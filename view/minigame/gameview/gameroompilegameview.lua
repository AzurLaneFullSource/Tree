local var0_0 = class("GameRoomPileGameView", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "GameRoomPileGameUI"
end

function var0_0.init(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("overview/back")
end

local var1_0 = 7

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_PANEL)

	arg0_3.controller = PileGameController.New()

	arg0_3.controller.view:SetUI(arg0_3._go)

	local var0_3 = arg0_3:PackData()

	arg0_3.controller:SetUp(var0_3, function(arg0_5, arg1_5)
		if arg1_5 < arg0_5 then
			arg0_3:StoreDataToServer({
				arg0_5
			})
		end

		local var0_5 = arg0_3:GetMGHubData()

		arg0_3:SendSuccess(arg0_5)
	end)
	arg0_3.controller:setGameStartCallback(function(arg0_6)
		arg0_3:openCoinLayer(arg0_6)
	end)
end

function var0_0.PackData(arg0_7)
	local var0_7 = arg0_7:GetMGData():GetRuntimeData("elements")
	local var1_7 = var0_7 and var0_7[1] or 0

	if arg0_7:getGameRoomData() then
		arg0_7.gameHelpTip = arg0_7:getGameRoomData().game_help
	end

	return {
		highestScore = var1_7,
		screen = Vector2(arg0_7._tf.rect.width, arg0_7._tf.rect.height),
		tip = arg0_7.gameHelpTip
	}
end

function var0_0.OnGetAwardDone(arg0_8, arg1_8)
	return
end

function var0_0.onBackPressed(arg0_9)
	if arg0_9.controller:onBackPressed() then
		return
	end

	arg0_9:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_10)
	arg0_10.controller:Dispose()
end

return var0_0
