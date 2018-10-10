@protocol XipSlideDownVCDelegate <NSObject>

@optional

- (void) topWillOpen;
- (void) topDidOpen;
- (void) topWillClose;
- (void) topDidClose;

@end
