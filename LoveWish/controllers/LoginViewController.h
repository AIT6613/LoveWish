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
@property NSString *uid;
@property NSString *email;


@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UISwitch *switchContributor;




- (IBAction)btnLogin:(id)sender;

@end


NS_ASSUME_NONNULL_END
