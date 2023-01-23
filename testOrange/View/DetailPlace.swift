//
//  DetailPlace.swift
//  testOrange
//
//  Created by Mohamed Melek Chtourou on 23/1/2023.
//

import Foundation
import UIKit

class DetailPlace : UIViewController{

    private var placesViewModel : wikiDataViewModel!
    var placeDetail : WikiData?
    
    @IBOutlet weak var wikiLink: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var titleDetail: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func returnButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        callToViewModelForUiUpdate()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        wikiLink.isUserInteractionEnabled = true
        wikiLink.addGestureRecognizer(tap)
    }
    
    func callToViewModelForUiUpdate(){
        self.placesViewModel =  wikiDataViewModel()
               self.placesViewModel.binPlacesViewModelToController = {
                   DispatchQueue.global(qos: .background).async { [self] in
                            DispatchQueue.main.sync {
                                self.placeDetail = self.placesViewModel.result
                                imageView.downloaded(from: self.placeDetail!.preview.source)
                                nomLabel.text = self.placeDetail!.name
                                regionLabel.text = self.placeDetail!.address.county + self.placeDetail!.address.city
                                kindLabel.text = self.placeDetail!.kinds
                                descLabel.text = self.placeDetail!.wikipediaExtracts.text
                                titleDetail.title = self.placeDetail!.name
                                  }
                          }
               }
        }
    @objc
      func tapFunction(sender:UITapGestureRecognizer) {
          if let url = URL(string: self.placeDetail!.wikipedia) {
              UIApplication.shared.open(url)
          }
      }
}
