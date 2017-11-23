//
//  PlayerScrollView.h
//  ImitateDY
//
//  Created by YangWei on 2017/11/22.
//  Copyright © 2017年 Apple-YangWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KSYMediaPlayer/KSYMediaPlayer.h>

@class PlayerScrollView;
@protocol PlayerScrollViewDelegate <NSObject>

- (void)playerScrollView:(PlayerScrollView *)playerScrollView currentPlayerIndex:(NSInteger)index;
@end

@interface PlayerScrollView : UIScrollView

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) KSYMoviePlayerController *upPlayer, *middlePlayer, *downPlayer;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)updateForvideoItemArray:(NSMutableArray *)videoItemArray withCurrentIndex:(NSInteger) index;

@property (nonatomic, weak) id<PlayerScrollViewDelegate> playerDelegate;

@end
