//
//  BilleteraViewController.m
//  DemoMe
//
//  Created by Emiliano Bivachi on 06/12/13.
//  Copyright (c) 2013 Emiliano Bivachi. All rights reserved.
//

#import "BilleteraViewController.h"
#import "AddTarjetaViewController.h"
#import "Billetera.h"
#import "Tarjeta.h"

@interface BilleteraViewController () <AddTarjetaDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BilleteraViewController

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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Add Tarjeta Segue"])
    {
        // Get reference to the destination view controller
        AddTarjetaViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.delegate = self;
    }
}

#pragma mark - AddTarjeta Delegate

- (void)cancelAddTarjeta
{
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}

- (void)addTarjeta:(Tarjeta *)tarjeta
{
    [[Billetera sharedBilletera] addTarjeta:tarjeta];
    [self dismissViewControllerAnimated:TRUE completion:^{
        [self.tableView reloadData];
    }];
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
