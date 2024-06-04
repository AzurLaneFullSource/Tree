local var0 = class("WorldMapPortShop", import("...BaseEntity"))

var0.Fields = {
	items = "table",
	expiredTime = "number"
}

function var0.Setup(arg0)
	return
end

function var0.IsValid(arg0)
	return arg0.expiredTime >= pg.TimeMgr.GetInstance():GetServerTime()
end

return var0
