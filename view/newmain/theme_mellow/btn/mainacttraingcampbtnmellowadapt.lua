local var0 = class("MainActTraingCampBtnMellowAdapt", import(".MainDifferentStyleSpActBtnAdapt"))

function var0.GetContainer(arg0)
	return arg0.root:Find("left/list")
end

function var0.OnRegister(arg0)
	arg0.redDot = RedDotNode.New(arg0._tf:Find("tip"), {
		pg.RedDotMgr.TYPES.ACT_NEWBIE
	})

	pg.redDotHelper:AddNode(arg0.redDot)
	arg0._tf:SetAsFirstSibling()
end

return var0
