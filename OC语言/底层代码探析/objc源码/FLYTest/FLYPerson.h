//
//  FLYPerson.h
//  FLYTest
//
//  Created by Walg on 2019/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYPerson : NSObject{
    NSString *hobby;
}

@property (nonatomic, copy) NSString *nickName;

- (void)sayHello;
+ (void)sayHappy;

@end

NS_ASSUME_NONNULL_END
