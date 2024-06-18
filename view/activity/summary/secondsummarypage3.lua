local var0_0 = class("SecondSummaryPage3", import(".SummaryAnimationPage"))

function var0_0.OnInit(arg0_1)
	setActive(arg0_1._tf:Find("propose_panel"), arg0_1.summaryInfoVO.isProPose)
	setActive(arg0_1._tf:Find("un_panel"), not arg0_1.summaryInfoVO.isProPose)

	if arg0_1.summaryInfoVO.isProPose then
		local var0_1 = Ship.New({
			configId = arg0_1.summaryInfoVO.firstLadyId
		}):getPainting()
		local var1_1 = arg0_1._tf:Find("propose_panel")

		setPaintingPrefabAsync(var1_1:Find("paint_panel/painting"), var0_1, "chuanwu")
		setText(var1_1:Find("window_5/ship_name/Text"), arg0_1.summaryInfoVO.firstProposeName)
		setText(var1_1:Find("window_5/day/Text"), arg0_1.summaryInfoVO.proposeTime)
		setText(var1_1:Find("window_6/number/Text"), arg0_1.summaryInfoVO.proposeCount)
		setText(var1_1:Find("window_6/number_2/Text"), arg0_1.summaryInfoVO.maxIntimacyNum)
	end
end

function var0_0.Show(arg0_2, arg1_2)
	var0_0.super.Show(arg0_2, arg1_2, arg0_2._tf:Find(arg0_2.summaryInfoVO.isProPose and "propose_panel" or "un_panel"))
end

return var0_0
