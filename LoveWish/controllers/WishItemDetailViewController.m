//
//  WishItemRequestViewController.m
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 17/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "WishItemDetailViewController.h"
#import "OfferViewController.h"

@interface WishItemDetailViewController ()


@end

@implementation WishItemDetailViewController

@synthesize data, lblItemName, txtViewDetail, offerItem, offerTableView, isNew, userType, firebaseUser, offerData, db;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    db = [FIRFirestore firestore];
    
    // Need to do this because we use tableView in side viewController
    [offerTableView setDelegate:self];
    [offerTableView setDataSource:self];
    
    // display wish request item detail
    [lblItemName setText:[data objectAtIndex:2]];
    [txtViewDetail setText:[data objectAtIndex:3]];
    
    // check if userType is User, hide create new offer button
    if ([[self userType] isEqualToString:@"User"]){
        [[self btnCreateNewOffer] setHidden:YES];
    }
    

    // get offer data to show in the offer item list
    self.offerData = [[NSMutableArray alloc] init];
    NSString *str = [NSString stringWithFormat:@"users/%@/wishItems/%@/offers",[self.data objectAtIndex:0],[self.data objectAtIndex:1]];
    [[self.db collectionWithPath:str]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (error != nil) {
             NSLog(@"Error getting documents: %@", error);
             [self displayAlertWith:@"Alert" andMessage:@"Get offer data fail."];
             return;
             
         } else {
             for (FIRDocumentSnapshot *document in snapshot.documents) {
                 // store data uid, wishItemid, title, detail
                 NSArray *item = [[NSArray alloc] initWithObjects:document.documentID, document[@"description"],document[@"price"], nil];
                 
                 [self.offerData addObject:item];
                 
             }
             [self.offerTableView reloadData];
         }
     }];
    
     
}

- (void)viewDidAppear:(BOOL)animated
{
    // remove all object every time to reload
    [self.offerData removeAllObjects];
    
    // get offer data to show in the offer item list
    self.offerData = [[NSMutableArray alloc] init];
    NSString *str = [NSString stringWithFormat:@"users/%@/wishItems/%@/offers",[self.data objectAtIndex:0],[self.data objectAtIndex:1]];
    [[self.db collectionWithPath:str]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
         if (error != nil) {
             NSLog(@"Error getting documents: %@", error);
             [self displayAlertWith:@"Alert" andMessage:@"Get offer data fail."];
             return;
             
         } else {
             for (FIRDocumentSnapshot *document in snapshot.documents) {
                 // store data uid, wishItemid, title, detail
                 NSArray *item = [[NSArray alloc] initWithObjects:document.documentID, document[@"description"],document[@"price"], nil];
                 
                 [self.offerData addObject:item];
                 
             }
             [self.offerTableView reloadData];
         }
     }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

// [START] setup table view ===========
// set number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// set number of item in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.offerData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Register custom design
    [self.offerTableView registerNib:[UINib nibWithNibName:@"OfferCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"OfferCell"];
    
    OfferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell" forIndexPath:indexPath];
    
    // get offer then display in tableview
    offerItem = [self.offerData objectAtIndex:indexPath.row];
    
    [[cell lblDescription] setText:[offerItem objectAtIndex:1]];
    [[cell lblPrice] setText:[offerItem objectAtIndex:2]];
    
    return cell;
}

// [FINISH] setup table view ===========

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    offerItem = [self.offerData objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toOfferDetail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //find segue
    if ([[segue identifier] isEqualToString: @"toOfferDetail"])
    {
        //get reference to the destination view controller
        OfferViewController *vc = [segue destinationViewController];
        
        //pass data to wish item request screen
        vc.offerData = offerItem;
        vc.wishItemData = data;
        vc.isNew = 0;
        vc.firebaseUser = self.firebaseUser;
        
    }
}


- (IBAction)lblCreateNewOffer:(id)sender {

}

- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end



