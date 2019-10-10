//
//  WishItemRequestViewController.m
//  LoveWish
//
//  Created by 6613 on 10/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "WishItemRequestViewController.h"

@interface WishItemRequestViewController ()

@end

@implementation WishItemRequestViewController

@synthesize imgData,txtTitle,txtDetail,imageTableView, imgDataItem;



- (void)viewDidLoad {
    [super viewDidLoad];
    // get user from firestore
    FIRUser *firebaseUser = [[FIRAuth auth] currentUser];
    
    // Need to do this because we use tableView in side viewController
    [imageTableView setDelegate:self];
    [imageTableView setDataSource:self];
    
    
    // SHOW OFFER DATA IN TABLE VIEW
    //data = [[NSMutableArray alloc] initWithObjects:@"{'MyItem1','xxx','eee'}",@"MyItem2",@"MyItem3",@"MyItem4",@"MyItem5",@"MyItem6",@"MyItem7",@"MyItem8",@"MyItem9 MyItem10",@"MyItem11",@"MyItem12",@"MyItem13",nil];
    imgData = [[NSMutableArray alloc] init];
    [imgData addObject:@[@"image1",@"fkadlfl;adsfaksdfla",@"offerImage1"]];
    [imgData addObject:@[@"image2",@"356357658476857867",@"offerImage2"]];
    
    
    // Pulling the data from Core Data
    //data = [[NSMutableArray alloc] init];
}

// set number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// set number of item in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [imgData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Register custom design
    [self.imageTableView registerNib:[UINib nibWithNibName:@"ImageViewCell"
                                                    bundle:nil]
              forCellReuseIdentifier:@"ImageViewCell"];
    
    ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageViewCell" forIndexPath:indexPath];
    
    // Get the student object from Array. One object at a time.
    //NSManagedObject *student = [data objectAtIndex:[indexPath row]];
    imgDataItem = [imgData objectAtIndex:indexPath.row];
    NSLog(@"IMGDATA: %@", [imgDataItem objectAtIndex:0]);
    
    //[[cell imgBox] setText:[offerItem objectAtIndex:0]];
    [[cell lblName] setText:[imgDataItem objectAtIndex:0]];
    
    //[[cell imgViewItem] setText:[NSString stringWithFormat:@"%@", [student valueForKey:@"sid"]]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
