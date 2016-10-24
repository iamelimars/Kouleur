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
//#import "cameraFocusSquaree.h"
#import "EditingViewController.h"
#import "IntroViewController.h"
#import "CamViewController.h"
@import AVFoundation;
@import AssetsLibrary;
@import Photos;
@import CoreGraphics;


@interface ViewController : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *picker;
    UIImage *images;
    
}
@property (weak, nonatomic) IBOutlet UIView *introView;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIScrollView *MainScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *CameraScollView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIView *cameraButtonView;
- (IBAction)cameraButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *flipCameraButton;
- (IBAction)flipCameraPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;
- (IBAction)selectPhotoButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
- (IBAction)yesButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
- (IBAction)flashButtonPressed:(id)sender;

@property (strong, nonatomic) CamViewController *view2;

@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDevice *device;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong) UIImageView *firstImage;
@property(nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic, retain) CALayer *rootLayer;
@property(weak, nonatomic) NSString *cameraPosition;
@property(nonatomic, assign) BOOL imageTaken;
//@property(weak, nonatomic) cameraFocusSquaree *camFocus;
@property (nonatomic, retain) UIView *focusSquare;
@property (nonatomic) CGPoint point;
@property(weak, nonatomic) NSTimer *fadeInFocus;
@property(weak, nonatomic) NSTimer *fadeOutFocus;



@end

