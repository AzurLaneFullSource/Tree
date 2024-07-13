local var0_0 = class("ValentineQteGameView", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "ValentineQteGamePage"
end

function var0_0.init(arg0_2)
	arg0_2.gameView = ValentineQteGamePage.New(arg0_2._tf)
end

function var0_0.didEnter(arg0_3)
	local var0_3 = arg0_3:GetMGHubData().usedtime == 0

	arg0_3.gameView:SetUp(function()
		if arg0_3:GetMGHubData().count > 0 then
			arg0_3:SendSuccess(0)
		end
	end, function()
		if arg0_3.gameView then
			arg0_3.gameView = nil
		end

		arg0_3:emit(var0_0.ON_BACK)
	end, var0_3)
end

function var0_0.onBackPressed(arg0_6)
	if arg0_6.gameView and arg0_6.gameView:onBackPressed() then
		return
	end

	var0_0.super.onBackPressed(arg0_6)
end

function var0_0.willExit(arg0_7)
	if arg0_7.gameView then
		arg0_7.gameView:Destroy()

		arg0_7.gameView = nil
	end
end

return var0_0
