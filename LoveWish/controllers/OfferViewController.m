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

@synthesize lblTitle,lblItemName,textViewDescription, imageTableView, imageData, txtPrice, imageItem, isNew, offerData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%d",self.isNew);
    
    // Need to do this because we use tableView in side viewController
    [imageTableView setDelegate:self];
    [imageTableView setDataSource:self];
    
    [lblItemName setText:[offerData objectAtIndex:0]];
    [textViewDescription setText:[offerData objectAtIndex:1]];
    
    // Show data
    imageData = [[NSMutableArray alloc] init];
    [imageData addObject:@[@"imageName1",@"offerImage1"]];
    [imageData addObject:@[@"imageName2",@"offerImage2"]];
    

    
    
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
    return [imageData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Register custom design
    [self.imageTableView registerNib:[UINib nibWithNibName:@"ImageViewCell"
                                                    bundle:nil]
              forCellReuseIdentifier:@"ImageViewCell"];
    
    ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageViewCell" forIndexPath:indexPath];
    
    // Get the student object from Array. One object at a time.
    //NSManagedObject *student = [data objectAtIndex:[indexPath row]];
    imageItem = [imageData objectAtIndex:indexPath.row];
    
    //[[cell ] setText:[offerItem objectAtIndex:0]];
    [[cell lblName] setText:[imageItem objectAtIndex:1]];
    
    
    return cell;
}


- (IBAction)btnSave:(id)sender {
    
}
@end
