-- Omarchy tags Evince as a floating-window; drop the tag so it tiles.
o.window({ class = "^org\\.gnome\\.Evince$" }, { tag = "-floating-window" })
