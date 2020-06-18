//
//  AppDelegate.m
//  VerticalScrollViewDemo
//
//  Created by goviewtech on 2020/6/18.
//  Copyright © 2020 goviewtech. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    ViewController *controller = [[ViewController alloc]init];
    self.window.rootViewController = controller;
    return YES;
}





@end
