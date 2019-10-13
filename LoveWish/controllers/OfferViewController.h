//
//  OfferViewController.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 3/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewCell.h"
#import <Photos/Photos.h>
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface OfferViewController : ViewController
<UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *offerData;
@property NSMutableArray *wishItemData;
@property NSMutableArray *imageData;
@property NSMutableArray *imageItem;
@property NSString *isCreateNewOffer;

@property FIRFirestore *db;
@property FIRUser *firebaseUser;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UITableView *imageTableView;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnAddImage;



- (IBAction)btnSave:(id)sender;
- (IBAction)btnAddImageClick:(id)sender;

- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message;
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
- (void)getAllImageByOfferId:(NSString *)offerId;
- (void)deleteWishItemById:(NSString *)id;

- (void)saveImage: (NSString *) offerId;

@end

NS_ASSUME_NONNULL_END
