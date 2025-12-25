local var0_0 = class("WinterFestival2025ShrineView", import(".Shrine2022View"))

var0_0.SHRINE_SELECT_SHIP_VIEW_CLS = WinterFestival2025ShrineSelectShipView
var0_0.SHRINE_SHIP_WORD_VIEW_CLS = WinterFestival2025ShrineShipWordView
var0_0.SHRINE_SELECT_BUFF_VIEW_CLS = WinterFestival2025ShrineSelectBuffView

function var0_0.getUIName(arg0_1)
	return "WinterFestival2025ShrineUI"
end

function var0_0.setUIData(arg0_2)
	local var0_2 = arg0_2._tf:Find("Res")
	local var1_2 = getImageSprite(var0_2:Find("CurBuff1"))
	local var2_2 = getImageSprite(var0_2:Find("CurBuff2"))
	local var3_2 = getImageSprite(var0_2:Find("CurBuff3"))

	arg0_2.curBuffSpriteList = {
		var1_2,
		var2_2,
		var3_2
	}
	arg0_2.shipCardSpriteList = {}

	for iter0_2 = 1, 7 do
		local var4_2 = getImageSprite(var0_2:Find("ShipCard" .. iter0_2))

		table.insert(arg0_2.shipCardSpriteList, var4_2)
	end

	arg0_2.shipNameSpriteList = {}

	for iter1_2 = 1, 7 do
		local var5_2 = getImageSprite(var0_2:Find("ShipName" .. iter1_2))

		table.insert(arg0_2.shipNameSpriteList, var5_2)
	end

	arg0_2.shipNameTextList = {
		Ship.getShipName(405011),
		Ship.getShipName(105141),
		Ship.getShipName(702051),
		Ship.getShipName(607021),
		Ship.getShipName(202121),
		Ship.getShipName(805011),
		Ship.getShipName(407011)
	}
	arg0_2.curBuffPosStart = 217
	arg0_2.curBuffPosEnd = -130

	setText(arg0_2._tf:Find("Data/Count2"), i18n("winterwish_20251225_tip1"))
	setText(arg0_2._tf:Find("Data/Count/Tip"), i18n("winterwish_20251225_tip2"))

	arg0_2.countText = arg0_2._tf:Find("Data/Count/Text")
	arg0_2.countText2 = arg0_2._tf:Find("Data/Count2/BG/Text")
end

function var0_0.updateShipCardUI(arg0_3, arg1_3, arg2_3)
	var0_0.super.updateShipCardUI(arg0_3, arg1_3, arg2_3)

	local var0_3 = arg1_3:Find("NameMask/NameText")

	setScrollText(var0_3, arg0_3.shipNameTextList[arg2_3])
end

return var0_0
