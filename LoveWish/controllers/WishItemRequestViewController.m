//
//  WishItemRequestViewController.m
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 17/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "WishItemRequestViewController.h"

@interface WishItemRequestViewController ()


@end

@implementation WishItemRequestViewController

@synthesize data, lblItemName, txtViewDetail;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [lblItemName setText:[data objectAtIndex:0]];
//    [txtViewDetail setText:[data objectAtIndex:1]];
//
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
