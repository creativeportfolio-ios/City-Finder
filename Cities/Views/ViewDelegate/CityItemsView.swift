//
//  CityItemsView.swift
//  Cities
//

import UIKit

protocol CityItemsView {
    func getCityList(items: [City])
    func FinishGettingCities()
}
