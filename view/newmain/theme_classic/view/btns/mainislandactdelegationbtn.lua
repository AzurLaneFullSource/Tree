local var0_0 = class("MainIslandActDelegationBtn", import(".MainBaseSpcailActBtn"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root.parent:Find("eventPanel")
end

function var0_0.InShowTime(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

	return var0_2 and not var0_2:isEnd()
end

function var0_0.GetUIName(arg0_3)
	return "MainIslandActDelegationBtn"
end

function var0_0.OnClick(arg0_4)
	arg0_4.event:emit(NewMainMediator.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SEA, {
		checkMain = true
	})
end

function var0_0.OnInit(arg0_5)
	return
end

function var0_0.OnRegister(arg0_6)
	arg0_6.redDotUI = arg0_6._tf:Find("tip")

	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_6.redDotUI, {
		"ISLAND"
	}, function(arg0_7)
		local var0_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

		setActive(arg0_7, Activity.IsActivityReady(var0_7))
	end)
end

function var0_0.OnClear(arg0_8)
	if arg0_8.redDotUI then
		pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_8.redDotUI)

		arg0_8.redDotUI = nil
	end
end

return var0_0
