local var0 = class("MainActRefluxBtnMellowAdapt", import(".MainDifferentStyleSpActBtnAdapt"))

function var0.GetContainer(arg0)
	return arg0.root:Find("left/list")
end

function var0.OnRegister(arg0)
	arg0.redDot = RedDotNode.New(arg0._tf:Find("tip"), {
		pg.RedDotMgr.TYPES.ACT_RETURN
	})

	pg.redDotHelper:AddNode(arg0.redDot)
end

return var0
