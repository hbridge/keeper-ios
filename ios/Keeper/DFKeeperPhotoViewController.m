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

@interface DFKeeperPhotoViewController ()

@end

@implementation DFKeeperPhotoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (self.photo)
    [self reloadData];
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
     });
   }];
  
  UIImage *icon = [DFCategoryConstants gridIconForCategory:self.photo.text];
  if (!icon) icon = [DFCategoryConstants defaultGridIcon];
  [self.tagButton setImage:[icon thumbnailImage:20
                              transparentBorder:0
                                   cornerRadius:0
                           interpolationQuality:kCGInterpolationDefault]
                  forState:UIControlStateNormal];
  [self.tagButton setTitle:self.photo.text forState:UIControlStateNormal];
}

@end