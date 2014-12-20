//
//  ImageRequest.m
//  Trending
//
//  Created by Andrew on 12/1/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "ImageRequest.h"

NSMutableDictionary *_inflight;
NSCache *_imageCache;

@implementation ImageRequest

- (NSMutableDictionary *)inflight {
    
    if (!_inflight) {
        _inflight = [NSMutableDictionary dictionary];
    }
    return _inflight;
}

- (NSCache *)imageCache {
    
    if (!_imageCache) {
        _imageCache = [[NSCache alloc] init];
        _imageCache.countLimit = kIMAGE_REQUEST_CACHE_LIMIT;
    }
    return _imageCache;
}

- (UIImage *)cachedResult {
    
    return [self.imageCache objectForKey:self];
}

- (void)startWithCompletion:(CompletionBlock)completion {
    
    UIImage *image = [self cachedResult];
    if (image) return completion(image, nil);
    
    NSMutableArray *inflightCompletionBlocks = [self.inflight objectForKey:self];
    if (inflightCompletionBlocks) {
        // a matching request is in flight, keep the completion block to run when we're finished
        [inflightCompletionBlocks addObject:completion];
    } else {
        [self.inflight setObject:[NSMutableArray arrayWithObject:completion] forKey:self];
        
        [NSURLConnection sendAsynchronousRequest:self queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (!error) {
                // build an image, cache the result and run completion blocks for this request
                UIImage *image = [UIImage imageWithData:data];
                [self.imageCache setObject:image forKey:self];
                
                id value = [self.inflight objectForKey:self];
                [self.inflight removeObjectForKey:self];
                
                for (CompletionBlock block in (NSMutableArray *)value) {
                    block(image, nil);
                }
            } else {
                [self.inflight removeObjectForKey:self];
                completion(nil, error);
            }
        }];
    }
}

@end