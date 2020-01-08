//
//  LGTeacher.h
//  LGTest
//
//  Created by Cooci on 2019/10/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGTeacher : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) long height;
@property (nonatomic, strong) NSString *hobby;

//@property (nonatomic, assign) int sex;
//@property (nonatomic) char ch1;
//@property (nonatomic) char ch2;

@end

NS_ASSUME_NONNULL_END
