//
//  AppDelegate.h
//  Keeper
//
//  Created by Henry Bridge on 2/15/15.
//  Copyright (c) 2015 Duffy Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy) void (^backgroundDownloadSessionCompletionHandler)();
@property (copy) void (^backgroundUploadSessionCompletionHandler)();

@end

