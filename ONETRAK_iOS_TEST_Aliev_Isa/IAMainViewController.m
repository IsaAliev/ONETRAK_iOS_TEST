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

NSString* const dailyResultCellIdentifier = @"dailyResultCell";
NSString* const goalReachedCellIdentifier = @"goalReachedCell";

@interface IAMainViewController ()

@property (strong, nonatomic) NSFetchedResultsController<IADailyResult *> *fetchedResultsController;

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
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
        [[IADataManager sharedManager] insertNewResultOnError:^(NSError *error) {

            [IAErrorPresenter showErrorWithMessage:error.localizedDescription];
            
        }];
    }
}


#pragma mark - Table View

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Определяем превышена ли цель. Если да, то возвращаем 2 для отображения двух ячеек в секции
    IADailyResult* result = [[self.fetchedResultsController fetchedObjects] objectAtIndex:section];
    return result.walkCount + result.aerobicCount + result.runCount > result.target ? 2 : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        IADailyResultInformationCell *cell = (IADailyResultInformationCell*)[tableView dequeueReusableCellWithIdentifier:dailyResultCellIdentifier forIndexPath:indexPath];
        
        IADailyResult *result = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        cell.dailyResult = result;
        
        return cell;
        
    } else {
        
        IADailyResultCompletedCell* cell = (IADailyResultCompletedCell*)[tableView dequeueReusableCellWithIdentifier:goalReachedCellIdentifier forIndexPath:indexPath];

        [cell animateStar];
        
        return cell;
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController<IADailyResult *> *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<IADailyResult *> *fetchRequest = IADailyResult.fetchRequest;
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    // Ставим в качестве sectionNameKeyPath поле timestamp, так как оно является уникальным для любого объекта, что дает возможность образовать секции вместо рядов
    NSFetchedResultsController<IADailyResult *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[IADataManager sharedManager].persistentContainer.viewContext sectionNameKeyPath:@"timestamp" cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        
        [IAErrorPresenter showErrorWithMessage:error.localizedDescription];
        
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        default: break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
