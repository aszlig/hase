package jascii.utils;

import jascii.display.Symbol;

class ColorMixer
{
    public var plain:Int;
    public var red:Int;
    public var green:Int;
    public var blue:Int;
    public var ansi:Int;

    public function new()
    {
        this.plain = 0;
        this.red = 0;
        this.green = 0;
        this.blue = 0;
        this.ansi = 0;
    }

    private function ord_to_6cube(ord:Int):Int
    {
        if (ord < "0".code || ord > "5".code)
            return 0;

        return ord - "0".code;
    }

    private function get_6cube():Int
    {
        var red:Int   = this.ord_to_6cube(this.red);
        var green:Int = this.ord_to_6cube(this.green);
        var blue:Int  = this.ord_to_6cube(this.blue);

        return 16 + (red * 36) + (green * 6) + blue;
    }

    private function get_fgcolor():Int
    {
        return switch (this.ansi) {
            case "k".code: 0;
            case "r".code: 1;
            case "g".code: 2;
            case "y".code: 3;
            case "b".code: 4;
            case "m".code: 5;
            case "c".code: 6;
            case "w".code: 7;
            case "K".code: 8;
            case "R".code: 9;
            case "G".code: 10;
            case "Y".code: 11;
            case "B".code: 12;
            case "M".code: 13;
            case "C".code: 14;
            case "W".code: 15;
            default: this.get_6cube();
        }
    }

    public function merge():Symbol
    {
        return new Symbol(this.plain, this.get_fgcolor());
    }
}
