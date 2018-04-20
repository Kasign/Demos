//
//  FlyButton.h
//  单例测试
//
//  Created by Q on 2018/4/20.
//  Copyright © 2018 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlyButton : UIButton

@property (nonatomic, copy) void(^buttonBlock)(FlyButton  * sender);

@end
