//
//  WishItemTableViewController.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 17/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishListCell.h"
#import "WishItemDetailViewController.h"
#import "LoginViewController.h"

#import "Device.h"
@import Firebase;


NS_ASSUME_NONNULL_BEGIN

@interface WishItemTableViewController : UITableViewController

@property NSMutableArray *data;
@property NSMutableArray *wishItems;

@property NSString *uid;
@property NSString *email;

@property(nonatomic) FIRFirestore *ref;


@end

NS_ASSUME_NONNULL_END
