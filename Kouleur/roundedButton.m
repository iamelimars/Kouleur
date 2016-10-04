//
//  roundedButton.m
//  Kouleur
//
//  Created by iMac on 10/4/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

#import "roundedButton.h"

@implementation roundedButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    self.layer.cornerRadius = 5.0;
    self.clipsToBounds = YES;

}


@end
