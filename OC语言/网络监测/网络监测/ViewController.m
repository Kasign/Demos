//
//  ViewController.m
//  网络监测
//
//  Created by Q on 2018/4/9.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

@interface ViewController ()
@property (readonly, nonatomic, assign) SCNetworkReachabilityRef networkReachability;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self afNetReachability];
    [self scNetReachability];
}

static const void * AFNetworkReachabilityRetainCallback(const void *info) {
    return Block_copy(info);
}

static void AFNetworkReachabilityReleaseCallback(const void *info) {
    if (info) {
        Block_release(info);
    }
}

static void AFNetworkReachabilityCallback(SCNetworkReachabilityRef __unused target, SCNetworkReachabilityFlags flags, void *info) {
    //    AFPostReachabilityStatusChange(flags, (__bridge AFNetworkReachabilityStatusBlock)info);
    NSLog(@" >>>>> %u  %@ <<<<< ",flags,info);
}

- (void)scNetReachability
{
    
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    struct sockaddr_in6 address;
    bzero(&address, sizeof(address));
    address.sin6_len = sizeof(address);
    address.sin6_family = AF_INET6;
#else
    struct sockaddr_in address;
    bzero(&address, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
#endif
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&address);
    
    _networkReachability = reachability;
    
    void(^callBack)(NSInteger type) = ^(NSInteger type){
        NSLog(@"  ****:%ld",type);
    };
    
    SCNetworkReachabilityContext context = {0, (__bridge void *)callBack, AFNetworkReachabilityRetainCallback, AFNetworkReachabilityReleaseCallback, NULL};
    SCNetworkReachabilitySetCallback(self.networkReachability, AFNetworkReachabilityCallback, &context);
    SCNetworkReachabilityScheduleWithRunLoop(self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(self.networkReachability, &flags)) {
            NSLog(@" ----***%u",flags);
        }
    });
}

- (void)afNetReachability
{
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld",status);
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"Unknown");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"NotReachable");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"WWAN");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                break;
                
            default:
                break;
        }
    }];
    [manager startMonitoring];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
