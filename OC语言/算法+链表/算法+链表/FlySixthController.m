//
//  FlySixthController.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/10.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlySixthController.h"
#import <sys/sysctl.h>

@interface FlySixthController ()

@end

@implementation FlySixthController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (isDebugger()) {
        FLYLog(@"123");
    }
//    [NSThread exit];//主线程可以退出，但是不影响子线程的运行
//
//    exit(0);//杀掉应用
}

BOOL isDebugger () {
    
    int name[4];
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    
    struct kinfo_proc info;
    size_t info_size = sizeof(info);
    
    int error = sysctl(name, sizeof(name)/sizeof(*name), &info, &info_size, 0, 0);
    assert(error == 0);
    
    return info.kp_proc.p_flag & P_TRACED;
}


@end
