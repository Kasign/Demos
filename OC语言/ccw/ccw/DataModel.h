//
//  DataModel.h
//  ccw
//
//  Created by Walg on 2017/5/7.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,strong)NSNumber *type;
@property (nonatomic,copy)NSString *urlString;
@end
