//
//  HHXMPPViewController.m
//  HHXMPPDemo
//
//  Created by FN-116 on 2021/11/9.
//

#import "HHXMPPViewController.h"
#import "XmppHelper.h"
#import "RosterTableViewController.h"

@interface HHXMPPViewController ()<XMPPHelperDelegate>
///账号输入框
@property (nonatomic, strong)UITextField *userNameTextField;
///密码输入框
@property (nonatomic, strong)UITextField *passwordTextField;
@end

@implementation HHXMPPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 60)];
    self.userNameTextField.backgroundColor = [UIColor cyanColor];
    self.userNameTextField.placeholder = @"请输入账号";
    [self.view addSubview:self.userNameTextField];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 100, 60)];
    self.passwordTextField.backgroundColor = [UIColor cyanColor];
    self.passwordTextField.placeholder = @"请输入密码";
    [self.view addSubview:self.passwordTextField];
    
    
    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    button0.backgroundColor = [UIColor cyanColor];
    button0.layer.masksToBounds = YES;
    button0.layer.cornerRadius = 20.0;
    button0.layer.borderColor = [UIColor blueColor].CGColor;
    button0.layer.borderWidth = 1.0;
    [button0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button0 setTitle:@"注册" forState:UIControlStateNormal];
    button0.frame = CGRectMake(50, 350, 90, 50);
    [button0 addTarget:self action:@selector(loginOrRegistAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button0];
    button0.tag = Regist;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor cyanColor];
    button1.layer.masksToBounds = YES;
    button1.layer.cornerRadius = 20.0;
    button1.layer.borderColor = [UIColor blueColor].CGColor;
    button1.layer.borderWidth = 1.0;
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitle:@"登陆" forState:UIControlStateNormal];
    button1.frame = CGRectMake(190, 350, 90, 50);
    [button1 addTarget:self action:@selector(loginOrRegistAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    button1.tag = Login;
    
    [XmppHelper shareXmppHelper].delegate = self;
}

#pragma mark  登陆\注册按钮方法
- (void)loginOrRegistAction:(UIButton *)sender {
    [[XmppHelper shareXmppHelper] loginOrRegistWithLoginOrRegist:sender.tag userName:self.userNameTextField.text password:self.passwordTextField.text];
}

#pragma mark 登陆成功方法回调
- (void)LoginSuccess:(XMPPStream *)sender {
    NSLog(@"登陆成功");
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [[XmppHelper shareXmppHelper].xmppStream sendElement:presence];
    //跳转到好友列表页面
    RosterTableViewController *rosterVC = [[RosterTableViewController alloc] init];
    UINavigationController *rostNC = [[UINavigationController alloc]initWithRootViewController:rosterVC];
    [self presentViewController:rostNC animated:YES completion:nil];
    
}

@end
