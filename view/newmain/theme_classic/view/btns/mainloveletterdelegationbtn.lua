local var0_0 = class("MainLoveLetterDelegationBtn", import(".MainBaseSpcailActBtn"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root.parent:Find("eventPanel")
end

function var0_0.InShowTime(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_UP)

	return var0_2 and not var0_2:isEnd()
end

function var0_0.GetUIName(arg0_3)
	return "MainLoveLetterDelegationBtn"
end

function var0_0.OnClick(arg0_4)
	arg0_4.event:emit(NewMainMediator.GO_SCENE, SCENE.LOVE_LETTER_ACTIVITY)
end

function var0_0.OnInit(arg0_5)
	return
end

function var0_0.OnRegister(arg0_6)
	return
end

function var0_0.OnClear(arg0_7)
	return
end

return var0_0
