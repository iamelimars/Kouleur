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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.introView setFrame:self.view.frame];
    [self.cameraView setFrame:self.view.frame];
    
    self.cameraButton.layer.cornerRadius = self.cameraButton.frame.size.height/2;
    self.cameraButtonView.layer.cornerRadius = self.cameraButtonView.frame.size.height/2;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self createCamera];
    
}

- (void)createCamera {
    
    self.session = [[AVCaptureSession alloc]init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
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

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraButtonPressed:(id)sender {
}
@end
