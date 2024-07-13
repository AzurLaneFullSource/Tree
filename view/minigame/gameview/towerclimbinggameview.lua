local var0_0 = class("TowerClimbingGameView", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "TowerClimbingUI"
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
	onButton(arg0_4, arg0_4:findTF("overview/back"), function()
		arg0_4:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4:findTF("overview/collection"), function()
		arg0_4:emit(TowerClimbingMediator.ON_COLLECTION)
	end, SFX_PANEL)

	if LOCK_TOWERCLIMBING_AWARD then
		setActive(arg0_4:findTF("overview/collection"), false)
	end
end

function var0_0.UpdateTip(arg0_7)
	local var0_7 = arg0_7:GetMGData()
	local var1_7 = TowerClimbingCollectionLayer.New()

	var1_7:SetData(var0_7)

	local var2_7 = _.any({
		1,
		2,
		3
	}, function(arg0_8)
		return var1_7:GetAwardState(arg0_8) == 1
	end)

	setActive(arg0_7:findTF("overview/collection/tip"), var2_7)
end

function var0_0.Start(arg0_9)
	arg0_9.controller = TowerClimbingController.New()

	arg0_9.controller.view:SetUI(arg0_9._go)

	local function var0_9(arg0_10, arg1_10, arg2_10)
		arg0_9:emit(TowerClimbingMediator.ON_FINISH, arg0_10, arg2_10, arg1_10)
	end

	local function var1_9(arg0_11, arg1_11)
		print("record map score:", arg0_11, arg1_11)
		arg0_9:emit(TowerClimbingMediator.ON_RECORD_MAP_SCORE, arg0_11, arg1_11)
	end

	arg0_9.controller:SetCallBack(var0_9, var1_9)

	local var2_9 = arg0_9:PackData()

	arg0_9.controller:SetUp(var2_9)
	arg0_9:UpdateTip()
end

function var0_0.OnSendMiniGameOPDone(arg0_12, arg1_12)
	if arg1_12.hubid == 9 and arg1_12.cmd == MiniGameOPCommand.CMD_SPECIAL_GAME and arg1_12.argList[1] == MiniGameDataCreator.TowerClimbingGameID and arg1_12.argList[2] == 1 then
		arg0_12:Start()
	elseif arg1_12.hubid == 9 and arg1_12.cmd == MiniGameOPCommand.CMD_COMPLETE or arg1_12.hubid == 9 and arg1_12.cmd == MiniGameOPCommand.CMD_SPECIAL_GAME and (arg1_12.argList[2] == 3 or arg1_12.argList[2] == 4) then
		local var0_12 = arg0_12:PackData()

		arg0_12.controller:NetUpdateData(var0_12)
		arg0_12:UpdateTip()
	end
end

function var0_0.GetTowerClimbingPageAndScore(arg0_13)
	local var0_13 = arg0_13[1] or {}
	local var1_13 = 3

	for iter0_13 = #var0_13 + 1, var1_13 do
		table.insert(var0_13, {
			value = 0,
			value2 = 0,
			key = iter0_13
		})
	end

	table.sort(var0_13, function(arg0_14, arg1_14)
		return arg0_14.key < arg1_14.key
	end)

	local var2_13 = var0_0.GetAwardScores()
	local var3_13 = 0
	local var4_13 = 1

	for iter1_13, iter2_13 in ipairs(var0_13) do
		local var5_13 = var2_13[iter2_13.key]
		local var6_13 = var5_13[#var5_13]

		if var6_13 > iter2_13.value2 or iter1_13 == #var0_13 and var6_13 <= iter2_13.value2 then
			var3_13 = iter2_13.value2
			var4_13 = iter2_13.key

			break
		end
	end

	local var7_13 = {}
	local var8_13 = arg0_13[2] or {}
	local var9_13 = 3

	for iter3_13 = #var8_13 + 1, var9_13 do
		table.insert(var8_13, {
			value = 0,
			key = iter3_13
		})
	end

	table.sort(var8_13, function(arg0_15, arg1_15)
		return arg0_15.key < arg1_15.key
	end)

	for iter4_13, iter5_13 in ipairs(var8_13) do
		var7_13[iter5_13.key] = iter5_13.value
	end

	return var3_13, var4_13, var7_13
end

function var0_0.GetAwardScores()
	local var0_16 = pg.mini_game[MiniGameDataCreator.TowerClimbingGameID].simple_config_data

	return (_.map(var0_16, function(arg0_17)
		return arg0_17[1]
	end))
end

function var0_0.PackData(arg0_18)
	local var0_18 = arg0_18._tf.rect.width
	local var1_18 = arg0_18._tf.rect.height
	local var2_18 = arg0_18:GetMGData():GetRuntimeData("kvpElements")
	local var3_18, var4_18, var5_18 = var0_0.GetTowerClimbingPageAndScore(var2_18)

	print(var3_18, "-", var4_18)

	local var6_18 = var0_0.GetAwardScores()

	return {
		shipId = 107031,
		npcName = "TowerClimbingManjuu",
		life = 3,
		screenWidth = var0_18,
		screenHeight = var1_18,
		higestscore = var3_18,
		pageIndex = var4_18,
		mapScores = var5_18,
		awards = var6_18
	}
end

function var0_0.onBackPressed(arg0_19)
	if arg0_19.controller:onBackPressed() then
		return
	end

	arg0_19:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_20)
	arg0_20.controller:Dispose()
end

return var0_0
