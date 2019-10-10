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

@synthesize data, wishItems, uid, email, db, firebaseUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    db = [FIRFirestore firestore];
    data = [[NSMutableArray alloc] init];
    
    NSString *str = [NSString stringWithFormat:@"users/%@/wishItem",[firebaseUser uid]];
    
    [[self.db collectionWithPath:str]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (error != nil) {
             NSLog(@"Error getting documents: %@", error);
             
         } else {
             for (FIRDocumentSnapshot *document in snapshot.documents) {
                 NSLog(@"%@ => %@", document.documentID, document.data);
                 
                 NSArray *item = [[NSArray alloc] initWithObjects:document.documentID, document[@"title"],document[@"detail"], nil];
                 
                 [self.data addObject:item];
                 
             }
             [self.tableView reloadData];
         }
     }];
    
    

}



- (void)viewDidAppear:(BOOL)animated
{
    firebaseUser = [[FIRAuth auth] currentUser];
    if (!firebaseUser) {
        //user not login, redirect to login in scene
        [self displayLoginScreen];
    }
    
    // remove all object every time to reload
    [self.data removeAllObjects];
    
    NSString *str = [NSString stringWithFormat:@"users/%@/wishItem",[firebaseUser uid]];
    
    [[self.db collectionWithPath:str]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (error != nil) {
             NSLog(@"Error getting documents: %@", error);
            
         } else {
             for (FIRDocumentSnapshot *document in snapshot.documents) {
                 NSLog(@"%@ => %@", document.documentID, document.data);
                 
                 NSArray *item = [[NSArray alloc] initWithObjects:document.documentID,document[@"title"],document[@"detail"], nil];
                 
                 [self.data addObject:item];
                 
             }
            [self.tableView reloadData];
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

        NSString *str = [NSString stringWithFormat:@"users/%@/wishItem",[firebaseUser uid]];
 
        [[[self.db collectionWithPath:str] documentWithPath:[[data objectAtIndex:indexPath.row] objectAtIndex:0]]
         deleteDocumentWithCompletion:^(NSError * _Nullable error) {
             if (error != nil) {
                 NSLog(@"Error removing document: %@", error);
             } else {
                 NSLog(@"WishItem successfully removed!");
                 
                 // delete row in table view
                 [self.data removeObjectAtIndex:indexPath.row];
                 [tableView reloadData];
             }
         }];
        
        
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
    
    [[cell lblItemName] setText:[wishItems objectAtIndex:1]];
    [[cell txtViewDetail] setText:[wishItems objectAtIndex:2]];
    
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
        vc.data = wishItems;
        
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
