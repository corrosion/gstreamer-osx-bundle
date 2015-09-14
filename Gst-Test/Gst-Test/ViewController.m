//
//  ViewController.m
//  Gst-Test
//
//  Created by Stoyan Iliev on 9/14/15.
//  Copyright (c) 2015 corrosion. All rights reserved.
//

#import "ViewController.h"
#import <gst/gst.h>


@implementation ViewController

- (IBAction) onPlay:(id) sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self gstPlayUri:[_uri stringValue]];
    });
}

- (void) gstPlayUri:(NSString *) uri
{
    GstElement *playbin;
    GMainLoop *main_loop;

    playbin = gst_element_factory_make("playbin", "pipeline");

    // Set flags - GST_PLAY_FLAG_BUFFERING | GST_PLAY_FLAG_AUDIO
    g_object_set(playbin, "flags", 0x102, NULL);

    // Set the URI to play
    g_object_set(playbin, "uri", [uri UTF8String], NULL);

    // Start playing
    gst_element_set_state(playbin, GST_STATE_PLAYING);


    // Create a GLib Main Loop and set it to run
    main_loop = g_main_loop_new(NULL, FALSE);
    g_main_loop_run(main_loop);
}


@end
