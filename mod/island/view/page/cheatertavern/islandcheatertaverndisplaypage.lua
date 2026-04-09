local var0_0 = class("IslandCheaterTavernDisplayPage", import("..ship.IslandBaseShipDisplayPage"))

function var0_0.getUIName(arg0_1)
	return "IslandCheaterTavernDisplayUI"
end

function var0_0.AddListeners(arg0_2)
	return
end

function var0_0.RemoveListeners(arg0_3)
	return
end

function var0_0.NeedCache(arg0_4)
	return false
end

function var0_0.AddSubLayers(arg0_5, arg1_5)
	local var0_5 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(IslandMediator)

	arg1_5.data = {
		container = arg0_5._tf,
		onClose = function()
			arg0_5:Hide()
		end
	}

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_5,
		context = arg1_5
	})
end

function var0_0.RemoveSubLayers(arg0_7, arg1_7)
	local var0_7 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg1_7.mediator)

	if var0_7 then
		pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_7
		})
	end
end

function var0_0.GetContext(arg0_8)
	return Context.New({
		mediator = PlayRoomEntranceMediator,
		viewComponent = PlayRoomCheatBarEntranceScene
	})
end

function var0_0.OnInit(arg0_9)
	onButton(arg0_9, arg0_9.uiCloseBtn, function()
		arg0_9:Hide()
	end, SPX_PANEL)
end

function var0_0.OnLoaded(arg0_11)
	arg0_11.playRoomPop = PlayRoomPop.New(arg0_11._tf:Find("playRoomPop"), arg0_11)

	arg0_11.playRoomPop:didEnter()
end

function var0_0.OnShow(arg0_12)
	arg0_12:AddSubLayers(arg0_12:GetContext())
	arg0_12.playRoomPop:Show(true)
	PlayRoomTools.SetGameTypeID(PlayRoomConst.GAME_TYPE.CHEATER_TAVERN)

	local var0_12 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
	local var1_12 = var0_12:GetViewGameShipViewId(PlayRoomTools.GetGameTypeID())
	local var2_12 = var0_12:GetShipById(var1_12)

	if not arg0_12.shipDressHelper then
		arg0_12.shipDressHelper = IslandShipDressHelperNew.New()
	end

	arg0_12.shipDressHelper:SetShipId(var2_12.configId, {}, true)
	arg0_12:LoadCharacter(var2_12:GetModel())
	setText(arg0_12.uiNameText, getProxy(PlayerProxy):getRawData().name)
end

function var0_0.OnHide(arg0_13)
	arg0_13:RemoveSubLayers(arg0_13:GetContext())
	arg0_13.playRoomPop:Show(false)
	arg0_13:UnloadCharacter(arg0_13.loadData)

	arg0_13.loadData = nil

	if arg0_13.shipDressHelper then
		arg0_13.shipDressHelper:Destroy()
	end
end

function var0_0.OnDisable(arg0_14)
	var0_0.super.OnDisable(arg0_14)
	arg0_14:RemoveSubLayers(arg0_14:GetContext())
end

function var0_0.OnDestroy(arg0_15)
	arg0_15:OnHide()
	arg0_15.playRoomPop:willExit()

	arg0_15.playRoomPop = nil
end

function var0_0.OnEnable(arg0_16)
	arg0_16:OnShow()
end

function var0_0.OnCharLoaded(arg0_17, arg1_17)
	if arg0_17.shipDressHelper then
		arg0_17.shipDressHelper:OnRoleLoaded(arg0_17.role.transform, arg1_17)
	end
end

function var0_0.GetSmoothRotateObject(arg0_18)
	return arg0_18._tf:Find("adapt/char")
end

function var0_0.SetCharterPos(arg0_19)
	if not arg0_19.role then
		return
	end

	local var0_19 = GameObject.Find("UICamera"):GetComponent(typeof(Camera)):WorldToScreenPoint(arg0_19.uiCharPos.position)
	local var1_19 = IslandCameraMgr.instance

	if IsNil(var1_19) then
		var1_19 = CheatTavernCameraMgr.instance
	end

	local var2_19 = var1_19._mainCamera:ScreenToWorldPoint(Vector3(var0_19.x, var0_19.y, 7))

	arg0_19.role.transform.localPosition = var2_19
end

function var0_0.LoadCharacter(arg0_20, arg1_20, arg2_20)
	arg0_20:UnloadCharacter(arg0_20.loadData)

	local var0_20 = {
		isCommander = arg2_20,
		modelData = arg1_20
	}

	arg0_20.loadData = var0_20

	local function var1_20(arg0_21, arg1_21)
		if arg0_20.loadData == nil then
			return
		end

		if var0_20.modelData.model ~= arg0_20.loadData.modelData.model then
			arg0_20:UnloadCharacter(var0_20)

			return
		end

		arg0_20.role = arg0_21

		GetOrAddComponent(arg0_20.role, typeof(CharacterHandleController))
		pg.ViewUtils.SetLayer(arg0_20.role.transform, Layer.Character3D)
		setParent(arg0_20.role, arg0_20.roleContainer)

		arg0_20.role.transform.eulerAngles = Vector3(0, 180, 0)

		arg0_20:SetCharterPos()

		local var0_21 = arg0_20:GetSmoothRotateObject()
		local var1_21 = GetOrAddComponent(var0_21, typeof(SmoothRotateObject))

		var1_21:SetUp(arg0_20.role.transform)

		var1_21.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int

		if arg1_21 and arg1_21 ~= "" then
			local var2_21 = GetOrAddComponent(arg0_20.role.transform:GetChild(0), typeof(Animator))

			for iter0_21 = 1, var2_21.layerCount do
				var2_21:CrossFadeInFixedTime(arg1_21, 0, iter0_21 - 1)
			end
		end

		arg0_20:OnCharLoaded(var0_20.modelData)
	end

	arg0_20:_LoadModel(var0_20, var1_20)
end

function var0_0.LoadCharacterScene(arg0_22, arg1_22)
	local var0_22 = "island/scenesres/scenes/bar/map_xyd_bar_character02_scene"

	SceneOpMgr.Inst:LoadSceneAsyncWithProgress(var0_22, "map_xyd_bar_character02", LoadSceneMode.Additive, function(arg0_23)
		if arg0_23 == 1 then
			arg1_22()
		end
	end)
end

function var0_0.UnLoadCharacterScene(arg0_24, arg1_24)
	local var0_24 = "island/scenesres/scenes/bar/map_xyd_bar_character02_scene"

	SceneOpMgr.Inst:UnloadSceneAsync(var0_24, "map_xyd_bar_character02", function()
		if arg1_24 then
			arg1_24()
		end
	end)
end

return var0_0
