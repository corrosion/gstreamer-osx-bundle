----------

For library relocation use:
https://github.com/tito/osxrelocator

----------

Setup to build the project with XCode:

- Install gstreamer-1.0-1.5.2-x86_64.pkg
- Install gstreamer-1.0-devel-1.5.2-x86_64.pkg
- Move /Library/Frameworks/GStreamer.framework to $(PROJECT_DIR)/GStreamer-devel.framework
- cd to $(PROJECT_DIR) and run the following commands
```
osxrelocator ./GStreamer-devel.framework/Versions/Current /Library/Frameworks/GStreamer.framework/ `pwd`/GStreamer-devel.framework/
install_name_tool -id @executable_path/../Frameworks/GStreamer.framework/GStreamer ./GStreamer-devel.framework/Versions/Current/GStreamer
```
- Add "$(PROJECT_DIR)/GStreamer-devel.framework/Headers" to Header Search Paths
- Add "GStreamer-devel.framework/GStreamer" file to the Xcode project

----------

Prepare the runtime framework:

- Install gstreamer-1.0-1.5.2-x86_64.pkg
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
- Since gst-plugin-scanner is executed during gst_init it also has to be able to find all libraries.
So create link to "Frameworks" in the libexec directory to resolve @executable_path/../Frameworks/GStreamer.framework/
```
ln -sf ../../../../ GStreamer.framework/Versions/Current/libexec/Frameworks
```
- In the project's Build Phases settings create new Copy Files Phase and copy the GStreamer.framework to Fameworks

----------

Set GST_PLUGIN_SCANNER and GST_PLUGIN_SYSTEM_PATH environment variables in code before calling gst_init():

    // Setup GSTreamer environment
    NSString *frameworksPath = [[NSBundle mainBundle] privateFrameworksPath];
    NSString *scannerPath = [NSString stringWithFormat:@"%@/%s", frameworksPath,
                             "GStreamer.framework/Versions/1.0/libexec/gstreamer-1.0/gst-plugin-scanner"];
    NSString *pluginsPath = [NSString stringWithFormat:@"%@/%s", frameworksPath,
                             "GStreamer.framework/Versions/1.0/lib"];
    setenv("GST_PLUGIN_SCANNER", [scannerPath UTF8String], 1);
    setenv("GST_PLUGIN_SYSTEM_PATH", [pluginsPath UTF8String], 1);

    // Initialize GStreamer
    gst_init(&argc, (char ***) &argv);
