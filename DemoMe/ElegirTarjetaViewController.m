//
//  ElegirTarjetaViewController.m
//  DemoMe
//
//  Created by Emiliano Bivachi on 06/12/13.
//  Copyright (c) 2013 Emiliano Bivachi. All rights reserved.
//

#import "ElegirTarjetaViewController.h"
#import "Billetera.h"

@interface ElegirTarjetaViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tarjetaNumero;
@property (weak, nonatomic) IBOutlet UITextField *tarjetaNombre;
@property (weak, nonatomic) IBOutlet UITextField *tarjetaCVV;
@property (weak, nonatomic) IBOutlet UITextField *tarjetaFecha;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ElegirTarjetaViewController

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

- (IBAction)cancel:(id)sender
{
    [self.delegate cancel];
}

- (IBAction)pay:(id)sender
{
    Tarjeta *tarjeta = [[Tarjeta alloc]init];
    tarjeta.numero = self.tarjetaNumero.text;
    tarjeta.nombre = self.tarjetaNombre.text;
    tarjeta.fecha = self.tarjetaFecha.text;
    tarjeta.cvv = self.tarjetaCVV.text;
    
    [self.delegate choseTarjeta:tarjeta andSave:NO];
}

- (IBAction)payAndSave:(id)sender
{
    Tarjeta *tarjeta = [[Tarjeta alloc]init];
    tarjeta.numero = self.tarjetaNumero.text;
    tarjeta.nombre = self.tarjetaNombre.text;
    tarjeta.fecha = self.tarjetaFecha.text;
    tarjeta.cvv = self.tarjetaCVV.text;
    
    [self.delegate choseTarjeta:tarjeta andSave:YES];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [Billetera sharedBilletera].misTarjetas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tarjetaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    Tarjeta *tarjeta = [Billetera sharedBilletera].misTarjetas[indexPath.row];
    cell.textLabel.text = tarjeta.numero;
    
    return cell;
}

@end
