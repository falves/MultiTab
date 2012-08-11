//
//  ItemViewController.m
//  MultiTab
//
//  Created by Felipe Alves on 08/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import "ItemViewController.h"
#import "ItemGlobal.h"
#import "AppDelegate.h"
#import "ConsumirItemViewController.h"
#import "ConversorDeDinheiro.h"

@interface ItemViewController ()
{
    IBOutlet UITableView * tableItens;
    IBOutlet UITextField * txtNome;
//    IBOutlet UITextField * txtPreco;
}

@property (nonatomic) AppDelegate * delegate;
@property (nonatomic) NSManagedObjectContext * context;
@property (nonatomic, strong) NSArray * listaDeItens;
@property (nonatomic) BOOL deletouUltimoItem;

- (void) atualizaDataSource;
- (IBAction)pressionouCadastrar:(UIButton*)sender;
- (IBAction)pressionouCancelar:(UIButton*)sender;

@end

@implementation ItemViewController

@synthesize context = _context;
@synthesize delegate = _delegate;
@synthesize mesa = _mesa;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self atualizaDataSource];
    [tableItens reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    self.context = [self.delegate managedObjectContext];
    
//    [txtPreco setDelegate:self];

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
    
    if ([[segue identifier] isEqualToString:@"segueConsumirItem"]) {
        
        ConsumirItemViewController * consumirVC = [segue destinationViewController];
        [consumirVC setMesa:self.mesa];
        [consumirVC setItem:sender];
    }
    
}

#pragma mark - Métodos dos botoões

- (IBAction)pressionouCadastrar:(UIButton*)sender {
    
    [txtNome resignFirstResponder];
//    [txtPreco resignFirstResponder];
    
    NSManagedObject * novoItemEntity = [NSEntityDescription insertNewObjectForEntityForName:@"ItemGlobal" inManagedObjectContext:self.context];
    ItemGlobal * item = (ItemGlobal*) novoItemEntity;
    [item setNome:txtNome.text];
    [self.delegate saveContext];
    
    [self atualizaDataSource];
    
    [tableItens reloadData];
    
}

- (void)pressionouCancelar:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Métodos Auxiliares

- (void) atualizaDataSource {
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ItemGlobal" inManagedObjectContext:self.context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:request error:&error];
    
    if (array != nil) {
        self.listaDeItens = [array copy];
    }
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    
    if ([self.listaDeItens count] == 0) {
        CellIdentifier = @"cellItensVazia2";
    } else {
        CellIdentifier = @"cellItens";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([self.listaDeItens count] != 0) {
        
        ItemGlobal * item = [self.listaDeItens objectAtIndex:indexPath.row];
        cell.textLabel.text = item.nome;
        cell.detailTextLabel.text = [ConversorDeDinheiro converteNumberParaString:item.preco];
    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.listaDeItens count] == 0 && !self.deletouUltimoItem) {
        return 1;
    } else {
        return [self.listaDeItens count];
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"segueConsumirItem" sender:[self.listaDeItens objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView beginUpdates];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ItemGlobal * item = [self.listaDeItens objectAtIndex:indexPath.row];
        
        [self.context deleteObject:item];
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
        [tableItens reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


@end
