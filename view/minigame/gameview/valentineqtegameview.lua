local var0 = class("ValentineQteGameView", import("..BaseMiniGameView"))

function var0.getUIName(arg0)
	return "ValentineQteGamePage"
end

function var0.init(arg0)
	arg0.gameView = ValentineQteGamePage.New(arg0._tf)
end

function var0.didEnter(arg0)
	local var0 = arg0:GetMGHubData().usedtime == 0

	arg0.gameView:SetUp(function()
		if arg0:GetMGHubData().count > 0 then
			arg0:SendSuccess(0)
		end
	end, function()
		if arg0.gameView then
			arg0.gameView = nil
		end

		arg0:emit(var0.ON_BACK)
	end, var0)
end

function var0.onBackPressed(arg0)
	if arg0.gameView and arg0.gameView:onBackPressed() then
		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	if arg0.gameView then
		arg0.gameView:Destroy()

		arg0.gameView = nil
	end
end

return var0
