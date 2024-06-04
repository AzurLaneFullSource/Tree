local var0 = class("GameRoomPileGameView", import("..BaseMiniGameView"))

function var0.getUIName(arg0)
	return "GameRoomPileGameUI"
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("overview/back")
end

local var1 = 7

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)

	arg0.controller = PileGameController.New()

	arg0.controller.view:SetUI(arg0._go)

	local var0 = arg0:PackData()

	arg0.controller:SetUp(var0, function(arg0, arg1)
		if arg1 < arg0 then
			arg0:StoreDataToServer({
				arg0
			})
		end

		local var0 = arg0:GetMGHubData()

		arg0:SendSuccess(arg0)
	end)
	arg0.controller:setGameStartCallback(function(arg0)
		arg0:openCoinLayer(arg0)
	end)
end

function var0.PackData(arg0)
	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = var0 and var0[1] or 0

	if arg0:getGameRoomData() then
		arg0.gameHelpTip = arg0:getGameRoomData().game_help
	end

	return {
		highestScore = var1,
		screen = Vector2(arg0._tf.rect.width, arg0._tf.rect.height),
		tip = arg0.gameHelpTip
	}
end

function var0.OnGetAwardDone(arg0, arg1)
	return
end

function var0.onBackPressed(arg0)
	if arg0.controller:onBackPressed() then
		return
	end

	arg0:emit(var0.ON_BACK)
end

function var0.willExit(arg0)
	arg0.controller:Dispose()
end

return var0
