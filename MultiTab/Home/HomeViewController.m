//
//  HomeViewController.m
//  MultiTab
//
//  Created by Mariana Meirelles on 8/7/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import "HomeViewController.h"
#import "MesaViewController.h"
#import "AppDelegate.h"
#import "Mesa.h"

@interface HomeViewController ()
{
    IBOutlet UITableView *tableMesas;
}

@property (nonatomic, strong) NSMutableArray * listaDeMesas;
@property (nonatomic, strong) NSManagedObjectContext * context;
@property (nonatomic) AppDelegate * delegate;
@property (nonatomic) BOOL deletouUltimaMesa;

- (void) atualizaDataSource;

@end

@implementation HomeViewController

@synthesize listaDeMesas = _listaDeMesas;
@synthesize context = _context;
@synthesize delegate = _delegate;
@synthesize deletouUltimaMesa;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self atualizaDataSource];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    self.context = [self.delegate managedObjectContext];
    
    self.title = @"Home";
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

#pragma mark - Métodos auxiliares

- (void) atualizaDataSource {
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Mesa" inManagedObjectContext:self.context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];

    
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:request error:&error];
    
    if (array != nil) {
        self.listaDeMesas = [array copy];
    }
    
    [tableMesas reloadData];
    
}

#pragma mark - UITableViewDatasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Mesas cadastradas";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    
    if ([self.listaDeMesas count] == 0) {
        CellIdentifier = @"mesasVaziaCell";
    } else {
        CellIdentifier = @"mesasCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([self.listaDeMesas count] != 0) {
        
        Mesa * mesa = [self.listaDeMesas objectAtIndex:indexPath.row];
        cell.textLabel.text = mesa.nome;
        
        NSSet * setClientes = [mesa clientesDaMesa];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d pessoas",[setClientes count]];
    }
    
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.listaDeMesas count] == 0 && !self.deletouUltimaMesa) {
        return 1;
    } else {
        return [self.listaDeMesas count];
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"segueMesaExistente" sender:[self.listaDeMesas objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    MesaViewController * mesaVC = [segue destinationViewController];

    if ([[segue identifier] isEqualToString:@"segueMesaNova"]) {
        [mesaVC setNovaMesa:YES];
    } else {
        [mesaVC setMesa:sender];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView beginUpdates];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Mesa * mesa = [self.listaDeMesas objectAtIndex:indexPath.row];
        
        [self.context deleteObject:mesa];
        [self.delegate saveContext];
        [self atualizaDataSource];
        
        if ([self.listaDeMesas count] == 0) {
            self.deletouUltimaMesa = YES;
        } else {
            self.deletouUltimaMesa = NO;
        }
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
    }
    
    [tableView endUpdates];
    
    if (self.deletouUltimaMesa) {
        self.deletouUltimaMesa = NO;
        [tableMesas reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

@end
