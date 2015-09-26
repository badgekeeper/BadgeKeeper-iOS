//
//  AppDelegate.m
//  BadgeKeeper.Sample
//
//  Created by Alexander Pukhov on 26.09.15.
//  Copyright (c) 2015 Alexander Pukhov, BadgeKeeper. All rights reserved.
//

#import "AppDelegate.h"
#import "BadgeKeeper.h"
#import "BKAchievementViewController.h"


@interface AppDelegate () {
    
}

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // setup BadgeKeeper project ID
    [BadgeKeeper instance].projectId = @"773b0723-ba00-45a3-aa8c-fc3d20f3fd20";
    
    // display simple view controller
    BKAchievementViewController *controller = [[BKAchievementViewController alloc]
                                               initWithNibName:@"BKAchievementViewController"
                                               bundle:[NSBundle mainBundle]];
    // init window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
