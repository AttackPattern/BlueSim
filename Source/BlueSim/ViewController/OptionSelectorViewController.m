// Copyright (c) Attack Pattern LLC.  All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

#import "OptionSelectorViewController.h"

@implementation Option

+ (Option *)createWithName:(NSString *)name intValue:(int) intValue
{
    return [Option createWithName:name value:[NSNumber numberWithInt:intValue]];
}

+ (Option *)createWithName:(NSString *)name value:(NSNumber *)value
{
    Option *option = [[Option alloc] init];
    option.name = name;
    option.value = value;
    return option;
}

@end

@interface OptionSelectorViewController ()

@end

@implementation OptionSelectorViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Option"];
    
    Option *option = self.options[indexPath.row];
    cell.textLabel.text = option.name;
    
    if (self.selectedOption)
    {
        cell.accessoryType = option.value == self.selectedOption.value
            ? UITableViewCellAccessoryCheckmark
            : UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UITableViewCell *cell in tableView.visibleCells)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.selectedOption = (Option *)self.options[indexPath.row];
    if (self.delegate)
    {
        [self.delegate optionSelector:self didSelectOption:self.selectedOption];
    }
}

@end
