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

@synthesize cameraPosition, focusSquare;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.introView setFrame:self.view.frame];
    [self.cameraView setFrame:self.view.frame];
    [self setImagePickerButton];
    
    self.cameraButton.layer.cornerRadius = self.cameraButton.frame.size.height/2;
    self.cameraButtonView.layer.cornerRadius = self.cameraButtonView.frame.size.height/2;
    self.yesButton.layer.cornerRadius = self.yesButton.frame.size.height/2;
    self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.height/2;
    self.selectPhotoButton.layer.cornerRadius = self.selectPhotoButton.frame.size.height/2;
    self.selectPhotoButton.clipsToBounds = TRUE;
    
}
-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    /*
    NSLog(@"focus1");
        CGPoint touchPoint = [recognizer locationInView:[recognizer.view superview]];
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
                        self.point = [recognizer locationInView:self.cameraView];
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
   */
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.yesButton.hidden = YES;
    self.cancelButton.hidden = YES;
    self.selectPhotoButton.hidden = NO;
    self.cameraButton.hidden = NO;
    self.flipCameraButton.hidden = NO;
    self.flashButton.hidden = NO;
    self.cameraButtonView.hidden = NO;
    self.imagePreview.image = nil;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    self.yesButton.hidden = YES;
    self.cancelButton.hidden = YES;

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

- (void)createCamera {
    
    self.session = [[AVCaptureSession alloc]init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //self.device = [self cameraWithPosition:AVCaptureDevicePositionFront];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    if (!input) {
        //Handle the error appropriately
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
    [[PHImageManager defaultManager]requestImageForAsset:lastAsset targetSize:self.selectPhotoButton.frame.size contentMode:PHImageContentModeAspectFill options:PHImageRequestOptionsVersionCurrent resultHandler:^(UIImage *result, NSDictionary *info){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.selectPhotoButton.layer.cornerRadius = self.selectPhotoButton.frame.size.height/2;
            self.selectPhotoButton.backgroundColor = [UIColor clearColor];
            [[self selectPhotoButton] setBackgroundImage:result forState:UIControlStateNormal];
            
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
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         }
         else
             NSLog(@"no attachments");
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         //image.imageOrientation = [UIImageOrientationLeftMirrored];
         UIImage *flippedImage = [UIImage imageWithCGImage:[image CGImage] scale:[image scale] orientation:UIImageOrientationLeftMirrored];
         
         if ([cameraPosition isEqualToString:@"Front"]) {
             NSLog(@"front");
             
             self.imagePreview.image = flippedImage;
         }else {
             NSLog(@"Back");
             
             self.imagePreview.image = image;
         }
         
        [self setImageTaken:YES];
         
         
     }];
    
    self.yesButton.hidden = NO;
    self.cancelButton.hidden = NO;
    self.selectPhotoButton.hidden = YES;
    self.cameraButton.hidden = YES;
    self.flipCameraButton.hidden = YES;
    self.flashButton.hidden = YES;
    self.cameraButtonView.hidden = YES;

    
    
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
    
    self.yesButton.hidden = YES;
    self.cancelButton.hidden = YES;
    self.selectPhotoButton.hidden = NO;
    self.cameraButton.hidden = NO;
    self.flipCameraButton.hidden = NO;
    self.flashButton.hidden = NO;
    self.cameraButtonView.hidden = NO;
    self.imagePreview.image = nil;
    
}
- (IBAction)yesButtonPressed:(id)sender {
    
    
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
        editingViewController.editingImage = self.imagePreview.image;
    }
    
    
}


@end
