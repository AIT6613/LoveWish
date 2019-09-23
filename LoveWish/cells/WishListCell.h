//
//  WishListCell.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 17/9/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WishListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UILabel *txtViewDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewItem;


@end

NS_ASSUME_NONNULL_END
