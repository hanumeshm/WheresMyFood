//
//  SearchResultViewTableViewCell.h
//  WheresMyFood
//


#import <UIKit/UIKit.h>

@interface SearchResultViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *businessImage;
@property (weak, nonatomic) IBOutlet UILabel *businessName;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *address1;
@property (weak, nonatomic) IBOutlet UILabel *address2;
@property (weak, nonatomic) IBOutlet UILabel *address3;
@property (weak, nonatomic) IBOutlet UILabel *address4;


@end
