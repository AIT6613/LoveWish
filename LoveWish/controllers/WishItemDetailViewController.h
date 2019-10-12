//
//  WishItemRequestViewController.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 17/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "ViewController.h"
#import "WishListCell.h"
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface WishItemDetailViewController : ViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property NSMutableArray *data;
@property NSMutableArray *offerData;
@property NSMutableArray *offerItem;
@property NSNumber *isNew;
@property FIRUser *firebaseUser;
@property NSString *userType;

@property (strong, nonatomic) IBOutlet UILabel *lblItemName;

@property (weak, nonatomic) IBOutlet UITextView *txtViewDetail;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;


- (IBAction)lblCreateNewOffer:(id)sender;

@end

NS_ASSUME_NONNULL_END
