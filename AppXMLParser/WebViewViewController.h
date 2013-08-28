//
//  WebViewViewController.h
//  AppXMLParser
//
//  Created by Hieu on 8/28/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewViewController : UIViewController{
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) UIActivityIndicatorView * animate;


@end
