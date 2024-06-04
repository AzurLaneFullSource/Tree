local var0 = class("SecondSummaryPage3", import(".SummaryAnimationPage"))

function var0.OnInit(arg0)
	setActive(arg0._tf:Find("propose_panel"), arg0.summaryInfoVO.isProPose)
	setActive(arg0._tf:Find("un_panel"), not arg0.summaryInfoVO.isProPose)

	if arg0.summaryInfoVO.isProPose then
		local var0 = Ship.New({
			configId = arg0.summaryInfoVO.firstLadyId
		}):getPainting()
		local var1 = arg0._tf:Find("propose_panel")

		setPaintingPrefabAsync(var1:Find("paint_panel/painting"), var0, "chuanwu")
		setText(var1:Find("window_5/ship_name/Text"), arg0.summaryInfoVO.firstProposeName)
		setText(var1:Find("window_5/day/Text"), arg0.summaryInfoVO.proposeTime)
		setText(var1:Find("window_6/number/Text"), arg0.summaryInfoVO.proposeCount)
		setText(var1:Find("window_6/number_2/Text"), arg0.summaryInfoVO.maxIntimacyNum)
	end
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0, arg1, arg0._tf:Find(arg0.summaryInfoVO.isProPose and "propose_panel" or "un_panel"))
end

return var0
