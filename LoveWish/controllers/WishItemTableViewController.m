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

@synthesize data, wishItems, uid, email;

- (void)viewDidLoad {
    [super viewDidLoad];
    //data = [[NSMutableArray alloc] initWithObjects:@"{'MyItem1','xxx','eee'}",@"MyItem2",@"MyItem3",@"MyItem4",@"MyItem5",@"MyItem6",@"MyItem7",@"MyItem8",@"MyItem9 MyItem10",@"MyItem11",@"MyItem12",@"MyItem13",nil];
    data = [[NSMutableArray alloc] init];
    [data addObject:@[@"MyItem1",@"In Objective-C, the compiler generates code that makes an underlying call to .... init?(contentsOfFile: String). Initializes a newly allocated array with the ... Returns the index of the first object in the array that passes a test in a given block. ..... Xcode · Swift · Swift Playgrounds ",@"image1"]];
    [data addObject:@[@"MyItem2",@"In Objective-C, arrays take the form of the NSArray class. ... Instead, we can initialize all of these string objects within the contents of a collection to hold and .... Subscripting returns the object at the submitted index number of the array being accessed. .... Reference: Objective-C Fundamentals · Xcode: Warnings and Errors ...",@"image2"]];
    
    
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

#pragma mark - Table view data source

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
    [self.tableView registerNib:[UINib nibWithNibName:@"WishListCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"wishItemCell"];
    
    WishListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wishItemCell" forIndexPath:indexPath];
    
    // Get the student object from Array. One object at a time.
    //NSManagedObject *student = [data objectAtIndex:[indexPath row]];
     wishItems = [data objectAtIndex:indexPath.row];
    
    [[cell lblItemName] setText:[wishItems objectAtIndex:0]];
    [[cell txtViewDetail] setText:[wishItems objectAtIndex:1]];
    
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
        WishItemRequestViewController *vc = [segue destinationViewController];
        
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
