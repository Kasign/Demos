//
//  FlyCollectionViewObject.h
//  DiyCollectionView
//
//  Created by Fly. on 2018/11/29.
//  Copyright © 2018 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlyCollectionViewObject : NSObject

@property (nonatomic, copy) NSString    *   className;
@property (nonatomic, copy) NSString    *   identifier;
@property (nonatomic, assign) NSInteger       type;//0 1 2

+ (instancetype)initWithClass:(Class)className identifier:(NSString *)identifier type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
