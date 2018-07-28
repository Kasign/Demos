//
//  RRFPSBar.h
//
//  Created by Rolandas Razma on 07/03/2013.
//  Copyright 2013 Rolandas Razma. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface RRFPSBar : UIWindow
@property (nonatomic, readwrite) NSTimeInterval desiredChartUpdateInterval;

//default is no
@property (nonatomic, readwrite) BOOL showsAverage;

+ (RRFPSBar *)sharedInstance;

@end
