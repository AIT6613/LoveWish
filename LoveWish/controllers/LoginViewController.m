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

@synthesize txtEmail, txtPassword, switchContributor, db, uid, email;


- (void)viewDidLoad {
    [super viewDidLoad];
    // connect to firestore database
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

- (IBAction)btnLogin:(id)sender {
    // check if user input both email and pass
    if ([txtEmail hasText] && [txtPassword hasText])
    {
        [[FIRAuth auth] signInWithEmail:self.txtEmail.text password:self.txtPassword.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            
            // check if have an error
            if (error) {
                // show alert
                NSLog(@"%@",[error localizedDescription]);
                NSLog(@"Login Failed!!!!!!!");
                
                // Show alert, login fail
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Email or Password are not correct." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //button click event
                }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
                return;
            }
            
            // check if successful login
            if ([authResult user]){
                
                // [START get_user_profile]
                FIRUser *user = [FIRAuth auth].currentUser;
                // [END get_user_profile]
                
                // [START user_profile]
                if (user) {
                    // The user's ID, unique to the Firebase project.
                    // Do NOT use this value to authenticate with your backend server,
                    // if you have one. Use getTokenWithCompletion:completion: instead.
                    self.uid = user.uid;
                    self.email = user.email;
                    
                    NSLog(@"userid: %@  email:%@", self.uid, self.email);
                    
                    // Show Welcome, and move to main wish table page
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Welcome" message:@"Login Success." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //button click event
                        
                        
                        // dismiss login screen
                        [self dismissViewControllerAnimated:(YES) completion:nil];
                    }];
                    
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
                    
                    
                }

            } else {
                NSLog(@"user: %@", [[authResult user] uid]);
            }
        }];
        
    }
    else
    {
        // Show alert, ask user to fill in information again
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please input both email and password." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //button click event
        }];

        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //find segue
    if ([[segue identifier] isEqualToString: @"toWishTable"])
    {
        //get reference to the destination view controller
        WishItemTableViewController *vc = [segue destinationViewController];
        
        //pass data to wish item request screen
        vc.uid = self.uid;
        vc.email = self.email;
        
    }
}

@end
