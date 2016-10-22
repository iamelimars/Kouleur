//
//  ShareViewController.m
//  Kouleur
//
//  Created by iMac on 10/18/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

@synthesize finalImage, docController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAndLoadInterstitial];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}
- (void)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-9906091830733745/3386219711"];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    //request.testDevices = @[ kGADSimulatorID, @"fd3efe9a2aa0d5b371f5a7e868f7d08a" ];
    [self.interstitial loadRequest:request];
    
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"interstitial success");
    [self.interstitial presentFromRootViewController:self];
}
-(void)viewDidAppear:(BOOL)animated {
    
    if (finalImage == nil) {
        NSLog(@"No Image Was Sent");
        
    } else {
        
        NSLog(@"image sent was a success");
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        [self shareToTwitter];
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
        
        [self shareToFacebook];
        
    }else if (indexPath.section == 0 && indexPath.row == 2){
        
        [self shareToInstagram];
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
        
        [self saveToCameraRoll];
        
    }else if (indexPath.section == 2 && indexPath.row == 0){
        
        [self sendAsMessage];
        
    }else if (indexPath.section == 2 && indexPath.row == 1){
        
        [self sendAsEmail];
        
    }
    
}

#pragma mark - Share Methods

-(void)shareToTwitter {
    
    NSLog(@"twitter");
    twitterSLComposer = [[SLComposeViewController alloc]init];
    twitterSLComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitterSLComposer addImage:finalImage];
    [twitterSLComposer setInitialText:@"Go download the 'Kouleur' app!!"];
    [self presentViewController:twitterSLComposer animated:YES completion:nil];
    
}
-(void)shareToFacebook {
    
    NSLog(@"facebook");
    SLComposer = [[SLComposeViewController alloc]init];
    SLComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [SLComposer setInitialText:[NSString stringWithFormat:@"CLRS"]];
    [SLComposer addImage:finalImage];
    [self presentViewController:SLComposer animated:YES completion:nil];
    
}
-(void)shareToInstagram {
    
    NSLog(@"instagram");
    NSString* imagePath = [NSString stringWithFormat:@"%@/image.igo", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    [UIImagePNGRepresentation(self.finalImage)writeToFile:imagePath atomically:YES];
    
    docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imagePath]];
    docController.delegate = self;
    docController.UTI = @"com.instagram.photo";
    //[self.docController presentPreviewAnimated:YES];
    
    [docController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];

}
-(void)saveToCameraRoll {
    
    NSLog(@"Camera Roll");
    UIImageWriteToSavedPhotosAlbum(self.finalImage,nil,nil , nil);
    
    
    [RKDropdownAlert show];
    [RKDropdownAlert title:@"Saved!" message:@"Image Saved To Camera Roll" backgroundColor:[UIColor flatMintColor] textColor:[UIColor flatWhiteColor]];
    
}



-(void)sendAsMessage {
    
    NSLog(@"message");
    NSString* imagePath = [NSString stringWithFormat:@"%@/image.igo", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    [UIImagePNGRepresentation(finalImage)writeToFile:imagePath atomically:YES];
    
    MFMessageComposeViewController *textComposer = [[MFMessageComposeViewController alloc] init];
    [textComposer setMessageComposeDelegate:self];
    
    if ([MFMessageComposeViewController canSendText]) {
        [textComposer setRecipients:NULL];
        [textComposer setBody:@"Go Download Kouleur from the Apple App Store."];
        NSData *data = UIImagePNGRepresentation(finalImage);
        [textComposer addAttachmentData:data typeIdentifier:@"image/png" filename:@"image.png"];
        
        [self presentViewController:textComposer animated:YES completion:NULL];
        
    } else {
        
        NSLog(@"Error");
        
    }

    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [RKDropdownAlert show];
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            [RKDropdownAlert show];
            [RKDropdownAlert title:@"Cancelled!" message:@"Message Cancelled" backgroundColor:[UIColor flatRedColor] textColor:[UIColor flatWhiteColor]];
            break;
        case MessageComposeResultSent:
            [RKDropdownAlert show];
            [RKDropdownAlert title:@"Sent!" message:@"Message Sent" backgroundColor:[UIColor flatMintColor] textColor:[UIColor flatWhiteColor]];
            break;
        case MessageComposeResultFailed:
            [RKDropdownAlert title:@"Failed!" message:@"Message Sending Failed" backgroundColor:[UIColor flatRedColorDark] textColor:[UIColor flatWhiteColor]];
            break;
    }
}


-(void)sendAsEmail {
    
    NSLog(@"email");

    NSString* imagePath = [NSString stringWithFormat:@"%@/image.igo", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    [UIImagePNGRepresentation(finalImage)writeToFile:imagePath atomically:YES];
    
    MFMailComposeViewController *imageEmail = [[MFMailComposeViewController alloc]init];
    imageEmail.mailComposeDelegate = self;
    [imageEmail setSubject:@"Kouleur app!"];
    NSString *bodyOfEmail = @"Go Download Kouleur from the Apple App Store.";
    [imageEmail setMessageBody:bodyOfEmail isHTML:NO];
    NSData *data = UIImagePNGRepresentation(finalImage);
    [imageEmail addAttachmentData:data mimeType:@"image/png" fileName:@"image.png"];
    
    
    [self presentViewController:imageEmail animated:YES completion:NULL];
    
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [RKDropdownAlert show];
            [RKDropdownAlert title:@"Cancelled!" message:@"Email Sending Cancelled" backgroundColor:[UIColor flatRedColor] textColor:[UIColor flatWhiteColor]];
            break;
        case MFMailComposeResultSaved:[RKDropdownAlert show];
            [RKDropdownAlert title:@"Saved!" message:@"Email Saved" backgroundColor:[UIColor flatSkyBlueColor] textColor:[UIColor flatWhiteColor]];
            break;
        case MFMailComposeResultSent:
            [RKDropdownAlert show];
            [RKDropdownAlert title:@"Sent!" message:@"Email Sent" backgroundColor:[UIColor flatMintColor] textColor:[UIColor flatWhiteColor]];
            break;
        case MFMailComposeResultFailed:
            [RKDropdownAlert show];
            [RKDropdownAlert title:@"Failure!" message:@"Email Sending Failed" backgroundColor:[UIColor flatRedColorDark] textColor:[UIColor flatWhiteColor]];
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    self.docController = nil;
}


-(UIImage *)createImage:(UIImageView *)imgView //save Image
{
    
    UIImageWriteToSavedPhotosAlbum(self.finalImage,nil,nil , nil);
    return self.finalImage;
}

-(BOOL)dropdownAlertWasTapped:(RKDropdownAlert *)alert {
    
    
    return YES;
}
-(BOOL)dropdownAlertWasDismissed {
    
    
    return YES;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
