//
//  DetalhesClienteViewController.m
//  MultiTab
//
//  Created by Mariana Meirelles on 8/14/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import "DetalhesClienteViewController.h"

@interface DetalhesClienteViewController ()

@end

@implementation DetalhesClienteViewController

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
