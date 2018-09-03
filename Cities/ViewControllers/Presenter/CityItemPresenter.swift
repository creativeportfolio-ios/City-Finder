//
//  CityItemPresenter.swift
//  Cities
//

import Foundation
import CoreData
import SVProgressHUD


class CityItemPresenter: NSObject {
    
    private var cityItemsView : CityItemsView?
    
    var arrCities: Array<City> = []
    var arrCitiesSearched: Array<City> = []
    
    var currentPage: Int = 0
    var totalPage: Int = 0
    var totalRecords: Int = 0
    
    var currentPageSearched: Int = 0
    var totalPageSearched: Int = 0
    var totalRecordsSearched: Int = 0
    
    var isSearching: Bool = false
    var strSearchCity: String = ""
    
    func attachCityView(view: CityItemsView) {
        cityItemsView = view
    }
    
    func detachCityView() {
        cityItemsView = nil
    }
    
    
    func getCities() {
        var items = [City]()

        let context = AppUtility.appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            for dict in result as! [NSManagedObject] {

                let city = City(dict: nil)
                city.ID = dict.value(forKey: "id") as? Int16 ?? 0
                city.countryID = dict.value(forKey: "country_id") as? Int16 ?? 0
                city.name = dict.value(forKey: "name") as? String ?? ""
                city.nameLocal = dict.value(forKey: "name_local") as? String ?? ""
                city.lat = dict.value(forKey: "lat") as? Double ?? 0.0
                city.lng = dict.value(forKey: "lng") as? Double ?? 0.0
                city.country = Country(dict: ["name" : dict.value(forKey: "country") as? String ?? ""])

                items.append(city)
            }

            items = items.sorted(by: { (city1, city2) -> Bool in
                return city1.name < city2.name
            })

        } catch {

            print("Failed")
        }

        cityItemsView?.getCityList(items: items)
    }

    func storeDataLocally(arrData: Array<Dictionary<String,Any>>) {
        let context = AppUtility.appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Cities", in: context)

        for dict in arrData {

            let id        = dict["id"] as? Int16 ?? 0

            updateOrInsertCity(cityDict: dict, id: id, context: context, entity: entity!)
        }

        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        getCities()
    }

    func updateOrInsertCity(cityDict: Dictionary<String, Any>, id: Int16, context: NSManagedObjectContext, entity: NSEntityDescription) {

        let block = { (city: Cities, dictPass: Dictionary<String, Any>) in
            let id        = dictPass["id"] as? Int16 ?? 0
            let countryID = dictPass["country_id"] as? Int16 ?? 0
            let name      = dictPass["name"] as? String ?? ""
            let localName = dictPass["local_name"] as? String ?? ""
            let lat       = dictPass["lat"] as? Double ?? 0.0
            let lng       = dictPass["lng"] as? Double ?? 0.0

            var country = ""
            if let dictCountry = dictPass["country"] as? Dictionary<String,Any> {
                if let strCountry = dictCountry["name"] as? String {
                    country = strCountry
                }
            }

            city.setValue(id, forKey: "id")
            city.setValue(countryID, forKey: "country_id")
            city.setValue(name, forKey: "name")
            city.setValue(localName, forKey: "name_local")
            city.setValue(lat, forKey: "lat")
            city.setValue(lng, forKey: "lng")
            city.setValue(country, forKey: "country")
        }

        if let city: Cities = fetchCity(by: id) {
            block(city, cityDict)
        }
        else {
            let city = NSManagedObject(entity: entity, insertInto: context)
            block(city as! Cities, cityDict)
        }
    }
    
    func getCityWithIndex(index: Int) -> City? {
        return (arrCities.filter{ $0.ID == index }).first
    }
    
    func fetchCity(by cityID: Int16) -> Cities? {
        let context = AppUtility.appDelegate.persistentContainer.viewContext

        // Define fetch request/predicate/sort descriptors
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        let predicate = NSPredicate(format: "id == \(cityID)", argumentArray: nil)

        // Assign fetch request properties
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 1
        fetchRequest.fetchLimit = 1

        do {
            let fetchedResults = try context.fetch(fetchRequest)
            if fetchedResults.count != 0 {

                if let cities: Cities = fetchedResults[0] as? Cities {
                    return cities
                }
            }
        } catch {
            print("Failed")
        }
        return nil
    }

}

//MARK: - UITableView
extension CityItemPresenter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = arrCities[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        cell.selectionStyle = .none
        cell.tag = Int(city.ID)
        cell.city = city
        
        return cell
    }
}

extension CityItemPresenter{
    //MARK: - Webservice
    func getCityList() {
        SVProgressHUD.show()
        
        var urlFinal = K.URL.GET_CITIES
        
        urlFinal += "?page=\(isSearching == true ? currentPageSearched : currentPage)"
        
        if isSearching == true && strSearchCity.isValid == true {
            urlFinal += "&filter[0][name][contains]=\(strSearchCity.urlEncoded())"
        }
        
        urlFinal += "&include=country"
        
        _ = WebClient.requestWithUrl(url: urlFinal, parameters: nil, headers: nil, completion: { (responseObject, error) in
            if error == nil {
                
                if self.isSearching == false {
                    //NOTE: - In this case user is not searching by city name, It will store in local Databse and retrieve data from it and then display to user
                    if let dict = responseObject {
                        if let dictData = dict["data"] as? Dictionary<String,Any> {
                            if let arrItems = dictData["items"] as? Array<Dictionary<String,Any>> {
                                self.storeDataLocally(arrData: arrItems)
                            }
                            else {
                                self.getCities()
                            }
                            
                            if let dictPagination = dictData["pagination"] as? Dictionary<String,Any> {
                                if let intTotalPage = dictPagination["last_page"] as? Int {
                                    self.totalPage = intTotalPage
                                }
                                
                                if let intTotalRecords = dictPagination["total"] as? Int {
                                    self.totalRecords = intTotalRecords
                                }
                            }
                        }
                        else {
                            self.getCities()
                        }
                    }
                    else {
                        self.getCities()
                    }
                }
                else {
                    //NOTE: - In this case user is searching by city name, So search result will be directly displayed rather then storing and retrieving data from database
                    if self.currentPageSearched == 1 {
                        self.arrCitiesSearched.removeAll(keepingCapacity: false)
                    }
                    if let dict = responseObject {
                        if let dictData = dict["data"] as? Dictionary<String,Any> {
                            if let arrItems = dictData["items"] as? Array<Dictionary<String,Any>> {
                                self.arrCitiesSearched.append(contentsOf: City.modelsFromDictionaryArray(array: arrItems))
                            }
                            self.cityItemsView?.FinishGettingCities()
                            if let dictPagination = dictData["pagination"] as? Dictionary<String,Any> {
                                if let intTotalPage = dictPagination["last_page"] as? Int {
                                    self.totalPageSearched = intTotalPage
                                }
                                
                                if let intTotalRecords = dictPagination["total"] as? Int {
                                    self.totalRecordsSearched = intTotalRecords
                                }
                            }
                        }
                    }
                }
                SVProgressHUD.dismiss()
            } else {
                
            }
            SVProgressHUD.dismiss()
        })
    }
}
