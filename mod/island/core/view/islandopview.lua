local var0_0 = class("IslandOpView", import(".IslandBaseOpView"))

var0_0.OperationType = {
	Harvest = 4,
	MiningCollect = 3,
	Interaction = 1,
	None = 0,
	Fishing = 7,
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
		arg0_2.opBtn:Find("fellCollect"),
		arg0_2.opBtn:Find("fishing")
	}
	arg0_2.seedBtn = arg0_2.opPanel:Find("seed")
	arg0_2.seedEmpty = arg0_2.seedBtn:Find("seedEmpty")
	arg0_2.areaChangeBtn = arg0_2.opPanel:Find("scope")
	arg0_2.run = arg0_2.opPanel:Find("run")
	arg0_2.moveBtn = arg0_2.opUI:Find("move")
	arg0_2.animationOpBtn = arg0_2.opPanel:Find("aniamtionop")
	arg0_2.animationOpEffect = arg0_2.animationOpBtn:Find("effect")
	arg0_2.followerBtn = arg0_2.opPanel:Find("follower")
	arg0_2.lureBtn = arg0_2.opPanel:Find("lure")
	arg0_2.lureEmptyTr = arg0_2.lureBtn:Find("empty")
	arg0_2.lureIconTr = arg0_2.lureBtn:Find("icon")
	arg0_2.lureIconTxt = arg0_2.lureBtn:Find("icon/count"):GetComponent(typeof(Text))
	arg0_2.animationOpEffectCounter = {}
	arg0_2.uiFollowerPanel = arg0_2.followerBtn:Find("list")

	local var0_2 = arg0_2.uiFollowerPanel:Find("tpl")

	arg0_2.uiFollowerList = UIItemList.New(arg0_2.uiFollowerPanel, var0_2)

	setActive(arg0_2.opPanel, true)
	setActive(arg0_2.lureBtn, false)
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
	arg0_2:UpdateLureBtn()
end

function var0_0.UpdateLureBtn(arg0_6)
	local var0_6 = arg0_6:GetSelfIsland()
	local var1_6 = var0_6:GetFishingAgency():GetBaitId()
	local var2_6 = var0_6:GetInventoryAgency()
	local var3_6 = var2_6:GetOwnCount(var1_6)

	setActive(arg0_6.lureEmptyTr, var3_6 <= 0)
	setActive(arg0_6.lureIconTr, var3_6 > 0)

	if var3_6 > 0 then
		local var4_6 = var2_6:GetItemById(var1_6)

		GetImageSpriteFromAtlasAsync("island/" .. var4_6:GetIcon(), "", arg0_6.lureIconTr)

		arg0_6.lureIconTxt.text = ""
	end

	onButton(arg0_6, arg0_6.lureBtn, function()
		if #var2_6:GetFishingItems() <= 0 then
			return
		end

		arg0_6:CreateSubView(IslandSelectLureOpView):Execute("Show")
	end, SFX_PANEL)
end

function var0_0.LaterInit(arg0_8)
	if arg0_8.showBalance < 1 then
		arg0_8:DisablePlayerOp()
	end
end

function var0_0.UpdateAnimationOpBtn(arg0_9)
	local var0_9 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	setActive(arg0_9.animationOpBtn, var0_9:HasAbility(IslandAblityAgency.ANIMATION_OP_ID))
end

function var0_0.UpdateAnimationOpEffect(arg0_10, arg1_10, arg2_10)
	if arg2_10 then
		table.insert(arg0_10.animationOpEffectCounter, arg1_10)
	else
		table.removebyvalue(arg0_10.animationOpEffectCounter, arg1_10)
	end

	local var0_10 = _.map(arg0_10.animationOpEffectCounter, function(arg0_11)
		local var0_11, var1_11 = IslandCalcUtil.GetTypeAndIdByUniqueId(arg0_11)

		return arg0_10:GetView():GetUnitModuleWithType(var0_11, var1_11)
	end)
	local var1_10 = _.detect(var0_10, function(arg0_12)
		return arg0_12 and isa(arg0_12, IslandStrollNpcUnit) and arg0_12:ExistActionFeedbackBubble()
	end)

	setActive(arg0_10.animationOpEffect, var1_10)
end

function var0_0.UpdateFollowBtn(arg0_13)
	if #getProxy(IslandProxy):GetIsland():GetFollowerAgency():GetFollowers() <= 0 or not arg0_13:IsSelfIsland() then
		setActive(arg0_13.followerBtn, false)

		return
	end

	setActive(arg0_13.followerBtn, true)
end

function var0_0.ShowFollowerList(arg0_14)
	local var0_14 = getProxy(IslandProxy):GetIsland()
	local var1_14 = var0_14:GetFollowerAgency():GetFollowers()
	local var2_14 = var0_14:GetCharacterAgency()

	if #var1_14 <= 0 then
		return
	end

	arg0_14.uiFollowerList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = var1_14[arg1_15 + 1]
			local var1_15 = var2_14:GetShipById(var0_15)
			local var2_15 = IslandShip.StaticGetPrefab(var1_15.configId)

			GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var2_15, "", arg2_15:Find("icon"))
			onButton(arg0_14, arg2_15, function()
				arg0_14:NotifiyCore(ISLAND_EVT.WILL_DEL_FOLLOWER, var1_15.id)
			end, SFX_PANEL)
		end
	end)
	arg0_14.uiFollowerList:align(#var1_14)
	setActive(arg0_14.uiFollowerPanel, true)
	arg0_14:AddDisableFollowerListTimer()
end

function var0_0.AddDisableFollowerListTimer(arg0_17)
	arg0_17:RemoveFollowerListTimer()

	arg0_17.followerTimer = Timer.New(function()
		arg0_17:RemoveFollowerListTimer()
		setActive(arg0_17.uiFollowerPanel, false)
	end, 5, 1)

	arg0_17.followerTimer:Start()
end

function var0_0.RemoveFollowerListTimer(arg0_19)
	if arg0_19.followerTimer then
		arg0_19.followerTimer:Stop()

		arg0_19.followerTimer = nil
	end
end

function var0_0.FlushFollowerList(arg0_20)
	arg0_20:UpdateFollowBtn()

	if not arg0_20.followerTimer then
		return
	end

	arg0_20:ShowFollowerList()
end

function var0_0.InitOpCustumPositon(arg0_21)
	local var0_21 = tf(GameObject.Find("UICamera/Canvas")).sizeDelta
	local var1_21 = var0_21.x / IslandSettingsConst.settingRectSize.x
	local var2_21 = var0_21.y / IslandSettingsConst.settingRectSize.y
	local var3_21 = IslandSettingsConst.ISLAND_JOY_STICK_DEFAULT_PREFERENCE
	local var4_21 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_JOYSTICK_ANCHORX, var3_21.x)
	local var5_21 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_JOYSTICK_ANCHORY, var3_21.y)

	arg0_21.moveBtn.anchoredPosition = Vector2(var4_21 * var1_21, var5_21 * var2_21)

	local var6_21 = {
		arg0_21.opBtn,
		arg0_21.opPanel:Find("jump"),
		arg0_21.areaChangeBtn,
		arg0_21.seedBtn
	}

	for iter0_21, iter1_21 in ipairs(var6_21) do
		local var7_21 = IslandSettingsConst.OPERATION_DEFAULT_PREFERENCE[iter0_21]
		local var8_21 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_OPERATION_ANCHORX[iter0_21], var7_21.x)
		local var9_21 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_OPERATION_ANCHORY[iter0_21], var7_21.y)

		iter1_21.anchoredPosition = Vector2(var8_21 * var1_21, var9_21 * var2_21)
	end

	arg0_21.lureBtn.anchoredPosition = arg0_21.seedBtn.anchoredPosition
end

function var0_0.UpdateOperationButton(arg0_22, arg1_22, arg2_22)
	if arg1_22 == var0_0.OperationType.None then
		if arg0_22.unitId == arg2_22 then
			arg0_22.unitId = nil
			arg0_22.operationType = arg1_22
		end
	else
		arg0_22.unitId = arg2_22
		arg0_22.operationType = arg1_22
	end

	arg0_22:UpdateOperationButtonDisplay()
end

function var0_0.UpdateOperationButtonDisplay(arg0_23)
	setActive(arg0_23.lureBtn, false)

	function OptionBtnDisplay(arg0_24)
		for iter0_24, iter1_24 in ipairs(arg0_23.opBtnList) do
			local var0_24 = iter0_24 == arg0_24

			setActive(iter1_24, var0_24)
		end
	end

	if arg0_23.operationType == var0_0.OperationType.None then
		setActive(arg0_23.opBtn, false)
		setActive(arg0_23.areaChangeBtn, false)
		setActive(arg0_23.seedBtn, false)
		arg0_23:GetView():GetSubView(IslandSeedOpView):ActiveSeedSelect(false)
		arg0_23:GetView():GetSubView(IslandSeedOpView):ActiveSeedDetals(false)
		OptionBtnDisplay(arg0_23.operationType)

		return
	end

	local var0_23 = arg0_23.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_23.unitId)

	if arg0_23.operationType ~= var0_0.OperationType.Fishing and not var0_23 then
		setActive(arg0_23.opBtn, false)
		setActive(arg0_23.areaChangeBtn, false)
		setActive(arg0_23.seedBtn, false)
		arg0_23:GetView():GetSubView(IslandSeedOpView):ActiveSeedSelect(false)
		arg0_23:GetView():GetSubView(IslandSeedOpView):ActiveSeedDetals(false)

		return
	end

	setActive(arg0_23.opBtn, true)

	local function var1_23()
		OptionBtnDisplay(arg0_23.operationType)
		onButton(arg0_23, arg0_23.opBtn, function()
			local var0_26 = arg0_23.view:GetCore()
			local var1_26 = arg0_23.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_23.unitId)
			local var2_26 = var1_26:GetAnimatorTrigger()

			if var1_26:CheckCanStartColloct() then
				var0_26.controller.playerInputManager:UpdataWorkStateFunc(var2_26, var1_26)
			end
		end, SFX_PANEL)
		setActive(arg0_23.areaChangeBtn, false)
		setActive(arg0_23.seedBtn, false)
	end

	switch(arg0_23.operationType, {
		[var0_0.OperationType.Plant] = function()
			local var0_27 = arg0_23.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_23.unitId)

			if var0_27:CanHarvest() then
				OptionBtnDisplay(var0_0.OperationType.Harvest)
				onButton(arg0_23, arg0_23.opBtn, function()
					arg0_23.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.GAHTER_FLAG, var0_27)

					local var0_28 = {}

					for iter0_28, iter1_28 in ipairs(arg0_23.view.detectionSystem:GetAreaList()) do
						local var1_28 = arg0_23.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_28)

						table.insert(var0_28, var1_28.handDate.configId)
					end

					pg.m02:sendNotification(GAME.ISLAND_START_HANDLE_HARVEST, {
						slot_list = var0_28
					})
				end, SFX_PANEL)
				setActive(arg0_23.seedBtn, false)
			elseif var0_27:CanPlant() then
				IslandGuideChecker.CheckGuide("ISLAND_GUIDE_22")
				OptionBtnDisplay(var0_0.OperationType.Plant)
				onButton(arg0_23, arg0_23.opBtn, function()
					if not arg0_23:GetView():GetSubView(IslandSeedOpView).selectseedItemId then
						pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_seeds_empty"))

						return
					end

					local var0_29 = pg.island_farm_seed[arg0_23:GetView():GetSubView(IslandSeedOpView).selectseedItemId]
					local var1_29 = pg.island_formula[var0_29.formulaid]
					local var2_29 = #arg0_23.view.detectionSystem:GetAreaList()

					if not (function(arg0_30)
						local var0_30 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

						for iter0_30, iter1_30 in ipairs(arg0_30) do
							local var1_30 = iter1_30[1]
							local var2_30 = iter1_30[2]

							if var0_30:GetItemById(var1_30):GetCount() < var2_30 * var2_29 then
								return false
							end

							return true
						end
					end)(var1_29.cost) then
						pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_seeds_notenough"))

						return
					end

					local var3_29 = {}

					for iter0_29, iter1_29 in ipairs(arg0_23.view.detectionSystem:GetAreaList()) do
						local var4_29 = arg0_23.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_29)

						table.insert(var3_29, var4_29.handDate.configId)
					end

					pg.m02:sendNotification(GAME.ISLAND_START_HANDLE_PLANT, {
						slot_list = var3_29,
						formula_id = var0_29.formulaid
					})
					arg0_23.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.SOW_FLAG, var0_27)
				end, SFX_PANEL)

				local var1_27 = arg0_23:GetView():GetSubView(IslandSeedOpView):CheckSeedEmpty(var0_27)

				setActive(arg0_23.seedEmpty, var1_27)
				setActive(arg0_23.seedBtn, true)
				setActive(arg0_23.seedBtn:Find("seedItem"), not var1_27)

				if not var1_27 then
					onButton(arg0_23, arg0_23.seedBtn, function()
						arg0_23:GetView():GetSubView(IslandSeedOpView):ActiveSeedSelect(true)
						arg0_23:GetView():GetSubView(IslandSeedOpView):RefreshSeedPlane(var0_27)
					end, SFX_PANEL)
					arg0_23:RefreshCurrentSlectSeed()
				end
			else
				OptionBtnDisplay(var0_0.OperationType.Interaction)
				onButton(arg0_23, arg0_23.opBtn, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_being_planted"))
				end, SFX_PANEL)
				setActive(arg0_23.seedBtn, false)
			end

			local var2_27 = var0_27:GetDataVO().slotData.configId
			local var3_27 = pg.island_production_slot[var2_27].place == IslandProductConst.FarmlandPlaceId

			setActive(arg0_23.areaChangeBtn, var3_27 and getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlockAreaPlant())
		end,
		[var0_0.OperationType.MiningCollect] = function()
			var1_23()
		end,
		[var0_0.OperationType.WildGather] = function()
			local var0_34 = arg0_23.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_23.unitId)
			local var1_34 = arg0_23.view:GetIsland()

			if var1_34.id == getProxy(IslandProxy):GetIsland().id then
				OptionBtnDisplay(var0_0.OperationType.WildGather)
				onButton(arg0_23, arg0_23.opBtn, function()
					arg0_23.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.GAHTERD_FLAG, var0_34)
					var0_34:StartGather(var1_34.id)
				end, SFX_PANEL)
			elseif var0_34:CheckGatherCanSign() then
				OptionBtnDisplay(var0_0.OperationType.WildGather)
				onButton(arg0_23, arg0_23.opBtn, function()
					var0_34:StartGaherSign(var1_34.id)
				end, SFX_PANEL)
			else
				setActive(arg0_23.opBtn, false)
			end
		end,
		[var0_0.OperationType.FellCollect] = function()
			var1_23()
		end,
		[var0_0.OperationType.Fishing] = function()
			IslandGuideChecker.CheckGuide("ISLAND_GUIDE_33")
			arg0_23:UpdateLureBtn()
			OptionBtnDisplay(arg0_23.operationType)
			setActive(arg0_23.lureBtn, true)
			onButton(arg0_23, arg0_23.opBtn, function()
				local var0_39 = arg0_23:GetSelfIsland():GetFishingAgency():GetBaitId()

				if arg0_23:GetSelfIsland():GetInventoryAgency():GetOwnCount(var0_39) <= 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_fishing_lure_empty"))
				elseif arg0_23:GetView().player:OnGrouded() then
					arg0_23:CreateSubView(IslandFishingOPView):Execute("Show", arg0_23.unitId, arg0_23.opBtn.localPosition)
				end
			end, SFX_PANEL)
		end
	})
end

function var0_0.RefreshCurrentSlectSeed(arg0_40)
	local var0_40 = arg0_40.seedBtn:Find("seedItem")
	local var1_40 = arg0_40:GetView():GetSubView(IslandSeedOpView).selectseedItemId

	if not var1_40 then
		setActive(var0_40, false)

		return
	end

	setActive(var0_40, true)

	local var2_40 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var3_40 = pg.island_farm_seed[var1_40]
	local var4_40 = var2_40:GetItemById(var3_40.itemid)

	if not var4_40 then
		local var5_40

		setActive(var0_40, false)

		return
	end

	setText(var0_40:Find("count"), var4_40:GetCount())

	local var6_40 = "island/" .. var4_40:GetIcon()

	GetImageSpriteFromAtlasAsync(var6_40, "", var0_40:Find("icon"))
end

function var0_0.GetSeedBtnWorldPos(arg0_41)
	return arg0_41.seedBtn.position
end

function var0_0.TryDisablePlayerOp(arg0_42)
	arg0_42.showBalance = arg0_42.showBalance - 1

	if arg0_42.showBalance == 0 then
		arg0_42:DisablePlayerOp()
	end
end

function var0_0.TryEnablePlayerOp(arg0_43)
	arg0_43.showBalance = arg0_43.showBalance + 1

	if arg0_43.showBalance == 1 then
		arg0_43:EnablePlayerOp()
	end
end

function var0_0.ResetShowBalance(arg0_44)
	if arg0_44.showBalance ~= 1 then
		arg0_44.showBalance = 1

		arg0_44:EnablePlayerOp()
	end
end

function var0_0.DisablePlayerOp(arg0_45)
	arg0_45:ShowOrHideGameObject(arg0_45.opPanel, false)
	arg0_45:ShowOrHideGameObject(arg0_45.moveBtn, false)
	arg0_45:GetView():GetSubView(IslandInteractionView):DisableInteraction()
	arg0_45.playerInputManager:DisableInput()
	arg0_45:GetView():GetSubView(IslandDistanceView):TryDisable()
	arg0_45:GetView().player:ActiveOrDisactive(false)
end

function var0_0.EnablePlayerOp(arg0_46)
	arg0_46:ShowOrHideGameObject(arg0_46.opPanel, true)
	arg0_46:ShowOrHideGameObject(arg0_46.moveBtn, true)
	arg0_46:GetView():GetSubView(IslandInteractionView):EnableInteraction()
	arg0_46.playerInputManager:EnableInput()
	arg0_46:GetView():GetSubView(IslandDistanceView):TryEnable()
	arg0_46:GetView().player:ActiveOrDisactive(true)

	if arg0_46.inInteraction then
		arg0_46:StartInteraction()
	end
end

function var0_0.StartInteraction(arg0_47)
	arg0_47.inInteraction = true

	arg0_47:ShowOrHideGameObject(arg0_47.moveBtn, false)
	arg0_47:ShowOrHideGameObject(arg0_47.opPanel, false)
	arg0_47.playerInputManager:DisablePlayerHandle()
	arg0_47:GetView().player:StopMoveHandle()
end

function var0_0.EndInteraction(arg0_48)
	arg0_48.inInteraction = false

	arg0_48:ShowOrHideGameObject(arg0_48.moveBtn, true)
	arg0_48:ShowOrHideGameObject(arg0_48.opPanel, true)
	arg0_48.playerInputManager:EnablePlayerHandle()
end

function var0_0.DisableInput(arg0_49)
	arg0_49.playerInputManager:DisableInput()
end

function var0_0.EnableInput(arg0_50)
	arg0_50.playerInputManager:EnableInput()
end

function var0_0.ChangeTakePhotoModel(arg0_51, arg1_51, arg2_51)
	if arg1_51 == IslandConst.TakePhotoModel.None then
		if not arg2_51 then
			arg0_51:ShowOrHideMoveBtn(false)
			arg0_51.playerInputManager:DisableInput()
			arg0_51:GetView().player:ActiveOrDisactive(false)
		end
	elseif arg1_51 == IslandConst.TakePhotoModel.First then
		arg0_51:ShowOrHideMoveBtn(true)
		arg0_51.playerInputManager:EnableInput()
		arg0_51:GetView().player:ActiveOrDisactive(true)
	else
		arg0_51:ShowOrHideMoveBtn(true)
		arg0_51.playerInputManager:EnableInput()
		arg0_51:GetView().player:ActiveOrDisactive(true)
	end
end

function var0_0.ShowOrHideMoveBtn(arg0_52, arg1_52, arg2_52)
	local var0_52 = GetOrAddComponent(arg0_52.moveBtn, typeof(CanvasGroup))

	var0_52.alpha = arg1_52 and 1 or 0
	var0_52.blocksRaycasts = arg1_52 or arg2_52
end

function var0_0.OnDestroy(arg0_53)
	if arg0_53.opUI then
		arg0_53:GetPoolMgr():ReturnOpUI(arg0_53.opUI.gameObject)

		arg0_53.opUI = nil
	end

	arg0_53:RemoveFollowerListTimer()

	arg0_53.animationOpEffectCounter = {}
end

return var0_0
