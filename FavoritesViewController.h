//
//  FavoritesViewController.h
//  WheresMyFood
//


#import <UIKit/UIKit.h>

@interface FavoritesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *favoritesView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;

@end
