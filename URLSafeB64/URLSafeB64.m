//
//  URLSafeB64.m
//  URLSafeB64
//
//  Created by Krupal Ghorpade on 29/03/21.
//

#import "URLSafeB64.h"

//
// Mapping from 6 bit pattern to ASCII character.
//
static unsigned char urlSafeBase64EncodeLookupArray[65] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
static unsigned char base64EncodeLookupArray[65] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
//
// Definition for "masked-out" areas of the base64DecodeLookup mapping
//
#define kk 65
#define xx 65

//
// Mapping from ASCII character to 6 bit pattern.
//
static unsigned char base64DecodeLookupArray[256] =
{
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 62, xx, xx, xx, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, xx, xx, xx, xx, xx, xx,
    xx,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, xx, xx, xx, xx, xx,
    xx, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
};

static unsigned char urlSafeBase64DecodeLookupArray[256] =
{
    kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk,
    kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk,
    kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, 62, kk, kk,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, kk, kk, kk, kk, kk, kk,
    kk,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, kk, kk, kk, kk, 63,
    kk, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, kk, kk, kk, kk, kk,
    kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk,
    kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk,
    kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk,
    kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk,
    kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk,
    kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk,
    kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk,
    kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk, kk,
};

//
// Fundamental sizes of the binary and base64 encode/decode units in bytes
//
#define BINARY_UNIT_SIZE 3
#define BASE64_UNIT_SIZE 4

void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength,
                      bool isUrlSafe)
{
    if (length == -1) {
        length = strlen(inputBuffer);
    }
    
    
    size_t outputBufferSize =
    ((length+BASE64_UNIT_SIZE-1) / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE;
    unsigned char *outputBuffer = (unsigned char *)malloc(outputBufferSize);
    
    size_t i = 0;
    size_t j = 0;
    while (i < length) {
    
        unsigned char accumulated[BASE64_UNIT_SIZE];
        size_t accumulateIndex = 0;
        unsigned char decode = '\0';
        while (i < length) {
            if(isUrlSafe)
                decode = urlSafeBase64DecodeLookupArray[inputBuffer[i++]];
            else
                decode = base64DecodeLookupArray[inputBuffer[i++]];
            if (decode != kk) {
                accumulated[accumulateIndex] = decode;
                accumulateIndex++;
                
                if (accumulateIndex == BASE64_UNIT_SIZE) {
                    break;
                }
            }
        }
    
        if(accumulateIndex >= 2)
            outputBuffer[j] = (accumulated[0] << 2) | (accumulated[1] >> 4);
        if(accumulateIndex >= 3)
            outputBuffer[j + 1] = (accumulated[1] << 4) | (accumulated[2] >> 2);
        if(accumulateIndex >= 4)
            outputBuffer[j + 2] = (accumulated[2] << 6) | accumulated[3];
        j += accumulateIndex - 1;
    }
    
    if (outputLength) {
        *outputLength = j;
    }
    return outputBuffer;
}

char *NewBase64Encode(
                      const void *buffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength,
                      bool isUrlSafe)
{
    const unsigned char *inputBuffer = (const unsigned char *)buffer;
    
#define MAX_NUM_PADDING_CHARS 2
#define OUTPUT_LINE_LENGTH 64
#define INPUT_LINE_LENGTH ((OUTPUT_LINE_LENGTH / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE)
#define CR_LF_SIZE 2
    
    //
    // Byte accurate calculation of final buffer size
    //
    size_t outputBufferSize =
    ((length / BINARY_UNIT_SIZE)
     + ((length % BINARY_UNIT_SIZE) ? 1 : 0))
    * BASE64_UNIT_SIZE;
    if (separateLines) {
        outputBufferSize += (outputBufferSize / OUTPUT_LINE_LENGTH) * CR_LF_SIZE;
    }
    
    //
    // Include space for a terminating zero
    //
    outputBufferSize += 1;
    
    //
    // Allocate the output buffer
    //
    char *outputBuffer = (char *)malloc(outputBufferSize);
    if (!outputBuffer) {
        return NULL;
    }
    
    size_t i = 0;
    size_t j = 0;
    const size_t lineLength = separateLines ? INPUT_LINE_LENGTH : length;
    size_t lineEnd = lineLength;
    
    while (true) {
        if (lineEnd > length) {
            lineEnd = length;
        }
        
        for (; i + BINARY_UNIT_SIZE - 1 < lineEnd; i += BINARY_UNIT_SIZE) {
            // Inner loop: turn 48 bytes into 64 base64 characters
            if(isUrlSafe){
                outputBuffer[j++] = urlSafeBase64EncodeLookupArray[(inputBuffer[i] & 0xFC) >> 2];
                outputBuffer[j++] = urlSafeBase64EncodeLookupArray[((inputBuffer[i] & 0x03) << 4)
                                                       | ((inputBuffer[i + 1] & 0xF0) >> 4)];
                outputBuffer[j++] = urlSafeBase64EncodeLookupArray[((inputBuffer[i + 1] & 0x0F) << 2)
                                                       | ((inputBuffer[i + 2] & 0xC0) >> 6)];
                outputBuffer[j++] = urlSafeBase64EncodeLookupArray[inputBuffer[i + 2] & 0x3F];
            } else {
                outputBuffer[j++] = base64EncodeLookupArray[(inputBuffer[i] & 0xFC) >> 2];
                outputBuffer[j++] = base64EncodeLookupArray[((inputBuffer[i] & 0x03) << 4)
                                                       | ((inputBuffer[i + 1] & 0xF0) >> 4)];
                outputBuffer[j++] = base64EncodeLookupArray[((inputBuffer[i + 1] & 0x0F) << 2)
                                                       | ((inputBuffer[i + 2] & 0xC0) >> 6)];
                outputBuffer[j++] = base64EncodeLookupArray[inputBuffer[i + 2] & 0x3F];
            }
        }
        
        if (lineEnd == length) {
            break;
        }

        outputBuffer[j++] = '\r';
        outputBuffer[j++] = '\n';
        lineEnd += lineLength;
    }
    
    if (i + 1 < length) {
        if(isUrlSafe) {
            outputBuffer[j++] = urlSafeBase64EncodeLookupArray[(inputBuffer[i] & 0xFC) >> 2];
            outputBuffer[j++] = urlSafeBase64EncodeLookupArray[((inputBuffer[i] & 0x03) << 4)
                                                   | ((inputBuffer[i + 1] & 0xF0) >> 4)];
            outputBuffer[j++] = urlSafeBase64EncodeLookupArray[(inputBuffer[i + 1] & 0x0F) << 2];
            outputBuffer[j++] =    '=';
        } else {
            outputBuffer[j++] = base64EncodeLookupArray[(inputBuffer[i] & 0xFC) >> 2];
            outputBuffer[j++] = base64EncodeLookupArray[((inputBuffer[i] & 0x03) << 4)
                                                   | ((inputBuffer[i + 1] & 0xF0) >> 4)];
            outputBuffer[j++] = base64EncodeLookupArray[(inputBuffer[i + 1] & 0x0F) << 2];
            outputBuffer[j++] =    '=';
        }
    } else if (i < length) {
        // Handle the double '=' case
        if (isUrlSafe) {
            outputBuffer[j++] = urlSafeBase64EncodeLookupArray[(inputBuffer[i] & 0xFC) >> 2];
            outputBuffer[j++] = urlSafeBase64EncodeLookupArray[(inputBuffer[i] & 0x03) << 4];
            outputBuffer[j++] = '=';
            outputBuffer[j++] = '=';
        } else {
            outputBuffer[j++] = base64EncodeLookupArray[(inputBuffer[i] & 0xFC) >> 2];
            outputBuffer[j++] = base64EncodeLookupArray[(inputBuffer[i] & 0x03) << 4];
            outputBuffer[j++] = '=';
            outputBuffer[j++] = '=';
        }
    }
    outputBuffer[j] = 0;
    
    if (outputLength)
    {
        *outputLength = j;
    }
    return outputBuffer;
}

@implementation URLSafeB64

+ (NSData *)dataFromBase64String:(NSString *)base64EncodedString urlSafe:(BOOL)isUrlSafe {
    NSData *data = [base64EncodedString dataUsingEncoding:NSASCIIStringEncoding];
    size_t outputLength;
    void *outputBuffer = NewBase64Decode([data bytes], [data length], &outputLength, isUrlSafe);
    NSData *result = [NSData dataWithBytes:outputBuffer length:outputLength];
    free(outputBuffer);
    return result;
}

+ (NSString *)base64EncodedStringWithData:(NSData *)data urlSafe:(BOOL)isUrlSafe {
    size_t outputLength = 0;
    char *outputBuffer =
    NewBase64Encode([data bytes], [data length], false, &outputLength,isUrlSafe);
    
    NSString *base64EncodedString = [[NSString alloc]
                        initWithBytes:outputBuffer
                        length:outputLength
                        encoding:NSASCIIStringEncoding];
    free(outputBuffer);
    return base64EncodedString;
}


@end
