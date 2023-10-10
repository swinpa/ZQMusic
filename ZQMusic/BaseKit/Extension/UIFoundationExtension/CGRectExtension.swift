import CoreGraphics
extension CGRect {
    public var x:CGFloat {
        get {
            return self.origin.x
        }
        set(newX) {
            var origin = self.origin
            origin.x = newX
            self.origin = origin
        }
    }
    public var y:CGFloat {
        get {
            return self.origin.y
        }
        set(newY) {
            var origin = self.origin
            origin.y = newY
            self.origin = origin
        }
    }
    
    public var width:CGFloat {
        get {
            return self.size.width
        }
        set(newWidth) {
            var size = self.size
            size.width = newWidth
            self.size = size
        }
    }
    public var height:CGFloat {
        get {
            return self.size.height
        }
        set(newHeight) {
            var size = self.size
            size.height = newHeight
            self.size = size
        }
    }
    
}


