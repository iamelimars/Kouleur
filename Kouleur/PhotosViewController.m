//
//  PhotosViewController.m
//  Kouleur
//
//  Created by iMac on 10/4/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import "PhotosViewController.h"
//#import "UICollectionView+Convenience.h"


@interface PhotosViewController ()

@end

@implementation PhotosViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const CellreuseIdentifier = @"Cell";
static CGSize AssetGridThumbnailSize;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
        
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);

    
}
- (void)awakeFromNib {
    self.imageManager = [[PHCachingImageManager alloc] init];
    //[self resetCachedAssets];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
}
- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsFetchResults.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    //self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    //self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    // Dequeue an AAPLGridViewCell.
    PhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellreuseIdentifier forIndexPath:indexPath];
    cell.representedAssetIdentifier = asset.localIdentifier;
    cell.backgroundColor = [UIColor blackColor];
    
    // Add a badge to the cell if the PHAsset represents a Live Photo.
    if (asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
        // Add Badge Image to the cell to denote that the asset is a Live Photo.
        
    }
    
    // Request an image for the asset from the PHCachingImageManager.
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  // Set the cell's thumbnail image if it's still showing the same asset.
                                  if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                      cell.thumbnailImage = result;
                                  }
                              }];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int viewWidth = CGRectGetWidth(self.view.frame)/3;
    return CGSizeMake(viewWidth, viewWidth);
}



#pragma mark - PHPhotoLibraryChangeObserver
/*
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // Check if there are changes to the assets we are showing.
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    
 
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
 
    dispatch_async(dispatch_get_main_queue(), ^{
        // Get the new fetch result.
        
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        
        UICollectionView *collectionView = self.collectionView;
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            // Reload the collection view if the incremental diffs are not available
            [collectionView reloadData];
            
        } else {
            /*
             Tell the collection view to animate insertions and deletions if we
             have incremental diffs.
 
            [collectionView performBatchUpdates:^{
                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                if ([removedIndexes count] > 0) {
                    [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                if ([insertedIndexes count] > 0) {
                    [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                if ([changedIndexes count] > 0) {
                    [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
            } completion:NULL];
        }
        
        [self resetCachedAssets];
    });
}

#pragma mark - Asset Caching

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
 
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}
*/
- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    
    return assets;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[ConfirmViewController class]]) {
        ConfirmViewController *confirmViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        confirmViewController.asset = self.assetsFetchResults[indexPath.item];
        confirmViewController.assetCollection = self.assetCollection;
    }
    
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
