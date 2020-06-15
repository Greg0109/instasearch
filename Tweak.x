//com.burbn.instagram
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

//%new
- (bool)isBrowser:(NSString *)bundleID;
- (NSURL *)generateLink:(NSString *)url forApp:(NSString *)bundleID;
@end

@interface SBUIAppIconForceTouchControllerDataProvider : NSObject
- (NSString*)applicationBundleIdentifier;
- (bool)isBrowser:(NSString *)bundleID;
@end


%hook SBIconView
-(NSArray *) applicationShortcutItems {
	NSArray * orig = %orig;
	//MARK: App bundle and bundle IDs
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
    SBSApplicationShortcutItem* instaSearch = [[%c(SBSApplicationShortcutItem) alloc] init];
    instaSearch.localizedTitle = [NSString stringWithFormat:@"Search"];
    //instaSearch.localizedSubtitle = [NSString stringWithFormat: @"Search \"%@\"", pbStr];
    instaSearch.type = @"com.greg0109.instaSearch.item";
    return [orig arrayByAddingObject:instaSearch];
	}
	return orig;
}

+(void) activateShortcut:(SBSApplicationShortcutItem*)item withBundleIdentifier:(NSString*)bundleID forIconView:(id)iconView{
	if ([[item type] isEqualToString:@"com.greg0109.instaSearch.item"]){
    if ([bundleID isEqualToString:@"com.burbn.instagram"]) {
      NSString *urlScheme = @"instagram://explore";
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlScheme]];
    }
	}
	%orig;
}

%end
