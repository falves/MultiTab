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
#import "AdicionarClienteViewController.h"

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
- (IBAction)pressionouAdicionarCliente:(UIButton*)sender;

@end

@implementation DetalhesDoItemViewController

@synthesize item                    = _item;
@synthesize context                 = _context;
@synthesize delegate                = _delegate;
@synthesize deletouUltimoCliente    = _deletouUltimoCliente;
@synthesize listaDeClientes         = _listaDeClientes;
@synthesize mesa                    = _mesa;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self atualizaDataSource];
    [tableClientes reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = self.item.nome;
    
    self.delegate   = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    self.context    = [self.delegate managedObjectContext];
    
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    AdicionarClienteViewController * adicionarVC = [segue destinationViewController];
    [adicionarVC setMesa:self.mesa];
    [adicionarVC setItem:self.item];
    
}

#pragma mark - Métodos dos botões

- (IBAction)pressionouAdicionarCliente:(UIButton*)sender {

    [self performSegueWithIdentifier:@"segueAdicionarCliente" sender:nil];
}

#pragma mark - Métodos auxiliares

- (void)atualizaDataSource {
    
    self.listaDeClientes = [NSArray arrayWithArray:[self.item.conssumidores allObjects]];
    
    self.listaDeClientes = [self.listaDeClientes sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Cliente*)a nome];
        NSString *second = [(Cliente*)b nome];
        return [first compare:second];
    }];

}

- (NSString *)calcularPrecoIndividual {
    
    float quantosConsumiram     = [self.item.quantosConsumiram floatValue];
    float precoTotalDoItem      = [self.item.preco floatValue];
    float precoIndividual       = precoTotalDoItem / quantosConsumiram;
    
    return [ConversorDeDinheiro converteNumberParaString:[NSNumber numberWithFloat:precoIndividual]];
    
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    
    if ([self.listaDeClientes count] == 0)
        CellIdentifier = @"cellDetalhesDoItemVazia";
    else
        CellIdentifier = @"cellDetalhesDoItem";
    
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
        
//        if (quantosConsumiram == 0) {
//            [self.context deleteObject:self.item];
//            [self.delegate saveContext];
//            [self dismissModalViewControllerAnimated:YES];
//        }
        
        if (quantosConsumiram == 0) {
            self.deletouUltimoCliente = YES;
        } else {
            self.deletouUltimoCliente = NO;
        }
        
        [self.item setQuantosConsumiram:[NSNumber numberWithInt:quantosConsumiram]];
        
        [cliente removeItensObject:self.item];

        [self.delegate saveContext];
        [self atualizaDataSource];

        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
        
    }
    [tableView endUpdates];
    
    if (self.deletouUltimoCliente) {
        self.deletouUltimoCliente = NO;
    }
    
    [tableClientes reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.listaDeClientes count] == 0)
        return NO;
    else
        return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
@end
