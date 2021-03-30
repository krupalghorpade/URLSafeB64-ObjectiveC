//
//  URLSafeB64Tests.m
//  URLSafeB64Tests
//
//  Created by Krupal Ghorpade on 29/03/21.
//

#import <XCTest/XCTest.h>
#import "NSString+URLSafeB64.h"

#define SAMPLE_STRING @"0Y0^S^F^G*H=^B^A^F^H*H=^C^A^G^CB^Df3ϕ"
 
@interface URLSafeB64Tests : XCTestCase

@end

@implementation URLSafeB64Tests

- (void)testB64Conversion{
    NSString *b64EncodedString = [SAMPLE_STRING urlSafeB64Encoded];
    NSString *b64DecodedString = [b64EncodedString urlSafeB64Decoded];
    NSAssert([b64DecodedString isEqualToString:SAMPLE_STRING], @"Conversion should produce original string");
}

@end
