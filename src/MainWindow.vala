/*
* Copyright (c) 2017 Lains
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/
using Granite.Widgets;

namespace Notejot {
    public class MainWindow : Gtk.Window {
        private Gtk.ScrolledWindow scroll;
        public Widgets.Toolbar toolbar;
        public Widgets.SourceView view;

        public MainWindow (Gtk.Application application) {
            Object (application: application,
                    resizable: false,
                    title: _("Notejot"),
                    height_request: 500,
                    width_request: 500);
        }

        construct {
            var provider = new Gtk.CssProvider ();
            provider.load_from_resource ("/com/github/lainsce/notejot/stylesheet.css");
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            this.get_style_context ().add_class ("rounded");
            var context = this.get_style_context ();
            context.add_class ("notejot-window");
            this.window_position = Gtk.WindowPosition.CENTER;

            this.toolbar = new Widgets.Toolbar ();
            this.set_titlebar (toolbar);

            scroll = new Gtk.ScrolledWindow (null, null);
            this.add (scroll);
            this.view = new Widgets.SourceView ();
            scroll.add (view);

            var settings = AppSettings.get_default ();
            int x = settings.window_x;
            int y = settings.window_y;

            if (x != -1 && y != -1) {
                move (x, y);
            }

            Utils.FileUtils.load_tmp_file ();
        }

        public override bool delete_event (Gdk.EventAny event) {
            var settings = AppSettings.get_default ();
            
            int x, y;
            get_position (out x, out y);
            settings.window_x = x;
            settings.window_y = y;
            return false;
        }
    }
}
