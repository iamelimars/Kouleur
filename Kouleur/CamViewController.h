//
//  CamViewController.h
//  Kouleur
//
//  Created by iMac on 10/18/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CamViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview;
@property (weak, nonatomic) IBOutlet UIButton *cancelPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *yesPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *flashCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *flipButton;
@property (weak, nonatomic) IBOutlet UIView *cameraButtonView;
@property (weak, nonatomic) IBOutlet UIButton *cameraPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *testButton;



@end
