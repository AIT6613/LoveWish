//
//  SignUpControllerViewController.h
//  LoveWish
//
//  Created by 6613 on 24/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface SignUpControllerViewController : UIViewController

@property FIRFirestore *db;

@property (weak, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtContactNumber;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
@property (weak, nonatomic) IBOutlet UISwitch *swbContributor;
@property NSString *userType;


- (IBAction)btnSave:(id)sender;
- (IBAction)btnCancel:(id)sender;
- (IBAction)swhClick:(id)sender;

- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
