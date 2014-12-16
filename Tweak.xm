#import <UIKit/UIKBRenderConfig.h>
#import <UIKit/UIKeyboardLayoutStar.h>
#import <UIKit/UIWindow+Private.h>

#define UIKeyboardAppearancePasscode 127

#pragma mark - Prevent from modifying real passcode keyboard

BOOL isActuallyLockScreen() {
	return %c(SBUIPasscodeTextField) && [UIApplication sharedApplication].keyWindow.firstResponder.class == %c(SBUIPasscodeTextField);
}

#pragma mark - Change keyboard appearance

%hook UIKeyboardLayoutStar

- (void)showKeyboardWithInputTraits:(id<UITextInputTraits>)inputTraits screenTraits:(id)screenTraits splitTraits:(id)splitTraits {
	if (inputTraits.keyboardAppearance != UIKeyboardAppearancePasscode) {
		inputTraits.keyboardAppearance = UIKeyboardAppearancePasscode;
	}

	%orig;
}

%end

#pragma mark - Fix outline alpha

%hook UIKBRenderConfig

- (double)keycapOpacity {
	return isActuallyLockScreen() ? %orig : 0.4f;
}

%end

#pragma mark - Hack to bring back dictation

BOOL dictationHack = NO;

%hook UIDictationController

+ (BOOL)fetchCurrentInputModeSupportsDictation {
	dictationHack = YES;
	BOOL result = %orig;
	dictationHack = NO;
	return result;
}

%end

%hook UITextInputTraits

- (UIKeyboardAppearance)keyboardAppearance {
	return dictationHack && !isActuallyLockScreen() ? 0 : %orig;
}

%end
