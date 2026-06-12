local var0_0 = class("MainActNewServerBtnMellowAdapt", import(".MainDifferentStyleSpActBtnAdapt"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root:Find("left/list")
end

function var0_0.OnRegister(arg0_2)
	arg0_2.redDotUI = arg0_2._tf:Find("tip")

	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_2.redDotUI, {
		"NEW_SERVER"
	}, function(arg0_3)
		setActive(arg0_3, NewServerCarnivalScene.isTip())
	end)
end

function var0_0.OnClear(arg0_4)
	if arg0_4.redDotUI then
		pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_4.redDotUI)

		arg0_4.redDotUI = nil
	end
end

return var0_0
