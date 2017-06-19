//
//  WXMLDigitDetect.m
//  WeexML
//
//  Created by yinfeng on 2017/6/14.
//  Copyright © 2017年 yinfeng. All rights reserved.
//

#import "WXMLDigitDetect.h"
#import <CoreImage/CoreImage.h>
#import <Vision/Vision.h>
#import "MNIST.h"

@implementation WXMLDigitDetect

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(predictWithCanvas:callback:))

- (void)predictWithCanvas:(NSString *)canvasRef callback:(WXModuleCallback)callback
{
    WXPerformBlockOnComponentThread(^{
        WXComponent *component = [self.weexInstance componentForRef:canvasRef];
        WXPerformBlockOnMainThread(^{
            UIView *view = component.view;
            CGRect imageBounds = CGRectMake(0, 0, 28, 28);
            UIGraphicsBeginImageContextWithOptions(imageBounds.size, NO, [UIScreen mainScreen].scale);
            [view drawViewHierarchyInRect:imageBounds afterScreenUpdates:YES];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [self _predict:image.CGImage callback:callback];
        });
    });
}

- (void)_predict:(CGImageRef)image callback:(WXModuleCallback)callback
{
    VNCoreMLModel *model = [VNCoreMLModel modelForMLModel:[MNIST new].model error:nil];
    VNCoreMLRequest *request = [[VNCoreMLRequest alloc] initWithModel:model completionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < 10 && i < request.results.count; i++) {
            VNClassificationObservation *result = request.results[i];
            if (result.identifier && result.confidence) {
                NSString *identifier = @"";
                if ([result.identifier containsString:@", "]) {
                    identifier = [result.identifier componentsSeparatedByString:@", "][0];
                } else {
                    identifier = result.identifier;
                }
                [resultArray addObject:@{@"identifier":identifier, @"confidence":@(result.confidence)}];
            }
        }
        callback(resultArray);
    }];
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image options:@{}];
    [handler performRequests:@[request] error:nil];
}

@end
