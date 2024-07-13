local var0_0 = class("SecondSummaryPage6", import(".SummaryAnimationPage"))

function var0_0.OnInit(arg0_1)
	local var0_1 = arg0_1.summaryInfoVO.skinId > 0

	setActive(arg0_1._tf:Find("skin_panel"), var0_1)
	setActive(arg0_1._tf:Find("un_panel"), not var0_1)

	if var0_1 then
		local var1_1 = pg.ship_skin_template[arg0_1.summaryInfoVO.skinId].painting
		local var2_1 = arg0_1._tf:Find("skin_panel")

		setPaintingPrefabAsync(var2_1:Find("paint_panel/painting"), var1_1, "chuanwu")
		setText(var2_1:Find("window_7/count/Text"), arg0_1.summaryInfoVO.skinNum)
		setText(var2_1:Find("window_7/ship/Text"), arg0_1.summaryInfoVO.skinShipNum)
	end
end

function var0_0.Show(arg0_2, arg1_2)
	var0_0.super.Show(arg0_2, arg1_2, arg0_2._tf:Find(arg0_2.summaryInfoVO.skinId > 0 and "skin_panel" or "un_panel"))
end

return var0_0
