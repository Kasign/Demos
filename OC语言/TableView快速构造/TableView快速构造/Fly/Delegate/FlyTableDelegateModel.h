//
//  FlyTableDelageteModel.h
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import <UIKit/UIKit.h>
#import "FlyResponderObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlyTableDelegateModel : FlyResponderObject <UITableViewDelegate>

// 可通过以下属性实现UITableViewDelegate其他代理方法
//@property (nonatomic, weak) id extentDelegate;

+ (instancetype)instanceWithId:(id)delegate;

@end

NS_ASSUME_NONNULL_END
