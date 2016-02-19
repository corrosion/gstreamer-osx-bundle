//
//  main.m
//  Gst-Test
//
//  Created by Stu on 9/14/15.
//  Copyright (c) 2015 corrosion. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <gst/gst.h>


int main(int argc, const char * argv[]) {
    // Setup GSTreamer environment
    NSString *frameworksPath = [[NSBundle mainBundle] privateFrameworksPath];
    NSString *scannerPath = [NSString stringWithFormat:@"%@/%@", frameworksPath,
                             @"GStreamer.framework/Versions/1.0/libexec/gstreamer-1.0/gst-plugin-scanner"];
    NSString *pluginsPath = [NSString stringWithFormat:@"%@/%@", frameworksPath,
                             @"GStreamer.framework/Versions/1.0/lib"];
    setenv("GST_PLUGIN_SCANNER", [scannerPath UTF8String], 1);
    setenv("GST_PLUGIN_SYSTEM_PATH", [pluginsPath UTF8String], 1);

    // Initialize GStreamer
    gst_init(&argc, (char ***) &argv);

    return NSApplicationMain(argc, argv);
}
