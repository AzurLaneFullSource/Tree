local var0 = class("MainActTraingCampBtn", import(".MainBaseSpcailActBtn"))

function var0.GetContainer(arg0)
	return arg0.root.parent:Find("link_top/layout")
end

function var0.InShowTime(arg0)
	local var0 = TrainingCampScene.isNormalActOn()
	local var1 = TrainingCampScene.isTecActOn()

	return var0 or var1
end

function var0.GetUIName(arg0)
	return "MainUIRecruitBtn"
end

function var0.OnClick(arg0)
	arg0.event:emit(NewMainMediator.GO_SCENE, SCENE.TRAININGCAMP)
end

function var0.OnRegister(arg0)
	arg0.redDot = EffectRedDotNode.New(arg0._tf, {
		pg.RedDotMgr.TYPES.ACT_NEWBIE
	})

	pg.redDotHelper:AddNode(arg0.redDot)
end

function var0.OnClear(arg0)
	if arg0.redDot then
		pg.redDotHelper:RemoveNode(arg0.redDot)
	end
end

return var0
