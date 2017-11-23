//
//  MainViewController.m
//  ImitateDY
//
//  Created by YangWei on 2017/11/22.
//  Copyright © 2017年 Apple-YangWei. All rights reserved.
//

#import "MainViewController.h"
#import "PlayerScrollView.h"
#import <KSYMediaPlayer/KSYMediaPlayer.h>

@interface MainViewController () <PlayerScrollViewDelegate>

@property (nonatomic , strong) KSYMoviePlayerController* player;
@property (nonatomic , strong) PlayerScrollView* playerScrollView;

@end

@implementation MainViewController

#pragma mark -- lazy loading
- (PlayerScrollView *)playerScrollView{
    if (!_playerScrollView) {
        _playerScrollView = [[PlayerScrollView alloc] initWithFrame:self.view.frame];
        _playerScrollView.playerDelegate = self;
        _playerScrollView.index = self.index;
    }
    return _playerScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initPlayer];
    
    //左划相机
    //UISwipeGestureRecognizer *swipeGesture = [UISwipeGestureRecognizer alloc] initWithTarget:self action:<#(nullable SEL)#>;
}

-(void) initUI{
    [self.playerScrollView updateForvideoItemArray:self.videoList withCurrentIndex:self.index];
    self.playerScrollView.playerDelegate = self;
    [self.view addSubview:self.playerScrollView];
}

-(void) initPlayer{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstVideoFrameRenderedNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerPreparedToPlayNotify:)
                                                name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                              object:nil];
}

//- (void)swipeCameraVC:(UISwipeGestureRecognizer *)sender{
//
//}

-(void)handlePlayerPreparedToPlayNotify:(NSNotification*)notify{
    
    KSYMoviePlayerController* cor = notify.object;
    switch (cor.view.tag) {
        case 101:
        {
            if (self.playerScrollView.upPlayer.view.frame.origin.y == KScreenHeight) {
                [self.playerScrollView.upPlayer play];
            }
        }
        break;
        case 102:
        {
            if (self.playerScrollView.middlePlayer.view.frame.origin.y == KScreenHeight) {
                [self.playerScrollView.middlePlayer play];
            }
        }
        break;
        case 103:
        {
            {
                if (self.playerScrollView.downPlayer.view.frame.origin.y == KScreenHeight) {
                    [self.playerScrollView.downPlayer play];
                }
            }
        }
        break;
        
        default:
        break;
    }
}

-(void)handlePlayerNotify:(NSNotification*)notify{
    KSYMoviePlayerController* cor = notify.object;
    switch (cor.view.tag) {
        case 101:
        {
            if (self.playerScrollView.upPlayer.view.frame.origin.y == KScreenHeight) {
                [self.playerScrollView.upPlayer.view setHidden:false];
            }
        }
        break;
        case 102:
        {
            if (self.playerScrollView.middlePlayer.view.frame.origin.y == KScreenHeight) {
                [self.playerScrollView.middlePlayer.view setHidden:false];
            }
        }
        break;
        case 103:
        {
            {
                if (self.playerScrollView.downPlayer.view.frame.origin.y == KScreenHeight) {
                    [self.playerScrollView.downPlayer.view setHidden:false];
                }
            }
        }
        break;
        
        default:
        break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.playerScrollView.middlePlayer play];
}

#pragma mark -- PlayerScrollViewDelegate
- (void)playerScrollView:(PlayerScrollView *)playerScrollView currentPlayerIndex:(NSInteger)index{
    
    if (self.index == index) {
        return;
    } else {
        if (playerScrollView.upPlayer.view.frame.origin.y == KScreenHeight) {
            [playerScrollView.upPlayer.view setHidden:true];
            if ([playerScrollView.upPlayer isPreparedToPlay]) {
                if (playerScrollView.upPlayer.currentPlaybackTime >  0.1) {
                    [playerScrollView.upPlayer.view setHidden:false];
                }
                [playerScrollView.upPlayer play];
            }
            
            [playerScrollView.middlePlayer pause];
            [playerScrollView.downPlayer pause];
            [playerScrollView.downPlayer.view setHidden:true];
            [playerScrollView.middlePlayer.view setHidden:true];
        }
        
        if (playerScrollView.middlePlayer.view.frame.origin.y == KScreenHeight) {
            [playerScrollView.middlePlayer.view setHidden:true];
            if ([playerScrollView.middlePlayer isPreparedToPlay]) {
                if (playerScrollView.middlePlayer.currentPlaybackTime >  0.1) {
                    [playerScrollView.middlePlayer.view setHidden:false];
                }
                [playerScrollView.middlePlayer play];
            }
            [playerScrollView.upPlayer pause];
            [playerScrollView.downPlayer pause];
            [playerScrollView.downPlayer.view setHidden:true];
            [playerScrollView.upPlayer.view setHidden:true];
        }
        
        if (playerScrollView.downPlayer.view.frame.origin.y == KScreenHeight) {
            [playerScrollView.downPlayer.view setHidden:true];
            if ([playerScrollView.downPlayer isPreparedToPlay]) {
                if (playerScrollView.downPlayer.currentPlaybackTime >  0.1) {
                    [playerScrollView.downPlayer.view setHidden:false];
                }
                [playerScrollView.downPlayer play];
            }
            [playerScrollView.upPlayer pause];
            [playerScrollView.middlePlayer pause];
            
            [playerScrollView.upPlayer.view setHidden:true];
            [playerScrollView.middlePlayer.view setHidden:true];
        }
        self.index = index;
    }
}
@end
