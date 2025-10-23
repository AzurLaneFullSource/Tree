local var0_0 = class("IslandOpView", import(".IslandBaseOpView"))

var0_0.OperationType = {
	Interaction = 1,
	MiningCollect = 3,
	None = 0,
	Harvest = 4,
	FellCollect = 6,
	WildGather = 5,
	Plant = 2
}

function var0_0.GetUIName(arg0_1)
	return "IslandEmptyUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	arg0_2.opUI = arg0_2:GetPoolMgr():GetOpUI().transform

	setParent(arg0_2.opUI, arg1_2)

	arg0_2.showBalance = arg0_2:GetView():GetCacheOpCount() or 1
	arg0_2.inputController = IslandCameraMgr.instance.gameObject:GetComponent(typeof(InputController))
	arg0_2._go = arg1_2
	arg0_2._tf = arg1_2.transform
	arg0_2.opPanel = arg0_2.opUI:Find("op_btns")
	arg0_2.opBtn = arg0_2.opPanel:Find("op_btn")
	arg0_2.opBtnList = {
		arg0_2.opBtn:Find("interaction"),
		arg0_2.opBtn:Find("plant"),
		arg0_2.opBtn:Find("miningCollect"),
		arg0_2.opBtn:Find("harvest"),
		arg0_2.opBtn:Find("wildgather"),
		arg0_2.opBtn:Find("fellCollect")
	}
	arg0_2.seedBtn = arg0_2.opPanel:Find("seed")
	arg0_2.seedEmpty = arg0_2.seedBtn:Find("seedEmpty")
	arg0_2.areaChangeBtn = arg0_2.opPanel:Find("scope")
	arg0_2.run = arg0_2.opPanel:Find("run")
	arg0_2.moveBtn = arg0_2.opUI:Find("move")
	arg0_2.animationOpBtn = arg0_2.opPanel:Find("aniamtionop")
	arg0_2.animationOpEffect = arg0_2.animationOpBtn:Find("effect")
	arg0_2.followerBtn = arg0_2.opPanel:Find("follower")
	arg0_2.animationOpEffectCounter = {}

	local var0_2 = arg0_2.followerBtn:GetComponent(typeof(ItemList))

	arg0_2.uiFollowerPanel = arg0_2.followerBtn:Find("list")
	arg0_2.uiFollowerList = UIItemList.New(arg0_2.uiFollowerPanel, var0_2.prefabItem[0])

	setActive(arg0_2.opPanel, true)
	onButton(arg0_2, arg0_2.areaChangeBtn, function()
		arg0_2:NotifiyCore(ISLAND_EVT.AREACHANGE)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.animationOpBtn, function()
		arg0_2:NotifiyCore(ISLAND_EVT.OPEN_ANIMATION_OP)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.followerBtn, function()
		if isActive(arg0_2.uiFollowerPanel) then
			arg0_2:RemoveFollowerListTimer()
			setActive(arg0_2.uiFollowerPanel, false)
		else
			arg0_2:ShowFollowerList()
		end
	end, SFX_PANEL)

	arg0_2.operationType = var0_0.OperationType.None

	arg0_2:UpdateOperationButtonDisplay()

	arg0_2.playerInputManager = arg0_2.view:GetController().playerInputManager

	arg0_2:InitOpCustumPositon()
	arg0_2:UpdateFollowBtn()
	arg0_2:UpdateAnimationOpBtn()
end

function var0_0.LaterInit(arg0_6)
	if arg0_6.showBalance < 1 then
		arg0_6:DisablePlayerOp()
	end
end

function var0_0.UpdateAnimationOpBtn(arg0_7)
	local var0_7 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	setActive(arg0_7.animationOpBtn, var0_7:HasAbility(IslandAblityAgency.ANIMATION_OP_ID))
end

function var0_0.UpdateAnimationOpEffect(arg0_8, arg1_8, arg2_8)
	if arg2_8 then
		table.insert(arg0_8.animationOpEffectCounter, arg1_8)
	else
		table.removebyvalue(arg0_8.animationOpEffectCounter, arg1_8)
	end

	local var0_8 = _.map(arg0_8.animationOpEffectCounter, function(arg0_9)
		local var0_9, var1_9 = IslandCalcUtil.GetTypeAndIdByUniqueId(arg0_9)

		return arg0_8:GetView():GetUnitModuleWithType(var0_9, var1_9)
	end)
	local var1_8 = _.detect(var0_8, function(arg0_10)
		return arg0_10 and isa(arg0_10, IslandStrollNpcUnit) and arg0_10:ExistActionFeedbackBubble()
	end)

	setActive(arg0_8.animationOpEffect, var1_8)
end

function var0_0.UpdateFollowBtn(arg0_11)
	if #getProxy(IslandProxy):GetIsland():GetFollowerAgency():GetFollowers() <= 0 or not arg0_11:IsSelfIsland() then
		setActive(arg0_11.followerBtn, false)

		return
	end

	setActive(arg0_11.followerBtn, true)
end

function var0_0.ShowFollowerList(arg0_12)
	local var0_12 = getProxy(IslandProxy):GetIsland()
	local var1_12 = var0_12:GetFollowerAgency():GetFollowers()
	local var2_12 = var0_12:GetCharacterAgency()

	if #var1_12 <= 0 then
		return
	end

	arg0_12.uiFollowerList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = var1_12[arg1_13 + 1]
			local var1_13 = var2_12:GetShipById(var0_13)
			local var2_13 = IslandShip.StaticGetPrefab(var1_13.configId)

			GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var2_13, "", arg2_13:Find("icon"))
			onButton(arg0_12, arg2_13, function()
				arg0_12:NotifiyMeditor(IslandMediator.DEL_FOLLOWER, var1_13.id)
			end, SFX_PANEL)
		end
	end)
	arg0_12.uiFollowerList:align(#var1_12)
	setActive(arg0_12.uiFollowerPanel, true)
	arg0_12:AddDisableFollowerListTimer()
end

function var0_0.AddDisableFollowerListTimer(arg0_15)
	arg0_15:RemoveFollowerListTimer()

	arg0_15.followerTimer = Timer.New(function()
		arg0_15:RemoveFollowerListTimer()
		setActive(arg0_15.uiFollowerPanel, false)
	end, 5, 1)

	arg0_15.followerTimer:Start()
end

function var0_0.RemoveFollowerListTimer(arg0_17)
	if arg0_17.followerTimer then
		arg0_17.followerTimer:Stop()

		arg0_17.followerTimer = nil
	end
end

function var0_0.FlushFollowerList(arg0_18)
	arg0_18:UpdateFollowBtn()

	if not arg0_18.followerTimer then
		return
	end

	arg0_18:ShowFollowerList()
end

function var0_0.InitOpCustumPositon(arg0_19)
	local var0_19 = tf(GameObject.Find("UICamera/Canvas")).sizeDelta
	local var1_19 = var0_19.x / IslandSettingsConst.settingRectSize.x
	local var2_19 = var0_19.y / IslandSettingsConst.settingRectSize.y
	local var3_19 = IslandSettingsConst.ISLAND_JOY_STICK_DEFAULT_PREFERENCE
	local var4_19 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_JOYSTICK_ANCHORX, var3_19.x)
	local var5_19 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_JOYSTICK_ANCHORY, var3_19.y)

	arg0_19.moveBtn.anchoredPosition = Vector2(var4_19 * var1_19, var5_19 * var2_19)

	local var6_19 = {
		arg0_19.opBtn,
		arg0_19.opPanel:Find("jump"),
		arg0_19.areaChangeBtn,
		arg0_19.seedBtn
	}

	for iter0_19, iter1_19 in ipairs(var6_19) do
		local var7_19 = IslandSettingsConst.OPERATION_DEFAULT_PREFERENCE[iter0_19]
		local var8_19 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_OPERATION_ANCHORX[iter0_19], var7_19.x)
		local var9_19 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_OPERATION_ANCHORY[iter0_19], var7_19.y)

		iter1_19.anchoredPosition = Vector2(var8_19 * var1_19, var9_19 * var2_19)
	end
end

function var0_0.UpdateOperationButton(arg0_20, arg1_20, arg2_20)
	if arg1_20 == var0_0.OperationType.None then
		if arg0_20.unitId == arg2_20 then
			arg0_20.unitId = nil
			arg0_20.operationType = arg1_20
		end
	else
		arg0_20.unitId = arg2_20
		arg0_20.operationType = arg1_20
	end

	arg0_20:UpdateOperationButtonDisplay()
end

function var0_0.UpdateOperationButtonDisplay(arg0_21)
	if arg0_21.operationType == var0_0.OperationType.None then
		setActive(arg0_21.opBtn, false)
		setActive(arg0_21.areaChangeBtn, false)
		setActive(arg0_21.seedBtn, false)
		arg0_21:GetView():GetSubView(IslandSeedOpView):ActiveSeedSelect(false)
		arg0_21:GetView():GetSubView(IslandSeedOpView):ActiveSeedDetals(false)

		return
	end

	function OptionBtnDisplay(arg0_22)
		for iter0_22, iter1_22 in ipairs(arg0_21.opBtnList) do
			local var0_22 = iter0_22 == arg0_22

			setActive(iter1_22, var0_22)
		end
	end

	if not arg0_21.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_21.unitId) then
		setActive(arg0_21.opBtn, false)
		setActive(arg0_21.areaChangeBtn, false)
		setActive(arg0_21.seedBtn, false)
		arg0_21:GetView():GetSubView(IslandSeedOpView):ActiveSeedSelect(false)
		arg0_21:GetView():GetSubView(IslandSeedOpView):ActiveSeedDetals(false)

		return
	end

	setActive(arg0_21.opBtn, true)

	local function var0_21()
		OptionBtnDisplay(arg0_21.operationType)
		onButton(arg0_21, arg0_21.opBtn, function()
			local var0_24 = arg0_21.view:GetCore()
			local var1_24 = arg0_21.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_21.unitId)
			local var2_24 = var1_24:GetAnimatorTrigger()

			if var1_24:CheckCanStartColloct() then
				var0_24.controller.playerInputManager:UpdataWorkStateFunc(var2_24, var1_24)
			end
		end, SFX_PANEL)
		setActive(arg0_21.areaChangeBtn, false)
		setActive(arg0_21.seedBtn, false)
	end

	switch(arg0_21.operationType, {
		[var0_0.OperationType.Plant] = function()
			local var0_25 = arg0_21.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_21.unitId)

			if var0_25:CanHarvest() then
				OptionBtnDisplay(var0_0.OperationType.Harvest)
				onButton(arg0_21, arg0_21.opBtn, function()
					arg0_21.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.GAHTER_FLAG, var0_25)

					local var0_26 = {}

					for iter0_26, iter1_26 in ipairs(arg0_21.view.detectionSystem:GetAreaList()) do
						local var1_26 = arg0_21.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_26)

						table.insert(var0_26, var1_26.handDate.configId)
					end

					pg.m02:sendNotification(GAME.ISLAND_START_HANDLE_HARVEST, {
						slot_list = var0_26
					})
				end, SFX_PANEL)
				setActive(arg0_21.seedBtn, false)
			elseif var0_25:CanPlant() then
				IslandGuideChecker.CheckGuide("ISLAND_GUIDE_22")
				OptionBtnDisplay(var0_0.OperationType.Plant)
				onButton(arg0_21, arg0_21.opBtn, function()
					if not arg0_21:GetView():GetSubView(IslandSeedOpView).selectseedItemId then
						pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_seeds_empty"))

						return
					end

					local var0_27 = pg.island_farm_seed[arg0_21:GetView():GetSubView(IslandSeedOpView).selectseedItemId]
					local var1_27 = pg.island_formula[var0_27.formulaid]
					local var2_27 = #arg0_21.view.detectionSystem:GetAreaList()

					if not (function(arg0_28)
						local var0_28 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

						for iter0_28, iter1_28 in ipairs(arg0_28) do
							local var1_28 = iter1_28[1]
							local var2_28 = iter1_28[2]

							if var0_28:GetItemById(var1_28):GetCount() < var2_28 * var2_27 then
								return false
							end

							return true
						end
					end)(var1_27.cost) then
						pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_seeds_notenough"))

						return
					end

					local var3_27 = {}

					for iter0_27, iter1_27 in ipairs(arg0_21.view.detectionSystem:GetAreaList()) do
						local var4_27 = arg0_21.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_27)

						table.insert(var3_27, var4_27.handDate.configId)
					end

					pg.m02:sendNotification(GAME.ISLAND_START_HANDLE_PLANT, {
						slot_list = var3_27,
						formula_id = var0_27.formulaid
					})
					arg0_21.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.SOW_FLAG, var0_25)
				end, SFX_PANEL)

				local var1_25 = arg0_21:GetView():GetSubView(IslandSeedOpView):CheckSeedEmpty(var0_25)

				setActive(arg0_21.seedEmpty, var1_25)
				setActive(arg0_21.seedBtn, true)
				setActive(arg0_21.seedBtn:Find("seedItem"), not var1_25)

				if not var1_25 then
					onButton(arg0_21, arg0_21.seedBtn, function()
						arg0_21:GetView():GetSubView(IslandSeedOpView):ActiveSeedSelect(true)
						arg0_21:GetView():GetSubView(IslandSeedOpView):RefreshSeedPlane(var0_25)
					end, SFX_PANEL)
					arg0_21:RefreshCurrentSlectSeed()
				end
			else
				OptionBtnDisplay(var0_0.OperationType.Interaction)
				onButton(arg0_21, arg0_21.opBtn, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_being_planted"))
				end, SFX_PANEL)
				setActive(arg0_21.seedBtn, false)
			end

			local var2_25 = var0_25:GetDataVO().slotData.configId
			local var3_25 = pg.island_production_slot[var2_25].place == IslandProductConst.FarmlandPlaceId

			setActive(arg0_21.areaChangeBtn, var3_25 and getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlockAreaPlant())
		end,
		[var0_0.OperationType.MiningCollect] = function()
			var0_21()
		end,
		[var0_0.OperationType.WildGather] = function()
			local var0_32 = arg0_21.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_21.unitId)
			local var1_32 = arg0_21.view:GetIsland()

			if var1_32.id == getProxy(IslandProxy):GetIsland().id then
				OptionBtnDisplay(var0_0.OperationType.WildGather)
				onButton(arg0_21, arg0_21.opBtn, function()
					arg0_21.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.GAHTERD_FLAG, var0_32)
					var0_32:StartGather(var1_32.id)
				end, SFX_PANEL)
			elseif var0_32:CheckGatherCanSign() then
				OptionBtnDisplay(var0_0.OperationType.WildGather)
				onButton(arg0_21, arg0_21.opBtn, function()
					var0_32:StartGaherSign(var1_32.id)
				end, SFX_PANEL)
			else
				setActive(arg0_21.opBtn, false)
			end
		end,
		[var0_0.OperationType.FellCollect] = function()
			var0_21()
		end
	})
end

function var0_0.RefreshCurrentSlectSeed(arg0_36)
	local var0_36 = arg0_36.seedBtn:Find("seedItem")
	local var1_36 = arg0_36:GetView():GetSubView(IslandSeedOpView).selectseedItemId

	if not var1_36 then
		setActive(var0_36, false)

		return
	end

	setActive(var0_36, true)

	local var2_36 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var3_36 = pg.island_farm_seed[var1_36]
	local var4_36 = var2_36:GetItemById(var3_36.itemid)

	if not var4_36 then
		local var5_36

		setActive(var0_36, false)

		return
	end

	setText(var0_36:Find("count"), var4_36:GetCount())

	local var6_36 = "island/" .. var4_36:GetIcon()

	GetImageSpriteFromAtlasAsync(var6_36, "", var0_36:Find("icon"))
end

function var0_0.GetSeedBtnWorldPos(arg0_37)
	return arg0_37.seedBtn.position
end

function var0_0.TryDisablePlayerOp(arg0_38)
	arg0_38.showBalance = arg0_38.showBalance - 1

	if arg0_38.showBalance == 0 then
		arg0_38:DisablePlayerOp()
	end
end

function var0_0.TryEnablePlayerOp(arg0_39)
	arg0_39.showBalance = arg0_39.showBalance + 1

	if arg0_39.showBalance == 1 then
		arg0_39:EnablePlayerOp()
	end
end

function var0_0.ResetShowBalance(arg0_40)
	if arg0_40.showBalance ~= 1 then
		arg0_40.showBalance = 1

		arg0_40:EnablePlayerOp()
	end
end

function var0_0.DisablePlayerOp(arg0_41)
	arg0_41:ShowOrHideGameObject(arg0_41.opPanel, false)
	arg0_41:ShowOrHideGameObject(arg0_41.moveBtn, false)
	arg0_41:GetView():GetSubView(IslandInteractionView):DisableInteraction()
	arg0_41.playerInputManager:DisableInput()
	arg0_41:GetView():GetSubView(IslandDistanceView):TryDisable()
	arg0_41:GetView().player:ActiveOrDisactive(false)
end

function var0_0.EnablePlayerOp(arg0_42)
	arg0_42:ShowOrHideGameObject(arg0_42.opPanel, true)
	arg0_42:ShowOrHideGameObject(arg0_42.moveBtn, true)
	arg0_42:GetView():GetSubView(IslandInteractionView):EnableInteraction()
	arg0_42.playerInputManager:EnableInput()
	arg0_42:GetView():GetSubView(IslandDistanceView):TryEnable()
	arg0_42:GetView().player:ActiveOrDisactive(true)

	if arg0_42.inInteraction then
		arg0_42:StartInteraction()
	end
end

function var0_0.StartInteraction(arg0_43)
	arg0_43.inInteraction = true

	arg0_43:ShowOrHideGameObject(arg0_43.moveBtn, false)
	arg0_43:ShowOrHideGameObject(arg0_43.opPanel, false)
	arg0_43.playerInputManager:DisablePlayerHandle()
end

function var0_0.EndInteraction(arg0_44)
	arg0_44.inInteraction = false

	arg0_44:ShowOrHideGameObject(arg0_44.moveBtn, true)
	arg0_44:ShowOrHideGameObject(arg0_44.opPanel, true)
	arg0_44.playerInputManager:EnablePlayerHandle()
end

function var0_0.DisableInput(arg0_45)
	arg0_45.playerInputManager:DisableInput()
end

function var0_0.EnableInput(arg0_46)
	arg0_46.playerInputManager:EnableInput()
end

function var0_0.ChangeTakePhotoModel(arg0_47, arg1_47)
	if arg1_47 == IslandConst.TakePhotoModel.None then
		arg0_47:ShowOrHideMoveBtn(false)
		arg0_47.playerInputManager:DisableInput()
		arg0_47:GetView().player:ActiveOrDisactive(false)
	elseif arg1_47 == IslandConst.TakePhotoModel.First then
		arg0_47:ShowOrHideMoveBtn(true)
		arg0_47.playerInputManager:EnableInput()
		arg0_47:GetView().player:ActiveOrDisactive(true)
	else
		arg0_47:ShowOrHideMoveBtn(true)
		arg0_47.playerInputManager:EnableInput()
		arg0_47:GetView().player:ActiveOrDisactive(true)
	end
end

function var0_0.ShowOrHideMoveBtn(arg0_48, arg1_48, arg2_48)
	local var0_48 = GetOrAddComponent(arg0_48.moveBtn, typeof(CanvasGroup))

	var0_48.alpha = arg1_48 and 1 or 0
	var0_48.blocksRaycasts = arg1_48 or arg2_48
end

function var0_0.OnDestroy(arg0_49)
	if arg0_49.opUI then
		arg0_49:GetPoolMgr():ReturnOpUI(arg0_49.opUI.gameObject)

		arg0_49.opUI = nil
	end

	arg0_49:RemoveFollowerListTimer()

	arg0_49.animationOpEffectCounter = {}
end

return var0_0
