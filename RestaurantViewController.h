//
//  RestaurantViewController.h
//  WheresMyFood
//


#import <UIKit/UIKit.h>

@interface RestaurantViewController : UIViewController

@property (weak, nonatomic) NSDictionary *restaurantDetail;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UIImageView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *noOfRatings;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *address1;
@property (weak, nonatomic) IBOutlet UILabel *address2;
@property (weak, nonatomic) IBOutlet UILabel *address3;
@property (weak, nonatomic) IBOutlet UILabel *address4;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *snippetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *snippetImage;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
- (IBAction)toggleFavorite:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *streetView;
- (IBAction)getStreetView:(id)sender;
@property bool isFavoriteInfo;

@end
