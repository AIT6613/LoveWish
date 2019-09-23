//
//  WishItemTableViewController.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 17/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishListCell.h"
#import "WishItemRequestViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WishItemTableViewController : UITableViewController

@property NSMutableArray *data;
@property NSMutableArray *wishItems;

@end

NS_ASSUME_NONNULL_END
