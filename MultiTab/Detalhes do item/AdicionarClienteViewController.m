//
//  AdicionarClienteViewController.m
//  MultiTab
//
//  Created by Felipe on 14/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import "AdicionarClienteViewController.h"
#import "AppDelegate.h"

@interface AdicionarClienteViewController ()
{
    IBOutlet UITableView * tableClientes;
}

@property (nonatomic) AppDelegate * delegate;
@property (nonatomic) NSManagedObjectContext * context;
@property (nonatomic, strong) NSArray * listaDePessoas;
@property (nonatomic, strong) NSMutableArray * pessoasSelecionadas;

- (IBAction)pressionouAdicionarSelecionados:(UIButton*)sender;
- (void) atualizaDataSource;

@end

@implementation AdicionarClienteViewController

@synthesize mesa                    =_mesa;
@synthesize item                    = _item;
@synthesize listaDePessoas          = _listaDePessoas;
@synthesize pessoasSelecionadas     = _pessoasSelecionadas;
@synthesize delegate                = _delegate;
@synthesize context                 = _context;

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
	
    self.delegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    self.context = [self.delegate managedObjectContext];
        
    [self atualizaDataSource];
    [tableClientes reloadData];
    
    self.pessoasSelecionadas = [NSMutableArray new];

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
    
    self.listaDePessoas = [self.mesa.clientesDaMesa allObjects];
    
    self.listaDePessoas = [self.listaDePessoas sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Cliente*)a nome];
        NSString *second = [(Cliente*)b nome];
        return [first compare:second];
    }];
    
}

#pragma mark - Métodos dos botões

- (void)pressionouAdicionarSelecionados:(UIButton *)sender {
    
    for (Cliente * cliente in self.pessoasSelecionadas) {
        [cliente addItensObject:self.item];
    }
    
    int qntsCosumiram = [[self.item.conssumidores allObjects] count];
    [self.item setQuantosConsumiram:[NSNumber numberWithInt:qntsCosumiram]];
    
    [self.delegate saveContext];
    
    [self dismissModalViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionc{
    
    return [self.listaDePessoas count];

}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cellAdicionarCliente";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([self.listaDePessoas count] != 0) {
        
        Cliente * cliente = [self.listaDePessoas objectAtIndex:indexPath.row];
        cell.textLabel.text = cliente.nome;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ([self.pessoasSelecionadas containsObject:[self.listaDePessoas objectAtIndex:indexPath.row]]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableClientes deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.pessoasSelecionadas containsObject:[self.listaDePessoas objectAtIndex:indexPath.row]]) {
        [self.pessoasSelecionadas removeObject:[self.listaDePessoas objectAtIndex:indexPath.row]];
    } else {
        [self.pessoasSelecionadas addObject:[self.listaDePessoas objectAtIndex:indexPath.row]];
    }
    [tableClientes reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Quem mais consumiu?";
}


@end
