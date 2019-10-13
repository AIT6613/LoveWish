//
//  MyProfileViewController.m
//  LoveWish
//
//  Created by 6613 on 10/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

@synthesize lblEmail,txtOldPassword, txtNewPassword, txtFirstName, txtLastName, txtContactNumber, txtAddress, db, firebaseUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    db = [FIRFirestore firestore];
    // get user from firestore
    firebaseUser = [[FIRAuth auth] currentUser];
    
    // get user detail from database
    FIRDocumentReference *docRef =
    [[self.db collectionWithPath:@"users"] documentWithPath:[firebaseUser uid]];
    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
        if (snapshot.exists) {
            // Document data may be nil if the document exists but has no keys or values.
            
             // show user detail to interface
            [self.lblEmail setText:[self.firebaseUser email]];
            [self.txtFirstName setText:snapshot.data[@"firstName"]];
            [self.txtLastName setText:snapshot.data[@"lastName"]];
            [self.txtContactNumber setText:snapshot.data[@"contactNumber"]];
            [self.txtAddress setText:snapshot.data[@"address"]];
            
        } else {
            NSLog(@"User does not exist");
            [self displayAlertWith:@"Alert" andMessage:[error localizedDescription]];
        }
    }];
    
    

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
    // check if both password have text
    if ([[self txtOldPassword] hasText] || [[self txtNewPassword] hasText]){
        // check need to provide both password
        if (![[self txtOldPassword] hasText] || ![[self txtNewPassword] hasText]){
            // ask user cannot user same password
            [self displayAlertWith:@"Alert" andMessage:@"Please provide all both old and new password."];
            
            return;
        }
        
        
        // check if both are the same password
        if ([[[self txtOldPassword] text] isEqualToString:[[self txtNewPassword] text]]){
            // ask user cannot user same password
            [self displayAlertWith:@"Alert" andMessage:@"New Pasword cannot be the same as previous one."];
            
            return;
        }
    
        // reautheticate user
        FIRAuthCredential *credentials = [FIREmailAuthProvider credentialWithEmail:[firebaseUser email] password:txtOldPassword.text];
        
        [firebaseUser reauthenticateWithCredential:credentials completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if(error){
                // ask user to input old password
                [self displayAlertWith:@"Alert" andMessage:[error localizedDescription]];
                return;
            }
            
            // update password
            [self.firebaseUser updatePassword:self.txtNewPassword.text completion:^(NSError *_Nullable error) {
                // check error
                if(error){
                    // ask user to input old password
                    [self displayAlertWith:@"Alert" andMessage:[error localizedDescription]];
                    return;
                }
                
                // clear password
                [self.txtOldPassword setText:@""];
                [self.txtNewPassword setText:@""];
            
            }];
            
        }];
    }
    
    // update user detail
    [[[self.db collectionWithPath:@"users"] documentWithPath:[self.firebaseUser uid]]
     updateData:@{
               @"firstName":[[self txtFirstName] text],
               @"lastName":[[self txtLastName] text],
               @"contactNumber":[[self txtContactNumber] text],
               @"address":[[self txtAddress] text]
               } completion:^(NSError * _Nullable error) {
                   if (error != nil) {
                       [self displayAlertWith:@"Alert" andMessage:[error localizedDescription]];
                       return;
                       
                   } else {
                       
                       [self displayAlertWith:@"Alert" andMessage:@"Update user profile successful."];
                       return;
                   }
                   
                   
               }];
}



- (IBAction)btnLogout:(id)sender {
    //log out
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        // Show alert, logout error
        [self displayAlertWith:@"Alert" andMessage:@"Logout Error. Please try again."];
        return;
        
    }
    
    // go back to root in tabbar controller
    [[self tabBarController] setSelectedIndex:0];
    
    [self displayLoginScreen];

}

// show login screen
- (void)displayLoginScreen {
    //get Authentication.storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    //get login viewcontroller
    LoginViewController *loginVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    
    //present SognInVC with an animation
    [self presentViewController:loginVC animated:NO completion:nil];
}

- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
