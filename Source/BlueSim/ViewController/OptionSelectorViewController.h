// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import <UIKit/UIKit.h>

@class OptionSelectorViewController;

@interface Option : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSNumber *value;
+ (Option *)createWithName:(NSString *)name value:(NSNumber *)value;
+ (Option *)createWithName:(NSString *)name intValue:(int) intValue;

@end

@protocol OptionSelectorDelegate<NSObject>
- (void)optionSelector:(OptionSelectorViewController *)optionSelector didSelectOption:(Option *)option;
@end

@interface OptionSelectorViewController : UITableViewController

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) Option *selectedOption;
@property (strong, nonatomic) id<OptionSelectorDelegate> delegate;

@end

