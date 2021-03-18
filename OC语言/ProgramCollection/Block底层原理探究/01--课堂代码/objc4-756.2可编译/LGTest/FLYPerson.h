//
//  FLYPerson.h
//  LGTest
//
//  Created by Qiushan on 2020/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYPerson : NSObject

@property (nonatomic, weak)   id  delegate;
@property (nonatomic, copy)   NSString  *  name;
@property (nonatomic, copy)   void (^block)(NSString  * key);

@end

NS_ASSUME_NONNULL_END
