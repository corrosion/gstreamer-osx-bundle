----------

Use relocation tool:
https://github.com/tito/osxrelocator

----------

Setup development framework:

- Install both gstreamer-1.0-x.x.x-x86_64.pkg and gstreamer-1.0-devel-x.x.x-x86_64.pkg
- Move /Library/Frameworks/GStreamer.framework to $(PROJECT_DIR)/GStreamer-devel.framework
- cd to $(PROJECT_DIR) and run the following commands
```
osxrelocator ./GStreamer-devel.framework/Versions/Current /Library/Frameworks/GStreamer.framework/ `pwd`/GStreamer-devel.framework/
install_name_tool -id @executable_path/../Frameworks/GStreamer.framework/GStreamer ./GStreamer-devel.framework/Versions/Current/GStreamer
```

----------

Prepare the runtime framework:

- Install gstreamer-1.0-x.x.x-x86_64.pkg
- Move /Library/Frameworks/GStreamer.framework to $(PROJECT_DIR)/GStreamer.framework
- Do some clean up of the framework:
```
rm ./GStreamer.framework/Headers ./GStreamer.framework/Commands
rm ./GStreamer.framework/Versions/Current/Commands
rm -r ./GStreamer.framework/Versions/Current/bin/
rm -r ./GStreamer.framework/Versions/Current/etc/
rm -r ./GStreamer.framework/Versions/Current/share/
```
- Relocate the framework's .dylibs:
```
osxrelocator -r ./GStreamer.framework/Versions/Current /Library/Frameworks/GStreamer.framework/ @executable_path/../Frameworks/GStreamer.framework/
```
- Since gst-plugin-scanner is executed during gst_init it needs to find the plugins.
So create link to "Frameworks" in the libexec directory to resolve @executable_path/../Frameworks/GStreamer.framework/
```
ln -sf ../../../../ GStreamer.framework/Versions/Current/libexec/Frameworks
```

----------

XCode:

- Add "$(PROJECT_DIR)/../GStreamer-devel.framework/Headers" to Header Search Paths
- Add "GStreamer-devel.framework/GStreamer" file to the Xcode project
- In the project's Build Phases settings create new Copy Files Phase and copy the GStreamer.framework to Fameworks
- Set GST_PLUGIN_SCANNER and GST_PLUGIN_SYSTEM_PATH environment variables in code before calling gst_init():
```
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
```
- To compile this project on another machine run:
```
osxrelocator ./GStreamer-devel.framework/Versions/Current /Volumes/Drobo/WS/gstreamer-osx-bundle/ `pwd`/
```
