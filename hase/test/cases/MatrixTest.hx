/* Copyright (C) 2013 aszlig
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

import hase.geom.Matrix;

class MatrixTest extends haxe.unit.TestCase
{
    private inline function assert_matrix<T>( m:Matrix<T>
                                            , a:Array<Array<T>>):Void
    {
        this.assertEquals(a.toString(), m.to_2d_array().toString());
    }

    public function test_3x3_simple():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [1, 2, 3]
            , [4, 5, 6]
            , [7, 8, 9]
            ], 0
        );

        this.assert_matrix(matrix,
            [ [1, 2, 3]
            , [4, 5, 6]
            , [7, 8, 9]
            ]
        );
    }

    public function test_irregular_rows():Void
    {
        var matrix:Matrix<Null<Int>> = Matrix.from_2d_array(
            [ [1]
            , [2, 3, 4, 5, 6]
            , [7, 8, 9]
            ], null
        );

        this.assert_matrix(matrix,
            [ [   1, null, null, null, null]
            , [   2,    3,    4,    5,    6]
            , [   7,    8,    9, null, null]
            ]
        );
    }

    public function test_3x3_add_row():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [1, 2, 3]
            , [4, 5, 6]
            , [7, 8, 9]
            ], 0
        );

        matrix.add_row([10, 11, 12]);

        this.assert_matrix(matrix,
            [ [ 1,  2,  3]
            , [ 4,  5,  6]
            , [ 7,  8,  9]
            , [10, 11, 12]
            ]
        );
    }

    public function test_3x3_add_row_grow():Void
    {
        var matrix:Matrix<Null<Int>> = Matrix.from_2d_array(
            [ [1, 2, 3]
            , [4, 5, 6]
            , [7, 8, 9]
            ], null
        );

        matrix.add_row([10, 11, 12, 13, 14, 15]);

        this.assert_matrix(matrix,
            [ [   1,    2,    3, null, null, null]
            , [   4,    5,    6, null, null, null]
            , [   7,    8,    9, null, null, null]
            , [  10,   11,   12,   13,   14,   15]
            ]
        );
    }

    public function test_3x3_add_smaller_row():Void
    {
        var matrix:Matrix<Null<Int>> = Matrix.from_2d_array(
            [ [1, 2, 3]
            , [4, 5, 6]
            , [7, 8, 9]
            ], null
        );

        matrix.add_row([10, 11]);

        this.assert_matrix(matrix,
            [ [   1,    2,    3]
            , [   4,    5,    6]
            , [   7,    8,    9]
            , [  10,   11, null]
            ]
        );
    }

    public function test_2x2_grow_to_4x4_width_first():Void
    {
        var matrix:Matrix<Null<Int>> = Matrix.from_2d_array(
            [ [1, 2]
            , [3, 4]
            ], null
        );

        matrix.width = 4;
        matrix.height = 4;

        this.assert_matrix(matrix,
            [ [   1,    2, null, null]
            , [   3,    4, null, null]
            , [null, null, null, null]
            , [null, null, null, null]
            ]
        );
    }

    public function test_2x2_grow_to_4x4_height_first():Void
    {
        var matrix:Matrix<Null<Int>> = Matrix.from_2d_array(
            [ [1, 2]
            , [3, 4]
            ], null
        );

        matrix.height = 4;
        matrix.width = 4;

        this.assert_matrix(matrix,
            [ [   1,    2, null, null]
            , [   3,    4, null, null]
            , [null, null, null, null]
            , [null, null, null, null]
            ]
        );
    }

    public function test_4x4_shrink_to_2x2_width_first():Void
    {
        var matrix:Matrix<Null<Int>> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], null
        );

        matrix.width = 2;
        matrix.height = 2;

        this.assert_matrix(matrix,
            [ [1, 2]
            , [5, 6]
            ]
        );
    }

    public function test_4x4_shrink_to_2x2_height_first():Void
    {
        var matrix:Matrix<Null<Int>> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], null
        );

        matrix.height = 2;
        matrix.width = 2;

        this.assert_matrix(matrix,
            [ [1, 2]
            , [5, 6]
            ]
        );
    }

    public function test_3x3_map():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [1, 2, 3]
            , [4, 5, 6]
            , [7, 8, 9]
            ], 0
        );

        var new_matrix:Matrix<Int> =
            matrix.map(function(x:Int, y:Int, val:Int) return val + 1, 0);

        this.assert_matrix(new_matrix,
            [ [ 2,  3,  4]
            , [ 5,  6,  7]
            , [ 8,  9, 10]
            ]
        );
    }

    public function test_get_cross():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        this.assertEquals( 1, matrix.get(0, 0));
        this.assertEquals( 6, matrix.get(1, 1));
        this.assertEquals(11, matrix.get(2, 2));
        this.assertEquals(16, matrix.get(3, 3));

        this.assertEquals( 4, matrix.get(3, 0));
        this.assertEquals( 7, matrix.get(2, 1));
        this.assertEquals(10, matrix.get(1, 2));
        this.assertEquals(13, matrix.get(0, 3));
    }

    public function test_manipulate_cross():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        for (i in 0...4) {
            matrix.set(i, i, 42);
            matrix.set(i, 3 - i, 42);
        }

        this.assert_matrix(matrix,
            [ [42,  2,  3, 42]
            , [ 5, 42, 42,  8]
            , [ 9, 42, 42, 12]
            , [42, 14, 15, 42]
            ]
        );
    }

    public function test_delete_first_col():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        matrix.delete_col(0);

        this.assert_matrix(matrix,
            [ [ 2,  3,  4]
            , [ 6,  7,  8]
            , [10, 11, 12]
            , [14, 15, 16]
            ]
        );
    }

    public function test_delete_last_col():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        matrix.delete_col(-1);

        this.assert_matrix(matrix,
            [ [ 1,  2,  3]
            , [ 5,  6,  7]
            , [ 9, 10, 11]
            , [13, 14, 15]
            ]
        );
    }

    public function test_delete_to_end_exceed_col():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        matrix.delete_col(2, 3);

        this.assert_matrix(matrix,
            [ [ 1,  2]
            , [ 5,  6]
            , [ 9, 10]
            , [13, 14]
            ]
        );
    }

    public function test_delete_to_negative_end_col():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        matrix.delete_col(2, -1);

        this.assert_matrix(matrix,
            [ [ 1,  2]
            , [ 5,  6]
            , [ 9, 10]
            , [13, 14]
            ]
        );
    }

    public function test_delete_two_col():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        matrix.delete_col(1, 2);

        this.assert_matrix(matrix,
            [ [ 1,  4]
            , [ 5,  8]
            , [ 9, 12]
            , [13, 16]
            ]
        );
    }

    public function test_delete_nonexistant_cols():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        matrix.delete_col(4, 2);

        this.assert_matrix(matrix,
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ]
        );
    }

    public function test_delete_no_col():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        matrix.delete_col(2, 0);

        this.assert_matrix(matrix,
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ]
        );
    }

    public function test_extract_inner():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        var new_matrix:Matrix<Int> = matrix.extract(1, 1, 2, 2);

        this.assert_matrix(new_matrix,
            [ [ 6,  7]
            , [10, 11]
            ]
        );
    }

    public function test_extract_full():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        var new_matrix:Matrix<Int> = matrix.extract();

        this.assert_matrix(new_matrix,
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ]
        );
    }

    public function test_extract_to_out_of_bounds():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        var new_matrix:Matrix<Int> = matrix.extract(2, 2, 6, 6);

        this.assert_matrix(new_matrix,
            [ [11, 12]
            , [15, 16]
            ]
        );
    }

    public function test_extract_one_row():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        var new_matrix:Matrix<Int> = matrix.extract(0, 2, -1, 1);

        this.assert_matrix(new_matrix,
            [ [ 9, 10, 11, 12]
            ]
        );
    }

    public function test_extract_one_col():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        var new_matrix:Matrix<Int> = matrix.extract(2, 0, 1);

        this.assert_matrix(new_matrix,
            [ [ 3]
            , [ 7]
            , [11]
            , [15]
            ]
        );
    }

    public function test_extract_inner_negative():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        var new_matrix:Matrix<Int> = matrix.extract(-3, -3, 2, 2);

        this.assert_matrix(new_matrix,
            [ [ 6,  7]
            , [10, 11]
            ]
        );
    }

    public function test_extract_rect():Void
    {
        var matrix:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        var rect:hase.geom.Rect = new hase.geom.Rect(1, 1, 2, 2);
        var new_matrix:Matrix<Int> = matrix.extract_rect(rect);

        this.assert_matrix(new_matrix,
            [ [ 6,  7]
            , [10, 11]
            ]
        );
    }

    public function test_zip_multiply():Void
    {
        var matrix1:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        var matrix2:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        var new_matrix:Matrix<Int> =
            matrix1.zip(matrix2, function(m1:Int, m2:Int) return m1 * m2, 0);

        this.assert_matrix(new_matrix,
            [ [  1,   4,   9,  16]
            , [ 25,  36,  49,  64]
            , [ 81, 100, 121, 144]
            , [169, 196, 225, 256]
            ]
        );
    }

    public function test_zip_different_return_type():Void
    {
        var matrix1:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        var matrix2:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        var new_matrix:Matrix<String> =
            matrix1.zip(matrix2, function(m1:Int, m2:Int)
                                 return Std.string(m1) + Std.string(m2), "");

        this.assert_matrix(new_matrix,
            [ [  "11",   "22",   "33",   "44"]
            , [  "55",   "66",   "77",   "88"]
            , [  "99", "1010", "1111", "1212"]
            , ["1313", "1414", "1515", "1616"]
            ]
        );
    }

    public function test_zip_all_different_types():Void
    {
        var matrix1:Matrix<String> = Matrix.from_2d_array(
            [ ["a", "b", "c", "d"]
            , ["e", "f", "g", "h"]
            , ["i", "J", "K", "L"]
            , ["M", "N", "O", "P"]
            ], ""
        );

        var matrix2:Matrix<Int> = Matrix.from_2d_array(
            [ [ 1,  2,  3,  4]
            , [ 5,  6,  7,  8]
            , [ 9, 10, 11, 12]
            , [13, 14, 15, 16]
            ], 0
        );

        var new_matrix:Matrix<Bool> =
            matrix1.zip(matrix2, function(m1:String, m2:Int) {
                return ((m1.toUpperCase() == m1 ? 2 : 1) + m2) % 2 == 0;
            }, false);

        this.assert_matrix(new_matrix,
            [ [ true, false,  true, false]
            , [ true, false,  true, false]
            , [ true,  true, false,  true]
            , [false,  true, false,  true]
            ]
        );
    }

    public function test_create_simple():Void
    {
        var matrix:Matrix<Int> = Matrix.create(4, 4, 666, 0);
        this.assert_matrix(matrix,
            [ [666, 666, 666, 666]
            , [666, 666, 666, 666]
            , [666, 666, 666, 666]
            , [666, 666, 666, 666]
            ]
        );
    }
}
