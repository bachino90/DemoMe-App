//
//  AddTarjetaViewController.m
//  DemoMe
//
//  Created by Emiliano Bivachi on 06/12/13.
//  Copyright (c) 2013 Emiliano Bivachi. All rights reserved.
//

#import "AddTarjetaViewController.h"

@interface AddTarjetaViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tarjetaNumero;
@property (weak, nonatomic) IBOutlet UITextField *tarjetaNombre;
@property (weak, nonatomic) IBOutlet UITextField *tarjetaFecha;
@property (weak, nonatomic) IBOutlet UITextField *tarjetaCVV;

@end

@implementation AddTarjetaViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addTarjeta:(id)sender {
    Tarjeta *tarjeta = [[Tarjeta alloc]init];
    tarjeta.numero = self.tarjetaNumero.text;
    tarjeta.nombre = self.tarjetaNombre.text;
    tarjeta.fecha = self.tarjetaFecha.text;
    tarjeta.cvv = self.tarjetaCVV.text;
    
    [self.delegate addTarjeta:tarjeta];
}

- (IBAction)cancel:(id)sender {
    [self.delegate cancelAddTarjeta];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

@end
