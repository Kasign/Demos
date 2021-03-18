//
//  LGHookBlock.h
//  005-HookBlock
//
//  Created by Cooci on 2019/7/3.
//  Copyright © 2019 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface LGHookInfo : NSObject
@property (nonatomic, weak) id _Nullable target;
@property (nonatomic, copy) NSString * _Nullable selector;
@property (nonatomic, strong) NSArray * _Nullable args;
@property (nonatomic, assign) id _Nonnull result;
@end

typedef void(^CallBack)(LGHookInfo * _Nullable info);
@interface LGHookBlock : NSObject
+ (void)hookBlock:(id)obj callBack:(CallBack)callBack;
@end

NS_ASSUME_NONNULL_END
