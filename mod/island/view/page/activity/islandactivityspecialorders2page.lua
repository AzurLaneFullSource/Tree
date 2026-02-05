local var0_0 = class("IslandActivitySpecialOrderS2Page", import(".IslandActivitySpecialOrderPage"))

function var0_0.getTabTipMapList(arg0_1)
	return {
		{
			"island_spoperation_btn_2602_2",
			"island_spoperation_tip_2602_3"
		},
		{
			"island_spoperation_btn_2602_1",
			"island_spoperation_tip_2602_2"
		},
		{
			"island_spoperation_btn_2602_3",
			"island_spoperation_tip_2602_1"
		}
	}
end

function var0_0.getItemTipPrefix(arg0_2)
	return "island_spoperation_item_2602_"
end

function var0_0.OnFirstFlush(arg0_3)
	var0_0.super.OnFirstFlush(arg0_3)
	setActive(arg0_3.rtTitle:Find("level"), false)
end

return var0_0
