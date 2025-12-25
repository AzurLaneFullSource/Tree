local var0_0 = class("WinterFestival2025ShrineSelectShipView", import(".Shrine2022SelectShipView"))

function var0_0.getUIName(arg0_1)
	return "WinterFestival2025ShrineSelectShipUI"
end

function var0_0.setUIData(arg0_2)
	local var0_2 = arg0_2._tf:Find("Res")

	arg0_2.shipCardSpriteList = {}

	for iter0_2 = 1, 7 do
		local var1_2 = getImageSprite(var0_2:Find("ShipCard" .. iter0_2))

		table.insert(arg0_2.shipCardSpriteList, var1_2)
	end

	arg0_2.shipNameSpriteList = {}

	for iter1_2 = 1, 7 do
		local var2_2 = getImageSprite(var0_2:Find("ShipName" .. iter1_2))

		table.insert(arg0_2.shipNameSpriteList, var2_2)
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
	arg0_2.cardPosList = {
		{
			x = -75.5,
			y = 290
		},
		{
			x = -75.5,
			y = 67.5
		},
		{
			x = -75.5,
			y = -155
		},
		{
			x = -75.5,
			y = -377.5
		},
		{
			x = 82,
			y = 290
		},
		{
			x = 82,
			y = 67.5
		},
		{
			x = 82,
			y = -155
		}
	}
	arg0_2.confirmPosList = {
		{
			x = -372,
			y = 15
		},
		{
			x = -75,
			y = 15
		},
		{
			x = 226,
			y = 15
		},
		{
			x = 523,
			y = 15
		},
		{
			x = -224,
			y = -350
		},
		{
			x = 80,
			y = -350
		},
		{
			x = 380,
			y = -350
		}
	}
end

function var0_0.updateShipCardUI(arg0_3, arg1_3, arg2_3)
	setImageSprite(arg1_3, arg0_3.shipCardSpriteList[arg2_3], true)

	local var0_3 = arg1_3:Find("Name")

	setActive(var0_3, false)

	local var1_3 = arg1_3:Find("NameMask/Name_Text")

	setScrollText(var1_3, arg0_3.shipNameTextList[arg2_3])
	setLocalPosition(arg1_3, arg0_3.cardPosList[arg2_3])

	local var2_3 = arg1_3:Find("Selected")
	local var3_3 = arg0_3:isSelected(arg2_3)

	setActive(var2_3, var3_3)
	setActive(var1_3, not var3_3)

	GetComponent(arg1_3, "Toggle").enabled = not var3_3
end

return var0_0
