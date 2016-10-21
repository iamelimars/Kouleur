//
//  AlbumsTableViewController.m
//  Kouleur
//
//  Created by iMac on 10/4/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import "AlbumsTableViewController.h"

@interface AlbumsTableViewController () 

@end

@implementation AlbumsTableViewController

static NSString * const AllPhotosReuseIdentifier = @"AllPhotosCell";
static NSString * const CollectionCellReuseIdentifier = @"CollectionCell";

static NSString * const AllPhotosSegue = @"showAllPhotos";
static NSString * const CollectionSegue = @"showCollection";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
    // Create a PHFetchResult object for each section in the table view.
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    PHFetchOptions *smartOption = [[PHFetchOptions alloc]init];
    smartOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:smartOption];
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    // Store the PHFetchResult objects and localized titles for each section.
    self.sectionFetchResults = @[allPhotos, smartAlbums, topLevelUserCollections];
    self.sectionLocalizedTitles = @[@"", NSLocalizedString(@"Smart Albums", @""), NSLocalizedString(@"Albums", @"")];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionFetchResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        // The "All Photos" section only ever has a single row.
        numberOfRows = 1;
    } else {
        PHFetchResult *fetchResult = self.sectionFetchResults[section];
        numberOfRows = fetchResult.count;
    }
    
    return numberOfRows;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:AllPhotosReuseIdentifier forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(@"All Photos", @"");
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13.0];
        //cell.textLabel.textColor = [UIColor blueColor];
        
    } else {
        
        PHFetchOptions *smartOption = [[PHFetchOptions alloc]init];
        smartOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
        //fetchResult = [PHAsset fetchAssetsWithOptions:smartOption];
        //PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:smartOption];
        
        PHCollection *collection = fetchResult[indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:CollectionCellReuseIdentifier forIndexPath:indexPath];
        cell.textLabel.text = collection.localizedTitle;
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13.0];
        //cell.textLabel.textColor = [UIColor blueColor];
    }
    
    return cell;

}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.sectionLocalizedTitles[section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(10, 8, self.view.frame.size.width - 20, 20);
    //myLabel.textAlignment = NSTextAlignmentRight;
    myLabel.font = [UIFont fontWithName:@"Avenir-MediumOblique" size:15.0];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Loop through the section fetch results, replacing any fetch results that have been updated.
        NSMutableArray *updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
        __block BOOL reloadRequired = NO;
        
        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            
            if (changeDetails != nil) {
                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
            }
        }];
        
        if (reloadRequired) {
            self.sectionFetchResults = updatedSectionFetchResults;
            [self.tableView reloadData];
        }
        
    });
}


#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
     Get the AAPLAssetGridViewController being pushed and the UITableViewCell
     that triggered the segue.
     */
    if (![segue.destinationViewController isKindOfClass:[PhotosViewController class]] || ![sender isKindOfClass:[UITableViewCell class]]) {
        return;
    }
    
    PhotosViewController *assetGridViewController = segue.destinationViewController;
    UITableViewCell *cell = sender;
    
    // Set the title of the AAPLAssetGridViewController.
    assetGridViewController.title = cell.textLabel.text;
    
    // Get the PHFetchResult for the selected section.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
    
    if ([segue.identifier isEqualToString:AllPhotosSegue]) {
        assetGridViewController.assetsFetchResults = fetchResult;
    } else if ([segue.identifier isEqualToString:CollectionSegue]) {
        // Get the PHAssetCollection for the selected row.
        PHCollection *collection = fetchResult[indexPath.row];
        if (![collection isKindOfClass:[PHAssetCollection class]]) {
            return;
        }
        
        // Configure the AAPLAssetGridViewController with the asset collection.
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        
        assetGridViewController.assetsFetchResults = assetsFetchResult;
        assetGridViewController.assetCollection = assetCollection;
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backToCamera:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
}
@end
