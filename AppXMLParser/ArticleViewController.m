//
//  ArticleViewController.m
//  AppXMLParser
//
//  Created by Hieu on 8/28/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()

@end

@implementation ArticleViewController
@synthesize ArticlesTableView;
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
    self.ArticlesTableView.delegate = self;
    self.ArticlesTableView.dataSource = self;
    [self parseXMLFileAtURL:@"http://www.croplifeamerica.org/rss.xml"];
    //pListPath = [[NSBundle mainBundle]pathForResource:@"ArticleList" ofType:@"plist"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"File found and parsing started");
    
}

- (void)parseXMLFileAtURL:(NSString *)URL{
    NSString *agentString = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-us) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/3.2.1 Safari/525.27.1";
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    [request setValue:agentString forHTTPHeaderField:@"User-Agent"];
    NSData * xmlFile = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    articles = [[NSMutableArray alloc]init];
    errorParsing = NO;
    rssParser = [[NSXMLParser alloc]initWithData:xmlFile];
    [rssParser setDelegate:self];
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
    [rssParser parse];
}

- (IBAction)loadArticles:(id)sender {
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:pListPath];
    if (!plistXML) {
        NSLog(@"can't find the files");
    }
    NSDictionary * temp = (NSDictionary * ) [NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    DataReadFromPList = [temp copy];
    NSLog(@"%@", DataReadFromPList);
    
    [ArticlesTableView reloadData];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    ElementValue = [[NSMutableString alloc]init];
    if ([elementName isEqualToString:@"item"]) {
        dic = [[NSMutableDictionary alloc]init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [ElementValue appendString:string];
    NSCharacterSet * charToTrim = [NSCharacterSet characterSetWithCharactersInString:@" \n"];
    
    NSString *trimmedString = [ElementValue stringByTrimmingCharactersInSet:charToTrim];
    [ElementValue setString:trimmedString];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"item"]) {
        [articles addObject:[dic copy]];
    }
    else{
        [dic setObject:ElementValue forKey:elementName];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (errorParsing == NO)
    {
        NSLog(@"XML processing done!");
//        NSLog(@"%@", articles);
        NSString * error;
        int artnum = 0;
        NSMutableDictionary * pListdic = [[NSMutableDictionary alloc]init];
        for (NSDictionary * article in articles) {
            artnum++;
            NSString * articleName = [NSString stringWithFormat:@"Article %d",artnum];
            [pListdic setObject:article forKey:articleName];
        }
        
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        pListPath = [rootPath stringByAppendingPathComponent:@"Articles.plist"];
        NSLog(@"%@", pListPath);

        NSData * plistData = [NSPropertyListSerialization dataFromPropertyList:pListdic format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
        if (plistData) {
            NSLog(@"writing");
//            [plistData writeToFile:pListPath atomically:YES];
            NSFileManager * fileManager  = [NSFileManager defaultManager];
            BOOL success = [fileManager createFileAtPath:pListPath contents:plistData attributes:nil];
            if (success) {
                NSLog(@"successfully create a file");
            }
        }
    } else {
        NSLog(@"Error occurred during XML processing");
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    return [DataReadFromPList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
    }
    int rnum = (int)[indexPath row] + 1;
    NSString * labelIndex = [NSString stringWithFormat:@"Article %d",rnum];
    NSString * labelName = [[DataReadFromPList objectForKey:labelIndex] objectForKey:@"title"];
    NSLog(@"%@", labelName);
    cell.textLabel.text = labelName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebViewViewController * destination = [self.storyboard instantiateViewControllerWithIdentifier:@"webview"];
    int rnum = (int)[indexPath row] + 1;
    NSString * labelIndex = [NSString stringWithFormat:@"Article %d",rnum];
    //NSLog(@"%@", labelIndex);
    NSString * URL = [[DataReadFromPList objectForKey:labelIndex] objectForKey:@"link"];
    [destination setUrl:URL];
    [self.navigationController pushViewController:destination animated:YES];
}

@end
