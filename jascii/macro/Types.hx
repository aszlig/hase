package jascii.macro;

import haxe.macro.Expr;

typedef AnimData = {
    frame:Array<Array<Int>>,
    ?raw_options:Map<String, String>,
    options:Map<String, ExprDef>,
};
