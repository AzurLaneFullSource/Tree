local var0_0 = class("IslandCheaterTavernGameView", import("Mod.Island.Core.View.IslandView"))

function var0_0.Init(arg0_1)
	var0_0.super.Init(arg0_1)
end

function var0_0.OnSceneInited(arg0_2)
	return
end

function var0_0.CreateViews(arg0_3)
	arg0_3.views = {}
end

function var0_0.AfterCoreInit(arg0_4)
	if arg0_4.weatherSystem then
		arg0_4.weatherSystem:Dispose()
	end

	arg0_4.weatherSystem = IslandWeatherSystem.New(arg0_4)
	arg0_4.root = arg0_4:CreateRoot()

	arg0_4:InitSceneGameObject()

	arg0_4.isSceneLoaded = true

	arg0_4:PlayBGM()
end

function var0_0.IsLoaded(arg0_5)
	local var0_5 = arg0_5:GetAllUnits()

	return _.all(arg0_5.views, function(arg0_6)
		return arg0_6:IsLoaded()
	end) and _.all(var0_5, function(arg0_7)
		return arg0_7:IsLoaded()
	end)
end

function var0_0.IsInit(arg0_8)
	return arg0_8.isInit
end

function var0_0.AddListeners(arg0_9)
	arg0_9:AddListener(ISLAND_EVT.GEN_UNIT, arg0_9.OnGenUnit)
	arg0_9:AddListener(ISLAND_EVT.RMOVE_UNIT, arg0_9.OnRemoveUnit)
	arg0_9:AddListener(ISLAND_EVT.INIT_CHEATERTAVERN_CAMERA, arg0_9.OnInitCamera)
	arg0_9:AddListener(CheaterTavernEvent.PLAYER_QUESTION_ANIMATION, arg0_9.OnPlayerQuestion)
	arg0_9:AddListener(CheaterTavernEvent.SHOOT_AND_TURN_TABLE, arg0_9.OnPlayerShoot)
	arg0_9:AddListener(CheaterTavernEvent.PLAYER_OUT_ANIMATION, arg0_9.OnPlayerOut)
	arg0_9:AddListener(CheaterTavernEvent.FIRST_TAKE_SHOOT_TIPS, arg0_9.OnFirstTakeShootTip)
	arg0_9:AddListener(CheaterTavernEvent.CLOSE_PREPARE_MAIN_PAGE, arg0_9.OnCloseCheaterMainPage)
	arg0_9:AddListener(CheaterTavernEvent.PLAY_ROOM_EXIT_ROOM_DONE, arg0_9.OnExitRoomDone)
	arg0_9:AddListener(CheaterTavernEvent.INITPLAYER_DATA_DONE, arg0_9.OnInitPlayerDone)
	arg0_9:AddListener(CheaterTavernEvent.PLAY_WIN_ANIMATION, arg0_9.OnPlayWinAnimation)
end

function var0_0.RemoveListeners(arg0_10)
	arg0_10:RemoveListener(ISLAND_EVT.GEN_UNIT, arg0_10.OnGenUnit)
	arg0_10:RemoveListener(ISLAND_EVT.RMOVE_UNIT, arg0_10.OnRemoveUnit)
	arg0_10:RemoveListener(ISLAND_EVT.INIT_CHEATERTAVERN_CAMERA, arg0_10.OnInitCamera)
	arg0_10:RemoveListener(CheaterTavernEvent.PLAYER_QUESTION_ANIMATION, arg0_10.OnPlayerQuestion)
	arg0_10:RemoveListener(CheaterTavernEvent.SHOOT_AND_TURN_TABLE, arg0_10.OnPlayerShoot)
	arg0_10:RemoveListener(CheaterTavernEvent.PLAYER_OUT_ANIMATION, arg0_10.OnPlayerOut)
	arg0_10:RemoveListener(CheaterTavernEvent.FIRST_TAKE_SHOOT_TIPS, arg0_10.OnFirstTakeShootTip)
	arg0_10:RemoveListener(CheaterTavernEvent.CLOSE_PREPARE_MAIN_PAGE, arg0_10.OnCloseCheaterMainPage)
	arg0_10:RemoveListener(CheaterTavernEvent.PLAY_ROOM_EXIT_ROOM_DONE, arg0_10.OnExitRoomDone)
	arg0_10:RemoveListener(CheaterTavernEvent.INITPLAYER_DATA_DONE, arg0_10.OnInitPlayerDone)
	arg0_10:RemoveListener(CheaterTavernEvent.PLAY_WIN_ANIMATION, arg0_10.OnPlayWinAnimation)
end

function var0_0.OnInitCamera(arg0_11, arg1_11)
	onNextTick(function()
		local var0_12 = "lookSeet0" .. arg1_11

		print("lookSeet0" .. Time.frameCount)
		CheatTavernCameraMgr.instance:ActiveVirtualCamera(var0_12)
	end)
end

function var0_0.PlayBGM(arg0_13)
	if not arg0_13.isSceneLoaded then
		return
	end

	var0_0.super.PlayBGM(arg0_13)
end

function var0_0.OnCloseCheaterMainPage(arg0_14)
	local var0_14 = arg0_14:GetSelfIsland()

	arg0_14:NotifiyMeditor(IslandBaseMediator.SWITCH_MAP, var0_14:GetLastExitPosition().mapId)
end

function var0_0.OnFirstTakeShootTip(arg0_15, arg1_15)
	local var0_15 = arg0_15:GetUnitModuleWithType(IslandConst.UNIT_LIST_CHEATER_ITEM, IslandCheaterTavernConst.deskTableId)

	if var0_15 then
		var0_15:OnFirstTakeShootTip(arg1_15)
	end
end

function var0_0.OnPlayerQuestion(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg0_16:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_16)

	if var0_16 then
		var0_16:OnPlayerQuestion(arg2_16)
	end

	if arg3_16 then
		local var1_16 = IslandCheaterTavernConst.deskCharIdList[arg3_16]
		local var2_16 = arg0_16:GetUnitModuleWithType(IslandConst.UNIT_LIST_CHEATER_ITEM, var1_16)

		if var2_16 then
			var2_16:OnPlayerQuestion()
		end
	end
end

function var0_0.OnPlayWinAnimation(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = arg0_17:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_17)

	if var0_17 then
		var0_17:OnPlayWinAnimation(arg2_17, arg3_17)
	end

	if arg2_17 then
		local var1_17 = IslandCheaterTavernConst.deskCharIdList[arg3_17]
		local var2_17 = arg0_17:GetUnitModuleWithType(IslandConst.UNIT_LIST_CHEATER_ITEM, var1_17)

		if var2_17 then
			var2_17:OnPlayWinAnimation()
		end
	end
end

function var0_0.OnPlayerShoot(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18, arg5_18)
	local var0_18 = arg0_18:GetUnitModuleWithType(IslandConst.UNIT_LIST_CHEATER_ITEM, IslandCheaterTavernConst.deskTableId)

	if var0_18 then
		var0_18:OnShoot(arg1_18, arg2_18, arg3_18, arg4_18, arg5_18)
	end
end

function var0_0.OnPlayerOut(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg0_19:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_19)

	if var0_19 then
		var0_19:OnPlayerOut(arg1_19, arg2_19)
	end

	local var1_19 = arg0_19:GetUnitModuleWithType(IslandConst.UNIT_LIST_CHEATER_ITEM, IslandCheaterTavernConst.deskCharIdList[arg2_19])

	if var1_19 then
		var1_19:OnPlayerOut(arg3_19)
	end
end

function var0_0.OnExitRoomDone(arg0_20)
	arg0_20:ClearSceneObject()
	arg0_20:InitSceneGameObject()
end

function var0_0.OnInitPlayerDone(arg0_21)
	for iter0_21, iter1_21 in ipairs(IslandCheaterTavernConst.deskCharIdList) do
		local var0_21 = arg0_21:GetUnitModuleWithType(IslandConst.UNIT_LIST_CHEATER_ITEM, iter1_21)

		if var0_21 then
			var0_21:InitDisplayState()
		end
	end
end

function var0_0.ClearSceneObject(arg0_22)
	local var0_22 = arg0_22:GetUnitListByKey(IslandConst.UNIT_LIST_PLAYER)
	local var1_22 = {}

	for iter0_22, iter1_22 in ipairs(var0_22) do
		table.insert(var1_22, iter1_22.id)
	end

	for iter2_22, iter3_22 in ipairs(var1_22) do
		arg0_22:OnRemoveUnit(IslandConst.UNIT_LIST_PLAYER, iter3_22)
	end

	local var2_22 = {}
	local var3_22 = arg0_22:GetUnitListByKey(IslandConst.UNIT_LIST_CHEATER_ITEM)

	for iter4_22, iter5_22 in ipairs(var3_22) do
		table.insert(var2_22, iter5_22.id)
	end

	for iter6_22, iter7_22 in ipairs(var2_22) do
		arg0_22:OnRemoveUnit(IslandConst.UNIT_LIST_CHEATER_ITEM, iter7_22)
	end
end

function var0_0.InitSceneGameObject(arg0_23)
	local var0_23 = {}

	for iter0_23, iter1_23 in ipairs(IslandCheaterTavernConst.deskCharIdList) do
		local var1_23 = pg.island_world_objects[iter1_23]

		if var1_23.unitId > 0 then
			local var2_23 = {
				typ = IslandConst.UNIT_TYPE_CHEATERTAVERN_CHAIR,
				index = iter0_23
			}
			local var3_23 = IslandDataConvertor.WorldObj2IslandUnit(var1_23, var2_23)

			table.insert(var0_23, var3_23)
		end
	end

	local var4_23 = pg.island_world_objects[IslandCheaterTavernConst.deskTableId]
	local var5_23 = {
		typ = IslandConst.UNIT_TYPE_CHEATERTAVERN_TABLE
	}
	local var6_23 = IslandDataConvertor.WorldObj2IslandUnit(var4_23, var5_23)

	table.insert(var0_23, var6_23)

	for iter2_23, iter3_23 in ipairs(var0_23) do
		arg0_23:OnGenUnit(iter3_23)
	end
end

function var0_0.RestartGame(arg0_24)
	return
end

function var0_0.OnEndPerformance(arg0_25)
	return
end

function var0_0.DisableOp(arg0_26)
	return
end

function var0_0.EnableOp(arg0_27)
	return
end

function var0_0.OnDispose(arg0_28)
	for iter0_28, iter1_28 in ipairs(arg0_28.views) do
		iter1_28:Dispose()
	end

	arg0_28.weatherSystem:Dispose()
end

function var0_0.OnRemoveUnit(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29:GetUnitListByKey(arg1_29)
	local var1_29 = 0

	for iter0_29, iter1_29 in ipairs(var0_29 or {}) do
		if iter1_29.id == arg2_29 then
			var1_29 = iter0_29

			break
		end
	end

	if var1_29 > 0 then
		local var2_29 = var0_29[var1_29]

		arg0_29:RemoveUnit(var2_29)
		var2_29:Dispose()
	end
end

function var0_0.OnAllPageClose(arg0_30)
	arg0_30.anyPageOpen = false
end

function var0_0.OnAnyPageOpen(arg0_31, arg1_31)
	arg0_31.anyPageOpen = true
end

function var0_0.OnUnTracking(arg0_32, arg1_32)
	return
end

return var0_0
