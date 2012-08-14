//
//  DetalhesClienteViewController.m
//  MultiTab
//
//  Created by Mariana Meirelles on 8/14/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import "DetalhesClienteViewController.h"
#import "AppDelegate.h"

@interface DetalhesClienteViewController ()
{
    IBOutlet UILabel * lblValorIndividual;
}

@property (nonatomic) NSManagedObjectContext * context;
@property (nonatomic) AppDelegate * delegate;

@end

@implementation DetalhesClienteViewController

@synthesize cliente     = _cliente;
@synthesize context     = _context;
@synthesize delegate    = _delegate;

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

//#pragma mark - UITableViewDatasource
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier;
//    UITableViewCell *cell;
//    
//    if (indexPath.section == 0) {
//        if ([self.listaDeClientes count] == 0) {
//            CellIdentifier = @"cellClientesVazia";
//        } else {
//            CellIdentifier = @"cellClientes";
//        }
//        
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        if ([self.listaDeClientes count] != 0) {
//            Cliente * cliente = (Cliente*)[self.listaDeClientes objectAtIndex:indexPath.row];
//            cell.textLabel.text = cliente.nome;
//            cell.detailTextLabel.text = [self calcularConsumoDoCliente:cliente];
//            
//        }
//    } else {
//        if ([self.listaDeItens count] == 0) {
//            CellIdentifier = @"cellItensVazia";
//        } else {
//            CellIdentifier = @"cellItens";
//        }
//        
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        if ([self.listaDeItens count] != 0) {
//            ItemDaMesa * item = (ItemDaMesa*)[self.listaDeItens objectAtIndex:indexPath.row];
//            cell.textLabel.text = item.nome;
//            if ([item.quantosConsumiram integerValue] == 1) {
//                cell.detailTextLabel.text = @"1 pessoa consumiu.";
//            } else {
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ pessoas consumiram.",item.quantosConsumiram];
//            }
//        }
//    }
//    
//    return cell;
//    
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    switch (section) {
//        case 0:
//            if ([self.listaDeClientes count] == 0 && !self.deletouUltimoCliente) {
//                return 1;
//            } else {
//                return [self.listaDeClientes count];
//            }
//            break;
//            
//        case 1:
//            if ([self.listaDeItens count] == 0 && !self.deletouUltimoItem) {
//                return 1;
//            } else {
//                return [self.listaDeItens count];
//            }
//            break;
//    }
//    
//    return 0;
//}
//
//#pragma mark - UITableViewDelegate
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    switch (indexPath.section) {
//            
//        case 0:
//            [self performSegueWithIdentifier:@"segueDetalhesPessoa" sender:indexPath];
//            break;
//            
//        case 1:
//            
//            break;
//    }
//    
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    switch (section) {
//        case 0:
//            return @"Pessoas";
//            break;
//            
//        case 1:
//            return @"Itens";
//            break;
//    }
//    return @"";
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [tableView beginUpdates];
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        Cliente * cliente;
//        ItemDaMesa * item;
//        
//        switch (indexPath.section) {
//            case 0:
//                
//                cliente = (Cliente*)[self.listaDeClientes objectAtIndex:indexPath.row];
//                
//                [self.mesa removeClientesDaMesaObject:cliente];
//                [self.delegate saveContext];
//                [self atualizaDataSource];
//                
//                if ([self.listaDeClientes count] == 0) {
//                    self.deletouUltimoCliente = YES;
//                } else {
//                    self.deletouUltimoCliente = NO;
//                }
//                
//                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
//                
//                break;
//                
//            case 1:
//                
//                item = (ItemDaMesa*)[self.listaDeItens objectAtIndex:indexPath.row];
//                [self.context deleteObject:item];
//                
//                
//                [self.delegate saveContext];
//                [self atualizaDataSource];
//                
//                if ([self.listaDeItens count] == 0) {
//                    self.deletouUltimoItem = YES;
//                } else {
//                    self.deletouUltimoItem = NO;
//                }
//                
//                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
//                
//                break;
//        }
//        
//        
//    }
//    
//    [tableView endUpdates];
//    
//    if (self.deletouUltimoCliente) {
//        self.deletouUltimoCliente = NO;
//    }
//    
//    if (self.deletouUltimoItem) {
//        self.deletouUltimoItem = NO;
//    }
//    
//    [tableClientes reloadData];
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}


@end
