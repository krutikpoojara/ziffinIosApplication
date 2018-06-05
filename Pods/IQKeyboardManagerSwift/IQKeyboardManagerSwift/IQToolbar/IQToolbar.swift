//
//  IQToolbar.swift
// https://github.com/hackiftekhar/IQKeyboardManager
// Copyright (c) 2013-15 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit

/** @abstract   IQToolbar for IQKeyboardManager.    */
open class IQToolbar: UIToolbar , UIInputViewAudioFeedback {

    override open class func initialize() {
        
        superclass()?.initialize()
                
        self.appearance().barTintColor = nil
        
        //Background image
        self.appearance().setBackgroundImage(nil, forToolbarPosition: UIBarPosition.any,            barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, forToolbarPosition: UIBarPosition.bottom,         barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, forToolbarPosition: UIBarPosition.top,            barMetrics: UIBarMetrics.default)
        self.appearance().setBackgroundImage(nil, forToolbarPosition: UIBarPosition.topAttached,    barMetrics: UIBarMetrics.default)

        self.appearance().setShadowImage(nil, forToolbarPosition: UIBarPosition.any)
        self.appearance().setShadowImage(nil, forToolbarPosition: UIBarPosition.bottom)
        self.appearance().setShadowImage(nil, forToolbarPosition: UIBarPosition.top)
        self.appearance().setShadowImage(nil, forToolbarPosition: UIBarPosition.topAttached)
        
        //Background color
        self.appearance().backgroundColor = nil
    }
    
    open var titleFont : UIFont? {
        
        didSet {
            
            if let newItems = items {
                for item in newItems {
                    
                    if let newItem = item as? IQTitleBarButtonItem {
                        newItem.font = titleFont
                    }
                }
            }
        }
    }
    
    open var title : String? {
        
        didSet {
            
            if let newItems = items {
                for item in newItems {
                    
                    if let newItem = item as? IQTitleBarButtonItem {
                        newItem.font = titleFont
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sizeToFit()
        autoresizingMask = UIViewAutoresizing.flexibleWidth
        tintColor = UIColor.black
        self.isTranslucent = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        sizeToFit()
        autoresizingMask = UIViewAutoresizing.flexibleWidth
        tintColor = UIColor.black
        self.isTranslucent = true
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFit = super.sizeThatFits(size)
        sizeThatFit.height = 44
        return sizeThatFit
    }

    override open var tintColor: UIColor! {
        
        didSet {
            if let unwrappedItems = items {
                for item in unwrappedItems {
                    
                    if let newItem = item as? IQTitleBarButtonItem {
                        newItem.tintColor = tintColor
                    }
                }
            }
        }
    }
    
    open var enableInputClicksWhenVisible: Bool {
        return true
    }
}
