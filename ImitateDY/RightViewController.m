//
//  RightViewController.m
//  ImitateDY
//
//  Created by YangWei on 2017/11/23.
//  Copyright © 2017年 Apple-YangWei. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, (KScreenHeight - 60) / 2, KScreenWidth-30, 60)];
    label.text = @"滑动时暂停播放,向右拖动返回播放";
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor redColor];
    
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
