//
//  SignUpControllerViewController.m
//  LoveWish
//
//  Created by 6613 on 24/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "SignUpControllerViewController.h"


@implementation SignUpControllerViewController

@synthesize db, txtAddress, txtLastName, txtPassword, txtFirstName, txtEmailAddress, txtContactNumber, swbContributor, userType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    db = [FIRFirestore firestore];
    
    self.userType = @"User";
    [self.swbContributor setOn:NO];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSave:(id)sender {
    // check information validation
    NSLog(@"email: %@   pass: %@",[self->txtEmailAddress text],[self->txtPassword text]);
    if (![self.txtEmailAddress hasText]){
        [self displayAlertWith:@"SignUp" andMessage:@"Please provide your email address."];
        return;
    }
    
    // sign up
    [[FIRAuth auth] createUserWithEmail:[txtEmailAddress text] password:[txtPassword text] completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        
            // check if have an error
            if (error) {
                // show alert
                [self displayAlertWith:@"SignUp" andMessage:error.localizedDescription];
                
                return;
            }
        
            // check if successful create new user
            if ([authResult user]){
                


                // add user detail to users by user key
                [[[self.db collectionWithPath:@"users"] documentWithPath:[[authResult user] uid]]
                  setData:@{
                                @"firstName":[[self txtFirstName] text],
                                @"lastName":[[self txtLastName] text],
                                @"contactNumber":[[self txtContactNumber] text],
                                @"address":[[self txtAddress] text],
                                @"userType":self.userType
                            } completion:^(NSError * _Nullable error) {
                                if (error != nil) {
                                    NSLog(@"Error: %@", error);
                                    [self displayAlertWith:@"SignUp" andMessage:error.localizedDescription];
                                    return;
                                } else {
                                    NSLog(@"Sign up successful.");
                                    [self displayAlertWith:@"SignUp" andMessage:@"Congratulation. You already regitered to our system."];
                                }
                                
                                // dissmiss both view controller
                                [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
                            }];
            } else {
                NSLog(@"user: %@", [[authResult user] uid]);
            }
        }];

}

- (IBAction)btnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)swhClick:(id)sender {
    if ([self.swbContributor isOn]) {
        self.userType = @"Contributor";
    } else {
        self.userType = @"User";
    }
}

- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // dismiss screen
        //[self dismissViewControllerAnimated:(YES) completion:nil];
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
