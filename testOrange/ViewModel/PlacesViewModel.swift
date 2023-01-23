//
//  PlacesViewModel.swift
//  testOrange
//
//  Created by Mohamed Melek Chtourou on 23/1/2023.
//

import Foundation

class PlacesViewModel: NSObject {
    
    private var apiService : APIService!

    private(set) var result = Places () {
        didSet {
            DispatchQueue.main.async {
                self.binPlacesViewModelToController()
            }
        }
    }
    
    var binPlacesViewModelToController : (() -> ()) = {
    }
    
    
    override init(){
        super.init()
        self.apiService = APIService()
        getPlacesByCoordinates(point: Point(lon: Double(UserDefaults.standard.string(forKey: "long")!)!, lat: Double(UserDefaults.standard.string(forKey: "lat")!)!))
    }
    
    func getPlacesByCoordinates(point : Point){
        self.apiService.getPlacesByCoordinates(point: point){ places in
            self.result = places
        }
    }
    
}
