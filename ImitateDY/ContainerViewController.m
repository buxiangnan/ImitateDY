//
//  ContainerViewController.m
//  ImitateDY
//
//  Created by YangWei on 2017/11/23.
//  Copyright © 2017年 Apple-YangWei. All rights reserved.
//

#import "ContainerViewController.h"
#import "MainViewController.h"
#import "RightViewController.h"
#import "AppDelegate.h"

static NSTimeInterval _animateDuration = 0.3;
static CGFloat _sideWidth = 47;

@interface ContainerViewController ()<UIImagePickerControllerDelegate>{
    UINavigationController *_navMain;
    RightViewController *_rightVC;
    MainViewController *_mainVC;
}
@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:YES];
    RightViewController *rightVC = [[RightViewController alloc] init];
    [self.view addSubview:rightVC.view];
    
    [self addChildViewController:rightVC];
    [rightVC didMoveToParentViewController:self];
    _rightVC = rightVC;
    
    //获取AppDelegate中的MainVC
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _mainVC = app.mainVC;
    
    UINavigationController *navMain = [[UINavigationController alloc] initWithRootViewController:_mainVC];
    [self.view addSubview:navMain.view];
    [self addChildViewController:navMain];
    [_navMain setNavigationBarHidden:YES];
    [_navMain didMoveToParentViewController:self];
    _navMain = navMain;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]init];
    [panGesture addTarget:self action:@selector(pan:)];
    [_navMain.view addGestureRecognizer:panGesture];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer{
    [_mainVC pausePlay];
    CGFloat x = [recognizer translationInView:_navMain.view].x;
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    CGFloat scrollWidth = _navMain.view.frame.size.width;
    CGFloat ratio = (_navMain.view.frame.size.width / 2 - _sideWidth) / scrollWidth;
    
    if (x < 0){
        if (_navMain.view.frame.origin.x > -scrollWidth){
            [self changViewX:x withRatio:ratio];
        }
    }else {
        if (_navMain.view.frame.origin.x < 0){
            [self changViewX:x withRatio:ratio];
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded){
        if (fabs(_navMain.view.frame.origin.x) >= _navMain.view.frame.size.width / 2 ){
            [self showCameratViewController];
        }else{
            [self hideCameratViewController];
        }
    }
}

- (void)changViewX:(CGFloat)x withRatio:(CGFloat)ratio{
    _navMain.view.frame = CGRectMake(x + _navMain.view.frame.origin.x,
                                     _navMain.view.frame.origin.y,
                                     _navMain.view.frame.size.width,
                                     _navMain.view.frame.size.height);
    _rightVC.view.frame = CGRectMake(self.view.center.x + _navMain.view.frame.origin.x * ratio,
                                                 _rightVC.view.frame.origin.y,
                                                 _rightVC.view.frame.size.width,
                                                 _rightVC.view.frame.size.height);
}

- (void) showCameratViewController{
    [_mainVC pausePlay];
    [UIView animateWithDuration:_animateDuration animations:^{
        _navMain.view.frame = CGRectMake(-(_navMain.view.frame.size.width - _sideWidth),
                                         _navMain.view.frame.origin.y,
                                         _navMain.view.frame.size.width,
                                         _navMain.view.frame.size.height);
        _rightVC.view.frame = CGRectMake(_sideWidth,
                                                     _rightVC.view.frame.origin.y,
                                                     _rightVC.view.frame.size.width,
                                                     _rightVC.view.frame.size.height);
    }];
}

- (void) hideCameratViewController{
    [_mainVC startPlay];
    [UIView animateWithDuration:_animateDuration animations:^{
        _navMain.view.frame = CGRectMake(0,
                                         _navMain.view.frame.origin.y,
                                         _navMain.view.frame.size.width,
                                         _navMain.view.frame.size.height);
        _rightVC.view.frame = CGRectMake(self.view.center.x,
                                                     _rightVC.view.frame.origin.y,
                                                     _rightVC.view.frame.size.width,
                                                     _rightVC.view.frame.size.height);
    }];
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
