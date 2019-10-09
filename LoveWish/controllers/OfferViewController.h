//
//  OfferViewController.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 3/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "ViewController.h"
#import "WishListCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface OfferViewController : ViewController
<UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *data;
@property NSMutableArray *offerItem;

@property int isNew;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UITableView *imageTableView;


- (IBAction)btnSave:(id)sender;


@end

NS_ASSUME_NONNULL_END
