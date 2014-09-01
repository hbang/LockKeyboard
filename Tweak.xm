#import <UIKit/UIKeyboardCache.h>
#import <AppSupport/CPBitmapStore.h>

#pragma mark - Keyboard hooks

BOOL override = NO;

@interface UIKBRenderConfig : NSObject

+ (instancetype)defaultConfig;

@end

@interface UIKBRenderFactoryiPhonePasscode : UIKBRenderConfig

@end

%hook UIKBRenderFactoryiPhone

+ (id)alloc {
	if (override) {
		override = NO;
		return %orig;
	} else {
		return [%c(UIKBRenderFactoryiPhonePasscode) alloc];
	}
}

%end

%hook UIKBRenderFactoryiPhonePasscode

+ (id)alloc {
	override = YES;
	return %orig;
}

%end

/*
 this is one of those "i don't know why it works but it works" things.
*/

%hook UIKBRenderConfig

+ (UIKBRenderConfig *)darkConfig {
	return [self defaultConfig];
}

- (BOOL)lightKeyboard {
	return NO;
}

- (double)keycapOpacity {
	return 0.2f;
}

%end

#pragma mark - SpringBoard hooks

%group SpringBoardHooks
%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	%orig;

	CPBitmapStore *store = MSHookIvar<CPBitmapStore *>([%c(UIKeyboardCache) sharedInstance], "_store");
	[store purge];
}

%end
%end

#pragma mark - Constructor

%ctor {
	if (IN_SPRINGBOARD) {
		%init(SpringBoardHooks);
	}

	%init;
}
