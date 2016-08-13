//
//  RestaurantViewController.m
//  WheresMyFood


#import "RestaurantViewController.h"
#import "AppDelegate.h"
#import "StreetViewController.h"

@import GoogleMaps;

@interface RestaurantViewController () {
    AppDelegate *del;
}

@property bool isFavorite;
@property (nonatomic) UIActivityIndicatorView *activityView;

@end

@implementation RestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightRecognizer];
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    
    [self.view addGestureRecognizer:leftRecognizer];
    [self startLoadingAnimation];
    [self setupRestaurantDetailScreen];
    [self setValues];
    [self stopLoadingAnimation];
}

- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    if(self.isFavoriteInfo)
        del.curFavoriteInd--;
    else
        del.curInd--;
    [self navigateBack];
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    if(self.isFavoriteInfo ) {
        if (del.curFavoriteInd + 1 == [del restaurantsCount]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"End of List" message:@"You have reached the end of list" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            RestaurantViewController *viewController = [[RestaurantViewController alloc] initWithNibName:@"RestaurantViewController" bundle:nil];
            del.curFavoriteInd++;
            viewController.restaurantDetail = [del restaurantAtIndex:del.curFavoriteInd];
            viewController.isFavoriteInfo = self.isFavoriteInfo;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else {
        if (del.curInd + 1 == [del.restaurantList count]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"End of List" message:@"You have reached the end of list" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            RestaurantViewController *viewController = [[RestaurantViewController alloc] initWithNibName:@"RestaurantViewController" bundle:nil];
            del.curInd++;
            viewController.restaurantDetail = [del.restaurantList objectAtIndex:del.curInd];
            viewController.isFavoriteInfo = self.isFavoriteInfo;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([del isFavoriteRestaurant:self.restaurantDetail[@"id"]]) {
        self.isFavorite = YES;
        [self.favoriteButton setImage:[self imageNamed:@"fav" withColor:[UIColor redColor]] forState:UIControlStateNormal];
    }
    else {
        self.isFavorite = NO;
        [self.favoriteButton setImage:[self imageNamed:@"fav" withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)startLoadingAnimation {
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 381, 554)];
    [self.activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
}

- (void)stopLoadingAnimation {
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
}

- (void)setValues {
    NSDictionary *locationInfo = self.restaurantDetail[@"location"];
    NSDictionary *coordinate = locationInfo[@"coordinate"];
    double longitude = [coordinate[@"longitude"] doubleValue];
    double latitude = [coordinate[@"latitude"] doubleValue];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:14];
    GMSMapView *map = [GMSMapView mapWithFrame:self.mapView.bounds camera:camera];
    [map.settings setAllGesturesEnabled:NO];
    map.buildingsEnabled = YES;
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:coord];
    marker.map = map;
    [self.mapView addSubview:map];
    
    self.restaurantName.text = self.restaurantDetail[@"name"];

    NSString *ratingURL = self.restaurantDetail[@"rating_img_url_large"];
    self.ratingView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ratingURL]]];

    self.noOfRatings.text = [NSString stringWithFormat:@"%d Ratings", (int)self.restaurantDetail[@"review_count"]];

    NSArray *addressInfo = (NSArray *) locationInfo[@"display_address"];
    self.address1.text = [addressInfo objectAtIndex:0];
    if([addressInfo count] >= 3) {
        self.address2.text = [addressInfo objectAtIndex:1];
        self.address3.text = [addressInfo objectAtIndex:2];
        self.address4.text = @"";
    }
    else if([addressInfo count] >= 2) {
        self.address2.text = [addressInfo objectAtIndex:1];
        self.address3.text = @"";
        self.address4.text = @"";
    }
    else {
        self.address2.text = @"";
        self.address3.text = @"";
        self.address4.text = @"";
    }
    
    NSString *phone = [NSString stringWithFormat:@"%@", self.restaurantDetail[@"phone"]];
    if(phone)
        self.phoneNumber.text = phone;
    else
        self.phoneNumber.text = @"Not Available";
    
    NSString *snippetURL = self.restaurantDetail[@"snippet_image_url"];
    self.snippetImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:snippetURL]]];
    self.snippetLabel.text = self.restaurantDetail[@"snippet_text"];
    [self.snippetLabel setNumberOfLines:0];
    [self.snippetLabel sizeToFit];
}

- (void)setupRestaurantDetailScreen {
    del = [[UIApplication sharedApplication] delegate];
    self.title = @"Restaurant Detail";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.streetView setBackgroundColor:[UIColor blackColor]];
    [self.streetView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    self.streetView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.streetView.layer.shadowRadius = 1.0f;
    self.streetView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.streetView.layer.shadowOpacity = 1.0f;
    self.streetView.layer.masksToBounds = NO;

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@" < Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [barButton setTintColor:[UIColor whiteColor]];
    [barButton setTarget:self];
    [barButton setAction:@selector(navigateBack)];
    self.navigationItem.leftBarButtonItem = barButton;
    self.mapView.layer.borderColor = [UIColor blackColor].CGColor;
    self.mapView.layer.borderWidth = 1.0f;
    [self.favoriteButton setImage:[self imageNamed:@"fav" withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    self.favoriteButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.favoriteButton.layer.shadowRadius = 2.0f;
    self.favoriteButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.favoriteButton.layer.shadowOpacity = 1.0f;
    self.favoriteButton.layer.masksToBounds = NO;
    self.isFavorite = NO;
    if([del isFavoriteRestaurant:self.restaurantDetail[@"id"]]) {
        self.isFavorite = YES;
        [self.favoriteButton setImage:[self imageNamed:@"fav" withColor:[UIColor redColor]] forState:UIControlStateNormal];
    }
}

- (IBAction)toggleFavorite:(id)sender {
    if(self.isFavorite) {
        self.isFavorite = NO;
        [self.favoriteButton setImage:[self imageNamed:@"fav" withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [del removeRestaurantusingID:self.restaurantDetail[@"id"]];
        
    }
    else {
        self.isFavorite = YES;
        [self.favoriteButton setImage:[self imageNamed:@"fav" withColor:[UIColor redColor]] forState:UIControlStateNormal];
        [del addRestaurantusingDictionary:self.restaurantDetail];
    }
}

- (void) navigateBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage*) imageNamed:(NSString *) name withColor:(UIColor *) color {
    UIImage *source = [UIImage imageNamed:name];
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImg;
}

- (IBAction)getStreetView:(id)sender {
    NSDictionary *locationInfo = self.restaurantDetail[@"location"];
    NSDictionary *coordinate = locationInfo[@"coordinate"];
    double longitude = [coordinate[@"longitude"] doubleValue];
    double latitude = [coordinate[@"latitude"] doubleValue];
    StreetViewController *viewController = [[StreetViewController alloc] initWithNibName:@"StreetViewController" bundle:nil];
    viewController.latitude = latitude;
    viewController.longitude = longitude;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
