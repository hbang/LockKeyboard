#import <AppSupport/CPBitmapStore.h>
#import <UIKit/UIKeyboardCache.h>
#import <UIKit/UIKBRenderConfig.h>
#import <UIKit/UIKBRenderFactoryiPhonePasscode.h>
#import <UIKit/UIKBRenderFactoryiPadPasscode.h>
#import <UIKit/UIKBRenderFactoryiPadLandscapePasscode.h>

#pragma mark - Keyboard hooks

BOOL override = NO;

#pragma mark - iPhone

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

%hook UIKBRenderFactoryiPad

+ (id)alloc {
	return override ? %orig : [%c(UIKBRenderFactoryiPadPasscode) alloc];
}

%end

%hook UIKBRenderFactoryiPadLandscape

+ (id)alloc {
	return override ? %orig : [%c(UIKBRenderFactoryiPadLandscapePasscode) alloc];
}

%end

%hook UIKBRenderFactoryiPhonePasscode

+ (id)alloc {
	override = YES;
	return %orig;
}

%end

%hook UIKBRenderFactoryiPadPasscode

+ (id)alloc {
	override = YES;
	return %orig;
}

%end

%hook UIKBRenderFactoryiPadLandscapePasscode

+ (id)alloc {
	override = YES;
	return %orig;
}

%end

#pragma mark - Render config

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
