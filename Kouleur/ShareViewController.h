//
//  ShareViewController.h
//  Kouleur
//
//  Created by iMac on 10/18/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backToEditingVC;
- (IBAction)backButtonPressed:(id)sender;
@property (strong, nonatomic) UIImage *finalImage;

@end
