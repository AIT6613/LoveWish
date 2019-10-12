//
//  LoginViewController.m
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 7/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()

@end


@implementation LoginViewController

@synthesize txtEmail, txtPassword, swhContributor, db, userType;


- (void)viewDidLoad {
    [super viewDidLoad];
    // connect to firestore database
    db = [FIRFirestore firestore];
    
    // set default for contributor switch to off
    self.userType = @"User";
    [self.swhContributor setOn:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnLogin:(id)sender {
    // check if user input both email and pass
    if ([txtEmail hasText] && [txtPassword hasText])
    {
        [[FIRAuth auth] signInWithEmail:self.txtEmail.text password:self.txtPassword.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            
            // check if have an error
            if (error) {
                // show alert
                [self displayAlertWith:@"Alert" andMessage:@"Email or Password are not correct."];
                
                return;
            }
            
            // check if successful login
            if ([authResult user]){
                
                // get user from firestore
                FIRUser *user = [FIRAuth auth].currentUser;
                
                // get user detail
                FIRDocumentReference *docRef =
                [[self.db collectionWithPath:@"users"] documentWithPath:[user uid]];
                [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
                    if (snapshot.exists) {
                        // Document data may be nil if the document exists but has no keys or values.
                        NSLog(@"User data: %@", snapshot.data);
                        
                        if ([snapshot.data[@"userType"] isEqualToString:self.userType] )
                        {
                            // dismiss login screen
                            [self dismissViewControllerAnimated:(YES) completion:nil];
                        } else {
                            // display get user fail
                            NSLog(@"User does not exist");
                            [self displayAlertWith:@"Alert" andMessage:@"User type not match."];
                            [self signoutUser];
                        }
                        
                    } else {
                        // display get user fail
                        NSLog(@"User does not exist");
                        [self displayAlertWith:@"Alert" andMessage:error.localizedDescription];
                    }
                }];

            } else {
                NSLog(@"user: %@", [[authResult user] uid]);
                
                // display fail alert
                [self displayAlertWith:@"Alert" andMessage:@"Login fail. Does not have dis user in the system."];
            }
        }];
        
    }
    else
    {
        // Show alert, ask user to fill in information again
        [self displayAlertWith:@"Alert" andMessage:@"Please input both email and password."];
    }
    
}

- (IBAction)switchToggle:(id)sender {
    if ([self.swhContributor isOn]) {
        self.userType = @"Contributor";
    } else {
        self.userType = @"User";
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    //find segue
//    if ([[segue identifier] isEqualToString: @"toWishTable"])
//    {
//        //get reference to the destination view controller
//        WishItemTableViewController *vc = [segue destinationViewController];
//
//        //pass data to wish item request screen
//        vc.uid = self.uid;
//        vc.email = self.email;
//
//    }
//}

- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // dismiss screen
        //[self dismissViewControllerAnimated:(YES) completion:nil];
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)signoutUser{
    //sign out
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        // Show alert, logout error
        [self displayAlertWith:@"Alert" andMessage:@"Logout Error. Please try again."];
        
        return;
    }
}

@end
