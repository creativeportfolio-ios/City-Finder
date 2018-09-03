//
//  CityCell.swift
//  Cities
//
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var lblIcon: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocalName: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    var city: City! {
        didSet {
            lblIcon.backgroundColor = getRandomColor()
            lblIcon.layer.cornerRadius = lblIcon.frame.width/2
            lblIcon.clipsToBounds = true
            lblIcon.text = "\(city.name.first ?? "?")"
            lblName.text = city.name
            lblLocalName.text = city.nameLocal
            lblCountry.text = "\(city.country.name ?? "")"
        }
    }

    func getRandomColor() -> UIColor {
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return UIColor(red:red, green: green, blue: blue, alpha: 0.6)
    }
}
