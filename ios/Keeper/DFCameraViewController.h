//
//  DFCameraViewController.h
//  Strand
//
//  Created by Henry Bridge on 6/9/14.
//  Copyright (c) 2014 Duffy Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DFAVCameraViewController.h"
#import "DFCategorizeController.h"

@class DFCameraOverlayView;

@interface DFCameraViewController : DFAVCameraViewController <DFAVCameraViewControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, DFCategorizeControllerDelegate>

@property (nonatomic, readonly, retain) DFCameraOverlayView *customCameraOverlayView;

@end
