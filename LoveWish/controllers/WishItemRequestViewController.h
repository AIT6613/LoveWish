//
//  WishItemRequestViewController.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 17/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WishItemRequestViewController : ViewController

@property NSMutableArray *data;

@property (strong, nonatomic) IBOutlet UILabel *lblItemName;

@property (weak, nonatomic) IBOutlet UITextView *txtViewDetail;


@end

NS_ASSUME_NONNULL_END
