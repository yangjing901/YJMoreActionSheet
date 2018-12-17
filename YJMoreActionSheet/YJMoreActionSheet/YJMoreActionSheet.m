//
//  YJMoreActionSheet.m
//  YJMoreActionSheet
//
//  Created by YangJing on 2018/3/26.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "YJMoreActionSheet.h"

static const CGFloat YJMoreActionHeight = 50.0;
static const CGFloat YJMoreActionWidth = 153.0;

@interface YJMoreActionSheet()

@end

@implementation YJMoreActionSheet {
    BOOL    _isAnimating;
    
    NSMutableArray <YJMoreAction *>* _actionArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _actionArray = [[NSMutableArray alloc] init];
        
        [self configSubViews];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _actionArray = [[NSMutableArray alloc] init];
        
        [self configSubViews];
    }
    return self;
}

//MARK: - private methods
- (void)addAction:(YJMoreAction *)action {
    [self addSubview:action];
    action.frame = CGRectMake(CGRectGetWidth(self.bounds), 12+(YJMoreActionHeight+12)*_actionArray.count, YJMoreActionWidth, YJMoreActionHeight);
    
    [action addTarget:self action:@selector(itemsAction:) forControlEvents:UIControlEventTouchUpInside];
    [_actionArray addObject:action];
}

- (void)itemsAction:(YJMoreAction *)sender {
    if (sender.handler) sender.handler(sender);

    [self dismissWithAnimation:NO];
    _active = NO;
}

- (void)cancelAction:(UITapGestureRecognizer *)tap {
    self.active = NO;
}

- (void)showWithAnimation:(BOOL)animation {
    if (_isAnimating) {
        NSLog(@"yangjing_%@: 操作太频繁", NSStringFromClass([self class]));
        return;
    }
    
    self.hidden = NO;
    _isAnimating = YES;
    
    if (animation) {
        self.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1;
        }];
        
        for (NSInteger i = 0, count = _actionArray.count; i < count; i++) {
            YJMoreAction *action = _actionArray[i];
            
            action.frame = CGRectMake(CGRectGetWidth(self.bounds)+15, 12+(YJMoreActionHeight+12)*i, YJMoreActionWidth, YJMoreActionHeight);
            
            [UIView animateWithDuration:0.25 delay:0.25+i*0.15 options:UIViewAnimationOptionCurveLinear animations:^{
                
                action.frame = CGRectMake(CGRectGetWidth(self.bounds)-YJMoreActionWidth-15, 12+(YJMoreActionHeight+12)*i, YJMoreActionWidth, YJMoreActionHeight);
                
            } completion:^(BOOL finished) {
                if (i == count-1) _isAnimating = NO;
                
            }];
        }
        
    } else {
        self.alpha = 1;
        
        for (NSInteger i = 0, count = _actionArray.count; i < count; i++) {
            YJMoreAction *action = _actionArray[i];
            
            action.frame = CGRectMake(CGRectGetWidth(self.bounds)-YJMoreActionWidth-15, 12+(YJMoreActionHeight+12)*i, YJMoreActionWidth, YJMoreActionHeight);
            _isAnimating = NO;
        }
    }
    
}

- (void)dismissWithAnimation:(BOOL)animation {
    if (_isAnimating) {
        NSLog(@"yangjing_%@: 操作太频繁", NSStringFromClass([self class]));
        return;
    }
    
    _isAnimating = YES;
    
    if (animation) {
        for (NSInteger i = _actionArray.count-1; i >= 0; i--) {
            YJMoreAction *action = _actionArray[i];
            
            action.frame = CGRectMake(CGRectGetWidth(self.bounds)-YJMoreActionWidth-15, 12+(YJMoreActionHeight+12)*i, YJMoreActionWidth, YJMoreActionHeight);
            
            [UIView animateWithDuration:0.25 delay:0.25+i*0.15 options:UIViewAnimationOptionCurveEaseOut animations:^{
                action.frame = CGRectMake(CGRectGetWidth(self.bounds)+15, 12+(YJMoreActionHeight+12)*i, YJMoreActionWidth, YJMoreActionHeight);
                
            } completion:^(BOOL finished) {
                
            }];
        }
        
        [UIView animateWithDuration:0.5 delay:_actionArray.count*0.15+0.25 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 0;
            
        } completion:^(BOOL finished) {
            self.alpha = 1;
            self.hidden = YES;
            _isAnimating = NO;
            
        }];
    } else {
        for (NSInteger i = _actionArray.count-1; i >= 0; i--) {
            YJMoreAction *action = _actionArray[i];
            
            action.frame = CGRectMake(CGRectGetWidth(self.bounds)+15, 12+(YJMoreActionHeight+12)*i, YJMoreActionWidth, YJMoreActionHeight);
        }
        self.alpha = 1;
        self.hidden = YES;
        _isAnimating = NO;
    }

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
    if (_isAnimating) {
        NSLog(@"yangjing_%@: 操作太频繁", NSStringFromClass([self class]));
        return;
    }
    
    _active = active;
    
    if (active) {
        [self showWithAnimation:YES];
        
    } else {
        [self dismissWithAnimation:YES];
        
    }
}

//MARK: - getter
- (NSMutableArray<YJMoreAction *> *)actions {
    return _actionArray;
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
