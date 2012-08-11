//
//  ConsumirItemViewController.m
//  MultiTab
//
//  Created by Felipe Alves on 08/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import "ConsumirItemViewController.h"
#import "AppDelegate.h"
#import "Cliente.h"
#import "TextFieldsDelegate.h"
#import "ConversorDeDinheiro.h"

@interface ConsumirItemViewController ()
{
    IBOutlet UILabel * lblNomeDoItem;
    IBOutlet UILabel * lblPreco;
    IBOutlet UITableView * tableClientes;
    IBOutlet UITextField * txtPreco;
    IBOutlet UISegmentedControl * segConsumo;
}

@property (nonatomic) AppDelegate * delegate;
@property (nonatomic) NSManagedObjectContext * context;
@property (nonatomic, strong) NSArray * listaDePessoas;
@property (nonatomic, strong) NSMutableArray * pessoasSelecionadas;
@property (nonatomic, strong) TextFieldsDelegate * textFieldsDelegate;

- (IBAction)pressionouAlterar:(UIButton*)sender;
- (IBAction)pressionouCancelar:(UIButton*)sender;
- (IBAction)pressionouConsumir:(UIButton*)sender;


@end

@implementation ConsumirItemViewController

@synthesize mesa = _mesa;
@synthesize item = _item;
@synthesize delegate = _delegate;
@synthesize context = _context;
@synthesize listaDePessoas = _listaDePessoas;
@synthesize pessoasSelecionadas = _pessoasSelecionadas;

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
    
    lblNomeDoItem.text = [self.item nome];
    lblPreco.text =  [ConversorDeDinheiro converteNumberParaString:[self.item preco]];  //[NSString stringWithFormat:@"R$%.2f",[[self.item preco] floatValue]];
    
    [self atualizaDataSource];
    [tableClientes reloadData];
    
    self.pessoasSelecionadas = [NSMutableArray new];
    
    self.textFieldsDelegate = [TextFieldsDelegate new];
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
    
}

#pragma mark - Métodos dos botões

- (IBAction)pressionouAlterar:(UIButton*)sender {
    
    UIAlertView * dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:self];
    [dialog setTitle:@"Digite o novo preço"];
    [dialog setMessage:@" "];
    [dialog addButtonWithTitle:@"Cancel"];
    [dialog addButtonWithTitle:@"OK"];
    [dialog setTag:1];
    
    txtPreco = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    txtPreco.backgroundColor          = [UIColor whiteColor];
    txtPreco.autocorrectionType       = UITextAutocorrectionTypeNo;
    txtPreco.delegate                 = self.textFieldsDelegate;
    txtPreco.keyboardType             = UIKeyboardTypeNumberPad;
    txtPreco.text                     = lblPreco.text;
    txtPreco.tag                      = tipoDinheiro;
    
    [dialog addSubview:txtPreco];
    [dialog show];
}

- (IBAction)pressionouCancelar:(UIButton*)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)pressionouConsumir:(UIButton*)sender {
    
#warning USAR O ID COMO RELACAO
    
    NSString * idDaMesa =  [[[self.mesa objectID] URIRepresentation] absoluteString];
    
    if (segConsumo.selectedSegmentIndex == 1) {
        self.item.quantosConsumiram = [NSNumber numberWithInt:[self.pessoasSelecionadas count]];
    }
    
    for (Cliente * cliente in self.pessoasSelecionadas) {
        
        switch (segConsumo.selectedSegmentIndex) {
                
            case 0: // Um para cada
                [cliente addItensIndividuaisObject:self.item];
//                [self.item addClienteIndividualObject:cliente];
                [self.delegate saveContext];

                break;
                
            case 1: // Compartilhado
                [cliente addItensCompartilhadosObject:self.item];
                [self.delegate saveContext];

                break;
        }
        
    }
    
    [self.mesa addItensTotaisObject:self.item];
    
    [self.delegate saveContext];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionc{
    
    if ([self.listaDePessoas count] == 0) {
        return 1;
    } else {
        return [self.listaDePessoas count];
    }
    
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    
    if ([self.listaDePessoas count] == 0) {
        CellIdentifier = @"cellConsumidorVazia";
    } else {
        CellIdentifier = @"cellConsumidor";
    }
    
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
    return @"Quem consumiu?";
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 1:
            [self.item setPreco:[ConversorDeDinheiro converteStringParaNumber:txtPreco.text]];
            [self.delegate saveContext];
            lblPreco.text = [ConversorDeDinheiro converteNumberParaString:[self.item preco]];
            
            break;
    }
}


@end
