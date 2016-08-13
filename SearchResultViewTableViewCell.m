//
//  SearchResultViewTableViewCell.m
//  WheresMyFood
//


#import "SearchResultViewTableViewCell.h"

@implementation SearchResultViewTableViewCell

- (void)awakeFromNib {
    [self.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.contentView.layer setBorderWidth:1.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
