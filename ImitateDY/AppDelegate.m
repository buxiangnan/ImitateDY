//
//  AppDelegate.m
//  ImitateDY
//
//  Created by YangWei on 2017/11/22.
//  Copyright © 2017年 Apple-YangWei. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "VideoModel.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor clearColor];
    
    [self.window makeKeyAndVisible];
    
    MainViewController *MainVC = [[MainViewController alloc] init];
    
    NSMutableArray* videoArray = [NSMutableArray array];
    
    //视频数据源
    NSArray* videoSourceArray = [NSArray arrayWithObjects:
                            @"http://p3.pstatp.com/large/483b0003893b819e39b9.jpeg",
                            @"http://p3.pstatp.com/large/39890001423bad8a5938.jpeg",
                            @"http://p3.pstatp.com/large/486500101dc27621ce40.jpeg",
                            @"http://p3.pstatp.com/large/4858000b4654bb6d884e.jpeg",nil];
    //图片数据源
    NSArray* imageSourceArray = [NSArray arrayWithObjects:
                            @"http://v9-dy.ixigua.com/bca729a327d8dab4549a1fea1c9dd5db/5a15481b/video/m/22079d4ac76247b496f9ce39d4f006e38d411526b5d0000efb1970db7f2/",
                            @"http://v3-dy.ixigua.com/90c96ff2609da84f63ce66f01863bd62/5a154812/video/m/2204bd78bc1f7184838afb519aa58020fc8115135da00003ba82195ec49/",
                            @"http://v1-dy.ixigua.com/0d4d4d0a69329870af26017c69007333/5a154807/video/m/220b0ddc32d46b14983a6de54d8542d69bc11526d3d0000b47fd32de9c9/",
                            @"http://v6-dy.ixigua.com/video/m/220da50ee9df839421291000b7af6cd24b411526d4c0000026b2dad9f79/?Expires=1511348312&AWSAccessKeyId=qh0h9TdcEMoS2oPj7aKX&Signature=xw%2BkUQkpUSbKxJG8Dnt6KIKVqhw%3D",nil];
    
    for(int i = 0; i < videoSourceArray.count; i++){
        VideoModel *model = [[VideoModel alloc] init];
        model.videoURL = videoSourceArray[i];
        model.coverImageURL = imageSourceArray[i];
        [videoArray addObject:model];
    }
    
    MainVC.videoList = videoArray;
    
    self.window.rootViewController = MainVC;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
