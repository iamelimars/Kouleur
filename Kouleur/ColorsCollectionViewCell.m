//
//  ColorsCollectionViewCell.m
//  Kouleur
//
//  Created by iMac on 10/13/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import "ColorsCollectionViewCell.h"

@implementation ColorsCollectionViewCell

-(void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.clipsToBounds = YES;
    
}

@end
