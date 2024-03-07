//
//  FlyEleventhController.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/26.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyEleventhController.h"

@interface FlyEleventhController ()

@end

@implementation FlyEleventhController

+ (NSString *)functionName {
    
    return @"沙盒";
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}
//现在的沙盒机制有待验证
/*
 
 一、AppName.app 应用程序的程序包目录，包含应用程序的本身。由于应用程序必须经过签名，所以不能在运行时对这个目录中的内容进行修改，否则会导致应用程序无法启动。

 Documents/ 保存应用程序的重要数据文件和用户数据文件等。用户数据基本上都放在这个位置(例如从网上下载的图片或音乐文件)，该文件夹在应用程序更新时会自动备份，在连接iTunes时也可以自动同步备份其中的数据。

 Library：这个目录下有两个子目录,可创建子文件夹。可以用来放置您希望被备份但不希望被用户看到的数据。该路径下的文件夹，除Caches以外，都会被iTunes备份.

 Library/Caches: 保存应用程序使用时产生的支持文件和缓存文件(保存应用程序再次启动过程中需要的信息)，还有日志文件最好也放在这个目录。iTunes 同步时不会备份该目录并且可能被其他工具清理掉其中的数据。
 Library/Preferences: 保存应用程序的偏好设置文件。NSUserDefaults类创建的数据和plist文件都放在这里。会被iTunes备份。

 tmp/: 保存应用运行时所需要的临时数据。不会被iTunes备份。iPhone重启时，会被清空。
 
 
 二、关于NSSearchPathForDirectoriesInDomains函数
 FOUNDATION_EXPORT NSArray<NSString *> *NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde); 用于查找目录，返回指定范围内的指定名称的目录的路径集合。有三个参数：

 NSSearchPathDirectory directory 想要查找的目录，是个枚举值，有很多值，有关于iOS的，有关于macOS，也有关于watchOS的。
 
 NSSearchPathDomainMask domainMask 表示“想要从哪个路径区域保护区查找”。
 typedef NS_OPTIONS(NSUInteger, NSSearchPathDomainMask) {
    NSUserDomainMask =1,      // 用户的主目录
    NSLocalDomainMask =2,     // 当前机器的本地目录
    NSNetworkDomainMask =4,    //在网络中公开可用的位置
    NSSystemDomainMask =8,    // 被苹果系统提供的，不可更改的位置 (/System)
    NSAllDomainsMask = 0x0ffff  // 上述所有及未来的位置
 };
 
 BOOL expandTilde 表示是否用波浪线显示部分目录路径。~在*nix系统表示当前用户的Home目录。列如上面获取cache目录路径如果使用NO，那么结果就是cachesDir=~/Library/Caches
 
 */


@end
