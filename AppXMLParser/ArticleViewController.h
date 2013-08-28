//
//  ArticleViewController.h
//  AppXMLParser
//
//  Created by Hieu on 8/28/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewViewController.h"

@interface ArticleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSXMLParser * rssParser;
    NSMutableArray * articles;
    NSMutableDictionary * dic;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
    NSString *pListPath;
    
    NSMutableDictionary * DataReadFromPList;
}
- (void)parseXMLFileAtURL:(NSString *)URL;
- (IBAction)loadArticles:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *ArticlesTableView;

@end
