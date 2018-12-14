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
    BOOL    _animating;
    
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
    action.frame = CGRectMake(CGRectGetWidth(self.bounds)-YJMoreActionWidth-15, 12+(YJMoreActionHeight+12)*_actionArray.count, YJMoreActionWidth, YJMoreActionHeight);
    
    [action addTarget:self action:@selector(itemsAction:) forControlEvents:UIControlEventTouchUpInside];
    [_actionArray addObject:action];
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
//    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    alphaAnimation.duration = 0.25;
//    alphaAnimation.fromValue = @0;
//    alphaAnimation.toValue = @1;
//    alphaAnimation.fillMode = kCAFillModeForwards;
//    [self.layer addAnimation:alphaAnimation forKey:@"alphaAnimation"];
    
    for (NSInteger i = 0, count = _actionArray.count; i < count; i++) {
        YJMoreAction *action = _actionArray[i];
        
        CASpringAnimation *positionAnimation = [CASpringAnimation animationWithKeyPath:@"position.x"];
        positionAnimation.duration = 0.5;
        positionAnimation.beginTime = CACurrentMediaTime() + i*0.15;
        positionAnimation.fromValue = [NSNumber numberWithFloat:CGRectGetWidth(self.bounds)];
        positionAnimation.toValue = [NSNumber numberWithFloat:CGRectGetWidth(self.bounds)-YJMoreActionWidth-15];
        positionAnimation.damping = 1;
        positionAnimation.initialVelocity = 5;
        positionAnimation.mass = 1;
        positionAnimation.stiffness = 10;
        positionAnimation.fillMode = kCAFillModeForwards;
        [action.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
    }
    _animating = NO;

}

- (void)dismiss {
    _animating = YES;

    for (NSInteger i = _actionArray.count-1; i >= 0; i--) {
        YJMoreAction *action = _actionArray[i];
        
        CASpringAnimation *positionAnimation = [CASpringAnimation animationWithKeyPath:@"position.x"];
        positionAnimation.duration = 0.5;
        positionAnimation.beginTime = CACurrentMediaTime() + i*0.15;
        positionAnimation.toValue = [NSNumber numberWithFloat:CGRectGetWidth(self.bounds)];
        positionAnimation.fromValue = [NSNumber numberWithFloat:CGRectGetWidth(self.bounds)-YJMoreActionWidth-15];
        positionAnimation.damping = 5;
        positionAnimation.initialVelocity = 0.25;
        positionAnimation.fillMode = kCAFillModeForwards;
        [action.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
    }
    
//    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    alphaAnimation.duration = CACurrentMediaTime() + _actionArray.count*0.15;
//    alphaAnimation.toValue = @0;
//    alphaAnimation.fromValue = @1;
//    alphaAnimation.fillMode = kCAFillModeForwards;
//    [self.layer addAnimation:alphaAnimation forKey:@"alphaAnimation"];
    self.hidden = YES;

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
