//
//  OnlineMusicPlayerManager.h
//  Unity-iPhone
//
//  Created by qiuShan on 2018/1/4.
//

#import <Foundation/Foundation.h>
@interface OnlineMusicPlayerManager : NSObject

- (void)playAudioUrlStr:(NSString *)urlStr;
- (void)stopPlay;
@end
