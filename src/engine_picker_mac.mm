#include "../include/engine_picker.h"

#import <AppKit/AppKit.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

bool pickEngineFile(const std::string &startDirectory, std::string *path) {
    @autoreleasepool {
        NSWindow *keyWindow = [NSApp keyWindow];

        NSOpenPanel *panel = [NSOpenPanel openPanel];
        panel.title = @"Choose an engine";
        panel.prompt = @"Load";
        panel.canChooseFiles = YES;
        panel.canChooseDirectories = NO;
        panel.allowsMultipleSelection = NO;
        panel.directoryURL = [NSURL fileURLWithPath:
            [NSString stringWithUTF8String:startDirectory.c_str()] isDirectory:YES];

        UTType *mrType = [UTType typeWithFilenameExtension:@"mr"];
        if (mrType != nil) panel.allowedContentTypes = @[mrType];

        const NSModalResponse response = [panel runModal];

        // Hand focus back to the game window so keyboard input keeps working
        [keyWindow makeKeyAndOrderFront:nil];

        if (response != NSModalResponseOK || panel.URL == nil) return false;

        *path = panel.URL.path.UTF8String;
        return true;
    }
}
