//
//  ViewController.h
//  Gst-Test
//
//  Created by Stoyan Iliev on 9/14/15.
//  Copyright (c) 2015 corrosion. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *uri;

- (IBAction) onPlay:(id) sender;

@end

