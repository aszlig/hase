/* Copyright (C) 2013-2017 aszlig
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package hase.test.cases;

import hase.display.Color;

class ColorTableTest extends haxe.unit.TestCase
{
    public function test_16colors():Void
    {
        this.assertEquals(0x000000, Color.get_rgb( 0));
        this.assertEquals(0xcd0000, Color.get_rgb( 1));
        this.assertEquals(0x00cd00, Color.get_rgb( 2));
        this.assertEquals(0xcdcd00, Color.get_rgb( 3));
        this.assertEquals(0x0000ee, Color.get_rgb( 4));
        this.assertEquals(0xcd00cd, Color.get_rgb( 5));
        this.assertEquals(0x00cdcd, Color.get_rgb( 6));
        this.assertEquals(0xe5e5e5, Color.get_rgb( 7));
        this.assertEquals(0x7f7f7f, Color.get_rgb( 8));
        this.assertEquals(0xff0000, Color.get_rgb( 9));
        this.assertEquals(0x00ff00, Color.get_rgb(10));
        this.assertEquals(0xffff00, Color.get_rgb(11));
        this.assertEquals(0x5c5cff, Color.get_rgb(12));
        this.assertEquals(0xff00ff, Color.get_rgb(13));
        this.assertEquals(0x00ffff, Color.get_rgb(14));
        this.assertEquals(0xffffff, Color.get_rgb(15));
    }

    public function test_6cube_colors():Void
    {
        this.assertEquals(0x000000, Color.get_rgb( 16));
        this.assertEquals(0x00005f, Color.get_rgb( 17));
        this.assertEquals(0x000087, Color.get_rgb( 18));
        this.assertEquals(0x0000af, Color.get_rgb( 19));
        this.assertEquals(0x0000d7, Color.get_rgb( 20));
        this.assertEquals(0x0000ff, Color.get_rgb( 21));
        this.assertEquals(0x005f00, Color.get_rgb( 22));
        this.assertEquals(0x005f5f, Color.get_rgb( 23));
        this.assertEquals(0x005f87, Color.get_rgb( 24));
        this.assertEquals(0x005faf, Color.get_rgb( 25));
        this.assertEquals(0x005fd7, Color.get_rgb( 26));
        this.assertEquals(0x005fff, Color.get_rgb( 27));
        this.assertEquals(0x008700, Color.get_rgb( 28));
        this.assertEquals(0x00875f, Color.get_rgb( 29));
        this.assertEquals(0x008787, Color.get_rgb( 30));
        this.assertEquals(0x0087af, Color.get_rgb( 31));
        this.assertEquals(0x0087d7, Color.get_rgb( 32));
        this.assertEquals(0x0087ff, Color.get_rgb( 33));
        this.assertEquals(0x00af00, Color.get_rgb( 34));
        this.assertEquals(0x00af5f, Color.get_rgb( 35));
        this.assertEquals(0x00af87, Color.get_rgb( 36));
        this.assertEquals(0x00afaf, Color.get_rgb( 37));
        this.assertEquals(0x00afd7, Color.get_rgb( 38));
        this.assertEquals(0x00afff, Color.get_rgb( 39));
        this.assertEquals(0x00d700, Color.get_rgb( 40));
        this.assertEquals(0x00d75f, Color.get_rgb( 41));
        this.assertEquals(0x00d787, Color.get_rgb( 42));
        this.assertEquals(0x00d7af, Color.get_rgb( 43));
        this.assertEquals(0x00d7d7, Color.get_rgb( 44));
        this.assertEquals(0x00d7ff, Color.get_rgb( 45));
        this.assertEquals(0x00ff00, Color.get_rgb( 46));
        this.assertEquals(0x00ff5f, Color.get_rgb( 47));
        this.assertEquals(0x00ff87, Color.get_rgb( 48));
        this.assertEquals(0x00ffaf, Color.get_rgb( 49));
        this.assertEquals(0x00ffd7, Color.get_rgb( 50));
        this.assertEquals(0x00ffff, Color.get_rgb( 51));
        this.assertEquals(0x5f0000, Color.get_rgb( 52));
        this.assertEquals(0x5f005f, Color.get_rgb( 53));
        this.assertEquals(0x5f0087, Color.get_rgb( 54));
        this.assertEquals(0x5f00af, Color.get_rgb( 55));
        this.assertEquals(0x5f00d7, Color.get_rgb( 56));
        this.assertEquals(0x5f00ff, Color.get_rgb( 57));
        this.assertEquals(0x5f5f00, Color.get_rgb( 58));
        this.assertEquals(0x5f5f5f, Color.get_rgb( 59));
        this.assertEquals(0x5f5f87, Color.get_rgb( 60));
        this.assertEquals(0x5f5faf, Color.get_rgb( 61));
        this.assertEquals(0x5f5fd7, Color.get_rgb( 62));
        this.assertEquals(0x5f5fff, Color.get_rgb( 63));
        this.assertEquals(0x5f8700, Color.get_rgb( 64));
        this.assertEquals(0x5f875f, Color.get_rgb( 65));
        this.assertEquals(0x5f8787, Color.get_rgb( 66));
        this.assertEquals(0x5f87af, Color.get_rgb( 67));
        this.assertEquals(0x5f87d7, Color.get_rgb( 68));
        this.assertEquals(0x5f87ff, Color.get_rgb( 69));
        this.assertEquals(0x5faf00, Color.get_rgb( 70));
        this.assertEquals(0x5faf5f, Color.get_rgb( 71));
        this.assertEquals(0x5faf87, Color.get_rgb( 72));
        this.assertEquals(0x5fafaf, Color.get_rgb( 73));
        this.assertEquals(0x5fafd7, Color.get_rgb( 74));
        this.assertEquals(0x5fafff, Color.get_rgb( 75));
        this.assertEquals(0x5fd700, Color.get_rgb( 76));
        this.assertEquals(0x5fd75f, Color.get_rgb( 77));
        this.assertEquals(0x5fd787, Color.get_rgb( 78));
        this.assertEquals(0x5fd7af, Color.get_rgb( 79));
        this.assertEquals(0x5fd7d7, Color.get_rgb( 80));
        this.assertEquals(0x5fd7ff, Color.get_rgb( 81));
        this.assertEquals(0x5fff00, Color.get_rgb( 82));
        this.assertEquals(0x5fff5f, Color.get_rgb( 83));
        this.assertEquals(0x5fff87, Color.get_rgb( 84));
        this.assertEquals(0x5fffaf, Color.get_rgb( 85));
        this.assertEquals(0x5fffd7, Color.get_rgb( 86));
        this.assertEquals(0x5fffff, Color.get_rgb( 87));
        this.assertEquals(0x870000, Color.get_rgb( 88));
        this.assertEquals(0x87005f, Color.get_rgb( 89));
        this.assertEquals(0x870087, Color.get_rgb( 90));
        this.assertEquals(0x8700af, Color.get_rgb( 91));
        this.assertEquals(0x8700d7, Color.get_rgb( 92));
        this.assertEquals(0x8700ff, Color.get_rgb( 93));
        this.assertEquals(0x875f00, Color.get_rgb( 94));
        this.assertEquals(0x875f5f, Color.get_rgb( 95));
        this.assertEquals(0x875f87, Color.get_rgb( 96));
        this.assertEquals(0x875faf, Color.get_rgb( 97));
        this.assertEquals(0x875fd7, Color.get_rgb( 98));
        this.assertEquals(0x875fff, Color.get_rgb( 99));
        this.assertEquals(0x878700, Color.get_rgb(100));
        this.assertEquals(0x87875f, Color.get_rgb(101));
        this.assertEquals(0x878787, Color.get_rgb(102));
        this.assertEquals(0x8787af, Color.get_rgb(103));
        this.assertEquals(0x8787d7, Color.get_rgb(104));
        this.assertEquals(0x8787ff, Color.get_rgb(105));
        this.assertEquals(0x87af00, Color.get_rgb(106));
        this.assertEquals(0x87af5f, Color.get_rgb(107));
        this.assertEquals(0x87af87, Color.get_rgb(108));
        this.assertEquals(0x87afaf, Color.get_rgb(109));
        this.assertEquals(0x87afd7, Color.get_rgb(110));
        this.assertEquals(0x87afff, Color.get_rgb(111));
        this.assertEquals(0x87d700, Color.get_rgb(112));
        this.assertEquals(0x87d75f, Color.get_rgb(113));
        this.assertEquals(0x87d787, Color.get_rgb(114));
        this.assertEquals(0x87d7af, Color.get_rgb(115));
        this.assertEquals(0x87d7d7, Color.get_rgb(116));
        this.assertEquals(0x87d7ff, Color.get_rgb(117));
        this.assertEquals(0x87ff00, Color.get_rgb(118));
        this.assertEquals(0x87ff5f, Color.get_rgb(119));
        this.assertEquals(0x87ff87, Color.get_rgb(120));
        this.assertEquals(0x87ffaf, Color.get_rgb(121));
        this.assertEquals(0x87ffd7, Color.get_rgb(122));
        this.assertEquals(0x87ffff, Color.get_rgb(123));
        this.assertEquals(0xaf0000, Color.get_rgb(124));
        this.assertEquals(0xaf005f, Color.get_rgb(125));
        this.assertEquals(0xaf0087, Color.get_rgb(126));
        this.assertEquals(0xaf00af, Color.get_rgb(127));
        this.assertEquals(0xaf00d7, Color.get_rgb(128));
        this.assertEquals(0xaf00ff, Color.get_rgb(129));
        this.assertEquals(0xaf5f00, Color.get_rgb(130));
        this.assertEquals(0xaf5f5f, Color.get_rgb(131));
        this.assertEquals(0xaf5f87, Color.get_rgb(132));
        this.assertEquals(0xaf5faf, Color.get_rgb(133));
        this.assertEquals(0xaf5fd7, Color.get_rgb(134));
        this.assertEquals(0xaf5fff, Color.get_rgb(135));
        this.assertEquals(0xaf8700, Color.get_rgb(136));
        this.assertEquals(0xaf875f, Color.get_rgb(137));
        this.assertEquals(0xaf8787, Color.get_rgb(138));
        this.assertEquals(0xaf87af, Color.get_rgb(139));
        this.assertEquals(0xaf87d7, Color.get_rgb(140));
        this.assertEquals(0xaf87ff, Color.get_rgb(141));
        this.assertEquals(0xafaf00, Color.get_rgb(142));
        this.assertEquals(0xafaf5f, Color.get_rgb(143));
        this.assertEquals(0xafaf87, Color.get_rgb(144));
        this.assertEquals(0xafafaf, Color.get_rgb(145));
        this.assertEquals(0xafafd7, Color.get_rgb(146));
        this.assertEquals(0xafafff, Color.get_rgb(147));
        this.assertEquals(0xafd700, Color.get_rgb(148));
        this.assertEquals(0xafd75f, Color.get_rgb(149));
        this.assertEquals(0xafd787, Color.get_rgb(150));
        this.assertEquals(0xafd7af, Color.get_rgb(151));
        this.assertEquals(0xafd7d7, Color.get_rgb(152));
        this.assertEquals(0xafd7ff, Color.get_rgb(153));
        this.assertEquals(0xafff00, Color.get_rgb(154));
        this.assertEquals(0xafff5f, Color.get_rgb(155));
        this.assertEquals(0xafff87, Color.get_rgb(156));
        this.assertEquals(0xafffaf, Color.get_rgb(157));
        this.assertEquals(0xafffd7, Color.get_rgb(158));
        this.assertEquals(0xafffff, Color.get_rgb(159));
        this.assertEquals(0xd70000, Color.get_rgb(160));
        this.assertEquals(0xd7005f, Color.get_rgb(161));
        this.assertEquals(0xd70087, Color.get_rgb(162));
        this.assertEquals(0xd700af, Color.get_rgb(163));
        this.assertEquals(0xd700d7, Color.get_rgb(164));
        this.assertEquals(0xd700ff, Color.get_rgb(165));
        this.assertEquals(0xd75f00, Color.get_rgb(166));
        this.assertEquals(0xd75f5f, Color.get_rgb(167));
        this.assertEquals(0xd75f87, Color.get_rgb(168));
        this.assertEquals(0xd75faf, Color.get_rgb(169));
        this.assertEquals(0xd75fd7, Color.get_rgb(170));
        this.assertEquals(0xd75fff, Color.get_rgb(171));
        this.assertEquals(0xd78700, Color.get_rgb(172));
        this.assertEquals(0xd7875f, Color.get_rgb(173));
        this.assertEquals(0xd78787, Color.get_rgb(174));
        this.assertEquals(0xd787af, Color.get_rgb(175));
        this.assertEquals(0xd787d7, Color.get_rgb(176));
        this.assertEquals(0xd787ff, Color.get_rgb(177));
        this.assertEquals(0xd7af00, Color.get_rgb(178));
        this.assertEquals(0xd7af5f, Color.get_rgb(179));
        this.assertEquals(0xd7af87, Color.get_rgb(180));
        this.assertEquals(0xd7afaf, Color.get_rgb(181));
        this.assertEquals(0xd7afd7, Color.get_rgb(182));
        this.assertEquals(0xd7afff, Color.get_rgb(183));
        this.assertEquals(0xd7d700, Color.get_rgb(184));
        this.assertEquals(0xd7d75f, Color.get_rgb(185));
        this.assertEquals(0xd7d787, Color.get_rgb(186));
        this.assertEquals(0xd7d7af, Color.get_rgb(187));
        this.assertEquals(0xd7d7d7, Color.get_rgb(188));
        this.assertEquals(0xd7d7ff, Color.get_rgb(189));
        this.assertEquals(0xd7ff00, Color.get_rgb(190));
        this.assertEquals(0xd7ff5f, Color.get_rgb(191));
        this.assertEquals(0xd7ff87, Color.get_rgb(192));
        this.assertEquals(0xd7ffaf, Color.get_rgb(193));
        this.assertEquals(0xd7ffd7, Color.get_rgb(194));
        this.assertEquals(0xd7ffff, Color.get_rgb(195));
        this.assertEquals(0xff0000, Color.get_rgb(196));
        this.assertEquals(0xff005f, Color.get_rgb(197));
        this.assertEquals(0xff0087, Color.get_rgb(198));
        this.assertEquals(0xff00af, Color.get_rgb(199));
        this.assertEquals(0xff00d7, Color.get_rgb(200));
        this.assertEquals(0xff00ff, Color.get_rgb(201));
        this.assertEquals(0xff5f00, Color.get_rgb(202));
        this.assertEquals(0xff5f5f, Color.get_rgb(203));
        this.assertEquals(0xff5f87, Color.get_rgb(204));
        this.assertEquals(0xff5faf, Color.get_rgb(205));
        this.assertEquals(0xff5fd7, Color.get_rgb(206));
        this.assertEquals(0xff5fff, Color.get_rgb(207));
        this.assertEquals(0xff8700, Color.get_rgb(208));
        this.assertEquals(0xff875f, Color.get_rgb(209));
        this.assertEquals(0xff8787, Color.get_rgb(210));
        this.assertEquals(0xff87af, Color.get_rgb(211));
        this.assertEquals(0xff87d7, Color.get_rgb(212));
        this.assertEquals(0xff87ff, Color.get_rgb(213));
        this.assertEquals(0xffaf00, Color.get_rgb(214));
        this.assertEquals(0xffaf5f, Color.get_rgb(215));
        this.assertEquals(0xffaf87, Color.get_rgb(216));
        this.assertEquals(0xffafaf, Color.get_rgb(217));
        this.assertEquals(0xffafd7, Color.get_rgb(218));
        this.assertEquals(0xffafff, Color.get_rgb(219));
        this.assertEquals(0xffd700, Color.get_rgb(220));
        this.assertEquals(0xffd75f, Color.get_rgb(221));
        this.assertEquals(0xffd787, Color.get_rgb(222));
        this.assertEquals(0xffd7af, Color.get_rgb(223));
        this.assertEquals(0xffd7d7, Color.get_rgb(224));
        this.assertEquals(0xffd7ff, Color.get_rgb(225));
        this.assertEquals(0xffff00, Color.get_rgb(226));
        this.assertEquals(0xffff5f, Color.get_rgb(227));
        this.assertEquals(0xffff87, Color.get_rgb(228));
        this.assertEquals(0xffffaf, Color.get_rgb(229));
        this.assertEquals(0xffffd7, Color.get_rgb(230));
        this.assertEquals(0xffffff, Color.get_rgb(231));
    }

    public function test_grayscale():Void
    {
        this.assertEquals(0x080808, Color.get_rgb(232));
        this.assertEquals(0x121212, Color.get_rgb(233));
        this.assertEquals(0x1c1c1c, Color.get_rgb(234));
        this.assertEquals(0x262626, Color.get_rgb(235));
        this.assertEquals(0x303030, Color.get_rgb(236));
        this.assertEquals(0x3a3a3a, Color.get_rgb(237));
        this.assertEquals(0x444444, Color.get_rgb(238));
        this.assertEquals(0x4e4e4e, Color.get_rgb(239));
        this.assertEquals(0x585858, Color.get_rgb(240));
        this.assertEquals(0x626262, Color.get_rgb(241));
        this.assertEquals(0x6c6c6c, Color.get_rgb(242));
        this.assertEquals(0x767676, Color.get_rgb(243));
        this.assertEquals(0x808080, Color.get_rgb(244));
        this.assertEquals(0x8a8a8a, Color.get_rgb(245));
        this.assertEquals(0x949494, Color.get_rgb(246));
        this.assertEquals(0x9e9e9e, Color.get_rgb(247));
        this.assertEquals(0xa8a8a8, Color.get_rgb(248));
        this.assertEquals(0xb2b2b2, Color.get_rgb(249));
        this.assertEquals(0xbcbcbc, Color.get_rgb(250));
        this.assertEquals(0xc6c6c6, Color.get_rgb(251));
        this.assertEquals(0xd0d0d0, Color.get_rgb(252));
        this.assertEquals(0xdadada, Color.get_rgb(253));
        this.assertEquals(0xe4e4e4, Color.get_rgb(254));
        this.assertEquals(0xeeeeee, Color.get_rgb(255));
    }
}
