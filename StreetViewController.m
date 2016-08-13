//
//  StreetViewController.m
//  WheresMyFood


#import "StreetViewController.h"

@import GoogleMaps;

@interface StreetViewController ()

@end

@implementation StreetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@" < Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [barButton setTintColor:[UIColor whiteColor]];
    [barButton setTarget:self];
    [barButton setAction:@selector(navigateBack)];
    self.navigationItem.leftBarButtonItem = barButton;
    GMSPanoramaView *panoView = [[GMSPanoramaView alloc] initWithFrame:CGRectZero];
    self.view = panoView;
    [panoView moveNearCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigateBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
