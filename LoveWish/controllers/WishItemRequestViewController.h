//
//  WishItemRequestViewController.h
//  LoveWish
//
//  Created by 6613 on 10/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewCell.h"
#import <Photos/Photos.h>
@import Firebase;


NS_ASSUME_NONNULL_BEGIN

@interface WishItemRequestViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *imgData;
@property NSMutableArray *imgDataItem;

@property FIRFirestore *db;
@property FIRUser *firebaseUser;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITableView *imageTableView;
@property (weak, nonatomic) IBOutlet UITextView *txtDetail;


- (IBAction)btnAddImage:(id)sender;
- (IBAction)btnSave:(id)sender;

-(void)saveImage: (NSString *) wishItemId;
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
- (void)displayAlertWith:(NSString *)title andMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
