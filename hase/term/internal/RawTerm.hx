/* Haxe ASCII Spriting Engine
 *
 * Copyright (C) 2015-2017 aszlig
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
