//
//  Item.h
//  MultiTab
//
//  Created by Felipe Alves on 07/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cliente, Mesa;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSNumber * preco;
@property (nonatomic, retain) Cliente *clienteIndividual;
@property (nonatomic, retain) Cliente *clientesCompartilhados;
@property (nonatomic, retain) Mesa *pertenceMesa;

@end
