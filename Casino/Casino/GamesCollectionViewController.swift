//
//  GamesCollectionViewController.swift
//  Casino
//
//  Created by seattle on 12/27/18.
//  Copyright © 2018 ACA. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GamesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    var icons: [UIImage] = [UIImage(named: "slot")!]
    var games: [String] = ["Slot machine"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Check first daily login
        
        let lastLaunch = UserDefaults.standard.double(forKey: "lastLaunch")
        let lastLaunchDate = Date(timeIntervalSince1970: lastLaunch)
        let lastLaunchIsToday = Calendar.current.isDateInToday(lastLaunchDate)
        
        if !lastLaunchIsToday {
            // add daily reward
        }
        // Update the last launch value
        UserDefaults.standard.set(NSDate().timeIntervalSince1970, forKey: "lastLaunch")    }



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as! GamesCollectionViewCell
        cell.gameNameLabel.text = games[indexPath.row]
        cell.gameIcon.image = icons[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ARViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
