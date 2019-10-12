//
//  MyProfileViewController.h
//  LoveWish
//
//  Created by 6613 on 10/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface MyProfileViewController : UIViewController

@property FIRFirestore *db;
@property FIRUser *firebaseUser;

@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtContactNumber;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;


- (IBAction)btnSave:(id)sender;
- (IBAction)btnLogout:(id)sender;
- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
