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
#import "Mesa.h"
#import "Item.h"

@interface MesaViewController ()
{
    IBOutlet UITableView * tableClientes;
}

@property (nonatomic, strong) NSMutableArray * listaDeClientes;
@property (nonatomic, strong) NSString * nomeDaMesa;

- (IBAction)pressionouAdicionarPessoa:(UIButton*)sender;

@end

@implementation MesaViewController

@synthesize listaDeClientes = _listaDeClientes;
@synthesize nomeDaMesa = _nomeDaMesa;


#warning MANTER UMA REFERENCIA PARA O CONTEXT 
#warning CRIAR UMA MESA NOVA NO VIEWDIDLOAD E MANTER UMA REFERENCIA PRA ELA
#warning SE ESTIVER CARREGANDO UMA MESA, CARREGA-LA NO VIEWDIDLOAD E MANTER UMA REFERENCIA PARA ELA


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

#pragma mark - Botões

- (void)pressionouAdicionarPessoa:(UIButton *)sender {
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

#pragma mark - Métodos auxiliares

- (void) adicionarCliente:(NSString*)nome {
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    Cliente *novoCliente = [[Cliente alloc] initWithEntity:[NSEntityDescription
                                                            insertNewObjectForEntityForName:@"Cliente"
                                                            inManagedObjectContext:context]
                            insertIntoManagedObjectContext:context];
//    novoCliente = [NSEntityDescription
//                  insertNewObjectForEntityForName:@"Cliente"
//                  inManagedObjectContext:context];
    
    novoCliente.nome = nome;
    
    
    NSError *error;
    [context save:&error];
    
    [tableClientes reloadData];
}

- (Mesa*) carregaMesaAtual {
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *clienteDesc = [NSEntityDescription entityForName:@"Mesa" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:clienteDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(nome = %@)",self.nomeDaMesa];
    [request setPredicate:pred];
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if ([objects count] == 0) {
        NSLog(@"Não encontrou a mesa.");
        return nil;
    } else {
        matches = [objects objectAtIndex:0];
        Mesa * mesa = (Mesa*) matches;
        NSLog(@"Carregou a mesa - %@",mesa.nome);
        return mesa;
    }
}

- (void) carregaClientesDoCoreData {
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];

    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *clienteDesc = [NSEntityDescription entityForName:@"Cliente" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:clienteDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(mesa = %@)",[self carregaMesaAtual]];
    [request setPredicate:pred];
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if ([objects count] == 0) {
        NSLog(@"Carregou mesa vazia.");
    } else {
        matches = [objects objectAtIndex:0];
        Cliente * cliente = (Cliente*) matches;
        NSLog(@"Carregou o cliente - %@",cliente.nome);
    }
}



#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    
    if ([self.listaDeClientes count] == 0) {
        CellIdentifier = @"clientesVaziaCell";
    } else {
        CellIdentifier = @"clientesCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.listaDeClientes count] == 0) {
        return 1;
    } else {
        return [self.listaDeClientes count];
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
//    [self dismissModalViewControllerAnimated:YES];
    NSString *primeiroNome = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *ultimoNome = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    NSString * nomeCompleto = [NSString stringWithFormat:@"%@ %@",primeiroNome,ultimoNome];
    
    
    UIView *view = peoplePicker.topViewController.view;
    UITableView *tableView = nil;
    for(UIView *uv in view.subviews)
    {
        if([uv isKindOfClass:[UITableView class]])
        {
            tableView = (UITableView*)uv;
            break;
        }
    }
    
    if(tableView != nil)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[tableView indexPathForSelectedRow]];
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSLog(@"Adicionar - %@",nomeCompleto);
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSLog(@"Remover - %@",nomeCompleto);
            
        }
                
        [cell setSelected:NO animated:YES];
    }
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


@end
