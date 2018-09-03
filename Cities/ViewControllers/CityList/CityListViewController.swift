//
//  CityListViewController.swift
//  Cities
//
//

import UIKit
import SVProgressHUD
import CoreData

class CityListViewController: UIViewController {

    @IBOutlet weak var tblCities: UITableView!
    @IBOutlet weak var searchCity: UISearchBar!
    
    private var presenter = CityItemPresenter()

    var strSearchCity: String {
        get {
            return presenter.strSearchCity
        }
        
        set{
            presenter.strSearchCity = newValue
        }
    }
    
    var isSearching: Bool {
        get {
            return presenter.isSearching
        }
        
        set{
            presenter.isSearching = newValue
        }
    }
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.attachCityView(view: self)
        
    }

    //MARK: - Other Actions
    func initialSetup() {
        tblCities.dataSource = presenter
        tblCities.tableFooterView = UIView()
        presenter.currentPage = 1
        presenter.getCityList()
    }

    func displayData() {
        presenter.arrCities.removeAll(keepingCapacity: false)

        if isSearching == true {
            presenter.arrCities = presenter.arrCitiesSearched

            self.presenter.arrCities = self.presenter.arrCities.sorted(by: { (city1, city2) -> Bool in
                return city1.name < city2.name
            })
            tblCities.reloadData()
        }
        else {
            presenter.getCities()
        }

    }
    
}

//MARK: - UITableView
extension CityListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //NOTE: - Load data according to search pagination value OR normal pagination value
        if isSearching == false {
            if(indexPath.row == self.presenter.arrCities.count - 1  &&  self.presenter.arrCities.count < presenter.totalRecords)
            {
                presenter.currentPage += 1
                self.presenter.getCityList()
            }
        }
        else {
            if(indexPath.row == self.presenter.arrCities.count - 1  &&  self.presenter.arrCities.count < presenter.totalRecordsSearched)
            {
                presenter.currentPageSearched += 1
                self.presenter.getCityList()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CityCell else {
            return
        }
        if let viewControllers = self.tabBarController?.viewControllers, let mapViewContrtoller = viewControllers[1] as? MapViewController{
            mapViewContrtoller.city = cell.city
        } 
        self.tabBarController?.selectedIndex = 1
    }
}


//MARK: - UISearchBarDelegate
extension CityListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchCity.showsCancelButton = (searchBar.text?.isValid)!
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchCity.showsCancelButton = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchCity.text = ""
        self.view.endEditing(true)
        self.presenter.getCities()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        if searchBar.text?.isValid == true {
            self.isSearching = true
            self.strSearchCity = searchBar.text!
            self.presenter.currentPageSearched = 1
            self.presenter.totalRecordsSearched = 0
            self.presenter.totalRecordsSearched = 0

            self.presenter.getCityList()
        }
        else {
            self.isSearching = false
            self.strSearchCity = ""
            self.displayData()
        }
    }
}


//MARK: - Get Data
extension CityListViewController: CityItemsView {
    
    func FinishGettingCities() {
        self.displayData()
        if self.presenter.arrCitiesSearched.count > 0 {
            self.tblCities.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }

    func getCityList(items: [City]) {
        self.presenter.arrCities.removeAll(keepingCapacity: false)
        self.presenter.arrCities = items
        tblCities.reloadData()
    }
}


