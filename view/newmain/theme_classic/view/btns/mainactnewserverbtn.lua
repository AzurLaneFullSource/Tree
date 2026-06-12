local var0_0 = class("MainActNewServerBtn", import(".MainBaseSpcailActBtn"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root.parent:Find("link_top/layout")
end

function var0_0.InShowTime(arg0_2)
	return NewServerCarnivalScene.isShow()
end

function var0_0.GetUIName(arg0_3)
	return "MainUINewServerBtn"
end

function var0_0.OnClick(arg0_4)
	arg0_4.event:emit(NewMainMediator.GO_SCENE, SCENE.NEW_SERVER_CARNIVAL)
end

function var0_0.OnRegister(arg0_5)
	arg0_5.redDotUI = arg0_5._tf:Find("tip")

	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_5.redDotUI, {
		"NEW_SERVER"
	}, function(arg0_6)
		setActive(arg0_6, NewServerCarnivalScene.isTip())
	end)
end

function var0_0.OnClear(arg0_7)
	if arg0_7.redDotUI then
		pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_7.redDotUI)

		arg0_7.redDotUI = nil
	end
end

return var0_0
