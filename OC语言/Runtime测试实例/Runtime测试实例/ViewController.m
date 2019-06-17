//
//  ViewController.m
//  Runtime测试实例
//
//  Created by mx-QS on 2019/4/3.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

#define FlyLog(FORMAT, ...) fprintf(stderr, "\n%s\n",[[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);

#define FlyScreenWidth  [UIScreen mainScreen].bounds.size.width
#define FlyScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createFuTextLayer];
    [self createLabel];
}

- (id)string
{
    UIFont *font = [UIFont systemFontOfSize:15];
    //choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum, diam odio congue lacus, vel fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet lobortis.";
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    //convert UIFont to a CTFont
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFloat fontSize     = font.pointSize;
    CTFontRef fontRef    = CTFontCreateWithName(fontName, fontSize, NULL);
    
    //set text attributes
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor cyanColor].CGColor,
                              (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                              };
    
    [attributedString setAttributes:attribs range:NSMakeRange(0, [text length])];
    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor blueColor].CGColor,
                (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
                (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                };
    [attributedString setAttributes:attribs range:NSMakeRange(6, 5)];
    CFRelease(fontRef);
    return attributedString;
}

- (void)createCATransformLayer
{
    CATransformLayer * transformLayer = [CATransformLayer layer];
    [transformLayer setFrame:CGRectMake(0, 100, 400, 200)];
    transformLayer.position = self.view.center;
    transformLayer.backgroundColor = [UIColor cyanColor].CGColor;
    [self.view.layer addSublayer:transformLayer];
}

- (void)createScrollLayer
{
    CAScrollLayer * scrollLayer = [CAScrollLayer layer];
    [scrollLayer setFrame:CGRectMake(0, 100, 400, 200)];
    scrollLayer.position = self.view.center;
    scrollLayer.backgroundColor = [UIColor cyanColor].CGColor;
    [self.view.layer addSublayer:scrollLayer];
}

- (void)createFuTextLayer
{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(0, 100, FlyScreenWidth, 150);
    textLayer.contentsScale   = [UIScreen mainScreen].scale;
    textLayer.backgroundColor = [UIColor grayColor].CGColor;
    textLayer.alignmentMode   = kCAAlignmentLeft;
    textLayer.wrapped         = YES;
    textLayer.string          = [self string];
    [self.view.layer addSublayer:textLayer];
}

- (void)createLabel
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, FlyScreenHeight - 250, FlyScreenWidth, 150)];
    label.attributedText  = [self string];
    label.textColor       = [UIColor cyanColor];
    label.backgroundColor = [UIColor grayColor];
    label.textAlignment   = NSTextAlignmentLeft;
    label.numberOfLines   = 0;
    [self.view addSubview:label];
}

- (void)createTextLayer
{
    CATextLayer * textLayer = [CATextLayer layer];
    [textLayer setFrame:CGRectMake(0, 100, FlyScreenWidth, 150)];
    textLayer.position        = self.view.center;
    textLayer.string          = [self string];
    textLayer.foregroundColor = [UIColor cyanColor].CGColor;
    textLayer.backgroundColor = [UIColor grayColor].CGColor;
    textLayer.truncationMode  = kCATruncationStart;
    textLayer.alignmentMode   = kCAAlignmentLeft;
    textLayer.contentsScale   = [UIScreen mainScreen].scale;
    textLayer.wrapped         = YES;
    [self.view.layer addSublayer:textLayer];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
//    [self createTextLayer];
    [self loopInstanceSuperClass:[UICollectionViewLayoutAttributes new]];
}

- (void)loopInstanceSuperClass:(id)instance
{
    Class cls = [instance class];
    id oriInstance = instance;
    while (![oriInstance isMemberOfClass:[NSObject class]] && !class_isMetaClass(cls)) {
        [self getClassMethods:instance class:cls];
        cls = [oriInstance superclass];
        oriInstance = [cls new];
    }
}

- (void)getClassMethods:(id)instance class:(Class)cls
{
    FlyLog(@"-------------------------********-------------------------");
    FlyLog(@"当前类名：%@",[instance class])
    NSMutableArray *methodArray = [NSMutableArray array];
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(cls, &methodCount);
    for (int i= 0; i<methodCount; i++) {
        Method method = methodList[i];
        SEL  methodSEL = method_getName(method);
        [methodArray addObject:NSStringFromSelector(methodSEL)];
    }
    free(methodList);
    FlyLog(@"实例方法：%@",methodArray);
    
    //类方法都是在元类方法列表里
    methodCount = 0;
    const char *clsName = class_getName(cls);
    Class metaClass = objc_getMetaClass(clsName);
    Method * metaMethodList = class_copyMethodList(metaClass, &methodCount);
    [methodArray removeAllObjects];
    for (int i = 0; i < methodCount ; i ++) {
        Method method = metaMethodList[i];
        SEL selector = method_getName(method);
        const char * methodCharName = sel_getName(selector);
        [methodArray addObject:NSStringFromSelector(selector)];
    }
    free(metaMethodList);
    FlyLog(@"类方法：%@",methodArray);
    
    
    //获取成员变量和属性
    NSMutableDictionary * nameTypeDict = [NSMutableDictionary dictionary];
    unsigned int ivarCount;
    Ivar * ivars = class_copyIvarList(cls, &ivarCount);
    for (int i = 0; i<ivarCount; i++) {
        Ivar ivar = ivars[i];
        const char * ivarCharName = ivar_getName(ivar);
        const char * ivarCharType = ivar_getTypeEncoding(ivar);
        
        NSString * ivarName = [NSString stringWithCString:ivarCharName encoding:NSUTF8StringEncoding];
        NSString * ivarType = [NSString stringWithCString:ivarCharType encoding:NSUTF8StringEncoding];
        id value = [instance valueForKey:ivarName];
        if (!value) {
            value = @"NULL";
        }
        [nameTypeDict setObject:value forKey:ivarName];
    }
    free(ivars);
    FlyLog(@"成员变量和属性:%@",nameTypeDict);
    
    //获取属性
    [nameTypeDict removeAllObjects];
    unsigned int outCount;
    objc_property_t * propertyList = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i<outCount; i++) {
        objc_property_t property = propertyList[i];
        const char * propertyChar = property_getName(property);
        const char * attributesChar = property_getAttributes(property);
        NSString * propertyName = [NSString stringWithCString:propertyChar encoding:NSUTF8StringEncoding];
        char * attributeValue = property_copyAttributeValue(property, attributesChar);
        NSString * attributesStr = @"";
        if (!attributesChar) {
            attributesStr = @"NULL";
        } else {
            attributesStr = [NSString stringWithCString:attributesChar encoding:NSUTF8StringEncoding];
        }
        id value = @"";
        value = [instance valueForKey:propertyName];
        if (!value) {
            value = @"NULL";
        }
        [nameTypeDict setObject:value forKey:propertyName];
    }
    free(propertyList);
    FlyLog(@"属性:%@",nameTypeDict);
    
    //获取协议列表
    NSMutableArray *protocoArray = [NSMutableArray array];
    unsigned int protocoCount = 0;
    __unsafe_unretained Protocol ** protocolList =  class_copyProtocolList(cls, &protocoCount);
    for (int i = 0; i<protocoCount; i++) {
        Protocol * protocol = protocolList[i];
        const char *protocolName =  protocol_getName(protocol);
        [protocoArray addObject:[NSString stringWithUTF8String:protocolName]];
    }
    FlyLog(@"协议列表：%@",protocoArray);
    FlyLog(@"-------------------------********-------------------------");
}


@end


@implementation NSObject (Forward)

- (id)valueForUndefinedKey:(NSString *)key {
    
    return @"NULL";
}

@end
