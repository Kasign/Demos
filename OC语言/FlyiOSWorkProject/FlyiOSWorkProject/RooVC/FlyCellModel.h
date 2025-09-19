//
//  FlyCellModel.h
//  ProgramCollection
//
//  Created by Walg on 2024/1/29.
//  Copyright © 2024 FLY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlyCellModel : NSObject

@property (nonatomic, copy) NSString *vcTitle;
@property (nonatomic, copy) NSString *cellTitle;
@property (nonatomic, strong) Class vcClass;

+ (instancetype)instanceWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
