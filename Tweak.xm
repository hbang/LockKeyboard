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
