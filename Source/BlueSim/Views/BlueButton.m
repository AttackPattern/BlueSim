// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "BlueButton.h"

@implementation BlueButton

static UIImage *backgroundImage;
static UIImage *backgroundImageHighlighted;

+ (BlueButton *)buttonWithType:(UIButtonType)type
{
    return [super buttonWithType:UIButtonTypeCustom];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (!backgroundImage || !backgroundImageHighlighted) {
            backgroundImage = [[UIImage imageNamed:@"button.png" ] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16) resizingMode: UIImageResizingModeStretch];
            backgroundImageHighlighted = [[UIImage imageNamed:@"button-highlight.png" ] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16) resizingMode: UIImageResizingModeStretch];
        }
        
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setupBackgrounds {
}

@end