//
//  FlySecurityViewController.h
//  Security
//
//  Created by walg on 2017/5/25.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlyConfirmDelegate <NSObject>

-(void)confirmSuccess;
-(void)confirmFailed;

@end


@interface FlySecurityViewController : UIViewController

@property (nonatomic, weak) id<FlyConfirmDelegate> delegate;

@end
