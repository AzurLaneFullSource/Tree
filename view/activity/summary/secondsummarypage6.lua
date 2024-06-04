local var0 = class("SecondSummaryPage6", import(".SummaryAnimationPage"))

function var0.OnInit(arg0)
	local var0 = arg0.summaryInfoVO.skinId > 0

	setActive(arg0._tf:Find("skin_panel"), var0)
	setActive(arg0._tf:Find("un_panel"), not var0)

	if var0 then
		local var1 = pg.ship_skin_template[arg0.summaryInfoVO.skinId].painting
		local var2 = arg0._tf:Find("skin_panel")

		setPaintingPrefabAsync(var2:Find("paint_panel/painting"), var1, "chuanwu")
		setText(var2:Find("window_7/count/Text"), arg0.summaryInfoVO.skinNum)
		setText(var2:Find("window_7/ship/Text"), arg0.summaryInfoVO.skinShipNum)
	end
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0, arg1, arg0._tf:Find(arg0.summaryInfoVO.skinId > 0 and "skin_panel" or "un_panel"))
end

return var0
