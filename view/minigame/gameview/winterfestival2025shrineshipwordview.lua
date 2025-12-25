local var0_0 = class("WinterFestival2025ShrineShipWordView", import(".Shrine2022ShipWordView"))

function var0_0.getUIName(arg0_1)
	return "WinterFestival2025ShrineShipWordUI"
end

function var0_0.setUIData(arg0_2)
	local var0_2 = arg0_2._tf:Find("Res")

	arg0_2.shipWordSpriteList = {}

	local var1_2 = getImageSprite(var0_2:Find("ShipWord" .. arg0_2.curSelectShip))

	arg0_2.shipWordSpriteList[arg0_2.curSelectShip] = var1_2
end

return var0_0
