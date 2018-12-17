//
//  YJMoreActionSheet.h
//  YJMoreActionSheet
//
//  Created by YangJing on 2018/3/26.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJMoreAction;
@interface YJMoreActionSheet : UIView

@property (nonatomic, assign) BOOL active;

@property (nonatomic, strong, readonly) NSMutableArray <YJMoreAction *>*actions;

- (void)addAction:(YJMoreAction *)action;

@end

@interface YJMoreAction : UIButton

@property (nonatomic, strong) void (^handler) (YJMoreAction *action);

+ (YJMoreAction *)actionWithTitle:(NSString *)title handler:(void(^)(YJMoreAction *action))handler;

@end
