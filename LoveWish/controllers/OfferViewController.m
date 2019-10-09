//
//  OfferViewController.m
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 3/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "OfferViewController.h"

@interface OfferViewController ()

@end

@implementation OfferViewController

@synthesize lblTitle,lblItemName,textViewDescription, imageTableView, data, offerItem, isNew;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%d",self.isNew);
    
    // Need to do this because we use tableView in side viewController
    [imageTableView setDelegate:self];
    [imageTableView setDataSource:self];
    
    [lblItemName setText:[data objectAtIndex:0]];
    [textViewDescription setText:[data objectAtIndex:1]];
    
    
    // SHOW OFFER DATA IN TABLE VIEW
    //data = [[NSMutableArray alloc] initWithObjects:@"{'MyItem1','xxx','eee'}",@"MyItem2",@"MyItem3",@"MyItem4",@"MyItem5",@"MyItem6",@"MyItem7",@"MyItem8",@"MyItem9 MyItem10",@"MyItem11",@"MyItem12",@"MyItem13",nil];
    data = [[NSMutableArray alloc] init];
    [data addObject:@[@"imageName1",@"offerImage1"]];
    [data addObject:@[@"imageName2",@"offerImage2"]];
    

    
    
    // Pulling the data from Core Data
    //data = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    /*
     [super viewDidAppear:animated];
     
     // prepare fectch command
     NSFetchRequest *myFetch = [NSFetchRequest fetchRequestWithEntityName:@"Students"];
     
     // prepare the context
     NSManagedObjectContext *context = [[[[UIApplication sharedApplication] delegate] performSelector:@selector(persistentContainer)] viewContext];
     
     // execute fetch command
     data = [[context executeFetchRequest:myFetch error:nil] mutableCopy];
     
     [self.tableView reloadData];
     */
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


// set number of section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// set number of item in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Register custom design
    [self.imageTableView registerNib:[UINib nibWithNibName:@"WishListCell"
                                                    bundle:nil]
              forCellReuseIdentifier:@"wishItemCell"];
    
    WishListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wishItemCell" forIndexPath:indexPath];
    
    // Get the student object from Array. One object at a time.
    //NSManagedObject *student = [data objectAtIndex:[indexPath row]];
    offerItem = [data objectAtIndex:indexPath.row];
    
    [[cell lblItemName] setText:[offerItem objectAtIndex:0]];
    [[cell txtViewDetail] setText:[offerItem objectAtIndex:1]];
    
    //[[cell imgViewItem] setText:[NSString stringWithFormat:@"%@", [student valueForKey:@"sid"]]];
    
    return cell;
}


- (IBAction)btnSave:(id)sender {
    
}
@end
