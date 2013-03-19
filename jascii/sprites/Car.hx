package jascii.sprites;

class Car extends jascii.display.Animation
{
    public function new()
    {
        super();

        this.add_frame(
            [ "    ,--+--."
            , "    |--`---`--."
            , " ~~~`-o----o--'"
            ]
        );

        this.add_frame(
            [ "    ,--+--."
            , " ~  |--`---`--."
            , "  ~~`-o----*--'"
            ]
        );

        this.add_frame(
            [ " ~  ,--+--."
            , " ~~ |--`---`--."
            , "   ~`-*----o--'"
            ]
        );
    }
}
