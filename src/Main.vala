/*
 * tailor
 *
 * Copyright © 2020 Payson Wallach
 *
 * Released under the terms of the Hippocratic License
 * (https://firstdonoharm.dev/version/1/1/license.html)
 *
 * This file incorporates work covered by the following copyright and
 * permission notice:
 *
 *  The MIT License (MIT)
 *
 *  Copyright (c) 2014 Oktay Acikalin <oktay.acikalin@gmail.com>
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 *
 *  http://opensource.org/licenses/MIT
 */

private Gee.HashMap<string, string> global_alterations;
private Settings settings;

private Gee.HashMap<string, string> get_alterations () {
    string? window_class;
    string? variant;
    VariantIter iterator = settings.get_value ("alterations").iterator ();
    var alterations = new Gee.HashMap<string, string> ();

    while (iterator.next ("(sss)", out window_class, out variant)) {
        alterations[window_class] = variant;
    }

    return alterations;
}

private void set_theme (string variant, ulong window_id) {
    string[] args = {
        "xprop",
        "-id",
        window_id.to_string (),
        "-f",
        "_GTK_THEME_VARIANT",
        "8u",
        "-set",
        "_GTK_THEME_VARIANT",
        variant
    };

    try {
        var subprocess = new Subprocess.newv (
            args,
            SubprocessFlags.NONE
        );
    } catch (Error err) {
        error (err.message);
    }
}

private void update_window (Wnck.Screen screen, Wnck.Window window) {
    ulong window_id = window.get_xid ();
    string instance_name = window.get_class_instance_name ().down ();

    debug (@"found window \'$(instance_name)\' (\'$(window.get_class_group_name ())\'/\'$(window.get_name ().down ())\')");

    if (global_alterations.has_key (instance_name)) {
        string variant = global_alterations[instance_name];

        set_theme (variant, window_id);
        info (@"setting window \'$(instance_name)\' to \'$(variant)\'");
    }
}

public void on_settings_changed (string key) {
    Gee.HashMap<string, string> alterations = get_alterations ();
    var changes = new Gee.ArrayList<string> ();

    foreach (var entry in alterations.entries) {
        if (global_alterations.has_key (entry.key)) {
            if (global_alterations[entry.key] != entry.value) {
                changes.add (entry.key);
            }
        } else {
            changes.add (entry.key);
        }
    }

    global_alterations = alterations;

    Wnck.Screen? screen = Wnck.Screen.get_default ();

    foreach (var window in screen.get_windows ()) {
        string instance_name = window.get_class_instance_name ().down ();

        if (changes.contains (instance_name)) {
            update_window (screen, window);
        }
    }
}

public static int main (string[] args) {
    unowned string[] unowned_args = args;

    Gdk.init (ref unowned_args);

    MainLoop loop = new MainLoop ();
    Wnck.Screen? screen = Wnck.Screen.get_default ();

    settings = new Settings ("com.paysonwallach.tailor");
    global_alterations = get_alterations ();

    settings.changed.connect ((key) => {
        on_settings_changed (key);
    });

    if (screen != null) {
        screen.window_opened.connect ((screen, window) => {
            update_window (screen, window);
        });
        info ("listening for newly-opened windows");
    } else {
        loop.quit ();

        return 1;
    }

    loop.run ();

    return 0;
}
