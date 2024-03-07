//
//  FlyFourteenController.m
//  ProgramCollection
//
//  Created by Qiushan on 2020/12/1.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FlyFourteenController.h"

@interface FlyFourteenController ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) void (^kBlock)(CGFloat a);
@property (nonatomic, copy) void (^gBlock)(void);

@end

@implementation FlyFourteenController

+ (NSString *)functionName {
    
    return @"Block";
}

/**
 这里总结block对外界变量的捕获
 局部变量：
    block结构体直接持有
 静态变量：
    block结构体持有指向该变量的指针(&)
 全局变量：
    block结构体不持有该变量，在block内部imp内直接操作
 __block 修饰的变量
    block结构体持有指向该变量结构体的指针(&)，该结构体的forwarding指向堆copy的新结构体，改变值的时候，只改变堆内的新结构体的值
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testBasicBlock];
//    [self testBlockCopy];
}

- (void)testBasicBlock {
    
    /**
     打印日志：exampleBlock is: __NSMallocBlock__？？？
     不是说好的 __NSStackBlock__ 的吗？为什么打印的是__NSMallocBlock__ 呢？这里是因为我们使用了 ARC ，Xcode 默认帮我们做了很多事情。
     我们可以去 Build Settings 里面，找到 Objective-C Automatic Reference Counting ，并将其设置为 No ，然后再 Run 一次代码。你会看到打印日志是：exampleBlock is: __NSStackBlock__
     如果 block 访问了外部局部变量，此时的 block 就是一个栈 block ，并且存储在栈区。由于栈区的释放是由系统控制，因此栈中的代码在作用域结束之后内存就会销毁，如果此时再调用 block 就会发生问题，( 注： 此代码运行在 MRC 下)如：

     作者：MChen
     链接：https://juejin.cn/post/7070319552495648782
     来源：稀土掘金
     著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
     */
    
    // 未持有外部变量 or 持有全局变量 or 持有静态变量
    // <__NSGlobalBlock__: 0x10cbfe088>
    // 持有外部局部变量被copy之后
    // <__NSMallocBlock__: 0x600002cd8090>
    // 持有外部局部变量且被copy之前
    // <_NSStackBlock__: 0x7ffeeb763440>_
    
    static CGFloat c = 1;
    CGFloat a = 10;
    //__NSGlobalBlock__
    FLYClearLog(@"1 -> %@",^{
        NSLog(@"111");
    });
    
    
    //__NSStackBlock__
    FLYClearLog(@"2 -> %@",^{
        NSLog(@"222 - %f", a);
    });
    
    //__NSGlobalBlock__
    void (^block1)(void) = ^{
        FLYClearLog(@"333");
    };
//    block1();
    FLYClearLog(@"3 -> %@", block1);
    
    
    //__NSMallocBlock__
    void (^block2)(void) = ^{
        FLYClearLog(@"333 - %f", a);
    };
//    block2();
    FLYClearLog(@"4 -> %@", block2);
    
    
    //__NSMallocBlock__
    void (^block3)(CGFloat) = ^(CGFloat b){
        NSLog(@"%f %f", b, a);
    };
    self.kBlock = block3;
    FLYClearLog(@"6 -> %@", self.kBlock);
    
    //__NSGlobalBlock__
    void (^block4)(void) = ^{
        NSLog(@"---");
    };
    self.gBlock = block4;
    FLYClearLog(@"7 -> %@", self.gBlock);
    
    __weak __typeof(self) weakSelf = self;
    void (^block5)(void) = ^{
        NSLog(@"--- %@", weakSelf);
    };
    self.gBlock = block5;
    FLYClearLog(@"8 -> %@", self.gBlock);
}

- (void)testBlockCopy {
    
    _name = @"abcd";
    __block NSString * nameA = _name;
    __block CGFloat a = 20;
    __weak __typeof(self) weakSelf = self;
    void (^block3)(CGFloat) = ^(CGFloat b){
        NSLog(@"%f %f %@ %@", b, a, nameA, weakSelf.name);
        nameA = @"bdcdd";
        NSLog(@"%f %f %@", b, a, nameA);
    };
    self.kBlock = block3;
    self.kBlock(2);
}

- (void)testBlockArr {
    
    NSMutableArray * arr = [NSMutableArray array];
    void (^block)(void) = ^() {
        [arr addObject:@"abcd_2"];
    };
    block();
    NSLog(@"%@", arr);
}

@end
