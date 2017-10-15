//
//  ViewController.swift
//  calc2
//
//  Created by Robert Diamond on 10/13/17.
//  Copyright © 2017 Robert Diamond. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    let rows : [[String]]
    let BUTTON = 5
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    fileprivate let displayHeight : CGFloat = 55.0
    var displayView : CalcDisplayView?
    lazy var engine = CalculatorEngine()

    required init?(coder aDecoder: NSCoder) {
        rows = [
            ["C","1/X","Sqrt","÷"],
            ["9","8","7","×"],
            ["6","5","4","-"],
            ["3","2","1","+"],
            ["±","0",".","="]
        ]
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rows.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let title = rows[indexPath.section][indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath)
        (cell.contentView.viewWithTag(BUTTON) as! UIButton).setTitle(title, for: .normal)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader && indexPath.section == 0 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CalcDisplay", for: indexPath)
            displayView = headerView as? CalcDisplayView
            displayView?.label.text = String(engine.value)
            return headerView
        } else {
            let spacerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CalcSpacer", for: indexPath)
            return spacerView
        }
        //assert(false, "Unknown element type " + kind)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let text = sender.titleLabel?.text {
            debugPrint("Pressed " + text)
            engine.handleEvent(event: text)
            displayView?.label.text = String(engine.value)
        } else {
            debugPrint("Pressed unknown")
        }
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = CGFloat(rows[indexPath.section].count)
        let rowCount = CGFloat(rows.count)
        let paddingSpaceW = sectionInsets.left * (itemsPerRow + 1)
        let paddingSpaceH = sectionInsets.top * (rowCount + 1)
        let availableWidth = view.frame.width - paddingSpaceW
        let availableHeight = view.frame.height - paddingSpaceH - displayHeight
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = availableHeight / rowCount - sectionInsets.bottom

        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = section == 0 ? displayHeight : 0.0
        return CGSize(width: collectionView.frame.width, height: height)
    }
}
