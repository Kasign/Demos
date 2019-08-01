//
//  Student.h
//  AOP切面编程
//
//  Created by mx-QS on 2019/7/15.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject

-(void)study:(NSString *)subject andRead:(NSString *)bookName;
-(void)study:(NSString *)subject :(NSString *)bookName;

@end

NS_ASSUME_NONNULL_END
