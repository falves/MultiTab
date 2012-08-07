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
#import "Item.h"

@interface MesaViewController ()
{
    IBOutlet UITableView * tableClientes;
    IBOutlet UITableView * tableItens;
    IBOutlet UITextField * nameField;
}

@property (nonatomic, strong) NSMutableArray * listaDeClientes;
@property (nonatomic, strong) NSMutableArray * listaDeItens;
@property (nonatomic, strong) NSManagedObjectContext * context;


- (IBAction)pressionouAdicionarPessoa:(UIButton*)sender;
- (void) atualizaDataSource;
- (void) exibeAddressBook;

@end

@implementation MesaViewController

@synthesize listaDeClientes = _listaDeClientes;
@synthesize mesa = _mesa;
@synthesize nomeDaMesa = _nomeDaMesa;
@synthesize listaDeItens = _listaDeItens;
@synthesize novaMesa;


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
    
    AppDelegate * delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    self.context = delegate.managedObjectContext;
    
    if (self.novaMesa) {
        [self criarNovaMesa];
    }
    
    [self atualizaDataSource];
    [tableClientes reloadData];
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

#pragma mark - Botões

- (void)pressionouAdicionarPessoa:(UIButton *)sender {
    
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"Adicionar pessoa à mesa" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Nova Pessoa",@"Adicionar da Agenda", nil];
    [sheet showInView:self.view];
}

#pragma mark - Controle de Mesa

- (void) criarNovaMesa {
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Mesa" inManagedObjectContext:self.context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:request error:&error];
    NSString * nomeDaNovaMesa;
    
    if (array == nil)
    {
        nomeDaNovaMesa = @"Mesa 0";
    } else {
        nomeDaNovaMesa = [NSString stringWithFormat:@"Mesa %d",[array count]];
    }
    
    NSManagedObject * novaMesaEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mesa" inManagedObjectContext:self.context];
    self.mesa = (Mesa*) novaMesaEntity;
    [self.mesa setNome:nomeDaNovaMesa];
    [self.context save:&error];
    
}

- (void) carregarMesaExistente {
    
}

#pragma mark - Métodos auxiliares

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
    
    NSError *error = nil;
    
    NSManagedObject * novaMesaEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Cliente" inManagedObjectContext:self.context];
    Cliente * cliente = (Cliente*) novaMesaEntity;
    [cliente setNome:nome];
    [cliente setPertenceMesa:self.mesa];
    [self.mesa addClientesDaMesaObject:cliente];
    [self.context save:&error];

    [self atualizaDataSource];
    
    [tableClientes reloadData];
}

- (void) atualizaDataSource {
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Cliente" inManagedObjectContext:self.context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"pertenceMesa == %@", self.mesa];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:request error:&error];
    
    if (array != nil) {
        self.listaDeClientes = [array copy];
    }

}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    
    if ([tableView isEqual:tableClientes]) {
        if ([self.listaDeClientes count] == 0) {
            CellIdentifier = @"clientesVaziaCell";
        } else {
            CellIdentifier = @"clientesCell";
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if ([self.listaDeClientes count] != 0) {
            Cliente * cliente = (Cliente*)[self.listaDeClientes objectAtIndex:indexPath.row];
            cell.textLabel.text = cliente.nome;
        }
    } else {
        if ([self.listaDeItens count] == 0) {
            CellIdentifier = @"cellItensVazia";
        } else {
            CellIdentifier = @"cellItensCheia";
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if ([self.listaDeItens count] != 0) {
            Item * item = (Item*)[self.listaDeItens objectAtIndex:indexPath.row];
            cell.textLabel.text = item.nome;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"R$ %f",[item.preco floatValue]];
        }
    }

    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:tableClientes]) {
        if ([self.listaDeClientes count] == 0) {
            return 1;
        } else {
            return [self.listaDeClientes count];
        }
    } else {
        if ([self.listaDeItens count] == 0) {
            return 1;
        } else {
            return [self.listaDeItens count];
        }
    }
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:tableClientes]) {
        return @"Pessoas";
    } else {
        return @"Items compartilhados";
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
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
            
            nameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
            [nameField setBackgroundColor:[UIColor whiteColor]];
            [dialog addSubview:nameField];
            [dialog show];
            
            break;
            
        case 1: //agenda
            [self exibeAddressBook];
            break;
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        [self adicionarCliente:nameField.text];
    }
}


@end
