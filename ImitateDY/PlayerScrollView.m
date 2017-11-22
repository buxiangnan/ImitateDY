//
//  PlayerScrollView.m
//  ImitateDY
//
//  Created by YangWei on 2017/11/22.
//  Copyright © 2017年 Apple-YangWei. All rights reserved.
//

#import "PlayerScrollView.h"
#import "VideoModel.h"
#import "UIImageView+WebCache.h"

@interface PlayerScrollView( )<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *videoItemArray;
@property (nonatomic, strong) VideoModel *item;
@property (nonatomic, strong) UIImageView *upImageView, *middleImageView, *downImageView;
@property (nonatomic, strong) VideoModel *upItem, *middleItem, *downItem;
@property (nonatomic, assign) NSInteger currentIndex, previousIndex;
@end

@implementation PlayerScrollView

#pragma -- lazy load

- (NSMutableArray *)videoItemArray{
    if(!_videoItemArray){
        _videoItemArray = [NSMutableArray array];
    }
    return _videoItemArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.contentSize = CGSizeMake(0, frame.size.height * 3);
        self.contentOffset = CGPointMake(0, frame.size.height);
        self.pagingEnabled = YES;
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        self.delegate = self;
        
        self.upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, frame.size.height)];
        self.downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height*2, frame.size.width, frame.size.height)];
        
        [self addSubview:self.upImageView];
        [self addSubview:self.middleImageView];
        [self addSubview:self.downImageView];
        
        self.upPlayer = [[KSYMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:self.item.videoURL]];
        self.upPlayer.view.backgroundColor = [UIColor clearColor];
        self.upPlayer.view.tag = 101;
        [self.upPlayer setBufferSizeMax:1];
        self.upPlayer.view.autoresizesSubviews = true;
        [self.upPlayer.view setFrame: self.bounds];
        self.upPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.upPlayer.shouldAutoplay = true;
        self.upPlayer.shouldLoop = YES;
        self.upPlayer.scalingMode = MPMovieScalingModeAspectFit;
        self.upPlayer.view.frame = CGRectMake(0, KScreenHeight * 0, KScreenWidth, KScreenHeight);
        self.autoresizesSubviews = YES;
        [self addSubview:self.upPlayer.view];
        
        self.middlePlayer = [[KSYMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:self.item.videoURL]];
        self.middlePlayer.view.backgroundColor = [UIColor clearColor];
        self.middlePlayer.view.tag = 102;
        [self.middlePlayer setBufferSizeMax:1];
        self.middlePlayer.view.autoresizesSubviews = true;
        [self.middlePlayer.view setFrame: self.bounds];  // player's frame must match parent's
        self.middlePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.middlePlayer.shouldAutoplay = true;
        self.middlePlayer.shouldLoop = YES;
        self.middlePlayer.scalingMode = MPMovieScalingModeAspectFit;
        [self.middlePlayer prepareToPlay];
        self.middlePlayer.view.frame = CGRectMake(0, KScreenHeight * 1, KScreenWidth, KScreenHeight);
        self.autoresizesSubviews = YES;
        [self addSubview:self.middlePlayer.view];
        
        self.downPlayer = [[KSYMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:self.item.videoURL]];
        self.downPlayer.view.backgroundColor = [UIColor clearColor];
        self.downPlayer.view.tag = 103;
        [self.downPlayer setBufferSizeMax:1];
        self.downPlayer.view.autoresizesSubviews = true;
        [self.downPlayer.view setFrame: self.bounds];  // player's frame must match parent's
        self.downPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.downPlayer.shouldAutoplay = true;
        self.downPlayer.shouldLoop = YES;
        self.downPlayer.scalingMode = MPMovieScalingModeAspectFit;
        self.downPlayer.view.frame = CGRectMake(0, KScreenHeight * 2, KScreenWidth, KScreenHeight);
        self.autoresizesSubviews = YES;
        [self addSubview:self.downPlayer.view];
    }
    return self;
}


- (void)updateForvideoItemArray:(NSMutableArray *)videoItemArray withCurrentIndex:(NSInteger)index{
    
}

//预备载入内容
- (void) prepareForImageView: (UIImageView *)imageView withLive:(VideoModel *)model{
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.coverImageURL]];
}

- (void) prepareForVideo: (KSYMoviePlayerController *)player withLive:(VideoModel *)model{
    [player reset:false];
    [player setUrl:[NSURL URLWithString:model.videoURL]];
    [player setShouldAutoplay:false];
    [player setBufferSizeMax:1];
    [player setShouldLoop:YES];
    player.view.backgroundColor = [UIColor clearColor];
    [player prepareToPlay];
}


@end
