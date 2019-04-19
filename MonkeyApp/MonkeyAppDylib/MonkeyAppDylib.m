//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  MonkeyAppDylib.m
//  MonkeyAppDylib
//
//  Created by Yulong Liu on 2019/4/18.
//  Copyright (c) 2019 long_. All rights reserved.
//

#import "MonkeyAppDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>

#import "AWEHookSettingViewController.h"
#import "AYTikTokPod/AYTikTokPod.h"

CHConstructor{
    printf(INSERT_SUCCESS_WELCOME);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
#ifndef __OPTIMIZE__
        CYListenServer(6666);
        
        MDCycriptManager* manager = [MDCycriptManager sharedInstance];
        [manager loadCycript:NO];

        NSError* error;
        NSString* result = [manager evaluateCycript:@"UIApp" error:&error];
        NSLog(@"result: %@", result);
        if(error.code != 0){
            NSLog(@"error: %@", error.localizedDescription);
        }
#endif
        
    }];
}


// Show Setting page when user shake iphone
CHDeclareClass(UIViewController)

CHMethod2(void, UIViewController, motionEnded, UIEventSubtype, motion, withEvent, UIEvent *, event) {

    CHSuper2(UIViewController, motionEnded, motion, withEvent, event);

    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        AWEHookSettingViewController *settingVc = [[AWEHookSettingViewController alloc] init];
        UIViewController *tabbarVc = UIApplication.sharedApplication.keyWindow.rootViewController;
        UINavigationController *hookNavi = [[UINavigationController alloc] initWithRootViewController:settingVc];
        [tabbarVc presentViewController:hookNavi animated:YES completion:nil];
    }
}

CHConstructor {
    CHLoadLateClass(UIViewController);
    CHClassHook2(UIViewController, motionEnded, withEvent);
}



// Add switch button on Home page
//
//CHDeclareClass(AWEAwemePlayInteractionViewController)
//
//CHOptimizedMethod0(self, void, AWEAwemePlayInteractionViewController, viewDidLoad) {
//    CHSuper0(AWEAwemePlayInteractionViewController, viewDidLoad);
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(100, 100, 50, 50);
//    [btn setBackgroundColor:[UIColor redColor]];
//    [btn addTarget:self action:@selector(settingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    NSDictionary *areaDic = [UserDefaults valueForKey:HookArea];
//    NSString *area = [areaDic objectForKey:@"area"];
//
//    if (area == nil || [area isEqualToString:@""]) {
//        area = [HookInitAreaValue objectForKey:@"area"];
//    }
//
//    [btn setTitle:area forState:UIControlStateNormal];
//
//    UIView *view = [(UIViewController*)self view];
//    [view addSubview:btn];
//}
//
//CHDeclareMethod1(void, AWEAwemePlayInteractionViewController, settingBtnAction, UIButton *, btn) {
//
//    AWEHookSettingViewController *settingVc = [[AWEHookSettingViewController alloc] init];
//    UIViewController *tabbarVc = UIApplication.sharedApplication.keyWindow.rootViewController;
//    UINavigationController *hookNavi = [[UINavigationController alloc] initWithRootViewController:settingVc];
//    [tabbarVc presentViewController:hookNavi animated:YES completion:nil];
//
//}
//
//CHConstructor{
//    CHLoadLateClass(AWEAwemePlayInteractionViewController);
//    CHClassHook0(AWEAwemePlayInteractionViewController, viewDidLoad);
//}
//
