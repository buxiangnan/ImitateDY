//
//  MainViewController.h
//  ImitateDY
//
//  Created by YangWei on 2017/11/22.
//  Copyright © 2017年 Apple-YangWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface MainViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *videoList;
@property (nonatomic, strong) VideoModel *videoItem;
@property (nonatomic, assign) NSInteger index;

- (void)pausePlay;
- (void)startPlay;

@end
