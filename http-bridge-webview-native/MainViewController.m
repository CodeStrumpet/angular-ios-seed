//
//  MainViewController.m
//  http-bridge-webview-native
//
//  Created by Paul Mans on 8/13/13.
//  Copyright (c) 2013 rockfakie. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "RoutingHTTPServer.h"

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation MainViewController

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

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *indexAddress = [documentsDirectory stringByAppendingPathComponent:@"html"];
    indexAddress = [indexAddress stringByAppendingPathComponent:@"index.html"];
    
    
    NSURL *indexURL = [NSURL fileURLWithPath:indexAddress];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:indexURL];
    [_webView loadRequest:urlRequest];
    
    
    
    [[AppDelegate instance].httpServer handleMethod:@"GET" withPath:@"/hello" block:^(RouteRequest *request, RouteResponse *response) {
        DDLogInfo(@"got /hello request");
        [response setHeader:@"Content-Type" value:@"application/json"];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"hello!" forKey:@"val"];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                           options:0
                                                             error:&error];
        
        
        [response respondWithData:jsonData];
        //[response respondWithString:@"['Hello!']"];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
