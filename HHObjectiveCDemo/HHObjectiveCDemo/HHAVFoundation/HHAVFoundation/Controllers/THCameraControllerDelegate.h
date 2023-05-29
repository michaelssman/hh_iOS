
@protocol THCameraControllerDelegate <NSObject>
- (void)deviceConfigurationFailedWithError:(NSError *)error;
- (void)mediaCaptureFailedWithError:(NSError *)error;
@end

