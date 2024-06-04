local var0 = class("TowerClimbingGameView", import("..BaseMiniGameView"))

function var0.getUIName(arg0)
	return "TowerClimbingUI"
end

function var0.GetMGData(arg0)
	local var0 = arg0.contextData.miniGameId

	return getProxy(MiniGameProxy):GetMiniGameData(var0):clone()
end

function var0.GetMGHubData(arg0)
	local var0 = arg0.contextData.miniGameId

	return getProxy(MiniGameProxy):GetHubByGameId(var0)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("overview/back"), function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("overview/collection"), function()
		arg0:emit(TowerClimbingMediator.ON_COLLECTION)
	end, SFX_PANEL)

	if LOCK_TOWERCLIMBING_AWARD then
		setActive(arg0:findTF("overview/collection"), false)
	end
end

function var0.UpdateTip(arg0)
	local var0 = arg0:GetMGData()
	local var1 = TowerClimbingCollectionLayer.New()

	var1:SetData(var0)

	local var2 = _.any({
		1,
		2,
		3
	}, function(arg0)
		return var1:GetAwardState(arg0) == 1
	end)

	setActive(arg0:findTF("overview/collection/tip"), var2)
end

function var0.Start(arg0)
	arg0.controller = TowerClimbingController.New()

	arg0.controller.view:SetUI(arg0._go)

	local function var0(arg0, arg1, arg2)
		arg0:emit(TowerClimbingMediator.ON_FINISH, arg0, arg2, arg1)
	end

	local function var1(arg0, arg1)
		print("record map score:", arg0, arg1)
		arg0:emit(TowerClimbingMediator.ON_RECORD_MAP_SCORE, arg0, arg1)
	end

	arg0.controller:SetCallBack(var0, var1)

	local var2 = arg0:PackData()

	arg0.controller:SetUp(var2)
	arg0:UpdateTip()
end

function var0.OnSendMiniGameOPDone(arg0, arg1)
	if arg1.hubid == 9 and arg1.cmd == MiniGameOPCommand.CMD_SPECIAL_GAME and arg1.argList[1] == MiniGameDataCreator.TowerClimbingGameID and arg1.argList[2] == 1 then
		arg0:Start()
	elseif arg1.hubid == 9 and arg1.cmd == MiniGameOPCommand.CMD_COMPLETE or arg1.hubid == 9 and arg1.cmd == MiniGameOPCommand.CMD_SPECIAL_GAME and (arg1.argList[2] == 3 or arg1.argList[2] == 4) then
		local var0 = arg0:PackData()

		arg0.controller:NetUpdateData(var0)
		arg0:UpdateTip()
	end
end

function var0.GetTowerClimbingPageAndScore(arg0)
	local var0 = arg0[1] or {}
	local var1 = 3

	for iter0 = #var0 + 1, var1 do
		table.insert(var0, {
			value = 0,
			value2 = 0,
			key = iter0
		})
	end

	table.sort(var0, function(arg0, arg1)
		return arg0.key < arg1.key
	end)

	local var2 = var0.GetAwardScores()
	local var3 = 0
	local var4 = 1

	for iter1, iter2 in ipairs(var0) do
		local var5 = var2[iter2.key]
		local var6 = var5[#var5]

		if var6 > iter2.value2 or iter1 == #var0 and var6 <= iter2.value2 then
			var3 = iter2.value2
			var4 = iter2.key

			break
		end
	end

	local var7 = {}
	local var8 = arg0[2] or {}
	local var9 = 3

	for iter3 = #var8 + 1, var9 do
		table.insert(var8, {
			value = 0,
			key = iter3
		})
	end

	table.sort(var8, function(arg0, arg1)
		return arg0.key < arg1.key
	end)

	for iter4, iter5 in ipairs(var8) do
		var7[iter5.key] = iter5.value
	end

	return var3, var4, var7
end

function var0.GetAwardScores()
	local var0 = pg.mini_game[MiniGameDataCreator.TowerClimbingGameID].simple_config_data

	return (_.map(var0, function(arg0)
		return arg0[1]
	end))
end

function var0.PackData(arg0)
	local var0 = arg0._tf.rect.width
	local var1 = arg0._tf.rect.height
	local var2 = arg0:GetMGData():GetRuntimeData("kvpElements")
	local var3, var4, var5 = var0.GetTowerClimbingPageAndScore(var2)

	print(var3, "-", var4)

	local var6 = var0.GetAwardScores()

	return {
		shipId = 107031,
		npcName = "TowerClimbingManjuu",
		life = 3,
		screenWidth = var0,
		screenHeight = var1,
		higestscore = var3,
		pageIndex = var4,
		mapScores = var5,
		awards = var6
	}
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
