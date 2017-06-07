//
//  ViewController.m
//  SHA256-Test
//
//  Created by Ticket Services on 07/06/17.
//  Copyright © 2017 Ticket. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtValue.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
        textField.text = @"";
    self.lblHashed.text = @"Your SHA256 Encoded Value";
}

-(IBAction)generateHash:(id)sender
{
    [self.txtValue resignFirstResponder];
    NSString* strInput =  self.txtValue.text;
    if(![self isNullOrEmpty:strInput])
    {
        self.lblHashed.text = [self generateSHA256: strInput];
    }
    
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please provide a valid string"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        

        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

//http://www.sha1-online.com/
//http://www.xorbin.com/tools/sha256-hash-calculator
-(NSString*) generateSHA256: (NSString*) inputString
{
    NSData *dataIn = [inputString dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData *dataOutput = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(dataIn.bytes, (CC_LONG)dataIn.length,  dataOutput.mutableBytes);
    
    NSString *result = [self hexDataToStringWithData:dataOutput withSpaces:NO];
    
    if(result)
    {
        return [result lowercaseString];
    }
    
    return @"Error!";
    
}


-(BOOL)isNullOrEmpty:(NSString*)string
{
    if (!string)
    {
        return YES;
    }
    if (string.length == 0)
    {
        return YES;
    }
    return NO;
}

// <478c63e5 76f47cac e292fadb ec171815 e3f6afc7 58f86e49 4b227c7e 07289e05> to
// 478C63E576F47CACE292FADBEC171815E3F6AFC758F86E494B227C7E07289E05
-(NSString*)hexDataToStringWithData:(NSData*)data withSpaces:(BOOL)spaces
{
    const unsigned char* bytes = (const unsigned char*)[data bytes];
    NSUInteger nbBytes = [data length];
    //If spaces is true, insert a space every this many input bytes (twice this many output characters).
    static const NSUInteger spaceEveryThisManyBytes = 4UL;
    //If spaces is true, insert a line-break instead of a space every this many spaces.
    static const NSUInteger lineBreakEveryThisManySpaces = 4UL;
    const NSUInteger lineBreakEveryThisManyBytes = spaceEveryThisManyBytes * lineBreakEveryThisManySpaces;
    NSUInteger strLen = 2*nbBytes + (spaces ? nbBytes/spaceEveryThisManyBytes : 0);
    
    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:strLen];
    for(NSUInteger i=0; i<nbBytes; ) {
        [hex appendFormat:@"%02X", bytes[i]];
        //We need to increment here so that the every-n-bytes computations are right.
        ++i;
        
        if (spaces) {
            if (i % lineBreakEveryThisManyBytes == 0) [hex appendString:@"\n"];
            else if (i % spaceEveryThisManyBytes == 0) [hex appendString:@" "];
        }
    }
    return hex;
}


@end
