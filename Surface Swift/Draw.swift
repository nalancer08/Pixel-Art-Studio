//
//  Draw.swift
//  Surface Swift
//
//  Created by Webchimp on 27/09/16.
//  Copyright © 2016 AppBuilders. All rights reserved.
//

import Foundation
import UIKit
import Darwin

//extension UIScrollViewDelegate()
class Draw: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate  {
    
    var lastPoint = CGPoint.zero;
    var red: CGFloat = 0.0;
    var green: CGFloat = 0.0;
    var blue : CGFloat = 0.0;
    var brushWidth: CGFloat = 1.5;
    var opacity: CGFloat = 1.0;
    var swiped = false;
    let mainImageView: UIImageView = UIImageView();
    let tempImageView: UIImageView = UIImageView();
    var scrollView: UIScrollView!;
    
    var xNumberLines = 45;//96;
    var yNumbreLines = 30;//64;
    
    var xSpaces:CGFloat! = 0;
    var ySpaces:CGFloat! = 0;
    
    let pixelLine:Int! = 0;
    let pixelRectangule:Int! = 1;
    let screenRect:CGRect! = UIScreen.mainScreen().bounds;
    
    var touchMenu = 0;
    var normalScale:CGFloat!;
    
    var colorDrawPixel:UIColor! = UIColor.redColor();
    
    // Lado de SUrface
    var window = SfPanel();
        let optionsPanel = SfPanel();
            let reDrawPanel = SfPanel();
            let closeOpenPanel = SfPanel();
            let closeDrawPanel = SfPanel();
            let savePanel = SfPanel();
    
    let reDrawView = UIButton();
    let closeDrawView = UIButton();
    let saveView = UIButton();
    
    let closeOpenView = UIButton();
    let viewCuadrito = UIView();
    
    //var mat
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let value = UIInterfaceOrientation.LandscapeLeft.rawValue;
        //UIDevice.currentDevice().setValue(value, forKey: "orientation");
        
        //UITapGestureRecognizer *tapMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMap)];
        var pinch:UIPinchGestureRecognizer! = UIPinchGestureRecognizer.init(target: self, action: #selector(Draw.pinch(_:)) );
        pinch.delegate = self;
        //view.addGestureRecognizer(pinch);
        
        scrollView = UIScrollView();
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height);
        scrollView.contentSize = view.bounds.size;
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 4.0;
        scrollView.zoomScale = 10.0;
        scrollView.bounces = false;
        scrollView.delegate = self;
        
        normalScale = self.view.frame.size.width / self.view.bounds.size.width;
        
        self.view.backgroundColor = UIColor.init(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0);
        
        reDrawView.setTitle("@", forState: UIControlState.Normal);
        reDrawView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        reDrawView.addTarget(self, action: #selector(Draw.reDrawCanvas), forControlEvents: .TouchUpInside);
        reDrawView.backgroundColor = UIColor.init(red: 0.569, green: 0.639, blue: 0.682, alpha: 0.8);
        
        saveView.setTitle("S", forState: UIControlState.Normal);
        saveView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        saveView.addTarget(self, action: #selector(Draw.randomColor), forControlEvents: .TouchUpInside);
        saveView.backgroundColor = UIColor.init(red: 0.569, green: 0.639, blue: 0.682, alpha: 0.8);
        
        closeDrawView.setTitle("X", forState: UIControlState.Normal);
        closeDrawView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        closeDrawView.addTarget(self, action: #selector(Draw.showAndHideFunctions), forControlEvents: .TouchUpInside);
        closeDrawView.backgroundColor = UIColor.init(red: 0.569, green: 0.639, blue: 0.682, alpha: 0.8);
        
        closeOpenView.setTitle("<>", forState: UIControlState.Normal);
        closeOpenView.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        closeOpenView.addTarget(self, action: #selector(Draw.showAndHideFunctions), forControlEvents: .TouchUpInside);
        closeOpenView.backgroundColor = UIColor.redColor();
        
        viewCuadrito.backgroundColor = UIColor.clearColor();
        
        // SURFACE
        window.append(optionsPanel);
        optionsPanel.append(reDrawPanel)
            .append(savePanel)
            .append(closeDrawPanel)
            .append(closeOpenPanel);
        
        window.setSize(-100, height: -100);
        
        optionsPanel.setSize(-5, height: -100).setView(viewCuadrito);
        //optionsPanel.setPosition(SF_POSITION_FIXED).setOrigin( (Float(screenRect.size.height) - Float(screenRect.size.height) * 0.10) / 2 , right: 0, bottom: Float(SF_UNSET), left: Float(SF_UNSET) );
        optionsPanel.setPosition(SF_POSITION_FIXED).setOrigin( 0 , right: 0, bottom: Float(SF_UNSET), left: Float(SF_UNSET) );
        optionsPanel.setAlignment(SF_ALIGNMENT_LEFT);
        
       
        reDrawPanel.setSize(0, height: 0).setView(reDrawView);
        savePanel.setSize(0, height: 0).setView(saveView);
        closeDrawPanel.setSize(0, height: 0).setView(closeDrawView);
        closeOpenPanel.setSize(-65, height: -10).setMargin( ( Float(screenRect.height) - ( Float(screenRect.height * 0.10) ) ) / 2 , right: 0, bottom: 0, left:20 ).setView(closeOpenView);
        closeOpenPanel.setAlignment(SF_ALIGNMENT_LEFT);
        
     
        
        //closeOpenPanel.setPosition(SF_POSITION_FIXED);
        
        //mainImagePanel.setSize(-100, height: -100).setView(mainImageView);
        //tempImagePanel.setSize(-100, height: -100).setView(tempImageView);
        window.update();
        /////////
        
        mainImageView.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
        tempImageView.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
        
        mainImageView.contentMode = .ScaleToFill;
        tempImageView.contentMode = .ScaleToFill;

        //self.view.addSubview(scrollView);
        self.view.addSubview(tempImageView);
        self.view.addSubview(mainImageView);
        
        self.view.addSubview(viewCuadrito);
        self.view.addSubview(reDrawView);
        self.view.addSubview(saveView);
        self.view.addSubview(closeDrawView);
        self.view.addSubview(closeOpenView);
        
        xSpaces = screenRect.size.width / CGFloat(xNumberLines);
        ySpaces = screenRect.size.height / CGFloat(yNumbreLines);
        
        makeGrid();
        
        //self.view.transform =
        view?.transform = CGAffineTransformScale((view?.transform)!, 1.0, 1.0);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false;
        
        let touch:UITouch! = touches.first;
        
        if ( touch != nil ) {
            
            lastPoint = touch.locationInView(self.view);
            
            //var tempPoint = CGPointMake(newX, newY);
            let tempPoint = findPixel(lastPoint);
            drawFigureFrom(tempPoint, toPoint: tempPoint, type: pixelRectangule);
            
        }
    }
    
    func drawFigureFrom(fromPoint: CGPoint, toPoint: CGPoint, type: Int) {
        
        // INICIALIZAMOS LAS HERRAMIENTAS DE DIBUJO
        UIGraphicsBeginImageContext(view.frame.size);
        let context = UIGraphicsGetCurrentContext();
        tempImageView.image?.drawInRect(CGRect(x:0, y:0, width: view.frame.size.width, height: view.frame.size.height));
        
        
        switch(type) {
            
        case 0:
            // LINEA
            //
            CGContextMoveToPoint(context!, fromPoint.x, fromPoint.y);
            CGContextAddLineToPoint(context!, toPoint.x, toPoint.y);
            
            //
            CGContextSetLineCap(context!, .Round);
            CGContextSetLineWidth(context!, brushWidth);
            CGContextSetRGBStrokeColor(context!, 255, 255, 255, 1.0);
            CGContextSetBlendMode(context!, .Normal)
            
            //
            CGContextStrokePath(context!);
            
            break;
            
        case 1:
            
            // PIXEL -- CUADRITO
            /*CGContextMoveToPoint(context, 100, 100)
            CGContextAddLineToPoint(context, 150, 150)
            CGContextAddLineToPoint(context, 100, 200)
            CGContextAddLineToPoint(context, 50, 150)
            CGContextAddLineToPoint(context, 100, 100)*/
            
            let rectangule = CGRectMake(fromPoint.x + brushWidth, fromPoint.y + brushWidth , xSpaces - (brushWidth * 2), ySpaces - (brushWidth * 2) );
            CGContextAddRect(context!, rectangule);
            /*CGContextSetFillColorWithColor(context!, UIColor.whiteColor().CGColor);
            CGContextFillPath(context!);
            CGContextStrokePath(context!);*/
            
            CGContextSetFillColorWithColor(context!, self.colorDrawPixel.CGColor);
            CGContextFillPath(context!);
            CGContextStrokePath(context!);
            break;
            
        default:
            break;
        }
        
        //
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        tempImageView.alpha = opacity;
        
        UIGraphicsEndImageContext();
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //
        swiped = true;
        let touch:UITouch! = touches.first;
        
        if ( touch != nil ) {
            let currentPoint = touch.locationInView(view);
            
            //drawFigureFrom(lastPoint, toPoint: currentPoint, type: pixelLine);
            //
            lastPoint = currentPoint;
            
            let tempPoint = findPixel(lastPoint);
            drawFigureFrom(tempPoint, toPoint: tempPoint, type: pixelRectangule);
            //endDraw();
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !swiped {
           //drawFigureFrom(lastPoint, toPoint: lastPoint, type: pixelLine)
            
            let tempPoint = findPixel(lastPoint);
            drawFigureFrom(tempPoint, toPoint: tempPoint, type: pixelRectangule);
        }
        
        endDraw();
        
    }
    
    func endDraw() {
        
        // MERGE DE IMAGENES
        UIGraphicsBeginImageContext(mainImageView.frame.size);
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height));
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height));
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        tempImageView.image = nil;
    }
    
    func makeGrid() {
    
        for ( var i = 0; i <= xNumberLines; i++ ) {
            
            let inicio:CGPoint! = CGPointMake(xSpaces * CGFloat(i), 0);
            let fin:CGPoint! = CGPointMake(xSpaces * CGFloat(i), screenRect.size.height);
            drawFigureFrom(inicio, toPoint: fin, type: pixelLine);
            
        }
        
        for ( var i = 0; i <= yNumbreLines; i++ ) {
            
            let inicio:CGPoint! = CGPointMake(0, ySpaces * CGFloat(i));
            let fin:CGPoint! = CGPointMake(screenRect.size.width, ySpaces * CGFloat(i));
            drawFigureFrom(inicio, toPoint: fin, type: pixelLine);
            
        }
    }
    
    func findPixel(lastPoint:CGPoint!) -> CGPoint {
        
        var newX:CGFloat! = 0.0;
        var newY:CGFloat! = 0.0;
        
        
        var nose:Float! = 0;
        var nose2:Float! = 0;
        
        for ( var i = 0; i <= yNumbreLines; i++ ) {
            
            nose = Float(ySpaces) * Float(i);
            nose2 = Float(ySpaces) * Float(i+1);
            
            
            if ( Float(lastPoint.y) > nose  && Float(lastPoint.y) < nose2 ) {
                
                newY = CGFloat(nose);
                
                for ( var j = 0; j <= xNumberLines; j++ ) {
                    
                    nose = Float(xSpaces) * Float(j);
                    nose2 = Float(xSpaces) * Float(j+1);
                    
                    if ( Float(lastPoint.x) > nose  && Float(lastPoint.x) < nose2 ) {
                        
                        newX = CGFloat(nose);
                        break;
                    }
                }
                
                break;
            }
            
        }
        
        return CGPointMake(newX, newY);
    }
    
    func showAndHideFunctions() {
        
        if ( touchMenu == 0 ) {
            
            optionsPanel.setSize(-15, height: -100);
            self.viewCuadrito.backgroundColor = UIColor.init(red: 0.569, green: 0.639, blue: 0.682, alpha: 0.8);

            UIView.transitionWithView(viewCuadrito, duration: 0.35, options: .CurveEaseOut, animations: {
            
                let button:UIButton! = self.closeOpenPanel.gewtView() as! UIButton;
                button.setTitle(">", forState: UIControlState.Normal);
                
                self.closeOpenPanel.setSize(0, height: 0);

                /// TODOS LOS CONTROLES
                self.reDrawPanel.setSize(-33, height: -5);
                self.savePanel.setSize(-33, height: -5);
                self.closeDrawPanel.setSize(-32, height: -5)
                //
                
                self.window.update();
                
            }, completion: nil);
            
            touchMenu = 1;
        
        } else {
            
            optionsPanel.setSize(-5, height: -100);

            UIView.transitionWithView(viewCuadrito, duration: 0.5, options: .CurveEaseInOut, animations: {
               
                self.viewCuadrito.backgroundColor = UIColor.clearColor();

                let button:UIButton! = self.closeOpenPanel.gewtView() as! UIButton;
                button.setTitle("<>", forState: UIControlState.Normal);
                
                self.closeOpenPanel.setSize(-100, height: -10).setMargin(( Float(self.screenRect.height) - ( Float(self.screenRect.height * 0.10) ) ) / 2, right: 0, bottom: 0, left: 0);
                
                self.closeOpenPanel.setSize(-65, height: -10).setMargin( ( Float(self.screenRect.height) - ( Float(self.screenRect.height * 0.10) ) ) / 2 , right: 0, bottom: 0, left:20 );
                
                /// TODOS LOS CONTROLES
                self.reDrawPanel.setSize(0, height: 0);
                self.savePanel.setSize(0, height: 0);
                self.closeDrawPanel.setSize(0, height: 0)
                //
                
                self.window.update();
                
            }, completion: nil);

            touchMenu = 0;
        }
        
    }
    
    func reDrawCanvas() {
        
        self.mainImageView.image = nil;
        self.tempImageView.image  = nil;
        makeGrid();
        
    }
    
    func showColors() {
        
        let popoverVC = ColorPickerViewController();
        popoverVC.modalPresentationStyle = .Popover
        popoverVC.preferredContentSize = CGSizeMake(284, 446)
        if let popoverController = popoverVC.popoverPresentationController {
            //popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
            //popoverVC.delegate = self
        }
        presentViewController(popoverVC, animated: true, completion: nil)
    }
    
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .None
    }
    
    func pinch(gesture:UIPinchGestureRecognizer!) {
        
        if ( gesture.state == UIGestureRecognizerState.Ended || gesture.state == UIGestureRecognizerState.Changed ) {
            
            print("SCALE ", gesture.scale);
            
            var currentScale:CGFloat! = self.view.frame.size.width / self.view.bounds.size.width;
            var newScale:CGFloat! = currentScale * gesture.scale;
            
            if ( newScale < normalScale ) {
                newScale = normalScale;
            }
            
            if ( newScale > 1.4 ) {
                newScale = 1.4;
            }
            
            var transform:CGAffineTransform! = CGAffineTransformMakeScale(newScale, newScale);
            self.view.transform = transform;
            gesture.scale = 1.0;
            
            //var currentScale:CGFloat! = sel
        }
    }
    
    func randomColor() {
        
        let blue:Double = Double(arc4random_uniform(255) + 1) / 255;
        let red:Double = Double(arc4random_uniform(255) + 1) / 255;
        let green:Double = Double(arc4random_uniform(255) + 1) / 255;
        
        print("BLUE ==", blue, "RED = ", red, "GREEN = ", green);
        
        self.colorDrawPixel = UIColor.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0);
        showAndHideFunctions();
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

}
