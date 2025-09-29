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

	arg0_2.showBalance = 1
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
	arg0_2.followerBtn = arg0_2.opPanel:Find("follower")

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

function var0_0.UpdateAnimationOpBtn(arg0_6)
	local var0_6 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	setActive(arg0_6.animationOpBtn, var0_6:HasAbility(IslandAblityAgency.ANIMATION_OP_ID))
end

function var0_0.UpdateFollowBtn(arg0_7)
	if #getProxy(IslandProxy):GetIsland():GetFollowerAgency():GetFollowers() <= 0 or not arg0_7:IsSelfIsland() then
		setActive(arg0_7.followerBtn, false)

		return
	end

	setActive(arg0_7.followerBtn, true)
end

function var0_0.ShowFollowerList(arg0_8)
	local var0_8 = getProxy(IslandProxy):GetIsland()
	local var1_8 = var0_8:GetFollowerAgency():GetFollowers()
	local var2_8 = var0_8:GetCharacterAgency()

	if #var1_8 <= 0 then
		return
	end

	arg0_8.uiFollowerList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = var1_8[arg1_9 + 1]
			local var1_9 = var2_8:GetShipById(var0_9)
			local var2_9 = IslandShip.StaticGetPrefab(var1_9.configId)

			GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var2_9, "", arg2_9:Find("icon"))
			onButton(arg0_8, arg2_9, function()
				arg0_8:NotifiyMeditor(IslandMediator.DEL_FOLLOWER, var1_9.id)
			end, SFX_PANEL)
		end
	end)
	arg0_8.uiFollowerList:align(#var1_8)
	setActive(arg0_8.uiFollowerPanel, true)
	arg0_8:AddDisableFollowerListTimer()
end

function var0_0.AddDisableFollowerListTimer(arg0_11)
	arg0_11:RemoveFollowerListTimer()

	arg0_11.followerTimer = Timer.New(function()
		arg0_11:RemoveFollowerListTimer()
		setActive(arg0_11.uiFollowerPanel, false)
	end, 5, 1)

	arg0_11.followerTimer:Start()
end

function var0_0.RemoveFollowerListTimer(arg0_13)
	if arg0_13.followerTimer then
		arg0_13.followerTimer:Stop()

		arg0_13.followerTimer = nil
	end
end

function var0_0.FlushFollowerList(arg0_14)
	arg0_14:UpdateFollowBtn()

	if not arg0_14.followerTimer then
		return
	end

	arg0_14:ShowFollowerList()
end

function var0_0.InitOpCustumPositon(arg0_15)
	local var0_15 = tf(GameObject.Find("UICamera/Canvas")).sizeDelta
	local var1_15 = var0_15.x / IslandSettingsConst.settingRectSize.x
	local var2_15 = var0_15.y / IslandSettingsConst.settingRectSize.y
	local var3_15 = IslandSettingsConst.ISLAND_JOY_STICK_DEFAULT_PREFERENCE
	local var4_15 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_JOYSTICK_ANCHORX, var3_15.x)
	local var5_15 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_JOYSTICK_ANCHORY, var3_15.y)

	arg0_15.moveBtn.anchoredPosition = Vector2(var4_15 * var1_15, var5_15 * var2_15)

	local var6_15 = {
		arg0_15.opBtn,
		arg0_15.opPanel:Find("jump"),
		arg0_15.areaChangeBtn,
		arg0_15.seedBtn
	}

	for iter0_15, iter1_15 in ipairs(var6_15) do
		local var7_15 = IslandSettingsConst.OPERATION_DEFAULT_PREFERENCE[iter0_15]
		local var8_15 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_OPERATION_ANCHORX[iter0_15], var7_15.x)
		local var9_15 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_OPERATION_ANCHORY[iter0_15], var7_15.y)

		iter1_15.anchoredPosition = Vector2(var8_15 * var1_15, var9_15 * var2_15)
	end
end

function var0_0.UpdateOperationButton(arg0_16, arg1_16, arg2_16)
	if arg1_16 == var0_0.OperationType.None then
		if arg0_16.unitId == arg2_16 then
			arg0_16.unitId = nil
			arg0_16.operationType = arg1_16
		end
	else
		arg0_16.unitId = arg2_16
		arg0_16.operationType = arg1_16
	end

	arg0_16:UpdateOperationButtonDisplay()
end

function var0_0.UpdateOperationButtonDisplay(arg0_17)
	if arg0_17.operationType == var0_0.OperationType.None then
		setActive(arg0_17.opBtn, false)
		setActive(arg0_17.areaChangeBtn, false)
		setActive(arg0_17.seedBtn, false)
		arg0_17:GetView():GetSubView(IslandSeedOpView):ActiveSeedSelect(false)
		arg0_17:GetView():GetSubView(IslandSeedOpView):ActiveSeedDetals(false)

		return
	end

	function OptionBtnDisplay(arg0_18)
		for iter0_18, iter1_18 in ipairs(arg0_17.opBtnList) do
			local var0_18 = iter0_18 == arg0_18

			setActive(iter1_18, var0_18)
		end
	end

	if not arg0_17.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_17.unitId) then
		setActive(arg0_17.opBtn, false)
		setActive(arg0_17.areaChangeBtn, false)
		setActive(arg0_17.seedBtn, false)
		arg0_17:GetView():GetSubView(IslandSeedOpView):ActiveSeedSelect(false)
		arg0_17:GetView():GetSubView(IslandSeedOpView):ActiveSeedDetals(false)

		return
	end

	setActive(arg0_17.opBtn, true)

	local function var0_17()
		OptionBtnDisplay(arg0_17.operationType)
		onButton(arg0_17, arg0_17.opBtn, function()
			local var0_20 = arg0_17.view:GetCore()
			local var1_20 = arg0_17.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_17.unitId)
			local var2_20 = var1_20:GetAnimatorTrigger()

			if var1_20:CheckCanStartColloct() then
				var0_20.controller.playerInputManager:UpdataWorkStateFunc(var2_20, var1_20)
			end
		end, SFX_PANEL)
		setActive(arg0_17.areaChangeBtn, false)
		setActive(arg0_17.seedBtn, false)
	end

	switch(arg0_17.operationType, {
		[var0_0.OperationType.Plant] = function()
			local var0_21 = arg0_17.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_17.unitId)

			if var0_21:CanHarvest() then
				OptionBtnDisplay(var0_0.OperationType.Harvest)
				onButton(arg0_17, arg0_17.opBtn, function()
					arg0_17.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.GAHTER_FLAG, var0_21)

					local var0_22 = {}

					for iter0_22, iter1_22 in ipairs(arg0_17.view.detectionSystem:GetAreaList()) do
						local var1_22 = arg0_17.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_22)

						table.insert(var0_22, var1_22.handDate.configId)
					end

					pg.m02:sendNotification(GAME.ISLAND_START_HANDLE_HARVEST, {
						slot_list = var0_22
					})
				end, SFX_PANEL)
				setActive(arg0_17.seedBtn, false)
			elseif var0_21:CanPlant() then
				IslandGuideChecker.CheckGuide("ISLAND_GUIDE_22")
				OptionBtnDisplay(var0_0.OperationType.Plant)
				onButton(arg0_17, arg0_17.opBtn, function()
					if not arg0_17:GetView():GetSubView(IslandSeedOpView).selectseedItemId then
						pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_seeds_empty"))

						return
					end

					local var0_23 = pg.island_farm_seed[arg0_17:GetView():GetSubView(IslandSeedOpView).selectseedItemId]
					local var1_23 = pg.island_formula[var0_23.formulaid]
					local var2_23 = #arg0_17.view.detectionSystem:GetAreaList()

					if not (function(arg0_24)
						local var0_24 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

						for iter0_24, iter1_24 in ipairs(arg0_24) do
							local var1_24 = iter1_24[1]
							local var2_24 = iter1_24[2]

							if var0_24:GetItemById(var1_24):GetCount() < var2_24 * var2_23 then
								return false
							end

							return true
						end
					end)(var1_23.cost) then
						pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_seeds_notenough"))

						return
					end

					local var3_23 = {}

					for iter0_23, iter1_23 in ipairs(arg0_17.view.detectionSystem:GetAreaList()) do
						local var4_23 = arg0_17.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_23)

						table.insert(var3_23, var4_23.handDate.configId)
					end

					pg.m02:sendNotification(GAME.ISLAND_START_HANDLE_PLANT, {
						slot_list = var3_23,
						formula_id = var0_23.formulaid
					})
					arg0_17.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.SOW_FLAG, var0_21)
				end, SFX_PANEL)

				local var1_21 = arg0_17:GetView():GetSubView(IslandSeedOpView):CheckSeedEmpty(var0_21)

				setActive(arg0_17.seedEmpty, var1_21)
				setActive(arg0_17.seedBtn, true)
				setActive(arg0_17.seedBtn:Find("seedItem"), not var1_21)

				if not var1_21 then
					onButton(arg0_17, arg0_17.seedBtn, function()
						arg0_17:GetView():GetSubView(IslandSeedOpView):ActiveSeedSelect(true)
						arg0_17:GetView():GetSubView(IslandSeedOpView):RefreshSeedPlane(var0_21)
					end, SFX_PANEL)
					arg0_17:RefreshCurrentSlectSeed()
				end
			else
				OptionBtnDisplay(var0_0.OperationType.Interaction)
				onButton(arg0_17, arg0_17.opBtn, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_being_planted"))
				end, SFX_PANEL)
				setActive(arg0_17.seedBtn, false)
			end

			local var2_21 = var0_21:GetDataVO().slotData.configId
			local var3_21 = pg.island_production_slot[var2_21].place == IslandProductConst.FarmlandPlaceId

			setActive(arg0_17.areaChangeBtn, var3_21 and getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlockAreaPlant())
		end,
		[var0_0.OperationType.MiningCollect] = function()
			var0_17()
		end,
		[var0_0.OperationType.WildGather] = function()
			local var0_28 = arg0_17.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_17.unitId)
			local var1_28 = arg0_17.view:GetIsland()

			if var1_28.id == getProxy(IslandProxy):GetIsland().id then
				OptionBtnDisplay(var0_0.OperationType.WildGather)
				onButton(arg0_17, arg0_17.opBtn, function()
					arg0_17.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.GAHTERD_FLAG, var0_28)
					var0_28:StartGather(var1_28.id)
				end, SFX_PANEL)
			elseif var0_28:CheckGatherCanSign() then
				OptionBtnDisplay(var0_0.OperationType.WildGather)
				onButton(arg0_17, arg0_17.opBtn, function()
					var0_28:StartGaherSign(var1_28.id)
				end, SFX_PANEL)
			else
				setActive(arg0_17.opBtn, false)
			end
		end,
		[var0_0.OperationType.FellCollect] = function()
			var0_17()
		end
	})
end

function var0_0.RefreshCurrentSlectSeed(arg0_32)
	local var0_32 = arg0_32.seedBtn:Find("seedItem")
	local var1_32 = arg0_32:GetView():GetSubView(IslandSeedOpView).selectseedItemId

	if not var1_32 then
		setActive(var0_32, false)

		return
	end

	setActive(var0_32, true)

	local var2_32 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var3_32 = pg.island_farm_seed[var1_32]
	local var4_32 = var2_32:GetItemById(var3_32.itemid)

	if not var4_32 then
		local var5_32

		setActive(var0_32, false)

		return
	end

	setText(var0_32:Find("count"), var4_32:GetCount())

	local var6_32 = "island/" .. var4_32:GetIcon()

	GetImageSpriteFromAtlasAsync(var6_32, "", var0_32:Find("icon"))
end

function var0_0.GetSeedBtnWorldPos(arg0_33)
	return arg0_33.seedBtn.position
end

function var0_0.TryDisablePlayerOp(arg0_34)
	arg0_34.showBalance = arg0_34.showBalance - 1

	if arg0_34.showBalance == 0 then
		arg0_34:DisablePlayerOp()
	end
end

function var0_0.TryEnablePlayerOp(arg0_35)
	arg0_35.showBalance = arg0_35.showBalance + 1

	if arg0_35.showBalance == 1 then
		arg0_35:EnablePlayerOp()
	end
end

function var0_0.ResetShowBalance(arg0_36)
	if arg0_36.showBalance ~= 1 then
		arg0_36.showBalance = 1

		arg0_36:EnablePlayerOp()
	end
end

function var0_0.DisablePlayerOp(arg0_37)
	arg0_37:ShowOrHideGameObject(arg0_37.opPanel, false)
	arg0_37:ShowOrHideGameObject(arg0_37.moveBtn, false)
	arg0_37:GetView():GetSubView(IslandInteractionView):DisableInteraction()
	arg0_37.playerInputManager:DisableInput()
	arg0_37:GetView():GetSubView(IslandDistanceView):TryDisable()
	arg0_37:GetView().player:ActiveOrDisactive(false)
end

function var0_0.EnablePlayerOp(arg0_38)
	arg0_38:ShowOrHideGameObject(arg0_38.opPanel, true)
	arg0_38:ShowOrHideGameObject(arg0_38.moveBtn, true)
	arg0_38:GetView():GetSubView(IslandInteractionView):EnableInteraction()
	arg0_38.playerInputManager:EnableInput()
	arg0_38:GetView():GetSubView(IslandDistanceView):TryEnable()
	arg0_38:GetView().player:ActiveOrDisactive(true)

	if arg0_38.inInteraction then
		arg0_38:StartInteraction()
	end
end

function var0_0.StartInteraction(arg0_39)
	arg0_39.inInteraction = true

	arg0_39:ShowOrHideGameObject(arg0_39.moveBtn, false)
	arg0_39:ShowOrHideGameObject(arg0_39.opPanel, false)
	arg0_39.playerInputManager:DisablePlayerHandle()
end

function var0_0.EndInteraction(arg0_40)
	arg0_40.inInteraction = false

	arg0_40:ShowOrHideGameObject(arg0_40.moveBtn, true)
	arg0_40:ShowOrHideGameObject(arg0_40.opPanel, true)
	arg0_40.playerInputManager:EnablePlayerHandle()
end

function var0_0.DisableInput(arg0_41)
	arg0_41.playerInputManager:DisableInput()
end

function var0_0.EnableInput(arg0_42)
	arg0_42.playerInputManager:EnableInput()
end

function var0_0.ChangeTakePhotoModel(arg0_43, arg1_43)
	if arg1_43 == IslandConst.TakePhotoModel.None then
		arg0_43:ShowOrHideMoveBtn(false)
		arg0_43.playerInputManager:DisableInput()
		arg0_43:GetView().player:ActiveOrDisactive(false)
	elseif arg1_43 == IslandConst.TakePhotoModel.First then
		arg0_43:ShowOrHideMoveBtn(true)
		arg0_43.playerInputManager:EnableInput()
		arg0_43:GetView().player:ActiveOrDisactive(true)
	else
		arg0_43:ShowOrHideMoveBtn(true)
		arg0_43.playerInputManager:EnableInput()
		arg0_43:GetView().player:ActiveOrDisactive(true)
	end
end

function var0_0.ShowOrHideMoveBtn(arg0_44, arg1_44, arg2_44)
	local var0_44 = GetOrAddComponent(arg0_44.moveBtn, typeof(CanvasGroup))

	var0_44.alpha = arg1_44 and 1 or 0
	var0_44.blocksRaycasts = arg1_44 or arg2_44
end

function var0_0.OnDestroy(arg0_45)
	if arg0_45.opUI then
		arg0_45:GetPoolMgr():ReturnOpUI(arg0_45.opUI.gameObject)

		arg0_45.opUI = nil
	end

	arg0_45:RemoveFollowerListTimer()
end

return var0_0
