/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2017 aszlig
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License, version 3, as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License
 * for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
package hase.ds;

// XXX: This class should be private, but it's currently blocked by
//      https://github.com/HaxeFoundation/haxe/issues/3589
class LinkedListNode<T> implements hase.iface.Renewable
{
    public var item:T;
    public var next:Null<LinkedListNode<T>>;

    public inline function new(item:T)
    {
        this.item = item;
        this.next = null;
    }
}

private class LinkedListIterator<T>
{
    private var ptr:LinkedListNode<T>;

    public inline function new(node)
        this.ptr = node;

    public inline function hasNext():Bool
        return this.ptr != null;

    public inline function next():T
    {
        var item:T = this.ptr.item;
        this.ptr = this.ptr.next;
        return item;
    }
}

class LinkedList<T> implements hase.iface.Pooling
{
    private var head:Null<LinkedListNode<T>>;
    private var last:Null<LinkedListNode<T>>;

    public function new()
        this.head = this.last = null;

    public function add(item:T):Void
    {
        #if macro
        var node:LinkedListNode<T> = new LinkedListNode(item);
        #else
        var node:LinkedListNode<T> = hase.utils.Pool.alloc(item);
        #end

        if (this.head == null)
            this.head = node;
        else
            this.last.next = node;
        this.last = node;
    }

    public function remove(item:T):Void
    {
        if (this.head == null)
            return;

        if (this.head.item == item) {
            if (this.head.next == null)
                this.last = this.head;
            #if !macro
            hase.utils.Pool.free(this.head);
            #end
            this.head = this.head.next;
            return;
        }

        var node:LinkedListNode<T> = this.head;

        while (node.next != null) {
            if (node.next.item == item) {
                #if !macro
                hase.utils.Pool.free(node.next);
                #end
                node.next = node.next.next;
                if (node.next == null)
                    this.last = node;
                return;
            }
            node = node.next;
        }
    }

    // Merge sort based on hase.ds.ListSort with a bit of cleanup.
    public inline function sort(cmp:T -> T -> Int):Void
    {
        if (this.head == null || this.head.next == null)
            return;

        var size:Int = 1;

        var left:LinkedListNode<T>;
        var right:LinkedListNode<T>;

        while (true) {
            var merges:Int = 0;

            left = this.head;
            this.head = this.last = null;

            while (left != null) {
                merges++;
                right = left;

                var leftsize:Int = 0;
                var rightsize:Int = size;

                for (i in 0...size) {
                    leftsize++;
                    right = right.next;
                    if (right == null)
                        break;
                }

                while (leftsize > 0 || (rightsize > 0 && right != null)) {
                    var node:LinkedListNode<T>;

                    if (leftsize == 0) {
                        node = right;
                        right = right.next;
                        rightsize--;
                    } else if (rightsize == 0 || right == null ||
                               cmp(left.item, right.item) <= 0) {
                        node = left;
                        left = left.next;
                        leftsize--;
                    } else {
                        node = right;
                        right = right.next;
                        rightsize--;
                    }
                    if (this.last != null)
                        this.last.next = node;
                    else
                        this.head = node;
                    this.last = node;
                }
                left = right;
            }
            this.last.next = null;
            if (merges <= 1)
                break;
            size <<= 1;
        }
    }

    public inline function iterator():LinkedListIterator<T>
        return new LinkedListIterator(this.head);

    public function toString():String
    {
        var buf:StringBuf = new StringBuf();
        var ptr:LinkedListNode<T> = this.head;

        buf.add("{");

        while (ptr != null) {
            buf.add(Std.string(ptr.item));
            if ((ptr = ptr.next) != null)
                buf.add(", ");
        }

        buf.add("}");

        return buf.toString();
    }
}
