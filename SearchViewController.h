//
//  SearchViewController.h
//  WheresMyFood
//

#import <UIKit/UIKit.h>
#import <YelpAPI/YLPBusiness.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double actlatitude;
@property (nonatomic) double actlongitude;
@property (nonatomic) NSDictionary *dict;
@property (nonatomic) NSMutableArray<NSDictionary *> *businesses;

@property (weak, nonatomic) IBOutlet UITextField *termField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *relevanceButton;
@property (weak, nonatomic) IBOutlet UIButton *distanceButton;
@property (weak, nonatomic) IBOutlet UITableView *searchResults;
@property (weak, nonatomic) IBOutlet UILabel *emptyResultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sortByLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

- (IBAction)getLocation:(id)sender;
- (IBAction)onClickSearch:(id)sender;
- (IBAction)onClickRelevance:(id)sender;
- (IBAction)onClickDistance:(id)sender;


-(void) getBusinesses;

@end
