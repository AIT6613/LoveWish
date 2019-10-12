//
//  OfferViewController.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 3/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface OfferViewController : ViewController
<UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *offerData;
@property NSMutableArray *imageData;
@property NSMutableArray *imageItem;

@property int isNew;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UITableView *imageTableView;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;


- (IBAction)btnSave:(id)sender;
- (IBAction)btnAddImageClick:(id)sender;


@end

NS_ASSUME_NONNULL_END
