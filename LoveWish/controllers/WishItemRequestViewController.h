//
//  WishItemRequestViewController.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 17/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "ViewController.h"
#import "WishListCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface WishItemRequestViewController : ViewController <UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *data;
@property NSMutableArray *offerItem;
@property NSNumber *isNew;

@property (strong, nonatomic) IBOutlet UILabel *lblItemName;

@property (weak, nonatomic) IBOutlet UITextView *txtViewDetail;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *imageTableView;


- (IBAction)lblCreateNewOffer:(id)sender;

@end

NS_ASSUME_NONNULL_END
