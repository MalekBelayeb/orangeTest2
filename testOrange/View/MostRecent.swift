//
//  ViewController.swift
//  testOrange
//
//  Created by Mohamed Melek Chtourou on 23/1/2023.
//

import UIKit
import DropDown
import CoreData
import CoreLocation
import TagListView
class MostRecent: UIViewController,UITableViewDelegate,UITableViewDataSource, TagListViewDelegate {
    
    var visible = false
    var selectedTag : String?
    private var placesViewModel : PlacesViewModel!
    var tabPlaces : [Place]?
    var tabPlacesFiltred : [Place]?
    let dropDown = DropDown()
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var settingsUIbutton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var sliderRange: UISlider!
    @IBOutlet weak var rangeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBAction func validateRange(_ sender: Any) {
        print(sliderRange.value * 10000)
        UserDefaults.standard.setValue(sliderRange.value * 10000, forKey: "radius")
        callToViewModelForUiUpdate()
        rangeView.visibility = .invisible
    }
    
    @IBAction func currentLocation(_ sender: Any) {
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location
            UserDefaults.standard.setValue(currentLoc.coordinate.latitude, forKey: "lat")
            UserDefaults.standard.setValue(currentLoc.coordinate.longitude, forKey: "long")
            callToViewModelForUiUpdate()
          
        }
    }
    @IBAction func rangeButton(_ sender: Any) {
        if(visible){
            rangeView.visibility = .invisible
            visible = false
        }
        else{
            rangeView.visibility = .visible
            visible = true
        }
    }
    
    @IBAction func filtreCityButton(_ sender: Any) {
        dropDown.show()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tabPlaces?.count == nil && selectedTag == nil) {
            return 0
        }
        else if (selectedTag != nil){
            return tabPlacesFiltred!.count
        }
        return tabPlaces!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let cv = cell?.contentView
        let nom = cv?.viewWithTag(1) as! UILabel
        let desc = cv?.viewWithTag(2) as! UILabel
        let distance = cv?.viewWithTag(3) as! UILabel
        let fav = cv?.viewWithTag(4) as! UIButton
        
        if(selectedTag == nil){
            desc.text = self.tabPlaces![indexPath.row].kinds
            nom.text = self.tabPlaces![indexPath.row].name
            distance.text = String(format: "%.2f", self.tabPlaces![indexPath.row].dist) + "m"
            titleLabel.text = "Places of interest (\(tabPlaces!.count))"
        }
        
        else{
            desc.text = self.tabPlacesFiltred![indexPath.row].kinds
            nom.text = self.tabPlacesFiltred![indexPath.row].name
            distance.text = String(format: "%.2f", self.tabPlacesFiltred![indexPath.row].dist) + "m"
            titleLabel.text = "Places of interest (\(tabPlacesFiltred!.count))"

        }
        //fav.tag = indexPath.row
        //fav.addTarget(self, action: #selector(pressedAction(_:)), for: .touchUpInside)
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let index = sender as! IndexPath
            let destination = segue.destination as! DetailPlace
            UserDefaults.standard.setValue(tabPlaces![index.row].xid, forKey: "xid")
        }
     
    }
    
    @objc func pressedAction(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity2", in: context)
        let newFav = NSManagedObject(entity: entity!, insertInto: context)
        newFav.setValue(tabPlaces![sender.tag].name, forKey: "name")
        newFav.setValue(tabPlaces![sender.tag].xid, forKey: "xib")
        newFav.setValue(tabPlaces![sender.tag].dist, forKey: "dist")
        newFav.setValue(tabPlaces![sender.tag].kinds, forKey: "kinds")
        do {
          try context.save()
         } catch {
          print("Error saving")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
         performSegue(withIdentifier: "detail", sender: indexPath)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeView.visibility = .invisible
        callToViewModelForUiUpdate()
        dropDown.anchorView = settingsUIbutton // UIView or UIBarButtonItem
        dropDownSelector()
        dropDown.dataSource = ["Tunis","Sousse", "Ariana","Bizerte","Sfax","Manouba"]
        dropDown.selectionBackgroundColor = .blue
        locationManager.requestWhenInUseAuthorization()
        
        tagListView.textFont = UIFont.systemFont(ofSize: 24)
        tagListView.alignment = .center
        tagListView.addTags(["Historic", "Cultural", "Religion", "Museums"])
        tagListView.delegate = self
        tagListView.tagBackgroundColor = .clear
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if(self.selectedTag == nil || self.selectedTag != title){
            self.selectedTag = title
            tagListView.tagBackgroundColor = .clear
            tagView.tagBackgroundColor = .gray
            tabPlacesFiltred = tabPlaces?.filter { place in
                return place.kinds.contains(title.lowercased())
            }
            
        }else{
            tagListView.tagBackgroundColor = .clear
            selectedTag = nil
        }
        self.tableView.reloadData()
    }
    
    
    func dropDownSelector (){
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            switch item {
            case "Tunis":
                UserDefaults.standard.setValue("10.181532", forKey: "long")
                UserDefaults.standard.setValue("36.806496", forKey: "lat")
            case "Sousse":
                UserDefaults.standard.setValue("10.634422", forKey: "long")
                UserDefaults.standard.setValue("35.821430", forKey: "lat")
            case "Ariana":
                UserDefaults.standard.setValue("10.640630", forKey: "long")
                UserDefaults.standard.setValue("35.829300", forKey: "lat")
            case "Bizerte":
                UserDefaults.standard.setValue("9.871910", forKey: "long")
                UserDefaults.standard.setValue("37.272591", forKey: "lat")
            case "Sfax":
                UserDefaults.standard.setValue("10.760180", forKey: "long")
                UserDefaults.standard.setValue("34.747021", forKey: "lat")
            case "Manouba":
                UserDefaults.standard.setValue("10.086327", forKey: "long")
                UserDefaults.standard.setValue("36.809328", forKey: "lat")
            default:
                UserDefaults.standard.setValue("10.181532", forKey: "long")
                UserDefaults.standard.setValue("36.806496", forKey: "lat")
            }
            settingsUIbutton.setTitle(item, for: .normal)
            callToViewModelForUiUpdate()
        }
    }
    
    func callToViewModelForUiUpdate(){
        self.placesViewModel =  PlacesViewModel()
               self.placesViewModel.binPlacesViewModelToController = {
                   DispatchQueue.global(qos: .background).async {
                       //sleep(2)
                            DispatchQueue.main.sync {
                                self.tabPlaces = self.placesViewModel.result
                                self.tableView.reloadData()
                                  }
                          }
               }
        }
}

