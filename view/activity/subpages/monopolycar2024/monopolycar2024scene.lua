local var0_0 = class("MonopolyCar2024Scene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MonopolyCar2024UI"
end

function var0_0.init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3)
	local var0_3 = arg0_3.contextData.actId
	local var1_3 = getProxy(ActivityProxy):getActivityById(var0_3)

	arg0_3:UpdateGame(var1_3)
end

function var0_0.UpdateGame(arg0_4, arg1_4)
	arg0_4.activity = arg1_4

	if arg0_4.gameUI then
		arg0_4.gameUI:UpdateActivity(arg0_4.activity)
	else
		arg0_4.gameUI = MonopolyCar2024Game.New(arg0_4.activity, arg0_4._tf:Find("adapt"), arg0_4.event)
	end
end

function var0_0.onBackPressed(arg0_5)
	var0_0.super.onBackPressed(arg0_5)
end

function var0_0.willExit(arg0_6)
	if arg0_6.gameUI then
		arg0_6.gameUI:Dispose()

		arg0_6.gameUI = nil
	end
end

return var0_0
