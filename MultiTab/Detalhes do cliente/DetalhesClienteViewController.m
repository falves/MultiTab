//
//  DetalhesClienteViewController.m
//  MultiTab
//
//  Created by Mariana Meirelles on 8/14/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import "DetalhesClienteViewController.h"
#import "AppDelegate.h"
#import "ConversorDeDinheiro.h"

@interface DetalhesClienteViewController ()
{
    IBOutlet UILabel * lblValorIndividual;
    IBOutlet UITableView * tableItens;
}

@property (nonatomic) NSManagedObjectContext * context;
@property (nonatomic) AppDelegate * delegate;
@property (nonatomic) BOOL deletouUltimoItem;
@property (nonatomic, strong) NSArray * listaDeItens;

- (void) atualizaDataSource;
- (NSString*) calcularPrecoIndividual:(ItemDaMesa*)item;
- (void) atualizaValorTotalIndividual;

@end

@implementation DetalhesClienteViewController

@synthesize cliente             = _cliente;
@synthesize context             = _context;
@synthesize delegate            = _delegate;
@synthesize deletouUltimoItem   =_deletouUltimoItem;
@synthesize listaDeItens        = _listaDeItens;

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
	
    self.title = self.cliente.nome;
    
    self.delegate   = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    self.context    = [self.delegate managedObjectContext];
    [self atualizaDataSource];
    [tableItens reloadData];
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
    self.listaDeItens = [NSArray arrayWithArray:[self.cliente.itensCompartilhados allObjects]];
    self.listaDeItens = [self.listaDeItens arrayByAddingObjectsFromArray:[self.cliente.itensIndividuais allObjects]];
    [self atualizaValorTotalIndividual];
}

- (NSString *)calcularPrecoIndividual:(ItemDaMesa *)item {
    
    float quantosConsumiram     = [item.quantosConsumiram floatValue];
    float precoTotalDoItem      = [item.preco floatValue];
    float precoIndividual       = precoTotalDoItem / quantosConsumiram;
    
    return [ConversorDeDinheiro converteNumberParaString:[NSNumber numberWithFloat:precoIndividual]];
    
}

- (void)atualizaValorTotalIndividual {
    
    float valorTotal = 0;
    
    for (ItemDaMesa * item in self.listaDeItens) {
        
        float precoDoItem       = [item.preco floatValue];
        float quantosConsumiram = [item.quantosConsumiram floatValue];
        
        valorTotal += precoDoItem / quantosConsumiram;
        
    }
    
    lblValorIndividual.text = [ConversorDeDinheiro converteNumberParaString:[NSNumber numberWithFloat:valorTotal]];
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    
    if ([self.listaDeItens count] == 0) {
        CellIdentifier = @"cellDetalhesPessoaVazia";
    } else {
        CellIdentifier = @"cellDetalhesPessoa";
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([self.listaDeItens count] != 0) {
        ItemDaMesa * item = (ItemDaMesa*)[self.listaDeItens objectAtIndex:indexPath.row];
        cell.textLabel.text = item.nome;
        cell.detailTextLabel.text = [self calcularPrecoIndividual:item];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
  
    if ([self.listaDeItens count] == 0 && !self.deletouUltimoItem) {
        return 1;
    } else {
        return [self.listaDeItens count];
    }

}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Itens individuais";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView beginUpdates];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ItemDaMesa * item = (ItemDaMesa*)[self.listaDeItens objectAtIndex:indexPath.row];
        
        int quantosConsumiram = [item.quantosConsumiram integerValue];
        
        quantosConsumiram--;
        
        [item setQuantosConsumiram:[NSNumber numberWithInt:quantosConsumiram]];
        
        if ([item.quantosConsumiram integerValue] == 0) {
            [self.context deleteObject:item];
        } else {
            [self.cliente removeItensCompartilhadosObject:item];
            [self.cliente removeItensIndividuaisObject:item];
        }

        [self.delegate saveContext];
        [self atualizaDataSource];
        
        if ([self.listaDeItens count] == 0) {
            self.deletouUltimoItem = YES;
        } else {
            self.deletouUltimoItem = NO;
        }
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
        
    }
    
    [tableView endUpdates];
    
    if (self.deletouUltimoItem) {
        self.deletouUltimoItem = NO;
    }
    
    [tableItens reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


@end
