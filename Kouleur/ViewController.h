//
//  ViewController.h
//  Kouleur
//
//  Created by iMac on 9/7/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
@import AVFoundation;
@import AssetsLibrary;
@import Photos;
@import CoreGraphics;


@interface ViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *introView;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIScrollView *MainScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *CameraScollView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIView *cameraButtonView;
- (IBAction)cameraButtonPressed:(id)sender;

@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDevice *device;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong) UIImageView *firstImage;
@property(nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic, retain) CALayer *rootLayer;
@property(weak, nonatomic) NSString *cameraPosition;
@property(nonatomic, assign) BOOL *imageTaken;

@end

