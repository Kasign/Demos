//
//  FlyTableViewCell.h
//  TableViewTest
//
//  Created by Walg on 2017/9/26.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlyTableViewCell : UITableViewCell
@property(nonatomic,copy) void(^deleBlock)(FlyTableViewCell*cell);
@end
