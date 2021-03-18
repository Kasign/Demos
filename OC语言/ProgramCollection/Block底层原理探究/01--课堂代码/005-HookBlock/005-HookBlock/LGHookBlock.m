//
//  LGHookBlock.m
//  005-HookBlock
//
//  Created by Cooci on 2019/7/3.
//  Copyright © 2019 Cooci. All rights reserved.
//


#import "LGHookBlock.h"
#import <objc/message.h>

#define LG_MethodHook(selector, func) {Method method = class_getInstanceMethod([NSObject class], selector); \
BOOL success = class_addMethod(cls, selector, (IMP)func, method_getTypeEncoding(method)); \
if (!success) { class_replaceMethod(cls, selector, (IMP)func, method_getTypeEncoding(method));}}

typedef NS_OPTIONS(int, LGBlockFlage) {
    LGBLOCK_HAS_COPY_DISPOSE =  (1 << 25),
    LGBLOCK_HAS_SIGNATURE  =    (1 << 30)
};

struct LGBlock_descriptor_1{
    uintptr_t reserved;
    uintptr_t size;
};

struct LGBlock_descriptor_2 {
    // requires BLOCK_HAS_COPY_DISPOSE
    void (*copy)(void *dst, const void *src);
    void (*dispose)(const void *);
};

struct LGBlock_descriptor_3 {
    // requires BLOCK_HAS_SIGNATURE
    const char *signature;
    const char *layout;
};

struct LGBlock_layout {
    void *isa;
    volatile int32_t flags;
    int32_t reserved;
    void (*invoke)(void *, ...);
    struct LGBlock_descriptor_1 *descriptor;
};
typedef  struct LGBlock_layout  *LGBlock;


@implementation LGHookBlock
+ (void)hookBlock:(id)obj callBack:(CallBack)callBack{
    lg_block_hook(obj);
}

//MARK: - hook 核心
static void lg_block_hook(id obj) {
    
    LGBlock block = (__bridge LGBlock)obj;
                     
    struct LGBlock_descriptor_1 *des1 = block->descriptor;
    des1->reserved = block->invoke;
    
    struct LGBlock_descriptor_3 *des3 = _lg_Block_descriptor_3(block);
    block->invoke = (void *)lg_getMsgForward(des3->signature);
}

//MARK: - lg_getMsgForward
static IMP lg_getMsgForward(const char *methodTypes) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    if (methodTypes[0] == '{') {
        NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:methodTypes];
        if ([methodSignature.debugDescription rangeOfString:@"is special struct return? YES"].location != NSNotFound) {
            msgForwardIMP = (IMP)_objc_msgForward_stret;
        }
    }
#endif
    return msgForwardIMP;
}

static void LG_NSBlock_hookOnces() {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"NSBlock");
        
#define LG_MethodHook(selector, func) {Method method = class_getInstanceMethod([NSObject class], selector); \
BOOL success = class_addMethod(cls, selector, (IMP)func, method_getTypeEncoding(method)); \
if (!success) { class_replaceMethod(cls, selector, (IMP)func, method_getTypeEncoding(method));}}
        
        LG_MethodHook(@selector(methodSignatureForSelector:), lg_BlockMethodSignatureForSelector);
        LG_MethodHook(@selector(forwardInvocation:), lg_BlockforwardInvocation);
    });
}

NSMethodSignature *lg_BlockMethodSignatureForSelector(id self, SEL _cmd, SEL aSelector) {

    struct LGBlock_descriptor_3 *des3 = _lg_Block_descriptor_3((__bridge void *)self);

    return [NSMethodSignature signatureWithObjCTypes:des3->signature];
}

static void lg_BlockforwardInvocation(id self, SEL _cmd, NSInvocation *invo) {
    
    LGBlock block = (__bridge void *)invo.target;
    struct LGBlock_descriptor_1 *des1 = block->descriptor;
    void (*KCBlock)(void *,...) = des1->reserved;
    KCBlock(block);
    
}

static struct LGBlock_descriptor_3 * _lg_Block_descriptor_3(LGBlock aBlock)
{
    if (! (aBlock->flags & LGBLOCK_HAS_SIGNATURE)) return nil;
    uint8_t *desc = (uint8_t *)aBlock->descriptor;
    desc += sizeof(struct LGBlock_descriptor_1);
    if (aBlock->flags & LGBLOCK_HAS_COPY_DISPOSE) {
        desc += sizeof(struct LGBlock_descriptor_2);
    }
    return (struct LGBlock_descriptor_3 *)desc;
}


//MARK: - hook 完毕的信息回调处理
static LGHookInfo *_lg_getCallback(NSInvocation *invocation) {
    LGHookInfo *callBack = [[LGHookInfo alloc] init];
    callBack.target = invocation.target;
    
    if ([callBack.target isKindOfClass:NSClassFromString(@"NSBlock")]) {
        callBack.args = _lg_getArguments(invocation,1);
    }
    
    callBack.result = _lg_getReturnValue(invocation);
    return callBack;
}

//MARK: - 参数处理
static NSArray *_lg_getArguments(NSInvocation *invocation, NSInteger beginIndex) {
    
    NSMutableArray *args = [NSMutableArray new];
    for (NSInteger i = beginIndex; i < [invocation.methodSignature numberOfArguments]; i ++) {
        const char *argType = [invocation.methodSignature getArgumentTypeAtIndex:i];
        id argBox;
        
#define IIFish_GetArgumentValueInBox(coding, type) case coding : {\
type arg;\
[invocation getArgument:&arg atIndex:i];\
argBox = @(arg);\
} break;
        
        switch (argType[0]) {
                IIFish_GetArgumentValueInBox('c', char)
                IIFish_GetArgumentValueInBox('i', int)
                IIFish_GetArgumentValueInBox('s', short)
                IIFish_GetArgumentValueInBox('l', long)
                IIFish_GetArgumentValueInBox('q', long long)
                IIFish_GetArgumentValueInBox('^', long long)
                IIFish_GetArgumentValueInBox('C', unsigned char)
                IIFish_GetArgumentValueInBox('I', unsigned int)
                IIFish_GetArgumentValueInBox('S', unsigned short)
                IIFish_GetArgumentValueInBox('L', unsigned long)
                IIFish_GetArgumentValueInBox('Q', unsigned long long)
                IIFish_GetArgumentValueInBox('f', float)
                IIFish_GetArgumentValueInBox('d', double)
                IIFish_GetArgumentValueInBox('B', BOOL)
            case '*': {
                char *arg;
                [invocation getArgument:&arg atIndex:i];
                argBox = [[NSString alloc] initWithUTF8String:arg];
            } break;
            case '@': {
                __autoreleasing id arg;
                [invocation getArgument:&arg atIndex:i];
                __weak id weakArg = arg;
                argBox = ^(){return weakArg;};
            } break;
            case '#': {
                Class arg;
                [invocation getArgument:&arg atIndex:i];
                argBox = NSStringFromClass(arg);
            } break;
            case ':': {
                SEL arg;
                [invocation getArgument:&arg atIndex:i];
                argBox = NSStringFromSelector(arg);
            } break;
            case '{': {
                NSUInteger valueSize = 0;
                NSGetSizeAndAlignment(argType, &valueSize, NULL);
                unsigned char arg[valueSize];
                [invocation getArgument:&arg atIndex:i];
                argBox = [NSValue value:arg withObjCType:argType];
            } break;
            default: {
                void *arg;
                [invocation getArgument:&arg atIndex:i];
                argBox = (__bridge id)arg;
            }
        }
        if (argBox) {
            [args addObject:argBox];
        }
    }
    
    return args;
}

//MARK: - 返回值处理
static id _lg_getReturnValue(NSInvocation *invocation) {
    const char *argType = [invocation.methodSignature methodReturnType];
    id argBox;
    
#define IIFish_GetReturnValueInBox(coding, type) case coding : {\
type arg;\
[invocation getReturnValue:&arg];\
argBox = @(arg);\
} break;
    
    switch (argType[0]) {
            IIFish_GetReturnValueInBox('c', char)
            IIFish_GetReturnValueInBox('i', int)
            IIFish_GetReturnValueInBox('s', short)
            IIFish_GetReturnValueInBox('l', long)
            IIFish_GetReturnValueInBox('q', long long)
            IIFish_GetReturnValueInBox('^', long long)
            IIFish_GetReturnValueInBox('C', unsigned char)
            IIFish_GetReturnValueInBox('I', unsigned int)
            IIFish_GetReturnValueInBox('S', unsigned short)
            IIFish_GetReturnValueInBox('L', unsigned long)
            IIFish_GetReturnValueInBox('Q', unsigned long long)
            IIFish_GetReturnValueInBox('f', float)
            IIFish_GetReturnValueInBox('d', double)
            IIFish_GetReturnValueInBox('B', BOOL)
        case '*': {
            char *arg;
            [invocation getReturnValue:&arg];
            argBox = [[NSString alloc] initWithUTF8String:arg];
        } break;
        case '@': {
            __autoreleasing id arg;
            [invocation getReturnValue:&arg];
            __weak id weakArg = arg;
            argBox = ^(){return weakArg;};
        } break;
        case '#': {
            Class arg;
            [invocation getReturnValue:&arg];
            argBox = NSStringFromClass(arg);
        } break;
        case ':': {
            SEL arg;
            [invocation getReturnValue:&arg];
            argBox = NSStringFromSelector(arg);
        } break;
        case '{': {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(argType, &valueSize, NULL);
            unsigned char arg[valueSize];
            [invocation getReturnValue:&arg];
            argBox = [NSValue value:arg withObjCType:argType];
        } break;
        case 'v':
            break;
        default: {
            void *arg;
            [invocation getReturnValue:&arg];
            argBox = (__bridge id)arg;
        }
    }
    
    return argBox;
}

@end



