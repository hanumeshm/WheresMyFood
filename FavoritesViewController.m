//
//  FavoritesViewController.m
//  WheresMyFood
//


#import "FavoritesViewController.h"
#import "AppDelegate.h"
#import "SearchResultViewTableViewCell.h"
#import "RestaurantViewController.h"

@interface FavoritesViewController () {
    AppDelegate *del;
}

@property (nonatomic) UIActivityIndicatorView *activityView;

@end

@implementation FavoritesViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.title = @"Favorites";
    if (self) {
        self.tabBarItem.title = @"Favorites";
        self.tabBarItem.image = [UIImage imageNamed:@"star"];
        self.tabBarController.tabBar.translucent = NO;
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    del = [[UIApplication sharedApplication] delegate];
    [super viewDidAppear:animated];
    [self startLoadingAnimation];
    [self loadTableView];
    [self stopLoadingAnimation];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self startLoadingAnimation];
    [self setFavoritesScreen];
    [self stopLoadingAnimation];
}

- (void) didReceiveMemoryWarning {
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

- (void) setFavoritesScreen {
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];//[UIColor colorWithRed:0.30 green:0.03 blue:0.48 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor colorWithRed:0.69 green:0.60 blue:0.97 alpha:1.0];
    [self.favoritesView registerNib:[UINib nibWithNibName:@"SearchResultViewTableViewCell" bundle:nil]
             forCellReuseIdentifier:@"SearchResultViewTableViewCell"];
    self.favoritesView.delegate = self;
    self.favoritesView.dataSource = self;
    [self loadTableView];
}

- (void) loadTableView {
    if([del restaurantsCount] == 0) {
        self.favoritesView.hidden = YES;
        self.emptyLabel.hidden = NO;
    }
    else {
        self.favoritesView.hidden = NO;
        self.emptyLabel.hidden = YES;
    }
    [self.favoritesView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [del restaurantsCount];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *restaurant = [del restaurantAtIndex:indexPath.row];
    SearchResultViewTableViewCell *cell = (SearchResultViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchResultViewTableViewCell" forIndexPath:indexPath];
    cell.businessName.text = restaurant[@"name"];
    NSString *ratingURL = restaurant[@"rating_img_url_small"];
    cell.ratingImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ratingURL]]];
    NSString *imageURL  = restaurant[@"image_url"];
    cell.businessImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    NSDictionary *location = restaurant[@"location"];
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
    RestaurantViewController *restaurantViewController = [[RestaurantViewController alloc] initWithNibName:@"RestaurantViewController" bundle:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    del.curFavoriteInd = (int) indexPath.row;
    NSMutableDictionary *restaurant = [del restaurantAtIndex:indexPath.row];
    restaurantViewController.restaurantDetail = restaurant;
    restaurantViewController.isFavoriteInfo = YES;
    [self.navigationController pushViewController:restaurantViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


@end
