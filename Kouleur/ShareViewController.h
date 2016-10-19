//
//  ShareViewController.h
//  Kouleur
//
//  Created by iMac on 10/18/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "RKDropdownAlert.h"
#import <ChameleonFramework/Chameleon.h>

@interface ShareViewController : UITableViewController <UIDocumentInteractionControllerDelegate,MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, RKDropdownAlertDelegate> {
    
    SLComposeViewController *SLComposer;
    SLComposeViewController *twitterSLComposer;
    
    
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backToEditingVC;
- (IBAction)backButtonPressed:(id)sender;
@property (strong, nonatomic) UIImage *finalImage;
@property (nonatomic, strong) UIDocumentInteractionController *docController;
@end
