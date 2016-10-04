//
//  ConfirmViewController.h
//  Kouleur
//
//  Created by iMac on 10/4/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditingViewController.h"
@import Photos;

@interface ConfirmViewController : UIViewController <PHPhotoLibraryChangeObserver>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
