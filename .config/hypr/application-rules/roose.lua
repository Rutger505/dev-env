-- Float roose-spawned documents and images immediately, before roose animates them in.
o.window({ title = "^roose-spawned-.*" }, { float = true })
-- Keep the dragged-in image windows visible across workspaces.
o.window({ class = "^imv$", title = "^roose-spawned-.*" }, { float = true, pin = true })
