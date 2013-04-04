package jascii.utils;

import jascii.display.Image;
import jascii.display.Symbol;

enum Variant {
    Plain;
    Color16;
    ColorRed;
    ColorGreen;
    ColorBlue;
}

enum Header {
    ChrAttr(key:String, val:Symbol);
    StrAttr(key:String, val:String);
    IntAttr(key:String, val:Int);
    Variant(variant:Variant);
}

typedef Container = {
    var headers:Array<Header>;
    var body:Image;
};
