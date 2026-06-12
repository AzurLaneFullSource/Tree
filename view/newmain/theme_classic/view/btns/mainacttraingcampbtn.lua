local var0_0 = class("MainActTraingCampBtn", import(".MainBaseSpcailActBtn"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root.parent:Find("link_top/layout")
end

function var0_0.InShowTime(arg0_2)
	return true
end

function var0_0.GetUIName(arg0_3)
	return "MainUIRecruitBtn"
end

function var0_0.OnClick(arg0_4)
	arg0_4.event:emit(NewMainMediator.GO_SCENE, SCENE.COMMANDER_MANUAL)
end

function var0_0.OnRegister(arg0_5)
	arg0_5.redDotUI = arg0_5._tf:Find("tip")

	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_5.redDotUI, {
		"COMMANDER_MANUAL"
	}, function(arg0_6)
		local var0_6, var1_6 = TechnologyConst.isTecActOn()

		setActive(arg0_6, getProxy(CommanderManualProxy):ShouldShowTaskOrGuideTip() or var1_6)
	end)
end

function var0_0.OnClear(arg0_7)
	if arg0_7.redDotUI then
		pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_7.redDotUI)

		arg0_7.redDotUI = nil
	end
end

return var0_0
