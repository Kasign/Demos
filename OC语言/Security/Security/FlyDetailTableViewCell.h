//
//  FlyDetailTableViewCell.h
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyBasicTableViewCell.h"

@interface FlyDetailTableViewCell : FlyBasicTableViewCell

@property (nonatomic, strong) UITextField *leftField;
@property (nonatomic, strong) UITextField *rightField;

@property (nonatomic, strong) NSString *leftString;
@property (nonatomic, strong) NSString *rightString;
@end

@interface FlyDisPlayTableViewCell : FlyBasicTableViewCell
@property (nonatomic, strong) NSString *leftString;
@property (nonatomic, strong) NSString *rightString;
@end
