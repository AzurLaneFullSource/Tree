pg = pg or {}
pg.cg_display = rawget(pg, "cg_display") or setmetatable({
	__name = "cg_display"
}, confNEO)
pg.cg_display.all = {}
pg.base = pg.base or {}
pg.base.cg_display = {}
