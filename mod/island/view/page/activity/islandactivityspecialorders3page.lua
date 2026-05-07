local var0_0 = class("IslandActivitySpecialOrderS3Page", import(".IslandActivitySpecialOrderPage"))

function var0_0.getTabTipMapList(arg0_1)
	return {
		{
			"island_spoperation_btn_2605_2",
			"island_spoperation_tip_2605_3"
		},
		{
			"island_spoperation_btn_2605_1",
			"island_spoperation_tip_2605_2"
		},
		{
			"island_spoperation_btn_2605_3",
			"island_spoperation_tip_2605_1"
		}
	}
end

function var0_0.getItemTipPrefix(arg0_2)
	return "island_spoperation_item_2605_"
end

function var0_0.OnFirstFlush(arg0_3)
	var0_0.super.OnFirstFlush(arg0_3)
	setActive(arg0_3.rtTitle:Find("level"), false)
end

return var0_0
