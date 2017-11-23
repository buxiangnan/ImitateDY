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

//@property (nonatomic, strong) KSYMoviePlayerController *player;
@property (nonatomic, strong) PlayerScrollView *playerScrollView;

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
    [self.view setBackgroundColor:[UIColor clearColor]];
    //[self initVideoData];
    [self initUI];
    [self.navigationController setNavigationBarHidden:YES];
    [self initPlayer];
}

-(void) initUI{
    [self.playerScrollView updateForvideoItemArray:self.videoList withCurrentIndex:self.index];
    self.playerScrollView.playerDelegate = self;
    [self.view addSubview:self.playerScrollView];
}

- (void)pausePlay{
    if (self.playerScrollView.upPlayer.view.frame.origin.y == KScreenHeight) {
        [self.playerScrollView.upPlayer pause];
    }
    if (self.playerScrollView.middlePlayer.view.frame.origin.y == KScreenHeight) {
        [self.playerScrollView.middlePlayer pause];
    }
    if (self.playerScrollView.downPlayer.view.frame.origin.y == KScreenHeight) {
        [self.playerScrollView.downPlayer pause];
    }
}
- (void)startPlay{
    if (self.playerScrollView.upPlayer.view.frame.origin.y == KScreenHeight) {
        [self.playerScrollView.upPlayer play];
    }
    if (self.playerScrollView.middlePlayer.view.frame.origin.y == KScreenHeight) {
        [self.playerScrollView.middlePlayer play];
    }
    if (self.playerScrollView.downPlayer.view.frame.origin.y == KScreenHeight) {
        [self.playerScrollView.downPlayer play];
    }
}
//- (void)initVideoData{
//
//    NSMutableArray* videoArray = [NSMutableArray array];
//
//    NSArray* imageSourceArray = [NSArray arrayWithObjects:
//                                 @"http://ksy.fffffive.com/mda-hinp1ik37b0rt1mj/mda-hinp1ik37b0rt1mj.jpg",
//                                 @"http://ksy.fffffive.com/mda-himtqzs2un1u8x2v/mda-himtqzs2un1u8x2v.jpg",
//                                 @"http://ksy.fffffive.com/mda-hiw5zixc1ghpgrhn/mda-hiw5zixc1ghpgrhn.jpg",
//                                 @"http://ksy.fffffive.com/mda-hiw61ic7i4qkcvmx/mda-hiw61ic7i4qkcvmx.jpg",nil];
//
//    NSArray* videoSourceArray = [NSArray arrayWithObjects:
//                                 @"http://ksy.fffffive.com/mda-hinp1ik37b0rt1mj/mda-hinp1ik37b0rt1mj.mp4",
//                                 @"http://ksy.fffffive.com/mda-himtqzs2un1u8x2v/mda-himtqzs2un1u8x2v.mp4",
//                                 @"http://ksy.fffffive.com/mda-hiw5zixc1ghpgrhn/mda-hiw5zixc1ghpgrhn.mp4",
//                                 @"http://ksy.fffffive.com/mda-hiw61ic7i4qkcvmx/mda-hiw61ic7i4qkcvmx.mp4",nil];
//
//    for(int i = 0; i < videoSourceArray.count; i++){
//        VideoModel *model = [[VideoModel alloc] init];
//        model.videoURL = videoSourceArray[i];
//        model.coverImageURL = imageSourceArray[i];
//        [videoArray addObject:model];
//    }
//
//    self.videoList = videoArray;
//    self.videoItem = videoArray[0];
//    self.index = 0;//初始化为第一个
//}

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
