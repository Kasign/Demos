//
//  FlyTableViewCell.m
//  TableView快速构造
//
//  Created by Walg on 2021/6/22.
//

#import "FlyTableViewCell.h"

@implementation FlyTableViewCell

- (void)initConfig {
    self.backgroundColor = [UIColor redColor];
}

- (void)updateDataWithModel:(id)model {
    
    NSLog(@"%@", model);
}

@end
