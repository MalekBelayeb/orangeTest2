//
//  wikiDataViewModelk.swift
//  testOrange
//
//  Created by Mohamed Melek Chtourou on 23/1/2023.
//

import Foundation
class wikiDataViewModel: NSObject {
    
    private var apiService : APIService!
    private(set) var result : WikiData! {
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
        getPlaceDetail(id: UserDefaults.standard.string(forKey: "xid")!)
    }
    
    func getPlaceDetail(id : String){
        self.apiService.getPlaceDetails(id: id){ places in
            self.result = places
        }
    }
    
}
