//
//  WishItemTableViewController.m
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 17/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "WishItemTableViewController.h"

@interface WishItemTableViewController ()

@end

@implementation WishItemTableViewController

@synthesize data, wishItems, uid, email, userType, db, firebaseUser, ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    db = [FIRFirestore firestore];
    data = [[NSMutableArray alloc] init];
    
    // get user from firestore
    firebaseUser = [[FIRAuth auth] currentUser];
    if (!firebaseUser)
    {
        [self displayLoginScreen];
        return;
    }
    
    // get user detail
    // get user detail from database
//    FIRDocumentReference *docRef =
//    [[self.db collectionWithPath:@"users"] documentWithPath:[firebaseUser uid]];
//    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
//        
//        if (snapshot.exists) {
//            // Document data may be nil if the document exists but has no keys or values.
//            NSLog(@"User data: %@", snapshot.data);
//            
//            self.userType = snapshot.data[@"userType"];
//            
//            // TODO: hide add button
//            
//            
//            // remove all object every time to reload
//            [self.data removeAllObjects];
//            
//            // if user type is User, show only wish item request for their own
//            // if user type is Contributor, show all wish item requests
//            if ([[self userType] isEqualToString:@"User"]){
//                // Get wish item requests select by uid
//                [self getWishItemByUid:[[self firebaseUser] uid]];
//            } else {
//                // Get all wish item requests
//                [self getAllWishItem];
//            }
//            
//            
//        } else {
//            NSLog(@"User does not exist");
//            [self displayAlertWith:@"Alert" andMessage:error.localizedDescription];
//            
//            [self signoutUser];
//            
//            // go back to root in tabbar controller
//            [[self tabBarController] setSelectedIndex:0];
//        }
//    }];
    

}



- (void)viewDidAppear:(BOOL)animated
{
    firebaseUser = [[FIRAuth auth] currentUser];
    if (!firebaseUser) {
        //user not login, redirect to login in scene
        [self displayLoginScreen];
        return;
    }
    
    // get user detail
    // get user detail from database
    FIRDocumentReference *docRef =
    [[self.db collectionWithPath:@"users"] documentWithPath:[firebaseUser uid]];
    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
        
        if (snapshot.exists) {
            // Document data may be nil if the document exists but has no keys or values.
            self.userType = snapshot.data[@"userType"];
            
            // TODO: hide add button
            
            
            // remove all object every time to reload
            [self.data removeAllObjects];
            
            // if user type is User, show only wish item request for their own
            // if user type is Contributor, show all wish item requests
            if ([[self userType] isEqualToString:@"User"]){
                // Get wish item requests select by uid
                [self getWishItemByUid:[[self firebaseUser] uid]];
            } else {
                // Get all wish item requests
                [self getAllWishItem];
            }
            
            
        } else {
            [self displayAlertWith:@"Alert" andMessage:error.localizedDescription];
            
            [self signoutUser];
            
            // go back to root in tabbar controller
            [[self tabBarController] setSelectedIndex:0];
        }
    }];
    
    
   
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

#pragma mark - Table view data source

// set number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// set number of item in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];

}

// START: DELETE by swipe in table view  ================
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete document in database
        [self deleteWishItemById:[[data objectAtIndex:indexPath.row] objectAtIndex:0]];
        
        // delete row in table view
        [self.data removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        
    }
}
// END: DELETE by swipe in table view  ================


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Register custom design
    [self.tableView registerNib:[UINib nibWithNibName:@"WishListCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"wishItemCell"];
    
    WishListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wishItemCell" forIndexPath:indexPath];
    
    // Get the student object from Array. One object at a time.
    //NSManagedObject *student = [data objectAtIndex:[indexPath row]];
     wishItems = [data objectAtIndex:indexPath.row];
    
    [[cell lblItemName] setText:[wishItems objectAtIndex:2]];
    [[cell txtViewDetail] setText:[wishItems objectAtIndex:3]];
    
    //[[cell imgViewItem] setText:[NSString stringWithFormat:@"%@", [student valueForKey:@"sid"]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    wishItems = [data objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toWishItemDetail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //find segue
    if ([[segue identifier] isEqualToString: @"toWishItemDetail"])
    {
        //get reference to the destination view controller
        WishItemDetailViewController *vc = [segue destinationViewController];
        
        //pass data to wish item request screen
        vc.wishItemData = wishItems;
        vc.firebaseUser = self.firebaseUser;
        vc.userType = self.userType;
        
    }
}

- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

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

// get wish item by uid
- (void)getWishItemByUid:(NSString *)uid{
    [[[self.db collectionWithPath:@"wishItemRequests"] queryWhereField:@"uid" isEqualTo:uid]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (error != nil) {
             NSLog(@"Error getting documents: %@", error);
         } else {
             for (FIRDocumentSnapshot *document in snapshot.documents) {
                 //NSLog(@"%@ => %@", document.documentID, document.data);
                 //store data uid, wishItemid, title, detail
                 NSArray *item = [[NSArray alloc] initWithObjects:document.documentID,document[@"uid"], document[@"title"],document[@"detail"], nil];
                 
                 [self.data addObject:item];
             }
             [self.tableView reloadData];
         }
     }];
}

// get all wish item requests
- (void)getAllWishItem{
    [[self.db collectionWithPath:@"wishItemRequests"]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (error != nil) {
             NSLog(@"Error getting documents: %@", error);
         } else {
             for (FIRDocumentSnapshot *document in snapshot.documents) {
                 //NSLog(@"%@ => %@", document.documentID, document.data);
                 //store data uid, wishItemid, title, detail
                 NSArray *item = [[NSArray alloc] initWithObjects:document.documentID,document[@"uid"], document[@"title"],document[@"detail"], nil];
                 
                 [self.data addObject:item];
             }
             [self.tableView reloadData];
         }
     }];
}

// delete wish item by id
- (void)deleteWishItemById:(NSString *)id{
    [[[self.db collectionWithPath:@"wishItemRequests"] documentWithPath:id]
     deleteDocumentWithCompletion:^(NSError * _Nullable error) {
         if (error != nil) {
             NSLog(@"Error removing document: %@", error);
         } else {
             NSLog(@"WishItem successfully removed!");

         }
     }];
}
@end
