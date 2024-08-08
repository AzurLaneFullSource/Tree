local var0_0 = class("GameRoomTowerView", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "GameRoomTowerUI"
end

function var0_0.GetMGData(arg0_2)
	local var0_2 = arg0_2.contextData.miniGameId

	return getProxy(MiniGameProxy):GetMiniGameData(var0_2):clone()
end

function var0_0.GetMGHubData(arg0_3)
	local var0_3 = arg0_3.contextData.miniGameId

	return getProxy(MiniGameProxy):GetHubByGameId(var0_3)
end

function var0_0.didEnter(arg0_4)
	arg0_4:Start()

	arg0_4.backBtn = findTF(arg0_4._tf, "overview/back")

	onButton(arg0_4, arg0_4.backBtn, function()
		arg0_4:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
end

function var0_0.Start(arg0_6)
	arg0_6.controller = TowerClimbingController.New()

	arg0_6.controller:setGameStateCallback(function()
		arg0_6:openCoinLayer(false)
	end, function()
		arg0_6:openCoinLayer(true)
	end)
	arg0_6.controller:setRoomTip(arg0_6:getGameRoomData().game_help)
	arg0_6.controller.view:SetUI(arg0_6._go)

	local function var0_6(arg0_9, arg1_9, arg2_9, arg3_9)
		local var0_9 = arg0_6:GetMGData():GetRuntimeData("elements")

		arg0_6.sendSuccessFlag = true

		arg0_6:SendSuccess(arg0_9)
	end

	local function var1_6(arg0_10, arg1_10)
		return
	end

	arg0_6.controller:SetCallBack(var0_6, var1_6)

	local var2_6 = arg0_6:PackData()

	arg0_6.controller:SetUp(var2_6)
end

function var0_0.updateHighScore(arg0_11)
	local var0_11 = arg0_11:GetMGData():GetRuntimeData("elements") or {}

	if arg0_11.controller then
		-- block empty
	end

	arg0_11.controller:updateHighScore(var0_11)
end

function var0_0.OnSendMiniGameOPDone(arg0_12, arg1_12)
	arg0_12.itemNums = getProxy(MiniGameProxy):GetHubByHubId(arg0_12.hub_id).count or 0

	setText(findTF(arg0_12._tf, "overview/item/num"), arg0_12.itemNums)
	arg0_12:updateHighScore()
end

function var0_0.getGameTimes(arg0_13)
	return arg0_13:GetMGHubData().count
end

function var0_0.GetTowerClimbingPageAndScore(arg0_14)
	local var0_14 = 0
	local var1_14 = 1
	local var2_14 = {
		0,
		0,
		0
	}

	return var0_14, var1_14, var2_14
end

function var0_0.GetAwardScores()
	local var0_15 = pg.mini_game[MiniGameDataCreator.TowerClimbingGameID].simple_config_data

	return (_.map(var0_15, function(arg0_16)
		return arg0_16[1]
	end))
end

function var0_0.PackData(arg0_17)
	local var0_17 = arg0_17._tf.rect.width
	local var1_17 = arg0_17._tf.rect.height
	local var2_17 = arg0_17:GetMGData():GetRuntimeData("elements")
	local var3_17, var4_17, var5_17 = var0_0.GetTowerClimbingPageAndScore(var2_17)

	print(var3_17, "-", var4_17)

	local var6_17 = var0_0.GetAwardScores()

	return {
		shipId = 107031,
		npcName = "TowerClimbingManjuu",
		life = 3,
		screenWidth = var0_17,
		screenHeight = var1_17,
		higestscore = var3_17,
		pageIndex = var4_17,
		mapScores = var5_17,
		awards = var6_17
	}
end

function var0_0.onBackPressed(arg0_18)
	if arg0_18.controller and arg0_18.controller:onBackPressed() then
		return
	end

	arg0_18:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_19)
	if arg0_19.controller then
		arg0_19.controller:Dispose()
	end
end

return var0_0
