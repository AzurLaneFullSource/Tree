local var0_0 = class("MainVoteEntranceBtnMellowAdapt", import(".MainCommonSpActBtnAdapt"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root:Find("right")
end

function var0_0.OnInit(arg0_2)
	setAnchoredPosition(arg0_2._tf, {
		x = 208,
		y = 209
	})
end

return var0_0
