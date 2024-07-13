local var0_0 = class("MainActDelegationBtn", import(".MainBaseSpcailActBtn"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root.parent:Find("eventPanel")
end

function var0_0.InShowTime(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivityById(ActivityConst.RYZA_TASK)

	return var0_2 and not var0_2:isEnd()
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
	arg0_6.redDot = RedDotNode.New(arg0_6._tf:Find("tip"), {
		pg.RedDotMgr.TYPES.RYZA_TASK
	})

	pg.redDotHelper:AddNode(arg0_6.redDot)
end

function var0_0.OnClear(arg0_7)
	if arg0_7.redDot then
		pg.redDotHelper:RemoveNode(arg0_7.redDot)
	end
end

return var0_0
