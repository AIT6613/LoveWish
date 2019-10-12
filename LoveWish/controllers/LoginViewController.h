//
//  LoginViewController.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 7/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishItemTableViewController.h"
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController

@property FIRFirestore *db;
@property NSString *userType;




@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UISwitch *swhContributor;




- (IBAction)btnLogin:(id)sender;
- (IBAction)switchToggle:(id)sender;

- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message;
- (void)signoutUser;


@end


NS_ASSUME_NONNULL_END
