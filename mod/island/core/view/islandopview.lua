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
	return "IslandOpUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	arg0_2.showBalance = 1
	arg0_2.timers = {}
	arg0_2.inputController = IslandCameraMgr.instance.gameObject:GetComponent(typeof(InputController))
	arg0_2._go = arg1_2
	arg0_2._tf = arg1_2.transform
	arg0_2.timeMgr = pg.TimeMgr.GetInstance()
	arg0_2.interactionPanel = arg0_2._tf:Find("interaction_btns")
	arg0_2.interactionUIItemList = UIItemList.New(arg0_2.interactionPanel, arg0_2.interactionPanel:Find("interaction"))
	arg0_2.opPanel = arg0_2._tf:Find("op_btns")
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
	arg0_2.seedSelectPlane = arg0_2._tf:Find("seed_select")
	arg0_2.seedSelectPlaneCloseBg = arg0_2._tf:Find("seed_select_closeBg")
	arg0_2.seed_detals = arg0_2._tf:Find("seed_detals")
	arg0_2.animationOpBtn = arg0_2.opPanel:Find("aniamtionop")

	setActive(arg0_2.seed_detals, false)
	arg0_2:ActiveSeedSelect(false)
	onButton(arg0_2, arg0_2.seedSelectPlaneCloseBg, function()
		setActive(arg0_2.seed_detals, false)
		arg0_2:ActiveSeedSelect(false)
	end, SFX_PANEL)

	arg0_2.uiSeedItemList = UIItemList.New(arg0_2.seedSelectPlane:Find("content"), arg0_2.seedSelectPlane:Find("content/itemSeed"))
	arg0_2.isSelectSeedPlane = false
	arg0_2.areaChangeBtn = arg0_2.opPanel:Find("scope")
	arg0_2.interactionBtnOther = arg0_2.opPanel:Find("interaction")
	arg0_2.run = arg0_2.opPanel:Find("run")
	arg0_2.moveBtn = arg0_2._tf:Find("move")

	setActive(arg0_2.opPanel, true)

	arg0_2.targetTracker = IslandTargetTracker.New(arg0_2._tf)

	arg0_2:ShowInterActionPanel({
		type = -1
	})
	onButton(arg0_2, arg0_2.areaChangeBtn, function()
		arg0_2:Emit(ISLAND_EVT.AREACHANGE)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.animationOpBtn, function()
		arg0_2:Emit(ISLAND_EVT.OPEN_ANIMATION_OP)
	end, SFX_PANEL)

	arg0_2.operationType = var0_0.OperationType.None

	arg0_2:UpdateOperationButtonDisplay()

	arg0_2.playerInputManager = arg0_2.view:GetController().playerInputManager
end

function var0_0.UpdateOperationButton(arg0_6, arg1_6, arg2_6)
	if arg1_6 == var0_0.OperationType.None then
		if arg0_6.unitId == arg2_6 then
			arg0_6.unitId = nil
			arg0_6.operationType = arg1_6
		end
	else
		arg0_6.unitId = arg2_6
		arg0_6.operationType = arg1_6
	end

	arg0_6:UpdateOperationButtonDisplay()
end

function var0_0.UpdateOperationButtonDisplay(arg0_7)
	if arg0_7.operationType == var0_0.OperationType.None then
		setActive(arg0_7.opBtn, false)
		setActive(arg0_7.areaChangeBtn, false)
		setActive(arg0_7.seedBtn, false)
		setActive(arg0_7.seed_detals, false)
		arg0_7:ActiveSeedSelect(false)

		return
	end

	function OptionBtnDisplay(arg0_8)
		for iter0_8, iter1_8 in ipairs(arg0_7.opBtnList) do
			local var0_8 = iter0_8 == arg0_8

			setActive(iter1_8, var0_8)
		end
	end

	setActive(arg0_7.opBtn, true)

	local function var0_7()
		OptionBtnDisplay(arg0_7.operationType)
		onButton(arg0_7, arg0_7.opBtn, function()
			local var0_10 = arg0_7.view:GetCore()
			local var1_10 = arg0_7.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_7.unitId)
			local var2_10 = var1_10:GetToolId()
			local var3_10 = var1_10:GetAnimatorTrigger()
			local var4_10 = var1_10:StartColloct(var2_10)

			if var4_10 == 3 then
				var0_10.controller.playerInputManager:UpdataWorkStateFunc(var3_10, var1_10.position, var2_10)
			elseif var4_10 == 2 then
				var0_10.controller.playerInputManager:UpdataWorkStateFunc(var3_10, var1_10.position, var2_10)
				arg0_7.view:OnUpdateHud(arg0_7.unitId)
			end
		end, SFX_PANEL)
		setActive(arg0_7.areaChangeBtn, false)
		setActive(arg0_7.seedBtn, false)
	end

	switch(arg0_7.operationType, {
		[var0_0.OperationType.Plant] = function()
			local var0_11 = arg0_7.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_7.unitId)

			if var0_11:CanHarvest() then
				OptionBtnDisplay(var0_0.OperationType.Harvest)
				onButton(arg0_7, arg0_7.opBtn, function()
					arg0_7.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.GAHTER_FLAG, var0_11.position)

					local var0_12 = {}

					for iter0_12, iter1_12 in ipairs(arg0_7.view.detectionSystem:GetAreaList()) do
						local var1_12 = arg0_7.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_12)

						table.insert(var0_12, var1_12.handDate.configId)
					end

					pg.m02:sendNotification(GAME.ISLAND_START_HANDLE_HARVEST, {
						slot_list = var0_12
					})
				end, SFX_PANEL)
				setActive(arg0_7.seedBtn, false)
			elseif var0_11:CanPlant() then
				IslandGuideChecker.CheckGuide("ISLAND_GUIDE_22")
				OptionBtnDisplay(var0_0.OperationType.Plant)
				onButton(arg0_7, arg0_7.opBtn, function()
					if not arg0_7.selectseedItemId then
						pg.TipsMgr.GetInstance():ShowTips("点左下角空白按钮选个种子再种地")

						return
					end

					local var0_13 = pg.island_farm_seed[arg0_7.selectseedItemId]
					local var1_13 = pg.island_formula[var0_13.formulaid]
					local var2_13 = #arg0_7.view.detectionSystem:GetAreaList()

					if not (function(arg0_14)
						local var0_14 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

						for iter0_14, iter1_14 in ipairs(arg0_14) do
							local var1_14 = iter1_14[1]
							local var2_14 = iter1_14[2]

							if var0_14:GetItemById(var1_14):GetCount() < var2_14 * var2_13 then
								return false
							end

							return true
						end
					end)(var1_13.cost) then
						pg.TipsMgr.GetInstance():ShowTips("种子数量不够")

						return
					end

					local var3_13 = {}

					for iter0_13, iter1_13 in ipairs(arg0_7.view.detectionSystem:GetAreaList()) do
						local var4_13 = arg0_7.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, iter1_13)

						table.insert(var3_13, var4_13.handDate.configId)
					end

					pg.m02:sendNotification(GAME.ISLAND_START_HANDLE_PLANT, {
						slot_list = var3_13,
						formula_id = var0_13.formulaid
					})
					arg0_7.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.SOW_FLAG, var0_11.position)
				end, SFX_PANEL)

				local var1_11 = arg0_7:CheckSeedEmpty(var0_11)

				setActive(arg0_7.seedEmpty, var1_11)
				setActive(arg0_7.seedBtn, true)
				setActive(arg0_7.seedBtn:Find("seedItem"), not var1_11)

				if not var1_11 then
					onButton(arg0_7, arg0_7.seedBtn, function()
						arg0_7:ActiveSeedSelect(true)
						arg0_7:RefreshSeedPlane(var0_11)
					end, SFX_PANEL)
					arg0_7:RefreshCurrentSlectSeed()
				end
			else
				OptionBtnDisplay(var0_0.OperationType.Interaction)
				onButton(arg0_7, arg0_7.opBtn, function()
					pg.TipsMgr.GetInstance():ShowTips("正在种植中,等等吧")
				end, SFX_PANEL)
				setActive(arg0_7.seedBtn, false)
			end

			setActive(arg0_7.areaChangeBtn, getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlockAreaPlant())
		end,
		[var0_0.OperationType.MiningCollect] = function()
			var0_7()
		end,
		[var0_0.OperationType.WildGather] = function()
			local var0_18 = arg0_7.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg0_7.unitId)
			local var1_18 = arg0_7.view:GetIsland()

			if var1_18.id == getProxy(IslandProxy):GetIsland().id then
				OptionBtnDisplay(var0_0.OperationType.WildGather)
				onButton(arg0_7, arg0_7.opBtn, function()
					arg0_7.view:GetCore().controller.playerInputManager:UpdataWorkStateFunc(IslandConst.GAHTERD_FLAG, var0_18.position)
					var0_18:StartGather(var1_18.id)
				end, SFX_PANEL)
			elseif var0_18:CheckGatherCanSign() then
				OptionBtnDisplay(var0_0.OperationType.WildGather)
				onButton(arg0_7, arg0_7.opBtn, function()
					var0_18:StartGaherSign(var1_18.id)
				end, SFX_PANEL)
			else
				setActive(arg0_7.opBtn, false)
			end
		end,
		[var0_0.OperationType.FellCollect] = function()
			var0_7()
		end
	})
end

function var0_0.ActiveSeedSelect(arg0_22, arg1_22)
	setActive(arg0_22.seedSelectPlane, arg1_22)
	setActive(arg0_22.seedSelectPlaneCloseBg, arg1_22)
end

function var0_0.RefreshSeedPlane(arg0_23, arg1_23)
	local var0_23 = arg1_23:GetDataVO().slotData.configId
	local var1_23 = pg.island_production_slot[var0_23].place
	local var2_23 = pg.island_production_place[var1_23].seed_list
	local var3_23 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var4_23 = {}

	for iter0_23, iter1_23 in ipairs(var2_23) do
		local var5_23 = var3_23:GetItemById(iter1_23)

		table.insert(var4_23, var5_23)
	end

	local var6_23 = #var4_23
	local var7_23 = 30
	local var8_23 = 40
	local var9_23 = arg0_23.seedSelectPlane:Find("content"):GetComponent(typeof(GridLayoutGroup))
	local var10_23 = var9_23.cellSize.x
	local var11_23 = var9_23.cellSize.y
	local var12_23 = math.min(var6_23, 7)
	local var13_23 = math.ceil(var6_23 / 7)
	local var14_23 = var10_23 * var12_23 + var9_23.spacing.x * (var12_23 - 1) + var9_23.padding.right + var8_23
	local var15_23 = var11_23 * var13_23 + var9_23.spacing.y * (var13_23 - 1) + var9_23.padding.bottom + var7_23

	arg0_23.seedSelectPlane:Find("content").sizeDelta = Vector2(var14_23, var15_23)

	arg0_23.uiSeedItemList:make(function(arg0_24, arg1_24, arg2_24)
		if arg0_24 == UIItemList.EventUpdate then
			local var0_24 = var4_23[arg1_24 + 1]

			setActive(arg2_24:Find("select"), arg0_23.selectseedItemId == var0_24.id)
			updateCustomDrop(arg2_24, Drop.New({
				type = DROP_TYPE_ISLAND_ITEM,
				id = var0_24.id,
				count = var0_24:GetCount()
			}))

			local var1_24

			onButton(arg0_23, arg2_24, function()
				if var1_24 then
					var1_24 = false

					return
				end

				arg0_23.selectseedItemId = var0_24.id

				PlayerPrefs.SetInt("island_last_selectItemId", arg0_23.selectseedItemId)
				arg0_23.uiSeedItemList:align(var6_23)
				arg0_23:RefreshCurrentSlectSeed()
				arg0_23:ActiveSeedSelect(false)
				setActive(arg0_23.seed_detals, false)
			end, SFX_PANEL)
			GetOrAddComponent(arg2_24, typeof(UILongPressTrigger)).onLongPressed:AddListener(function()
				var1_24 = true

				setActive(arg0_23.seed_detals, true)

				arg0_23.seed_detals.position = arg2_24.position

				setText(arg0_23.seed_detals:Find("bg/itemSeed/icon_bg/count_bg/count"), var0_24:GetCount())

				local var0_26 = var0_24:GetIcon()

				GetImageSpriteFromAtlasAsync(var0_26, "", arg0_23.seed_detals:Find("bg/itemSeed/icon_bg/icon"))

				local var1_26 = arg0_23.seed_detals:Find("bg/detaiView/Viewport/detaiViewText")

				setText(var1_26, var0_24:GetDesc())
				setText(arg0_23.seed_detals:Find("bg/seedName"), var0_24:GetName())
			end)
		end
	end)
	arg0_23.uiSeedItemList:align(var6_23)
end

function var0_0.GetOriginSelectItem(arg0_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in ipairs(seedList) do
		local var1_27 = inventory:GetItemById(iter1_27)

		table.insert(var0_27, var1_27)
	end

	local var2_27 = PlayerPrefs.GetInt("island_last_selectItemId", 0)

	if var2_27 ~= 0 and inventory:GetOwnCount(var2_27) > 0 then
		arg0_27.selectseedItemId = var2_27
	elseif #var0_27 > 0 then
		arg0_27.selectseedItemId = var0_27[1].id
	end
end

function var0_0.RefreshCurrentSlectSeed(arg0_28)
	local var0_28 = arg0_28.seedBtn:Find("seedItem")

	if not arg0_28.selectseedItemId then
		setActive(var0_28, false)

		return
	end

	setActive(var0_28, true)

	local var1_28 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetItemById(arg0_28.selectseedItemId)

	if not var1_28 then
		arg0_28.selectseedItemId = nil

		setActive(var0_28, false)

		return
	end

	setText(var0_28:Find("count"), var1_28:GetCount())

	local var2_28 = "island/" .. var1_28:GetIcon()

	GetImageSpriteFromAtlasAsync(var2_28, "", var0_28:Find("icon"))
end

function var0_0.CheckSeedEmpty(arg0_29, arg1_29)
	local var0_29 = arg1_29:GetDataVO().slotData.configId
	local var1_29 = pg.island_production_slot[var0_29].place
	local var2_29 = pg.island_production_place[var1_29].seed_list
	local var3_29 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	arg0_29.selectseedItemId = nil

	local var4_29 = PlayerPrefs.GetInt("island_last_selectItemId", 0)

	if var4_29 ~= 0 and var3_29:GetOwnCount(var4_29) > 0 then
		arg0_29.selectseedItemId = var4_29
	end

	for iter0_29, iter1_29 in ipairs(var2_29) do
		local var5_29 = var3_29:GetItemById(iter1_29)

		if var5_29 and var5_29:GetCount() ~= 0 then
			if not arg0_29.selectseedItemId then
				arg0_29.selectseedItemId = iter1_29
			end

			return false
		end
	end

	return true
end

function var0_0.OnUpdate(arg0_30)
	arg0_30.targetTracker:Update()
end

function var0_0.ShowInterActionPanel(arg0_31, arg1_31)
	arg0_31:UpdateInteractionBtns(arg1_31)
end

function var0_0.UpdateInteractionBtns(arg0_32, arg1_32)
	arg0_32.interactionData = arg1_32

	local var0_32 = arg0_32.interactionData.id
	local var1_32 = IslandInteractionUntil.GetInteractionOptions(arg0_32:GetView():GetIsland(), arg0_32.interactionData.type, var0_32)

	arg0_32:RemoveTimers()
	arg0_32.interactionUIItemList:make(function(arg0_33, arg1_33, arg2_33)
		if arg0_33 == UIItemList.EventUpdate then
			local var0_33 = var1_32[arg1_33 + 1]

			arg2_33.name = var0_33.id

			onButton(arg0_32, arg2_33, function()
				if arg0_32.interactionData.callback then
					arg0_32.interactionData.callback()
				end

				IslandInteractionUntil.Response(arg0_32, var0_32, var0_33.id)
			end, SFX_PANEL)
			arg0_32:SetInteractionText(arg2_33, var0_33)
		end
	end)
	arg0_32.interactionUIItemList:align(#var1_32)
end

function var0_0.CloseInterActionPanelByUnitIdRemove(arg0_35, arg1_35)
	if not arg0_35.interactionData then
		return
	end

	if arg0_35.interactionData.id == arg1_35 then
		arg0_35:HideInterActionPanel()
	end
end

function var0_0.ShowNextInteractionBtns(arg0_36, arg1_36)
	arg0_36.interactionData.type = tonumber(arg1_36)

	arg0_36:UpdateInteractionBtns(arg0_36.interactionData)
end

function var0_0.SetInteractionText(arg0_37, arg1_37, arg2_37)
	if arg2_37.id == IslandInteractionUntil.SIGNIN_TIME_ID then
		setActive(arg1_37:Find("time"), true)
		arg0_37:AddTimer(arg1_37, arg2_37)
	else
		setActive(arg1_37:Find("time"), false)
	end

	setText(arg1_37:Find("bg/Text"), HXSet.hxLan(arg2_37.text))

	local var0_37 = GetSpriteFromAtlas("island/IslandInteractionBtns", tostring(arg2_37.icon))

	setImageSprite(arg1_37:Find("icon_type"), var0_37, true)
end

function var0_0.AddTimer(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg0_38:GetView():GetIsland():GetSignInAgency():GetNextCanSignInTime()
	local var1_38 = Timer.New(function()
		local var0_39 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_39 = var0_38 - var0_39

		if var1_39 <= 0 then
			setActive(arg1_38:Find("time"), false)
			arg0_38:RemoveTimers()
			arg0_38:RefreshInteractionBtns()
		else
			setText(arg1_38:Find("time/Text"), pg.TimeMgr.GetInstance():DescCDTime(var1_39))
		end
	end, 1, -1)

	arg0_38.timers[arg2_38.id] = var1_38

	arg0_38.timers[arg2_38.id].func()
	var1_38:Start()
end

function var0_0.RemoveTimers(arg0_40)
	for iter0_40, iter1_40 in pairs(arg0_40.timers) do
		iter1_40:Stop()
	end

	arg0_40.timers = {}
end

function var0_0.RefreshInteractionBtns(arg0_41)
	if not arg0_41.interactionData then
		return
	end

	arg0_41:UpdateInteractionBtns(arg0_41.interactionData)
end

function var0_0.HideInterActionPanel(arg0_42)
	arg0_42:RemoveTimers()

	arg0_42.interactionData = nil

	arg0_42.interactionUIItemList:align(0)
	removeOnButton(arg0_42.opBtn)
end

function var0_0.TryDisablePlayerOp(arg0_43)
	arg0_43.showBalance = arg0_43.showBalance - 1

	if arg0_43.showBalance == 0 then
		arg0_43:DisablePlayerOp()
	end
end

function var0_0.TryEnablePlayerOp(arg0_44)
	arg0_44.showBalance = arg0_44.showBalance + 1

	if arg0_44.showBalance == 1 then
		arg0_44:EnablePlayerOp()
	end
end

function var0_0.ResetShowBalance(arg0_45)
	if arg0_45.showBalance ~= 1 then
		arg0_45.showBalance = 1
	end
end

function var0_0.DisablePlayerOp(arg0_46)
	setActive(arg0_46.opPanel, false)
	setActive(arg0_46.moveBtn, false)
	arg0_46:DisableInteraction()
	arg0_46.playerInputManager:DisableInput()
	arg0_46.targetTracker:Disable()
	arg0_46:GetView().player:ActiveOrDisactive(false)
end

function var0_0.EnablePlayerOp(arg0_47)
	setActive(arg0_47.opPanel, true)
	setActive(arg0_47.moveBtn, true)
	arg0_47:EnableInteraction()
	arg0_47.playerInputManager:EnableInput()
	arg0_47.targetTracker:Enable()
	arg0_47:GetView().player:ActiveOrDisactive(true)
end

function var0_0.StartInteraction(arg0_48)
	setActive(arg0_48.moveBtn, false)
	setActive(arg0_48.opPanel, false)
	arg0_48.playerInputManager:DisablePlayerHandle()
end

function var0_0.EndInteraction(arg0_49)
	setActive(arg0_49.moveBtn, true)
	setActive(arg0_49.opPanel, true)
	arg0_49.playerInputManager:EnablePlayerHandle()
end

function var0_0.DisableInput(arg0_50)
	arg0_50.playerInputManager:DisableInput()
end

function var0_0.EnableInput(arg0_51)
	arg0_51.playerInputManager:EnableInput()
end

function var0_0.EnableInteraction(arg0_52)
	setActive(arg0_52.interactionPanel, true)
end

function var0_0.DisableInteraction(arg0_53)
	setActive(arg0_53.interactionPanel, false)
end

function var0_0.SetTrackingTarget(arg0_54, arg1_54, arg2_54, arg3_54)
	arg0_54.targetTracker:Tracking(arg1_54._go, arg2_54._go, arg3_54)
end

function var0_0.CancelTracking(arg0_55)
	arg0_55.targetTracker:UnTracking()
end

function var0_0.OnShowHud(arg0_56, arg1_56)
	arg0_56.targetTracker:OnShowHud(arg1_56)
end

function var0_0.OnHideHud(arg0_57, arg1_57)
	arg0_57.targetTracker:OnHideHud(arg1_57)
end

function var0_0.OnDestroy(arg0_58)
	pg.DelegateInfo.Dispose(arg0_58)
	arg0_58:RemoveTimers()

	if arg0_58.targetTracker then
		arg0_58.targetTracker:Dispose()

		arg0_58.targetTracker = nil
	end
end

return var0_0
