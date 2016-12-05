//
//  MCEncrypt.m
//  WebBridgeNativeExample
//
//  Created by marco chen on 2016/12/5.
//  Copyright © 2016年 marco chen. All rights reserved.
//

#import "MCEncrypt.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation MCEncrypt
//客户端加密
+(NSDictionary*)encryptWithDESAndRSA:(NSData*) data withKey:(NSString*)key keyPath:(NSString*)keyPath{
    
    //rsa
    NSString* encryptedKey = [self RSAEncryptData:key keyPath:keyPath];
    
    //des
    NSData* encryptedData = [self DESEncrypt:data WithKey:key];
    NSString* encryptedBase64 = [encryptedData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:encryptedKey,@"key",encryptedBase64,@"data",nil];
    return dict;
}

+(NSString*)RSAEncryptData:(NSString*)text keyPath:(NSString*)keyPath{
    NSData* data = [self RSAEncryptToData:text keyPath:keyPath];
    NSString* encryptedKey = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encryptedKey;
}

+(NSData*)RSAEncryptToData:(NSString*)text keyPath:(NSString*)keyPath{
    NSData* encryptData = nil;
    if (!keyPath) {
        keyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    }
    WDRSACrypt *rsa = [[WDRSACrypt alloc] initWithKeyPath:keyPath];
    if (rsa != nil) {
        encryptData = [rsa encryptWithString:text];
    }else {
        //        NSLog(@"init rsa error");
    }
    return encryptData;
}

+(NSString*)DESEncryptWithBase64:(NSString*)str key:(NSString*)key{
    NSData* data = [str dataUsingEncoding:(NSUTF8StringEncoding)];
    NSData* encryptData = [self DESEncrypt:data WithKey:key];
    NSString* base64 = [encryptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64;
}

+(NSString*)DESDecryptBase64:(NSString*)base64 key:(NSString*)key{
    NSData* encryptData = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData* data = [self DESDecrypt:encryptData WithKey:key];
    NSString* decryptStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return decryptStr;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}
@end



@implementation WDRSACrypt

- (id)initWithKeyPath:(NSString*) publicKeyPath{
    self = [super init];
    
    if (publicKeyPath == nil) {
        //        NSLog(@"Can not find pub.der");
        return nil;
    }
    
    NSData *publicKeyFileContent = [NSData dataWithContentsOfFile:publicKeyPath];
    
    if (publicKeyFileContent == nil) {
        //        NSLog(@"Can not read from pub.der");
        return nil;
    }
    
    certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)publicKeyFileContent);
    if (certificate == nil) {
        //        NSLog(@"Can not read certificate from pub.der");
        return nil;
    }
    
    policy = SecPolicyCreateBasicX509();
    OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
    if (returnCode != 0) {
        //        NSLog(@"SecTrustCreateWithCertificates fail. Error Code: %d", (int)returnCode);
        return nil;
    }
    
    SecTrustResultType trustResultType;
    returnCode = SecTrustEvaluate(trust, &trustResultType);
    if (returnCode != 0) {
        //        NSLog(@"SecTrustEvaluate fail. Error Code: %d", (int)returnCode);
        return nil;
    }
    
    publicKey = SecTrustCopyPublicKey(trust);
    if (publicKey == nil) {
        
        //        NSLog(@"SecTrustCopyPublicKey fail");
        return nil;
    }
    
    maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
    return self;
}

- (NSData *) encryptWithData:(NSData *)content {
    
    size_t plainLen = [content length];
    if (plainLen > maxPlainLen) {
        //        NSLog(@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
        return nil;
    }
    
    void *plain = malloc(plainLen);
    [content getBytes:plain
               length:plainLen];
    
    size_t cipherLen = 128; // 当前RSA的密钥长度是128字节
    void *cipher = malloc(cipherLen);
    
    OSStatus returnCode = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, plain,
                                        plainLen, cipher, &cipherLen);
    
    NSData *result = nil;
    if (returnCode != 0) {
        //        NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)returnCode);
    }
    else {
        result = [NSData dataWithBytes:cipher
                                length:cipherLen];
    }
    
    free(plain);
    free(cipher);
    
    return result;
}

- (NSData *) encryptWithString:(NSString *)content {
    return [self encryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)dealloc{
    CFRelease(certificate);
    CFRelease(trust);
    CFRelease(policy);
    CFRelease(publicKey);
}
@end
