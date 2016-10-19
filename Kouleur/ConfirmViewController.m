//
//  ConfirmViewController.m
//  Kouleur
//
//  Created by iMac on 10/4/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import "ConfirmViewController.h"

@interface ConfirmViewController ()

@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    if (self.asset == nil) {
        NSLog(@"no asset");
    } else {
        
        
        [self updateStaticImage];
    }
    
}
-(void)dealloc {
    
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateStaticImage {
    // Prepare the options to pass when fetching the live photo.
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
       
    };
    
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:[self targetSize] contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        // Hide the progress view now the request has completed.
        
        // Check if the request was successful.
        if (!result) {
            NSLog(@"noImage");
            return;
            
        }
        
        // Show the UIImageView and use it to display the requested image.
        self.imageView.image = result;
    }];
}

- (CGSize)targetSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(CGRectGetWidth(self.imageView.bounds) * scale, CGRectGetHeight(self.imageView.bounds) * scale);
    return targetSize;
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        // Check if there are changes to the asset we're displaying.
        PHObjectChangeDetails *changeDetails = [changeInstance changeDetailsForObject:self.asset];
        if (changeDetails == nil) {
            return;
        }
        
        // Get the updated asset.
        self.asset = [changeDetails objectAfterChanges];
        
        // If the asset's content changed, update the image and stop any video playback.
        if ([changeDetails assetContentChanged]) {
            [self updateStaticImage];
            
        }
    });
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[EditingViewController class]]) {
        EditingViewController *editingViewController = segue.destinationViewController;
        editingViewController.editingImage = self.imageView.image;
    }
    

}


@end
