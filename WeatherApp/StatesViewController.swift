//
//  StatesViewController.swift
//  WeatherApp
//
//  Created by Techno on 11/3/15.
//  Copyright © 2015 Techno. All rights reserved.
//

import UIKit
import Alamofire



class StatesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var myTableviewStates: UITableView!
    var myTableData  = []
    var myStringVal :String = ""
    var actInd : UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title="Select the State for Weather"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        myTableviewStates.delegate = self
        myTableviewStates.dataSource = self
        
        navigationController!.navigationBar.barTintColor = UIColor(red: (52/255.0), green: (146/255.0), blue: (201/255.0), alpha: 1.0)
        
        actInd  = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd!.center = self.view.center
        actInd!.hidesWhenStopped = true
        actInd!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        actInd!.color = UIColor.redColor()
        view.addSubview(actInd!)
        actInd!.startAnimating()
        
        Alamofire.request(.GET, "https://www.WhizAPI.com/api/v2/util/ui/in/indian-states-list?project-app-key=pz6utk2ypq8vxktwkczxnuxc").responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                
                if let dataAray = JSON["Data"] as? NSArray {
                    
                    self.myTableData = dataAray;
                    
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        self.myTableviewStates.reloadData()
                        self.actInd!.stopAnimating()
                    }
                    
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                }
                
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myTableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let textCellIdentifier = "CellCell"
        
        let cell = myTableviewStates.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let name : String = self.myTableData.objectAtIndex(indexPath.row).objectForKey("Name") as! String ;
        
        cell.textLabel?.text = name;
        
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "playerSegue", let destination = segue.destinationViewController as? CitysViewController {
            
            
            if let cell = sender as? UITableViewCell, let indexPath = myTableviewStates.indexPathForCell(cell) {
                
                
                let affiliation = self.myTableData.objectAtIndex(indexPath.row).objectForKey("ID") as! String ;
                destination.places = affiliation
                
                print("destina ====",destination.places)
            }
        }
        
        
    }
}