#!/usr/bin/env python3
import sys
import os
import gi

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GLib, Gdk

# Set program name so Hyprland window rules match without deprecation warnings
GLib.set_prgname("hold_power.py")

class HoldActionWindow(Gtk.Window):
    def __init__(self, action):
        super().__init__(title="Confirm Action")
        self.action = action
        self.hold_duration = 1.5  # Seconds required to hold
        self.elapsed = 0.0
        self.interval_ms = 20
        self.timer_id = None

        self.set_default_size(320, 180)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_resizable(False)
        self.set_border_width(16)

        if action in ("reboot", "restart"):
            self.icon_symbol = "\uF021"
            self.title_text = "Hold to Reboot"
            self.accent_color = "#89b4fa"
        else:
            self.icon_symbol = "\uF011"
            self.title_text = "Hold to Power Off"
            self.accent_color = "#f38ba8"

        self.apply_css()

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        self.add(box)

        # Header Container
        header_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        header_box.set_halign(Gtk.Align.CENTER)

        icon_lbl = Gtk.Label(label=self.icon_symbol)
        icon_lbl.get_style_context().add_class("action-icon")

        title_lbl = Gtk.Label(label=self.title_text)
        title_lbl.get_style_context().add_class("action-title")

        header_box.pack_start(icon_lbl, False, False, 0)
        header_box.pack_start(title_lbl, False, False, 0)
        box.pack_start(header_box, False, False, 0)

        # Progress Bar
        self.pbar = Gtk.ProgressBar()
        self.pbar.set_fraction(0.0)
        box.pack_start(self.pbar, False, False, 0)

        # Action Button
        self.hold_btn = Gtk.Button(label="PRESS & HOLD")
        
        # GTK Button signals
        self.hold_btn.connect("pressed", self.on_press)
        self.hold_btn.connect("released", self.on_release)
        
        box.pack_start(self.hold_btn, True, True, 0)

        self.connect("key-press-event", self.on_key_press)
        self.connect("destroy", Gtk.main_quit)

    def apply_css(self):
        css_provider = Gtk.CssProvider()
        css = f"""
        window {{
            background-color: rgba(30, 30, 46, 0.92);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 16px;
        }}
        .action-icon {{
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            font-size: 22px;
            color: {self.accent_color};
        }}
        .action-title {{
            font-size: 15px;
            font-weight: bold;
            color: #cdd6f4;
        }}
        progressbar progress {{
            background-color: {self.accent_color};
            border-radius: 4px;
        }}
        progressbar trough {{
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
            min-height: 8px;
        }}
        button {{
            background: rgba(255, 255, 255, 0.08);
            color: #cdd6f4;
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 10px;
            font-size: 13px;
            font-weight: bold;
            padding: 10px;
        }}
        button:hover {{
            background: rgba(255, 255, 255, 0.18);
        }}
        button:active {{
            background: rgba(255, 255, 255, 0.25);
        }}
        """.encode('utf-8')

        css_provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

    def on_press(self, widget):
        self.elapsed = 0.0
        if self.timer_id is None:
            self.timer_id = GLib.timeout_add(self.interval_ms, self.on_tick)

    def on_release(self, widget):
        if self.timer_id is not None:
            GLib.source_remove(self.timer_id)
            self.timer_id = None
        self.elapsed = 0.0
        self.pbar.set_fraction(0.0)

    def on_tick(self):
        self.elapsed += self.interval_ms / 1000.0
        fraction = min(1.0, self.elapsed / self.hold_duration)
        self.pbar.set_fraction(fraction)

        if fraction >= 1.0:
            self.timer_id = None
            self.execute_system_action()
            return False
        return True

    def execute_system_action(self):
        if self.action in ("reboot", "restart"):
            os.system("systemctl reboot")
        else:
            os.system("systemctl poweroff")
        Gtk.main_quit()

    def on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            Gtk.main_quit()

if __name__ == "__main__":
    action_type = sys.argv[1] if len(sys.argv) > 1 else "power"
    win = HoldActionWindow(action_type)
    win.show_all()
    Gtk.main()
