//
//  ImageViewCell.h
//  LoveWish
//
//  Created by Anirut Puangkingkaew on 3/10/19.
//  Copyright © 2019 AIT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgBox;
@property (weak, nonatomic) IBOutlet UILabel *lblName;


@end

NS_ASSUME_NONNULL_END
