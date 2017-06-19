//
//  WXMLFaceDetect.m
//  WeexMLExamples
//
//  Created by yinfeng on 2017/6/15.
//  Copyright © 2017年 yinfeng. All rights reserved.
//

#import "WXMLFaceDetect.h"
#import <Vision/Vision.h>

@implementation WXMLFaceDetect

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(detectLandmarks:callback:))

- (void)detectLandmarks:(NSString *)ref callback:(WXModuleCallback)callback
{
    WXPerformBlockOnComponentThread(^{
        WXComponent *component = [self.weexInstance componentForRef:ref];
        UIImageView *imageView = (UIImageView *)component.view;
        if (![imageView isKindOfClass:[UIImageView class]]) {
            WXLogError(@"error component ref for image");
            return ;
        }
        WXPerformBlockOnMainThread(^{
            [self _detectLandmarks:imageView.image.CGImage width:imageView.bounds.size.width height:imageView.bounds.size.height callback:callback];
        });
    });
}

- (void)_detectLandmarks:(CGImageRef)image width:(CGFloat)width height:(CGFloat)height callback:(WXModuleCallback)callback
{
    CGFloat scaleFactor = self.weexInstance.pixelScaleFactor;
    width = width / scaleFactor;
    height = height / scaleFactor;
    VNDetectFaceLandmarksRequest *request = [[VNDetectFaceLandmarksRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        NSArray<VNFaceObservation *> *results = request.results;
        NSMutableArray *callbackArray = [NSMutableArray arrayWithCapacity:1];
        for (VNFaceObservation *result in results) {
            NSMutableDictionary *faceDetectResult = [NSMutableDictionary dictionary];
            VNFaceLandmarks2D *landmarks = result.landmarks;
            if (!landmarks) {
                continue;
            }
            
            CGRect boundingBox = result.boundingBox;
            CGRect boundingRect = CGRectMake(boundingBox.origin.x * width, boundingBox.origin.y * height, boundingBox.size.width * width, boundingBox.size.height * height);
            faceDetectResult[@"boundingBox"] = @{@"x":@(boundingRect.origin.x),
                                               @"y":@(boundingRect.origin.y),
                                               @"width":@(boundingRect.size.width),
                                               @"height":@(boundingRect.size.height)};
            
            if (landmarks.faceContour) {
                faceDetectResult[@"faceContour"] = [self pointsFromLandmarkRegion:landmarks.faceContour rect:boundingRect];
            }
            if (landmarks.leftEye) {
                faceDetectResult[@"leftEye"] = [self pointsFromLandmarkRegion:landmarks.leftEye rect:boundingRect];
            }
            if (landmarks.rightEye) {
                faceDetectResult[@"rightEye"] = [self pointsFromLandmarkRegion:landmarks.rightEye rect:boundingRect];
            }
            if (landmarks.nose) {
                faceDetectResult[@"nose"] = [self pointsFromLandmarkRegion:landmarks.nose rect:boundingRect];
            }
            if (landmarks.noseCrest) {
                faceDetectResult[@"noseCrest"] = [self pointsFromLandmarkRegion:landmarks.noseCrest rect:boundingRect];
            }
            if (landmarks.medianLine) {
                faceDetectResult[@"medianLine"] = [self pointsFromLandmarkRegion:landmarks.medianLine rect:boundingRect];
            }
            if (landmarks.outerLips) {
                faceDetectResult[@"outerLips"] = [self pointsFromLandmarkRegion:landmarks.outerLips rect:boundingRect];
            }
            
            [callbackArray addObject:faceDetectResult];
        }
        
        callback(callbackArray);
    }];
    
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image options:@{}];
    [handler performRequests:@[request] error:nil];
}

- (NSArray *)pointsFromLandmarkRegion:(VNFaceLandmarkRegion2D *)region rect:(CGRect)rect
{
    NSMutableArray *points = [NSMutableArray array];
    for (int i = 0; i < region.pointCount; i++) {
        vector_float2 point = [region pointAtIndex:i];
        [points addObject:@{@"x":@(rect.origin.x + point.x * rect.size.width),
                            @"y":@(rect.origin.y + point.y * rect.size.height)}];
    }
    
    return points;
}

@end
