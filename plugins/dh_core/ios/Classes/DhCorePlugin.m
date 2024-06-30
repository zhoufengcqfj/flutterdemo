#import "DhCorePlugin.h"
#if __has_include(<dh_core/dh_core-Swift.h>)
#import <dh_core/dh_core-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dh_core-Swift.h"
#endif

@implementation DhCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftDhCorePlugin registerWithRegistrar:registrar];
}
@end
