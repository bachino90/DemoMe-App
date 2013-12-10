//
//  FacturaViewController.m
//  DemoMe
//
//  Created by Emiliano Bivachi on 06/12/13.
//  Copyright (c) 2013 Emiliano Bivachi. All rights reserved.
//

#import "FacturaViewController.h"
#import "ElegirTarjetaViewController.h"
#import "Tarjeta.h"
#import "Billetera.h"

@interface FacturaViewController () <UITableViewDelegate, UITableViewDataSource, ElegirTarjetaDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UIButton *pagarButton;
@property (weak, nonatomic) IBOutlet UIButton *pagarConOtraButton;

@property (nonatomic) BOOL isPayed;
@end

@implementation FacturaViewController

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
    self.idLabel.text = [NSString stringWithFormat:@"ID: %@",[(NSDictionary *)self.items[0] valueForKey:@"bill_id"]];
    CGFloat total = 0.0;
    for (NSDictionary *item in self.items) {
        NSString *price = [item valueForKey:@"price"];
        total += [price floatValue];
    }
    self.isPayed = NO;
    self.totalLabel.text = [NSString stringWithFormat:@"Total: $ %.2f",total];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payWithDefaultCard:(id)sender {
    self.pagarButton.enabled = NO;
    self.pagarConOtraButton.enabled = NO;
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://localhost:3000/api/bills/pay/%@",[(NSDictionary *)self.items[0] valueForKey:@"bill_id"]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // You need a customer id in order to save a card to the Braintree vault.
    // Here, for the sake of example, we set customer_id to device id.
    // In practice, this is probably whatever user_id your app has assigned to this user.
    
    request.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *body, NSError *requestError)
     {
         NSError *err = nil;
         if (!response && requestError) {
             NSLog(@"requestError: %@", requestError);
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:@"No ha se ha podido realizar la transaccion"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
             [message show];
             return;
         }
         
         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:body options:kNilOptions error:&err];
         //NSLog(@"saveCardToServer: paymentInfo: %@ response: %@, error: %@", paymentInfo, responseDictionary, requestError);
         NSNumber *pagado = [responseDictionary valueForKey:@"pagado"];
         if ([pagado isKindOfClass:[NSNull class]]) {
             pagado = [NSNumber numberWithBool:NO];
         }
         if ([pagado boolValue]) { // Success!
             // Don't forget to call the cleanup method,
             // `prepareForDismissal`, on your `BTPaymentViewController`
             // Now you can dismiss and tell the user everything worked.
             self.isPayed = YES;
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Perfecto!!"
                                                               message:@"La factura ha sido pagada"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
             [message show];
             
         } else { // The card did not save correctly, so show the error from server with convenenience method `showErrorWithTitle`
             self.pagarButton.enabled = YES;
             self.pagarConOtraButton.enabled = YES;
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:@"No ha se ha podido realizar la transaccion"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
             [message show];
         }
     }];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Elegir Tarjeta Segue"])
    {
        // Get reference to the destination view controller
        ElegirTarjetaViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.delegate = self;
    }
}

#pragma mark - Alert view Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.isPayed) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Elegir Tarjeta Delegate

- (void)cancel
{
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}

- (void)choseTarjeta:(Tarjeta *)tarjeta andSave:(BOOL)save
{
    if (save) {
        [[Billetera sharedBilletera] addTarjeta:tarjeta];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self payWithDefaultCard:nil];
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
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tarjetaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *item = self.items[indexPath.row];
    CGFloat price = [(NSString *)[item valueForKey:@"price"] floatValue];
    cell.textLabel.text = [NSString stringWithFormat:@"%@   $ %2.f",[item valueForKey:@"name"],price];
    
    return cell;
}


@end
