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

@synthesize txtEmail, txtOldPassword, txtNewPassword, txtFirstName, txtLastName, txtContactNumber, txtAddress, db, firebaseUser;

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
            NSLog(@"User data: %@", snapshot.data);
            
             // show user detail to interface
            [self.txtEmail setText:[self.firebaseUser email]];
            [self.txtFirstName setText:snapshot.data[@"firstName"]];
            [self.txtLastName setText:snapshot.data[@"lastName"]];
            [self.txtContactNumber setText:snapshot.data[@"contactNumber"]];
            [self.txtAddress setText:snapshot.data[@"address"]];
            
        } else {
            NSLog(@"User does not exist");
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
    // check if new both password
    if (![txtNewPassword.text isEqualToString:@""]){
        // check if have old password
        if ([txtOldPassword.text isEqualToString:@""]){
            // ask user to input old password
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please provide old password." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    
        // reautheticate user
        FIRAuthCredential *credentials = [FIREmailAuthProvider credentialWithEmail:[firebaseUser email] password:txtOldPassword.text];
        
        [firebaseUser reauthenticateWithCredential:credentials completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if(error){
                // ask user to input old password
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Updaet password error." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            
            // update password
            [self.firebaseUser updatePassword:self.txtNewPassword.text completion:^(NSError *_Nullable error) {
                // check error
                if(error){
                    // ask user to input old password
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Updaet password error." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
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
                       NSLog(@"Error: %@", error);
                       // check error
                      
                       // ask user to input old password
                       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Updaet user detail error." preferredStyle:UIAlertControllerStyleAlert];
                       
                       UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                           
                       }];
                       
                       [alert addAction:ok];
                       [self presentViewController:alert animated:YES completion:nil];
                       return;
                       
                   } else {
                       NSLog(@"Updaet user successful.");
                       
                       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Updaet user successful." preferredStyle:UIAlertControllerStyleAlert];
                       
                       UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                           
                       }];
                       
                       [alert addAction:ok];
                       [self presentViewController:alert animated:YES completion:nil];
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Logout Error. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //button click event
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
       
        return;
    }
    
    // go back to root in tabbar controller
    [[self tabBarController] setSelectedIndex:0];
    
    //redirect to login screen
    //[self displayLoginScreen];
    
}

// show login screen
- (void)displayLoginScreen {
    //get Authentication.storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    //get SignInVC
    LoginViewController *loginVC = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    //present SognInVC with an animation
    [self presentViewController:loginVC animated:NO completion:nil];
}

@end
