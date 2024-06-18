local var0_0 = class("WorldMapPortShop", import("...BaseEntity"))

var0_0.Fields = {
	items = "table",
	expiredTime = "number"
}

function var0_0.Setup(arg0_1)
	return
end

function var0_0.IsValid(arg0_2)
	return arg0_2.expiredTime >= pg.TimeMgr.GetInstance():GetServerTime()
end

return var0_0
