//
//  WXMLImageRecognition.m
//  WeexML
//
//  Created by yinfeng on 2017/6/12.
//  Copyright © 2017年 yinfeng. All rights reserved.
//

#import "WXMLImageRecognition.h"
#import <Vision/Vision.h>
#import <CoreML/CoreML.h>
#import "Inceptionv3.h"

@implementation WXMLImageRecognition

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(predictWithImage:callback:))
WX_EXPORT_METHOD(@selector(predictWithURL:callback:))

- (void)predictWithImage:(NSString *)imageRef callback:(WXModuleCallback)callback
{
    WXPerformBlockOnComponentThread(^{
        WXComponent *component = [self.weexInstance componentForRef:imageRef];
        UIImageView *imageView = (UIImageView *)component.view;
        if (![imageView isKindOfClass:[UIImageView class]]) {
            WXLogError(@"error component ref for image");
            return ;
        }
        WXPerformBlockOnMainThread(^{
            [self _predict:imageView.image.CGImage callback:callback];
        });
    });
}

- (void)predictWithURL:(NSString *)url callback:(WXModuleCallback)callback
{
    
}

- (void)_predict:(CGImageRef)image callback:(WXModuleCallback)callback
{
    VNCoreMLModel *model = [VNCoreMLModel modelForMLModel:[Inceptionv3 new].model error:nil];
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
