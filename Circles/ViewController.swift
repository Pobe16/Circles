//
//  ViewController.swift
//  Circles
//
//  Created by Mikolaj Lukasik on 04/11/2019.
//  Copyright © 2019 Mikolaj Lukasik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var lastTouch : CGPoint?
    var greatCircleDance : Int = 0
    
    @IBOutlet var gr: UITapGestureRecognizer!
    @IBOutlet var sgr: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        gr.addTarget(self, action: #selector(handleTap))
        sgr.addTarget(self, action: #selector(handleSwipe))
        
        view.addGestureRecognizer(gr)
        view.addGestureRecognizer(sgr)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        lastTouch = sender.location(ofTouch: 0, in: view)
        print("Tap")
        print(lastTouch ?? "Error in generating point.")
        
        let newView = makeView()
        
        newView.transform = CGAffineTransform(scaleX: 0.2, y: 0.5)
        view.addSubview(newView)
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {newView.transform = .identity},
                       completion: nil)
        
        spreadViewsAround()
                       
    }
    
    
    @objc func handleSwipe(sender: UIPanGestureRecognizer) {
        print("Swipe")
        view.subviews.last?.removeFromSuperview()
        
    }
    
    func spreadViewsAround() {
        let lastAdded = view.subviews.last

        view.subviews.forEach {  shape in
            if shape != lastAdded {
                let initialDistanceX = shape.center.x - lastAdded!.center.x
                let initialDistanceY = shape.center.y - lastAdded!.center.y
                let distanceBetweenCentres =  (initialDistanceX*initialDistanceX + initialDistanceY*initialDistanceY).squareRoot()
                
                let distanceBetweenShapes = shape.frame.size.width/2 + lastAdded!.frame.size.width/2
                

                if distanceBetweenCentres < distanceBetweenShapes {
                    
                    let proportionalDistance = distanceBetweenShapes / distanceBetweenCentres
                    
                    let lastAddedPosition = lastAdded!.center
                    
                    let size = shape.frame.size
                    
                    let moveShapeByX = initialDistanceX * proportionalDistance + (initialDistanceX > 0 ? CGFloat(greatCircleDance) : -CGFloat(greatCircleDance))
                    
                    let moveShapeByY = initialDistanceY * proportionalDistance + (initialDistanceY > 0 ? CGFloat(greatCircleDance) : -CGFloat(greatCircleDance))
                    
                    let newPosition = CGPoint(
                        x: lastAddedPosition.x + moveShapeByX - shape.frame.size.width/2,
                        y: lastAddedPosition.y + moveShapeByY - shape.frame.size.width/2
                    )
                    
                    UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.25,
                                   initialSpringVelocity: 0,
                                   options: [],
                                   animations: {
                                       shape.frame = CGRect(origin: newPosition, size: size)
                                   },
                                   completion: {(finished : Bool) in
                                    self.theGreatShapeDance()
                    }
                    )
                    
                    
                                    
                }
            }
        }
    }
    
    func removeShapesOutOfBounds() {
        var shapesDeleted = 0
         view.subviews.forEach { shape in
            if (
                shape.center.x + shape.frame.size.width/2 < 0 ||
                    shape.center.y + shape.frame.size.height/2 < 0
                ) || (
                    shape.center.x - shape.frame.size.width/2 > view.bounds.maxX ||
                        shape.center.y - shape.frame.size.height/2 > view.bounds.maxY
                )
            {
                shapesDeleted += 1
                shape.removeFromSuperview()
            }
        }
        shapesDeleted > 0 ? print("Deleted \(shapesDeleted) shapes.") : nil
    }
    
    func theGreatShapeDance() {
        var shapesMoved = 0
        var shapeMoved = false
        view.subviews.reversed().forEach{ mainShape in
            let currentShape = mainShape
            view.subviews.forEach { shape in
                if shape != currentShape {
                    let initialDistanceX = shape.center.x - currentShape.center.x
                    let initialDistanceY = shape.center.y - currentShape.center.y
                    let distanceBetweenCentres =  (initialDistanceX * initialDistanceX + initialDistanceY * initialDistanceY).squareRoot()
                    
                    let distanceBetweenShapes = shape.frame.size.width/2 + currentShape.frame.size.width/2
                    

                    if distanceBetweenCentres < distanceBetweenShapes {
                        shapeMoved = true
                        shapesMoved += 1
                        
                        let proportionalDistance = distanceBetweenShapes / distanceBetweenCentres
                        
                        let lastAddedPosition = currentShape.center
                        
                        let size = shape.frame.size
                        
                        let moveShapeByX = initialDistanceX * proportionalDistance + (initialDistanceX > 0 ? CGFloat(greatCircleDance) : -CGFloat(greatCircleDance))
                        
                        let moveShapeByY = initialDistanceY * proportionalDistance + (initialDistanceY > 0 ? CGFloat(greatCircleDance) : -CGFloat(greatCircleDance))
                        
                        let newPosition = CGPoint(
                            x: lastAddedPosition.x + moveShapeByX - shape.frame.size.width/2,
                            y: lastAddedPosition.y + moveShapeByY - shape.frame.size.width/2
                        )
                        UIView.animate(withDuration: 0.5,
                                       delay: 0 ,
                                       usingSpringWithDamping: 0.25,
                                       initialSpringVelocity: 0,
                                       options: [],
                                       animations: {
                                           shape.frame = CGRect(origin: newPosition, size: size)
                                       },
                                       completion: nil
                        )
                        
                        
                    }
                }
            }
            
        }
        greatCircleDance += 1
        print("This dance moved \(shapesMoved) shapes.")
        removeShapesOutOfBounds()
        if shapeMoved && greatCircleDance < 150 {
            theGreatShapeDance()
        } else {
            print("The Great Circle Dance has run \(greatCircleDance) times. There are \(view.subviews.count) shapes.")
            greatCircleDance = 0
        }
    }
    
    
    
    func makeView() -> UIView {
        let longerSizeOfSuperView : CGFloat = max(view.bounds.maxX, view.bounds.maxY)
        
        let size = makeRandomSize(inRange: longerSizeOfSuperView/10...longerSizeOfSuperView/3)
        
        let shorterSizeOfTheThing : CGFloat = min(size.width, size.height)
        
        let position = makeRandomPosition(usingWidth: size.width, andHeight: size.height)
        
        let newView = UIView()
        
        newView.frame = CGRect(origin: position, size: size)
        newView.backgroundColor = makeRandomColor()
        newView.layer.cornerRadius = makeRandomCornerRadius(usingWidth: shorterSizeOfTheThing)
        
        return newView
        
    }
    
    func makeRandomSize(inRange range: ClosedRange<CGFloat>) -> CGSize {
        let width = CGFloat.random(in: range)
//        let height = CGFloat.random(in: range)
//        return CGSize(width: width, height: height)
        return CGSize(width: width, height: width)
    }
    
    func makeRandomPosition(usingWidth width: CGFloat, andHeight height: CGFloat) -> CGPoint {
        let exactX = (lastTouch?.x ?? view.center.x) - (width/2)
        let exactY = (lastTouch?.y ?? view.center.y) - (height/2)
        
        let rangeOfXPosition: ClosedRange<CGFloat> = exactX-50 ... exactX+50
        let rangeOfYPosition: ClosedRange<CGFloat> = exactY-50 ... exactY+50
        
        
//      This is how it was done in example - total randomness, all within range.
//      I want to make it show up on (or in close vicinity of) tap. /\/\/\
//
//        let maxX = view.bounds.maxX - width
//        let rangeOfXPosition = view.bounds.minX ... maxX
//
//        let maxY = view.bounds.maxY - height
//        let rangeOfYPosition = view.bounds.minY ... maxY

        let x = CGFloat.random(in: rangeOfXPosition)
        let y = CGFloat.random(in: rangeOfYPosition)

        return CGPoint(x: x, y: y)
    }
    
    func makeRandomColor() -> UIColor {
        let randomRed = CGFloat.random(in: 0...255) / 255
        let randomGreen = CGFloat.random(in: 0...255) / 255
        let randomBlue = CGFloat.random(in: 0...255) / 255
        let randomAlpha = CGFloat.random(in: 0.6...1)
        
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: randomAlpha)
    }

    func makeRandomCornerRadius(usingWidth width: CGFloat) -> CGFloat {
//        return CGFloat.random(in: 0...(width/2))
        return width/2
    }

}

