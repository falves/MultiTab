//
//  DetalhesDoItemViewController.m
//  MultiTab
//
//  Created by Felipe on 14/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import "DetalhesDoItemViewController.h"
#import "AppDelegate.h"
#import "ConversorDeDinheiro.h"

@interface DetalhesDoItemViewController ()
{
    IBOutlet UILabel * lblPrecoDoItem;
    IBOutlet UITableView * tableClientes;
}

@property (nonatomic) NSManagedObjectContext * context;
@property (nonatomic) AppDelegate * delegate;
@property (nonatomic) BOOL deletouUltimoCliente;
@property (nonatomic, strong) NSArray * listaDeClientes;

- (void) atualizaDataSource;
- (NSString*) calcularPrecoIndividual;

@end

@implementation DetalhesDoItemViewController

@synthesize item                    = _item;
@synthesize context                 = _context;
@synthesize delegate                = _delegate;
@synthesize deletouUltimoCliente    = _deletouUltimoCliente;
@synthesize listaDeClientes         = _listaDeClientes;

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
	
    self.title = self.item.nome;
    
    self.delegate   = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    self.context    = [self.delegate managedObjectContext];
    [self atualizaDataSource];
    [tableClientes reloadData];
    
    lblPrecoDoItem.text = [ConversorDeDinheiro converteNumberParaString:self.item.preco];
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

- (void)atualizaDataSource {
    
    self.listaDeClientes = [NSArray arrayWithArray:[self.item.clienteCompartilhado allObjects]];
    
    if ([self.item.clienteIndividual isKindOfClass:[Cliente class]]) {
        self.listaDeClientes = [self.listaDeClientes arrayByAddingObject:self.item.clienteIndividual];
    }
    
    
//    NSLog(@"Individual - %@",self.item.clienteIndividual);
}

- (NSString *)calcularPrecoIndividual {
    
    float quantosConsumiram     = [self.item.quantosConsumiram floatValue];
    float precoTotalDoItem      = [self.item.preco floatValue];
    float precoIndividual       = precoTotalDoItem / quantosConsumiram;
    
    return [ConversorDeDinheiro converteNumberParaString:[NSNumber numberWithFloat:precoIndividual]];
    
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cellDetalhesDoItem";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([self.listaDeClientes count] != 0) {
        Cliente * cliente = (Cliente*)[self.listaDeClientes objectAtIndex:indexPath.row];
        cell.textLabel.text = cliente.nome;
        cell.detailTextLabel.text = [self calcularPrecoIndividual];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if ([self.listaDeClientes count] == 0 && !self.deletouUltimoCliente) {
        return 1;
    } else {
        return [self.listaDeClientes count];
    }
    
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Pessoas que consumiram";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView beginUpdates];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Cliente * cliente = (Cliente*)[self.listaDeClientes objectAtIndex:indexPath.row];
        
        int quantosConsumiram = [self.item.quantosConsumiram integerValue];
        
        quantosConsumiram--;
        
        [self.item setQuantosConsumiram:[NSNumber numberWithInt:quantosConsumiram]];
        
        if ([self.item.quantosConsumiram integerValue] == 0) {
            [self.context deleteObject:self.item];
            [self dismissModalViewControllerAnimated:YES];
        } else {
            [cliente removeItensCompartilhadosObject:self.item];
            [cliente removeItensIndividuaisObject:self.item];
        }
        
        [self.delegate saveContext];
        [self atualizaDataSource];

        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
        
    }
    
    [tableClientes reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
@end
