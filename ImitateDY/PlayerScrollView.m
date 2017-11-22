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

#pragma mark -- lazy load

- (NSMutableArray *)videoItemArray{
    if(!_videoItemArray){
        _videoItemArray = [NSMutableArray array];
    }
    return _videoItemArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //set scrollView
        self.contentSize = CGSizeMake(0, frame.size.height * 3);
        self.contentOffset = CGPointMake(0, frame.size.height);
        self.pagingEnabled = YES;
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.delegate = self;
        
        //上下滑动时的图片预览
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

- (void)updateForvideoItemArray:(NSMutableArray *)itemArray withCurrentIndex:(NSInteger)index{
    if(itemArray.count && [itemArray firstObject]){
        [self.videoItemArray removeAllObjects];
        [self.videoItemArray addObjectsFromArray:itemArray];
        self.currentIndex = index;
        self.previousIndex = index;
        
        _upItem = [[VideoModel alloc] init];
        _middleItem = (VideoModel *)_videoItemArray[_currentIndex];
        _downItem = [[VideoModel alloc] init];
        
        if (_currentIndex == 0) {
            _upItem = (VideoModel *)[_videoItemArray lastObject];
        } else {
            _upItem = (VideoModel *)_videoItemArray[_currentIndex - 1];
        }
        if (_currentIndex == itemArray.count - 1) {
            _downItem = (VideoModel *)[_videoItemArray firstObject];
        } else {
            _downItem = (VideoModel *)_videoItemArray[_currentIndex + 1];
        }
        
        //load image
        [self prepareForImageView:self.upImageView withLive:_upItem];
        [self prepareForImageView:self.middleImageView withLive:_middleItem];
        [self prepareForImageView:self.downImageView withLive:_downItem];
        
        //load video
        [self prepareForVideo:self.upPlayer withLive:_upItem];
        [self prepareForVideo:self.middlePlayer withLive:_middleItem];
        [self prepareForVideo:self.downPlayer withLive:_downItem];
    }
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

#pragma mark -- 播放器切换

//3个播放器实例切换
- (void)switchPlayer:(UIScrollView*)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    if (self.videoItemArray.count) {
        if (offset >= 2 * self.frame.size.height){
            // slides to the down player
            scrollView.contentOffset = CGPointMake(0, self.frame.size.height);
            _currentIndex++;
            self.upImageView.image = self.middleImageView.image;
            self.middleImageView.image = self.downImageView.image;
            
            if (self.upPlayer.view.frame.origin.y == 0) {//移动到最下面
                self.upPlayer.view.frame = CGRectMake(0, KScreenHeight * 2, KScreenWidth, KScreenHeight);
            }else{//位置向上移动一个屏幕的高度
                self.upPlayer.view.frame = CGRectMake(0, self.upPlayer.view.frame.origin.y - KScreenHeight, KScreenWidth, KScreenHeight);
            }
            
            if (self.middlePlayer.view.frame.origin.y == 0) {//移动到最下面
                self.middlePlayer.view.frame = CGRectMake(0, KScreenHeight * 2, KScreenWidth, KScreenHeight);
            }else{//位置向上移动一个屏幕的高度
                self.middlePlayer.view.frame = CGRectMake(0, self.middlePlayer.view.frame.origin.y - KScreenHeight, KScreenWidth, KScreenHeight);
            }
            
            if (_currentIndex == self.videoItemArray.count - 1){
                _downItem = [self.videoItemArray firstObject];
            } else if(_currentIndex == self.videoItemArray.count){
                _downItem = self.videoItemArray[1];
                _currentIndex = 0;
            } else{
                _downItem = self.videoItemArray[_currentIndex+1];
            }
            
            [self prepareForImageView:self.downImageView withLive:_downItem];
            
            if (self.downPlayer.view.frame.origin.y == 0) {//移动到最下面
                self.downPlayer.view.frame = CGRectMake(0, KScreenHeight * 2, KScreenWidth, KScreenHeight);
            }else{//位置向上移动一个屏幕的高度
                self.downPlayer.view.frame = CGRectMake(0, self.downPlayer.view.frame.origin.y - KScreenHeight, KScreenWidth, KScreenHeight);
            }
            
            if (self.upPlayer.view.frame.origin.y == KScreenHeight * 2) {
                [self prepareForVideo:self.upPlayer withLive:_downItem];
            }
            if (self.middlePlayer.view.frame.origin.y == KScreenHeight * 2) {
                [self prepareForVideo:self.middlePlayer withLive:_downItem];
            }
            if (self.downPlayer.view.frame.origin.y == KScreenHeight * 2) {
                [self prepareForVideo:self.downPlayer withLive:_downItem];
            }
            
            if (_previousIndex == _currentIndex) {
                return;
            }
            
            if ([self.playerDelegate respondsToSelector:@selector(playerScrollView:currentPlayerIndex:)]) {
                [self.playerDelegate playerScrollView:self currentPlayerIndex:_currentIndex];
                _previousIndex = _currentIndex;
                YWLog(@"当前scrollView的index: %ld",_currentIndex);
            }
        }else if (offset <= 0){
            
            scrollView.contentOffset = CGPointMake(0, self.frame.size.height);
            _currentIndex--;
            self.downImageView.image = self.middleImageView.image;
            
            if (self.downPlayer.view.frame.origin.y == 2 * KScreenHeight) {
                self.downPlayer.view.frame = CGRectMake(0, KScreenHeight * 0, KScreenWidth, KScreenHeight);
            }else{
                self.downPlayer.view.frame = CGRectMake(0, self.downPlayer.view.frame.origin.y + KScreenHeight, KScreenWidth, KScreenHeight);
            }
            
            self.middleImageView.image = self.upImageView.image;
            
            if (self.middlePlayer.view.frame.origin.y == 2 * KScreenHeight) {
                self.middlePlayer.view.frame = CGRectMake(0, KScreenHeight * 0, KScreenWidth, KScreenHeight);
            }else{
                self.middlePlayer.view.frame = CGRectMake(0, self.middlePlayer.view.frame.origin.y + KScreenHeight, KScreenWidth, KScreenHeight);
            }

            if (_currentIndex == 0){
                _upItem = [self.videoItemArray lastObject];
                
            } else if (_currentIndex == -1){
                _upItem = self.videoItemArray[self.videoItemArray.count - 2];
                _currentIndex = self.videoItemArray.count-1;
            } else{
                _upItem = self.videoItemArray[_currentIndex - 1];
            }
            [self prepareForImageView:self.upImageView withLive:_upItem];
            
            if (self.upPlayer.view.frame.origin.y == 2 * KScreenHeight) {
                self.upPlayer.view.frame = CGRectMake(0, KScreenHeight * 0, KScreenWidth, KScreenHeight);
            }else{
                self.upPlayer.view.frame = CGRectMake(0, self.upPlayer.view.frame.origin.y + KScreenHeight, KScreenWidth, KScreenHeight);
            }
            
            if (self.upPlayer.view.frame.origin.y == 0 ) {
                [self prepareForVideo:self.upPlayer withLive:_upItem];
            }
            if (self.middlePlayer.view.frame.origin.y == 0 ) {
                [self prepareForVideo:self.middlePlayer withLive:_upItem];
            }
            if (self.downPlayer.view.frame.origin.y == 0 ) {
                [self prepareForVideo:self.downPlayer withLive:_upItem];
            }
            
            if (_previousIndex == _currentIndex) {
                return;
            }
            if ([self.playerDelegate respondsToSelector:@selector(playerScrollView:currentPlayerIndex:)]) {
                [self.playerDelegate playerScrollView:self currentPlayerIndex:_currentIndex];
                _previousIndex = _currentIndex;
                YWLog(@"current index is: %ld",_currentIndex);
            }
        }
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self switchPlayer:scrollView];
}

@end
