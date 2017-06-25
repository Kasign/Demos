//
//  FlyJokeTableViewCell.h
//  ccw
//
//  Created by Walg on 2017/6/25.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlyJokeModel.h"
@interface FlyJokeTableViewCell : UITableViewCell
@property (nonatomic,strong)FlyJokeModel *model;
+(CGFloat)heightForCellWithContent:(NSString*)content;
@end
