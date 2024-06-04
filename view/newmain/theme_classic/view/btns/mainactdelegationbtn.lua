local var0 = class("MainActDelegationBtn", import(".MainBaseSpcailActBtn"))

function var0.GetContainer(arg0)
	return arg0.root.parent:Find("eventPanel")
end

function var0.InShowTime(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.RYZA_TASK)

	return var0 and not var0:isEnd()
end

function var0.GetUIName(arg0)
	return "MainActDelegationBtn"
end

function var0.OnClick(arg0)
	arg0.event:emit(NewMainMediator.GO_SCENE, SCENE.RYZA_TASK)
end

function var0.OnInit(arg0)
	setAnchoredPosition(arg0._tf, {
		x = 200,
		y = 220
	})
end

function var0.OnRegister(arg0)
	arg0.redDot = RedDotNode.New(arg0._tf:Find("tip"), {
		pg.RedDotMgr.TYPES.RYZA_TASK
	})

	pg.redDotHelper:AddNode(arg0.redDot)
end

function var0.OnClear(arg0)
	if arg0.redDot then
		pg.redDotHelper:RemoveNode(arg0.redDot)
	end
end

return var0
