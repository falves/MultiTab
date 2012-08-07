//
//  HomeViewController.m
//  MultiTab
//
//  Created by Mariana Meirelles on 8/7/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) NSMutableArray * listaDeMesas;

@end

@implementation HomeViewController

@synthesize listaDeMesas = _listaDeMesas;

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

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    
    if ([self.listaDeMesas count] == 0) {
        CellIdentifier = @"mesasVaziaCell";
    } else {
        CellIdentifier = @"mesasCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.listaDeMesas count] == 0) {
        return 1;
    } else {
        return [self.listaDeMesas count];
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
