//
//  ViewController.m
//  YJMoreActionSheet
//
//  Created by YangJing on 2018/3/26.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "ViewController.h"
#import "YJMoreActionSheet.h"

@interface ViewController ()

@property (nonatomic, strong) YJMoreActionSheet *moreActionSheet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configSubview];
}

//MARK: - private methods
- (void)moreAction:(id)sender {
    self.moreActionSheet.active = !self.moreActionSheet.active;
}

- (void)clickAction:(YJMoreAction *)sender {
    NSLog(@"yangjing_%@: clickAction %@", NSStringFromClass([self class]), sender.titleLabel.text);
}

//MARK: - UI
- (void)configSubview {
    self.navigationItem.title = @"YJMoreActionSheet";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_more"] style:UIBarButtonItemStyleDone target:self action:@selector(moreAction:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.moreActionSheet];
    //添加动作
    __weak typeof(self) weakSelf = self;
    [weakSelf.moreActionSheet addAction:[YJMoreAction actionWithTitle:@"Action 1" handler:^(YJMoreAction *action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf clickAction:action];
        
    }]];
    
    [weakSelf.moreActionSheet addAction:[YJMoreAction actionWithTitle:@"Action 2" handler:^(YJMoreAction *action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf clickAction:action];

    }]];
    
    [weakSelf.moreActionSheet addAction:[YJMoreAction actionWithTitle:@"Action 3" handler:^(YJMoreAction *action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf clickAction:action];
        
    }]];
    
    [weakSelf.moreActionSheet addAction:[YJMoreAction actionWithTitle:@"Action 4" handler:^(YJMoreAction *action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf clickAction:action];
        
    }]];
}

//MARK: - getter
- (YJMoreActionSheet *)moreActionSheet {
    if (!_moreActionSheet) {
        _moreActionSheet = [[YJMoreActionSheet alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)-64)];
    }
    return _moreActionSheet;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
