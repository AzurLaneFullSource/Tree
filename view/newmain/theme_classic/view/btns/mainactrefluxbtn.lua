local var0 = class("MainActRefluxBtn", import(".MainBaseSpcailActBtn"))

function var0.GetContainer(arg0)
	return arg0.root.parent:Find("link_top/layout")
end

function var0.InShowTime(arg0)
	return getProxy(RefluxProxy):isActive()
end

function var0.GetUIName(arg0)
	return "MainUIReturnBtn"
end

function var0.OnClick(arg0)
	arg0.event:emit(NewMainMediator.GO_SCENE, SCENE.REFLUX)
end

function var0.OnRegister(arg0)
	arg0.redDot = EffectRedDotNode.New(arg0._tf, {
		pg.RedDotMgr.TYPES.ACT_RETURN
	})

	pg.redDotHelper:AddNode(arg0.redDot)
end

function var0.OnClear(arg0)
	if arg0.redDot then
		pg.redDotHelper:RemoveNode(arg0.redDot)
	end
end

return var0
