#import "RealtimeRankingPlugin.h"
#if __has_include(<realtime_ranking/realtime_ranking-Swift.h>)
#import <realtime_ranking/realtime_ranking-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "realtime_ranking-Swift.h"
#endif

@implementation RealtimeRankingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRealtimeRankingPlugin registerWithRegistrar:registrar];
}
@end
