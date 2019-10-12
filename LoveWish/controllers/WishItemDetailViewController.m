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

@synthesize data, lblItemName, txtViewDetail, offerItem, offerTableView, isNew, userType, firebaseUser, offerData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Need to do this because we use tableView in side viewController
    [offerTableView setDelegate:self];
    [offerTableView setDataSource:self];
    
    [lblItemName setText:[data objectAtIndex:1]];
    [txtViewDetail setText:[data objectAtIndex:2]];
    

    // get offer data to show in the offer item list
    self.offerData = [[NSMutableArray alloc] init];
//    [self.offerData addObject:@[@"Offer1",@"fkadlfl;adsfaksdfla",@"offerImage1"]];
//    [self.offerData addObject:@[@"Offer2",@"356357658476857867",@"offerImage2"]];
    
     
}

- (void)viewDidAppear:(BOOL)animated
{
    // remove all object every time to reload
    [self.offerData removeAllObjects];
    
    // TODO: do the same thing with did load
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
    [self.offerTableView registerNib:[UINib nibWithNibName:@"WishListCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"wishItemCell"];
    
    WishListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wishItemCell" forIndexPath:indexPath];
    
    // Get the student object from Array. One object at a time.
    //NSManagedObject *student = [data objectAtIndex:[indexPath row]];
    offerItem = [self.offerData objectAtIndex:indexPath.row];
    
    [[cell lblItemName] setText:[offerItem objectAtIndex:0]];
    [[cell txtViewDetail] setText:[offerItem objectAtIndex:1]];
    
    //[[cell imgViewItem] setText:[NSString stringWithFormat:@"%@", [student valueForKey:@"sid"]]];
    
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
        vc.isNew = 0;
        
    }
}


- (IBAction)lblCreateNewOffer:(id)sender {

}
@end



