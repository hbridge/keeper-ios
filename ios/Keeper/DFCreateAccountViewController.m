//
//  DFCreateAccountViewController.m
//  Keeper
//
//  Created by Henry Bridge on 3/5/15.
//  Copyright (c) 2015 Duffy Inc. All rights reserved.
//

#import "DFCreateAccountViewController.h"
#import "DFUserLoginManager.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface DFCreateAccountViewController ()

@end

@implementation DFCreateAccountViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  for (DFInsetTextField *tf in @[self.nameTextField, self.emailTextField, self.passwordTextField]) {
    tf.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    tf.layer.borderWidth = 1.0;
    tf.textInsets = UIEdgeInsetsMake(0, 4, 0, 4);
  }
  
  [self setButtonEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.nameTextField becomeFirstResponder];
}


- (IBAction)editingChanged:(id)sender {
  if ([self.nameTextField.text isNotEmpty]
      && [self.emailTextField.text isNotEmpty]
      && [self.passwordTextField.text isNotEmpty]) {
    [self setButtonEnabled:YES];
  } else {
    [self setButtonEnabled:NO];
  }
}

- (void)setButtonEnabled:(BOOL)enabled
{
  self.createAccountButton.enabled = enabled;
  self.createAccountButton.alpha = enabled ? 1.0 : 0.5;
}


- (IBAction)createAccountPressed:(id)sender {
  [[DFUserLoginManager sharedManager]
   createUserWithName:self.nameTextField.text
   email:self.emailTextField.text
   password:self.passwordTextField.text
   success:^{
     dispatch_async(dispatch_get_main_queue(), ^{
       [[DFUserLoginManager sharedManager] dismissNotLoggedInControllerWithCompletion:^{
         [SVProgressHUD showSuccessWithStatus:@"Account Created!"];
       }];
     });
   } failure:^(NSError *error) {
     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
   }];
}

@end
