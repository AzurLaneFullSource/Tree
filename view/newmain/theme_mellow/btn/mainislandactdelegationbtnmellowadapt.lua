local var0 = class("MainIslandActDelegationBtnMellowAdapt", import(".MainCommonSpActBtnAdapt"))

function var0.GetContainer(arg0)
	return arg0.root:Find("right")
end

function var0.OnInit(arg0)
	setAnchoredPosition(arg0._tf, {
		x = 178,
		y = 185
	})
end

return var0
