//
//  SignUpControllerViewController.m
//  LoveWish
//
//  Created by 6613 on 24/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "SignUpControllerViewController.h"


@implementation SignUpControllerViewController

@synthesize db, txtAddress, txtLastName, txtPassword, txtFirstName, txtEmailAddress, txtContactNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    db = [FIRFirestore firestore];


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
    NSLog(@"Step 1");
    NSLog(@"email: %@   pass: %@",[self->txtEmailAddress text],[self->txtPassword text]);
    // sign up
    [[FIRAuth auth] createUserWithEmail:[txtEmailAddress text] password:[txtPassword text] completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        
            // check if have an error
            if (error) {
                // show alert
                // TODO: show alert
                
                NSLog(@"%@",[error localizedDescription]);
                NSLog(@"Sign up ERROR!!!!!!!");
                
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
                                @"address":[[self txtAddress] text]
                            } completion:^(NSError * _Nullable error) {
                                if (error != nil) {
                                    NSLog(@"Error: %@", error);
                                } else {
                                    NSLog(@"Sign up successful.");
                                }
                            }];
            } else {
                NSLog(@"user: %@", [[authResult user] uid]);
            }
        }];

}

@end
