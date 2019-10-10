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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    //redirect to login screen
    [self displayLoginScreen];
    
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
