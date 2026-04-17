local var0_0 = class("IslandCheaterTavernPlayRoomInfoPage", import("...page.temp.IslandExternalBridgePage"))

function var0_0.AddListeners(arg0_1)
	arg0_1:AddListener(GAME.PLAY_ROOM_ALL_LOAD_OVER, arg0_1.OnRoomAllLoadDone)
	arg0_1:AddListener(GAME.PLAY_ROOM_REDAY_ROOM_REFRESH, arg0_1.OnRefreshModel)
	arg0_1:AddListener(GAME.PLAY_ROOM_MATCH_REDAY_ROOM_REFRESH, arg0_1.OnRefreshModel)
	arg0_1:AddListener(GAME.ISLAND_CHEATER_CHANGE_VIEW_DRESSID, arg0_1.OnRefreshModel)
	arg0_1:AddListener(GAME.PLAY_ROOM_ENTER_LOAD, arg0_1.OnRefreshModel)
end

function var0_0.RemoveListeners(arg0_2)
	arg0_2:RemoveListener(GAME.PLAY_ROOM_ALL_LOAD_OVER, arg0_2.OnRoomAllLoadDone)
	arg0_2:RemoveListener(GAME.PLAY_ROOM_REDAY_ROOM_REFRESH, arg0_2.OnRefreshModel)
	arg0_2:RemoveListener(GAME.PLAY_ROOM_MATCH_REDAY_ROOM_REFRESH, arg0_2.OnRefreshModel)
	arg0_2:RemoveListener(GAME.ISLAND_CHEATER_CHANGE_VIEW_DRESSID, arg0_2.OnRefreshModel)
	arg0_2:RemoveListener(GAME.PLAY_ROOM_ENTER_LOAD, arg0_2.OnRefreshModel)
end

function var0_0.getUIName(arg0_3)
	return "IslandCheaterTavernPlayRoomInfoDisplayUI"
end

function var0_0.OnLoaded(arg0_4)
	local var0_4 = arg0_4._tf:Find("adapt/playerList")

	arg0_4.playerCharTF = {}

	for iter0_4 = 1, 4 do
		local var1_4 = var0_4:Find("playerItem" .. iter0_4)

		arg0_4.playerCharTF[iter0_4] = var1_4:Find("charPos")
	end
end

function var0_0.OnShow(arg0_5, arg1_5)
	arg0_5.sceneRoomType = arg1_5

	arg0_5:AddSubLayers(arg0_5:GetContext())

	arg0_5.isExit = false
	arg0_5.playerIndexDic = {}
	arg0_5.modelDataDic = {}

	arg0_5:LoadRoomPlayerModel()

	arg0_5.unReadyEffectList = {}
	arg0_5.readyEffectList = {}

	arg0_5:LoadLightEffect(arg0_5.playerSlotCount)
end

function var0_0.GetContext(arg0_6)
	return Context.New({
		mediator = PlayRoomInfoMediator,
		viewComponent = PlayRoomInfoScene
	})
end

function var0_0.AddSubLayers(arg0_7, arg1_7)
	local var0_7 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(IslandMediator)

	arg1_7.data = {
		container = arg0_7._tf,
		onClose = function()
			pg.SceneAnimMgr.GetInstance():CommonSceneChange("Dorm3DLoading", function(arg0_9)
				arg0_7:Hide()
				arg0_9()
			end)
		end,
		sceneRoomType = arg0_7.sceneRoomType
	}

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_7,
		context = arg1_7
	})
end

function var0_0.OnRoomAllLoadDone(arg0_10)
	IslandCheaterTavernRecordTools.StartGame()
end

function var0_0.OnRefreshModel(arg0_11)
	arg0_11:LoadRoomPlayerModel()
	arg0_11:RefreshLight()
end

function var0_0.RefreshLight(arg0_12)
	local var0_12 = getProxy(PlayRoomProxy)
	local var1_12 = arg0_12.playRoomProxy:GetGameLoadData()

	if var1_12 == nil then
		if arg0_12.sceneRoomType == IslandCheaterTavernConst.SceneRoomType.CustomRoom then
			var1_12 = var0_12:GetRoomData()
		elseif arg0_12.sceneRoomType == IslandCheaterTavernConst.SceneRoomType.MatchInfoRoom then
			var1_12 = var0_12:GetMatchRoomData()
		end
	end

	if var1_12 == nil then
		return
	end

	local var2_12 = var1_12.teamPosList

	for iter0_12 = 1, arg0_12.playerSlotCount do
		if var2_12[iter0_12] and var2_12[iter0_12][1] then
			if arg0_12.playRoomProxy:GetGameLoadData() or table.keyof(var1_12.readyList, var2_12[iter0_12][1]) then
				setActive(arg0_12.unReadyEffectList[iter0_12], false)
				setActive(arg0_12.readyEffectList[iter0_12], true)
			else
				setActive(arg0_12.unReadyEffectList[iter0_12], true)
				setActive(arg0_12.readyEffectList[iter0_12], false)
			end
		else
			setActive(arg0_12.unReadyEffectList[iter0_12], false)
			setActive(arg0_12.readyEffectList[iter0_12], false)
		end
	end
end

function var0_0.LoadRoomPlayerModel(arg0_13)
	arg0_13.playRoomProxy = getProxy(PlayRoomProxy)

	local var0_13 = arg0_13.playRoomProxy
	local var1_13 = arg0_13.playRoomProxy:GetGameLoadData()

	if var1_13 == nil then
		if arg0_13.sceneRoomType == IslandCheaterTavernConst.SceneRoomType.CustomRoom then
			var1_13 = var0_13:GetRoomData()
		elseif arg0_13.sceneRoomType == IslandCheaterTavernConst.SceneRoomType.MatchInfoRoom then
			var1_13 = var0_13:GetMatchRoomData()
		end
	end

	if var1_13 == nil then
		return
	end

	local var2_13 = var1_13.teamPosList

	arg0_13.playerSlotCount = PlayRoomTools.GetMaxTeamCnt(var1_13.gameType)
	arg0_13.dressHelperDic = {}

	for iter0_13 = 1, arg0_13.playerSlotCount do
		if var2_13[iter0_13] then
			local var3_13 = var2_13[iter0_13][1]
			local var4_13 = var1_13.playerDataList[var3_13]

			if var4_13 then
				arg0_13.playerIndexDic[iter0_13] = var3_13

				local var5_13 = PlayRoomTools.GetGameViewID(var4_13.user_view)

				if not arg0_13.dressHelperDic[iter0_13] then
					arg0_13.dressHelperDic[iter0_13] = IslandShipDressHelperMiniGameNew.New()

					arg0_13.dressHelperDic[iter0_13]:SetShipId(var5_13.ship_id, var5_13.dress_list or {})
				end

				local var6_13 = CheaterTavernHelper.GetModelDataByViewData(var5_13)

				arg0_13:LoadCharacter(iter0_13, var6_13)
			else
				arg0_13:UnloadCharacter(iter0_13)
			end
		end
	end
end

function var0_0.Preload(arg0_14, arg1_14)
	arg0_14:PrepareCharacterScene(arg1_14)
end

function var0_0.PrepareCharacterScene(arg0_15, arg1_15)
	arg0_15.isLoadCharacterScene = true

	seriesAsync({
		function(arg0_16)
			arg0_15:CreateCharacterContainer()
			arg0_15:LoadCharacterScene(arg0_16)
		end,
		function(arg0_17)
			arg0_15:ModifyCameraMask()
			arg0_15:ActivityCharacterCamera()
			arg0_15:InitSceneTimeline()
			arg0_17()
		end
	}, arg1_15)
end

function var0_0.CreateCharacterContainer(arg0_18)
	arg0_18.roleContainer = GameObject.New("roleContainer").transform

	pg.ViewUtils.SetLayer(arg0_18.roleContainer, Layer.Character3D)
end

function var0_0.ModifyCameraMask(arg0_19)
	local var0_19 = IslandCameraMgr.instance

	if IsNil(var0_19) then
		var0_19 = CheatTavernCameraMgr.instance
	end

	local var1_19 = var0_19._mainCamera

	arg0_19.defaultCullingMask = var1_19.cullingMask

	LuaHelper.SetCamCullingMask(var1_19, "Character3D")
end

function var0_0.ActivityCharacterCamera(arg0_20)
	local var0_20 = arg0_20:GetActiveCamName()
	local var1_20 = IslandCameraMgr.instance

	if IsNil(var1_20) then
		var1_20 = CheatTavernCameraMgr.instance
	end

	local var2_20 = var1_20:GetVirtualCamera(var0_20)

	var2_20.Follow = arg0_20.roleContainer
	var2_20.LookAt = arg0_20.roleContainer

	var1_20:ActiveVirtualCamera(var0_20)
end

function var0_0.InitSceneTimeline(arg0_21)
	local var0_21 = GameObject.Find("[sequence]")

	if var0_21 then
		local var1_21 = var0_21:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		TimelineSupport.DynamicBinding(var1_21)
		var1_21:Play()
	end
end

function var0_0.ClearCharacterScene(arg0_22, arg1_22)
	arg0_22.isExit = true

	if arg0_22.isLoadCharacterScene then
		arg0_22:UnLoadLightEffect()
		arg0_22:ClearCharacterContainer()
		arg0_22:UnLoadCharacterScene(function()
			arg0_22:ActivityPlayerCamera()
			existCall(arg1_22)
		end)
		arg0_22:ResetCameraMask()
		arg0_22:emitCore(ISLAND_EVT.REFRESH_WEATHER_SYSTEM)
	end

	arg0_22.playerIndexDic = {}
	arg0_22.modelDataDic = {}
	arg0_22.isLoadCharacterScene = false
end

function var0_0.OnHome(arg0_24)
	arg0_24:ClearCharacterScene(function()
		arg0_24:emit(BaseUI.ON_HOME)
	end)
end

function var0_0.LoadCharacter(arg0_26, arg1_26, arg2_26)
	arg0_26:UnloadCharacter(arg1_26)

	local var0_26 = arg0_26.modelDataDic[arg1_26] or {}

	arg0_26.modelDataDic[arg1_26] = var0_26
	arg0_26.modelDataDic[arg1_26].modelData = arg2_26

	local function var1_26(arg0_27)
		local var0_27 = arg0_26.modelDataDic[arg1_26]

		if var0_27 == nil or var0_27.modelData.model ~= arg2_26.model then
			arg0_26:GetPoolMgr():ReturnCharacter(arg2_26.model, arg2_26.animator, arg0_27)

			return
		end

		local var1_27 = arg0_27

		GetOrAddComponent(var1_27, typeof(CharacterHandleController))

		arg0_26.modelDataDic[arg1_26].role = var1_27

		pg.ViewUtils.SetLayer(var1_27.transform, Layer.Character3D)
		setParent(var1_27, arg0_26.roleContainer)

		var1_27.transform.eulerAngles = Vector3(0, 180, 0)

		local var2_27 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var3_27 = arg0_26.playerCharTF[arg1_26]
		local var4_27 = var2_27:WorldToScreenPoint(var3_27.position)
		local var5_27 = IslandCameraMgr.instance

		if IsNil(var5_27) then
			var5_27 = CheatTavernCameraMgr.instance
		end

		local var6_27 = var5_27._mainCamera:ScreenToWorldPoint(Vector3(var4_27.x, var4_27.y, 10))

		var1_27.transform.localPosition = Vector3(var6_27.x, var6_27.y + 0.4, var6_27.z)

		arg0_26:OnCharLoaded(arg1_26, arg2_26)
	end

	arg0_26:_LoadModel(arg2_26, var1_26)
end

function var0_0._LoadModel(arg0_28, arg1_28, arg2_28)
	pg.UIMgr.GetInstance():LoadingOn()
	arg0_28:GetPoolMgr():GetCharacter(arg1_28.model, arg1_28.animator, function(arg0_29)
		arg2_28(arg0_29)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

function var0_0.UnloadCharacter(arg0_30, arg1_30)
	local var0_30 = arg0_30.modelDataDic[arg1_30]

	if var0_30 and var0_30.role then
		local var1_30 = var0_30.modelData

		pg.ViewUtils.SetLayer(var0_30.role.transform, Layer.Default)
		arg0_30:GetPoolMgr():ReturnCharacter(var1_30.model, var1_30.animator, var0_30.role)
	end

	arg0_30.modelDataDic[arg1_30] = nil
	arg0_30.playerIndexDic[arg1_30] = nil
end

function var0_0.LoadLightEffect(arg0_31, arg1_31)
	arg1_31 = arg1_31 or 0

	local var0_31, var1_31 = arg0_31:GetLigthEffectPath()
	local var2_31 = {}

	for iter0_31 = 1, arg1_31 do
		local var3_31 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var4_31 = arg0_31.playerCharTF[iter0_31]
		local var5_31 = var3_31:WorldToScreenPoint(var4_31.position)
		local var6_31 = IslandCameraMgr.instance

		if IsNil(var6_31) then
			var6_31 = CheatTavernCameraMgr.instance
		end

		local var7_31 = var6_31._mainCamera:ScreenToWorldPoint(Vector3(var5_31.x, var5_31.y, 10))
		local var8_31 = Vector3(var7_31.x, var7_31.y + 0.4, var7_31.z)

		table.insert(var2_31, function(arg0_32)
			arg0_31:GetPoolMgr():GetSceneProductEffect(var0_31, function(arg0_33)
				if arg0_31.isExit then
					arg0_31:GetPoolMgr():ReturnSceneProductEffect(var0_31, arg0_33)
				else
					setActive(arg0_33, false)

					arg0_33.transform.localPosition = var8_31

					setParent(arg0_33, arg0_31.roleContainer)

					arg0_31.unReadyEffectList[iter0_31] = arg0_33
				end

				arg0_32()
			end)
		end)
		table.insert(var2_31, function(arg0_34)
			arg0_31:GetPoolMgr():GetSceneProductEffect(var1_31, function(arg0_35)
				if arg0_31.isExit then
					arg0_31:GetPoolMgr():ReturnSceneProductEffect(var1_31, arg0_35)
				else
					setActive(arg0_35, false)
					setParent(arg0_35, arg0_31.roleContainer)

					arg0_35.transform.localPosition = var8_31
					arg0_31.readyEffectList[iter0_31] = arg0_35
				end

				arg0_34()
			end)
		end)
	end

	seriesAsync(var2_31, function()
		arg0_31:RefreshLight()
	end)
end

function var0_0.UnLoadLightEffect(arg0_37)
	local var0_37, var1_37 = arg0_37:GetLigthEffectPath()

	for iter0_37, iter1_37 in ipairs(arg0_37.readyEffectList) do
		arg0_37:GetPoolMgr():ReturnSceneProductEffect(var1_37, iter1_37)
	end

	arg0_37.readyEffectList = {}

	for iter2_37, iter3_37 in ipairs(arg0_37.unReadyEffectList) do
		arg0_37:GetPoolMgr():ReturnSceneProductEffect(var0_37, iter3_37)
	end

	arg0_37.unReadyEffectList = {}
end

function var0_0.ClearCharacterContainer(arg0_38)
	for iter0_38, iter1_38 in ipairs(arg0_38.dressHelperDic or {}) do
		iter1_38:Destroy()
	end

	for iter2_38 = 1, arg0_38.playerSlotCount or 0 do
		arg0_38:UnloadCharacter(iter2_38)
	end

	if not IsNil(arg0_38.roleContainer) then
		Object.Destroy(arg0_38.roleContainer.gameObject)

		arg0_38.roleContainer = nil
	end
end

function var0_0.ResetCameraMask(arg0_39)
	local var0_39 = IslandCameraMgr.instance

	if IsNil(var0_39) then
		var0_39 = CheatTavernCameraMgr.instance
	end

	if arg0_39.defaultCullingMask and var0_39 then
		local var1_39 = var0_39._mainCamera

		LuaHelper.ResetCamCullingMask(var1_39, arg0_39.defaultCullingMask)
	end
end

function var0_0.ActivityPlayerCamera(arg0_40)
	if not IslandCameraMgr.instance then
		return
	end

	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.FOLLOW_CAMERA_NAME)
end

function var0_0.OnHide(arg0_41)
	var0_0.super.OnHide(arg0_41)
	arg0_41:ClearCharacterScene()
end

function var0_0.OnDisable(arg0_42)
	arg0_42:RemoveSubLayers(arg0_42:GetContext())
	arg0_42:ClearCharacterScene()
end

function var0_0.OnDestroy(arg0_43)
	arg0_43:ClearCharacterScene()

	for iter0_43, iter1_43 in pairs(arg0_43.cards or {}) do
		iter1_43:Dispose()
	end

	arg0_43.cards = nil
end

function var0_0.GetActiveCamName(arg0_44)
	return IslandConst.CHARA_CAMERA_NAME
end

function var0_0.OnCharLoaded(arg0_45, arg1_45, arg2_45)
	local var0_45 = arg0_45.dressHelperDic[arg1_45]

	if var0_45 then
		var0_45:OnRoleLoaded(arg0_45.modelDataDic[arg1_45].role.transform, arg2_45)
	end
end

function var0_0.LoadCharacterScene(arg0_46, arg1_46)
	local var0_46 = "island/scenesres/scenes/bar/map_xyd_bar_character01_scene"

	SceneOpMgr.Inst:LoadSceneAsyncWithProgress(var0_46, "map_xyd_bar_character01", LoadSceneMode.Additive, function(arg0_47)
		if arg0_47 == 1 then
			arg1_46()
		end
	end)
end

function var0_0.UnLoadCharacterScene(arg0_48, arg1_48)
	local var0_48 = "island/scenesres/scenes/character/map_xyd_bar_character01_scene"

	SceneOpMgr.Inst:UnloadSceneAsync(var0_48, "map_xyd_bar_character01", function()
		if arg1_48 then
			arg1_48()
		end
	end)
end

function var0_0.GetLigthEffectPath(arg0_50)
	return "island/effect/prefab/game/bar/vfx_bar_quan_y", "island/effect/prefab/game/bar/vfx_bar_quan_b"
end

function var0_0.OnInit(arg0_51)
	return
end

function var0_0.closeView(arg0_52)
	arg0_52.contextData.onClose()
end

return var0_0
