//
//  IAMainViewController.m
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import "IAMainViewController.h"
#import "IADataManager.h"
#import "IASegmentedView.h"
#import "Constants.h"
#import "IADailyResultInformationCell.h"
#import "IADailyResultCompletedCell.h"

NSUInteger const fetchSize = 10;
NSString* const dailyResultCellIdentifier = @"dailyResultCell";
NSString* const goalReachedCellIdentifier = @"goalReachedCell";

@interface IAMainViewController ()

@property (strong, nonatomic) NSMutableArray* dailyResults;
@property (assign, nonatomic) NSUInteger newOffset;
@property (assign, nonatomic) BOOL isAllLoaded;


@end

@implementation IAMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_plus"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(insertNewObject:)];
    UIBarButtonItem* aimButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_aim"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(setTarget:)];
    
    self.navigationItem.leftBarButtonItem = aimButton;
    self.navigationItem.rightBarButtonItem = addButton;

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    _dailyResults = [[IADataManager sharedManager] fetchResultsOfSize:fetchSize withOffset:0].mutableCopy;
    self.newOffset += fetchSize;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadResults {
    
    NSArray* loadedResults = [[IADataManager sharedManager] fetchResultsOfSize:fetchSize withOffset:self.newOffset];
    
    if (loadedResults.count == 0) {
        _isAllLoaded = TRUE;
        return;
    }
    
    NSMutableIndexSet* indexSet = [NSMutableIndexSet indexSet];
    
    for (int i = (int)_dailyResults.count; i < _dailyResults.count + loadedResults.count; i++) {
        [indexSet addIndex:i];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_dailyResults addObjectsFromArray:loadedResults];
        
        [self.tableView beginUpdates];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        self.newOffset += fetchSize;
    });
    
    
}


#pragma mark Actions

-(void)setTarget:(id)sender {
    
    UIAlertController* aimInputVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"New aim", @"new aim") message:NSLocalizedString(@"Enter your aim for the near future", @"input view message") preferredStyle:UIAlertControllerStyleAlert];
    [aimInputVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = NSLocalizedString(@"Aim", @"aim input placeholder");
    }];
    [aimInputVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSInteger target = aimInputVC.textFields.firstObject.text.integerValue;
        
        if (!(target > 0)) {
            [self setTarget:nil];
        }
        
        [[IADataManager sharedManager] setTargetSteps:target];
        
    }]];
    
    [aimInputVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:aimInputVC animated:YES completion:nil];
    
}

- (void)insertNewObject:(id)sender {
    
    if([[IADataManager sharedManager] getTargetSteps] == NoTargetStepsDefined) {
        
        UIAlertController* warningVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"An aim needed", @"") message:NSLocalizedString(@"Please, enter your aim firstly", @"") preferredStyle:UIAlertControllerStyleAlert];
        [warningVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Enter an aim", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setTarget:nil];
        }]];
        
        [self presentViewController:warningVC animated:YES completion:nil];
        
    } else {
    
        IADailyResult* newResult = [[IADataManager sharedManager] insertNewResultOnError:^(NSError *error) {

            [IAErrorPresenter showErrorWithMessage:error.localizedDescription];
            
        }];

        [_dailyResults insertObject:newResult atIndex:0];
        
        [self.tableView beginUpdates];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
    }
}


#pragma mark - Table View

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.dailyResults.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Определяем превышена ли цель. Если да, то возвращаем 2 для отображения двух ячеек в секции
    
    IADailyResult* result =  [self.dailyResults objectAtIndex:section];
    
    return result.walkCount + result.aerobicCount + result.runCount > result.target ? 2 : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        IADailyResultInformationCell *cell = (IADailyResultInformationCell*)[tableView dequeueReusableCellWithIdentifier:dailyResultCellIdentifier forIndexPath:indexPath];
        
        IADailyResult *result = [self.dailyResults objectAtIndex:indexPath.section];
        cell.dailyResult = result;
        
        if (indexPath.section == _dailyResults.count - 1 && !_isAllLoaded) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self loadResults];
            });
            
        }
        
        return cell;
        
    } else {
        
        IADailyResultCompletedCell* cell = (IADailyResultCompletedCell*)[tableView dequeueReusableCellWithIdentifier:goalReachedCellIdentifier forIndexPath:indexPath];

        [cell animateStar];
        
        return cell;
    }
}



@end
