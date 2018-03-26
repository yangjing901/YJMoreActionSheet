//
//  YJMoreActionSheet.m
//  YJMoreActionSheet
//
//  Created by YangJing on 2018/3/26.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "YJMoreActionSheet.h"

#define YJMoreActionHeight  50
#define YJMoreActionWidth   153

@implementation YJMoreActionSheet {
    BOOL    _animating;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubViews];
    }
    return self;
}

//MARK: - private methods

- (void)addAction:(YJMoreAction *)action {
    [self addSubview:action];
    action.frame = CGRectMake(CGRectGetWidth(self.frame)-YJMoreActionWidth-15, 12+(YJMoreActionHeight+12)*self.actions.count, YJMoreActionWidth, YJMoreActionHeight);
    
    [action addTarget:self action:@selector(itemsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.actions addObject:action];
}

- (void)itemsAction:(YJMoreAction *)sender {
    if (sender.handler) sender.handler(sender);

    self.active = NO;
}

- (void)cancelAction:(UITapGestureRecognizer *)tap {
    self.active = NO;
}

- (void)show {
    _animating = YES;
    
    self.hidden = NO;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    semaphore = dispatch_semaphore_create(self.actions.count);
    
    for (NSInteger i = 0, count = self.actions.count; i < count; i++) {
        YJMoreAction *action = self.actions[i];
        
        action.frame = CGRectMake(CGRectGetWidth(self.frame), 12+(YJMoreActionHeight+12)*i, YJMoreActionWidth, YJMoreActionHeight);
        
        [UIView animateWithDuration:0.5 delay:i*0.15 usingSpringWithDamping:0.5 initialSpringVelocity:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            action.frame = CGRectMake(CGRectGetWidth(self.frame)-YJMoreActionWidth-15, 12+(YJMoreActionHeight+12)*i, YJMoreActionWidth, YJMoreActionHeight);

        } completion:^(BOOL finished) {
            dispatch_semaphore_signal(semaphore);
            
        }];
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    _animating = NO;

}

- (void)dismiss {
    _animating = YES;

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(self.actions.count);

    for (NSInteger i = self.actions.count-1; i >= 0; i--) {
        YJMoreAction *action = self.actions[i];
        
        action.frame = CGRectMake(CGRectGetWidth(self.frame)-YJMoreActionWidth-15, 12+(YJMoreActionHeight+12)*i, YJMoreActionWidth, YJMoreActionHeight);
        
        [UIView animateWithDuration:0.5 delay:(self.actions.count-1-i)*0.15 usingSpringWithDamping:0.5 initialSpringVelocity:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            action.frame = CGRectMake(CGRectGetWidth(self.frame), 12+(YJMoreActionHeight+12)*i, YJMoreActionWidth, YJMoreActionHeight);
            
        } completion:^(BOOL finished) {
            dispatch_semaphore_signal(semaphore);
            
        }];
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    semaphore = dispatch_semaphore_create(1);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        dispatch_semaphore_signal(semaphore);

    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    _animating = NO;

}

//MARK: - UI
- (void)configSubViews {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        view;
    });
    [self addSubview:backView];
    backView.frame = self.bounds;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)];
    [backView addGestureRecognizer:tapGesture];
    
    self.hidden = YES;
}

//MARK: - setter
- (void)setActive:(BOOL)active {
    if (_animating) return;
    
    _active = active;
    
    if (active) {
        [self show];
        
    } else {
        [self dismiss];
        
    }
}

//MARK: - getter
- (NSMutableArray<YJMoreAction *> *)actions {
    if (!_actions) {
        _actions = [[NSMutableArray alloc] init];
    }
    return _actions;
}

@end

@implementation YJMoreAction

+ (YJMoreAction *)actionWithTitle:(NSString *)title handler:(void(^)(YJMoreAction *action))handler {
    YJMoreAction *action = [YJMoreAction buttonWithType:UIButtonTypeCustom];
    action.handler = handler;
    [action setTitle:title forState:UIControlStateNormal];
    [action setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    action.titleLabel.font = [UIFont systemFontOfSize:14];

    action.backgroundColor = [UIColor whiteColor];
    action.layer.cornerRadius = 25;
    action.layer.shadowColor = [UIColor blackColor].CGColor;
    action.layer.shadowOffset = CGSizeMake(0, 2);
    action.layer.shadowRadius = 6;
    action.layer.shadowOpacity = 0.5;
    return action;
}

@end
