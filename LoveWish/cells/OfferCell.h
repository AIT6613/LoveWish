//
//  OfferCell.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 3/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OfferCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewOffer;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;


@end

NS_ASSUME_NONNULL_END
