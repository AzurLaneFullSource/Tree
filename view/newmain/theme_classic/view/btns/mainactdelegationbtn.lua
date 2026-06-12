local var0_0 = class("MainActDelegationBtn", import(".MainBaseSpcailActBtn"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root.parent:Find("eventPanel")
end

function var0_0.InShowTime(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivityById(ActivityConst.RYZA_TASK)
	local var1_2 = var0_2 and var0_2:getConfig("config_client").hide_main_btn or nil

	return var0_2 and not var0_2:isEnd() and var1_2 ~= 1
end

function var0_0.GetUIName(arg0_3)
	return "MainActDelegationBtn"
end

function var0_0.OnClick(arg0_4)
	arg0_4.event:emit(NewMainMediator.GO_SCENE, SCENE.RYZA_TASK)
end

function var0_0.OnInit(arg0_5)
	setAnchoredPosition(arg0_5._tf, {
		x = 200,
		y = 220
	})
end

function var0_0.OnRegister(arg0_6)
	arg0_6.redDotUI = arg0_6._tf:Find("tip")

	pg.EasyRedDotMgr.GetInstance():RegisterRedDot(arg0_6.redDotUI, {
		"RYZA_TASK"
	}, function(arg0_7)
		setActive(arg0_7, getProxy(ActivityTaskProxy):getActTaskTip(ActivityConst.RYZA_TASK))
	end)
end

function var0_0.OnClear(arg0_8)
	if arg0_8.redDotUI then
		pg.EasyRedDotMgr.GetInstance():UnRegisterRedDot(arg0_8.redDotUI)

		arg0_8.redDotUI = nil
	end
end

return var0_0
