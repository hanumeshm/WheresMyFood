//
//  SearchViewController.m
//  WheresMyFood
//


#import "SearchViewController.h"
#import "Search.h"
#import "SearchResultViewTableViewCell.h"
#import "RestaurantViewController.h"
#import "AppDelegate.h"

@import GoogleMaps;

@interface SearchViewController () {
    GMSPlacePicker *placePicker;
}

@property (nonatomic) NSString *sortedBy;
@property (nonatomic) NSString *selectedLocation;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) UIActivityIndicatorView *activityView;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.title = @"Search for Restaurant";
    if (self) {
        self.tabBarItem.title = @"Search";
        self.tabBarItem.image = [UIImage imageNamed:@"search"];
        self.tabBarController.tabBar.translucent = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLoadingAnimation];
    [self setupSearchScreen];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to Get Your Location" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.locationManager.location
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                           if (error){
                               NSLog(@"Geocode failed with error: %@", error);
                               return;
                               
                           }
                           CLPlacemark *placemark = [placemarks objectAtIndex:0];
                           self.longitude = currentLocation.coordinate.longitude;
                           self.latitude = currentLocation.coordinate.latitude;
                           self.actlatitude = self.latitude;
                           self.actlongitude = self.longitude;
                           self.selectedLocation = placemark.locality;
                           [manager stopUpdatingLocation];
                           [self initiateSearch];
                       }];
    }
}

- (void)doneTouched:(UIBarButtonItem *)sender {
    [self.termField resignFirstResponder];
}

- (void) updateLocationandSearchwithLatitude: (double)latitude withLongitude: (double)longitude {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.locationManager.location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       self.longitude = longitude;
                       self.latitude = latitude;
                       self.selectedLocation = placemark.locality;
                       [self initiateSearch];
                   }];
}

- (void) initiateSearch {
    NSString *coord = [NSString stringWithFormat:@"%f,%f", self.latitude, self.longitude];
    NSString *temp = nil;
    if(![self.termField.text isEqualToString:@""])
        temp = self.termField.text;
    Search *search = [[Search alloc] init];
    if([self.sortedBy isEqualToString:@"relevance"]) {
        [search searchWithLocation:self.selectedLocation
                    currentLatLong:coord
                              term:temp
                              sort:YLPSortTypeBestMatched
                 completionHandler:^(NSDictionary *dict, NSError* error) {
                     self.dict = dict;
                     [self getBusinesses];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self stopLoadingAnimation];
                     });
                 }];
    } else {
        [search searchWithLocation:self.selectedLocation
                    currentLatLong:coord
                              term:temp
                              sort:YLPSortTypeDistance
                 completionHandler:^(NSDictionary *dict, NSError* error) {
                     self.dict = dict;
                     [self getBusinesses];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self stopLoadingAnimation];
                     });
                 }];
    }
    [self.termField resignFirstResponder];
}

- (IBAction)onClickSearch:(id)sender {
    [self startLoadingAnimation];
    if([self.selectedLocation isEqualToString:@"Current Location (change)"]) {
        [self updateLocationandSearchwithLatitude:self.longitude withLongitude:self.latitude];
    }
    else {
        [self initiateSearch];
    }
}

- (IBAction)onClickRelevance:(id)sender {
    if(![self.sortedBy isEqualToString:@"relevance"]) {
        self.relevanceButton.backgroundColor = [UIColor whiteColor];
        [self.relevanceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
        self.distanceButton.backgroundColor = [UIColor blackColor];
        [self.distanceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
        self.sortedBy = @"relevance";
        [self startLoadingAnimation];
        [self initiateSearch];
    }
}

- (IBAction)onClickDistance:(id)sender {
    if(![self.sortedBy isEqualToString:@"distance"]) {
        self.relevanceButton.backgroundColor = [UIColor blackColor];
        [self.relevanceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
        self.distanceButton.backgroundColor = [UIColor whiteColor];
        [self.distanceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
        self.sortedBy = @"distance";
        [self startLoadingAnimation];
        [self initiateSearch];
    }
}

- (IBAction)getLocation:(id)sender {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.actlatitude, self.actlongitude);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            [self.locationButton setTitle:place.formattedAddress forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
            if(place.formattedAddress == nil) {
                 [self.locationButton setTitle:@"Current Location (change)" forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
                self.longitude = self.actlongitude;
                self.latitude = self.actlatitude;
            } else {
                self.selectedLocation = place.formattedAddress;
                self.latitude = place.coordinate.latitude;
                self.longitude = place.coordinate.longitude;
            }
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.businesses count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultViewTableViewCell *cell = (SearchResultViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchResultViewTableViewCell" forIndexPath:indexPath];
    cell.businessName.text = [self.businesses objectAtIndex:indexPath.row][@"name"];
    NSString *ratingURL = [self.businesses objectAtIndex:indexPath.row][@"rating_img_url_small"];
    cell.ratingImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ratingURL]]];
    NSString *imageURL  = [self.businesses objectAtIndex:indexPath.row][@"image_url"];
    cell.businessImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    NSDictionary *location = [self.businesses objectAtIndex:indexPath.row][@"location"];
    NSArray *addressInfo = (NSArray *) location[@"display_address"];
    cell.address1.text = [addressInfo objectAtIndex:0];
//    if([addressInfo count] >= 4) {
//        cell.address2.text = [addressInfo objectAtIndex:1];
//        cell.address3.text = [addressInfo objectAtIndex:2];
//        cell.address4.text = [addressInfo objectAtIndex:3];
//    }
    if([addressInfo count] >= 3) {
        cell.address2.text = [addressInfo objectAtIndex:1];
        cell.address3.text = [addressInfo objectAtIndex:2];
        cell.address4.text = @"";
    }
    else if([addressInfo count] >= 2) {
        cell.address2.text = [addressInfo objectAtIndex:1];
        cell.address3.text = @"";
        cell.address4.text = @"";
    }
    else {
        cell.address2.text = @"";
        cell.address3.text = @"";
        cell.address4.text = @"";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    del.curInd = (int) indexPath.row;
    RestaurantViewController *restaurantViewController = [[RestaurantViewController alloc] initWithNibName:@"RestaurantViewController" bundle:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    restaurantViewController.restaurantDetail = [self.businesses objectAtIndex:indexPath.row];
    restaurantViewController.isFavoriteInfo = NO;
    [self.navigationController pushViewController:restaurantViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void) getBusinesses {
    self.businesses = [[NSMutableArray alloc] init];
    
    for (NSDictionary *business in self.dict[@"businesses"]) {
        [self.businesses addObject:business];
    }
    
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    del.restaurantList = self.businesses;
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.businesses count] == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Huh Oh..." message:@"There is no place to eat near your location!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            self.searchResults.hidden = YES;
            self.emptyResultsLabel.hidden = NO;
        }
        else {
            [self.searchResults reloadData];
            self.emptyResultsLabel.hidden = YES;
            self.searchResults.hidden = NO;
        }
    });
}

-(void) setupSearchScreen {

    // Design Setup
    self.navigationController.navigationBar.barTintColor =  [UIColor blackColor]; //[UIColor colorWithRed:0.30 green:0.03 blue:0.48 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.view.backgroundColor = [UIColor colorWithRed:0.24 green:0.52 blue:0.78 alpha:1.0];

    self.emptyResultsLabel.textColor = [UIColor whiteColor];

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    // the left and middle buttons are to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                       doneButton, nil]];

    //Adding Done button to keypad.
    self.termField.inputAccessoryView = toolBar;
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.frame = CGRectMake(0,0 ,5, self.termField.frame.size.height);
    self.termField.leftViewMode = UITextFieldViewModeAlways;
    self.termField.leftView = imageView1;

    self.locationButton.backgroundColor = [UIColor blackColor];
    [self.locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    self.locationButton.backgroundColor = [UIColor blackColor];
    self.locationButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.locationButton.layer.shadowRadius = 2.0f;
    self.locationButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.locationButton.layer.shadowOpacity = 1.0f;
    self.locationButton.layer.masksToBounds = NO;
    
    self.searchButton.backgroundColor = [UIColor blackColor];
    self.searchButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.searchButton.layer.shadowRadius = 2.0f;
    self.searchButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.searchButton.layer.shadowOpacity = 1.0f;
    self.searchButton.layer.masksToBounds = NO;
    
    self.sortByLabel.textColor = [UIColor whiteColor];

    self.relevanceButton.backgroundColor = [UIColor whiteColor];
    [self.relevanceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    self.relevanceButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.relevanceButton.layer.shadowRadius = 1.0f;
    self.relevanceButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.relevanceButton.layer.shadowOpacity = 1.0f;
    self.relevanceButton.layer.masksToBounds = NO;
    
    self.distanceButton.backgroundColor = [UIColor blackColor];
    [self.distanceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    self.distanceButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.distanceButton.layer.shadowRadius = 1.0f;
    self.distanceButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.distanceButton.layer.shadowOpacity = 1.0f;
    self.distanceButton.layer.masksToBounds = NO;
    
    self.searchResults.delegate = self;
    self.searchResults.dataSource = self;
    self.searchResults.alwaysBounceVertical = NO;

    self.sortedBy = @"relevance";

    [self.searchResults registerNib:[UINib nibWithNibName:@"SearchResultViewTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"SearchResultViewTableViewCell"];
    self.searchResults.hidden = YES;
}

@end
