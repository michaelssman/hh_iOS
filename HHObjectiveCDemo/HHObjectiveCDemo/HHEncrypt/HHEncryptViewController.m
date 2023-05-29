//
//  HHEncryptViewController.m
//  HHEncrypt
//
//  Created by FN-116 on 2021/12/13.
//

#import "HHEncryptViewController.h"
#import "NSData+AES256.h"
#import "NSString+MD5.h"
#import "NSString+Base64.h"
@interface HHEncryptViewController ()

@end

@implementation HHEncryptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor cyanColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 20.0;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    button.layer.borderWidth = 1.0;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"test button" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.frame = CGRectMake(50, 150, 100, 80);
    [button addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectPhoto {
    NSString *str = [@"aHR0cDovL21maW50LWg1LnhpdTM2MS5jbi9ndWFyZC9ndWFyZFJvb20=" base64DecodingString];
    NSData *data = [[NSData alloc] initWithContentsOfFile:@"/Users/ebsinori/Downloads/20170104162807_1_200.yyt"];
    NSData *decrypted = [data aes256_decrypt:@"ed2885ed60eba7b7"];
    [decrypted writeToFile:@"/Users/ebsinori/Downloads/20170104162807_1_200.zip" atomically:NO];
}

@end
