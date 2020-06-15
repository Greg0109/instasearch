#line 1 "Tweak.x"

@interface RBSProcessIdentity : NSObject
@property(readonly, copy, nonatomic) NSString *executablePath;
@property(readonly, copy, nonatomic) NSString *embeddedApplicationIdentifier;
@end

@interface FBProcessExecutionContext : NSObject
@property (nonatomic,copy) NSDictionary* environment;
@property (nonatomic,copy) RBSProcessIdentity* identity;
@end

@interface FBProcessManager : NSObject
- (void)handleSafeModeForExecutionContext:(FBProcessExecutionContext*)executionContext withApplicationID:(NSString*)applicationID;
@end

@interface SBApplicationInfo : NSObject
@property (nonatomic,readonly) NSURL* executableURL;
@property (nonatomic,readonly) BOOL hasHiddenTag;
@property (nonatomic,retain,readonly) NSArray* tags;
@end

@interface SBApplication : NSObject
- (SBApplicationInfo*)_appInfo;
@end

@interface SBSApplicationShortcutIcon : NSObject
@end

@interface SBSApplicationShortcutSystemItem : SBSApplicationShortcutIcon
- (instancetype)initWithSystemImageName:(NSString*)systemImageName;
@end

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic,copy) NSString* type;
@property (nonatomic,copy) NSString* localizedTitle;
@property (nonatomic,copy) NSString* localizedSubtitle;
@property (nonatomic,copy) SBSApplicationShortcutIcon* icon;
@property (nonatomic,copy) NSDictionary* userInfo;
@property (assign,nonatomic) NSUInteger activationMode;
@property (nonatomic,copy) NSString* bundleIdentifierToLaunch;
@end

@interface SBIconView : NSObject
- (NSString*)applicationBundleIdentifier;
- (NSString*)applicationBundleIdentifierForShortcuts;


- (bool)isBrowser:(NSString *)bundleID;
- (NSURL *)generateLink:(NSString *)url forApp:(NSString *)bundleID;
@end

@interface SBUIAppIconForceTouchControllerDataProvider : NSObject
- (NSString*)applicationBundleIdentifier;
- (bool)isBrowser:(NSString *)bundleID;
@end



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBIconView; @class SBSApplicationShortcutItem; 
static NSArray * (*_logos_orig$_ungrouped$SBIconView$applicationShortcutItems)(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST, SEL); static NSArray * _logos_method$_ungrouped$SBIconView$applicationShortcutItems(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST, SEL); static void (*_logos_meta_orig$_ungrouped$SBIconView$activateShortcut$withBundleIdentifier$forIconView$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, SBSApplicationShortcutItem*, NSString*, id); static void _logos_meta_method$_ungrouped$SBIconView$activateShortcut$withBundleIdentifier$forIconView$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, SBSApplicationShortcutItem*, NSString*, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBSApplicationShortcutItem(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBSApplicationShortcutItem"); } return _klass; }
#line 58 "Tweak.x"

static NSArray * _logos_method$_ungrouped$SBIconView$applicationShortcutItems(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	NSArray * orig = _logos_orig$_ungrouped$SBIconView$applicationShortcutItems(self, _cmd);
	
	NSString * bundleID;
	if ([self respondsToSelector:@selector(applicationBundleIdentifier)]){
		bundleID = [self applicationBundleIdentifier];
	} else if ([self respondsToSelector:@selector(applicationBundleIdentifierForShortcuts)]){
		bundleID = [self applicationBundleIdentifierForShortcuts];
	}

	if(!bundleID){
		return orig;
	}

	if ([bundleID isEqualToString:@"com.burbn.instagram"]) {
    SBSApplicationShortcutItem* instaSearch = [[_logos_static_class_lookup$SBSApplicationShortcutItem() alloc] init];
    instaSearch.localizedTitle = [NSString stringWithFormat:@"Search"];
    
    instaSearch.type = @"com.greg0109.instaSearch.item";
    return [orig arrayByAddingObject:instaSearch];
	}
	return orig;
}

static void _logos_meta_method$_ungrouped$SBIconView$activateShortcut$withBundleIdentifier$forIconView$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, SBSApplicationShortcutItem* item, NSString* bundleID, id iconView){
	if ([[item type] isEqualToString:@"com.greg0109.instaSearch.item"]){
    if ([bundleID isEqualToString:@"com.burbn.instagram"]) {
      NSString *urlScheme = @"instagram://explore";
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlScheme]];
    }
	}
	_logos_meta_orig$_ungrouped$SBIconView$activateShortcut$withBundleIdentifier$forIconView$(self, _cmd, item, bundleID, iconView);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBIconView = objc_getClass("SBIconView"); Class _logos_metaclass$_ungrouped$SBIconView = object_getClass(_logos_class$_ungrouped$SBIconView); MSHookMessageEx(_logos_class$_ungrouped$SBIconView, @selector(applicationShortcutItems), (IMP)&_logos_method$_ungrouped$SBIconView$applicationShortcutItems, (IMP*)&_logos_orig$_ungrouped$SBIconView$applicationShortcutItems);MSHookMessageEx(_logos_metaclass$_ungrouped$SBIconView, @selector(activateShortcut:withBundleIdentifier:forIconView:), (IMP)&_logos_meta_method$_ungrouped$SBIconView$activateShortcut$withBundleIdentifier$forIconView$, (IMP*)&_logos_meta_orig$_ungrouped$SBIconView$activateShortcut$withBundleIdentifier$forIconView$);} }
#line 94 "Tweak.x"
