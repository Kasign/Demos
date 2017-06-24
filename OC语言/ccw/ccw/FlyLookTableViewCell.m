//
//  FlyLookTableViewCell.m
//  ccw
//
//  Created by walg on 2017/6/22.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyLookTableViewCell.h"

@implementation FlyLookTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageV= [[UIImageView alloc] initWithFrame:self.bounds];
        
        [self addSubview:_imageV];
    }
    return self;
}


@end
