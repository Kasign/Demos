//
//  FlyModelObject.h
//  三方库合集
//
//  Created by mx-QS on 2019/8/1.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlyBaseModelObject : NSObject<NSCopying, NSMutableCopying>

@property (nonatomic, copy)   NSString       *   modelType;

@end

@interface FlyModelObject2 : FlyBaseModelObject<NSCopying, NSMutableCopying>

@property (nonatomic, copy)   void (^converBlock)(NSInteger  index);

@end

@interface FlyModelObject : FlyBaseModelObject<NSCopying, NSMutableCopying>

@property (nonatomic, strong) FlyModelObject2   *   detailModel;
@property (nonatomic, copy)   void (^converBlock)(NSInteger  index);

@end

NS_ASSUME_NONNULL_END
