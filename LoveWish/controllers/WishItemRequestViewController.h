//
//  WishItemRequestViewController.h
//  LoveWish
//
//  Created by 6613 on 10/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewCell.h"
@import Firebase;


NS_ASSUME_NONNULL_BEGIN

@interface WishItemRequestViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *imgData;
@property NSMutableArray *imgDataItem;

@property FIRFirestore *db;
@property FIRUser *firebaseUser;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtDetail;
@property (weak, nonatomic) IBOutlet UITableView *imageTableView;

- (IBAction)btnAddImage:(id)sender;
- (IBAction)btnSave:(id)sender;

-(void)saveImage: (NSString *) wishItemId;

@end

NS_ASSUME_NONNULL_END
