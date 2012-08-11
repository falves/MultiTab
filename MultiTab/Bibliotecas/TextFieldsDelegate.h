//
//  TextFieldsDelegate.h
//  BMG_2
//
//  Created by Flavio Caetano on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum
{
    tipoNone,
    tipoDinheiro,
    tipoCEP,
    tipoCPF,
    tipoIdentidade,
    tipoTelefone,
    tipoNumeros
} TipoTextField;

@interface TextFieldsDelegate : NSObject <UITextFieldDelegate>

@property (nonatomic, strong) UITextField * textFieldAtivo;
@property (nonatomic, strong) id<UITextFieldDelegate> delegate;

@end
