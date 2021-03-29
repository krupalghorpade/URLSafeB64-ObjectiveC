//
//  URLSafeB64.h
//  URLSafeB64
//
//  Created by Krupal Ghorpade on 29/03/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLSafeB64 : NSObject

+ (NSData *_Nullable)dataFromBase64String:(NSString *_Nonnull)base64EncodedString
                                  urlSafe:(BOOL)isUrlSafe;

+ (NSString *_Nullable)base64EncodedStringWithData:(NSData *_Nonnull)data
                                           urlSafe:(BOOL)isUrlSafe;

@end

NS_ASSUME_NONNULL_END
