//
//  TextFieldsDelegate.m
//  BMG_2
//
//  Created by Flavio Caetano on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextFieldsDelegate.h"

@implementation TextFieldsDelegate

@synthesize textFieldAtivo, delegate;

- (BOOL)editDinheiro:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet * charSetNumeros = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"]; 
//    NSUInteger novoTamanho = [textField.text length] + [string length] - range.length;   
    NSLocale * locale;
    NSNumberFormatter* currencyFormatter;
    NSString * numeroString;
    double numeroDouble;
    
    if (string.length > 0 ) {
        
        if (![charSetNumeros characterIsMember:[string characterAtIndex:0]] || string.length > 1 || range.location != textField.text.length ) {
            return NO;
        }
    } else if (range.location != textField.text.length-1) {
        return NO;
    }
    numeroString = textField.text;
    
    if (string.length < 1) {
        numeroString = [numeroString substringToIndex:numeroString.length-1];
    } else {
        numeroString = [numeroString stringByAppendingString:string];
    }
    
    numeroString = [numeroString stringByReplacingOccurrencesOfString:@"." withString:@""];
    numeroString = [numeroString stringByReplacingOccurrencesOfString:@"," withString:@""];
    numeroString = [numeroString stringByReplacingOccurrencesOfString:@"R$" withString:@""];
    
    numeroDouble = [numeroString doubleValue]/100;
    
    locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
//    locale = [NSLocale currentLocale];
    currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setMaximumFractionDigits:2];
    [currencyFormatter setLocale:locale];
    
    textField.text = [currencyFormatter stringFromNumber:[NSNumber numberWithDouble: numeroDouble]];
    
    if (textField.text.length > 0 && ![textField.text isEqualToString:@"R$0,00"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DinheiroFull" object:textField];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DinheiroEmpty" object:textField];
    }
    
    return NO;
}

- (BOOL)editCEP:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger novoTamanho = [textField.text length] + [string length] - range.length;
    NSCharacterSet * charSetNumeros = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    if (string.length > 0 )
    {
        if (![charSetNumeros characterIsMember:[string characterAtIndex:0]] || string.length > 1 || range.location != textField.text.length )
        {
            return NO;
        }
    }
    else if (range.location != textField.text.length-1)
    {
        return NO;
    }
    
    if (novoTamanho >= 10) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CEPFull" object:textField];
        
        if (novoTamanho > 10) return NO;
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CEPEmpty" object:textField];
    }
    
    // Digitou o 3 caracter
    if (textField.text.length == 2 && string.length == 1) {
        textField.text = [NSString stringWithFormat:@"%@.%@",textField.text,string];
        return NO;
    }
    
    // Removeu o 3 caracter
    if (textField.text.length == 4 && string.length < 1) {
        textField.text = [textField.text substringToIndex:2];
        return NO;
    }
    
    // Digitou o 6 caracter
    if (textField.text.length == 6 && string.length == 1) {
        textField.text = [NSString stringWithFormat:@"%@-%@",textField.text,string];
        return NO;
    }
    
    // Removeu o 6 caracter
    if (textField.text.length == 8 && string.length < 1) {
        textField.text = [textField.text substringToIndex:6];
        return NO;
    }
    
    return YES;
}

- (BOOL)editCPF:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger novoTamanho = [textField.text length] + [string length] - range.length;
    NSCharacterSet * charSetNumeros = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    if (string.length > 0 )
    {
        if (![charSetNumeros characterIsMember:[string characterAtIndex:0]] || string.length > 1 || range.location != textField.text.length )
        {
            return NO;
        }
    }
    else if (range.location != textField.text.length-1)
    {
        return NO;
    }
    
    if (novoTamanho >= 14) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CPFFull" object:textField];
        
        if (novoTamanho > 14) return NO;
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CPFEmpty" object:textField];
    }
    
    // Digitou o 4 caracter
    if (textField.text.length == 3 && string.length == 1) {
        textField.text = [NSString stringWithFormat:@"%@.%@",textField.text,string];
        return NO;
    }
    
    // Removeu o 4 caracter
    if (textField.text.length == 5 && string.length < 1) {
        textField.text = [textField.text substringToIndex:3];
        return NO;
    }
    
    // Digitou o 7 caracter
    if (textField.text.length == 7 && string.length == 1) {
        textField.text = [NSString stringWithFormat:@"%@.%@",textField.text,string];
        return NO;
    }
    
    // Removeu o 7 caracter
    if (textField.text.length == 9 && string.length < 1) {
        textField.text = [textField.text substringToIndex:7];
        return NO;
    }
    
    // Digitou o 10 caracter
    if (textField.text.length == 11 && string.length == 1) {
        textField.text = [NSString stringWithFormat:@"%@-%@",textField.text,string];
        return NO;
    }
    
    // Removeu o 10 caracter
    if (textField.text.length == 13 && string.length < 1) {
        textField.text = [textField.text substringToIndex:11];
        return NO;
    }
    
    return YES;
}

- (BOOL)editIdentidade:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger novoTamanho = [textField.text length] + [string length] - range.length;
    NSCharacterSet * charSetNumeros = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    
    
    if (string.length > 0 )
    {
        if (![charSetNumeros characterIsMember:[string characterAtIndex:0]] || string.length > 1 || range.location != textField.text.length )
        {
            return NO;
        }
    }
    else if (range.location != textField.text.length-1)
    {
        return NO;
    }
    
    if (novoTamanho >= 12) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IDFull" object:textField];
        
        if (novoTamanho > 12) return NO;
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IDEmpty" object:textField];
    }
    
    // Digitou o 3 caracter
    if (textField.text.length == 2 && string.length == 1) {
        textField.text = [NSString stringWithFormat:@"%@.%@",textField.text,string];
        return NO;
    }
    
    // Removeu o 3 caracter
    if (textField.text.length == 4 && string.length < 1) {
        textField.text = [textField.text substringToIndex:2];
        return NO;
    }
    
    // Digitou o 6 caracter
    if (textField.text.length == 6 && string.length == 1) {
        textField.text = [NSString stringWithFormat:@"%@.%@",textField.text,string];
        return NO;
    }
    
    // Removeu o 6 caracter
    if (textField.text.length == 8 && string.length < 1) {
        textField.text = [textField.text substringToIndex:6];
        return NO;
    }
    
    // Digitou o 9 caracter
    if (textField.text.length == 10 && string.length == 1) {
        textField.text = [NSString stringWithFormat:@"%@-%@",textField.text,string];
        return NO;
    }
    
    // Removeu o 9 caracter
    if (textField.text.length == 12 && string.length < 1) {
        textField.text = [textField.text substringToIndex:10];
        return NO;
    }
    
    return YES;
}

- (BOOL)editTelefone:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger novoTamanho = [textField.text length] + [string length] - range.length;
    NSCharacterSet * charSetNumeros = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    if (string.length > 0 )
    {
        if (![charSetNumeros characterIsMember:[string characterAtIndex:0]] || string.length > 1 || range.location != textField.text.length )
        {
            return NO;
        }
    }
    else if (range.location != textField.text.length-1)
    {
        return NO;
    }

    if (novoTamanho >= 13)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TelefoneFull" object:textField];
        
        if (novoTamanho > 13) return NO;
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TelefoneEmpty" object:textField];
    }
    
    // Digitou o 1 caracter
    if (textField.text.length == 0 && string.length == 1) {
        textField.text = [NSString stringWithFormat:@"(%@",string];
        return NO;
    }
    
    // Digitou o 2 caracter
    if (textField.text.length == 2 && string.length == 1) {
        textField.text = [NSString stringWithFormat:@"%@%@)",textField.text,string];
        return NO;
    }
    
    // Digitou o 5 caracter
    if (textField.text.length == 8 && string.length == 1) {
        textField.text = [NSString stringWithFormat:@"%@-%@",textField.text,string];
        return NO;
    }
    
    // Removeu o 1 caracter
    if (textField.text.length == 2 && string.length < 1) {
        textField.text = @"";
        return NO;
    }
    
    // Removeu o 2 caracter
    if (textField.text.length == 4 && string.length < 1) {
        textField.text = [textField.text substringToIndex:2];
        return NO;
    }
    
    // Removeu o 5 caracter
    if (textField.text.length == 10 && string.length < 1) {
        textField.text = [textField.text substringToIndex:8];
        return NO;
    }
    
    return YES;
}

- (BOOL)editNumeros:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet * charSetNumeros = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"]; 
    NSUInteger novoTamanho = [textField.text length] + [string length] - range.length;
    
    if (string.length > 0 )
    {
        if (![charSetNumeros characterIsMember:[string characterAtIndex:0]] || string.length > 1 || range.location != textField.text.length )
        {
            return NO;
        }
    }
    else if (range.location != textField.text.length-1)
    {
        return NO;
    }
    
    if (novoTamanho > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NumeroFull" object:textField];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NumeroEmpty" object:textField];
    }
    
    return YES;
}


#pragma Mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{    
    switch ((TipoTextField) textField.tag)
    {
        case tipoDinheiro:
            return [self editDinheiro:textField shouldChangeCharactersInRange:range replacementString:string];
            
        case tipoCEP:
            return [self editCEP:textField shouldChangeCharactersInRange:range replacementString:string];
            
        case tipoCPF:
            return [self editCPF:textField shouldChangeCharactersInRange:range replacementString:string];
            
        case tipoIdentidade:
            return [self editIdentidade:textField shouldChangeCharactersInRange:range replacementString:string];
            
        case tipoTelefone:
            return [self editTelefone:textField shouldChangeCharactersInRange:range replacementString:string];
            
        case tipoNumeros:
            return [self editNumeros:textField shouldChangeCharactersInRange:range replacementString:string];
        
        case tipoNone:
        default:
            break;
    }
    
    if ([delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) return [delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    if ([delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) [delegate textFieldDidBeginEditing:textField];

    self.textFieldAtivo = textField;
    /* keyboard is visible, move views */
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) [delegate textFieldDidEndEditing:textField];
    
    [textField resignFirstResponder];
    self.textFieldAtivo = nil;
    /* resign first responder, hide keyboard, move views */
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) return [delegate textFieldShouldBeginEditing:textField];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    switch ((TipoTextField) textField.tag)
    {
        case tipoDinheiro:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DinheiroEmpty" object:textField];
            break;
            
        case tipoCEP:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CEPEmpty" object:textField];
            break;
            
        case tipoIdentidade:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IDEmpty" object:textField];
            break;
            
        case tipoNumeros:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NumeroEmpty" object:textField];
            break;
            
        case tipoTelefone:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TelefoneEmpty" object:textField];
            break;
            
        case tipoCPF:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CPFEmpty" object:textField];
            break;
            
        default:
            break;
    }
    
    if ([delegate respondsToSelector:@selector(textFieldShouldClear:)]) return [delegate textFieldShouldClear:textField];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) return [delegate textFieldShouldEndEditing:textField];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)]) return [delegate textFieldShouldReturn:textField];
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
