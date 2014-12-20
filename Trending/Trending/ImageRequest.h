//
//  ImageRequest.h
//  Trending
//
//  Created by Andrew on 12/1/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#define kIMAGE_REQUEST_CACHE_LIMIT  100
typedef void (^CompletionBlock) (UIImage *, NSError *);

@interface ImageRequest : NSMutableURLRequest

- (UIImage *)cachedResult;
- (void)startWithCompletion:(CompletionBlock)completion;

@end
