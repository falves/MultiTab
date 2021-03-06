//
//  MesaViewController.m
//  MultiTab
//
//  Created by Mariana Meirelles on 8/7/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import "MesaViewController.h"
#import "AppDelegate.h"
#import "Cliente.h"
#import "ItemDaMesa.h"
#import "ItemViewController.h"
#import "ConversorDeDinheiro.h"
#import "DetalhesClienteViewController.h"
#import "DetalhesDoItemViewController.h"

@interface MesaViewController ()
{
    IBOutlet UITableView * tableClientes;
    IBOutlet UITableView * tableItens;
    IBOutlet UITextField * nameField;
    IBOutlet UITextField * txtNomeDaMesa;
    IBOutlet UILabel * lblNomeDaMesa;
    IBOutlet UILabel * lblValorDaMesa;
}

@property (nonatomic, strong) NSArray * listaDeClientes;
@property (nonatomic, strong) NSArray * listaDeItens;
@property (nonatomic, strong) NSManagedObjectContext * context;
@property (nonatomic) AppDelegate * delegate;
@property (nonatomic) BOOL deletouUltimoCliente;
@property (nonatomic) BOOL deletouUltimoItem;


- (IBAction)pressionouAdicionarPessoa:(UIButton*)sender;
- (IBAction)pressionouAlterarNomeDaMesa:(UIButton*)sender;
- (IBAction)presionouEsvaziarMesa:(UIButton*)sender;
- (void) atualizaDataSource;
- (void) exibeAddressBook;
- (NSString*) calcularConsumoDoCliente:(Cliente*)cliente;

@end

@implementation MesaViewController

@synthesize listaDeClientes = _listaDeClientes;
@synthesize mesa = _mesa;
@synthesize nomeDaMesa = _nomeDaMesa;
@synthesize listaDeItens = _listaDeItens;
@synthesize novaMesa;
@synthesize delegate = _delegate;
@synthesize deletouUltimoCliente, deletouUltimoItem;


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
    
    self.delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    self.context = self.delegate.managedObjectContext;
    
    if (self.novaMesa) {
        [self criarNovaMesa];
    }
    
    self.title = self.mesa.nome;
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(pressionouAlterarNomeDaMesa:)]];

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
    
    if ([[segue identifier] isEqualToString:@"segueAdicionaItem"]) {
        ItemViewController * itemVC = [segue destinationViewController];
        [itemVC setMesa:self.mesa];
    }
    
    if ([[segue identifier] isEqualToString:@"segueDetalhesPessoa"]) {
        NSIndexPath * indexPath = (NSIndexPath*)sender;
        DetalhesClienteViewController * detalhesVC = [segue destinationViewController];
        [detalhesVC setCliente:[self.listaDeClientes objectAtIndex:indexPath.row]];
    }
    
    if ([[segue identifier] isEqualToString:@"segueDetalhesDoItem"]) {
        NSIndexPath * indexPath = (NSIndexPath*)sender;
        DetalhesDoItemViewController * detalhesVC = [segue destinationViewController];
        [detalhesVC setItem:[self.listaDeItens objectAtIndex:indexPath.row]];
        [detalhesVC setMesa:self.mesa];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self atualizaDataSource];
    [tableClientes reloadData];
    
}

#pragma mark - Botões

- (IBAction)presionouEsvaziarMesa:(UIButton*)sender {
    
    for (ItemDaMesa * item in self.mesa.itensTotais) {
        [self.context deleteObject:item];
    }
    
    [self.delegate saveContext];
    [self atualizaDataSource];
    [tableClientes reloadData];
}

- (void)pressionouAdicionarPessoa:(UIButton *)sender {
    
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"Adicionar pessoa à mesa" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Nova Pessoa",@"Adicionar da Agenda", nil];
    [sheet showInView:self.view];
}

- (IBAction)pressionouAlterarNomeDaMesa:(UIButton*)sender {
    
    UIAlertView * dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:self];
    [dialog setTitle:@"Digite o novo nome"];
    [dialog setMessage:@" "];
    [dialog addButtonWithTitle:@"Cancel"];
    [dialog addButtonWithTitle:@"OK"];
    [dialog setTag:1];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
//    txtNomeDaMesa = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    txtNomeDaMesa = [dialog textFieldAtIndex:0];
//    [txtNomeDaMesa setBackgroundColor:[UIColor whiteColor]];
    [txtNomeDaMesa setText:lblNomeDaMesa.text];
    [dialog addSubview:txtNomeDaMesa];
    [dialog show];
}

#pragma mark - Controle de Mesa

- (void) criarNovaMesa {
    
    
    NSManagedObject * novaMesaEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mesa" inManagedObjectContext:self.context];
    self.mesa = (Mesa*) novaMesaEntity;
    [self.mesa setNome:@"Nova mesa"];
    [self.delegate saveContext];
    
}

#pragma mark - Métodos auxiliares

- (NSString *)calcularConsumoDoCliente:(Cliente *)cliente {
    
    float valorTotal = 0;

    for (ItemDaMesa * item in cliente.itens) {
        
        int consumidores = [item.quantosConsumiram integerValue];
        float precoInteiro = [item.preco floatValue];
        valorTotal += precoInteiro / consumidores;
    }
    
    return [ConversorDeDinheiro converteNumberParaString:[NSNumber numberWithFloat:valorTotal]];
}

- (void) exibeAddressBook {
    ABPeoplePickerNavigationController *picker = [ABPeoplePickerNavigationController new];
    picker.peoplePickerDelegate = self;
	// Display only a person's phone, email, and birthdate
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
	
	
	picker.displayedProperties = displayedItems;
	// Show the picker
	[self presentModalViewController:picker animated:YES];
}

- (void) adicionarCliente:(NSString*)nome {
        
    NSManagedObject * novaMesaEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Cliente" inManagedObjectContext:self.context];
    Cliente * cliente = (Cliente*) novaMesaEntity;
    [cliente setNome:nome];
    [cliente setPertenceMesa:self.mesa];
    [self.mesa addClientesDaMesaObject:cliente];
    [self.delegate saveContext];

    [self atualizaDataSource];
    
    [tableClientes reloadData];
}

- (void) alterarNomeDaMesa:(NSString*)novoNome {
    
    self.title = novoNome;
    self.mesa.nome = novoNome;
    [self.delegate saveContext];
}

- (void) atualizaValorDaMesa {
    
    float valorTotal = 0;
    
    for (ItemDaMesa * item in self.mesa.itensTotais) {
        valorTotal += [item.preco floatValue];
    }
    
//    Inserir os 10%
//    valorTotal = valorTotal * 1.1;
    
    NSString * valorString = [ConversorDeDinheiro converteNumberParaString:[NSNumber numberWithFloat:valorTotal]];

    lblValorDaMesa.text = valorString;
    
}

- (void) atualizaDataSource {
    
    self.listaDeClientes    = [self.mesa.clientesDaMesa allObjects];
    self.listaDeItens       = [self.mesa.itensTotais allObjects];
    
    self.listaDeItens = [self.listaDeItens sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(ItemDaMesa*)a nome];
        NSString *second = [(ItemDaMesa*)b nome];
        return [first compare:second];
    }];
    
    self.listaDeClientes = [self.listaDeClientes sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Cliente*)a nome];
        NSString *second = [(Cliente*)b nome];
        return [first compare:second];
    }];
    
    [self atualizaValorDaMesa];

}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        if ([self.listaDeClientes count] == 0) {
            CellIdentifier = @"cellClientesVazia";
        } else {
            CellIdentifier = @"cellClientes";
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if ([self.listaDeClientes count] != 0) {
            Cliente * cliente = (Cliente*)[self.listaDeClientes objectAtIndex:indexPath.row];
            cell.textLabel.text = cliente.nome;
            cell.detailTextLabel.text = [self calcularConsumoDoCliente:cliente];
            
        }
    } else {
        if ([self.listaDeItens count] == 0) {
            CellIdentifier = @"cellItensVazia";
        } else {
            CellIdentifier = @"cellItens";
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if ([self.listaDeItens count] != 0) {
            ItemDaMesa * item = (ItemDaMesa*)[self.listaDeItens objectAtIndex:indexPath.row];
            cell.textLabel.text = item.nome;
            if ([item.quantosConsumiram integerValue] == 1) {
                cell.detailTextLabel.text = @"1 pessoa consumiu.";
            } else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ pessoas consumiram.",item.quantosConsumiram];
            }
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            if ([self.listaDeClientes count] == 0 && !self.deletouUltimoCliente) {
                return 1;
            } else {
                return [self.listaDeClientes count];
            }
            break;
            
        case 1:
            if ([self.listaDeItens count] == 0 && !self.deletouUltimoItem) {
                return 1;
            } else {
                return [self.listaDeItens count];
            }
            break;
    }
    
    return 0;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
            
        case 0:
            [self performSegueWithIdentifier:@"segueDetalhesPessoa" sender:indexPath];
            break;
            
        case 1:
            [self performSegueWithIdentifier:@"segueDetalhesDoItem" sender:indexPath];
            break;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Pessoas";
            break;
            
        case 1:
            return @"Itens";
            break;
    }
    return @"";
}

//[tableView beginUpdates];
//
//if (editingStyle == UITableViewCellEditingStyleDelete) {
//    
//    Cliente * cliente;
//    ItemDaMesa * item;
//    
//    switch (indexPath.section) {
//            
//        case 0: // Removeu um cliente
//            cliente = [self.listaDeClientes objectAtIndex:indexPath.row];
//            
//            [self.mesa removeClientesDaMesaObject:cliente];
//            [self.delegate saveContext];
//            [self atualizaDataSource];
//            
//            if ([self.listaDeClientes count] == 0) {
//                self.deletouUltimoCliente = YES;
//            } else {
//                self.deletouUltimoCliente = NO;
//            }
//            
//            break;
//            
//        case 1: //Removeu um item
//            item = [self.listaDeItens objectAtIndex:indexPath.row];
//            
//            [self.mesa removeItensTotaisObject:item];
//            [self.delegate saveContext];
//            [self atualizaDataSource];
//            
//            if ([self.listaDeItens count] == 0) {
//                self.deletouUltimoItem = YES;
//            } else {
//                self.deletouUltimoItem = NO;
//            }
//            break;
//    }
//    
//    
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
//}
//
//[tableView endUpdates];
//
//if (self.deletouUltimoCliente) {
//    self.deletouUltimoCliente = NO;
//    [tableClientes reloadData];
//}
//
//if (self.deletouUltimoItem) {
//    self.deletouUltimoItem = NO;
//    [tableClientes reloadData];
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView beginUpdates];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Cliente * cliente;
        ItemDaMesa * item;
        
        switch (indexPath.section) {
            case 0:
                
                cliente = (Cliente*)[self.listaDeClientes objectAtIndex:indexPath.row];
                
                for (ItemDaMesa * item in cliente.itens) {
                    int qnts = [item.quantosConsumiram integerValue];
                    qnts--;
                    [item setQuantosConsumiram:[NSNumber numberWithInt:qnts]];
                    
                }
                
                [self.context deleteObject:cliente];
                [self.delegate saveContext];
                [self atualizaDataSource];
                
                if ([self.listaDeClientes count] == 0) {
                    self.deletouUltimoCliente = YES;
                } else {
                    self.deletouUltimoCliente = NO;
                }
                
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
                
                break;
                
            case 1:
                
                item = (ItemDaMesa*)[self.listaDeItens objectAtIndex:indexPath.row];
                [self.context deleteObject:item];
                
                
                [self.delegate saveContext];
                [self atualizaDataSource];
                
                if ([self.listaDeItens count] == 0) {
                    self.deletouUltimoItem = YES;
                } else {
                    self.deletouUltimoItem = NO;
                }
                
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
                
                break;
        }

        
    }
    
    [tableView endUpdates];
    
    if (self.deletouUltimoCliente) {
        self.deletouUltimoCliente = NO;
    }
    
    if (self.deletouUltimoItem) {
        self.deletouUltimoItem = NO;
    }
    
    [tableClientes reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            
            if ([self.listaDeClientes count] == 0)
                return NO;
            else
                return YES;
            
            break;
            
        case 1:
            
            if ([self.listaDeItens count] == 0)
                return NO;
            else
                return YES;
            
            break;
    }
    
    return NO;
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
//    [self dismissModalViewControllerAnimated:YES];
    NSString *primeiroNome = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *ultimoNome = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    NSString * nomeCompleto = [NSString stringWithFormat:@"%@ %@",primeiroNome,ultimoNome];
    
    
//    UIView *view = peoplePicker.topViewController.view;
//    UITableView *tableView = nil;
//    for(UIView *uv in view.subviews)
//    {
//        if([uv isKindOfClass:[UITableView class]])
//        {
//            tableView = (UITableView*)uv;
//            break;
//        }
//    }
//    
//    if(tableView != nil)
//    {
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[tableView indexPathForSelectedRow]];
//        
//        if (cell.accessoryType == UITableViewCellAccessoryNone) {
//            
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            NSLog(@"Adicionar - %@",nomeCompleto);
//            [self adicionarCliente:nomeCompleto];
//            
//        } else {
//            
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            NSLog(@"Remover - %@",nomeCompleto);
//            
//        }
//                
//        [cell setSelected:NO animated:YES];
//    }
    
    [self adicionarCliente:nomeCompleto];
    [self dismissModalViewControllerAnimated:YES];
	return NO;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIAlertView* dialog;
    
    switch (buttonIndex) {
        case 0: //nova
            
            dialog = [[UIAlertView alloc] init];
            [dialog setDelegate:self];
            [dialog setTitle:@"Digite o nome"];
            [dialog setMessage:@" "];
            [dialog addButtonWithTitle:@"Cancel"];
            [dialog addButtonWithTitle:@"OK"];
            [dialog setTag:0];
            [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
//            nameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
            nameField = [dialog textFieldAtIndex:0];
//            [nameField setBackgroundColor:[UIColor whiteColor]];
            [dialog addSubview:nameField];
            [dialog show];
            
            break;
            
        case 1: //agenda
            [self exibeAddressBook];
            break;
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case 0:
            if (buttonIndex != 0) {
                [self adicionarCliente:nameField.text];
            }
            break;
            
        case 1:
            if (buttonIndex != 0) {
                [self alterarNomeDaMesa:txtNomeDaMesa.text];
            }
            break;
    }
    
}


@end
