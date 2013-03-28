package jascii.macro;

import haxe.macro.Expr;

typedef AnimData = {
    frame:Array<Array<jascii.display.Symbol>>,
    ?raw_options:Map<String, String>,
    options:Map<String, ExprDef>,
};
