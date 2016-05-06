//
//  ViewController.m
//  LotteryHelper
//
//  Created by Gil on 5/2/16.
//  Copyright © 2016 Hartman. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(255.0/255.0, 139.0/255.0, 216.0/255.0, 1.0)]; //RGB plus Alpha Channel
    [self.view setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
    [self.view setLayer:viewLayer];
    [self.number_1 becomeFirstResponder];
}

- (void)controlTextDidChange:(NSNotification *)notification {
    [self updateEnabledButton];
}

- (void) updateEnabledButton {
    self.run_button.enabled = [self.number_1.stringValue length] > 0 &&
    [self.number_2.stringValue length] > 0 &&
    [self.number_3.stringValue length] > 0 &&
    [self.number_4.stringValue length] > 0 &&
    [self.number_5.stringValue length] > 0 &&
    [self.number_6.stringValue length] > 0 &&
    [self.extra_number.stringValue length] > 0 && [self.xml_path.stringValue length] > 0;
}

- (IBAction)browse:(id)sender {
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];

    [openDlg setCanChooseFiles:TRUE];
    [openDlg setCanChooseDirectories:FALSE];
    [openDlg setAllowsMultipleSelection:FALSE];
    [openDlg setAllowsOtherFileTypes:FALSE];
    [openDlg setAllowedFileTypes:@[@"xml"]];

    if ([openDlg runModal] == NSModalResponseOK)
    {
        NSString* fileNameOpened = [[[openDlg URLs] objectAtIndex:0] path];
        [self.xml_path setStringValue:fileNameOpened];
        [self updateEnabledButton];
    }
}

- (IBAction)runScript:(id)sender {
    [[NSProcessInfo processInfo] processIdentifier];
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;

    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/python";
    task.arguments = @[[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent: @"Contents/Resources/netbet_parser.py"], self.xml_path.stringValue, self.extra_number.stringValue, @"-l", self.number_1.stringValue, self.number_2.stringValue, self.number_3.stringValue, self.number_4.stringValue, self.number_5.stringValue, self.number_6.stringValue];
    task.standardOutput = pipe;

    [task launch];

    NSData *data = [file readDataToEndOfFile];
    [file closeFile];

    NSString *output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    self.output_label.string = output;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
