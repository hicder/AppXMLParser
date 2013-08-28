//
//  WebViewViewController.m
//  AppXMLParser
//
//  Created by Hieu on 8/28/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController
@synthesize url, animate, webView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"%@", url);
	// Do any additional setup after loading the view.
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [act setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.5]];
    self.animate = act;
    [webView addSubview:self.animate];
    act.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:act attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:webView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:act attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:webView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    NSURL *urlString = [NSURL URLWithString:url];
    [webView loadRequest:[NSURLRequest requestWithURL:urlString]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.animate startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.animate stopAnimating];
}


@end
