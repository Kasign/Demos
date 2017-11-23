//
//  FlyOfflineTool.h
//  DownLoadTool
//
//  Created by qiuShan on 2017/11/23.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyOfflineTool : NSObject

+ (instancetype)sharedInstance;

- (void)startOfflineWithUrlStr:(NSString*)urlStr;

@end
