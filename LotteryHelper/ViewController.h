//
//  ViewController.h
//  LotteryHelper
//
//  Created by Gil on 5/2/16.
//  Copyright © 2016 Hartman. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController


@property (weak) IBOutlet NSTextField *number_1;
@property (weak) IBOutlet NSTextField *number_2;
@property (weak) IBOutlet NSTextField *number_3;
@property (weak) IBOutlet NSTextField *number_4;
@property (weak) IBOutlet NSTextField *number_5;
@property (weak) IBOutlet NSTextField *number_6;

@property (weak) IBOutlet NSTextField *extra_number;
@property (weak) IBOutlet NSTextField *xml_path;
@property (weak) IBOutlet NSButton *xml_browse;
@property (weak) IBOutlet NSButton *run_button;

@property (unsafe_unretained) IBOutlet NSTextView *output_label;

@end

