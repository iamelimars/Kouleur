//
//  PhotosViewController.h
//  Kouleur
//
//  Created by iMac on 10/4/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosCell.h"
#import "ConfirmViewController.h"
@import Photos;
@import PhotosUI;

@interface PhotosViewController : UICollectionViewController <PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@end
