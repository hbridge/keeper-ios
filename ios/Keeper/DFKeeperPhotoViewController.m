//
//  DFKeeperPhotoViewController.m
//  Keeper
//
//  Created by Henry Bridge on 2/23/15.
//  Copyright (c) 2015 Duffy Inc. All rights reserved.
//

#import "DFKeeperPhotoViewController.h"
#import "DFImageManager.h"
#import "DFCategoryConstants.h"
#import "UIImage+Resize.h"
#import "DFRootViewController.h"
#import "DFAnalytics.h"
#import "DFKeeperStore.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "DFUIKit.h"
#import "UIImage+DFHelpers.h"

@interface DFKeeperPhotoViewController ()

@property (nonatomic, retain) DFCategorizeController *categorizeController;

@end

@implementation DFKeeperPhotoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (self.photo)
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [DFAnalytics logViewController:self appearedWithParameters:@{@"category" : NonNull(self.photo.category)}];
  [[DFRootViewController rootViewController] setSwipingEnabled:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [[DFRootViewController rootViewController] setSwipingEnabled:YES];
}

- (void)setPhoto:(DFKeeperPhoto *)photo
{
  _photo = photo;
  if (self.imageView) {
    [self reloadData];
  }
}

- (void)reloadData
{
  [[DFImageManager sharedManager]
   imageForKey:self.photo.imageKey
   pointSize:[[UIScreen mainScreen] bounds].size
   contentMode:DFImageRequestContentModeAspectFit
   deliveryMode:DFImageRequestOptionsDeliveryModeHighQualityFormat
   completion:^(UIImage *image) {
     dispatch_async(dispatch_get_main_queue(), ^{
       self.imageView.image = image;
       DDLogVerbose(@"image oreintation: %@", @(image.imageOrientation));
     });
   }];
  
  [self reloadCategory];
}

- (void)reloadCategory
{
  UIImage *icon = [DFCategoryConstants gridIconForCategory:self.photo.category];
  if (!icon) icon = [DFCategoryConstants defaultGridIcon];
  UIImage *resizedIcon = [icon thumbnailImage:20
                            transparentBorder:0
                                  cornerRadius:0
                          interpolationQuality:kCGInterpolationDefault];

  [self.tagButton setImage:[resizedIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                  forState:UIControlStateNormal];
                          
  [self.tagButton setTitle:self.photo.category forState:UIControlStateNormal];
}

- (IBAction)categoryButtonPressed:(id)sender {
  self.categorizeController = [DFCategorizeController new];
  self.categorizeController.delegate = self;
  [self.categorizeController presentInViewController:self];
}

- (void)categorizeController:(DFCategorizeController *)cateogrizeController didFinishWithCategory:(NSString *)category
{
  if (category) {
    self.photo.category = category;
    [[DFKeeperStore sharedStore] savePhoto:self.photo];
    [self reloadCategory];
  }
}

- (IBAction)deleteButtonPressed:(id)sender {
  DFAlertController *alertController = [DFAlertController
                                        alertControllerWithTitle:nil
                                        message:nil
                                        preferredStyle:DFAlertControllerStyleActionSheet];
  [alertController addAction:[DFAlertAction actionWithTitle:@"Cancel"
                                                      style:DFAlertActionStyleCancel
                                                    handler:nil]];
  [alertController
   addAction:[DFAlertAction
              actionWithTitle:@"Delete"
              style:DFAlertActionStyleDestructive
              handler:^(DFAlertAction *action) {
                [[DFKeeperStore sharedStore] deletePhoto:self.photo];
                [SVProgressHUD showSuccessWithStatus:@"Deleted"];
                [self.navigationController popViewControllerAnimated:YES];
              }]];
  [alertController showWithParentViewController:self animated:YES completion:nil];
}

- (IBAction)rotateButtonPressed:(id)sender {
  UIImageOrientation newOrientation = [self.imageView.image orientationRotatedLeft];
  DDLogVerbose(@"orientation old:%d new:%d", (int)self.imageView.image.imageOrientation,
               (int)newOrientation);
  self.imageView.image = [[UIImage alloc] initWithCGImage:self.imageView.image.CGImage
                                                    scale:1.0
                                              orientation:newOrientation];
}


@end
