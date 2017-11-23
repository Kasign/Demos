//
//  FlyNativeDownloadManager.h
//  DownLoadTool
//
//  Created by qiuShan on 2017/11/22.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyNativeDownloadManager : NSObject

+ (instancetype)sharedInstance;

- (void)startDownload;

@end
