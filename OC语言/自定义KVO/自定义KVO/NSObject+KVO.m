//
//  NSObject+KVO.m
//  自定义KVO
//
//  Created by qiuShan on 2017/12/28.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>

@implementation NSObject (KVO)

/** 根据getter方法名获得对应的setter方法名 */
static NSString * setterForGetter(NSString *getter)
{
    if (getter.length <= 0) {
        return nil;
    }
    
    // upper case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    // add 'set' at the begining and ':' at the end
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    
    return setter;
}

/** 根据setter方法名获得对应的getter方法名 */
static NSString * getterForSetter(NSString *setter)
{
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    // remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    
    // lower case the first letter
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    return key;
}

- (Class)makeKvoClassWithOriginalClassName:(NSString *)originalClazzName
{
    // 生成kPGKVOClassPrefix_class的类名
    NSString *kvoClazzName = [kFYKVOClassPrefix stringByAppendingString:originalClazzName];
    Class clazz = NSClassFromString(kvoClazzName);
    
    // 如果kvo class已经被注册过了, 则直接返回
    if (clazz) {
        return clazz;
    }
    
    /*
     *  如果kvo class不存在, 则创建这个类
     *  class doesn't exist yet, make it
     */
    Class originalClazz = object_getClass(self);
    Class kvoClazz = objc_allocateClassPair(originalClazz, kvoClazzName.UTF8String, 0);
    
    /*
     *  修改kvo class方法的实现, 学习Apple的做法, 隐瞒这个kvo_class
     *  grab class method's signature so we can borrow it
     */
    Method clazzMethod = class_getInstanceMethod(originalClazz, @selector(class));
    const char *types = method_getTypeEncoding(clazzMethod);
    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);
    
    // 注册kvo_class
    objc_registerClassPair(kvoClazz);
    
    return kvoClazz;
}

static Class kvo_class(id self, SEL _cmd)
{
    return class_getSuperclass(object_getClass(self));
}


#pragma mark - Overridden Methods
/** 重写setter方法, 新方法在调用原方法后, 通知每个观察者(调用传入的block) */
static void kvo_setter(id self, SEL _cmd, id newValue)
{
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    
    // 如果不存在getter方法
    if (!getterName)
    {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    // 获取旧值
    id oldValue = [self valueForKey:getterName];
    
    // 调用原类的setter方法
    struct objc_super superclazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    /*
     *   这里需要做个类型强转, 否则会报too many argument的错误
     *   cast our pointer so the compiler won't complain
     */
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    /*
     *   call super's setter, which is original class's setter method
     */
    objc_msgSendSuperCasted(&superclazz, _cmd, newValue);
    
    /*
     *  找出观察者的数组, 调用对应对象的callback
     *  look up observers and call the blocks
     */
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kPGKVOAssociatedObservers));
    // 遍历数组
    for (PGObservationInfo *each in observers)
    {
        if ([each.key isEqualToString:getterName])
        {
            // gcd异步调用callback
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                each.block(self, getterName, oldValue, newValue);
            });
        }
    }
}

/** 添加观察者 */
- (void)FY_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(FYObservingBlock)block
{
    /*
     一、 检查对象的类有没有相应的setter方法，如果没有抛出异常
     
     具体细节：
     1.1)、先通过 setterForGetter() 方法获得相应的 setter 的名字（SEL）。
     1.2)、把key的首字母大写； 前面加上set； key就变成了setKey。
     1.3)、再用class_getInstanceMethod去获得setKey:的实现（Method），如果没有，自然要抛出异常
     */
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod)
    {
        NSString *reason = [NSString stringWithFormat:
                            @"Object %@ does not have a setter for key %@", self, key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    /*
     二、检查对象isa指向的类是不是一个KVO类。如果不是，新建一个继承原来类的子类，并把isa指向这个新建的子类
     */
    
    Class clazz = object_getClass(self);
    NSString *clazzName = NSStringFromClass(clazz);
    
    // 2.1)、先看类名有没有我们定义的前缀。如果没有，我们就去创建新的子类
    if (![clazzName hasPrefix:kFYKVOClassPrefix])
    {
        clazz = [self makeKvoClassWithOriginalClassName:clazzName];
        object_setClass(self, clazz);
    }
    // 2.2)、到这里为止, object的类已不是原类了, 而是KVO新建的类
    // 2.3)、例如官方的API: Person -> NSKVONotifying_Person()
    // 2.4)、kPGKVOClassPrefix是自己定义的一个宏，便于区分系统
    
    
    /*
     三、重写setter方法。新的setter在调用原setter方法后，通知每个观察者（调用之前传入的block）
     */
    if (![self hasSelector:setterSelector])
    {
        const char *types = method_getTypeEncoding(setterMethod);
        class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
    }
    
    /*
     四、把这个观察的相关信息存在associatedObject里。
     
     具体相关：
     观察的相关信息（观察者，被观察的 key, 和传入的 block ）封装在 PGObservationInfo 类里。
     */
    PGObservationInfo * info = [[PGObservationInfo alloc] initWithObserver:observer Key:key block:block];
    NSMutableArray * observers = objc_getAssociatedObject(self, (__bridge const void *)(kFYKVOAssociatedObservers));
    if (!observers)
    {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(kFYKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject:info];
}

/** 移除观察者 */
- (void)FY_removeObserver:(NSObject *)observer
                   forKey:(NSString *)key
{
    
    NSMutableArray * observers = objc_getAssociatedObject(self, (__bridge const void *)(kFYKVOAssociatedObservers));
    PGObservationInfo * infoToRemove;
    for (PGObservationInfo * info in observers)
    {
        if (info.observer == observer && [info.key isEqual:key])
        {
            infoToRemove = info;
            break;
        }
    }
    [observers removeObject:infoToRemove];
    
}

@end
