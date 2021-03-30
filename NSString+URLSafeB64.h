//
//  NSString+URLSafeB64.h
//  URLSafeB64
//
//  Created by Krupal Ghorpade on 30/03/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(URLSafeB64)

- (NSString* _Nullable)urlSafeB64Encoded;

- (NSString* _Nullable)urlSafeB64Decoded;

@end

NS_ASSUME_NONNULL_END
