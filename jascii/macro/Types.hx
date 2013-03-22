package jascii.macro;

import haxe.macro.Expr;

typedef AnimData = {
    frame:Array<Array<Int>>,
    ?raw_options:Hash<String>,
    options:Hash<ExprDef>,
};
