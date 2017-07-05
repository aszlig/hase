/* Copyright (C) 2015-2017 aszlig
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
package hase.term.internal;

@:headerCode("
#include <sys/ioctl.h>
#include <signal.h>
#include <unistd.h>
#include <termios.h>
")

@:cppFileCode("
struct termios old_term;

void __trigger_cleanup(int signum) {
    ::hase::term::internal::RawTerm_obj::trigger_cleanup(signum);
}
")

class RawTerm
{
    private static var sighandlers:List<Int -> Void> = new List();

    @:keep
    public static function trigger_cleanup(signal:Int):Void
        for (handler in RawTerm.sighandlers) handler(signal);

    public static function add_cleanup(f:Int -> Void):Void
    {
        if (RawTerm.sighandlers.length == 0) {
            untyped __cpp__("
                if (signal(SIGINT, SIG_IGN) != SIG_IGN)
                    signal(SIGINT, __trigger_cleanup);
                if (signal(SIGTERM, SIG_IGN) != SIG_IGN)
                    signal(SIGTERM, __trigger_cleanup);
            ");
        }

        RawTerm.sighandlers.add(f);
    }

    public static function remove_cleanups():Void
    {
        untyped __cpp__("
            signal(SIGINT, SIG_DFL);
            signal(SIGTERM, SIG_DFL);
        ");

        RawTerm.sighandlers.clear();
    }

    public static function setraw():Void
    {
        untyped __cpp__("
            struct termios term;
            tcgetattr(STDIN_FILENO, &old_term);
            term = old_term;
            cfmakeraw(&term);
            term.c_lflag |= ISIG;
            tcsetattr(STDIN_FILENO, 0, &term);
        ");
    }

    public static function unsetraw():Void
    {
        untyped __cpp__("
            tcsetattr(STDIN_FILENO, 0, &old_term);
        ");
    }

    public static function exit_now(status:Int):Void
    {
        untyped __global__._exit(status);
    }
}
