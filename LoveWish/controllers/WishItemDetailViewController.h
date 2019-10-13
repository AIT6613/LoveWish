//
//  WishItemRequestViewController.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 17/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "ViewController.h"
#import "OfferCell.h"
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface WishItemDetailViewController : ViewController <UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *wishItemData;
@property NSMutableArray *offerData;
@property NSMutableArray *offerItem;
@property FIRUser *firebaseUser;
@property NSString *userType;
@property NSString *isCreateNewOffer;

@property FIRFirestore *db;

@property (strong, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateNewOffer;

@property (weak, nonatomic) IBOutlet UITextView *txtViewDetail;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;


- (IBAction)btnCreateNewOffer:(id)sender;
- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message;
- (void)getOffersByWishItemId:(NSString *)wishItemId;
@end

NS_ASSUME_NONNULL_END
