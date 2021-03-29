//
//  URLSafeB64Tests.m
//  URLSafeB64Tests
//
//  Created by Krupal Ghorpade on 29/03/21.
//

#import <XCTest/XCTest.h>
#import "URLSafeB64.h"

#define SAMPLE_STRING @"This is a sample text + sample followed by /"
#define SAMPLE_B64_STRING @"VGhpcyBpcyBhIHNhbXBsZSB0ZXh0ICsgc2FtcGxlIGZvbGxvd2VkIGJ5IC8="

#define B64_URL_UNSAFE_STRING @"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEZjPPlakshTyuc/DnqqigEp8Cyqe9G/Koee/xXEC526KAQkcyus+jLcADSqnol4x14RHoJFf6llfGKop79rxKFw=="

#define B64_URL_SAFE_STRING @"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEZjPPlakshTyuc_DnqqigEp8Cyqe9G_Koee_xXEC526KAQkcyus-jLcADSqnol4x14RHoJFf6llfGKop79rxKFw=="

@interface URLSafeB64Tests : XCTestCase

@end

@implementation URLSafeB64Tests

- (void)testB64Encoding{
    NSData *data = [SAMPLE_STRING dataUsingEncoding:NSUTF8StringEncoding];
    NSString *b64EncodedString = [URLSafeB64 base64EncodedStringWithData:data urlSafe:YES];
    NSAssert([b64EncodedString isEqualToString:SAMPLE_B64_STRING], @"Invalid conversion to B64 string");
}

- (void)testStringToDataConversion{
    NSData *urlUnSafeDataRegular     = [[NSData alloc]initWithBase64EncodedString:B64_URL_UNSAFE_STRING
                                                                          options:NSDataBase64DecodingIgnoreUnknownCharacters];

    // Check URLSafeB64's method
    NSData *urlSafeData              = [URLSafeB64 dataFromBase64String:B64_URL_UNSAFE_STRING urlSafe:YES];
    NSData *urlUnSafeDataUsingHelper = [URLSafeB64 dataFromBase64String:B64_URL_UNSAFE_STRING urlSafe:NO];

    // Assertions
    NSAssert(![urlSafeData isEqual:urlUnSafeDataRegular], @"URLSafe data must not be equal to URLUnSafe data");
    NSAssert([urlUnSafeDataRegular isEqual:urlUnSafeDataUsingHelper], @"Regular data conversion must be equal to url unsafe data");
}

- (void)testDataToStringConversion{
    
    NSData *urlUnSafeDataRegular = [[NSData alloc]initWithBase64EncodedString:B64_URL_UNSAFE_STRING options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    // Check URLSafeB64's method
    NSString *urlSafeString     = [URLSafeB64 base64EncodedStringWithData:urlUnSafeDataRegular urlSafe:YES];
    NSString *urlUnSafeString   = [URLSafeB64 base64EncodedStringWithData:urlUnSafeDataRegular urlSafe:NO];
    
    // Assertions
    NSAssert([urlSafeString isEqual:B64_URL_SAFE_STRING], @"URLSafe string must be equal to original safe string");
    NSAssert([urlUnSafeString isEqual:B64_URL_UNSAFE_STRING], @"URLUnSafe string must be equal to original unsafe string");
}

@end
