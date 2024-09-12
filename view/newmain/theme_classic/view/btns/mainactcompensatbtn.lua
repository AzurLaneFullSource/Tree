local var0_0 = class("MainActCompensatBtn", import(".MainBaseSpcailActBtn"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root.parent:Find("link_top/layout")
end

function var0_0.InShowTime(arg0_2)
	return getProxy(CompensateProxy):hasRewardCount()
end

function var0_0.GetUIName(arg0_3)
	return "MainActCompensatBtn"
end

function var0_0.OnClick(arg0_4)
	arg0_4.event:emit(NewMainMediator.OPEN_Compensate)
end

function var0_0.OnRegister(arg0_5)
	return
end

function var0_0.OnClear(arg0_6)
	if arg0_6.redDot then
		pg.redDotHelper:RemoveNode(arg0_6.redDot)
	end
end

return var0_0
