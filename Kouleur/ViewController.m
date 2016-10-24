//
//  ViewController.m
//  Kouleur
//
//  Created by iMac on 9/7/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



@end

const float squareLength = 80.0f;

@implementation ViewController

@synthesize cameraPosition, focusSquare, view2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.MainScrollView.delegate = self;
//    CGRect scrollFrame;
//    scrollFrame.origin = self.MainScrollView.frame.origin;
//    scrollFrame.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2);
//    self.MainScrollView.frame = scrollFrame;
//    self.introView.frame = CGRectMake(self.introView.frame.origin.x, self.introView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//    self.cameraView.frame = CGRectMake(self.introView.frame.origin.x, self.introView.frame.origin.y + self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
//    //[self.introView setFrame:self.view.frame];
//    NSLog(@"%f", self.MainScrollView.frame.size.height);
//    [self.cameraView setFrame:self.view.frame];
    [self setImagePickerButton];
    
    IntroViewController *view1 = [[IntroViewController alloc]initWithNibName:@"IntroViewController" bundle:nil];
    view2 = [[CamViewController alloc]initWithNibName:@"CamViewController" bundle:nil];
    

    
    //Add UIVC's to scroll view
    [self addChildViewController:view1];
    [self.MainScrollView addSubview:view1.view];
    [view1 didMoveToParentViewController:self];
    
    [self addChildViewController:view2];
    [self.MainScrollView addSubview:view2.view];
    [view2 didMoveToParentViewController:self];
    
    [view2.selectButton addTarget:self action:@selector(toAlbumsView) forControlEvents:UIControlEventTouchDown];
    [view2.flashCameraButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [view2.cancelPhotoButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [view2.yesPhotoButton addTarget:self action:@selector(yesButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [view2.cameraPhotoButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [view2.flipButton addTarget:self action:@selector(flipCameraPressed:) forControlEvents:UIControlEventTouchDown];

    
    
    CGRect V2Frame = view2.view.frame;
    V2Frame.origin.y = self.view.frame.size.height;
    //V2Frame.origin.x = 0;
    view2.view.frame = V2Frame;
    
    
    //set scroll view content size
    self.MainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2);

    
}
//-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
//    
//    /*
//    NSLog(@"focus1");
//        CGPoint touchPoint = [recognizer locationInView:[recognizer.view superview]];
//        //focusLayer.frame = CGRectMake((touchPoint.x-25), (touchPoint.y-25), 50, 50);
//    
//        
//        if (self.imageTaken == NO ) {
//            
//            if ([_device isFocusPointOfInterestSupported]) {
//                NSError *error;
//                NSLog(@"focus2");
//                
//                if ([_device lockForConfiguration:&error]) {
//                    [_device setFocusPointOfInterest:touchPoint];
//                    [_device setExposurePointOfInterest:touchPoint];
//                    NSLog(@"focus3");
//                    
//                    [_device setFocusMode:AVCaptureFocusModeAutoFocus];
//                    if ([_device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
//                        [_device setExposureMode:AVCaptureExposureModeAutoExpose];
//                        self.point = [recognizer locationInView:self.cameraView];
//                        focusSquare.frame = CGRectMake(self.point.x, self.point.y, 30, 30);
//                        focusSquare.backgroundColor = [UIColor clearColor];
//                        focusSquare.layer.cornerRadius = 15;
//                        focusSquare.layer.borderWidth = 2.0;
//                        focusSquare.layer.borderColor = [UIColor whiteColor].CGColor;
//                        focusSquare.layer.masksToBounds = YES;
//                        focusSquare.alpha = 1.0;
//                        
//                        [self.cameraView addSubview:focusSquare];
//                        [self focusPoint];
//                        self.fadeInFocus = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
//                                                                          selector:@selector(focusFadeIn) userInfo:nil repeats:NO];
//                        
//                        
//                        NSLog(@"X location: %f", _point.x);
//                        NSLog(@"Y Location: %f",_point.y);
//                    }
//                    [_device unlockForConfiguration];
//                }
//            }else{
//                NSLog(@"Not Supported");
//                
//            }
//        }
//        
//        // NSLog(@"x = %f, y = %f", touchPoint.x, touchPoint.y);
//   */
//    
//}

-(void)viewWillAppear:(BOOL)animated {
    
    view2.yesPhotoView.hidden = YES;
    view2.cancelPhotoView.hidden = YES;
    view2.selectButton.hidden = NO;
    view2.cameraPhotoButton.hidden = NO;
    view2.flipButton.hidden = NO;
    view2.flashCameraButton.hidden = NO;
    view2.cameraButtonView.hidden = NO;
    view2.imageViewPreview.image = nil;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    //self.yesButton.hidden = YES;
    //self.cancelButton.hidden = YES;

    [self createCamera];
    [self setImagePickerButton];
    focusSquare = [[UIView alloc]init];
    

    
}
-(void)viewDidDisappear:(BOOL)animated {
    
    [self.session stopRunning];
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
    self.session = nil;
    
}

-(void)toAlbumsView{
    
    [self performSegueWithIdentifier:@"toAlbumsVC" sender:self];
    
}

- (void)createCamera {
    
    self.session = [[AVCaptureSession alloc]init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //self.device = [self cameraWithPosition:AVCaptureDevicePositionFront];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    if (!input) {
        //Handle the error
        NSLog(@"ERROR: Trying to open camera: %@", error);
    }else if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.rootLayer = [[self view]layer];
    [self.rootLayer setMasksToBounds:YES];
    [self.previewLayer setFrame:self.view.bounds];
    [self.rootLayer insertSublayer:self.previewLayer atIndex:0];
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.stillImageOutput];
    [self.session startRunning];
   
    
    if ([_device lockForConfiguration:&error]) {
    
    [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]){
            [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
    }
    
}
-(void)setImagePickerButton {
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    PHAsset *lastAsset = [fetchResult lastObject];
    [[PHImageManager defaultManager]requestImageForAsset:lastAsset targetSize:view2.selectButton.frame.size contentMode:PHImageContentModeAspectFill options:PHImageRequestOptionsVersionCurrent resultHandler:^(UIImage *result, NSDictionary *info){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            view2.selectButton.layer.cornerRadius = view2.selectButton.frame.size.height/2;
            view2.selectButton.backgroundColor = [UIColor clearColor];
            [[view2 selectButton] setBackgroundImage:result forState:UIControlStateNormal];
            
            });
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraButtonPressed:(id)sender {
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    NSLog(@"about to request a capture from: %@", _stillImageOutput);
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             
             NSLog(@"attachements: %@", exifAttachments);
         }
         else
             NSLog(@"no attachments");
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         UIImage *flippedImage = [UIImage imageWithCGImage:[image CGImage] scale:[image scale] orientation:UIImageOrientationLeftMirrored];
         
         if ([cameraPosition isEqualToString:@"Front"]) {
             NSLog(@"front");
             
             view2.imageViewPreview.image = flippedImage;
         }else {
             NSLog(@"Back");
             
             view2.imageViewPreview.image = image;
         }
         
        [self setImageTaken:YES];
         
         
     }];
    
    view2.yesPhotoView.hidden = NO;
    view2.cancelPhotoView.hidden = NO;
    view2.selectButton.hidden = YES;
    view2.cameraPhotoButton.hidden = YES;
    view2.flipButton.hidden = YES;
    view2.flashCameraButton.hidden = YES;
    view2.cameraButtonView.hidden = YES;

    
    
}
- (IBAction)flipCameraPressed:(id)sender {
    
    if(_session)
    {
        //Indicate that some changes will be made to the session
        [_session beginConfiguration];
        
        //Remove existing input
        AVCaptureInput* currentCameraInput = [_session.inputs objectAtIndex:0];
        [_session removeInput:currentCameraInput];
        
        //Get new input
        //AVCaptureDevice *newCamera = nil;
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
        {
            cameraPosition = @"Front";
            _device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else
        {
            cameraPosition = @"Back";
            
            _device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
        
        //Add input to session
        NSError *err = nil;
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_device error:&err];
        if(!newVideoInput || err)
        {
            NSLog(@"Error creating capture device input: %@", err.localizedDescription);
        }
        else
        {
            [_session addInput:newVideoInput];
        }
        
        //Commit all the configuration changes at once
        [_session commitConfiguration];
    }
    
    

    
}

- (IBAction)selectPhotoButton:(id)sender {
}
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    view2.yesPhotoView.hidden = YES;
    view2.cancelPhotoView.hidden = YES;
    view2.selectButton.hidden = NO;
    view2.cameraPhotoButton.hidden = NO;
    view2.flipButton.hidden = NO;
    view2.flashCameraButton.hidden = NO;
    view2.cameraButtonView.hidden = NO;
    view2.imageViewPreview.image = nil;
    
}
- (IBAction)yesButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"toEditingVC" sender:self];
    
}
- (IBAction)flashButtonPressed:(id)sender {
    
    if ([self.device hasTorch] && [self.device hasFlash]){
        
        [self.device lockForConfiguration:nil];
        if (self.device.torchMode == AVCaptureTorchModeOff) {
            [self.device setTorchMode:AVCaptureTorchModeOn];
            [self.device setFlashMode:AVCaptureFlashModeOn];
            //torchIsOn = YES; //define as a variable/property if you need to know status
        } else {
            [self.device setTorchMode:AVCaptureTorchModeOff];
            [self.device setFlashMode:AVCaptureFlashModeOff];
            //torchIsOn = NO;
        }
        [self.device unlockForConfiguration];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"focus1");
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UITouch *touch = obj;
        CGPoint touchPoint = [touch locationInView:touch.view];
        //focusLayer.frame = CGRectMake((touchPoint.x-25), (touchPoint.y-25), 50, 50);
        
        
        if (self.imageTaken == NO ) {
            
            if ([_device isFocusPointOfInterestSupported]) {
                NSError *error;
                NSLog(@"focus2");
                
                if ([_device lockForConfiguration:&error]) {
                    [_device setFocusPointOfInterest:touchPoint];
                    [_device setExposurePointOfInterest:touchPoint];
                    NSLog(@"focus3");
                    
                    [_device setFocusMode:AVCaptureFocusModeAutoFocus];
                    if ([_device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
                        [_device setExposureMode:AVCaptureExposureModeAutoExpose];
                        self.point = [touch locationInView:self.cameraView];
                        focusSquare.frame = CGRectMake(self.point.x, self.point.y, 30, 30);
                        focusSquare.backgroundColor = [UIColor clearColor];
                        focusSquare.layer.cornerRadius = 15;
                        focusSquare.layer.borderWidth = 2.0;
                        focusSquare.layer.borderColor = [UIColor whiteColor].CGColor;
                        focusSquare.layer.masksToBounds = YES;
                        focusSquare.alpha = 1.0;
                        
                        [self.cameraView addSubview:focusSquare];
                        [self focusPoint];
                        self.fadeInFocus = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                                                          selector:@selector(focusFadeIn) userInfo:nil repeats:NO];
                        
                        
                        NSLog(@"X location: %f", _point.x);
                        NSLog(@"Y Location: %f",_point.y);
                    }
                    [_device unlockForConfiguration];
                }
            }else{
                NSLog(@"Not Supported");
                
            }
        }
        
        // NSLog(@"x = %f, y = %f", touchPoint.x, touchPoint.y);
    }];
    
}
-(void)focusPoint{
    
    //focusSquare = [[UIView alloc]initWithFrame:CGRectMake(self.point.x, self.point.y, 20, 20)];
    //focusSquare.frame = CGRectMake(self.point.x, self.point.y, 20, 20);
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionOverrideInheritedOptions | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations: ^{
        focusSquare.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:focusSquare];
    } completion:nil];
    
}
-(void)focusFadeIn{
    
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionOverrideInheritedOptions | UIViewAnimationOptionCurveEaseInOut  animations: ^{
        
        focusSquare.alpha = 0.0;
        [self.view addSubview:focusSquare];
    } completion:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[EditingViewController class]]) {
        EditingViewController *editingViewController = segue.destinationViewController;
        editingViewController.editingImage = view2.imageViewPreview.image;
    }
    
    
}


@end
