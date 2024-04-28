//
//  ViewController.swift
//  CountryFlags
//
//  Created by Antriksh Singh on 28/04/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var countryData = [CapitalNames]()
    
    var itemsPerRow: CGFloat = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchData()
    }
    
    func fetchData(){
        guard let url = URL(string: "http://haritibhakti.com/capitalname.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Print JSON data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON data: \(jsonString)")
            }
            
            var cList = [CapitalNames]()
            
            do {
                cList = try JSONDecoder().decode([CapitalNames].self, from: data)
                print("Decoding successful")
            } catch {
                print("Error while decoding json into Swift Structure: \(error)")
            }
            
            self.countryData = cList
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }

}

extension ViewController : UICollectionViewDelegate{
    
}


extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        countryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        let baseURLString = "http://haritibhakti.com"
        let imageURLString = countryData[indexPath.row].flagimage
        let fullURLString = baseURLString + imageURLString
        
        if let url = URL(string: fullURLString) {
            cell.imageView.downloadImage(from: url)
            print(url)
        }
        

        
        cell.imageView.layer.cornerRadius = 20
        cell.labelText.text = countryData[indexPath.row].countryname
        
        return cell
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem) // You can adjust height as per your requirement
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

}
