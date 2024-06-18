local var0_0 = class("MainActRefluxBtn", import(".MainBaseSpcailActBtn"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root.parent:Find("link_top/layout")
end

function var0_0.InShowTime(arg0_2)
	return getProxy(RefluxProxy):isActive()
end

function var0_0.GetUIName(arg0_3)
	return "MainUIReturnBtn"
end

function var0_0.OnClick(arg0_4)
	arg0_4.event:emit(NewMainMediator.GO_SCENE, SCENE.REFLUX)
end

function var0_0.OnRegister(arg0_5)
	arg0_5.redDot = EffectRedDotNode.New(arg0_5._tf, {
		pg.RedDotMgr.TYPES.ACT_RETURN
	})

	pg.redDotHelper:AddNode(arg0_5.redDot)
end

function var0_0.OnClear(arg0_6)
	if arg0_6.redDot then
		pg.redDotHelper:RemoveNode(arg0_6.redDot)
	end
end

return var0_0
