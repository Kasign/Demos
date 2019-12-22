//
//  LGPerson.h
//  01-Runtime 初探
//
//  Created by cooci on 2018/11/27.
//  Copyright © 2018 cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGPerson : NSObject{
    NSString *hobby;
}

@property (nonatomic, copy) NSString *nickName;

- (void)sayHello;
+ (void)sayHappy;

@end

NS_ASSUME_NONNULL_END
