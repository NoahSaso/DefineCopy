#define kName @"DefineCopy"
#import <Custom/defines.h>

#define appID CFSTR("com.sassoty.definecopy")

static BOOL enabled = YES;

static void reloadPrefs() {
	CFBooleanRef enabledBoolRef = (CFBooleanRef)CFPreferencesCopyAppValue(CFSTR("Enabled"), appID);
	enabled = (!enabledBoolRef ? YES : CFBooleanGetValue(enabledBoolRef));
}

%hook UITextField

- (void)_define:(id)arg1 {
	%orig;
	if(!enabled) return;
	XLog(Xstr(@"TextField _define: %@", arg1));
	[UIPasteboard generalPasteboard].string = [self textInRange:self.selectedTextRange];
}

%end

%hook UITextView

- (void)_define:(id)arg1 {
	%orig;
	if(!enabled) return;
	XLog(Xstr(@"TextView _define: %@", arg1));
	[UIPasteboard generalPasteboard].string = [self textInRange:self.selectedTextRange];
}

%end

@interface UIWebDocumentView : NSObject
@property(copy) UITextRange *selectedTextRange;
- (id)textInRange:(id)arg1;
@end

%hook UIWebDocumentView

- (void)_define:(id)arg1 {
	%orig;
	if(!enabled) return;
	XLog(Xstr(@"WebDocument _define: %@", arg1));
	[UIPasteboard generalPasteboard].string = [self textInRange:self.selectedTextRange];
}

%end

@interface WKContentView : UITextView
- (id)selectedText;
@end

%hook WKContentView

- (void)_define:(id)arg1 {
	%orig;
	if(!enabled) return;
	XLog(Xstr(@"Safari WKContent _define: %@", arg1));
	[UIPasteboard generalPasteboard].string = [self selectedText];
}

%end

%ctor {
	reloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback)reloadPrefs,
        CFSTR("com.sassoty.definecopy/preferencechanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
