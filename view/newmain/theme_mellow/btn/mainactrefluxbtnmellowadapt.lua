local var0_0 = class("MainActRefluxBtnMellowAdapt", import(".MainDifferentStyleSpActBtnAdapt"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root:Find("left/list")
end

function var0_0.OnRegister(arg0_2)
	arg0_2.redDot = RedDotNode.New(arg0_2._tf:Find("tip"), {
		pg.RedDotMgr.TYPES.ACT_RETURN
	})

	pg.redDotHelper:AddNode(arg0_2.redDot)
end

return var0_0
