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
	arg0_2.morphBtn = arg0_2.opPanel:Find("morph")
	arg0_2.seedBtn = arg0_2.opPanel:Find("seed")
	arg0_2.seedEmpty = arg0_2.seedBtn:Find("seedEmpty")
	arg0_2.areaChangeBtn = arg0_2.opPanel:Find("scope")
	arg0_2.run = arg0_2.opPanel:Find("run")
	arg0_2.moveBtn = arg0_2.opUI:Find("move")
	arg0_2.animationOpBtn = arg0_2.opPanel:Find("aniamtionop")
	arg0_2.animationOpEffect = arg0_2.animationOpBtn:Find("effect")
	arg0_2.animationOpSkillTip = arg0_2.animationOpBtn:Find("tip")
	arg0_2.animationOpSkillEffect = arg0_2.animationOpBtn:Find("effect_skill")
	arg0_2.followerBtn = arg0_2.opPanel:Find("follower")
	arg0_2.lureBtn = arg0_2.opPanel:Find("lure")
	arg0_2.lureEmptyTr = arg0_2.lureBtn:Find("empty")
	arg0_2.lureIconTr = arg0_2.lureBtn:Find("icon")
	arg0_2.lureIconTxt = arg0_2.lureBtn:Find("icon/count"):GetComponent(typeof(Text))
	arg0_2.animationOpEffectCounter = {}
	arg0_2.morphing = false
	arg0_2.uiFollowerPanel = arg0_2.followerBtn:Find("list")

	local var0_2 = arg0_2.uiFollowerPanel:Find("tpl")

	arg0_2.uiFollowerList = UIItemList.New(arg0_2.uiFollowerPanel, var0_2)

	setActive(arg0_2.opPanel, true)
	setActive(arg0_2.lureBtn, false)
	onButton(arg0_2, arg0_2.areaChangeBtn, function()
		arg0_2:NotifiyCore(ISLAND_EVT.AREACHANGE)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.morphBtn, function()
		arg0_2:OnMorphBtnClick()
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
	arg0_2:UpdateMorphBtn()
end

function var0_0.GetMorphBodyIds(arg0_7)
	local var0_7 = getProxy(IslandProxy):GetIsland()

	if not var0_7 then
		return 0, 0
	end

	local var1_7 = var0_7:GetDressUpAgency()

	if not var1_7 then
		return 0, 0
	end

	local var2_7 = var1_7:GetDressByType(IslandShipDressHelperNew.DressType.Body) or 0

	if var2_7 == 0 then
		return 0, 0
	end

	return var2_7, var1_7:GetMorphTargetId(var2_7) or 0
end

function var0_0.CanShowMorphBtn(arg0_8)
	local var0_8, var1_8 = arg0_8:GetMorphBodyIds()

	return arg0_8:IsSelfIsland() and var1_8 ~= 0
end

function var0_0.IsPlayerIdleForMorph(arg0_9)
	local var0_9 = arg0_9:GetView().player

	if not var0_9 then
		return false
	end

	if arg0_9.morphing then
		return false
	end

	if var0_9.cantMove then
		return false
	end

	if var0_9.isNavigating then
		return false
	end

	if var0_9.targetSpeed and not Mathf.Approximately(var0_9.targetSpeed, 0) then
		return false
	end

	if var0_9.OnGrouded and not var0_9:OnGrouded() then
		return false
	end

	local var1_9 = var0_9.GetAnimator and var0_9:GetAnimator() or var0_9.animator

	if var1_9 then
		local var2_9 = var1_9:GetCurrentAnimatorStateInfo(0)

		if var1_9:IsInTransition(0) then
			return false
		end

		if _.any(IslandConst.CANT_SWITCH_TO_MOVEMENT_STATES, function(arg0_10)
			return var2_9:IsName(arg0_10)
		end) then
			return false
		end
	end

	return true
end

function var0_0.UpdateMorphBtn(arg0_11)
	if not arg0_11.morphBtn then
		return
	end

	local var0_11 = arg0_11:CanShowMorphBtn()

	setActive(arg0_11.morphBtn, var0_11)

	if not var0_11 then
		return
	end

	local var1_11 = arg0_11:IsPlayerIdleForMorph()
	local var2_11 = arg0_11.morphBtn:GetComponent(typeof(UnityEngine.UI.Button))

	if var2_11 then
		var2_11.interactable = var1_11
	end

	local var3_11 = arg0_11.morphBtn:Find("icon_normal")
	local var4_11 = arg0_11.morphBtn:Find("icon_gray")

	if var3_11 then
		setActive(var3_11, var1_11)
	end

	if var4_11 then
		setActive(var4_11, not var1_11)
	end
end

function var0_0.StartMorphFreeze(arg0_12)
	if arg0_12.morphFreeze then
		return
	end

	arg0_12.morphFreeze = true

	arg0_12:NotifiyCore(ISLAND_EVT.DISABLE_INPUT)
	pg.UIMgr.GetInstance():LoadingOn(false)
end

function var0_0.StopMorphFreeze(arg0_13)
	if not arg0_13.morphFreeze then
		return
	end

	arg0_13.morphFreeze = false

	pg.UIMgr.GetInstance():LoadingOff()
	arg0_13:NotifiyCore(ISLAND_EVT.ENABLE_INPUT)
end

function var0_0.ResetMorphing(arg0_14)
	arg0_14.morphing = false
	arg0_14.morphTargetBodyId = nil

	arg0_14:StopMorphFreeze()
	arg0_14:UpdateMorphBtn()
end

function var0_0.OnMorphBtnClick(arg0_15)
	if not arg0_15:CanShowMorphBtn() then
		return
	end

	if not arg0_15:IsPlayerIdleForMorph() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_morph_not_idle"))

		return
	end

	local var0_15, var1_15 = arg0_15:GetMorphBodyIds()

	if var0_15 == 0 or var1_15 == 0 then
		return
	end

	arg0_15.morphing = true
	arg0_15.morphTargetBodyId = var1_15

	arg0_15:StartMorphFreeze()
	arg0_15:UpdateMorphBtn()
	pg.m02:sendNotification(GAME.ISLAND_MORPH_FORM_CHANGE, {
		fromBodyDressId = var0_15,
		toBodyDressId = var1_15,
		callback = function()
			arg0_15:ResetMorphing()
		end
	})
end

function var0_0.UpdateLureBtn(arg0_17)
	local var0_17 = arg0_17:GetSelfIsland()
	local var1_17 = var0_17:GetFishingAgency():GetBaitId()
	local var2_17 = var0_17:GetInventoryAgency()
	local var3_17 = var2_17:GetOwnCount(var1_17)

	setActive(arg0_17.lureEmptyTr, var3_17 <= 0)
	setActive(arg0_17.lureIconTr, var3_17 > 0)

	if var3_17 > 0 then
		local var4_17 = var2_17:GetItemById(var1_17)

		GetImageSpriteFromAtlasAsync("island/" .. var4_17:GetIcon(), "", arg0_17.lureIconTr)

		arg0_17.lureIconTxt.text = ""
	end

	onButton(arg0_17, arg0_17.lureBtn, function()
		if #var2_17:GetFishingItems() <= 0 then
			return
		end

		arg0_17:CreateSubView(IslandSelectLureOpView):Execute("Show")
	end, SFX_PANEL)
end

function var0_0.LaterInit(arg0_19)
	if arg0_19.showBalance < 1 then
		arg0_19:DisablePlayerOp()
	end
end

function var0_0.UpdateAnimationOpBtn(arg0_20)
	local var0_20 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

	setActive(arg0_20.animationOpBtn, var0_20:HasAbility(IslandAblityAgency.ANIMATION_OP_ID))
end

function var0_0.Update(arg0_21)
	var0_0.super.Update(arg0_21)
	arg0_21:UpdateMorphBtn()
end

function var0_0.UpdateAnimationOpEffect(arg0_22, arg1_22, arg2_22)
	if arg2_22 then
		table.insert(arg0_22.animationOpEffectCounter, arg1_22)
	else
		table.removebyvalue(arg0_22.animationOpEffectCounter, arg1_22)
	end

	local var0_22 = _.map(arg0_22.animationOpEffectCounter, function(arg0_23)
		local var0_23, var1_23 = IslandCalcUtil.GetTypeAndIdByUniqueId(arg0_23)

		return arg0_22:GetView():GetUnitModuleWithType(var0_23, var1_23)
	end)
	local var1_22 = _.detect(var0_22, function(arg0_24)
		return arg0_24 and isa(arg0_24, IslandStrollNpcUnit) and arg0_24.data:ExistGreetingActionFeedback()
	end)
	local var2_22 = var1_22 ~= nil
	local var3_22 = var2_22 and var1_22.data:OnlySkillActionFeedback()
	local var4_22 = var2_22 and var1_22.data:ExistSkillActionFeedback()

	setActive(arg0_22.animationOpSkillEffect, var3_22)
	setActive(arg0_22.animationOpEffect, var2_22 and not var3_22)
	setActive(arg0_22.animationOpSkillTip, var4_22)
end

function var0_0.UpdateFollowBtn(arg0_25)
	if #getProxy(IslandProxy):GetIsland():GetFollowerAgency():GetFollowers() <= 0 or not arg0_25:IsSelfIsland() then
		setActive(arg0_25.followerBtn, false)

		return
	end

	setActive(arg0_25.followerBtn, true)
end

function var0_0.ShowFollowerList(arg0_26)
	local var0_26 = getProxy(IslandProxy):GetIsland()
	local var1_26 = var0_26:GetFollowerAgency():GetFollowers()
	local var2_26 = var0_26:GetCharacterAgency()

	if #var1_26 <= 0 then
		return
	end

	arg0_26.uiFollowerList:make(function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			local var0_27 = var1_26[arg1_27 + 1]
			local var1_27 = var2_26:GetShipById(var0_27)
			local var2_27 = IslandShip.StaticGetPrefab(var1_27.configId)

			GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var2_27, "", arg2_27:Find("icon"))
			onButton(arg0_26, arg2_27, function()
				arg0_26:NotifiyCore(ISLAND_EVT.WILL_DEL_FOLLOWER, var1_27.id)
			end, SFX_PANEL)
		end
	end)
	arg0_26.uiFollowerList:align(#var1_26)
	setActive(arg0_26.uiFollowerPanel, true)
	arg0_26:AddDisableFollowerListTimer()
end

function var0_0.AddDisableFollowerListTimer(arg0_29)
	arg0_29:RemoveFollowerListTimer()

	arg0_29.followerTimer = Timer.New(function()
		arg0_29:RemoveFollowerListTimer()
		setActive(arg0_29.uiFollowerPanel, false)
	end, 5, 1)

	arg0_29.followerTimer:Start()
end

function var0_0.RemoveFollowerListTimer(arg0_31)
	if arg0_31.followerTimer then
		arg0_31.followerTimer:Stop()

		arg0_31.followerTimer = nil
	end
end

function var0_0.FlushFollowerList(arg0_32)
	arg0_32:UpdateFollowBtn()

	if not arg0_32.followerTimer then
		return
	end

	arg0_32:ShowFollowerList()
end

function var0_0.InitOpCustumPositon(arg0_33)
	local var0_33 = tf(GameObject.Find("UICamera/Canvas")).sizeDelta
	local var1_33 = var0_33.x / IslandSettingsConst.settingRectSize.x
	local var2_33 = var0_33.y / IslandSettingsConst.settingRectSize.y
	local var3_33 = IslandSettingsConst.ISLAND_JOY_STICK_DEFAULT_PREFERENCE
	local var4_33 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_JOYSTICK_ANCHORX, var3_33.x)
	local var5_33 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_JOYSTICK_ANCHORY, var3_33.y)

	arg0_33.moveBtn.anchoredPosition = Vector2(var4_33 * var1_33, var5_33 * var2_33)

	local var6_33 = {
		arg0_33.opBtn,
		arg0_33.opPanel:Find("jump"),
		arg0_33.areaChangeBtn,
		arg0_33.seedBtn
	}

	for iter0_33, iter1_33 in ipairs(var6_33) do
		local var7_33 = IslandSettingsConst.OPERATION_DEFAULT_PREFERENCE[iter0_33]
		local var8_33 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_OPERATION_ANCHORX[iter0_33], var7_33.x)
		local var9_33 = PlayerPrefs.GetFloat(IslandSettingsConst.ISLAND_KEY_OPERATION_ANCHORY[iter0_33], var7_33.y)

		iter1_33.anchoredPosition = Vector2(var8_33 * var1_33, var9_33 * var2_33)
	end

	arg0_33.lureBtn.anchoredPosition = arg0_33.seedBtn.anchoredPosition
end

function var0_0.UpdateOperationButton(arg0_34, arg1_34, arg2_34)
	if arg1_34 == var0_0.OperationType.None then
		if arg0_34.unitId == arg2_34 then
			arg0_34.unitId = nil
			arg0_34.operationType = arg1_34
		end
	else
		arg0_34.unitId = arg2_34
		arg0_34.operationType = arg1_34
	end

	arg0_34:UpdateOperationButtonDisplay()
end

function var0_0.UpdateOperationButtonDisplay(arg0_35)
	setActive(arg0_35.lureBtn, false)

	function OptionBtnDisplay(arg0_36)
		for iter0_36, iter1_36 in ipairs(arg0_35.opBtnList) do
			local var0_36 = iter0_36 == arg0_36

			setActive(iter1_36, var0_36)
		end
	end

	if arg0_35.operationType == var0_0.OperationType.None then
		setActive(arg0_35.opBtn, false)
		setActive(arg0_35.areaChangeBtn, false)
		setActive(arg0_35.seedBtn, false)
		arg0_35:GetView():GetSubView(IslandSeedOpView):ActiveSeedSelect(false)
		arg0_35:GetView():GetSubView(IslandSeedOpView):ActiveSeedDetals(false)
		OptionBtnDisplay(arg0_35.operationType)

		return
	end

	local var0_35 = arg0_35.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_35.unitId)

	if arg0_35.operationType ~= var0_0.OperationType.Fishing and not var0_35 then
		setActive(arg0_35.opBtn, false)
		setActive(arg0_35.areaChangeBtn, false)
		setActive(arg0_35.seedBtn, false)
		arg0_35:GetView():GetSubView(IslandSeedOpView):ActiveSeedSelect(false)
		arg0_35:GetView():GetSubView(IslandSeedOpView):ActiveSeedDetals(false)

		return
	end

	setActive(arg0_35.opBtn, true)

	local function var1_35()
		OptionBtnDisplay(arg0_35.operationType)
		onButton(arg0_35, arg0_35.opBtn, function()
			local var0_38 = arg0_35.view:GetCore()
			local var1_38 = arg0_35.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_35.unitId)
			local var2_38 = var1_38:GetAnimatorTrigger()

			if var1_38:CheckCanStartColloct() then
				var0_38.controller.playerInputManager:UpdataWorkStateFunc(var2_38, var1_38)
			end
		end, SFX_PANEL)
		setActive(arg0_35.areaChangeBtn, false)
		setActive(arg0_35.seedBtn, false)
	end

	switch(arg0_35.operationType, {
		[var0_0.OperationType.Plant] = function()
			local var0_39 = arg0_35.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_35.unitId)

			if var0_39:CanHarvest() then
				OptionBtnDisplay(var0_0.OperationType.Harvest)
				onButton(arg0_35, arg0_35.opBtn, function()
					arg0_35.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.GAHTER_FLAG, var0_39)

					local var0_40 = {}

					for iter0_40, iter1_40 in ipairs(arg0_35.view.detectionSystem:GetAreaList()) do
						local var1_40 = arg0_35.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_40)

						table.insert(var0_40, var1_40.handDate.configId)
					end

					pg.m02:sendNotification(GAME.ISLAND_START_HANDLE_HARVEST, {
						slot_list = var0_40
					})
				end, SFX_PANEL)
				setActive(arg0_35.seedBtn, false)
			elseif var0_39:CanPlant() then
				IslandGuideChecker.CheckGuide("ISLAND_GUIDE_22")
				OptionBtnDisplay(var0_0.OperationType.Plant)
				onButton(arg0_35, arg0_35.opBtn, function()
					if not arg0_35:GetView():GetSubView(IslandSeedOpView).selectseedItemId then
						pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_seeds_empty"))

						return
					end

					local var0_41 = pg.island_farm_seed[arg0_35:GetView():GetSubView(IslandSeedOpView).selectseedItemId]
					local var1_41 = pg.island_formula[var0_41.formulaid]
					local var2_41 = #arg0_35.view.detectionSystem:GetAreaList()

					if not (function(arg0_42)
						local var0_42 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

						for iter0_42, iter1_42 in ipairs(arg0_42) do
							local var1_42 = iter1_42[1]
							local var2_42 = iter1_42[2]

							if var0_42:GetItemById(var1_42):GetCount() < var2_42 * var2_41 then
								return false
							end

							return true
						end
					end)(var1_41.cost) then
						pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_seeds_notenough"))

						return
					end

					local var3_41 = {}

					for iter0_41, iter1_41 in ipairs(arg0_35.view.detectionSystem:GetAreaList()) do
						local var4_41 = arg0_35.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_41)

						table.insert(var3_41, var4_41.handDate.configId)
					end

					pg.m02:sendNotification(GAME.ISLAND_START_HANDLE_PLANT, {
						slot_list = var3_41,
						formula_id = var0_41.formulaid
					})
					arg0_35.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.SOW_FLAG, var0_39)
				end, SFX_PANEL)

				local var1_39 = arg0_35:GetView():GetSubView(IslandSeedOpView):CheckSeedEmpty(var0_39)

				setActive(arg0_35.seedEmpty, var1_39)
				setActive(arg0_35.seedBtn, true)
				setActive(arg0_35.seedBtn:Find("seedItem"), not var1_39)

				if not var1_39 then
					onButton(arg0_35, arg0_35.seedBtn, function()
						arg0_35:GetView():GetSubView(IslandSeedOpView):ActiveSeedSelect(true)
						arg0_35:GetView():GetSubView(IslandSeedOpView):RefreshSeedPlane(var0_39)
					end, SFX_PANEL)
					arg0_35:RefreshCurrentSlectSeed()
				end
			else
				OptionBtnDisplay(var0_0.OperationType.Interaction)
				onButton(arg0_35, arg0_35.opBtn, function()
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_being_planted"))
				end, SFX_PANEL)
				setActive(arg0_35.seedBtn, false)
			end

			local var2_39 = var0_39:GetDataVO().slotData.configId
			local var3_39 = pg.island_production_slot[var2_39].place == IslandProductConst.FarmlandPlaceId

			setActive(arg0_35.areaChangeBtn, var3_39 and getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlockAreaPlant())
		end,
		[var0_0.OperationType.MiningCollect] = function()
			var1_35()
		end,
		[var0_0.OperationType.WildGather] = function()
			local var0_46 = arg0_35.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_35.unitId)
			local var1_46 = arg0_35.view:GetIsland()

			if var1_46.id == getProxy(IslandProxy):GetIsland().id then
				OptionBtnDisplay(var0_0.OperationType.WildGather)
				onButton(arg0_35, arg0_35.opBtn, function()
					arg0_35.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.GAHTERD_FLAG, var0_46)
					var0_46:StartGather(var1_46.id)
				end, SFX_PANEL)
			elseif var0_46:CheckGatherCanSign() then
				OptionBtnDisplay(var0_0.OperationType.WildGather)
				onButton(arg0_35, arg0_35.opBtn, function()
					var0_46:StartGaherSign(var1_46.id)
				end, SFX_PANEL)
			else
				setActive(arg0_35.opBtn, false)
			end
		end,
		[var0_0.OperationType.FellCollect] = function()
			var1_35()
		end,
		[var0_0.OperationType.Fishing] = function()
			IslandGuideChecker.CheckGuide("ISLAND_GUIDE_33")
			arg0_35:UpdateLureBtn()
			OptionBtnDisplay(arg0_35.operationType)
			setActive(arg0_35.lureBtn, true)
			onButton(arg0_35, arg0_35.opBtn, function()
				local var0_51 = arg0_35:GetSelfIsland():GetFishingAgency():GetBaitId()

				if arg0_35:GetSelfIsland():GetInventoryAgency():GetOwnCount(var0_51) <= 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_fishing_lure_empty"))
				elseif arg0_35:GetView().player:OnGrouded() then
					arg0_35:CreateSubView(IslandFishingOPView):Execute("Show", arg0_35.unitId, arg0_35.opBtn.localPosition)
				end
			end, SFX_PANEL)
		end
	})
end

function var0_0.RefreshCurrentSlectSeed(arg0_52)
	local var0_52 = arg0_52.seedBtn:Find("seedItem")
	local var1_52 = arg0_52:GetView():GetSubView(IslandSeedOpView).selectseedItemId

	if not var1_52 then
		setActive(var0_52, false)

		return
	end

	setActive(var0_52, true)

	local var2_52 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var3_52 = pg.island_farm_seed[var1_52]
	local var4_52 = var2_52:GetItemById(var3_52.itemid)

	if not var4_52 then
		local var5_52

		setActive(var0_52, false)

		return
	end

	setText(var0_52:Find("count"), var4_52:GetCount())

	local var6_52 = "island/" .. var4_52:GetIcon()

	GetImageSpriteFromAtlasAsync(var6_52, "", var0_52:Find("icon"))
end

function var0_0.GetSeedBtnWorldPos(arg0_53)
	return arg0_53.seedBtn.position
end

function var0_0.TryDisablePlayerOp(arg0_54)
	arg0_54.showBalance = arg0_54.showBalance - 1

	if arg0_54.showBalance == 0 then
		arg0_54:DisablePlayerOp()
	end
end

function var0_0.TryEnablePlayerOp(arg0_55)
	arg0_55.showBalance = arg0_55.showBalance + 1

	if arg0_55.showBalance == 1 then
		arg0_55:EnablePlayerOp()
	end
end

function var0_0.ResetShowBalance(arg0_56)
	if arg0_56.showBalance ~= 1 then
		arg0_56.showBalance = 1

		arg0_56:EnablePlayerOp()
	end
end

function var0_0.DisablePlayerOp(arg0_57)
	arg0_57:ShowOrHideGameObject(arg0_57.opPanel, false)
	arg0_57:ShowOrHideGameObject(arg0_57.moveBtn, false)
	arg0_57:GetView():GetSubView(IslandInteractionView):DisableInteraction()
	arg0_57.playerInputManager:DisableInput()
	arg0_57:GetView():GetSubView(IslandDistanceView):TryDisable()
	arg0_57:GetView().player:ActiveOrDisactive(false)
end

function var0_0.EnablePlayerOp(arg0_58)
	arg0_58:ShowOrHideGameObject(arg0_58.opPanel, true)
	arg0_58:ShowOrHideGameObject(arg0_58.moveBtn, true)
	arg0_58:GetView():GetSubView(IslandInteractionView):EnableInteraction()
	arg0_58.playerInputManager:EnableInput()
	arg0_58:GetView():GetSubView(IslandDistanceView):TryEnable()
	arg0_58:GetView().player:ActiveOrDisactive(true)

	if arg0_58.inInteraction then
		arg0_58:StartInteraction()
	end
end

function var0_0.StartInteraction(arg0_59)
	arg0_59.inInteraction = true

	arg0_59:ShowOrHideGameObject(arg0_59.moveBtn, false)
	arg0_59:ShowOrHideGameObject(arg0_59.opPanel, false)
	arg0_59.playerInputManager:DisablePlayerHandle()
	arg0_59:GetView().player:StopMoveHandle()
end

function var0_0.EndInteraction(arg0_60)
	arg0_60.inInteraction = false

	arg0_60:ShowOrHideGameObject(arg0_60.moveBtn, true)
	arg0_60:ShowOrHideGameObject(arg0_60.opPanel, true)
	arg0_60.playerInputManager:EnablePlayerHandle()
end

function var0_0.DisableInput(arg0_61)
	arg0_61.playerInputManager:DisableInput()
end

function var0_0.EnableInput(arg0_62)
	arg0_62.playerInputManager:EnableInput()
end

function var0_0.ChangeTakePhotoModel(arg0_63, arg1_63, arg2_63)
	if arg1_63 == IslandConst.TakePhotoModel.None then
		if not arg2_63 then
			arg0_63:ShowOrHideMoveBtn(false)
			arg0_63.playerInputManager:DisableInput()
			arg0_63:GetView().player:ActiveOrDisactive(false)
		end
	elseif arg1_63 == IslandConst.TakePhotoModel.First then
		arg0_63:ShowOrHideMoveBtn(true)
		arg0_63.playerInputManager:EnableInput()
		arg0_63:GetView().player:ActiveOrDisactive(true)
	else
		arg0_63:ShowOrHideMoveBtn(true)
		arg0_63.playerInputManager:EnableInput()
		arg0_63:GetView().player:ActiveOrDisactive(true)
	end
end

function var0_0.ShowOrHideMoveBtn(arg0_64, arg1_64, arg2_64)
	local var0_64 = GetOrAddComponent(arg0_64.moveBtn, typeof(CanvasGroup))

	var0_64.alpha = arg1_64 and 1 or 0
	var0_64.blocksRaycasts = arg1_64 or arg2_64
end

function var0_0.OnDestroy(arg0_65)
	arg0_65:StopMorphFreeze()

	if arg0_65.opUI then
		arg0_65:GetPoolMgr():ReturnOpUI(arg0_65.opUI.gameObject)

		arg0_65.opUI = nil
	end

	arg0_65:RemoveFollowerListTimer()

	arg0_65.animationOpEffectCounter = {}
end

return var0_0
