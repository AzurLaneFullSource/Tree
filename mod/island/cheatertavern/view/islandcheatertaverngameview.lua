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
	local var0_11 = "lookSeet0" .. arg1_11

	print("todo:lookSeet0" .. Time.frameCount)
	CheatTavernCameraMgr.instance:ActiveVirtualCamera(var0_11)

	CheatTavernCameraMgr.instance._mainCamera.enabled = true
end

function var0_0.PlayBGM(arg0_12)
	if not arg0_12.isSceneLoaded then
		return
	end

	var0_0.super.PlayBGM(arg0_12)
end

function var0_0.OnCloseCheaterMainPage(arg0_13)
	local var0_13 = arg0_13:GetSelfIsland()

	arg0_13:NotifiyMeditor(IslandBaseMediator.SWITCH_MAP, var0_13:GetLastExitPosition().mapId)
end

function var0_0.OnFirstTakeShootTip(arg0_14, arg1_14)
	local var0_14 = arg0_14:GetUnitModuleWithType(IslandConst.UNIT_LIST_CHEATER_ITEM, IslandCheaterTavernConst.deskTableId)

	if var0_14 then
		var0_14:OnFirstTakeShootTip(arg1_14)
	end
end

function var0_0.OnPlayerQuestion(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = arg0_15:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_15)

	if var0_15 then
		var0_15:OnPlayerQuestion(arg2_15)
	end

	if arg3_15 then
		local var1_15 = IslandCheaterTavernConst.deskCharIdList[arg3_15]
		local var2_15 = arg0_15:GetUnitModuleWithType(IslandConst.UNIT_LIST_CHEATER_ITEM, var1_15)

		if var2_15 then
			var2_15:OnPlayerQuestion()
		end
	end
end

function var0_0.OnPlayWinAnimation(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg0_16:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_16)

	if var0_16 then
		var0_16:OnPlayWinAnimation(arg2_16, arg3_16)
	end

	if arg2_16 then
		local var1_16 = IslandCheaterTavernConst.deskCharIdList[arg3_16]
		local var2_16 = arg0_16:GetUnitModuleWithType(IslandConst.UNIT_LIST_CHEATER_ITEM, var1_16)

		if var2_16 then
			var2_16:OnPlayWinAnimation()
		end
	end
end

function var0_0.OnPlayerShoot(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17, arg5_17)
	local var0_17 = arg0_17:GetUnitModuleWithType(IslandConst.UNIT_LIST_CHEATER_ITEM, IslandCheaterTavernConst.deskTableId)

	if var0_17 then
		var0_17:OnShoot(arg1_17, arg2_17, arg3_17, arg4_17, arg5_17)
	end
end

function var0_0.OnPlayerOut(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg0_18:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, arg1_18)

	if var0_18 then
		var0_18:OnPlayerOut(arg1_18, arg2_18)
	end

	local var1_18 = arg0_18:GetUnitModuleWithType(IslandConst.UNIT_LIST_CHEATER_ITEM, IslandCheaterTavernConst.deskCharIdList[arg2_18])

	if var1_18 then
		var1_18:OnPlayerOut(arg3_18)
	end
end

function var0_0.OnExitRoomDone(arg0_19)
	arg0_19:ClearSceneObject()
	arg0_19:InitSceneGameObject()
end

function var0_0.OnInitPlayerDone(arg0_20)
	for iter0_20, iter1_20 in ipairs(IslandCheaterTavernConst.deskCharIdList) do
		local var0_20 = arg0_20:GetUnitModuleWithType(IslandConst.UNIT_LIST_CHEATER_ITEM, iter1_20)

		if var0_20 then
			var0_20:InitDisplayState()
		end
	end
end

function var0_0.ClearSceneObject(arg0_21)
	local var0_21 = arg0_21:GetUnitListByKey(IslandConst.UNIT_LIST_PLAYER)
	local var1_21 = {}

	for iter0_21, iter1_21 in ipairs(var0_21) do
		table.insert(var1_21, iter1_21.id)
	end

	for iter2_21, iter3_21 in ipairs(var1_21) do
		arg0_21:OnRemoveUnit(IslandConst.UNIT_LIST_PLAYER, iter3_21)
	end

	local var2_21 = {}
	local var3_21 = arg0_21:GetUnitListByKey(IslandConst.UNIT_LIST_CHEATER_ITEM)

	for iter4_21, iter5_21 in ipairs(var3_21) do
		table.insert(var2_21, iter5_21.id)
	end

	for iter6_21, iter7_21 in ipairs(var2_21) do
		arg0_21:OnRemoveUnit(IslandConst.UNIT_LIST_CHEATER_ITEM, iter7_21)
	end
end

function var0_0.InitSceneGameObject(arg0_22)
	local var0_22 = {}

	for iter0_22, iter1_22 in ipairs(IslandCheaterTavernConst.deskCharIdList) do
		local var1_22 = pg.island_world_objects[iter1_22]

		if var1_22.unitId > 0 then
			local var2_22 = {
				typ = IslandConst.UNIT_TYPE_CHEATERTAVERN_CHAIR,
				index = iter0_22
			}
			local var3_22 = IslandDataConvertor.WorldObj2IslandUnit(var1_22, var2_22)

			table.insert(var0_22, var3_22)
		end
	end

	local var4_22 = pg.island_world_objects[IslandCheaterTavernConst.deskTableId]
	local var5_22 = {
		typ = IslandConst.UNIT_TYPE_CHEATERTAVERN_TABLE
	}
	local var6_22 = IslandDataConvertor.WorldObj2IslandUnit(var4_22, var5_22)

	table.insert(var0_22, var6_22)

	for iter2_22, iter3_22 in ipairs(var0_22) do
		arg0_22:OnGenUnit(iter3_22)
	end
end

function var0_0.RestartGame(arg0_23)
	return
end

function var0_0.OnEndPerformance(arg0_24)
	return
end

function var0_0.DisableOp(arg0_25)
	return
end

function var0_0.EnableOp(arg0_26)
	return
end

function var0_0.OnDispose(arg0_27)
	for iter0_27, iter1_27 in ipairs(arg0_27.views) do
		iter1_27:Dispose()
	end

	arg0_27.weatherSystem:Dispose()
end

function var0_0.OnRemoveUnit(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28:GetUnitListByKey(arg1_28)
	local var1_28 = 0

	for iter0_28, iter1_28 in ipairs(var0_28 or {}) do
		if iter1_28.id == arg2_28 then
			var1_28 = iter0_28

			break
		end
	end

	if var1_28 > 0 then
		local var2_28 = var0_28[var1_28]

		arg0_28:RemoveUnit(var2_28)
		var2_28:Dispose()
	end
end

function var0_0.OnAllPageClose(arg0_29)
	arg0_29.anyPageOpen = false
end

function var0_0.OnAnyPageOpen(arg0_30, arg1_30)
	arg0_30.anyPageOpen = true
end

function var0_0.OnUnTracking(arg0_31, arg1_31)
	return
end

return var0_0
