local var0_0 = class("IslandTechQuickPanel", import("view.base.BaseSubView"))

var0_0.TOGGLE_STATUS = {
	FINISHED = "finished",
	STUDYING = "studying",
	NORMAL = "normal"
}

function var0_0.getUIName(arg0_1)
	return "IslandTechQuickPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.toggle = arg0_2._tf:Find("toggle")
	arg0_2.panel = arg0_2._tf:Find("panel")

	local var0_2 = arg0_2.panel:Find("content")

	arg0_2.uiList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	setText(var0_2:Find("tpl/content/get/Image/Text"), i18n("island_tech_can_get"))
	setText(arg0_2.toggle:Find("normal/Text"), i18n("island_tech_nodev"))
	setText(arg0_2.toggle:Find("studying/Text"), i18n("island_tech_dev_starting"))
	setText(arg0_2.toggle:Find("finished/Text"), i18n("island_tech_dev_finish_1"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.slotIds = IslandTechnologyAgency.GetSlotIds()

	arg0_3.uiList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateItem(arg1_4, arg2_4)
		end
	end)

	arg0_3.timeMgr = pg.TimeMgr.GetInstance()

	onButton(arg0_3, arg0_3._tf:Find("off"), function()
		triggerToggle(arg0_3.toggle, false)
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.toggle, function(arg0_6)
		if arg0_6 then
			pg.UIMgr.GetInstance():OverlayPanelPB(arg0_3._tf, {
				pbList = {
					arg0_3.panel
				},
				groupName = LayerWeightConst.GROUP_ISLAND
			})
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_3._tf, arg0_3._parentTf)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.slotIds[arg1_7 + 1]
	local var1_7 = arg0_7.buildingData:GetDelegationSlotData(var0_7)
	local var2_7 = var1_7 and var1_7:GetFormulaId()

	setActive(arg2_7:Find("lock"), not var1_7)
	setActive(arg2_7:Find("empty"), var1_7 and not var2_7)
	setActive(arg2_7:Find("content"), var2_7)

	if var2_7 then
		local var3_7 = arg2_7:Find("content")
		local var4_7 = arg0_7.technologyAgency:GetTechnologyByFormulaId(var2_7)

		setText(var3_7:Find("title"), var4_7:getConfig("tech_name"))

		local var5_7 = var1_7:GetSlotRoleData()

		setActive(var3_7:Find("icon_bg"), var5_7)

		if var5_7 then
			local var6_7 = IslandShip.StaticGetPrefab(var5_7.ship_id)

			GetImageSpriteFromAtlasAsync("squareicon/" .. var6_7, "", var3_7:Find("icon_bg/mask/icon"))

			local var7_7 = var5_7:GetFinishTime() - arg0_7.timeMgr:GetServerTime()

			setSlider(var3_7:Find("silder"), 0, 1, 1 - var7_7 / var5_7:GetAllTime())
			setText(var3_7:Find("silder/Text"), arg0_7.timeMgr:DescCDTime(var7_7))
		end

		local var8_7 = var1_7:GetSlotRewardData()

		setActive(var3_7:Find("get"), var8_7)
		setActive(var3_7:Find("silder"), not var8_7)
	end
end

function var0_0.Flush(arg0_8)
	arg0_8:StopTimer()

	local var0_8 = getProxy(IslandProxy):GetIsland()

	arg0_8.technologyAgency = var0_8:GetTechnologyAgency()
	arg0_8.buildingData = var0_8:GetBuildingAgency():GetBuilding(IslandTechnologyAgency.PLACE_ID)

	arg0_8.uiList:align(#arg0_8.slotIds)
	arg0_8:StartTimer()
	arg0_8:UpdateTime()
end

function var0_0.GetToggleStatus(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.slotIds) do
		local var0_9 = arg0_9.buildingData:GetDelegationSlotData(iter1_9)

		if var0_9 and var0_9:GetSlotRewardData() then
			return var0_0.TOGGLE_STATUS.FINISHED
		end

		if var0_9 and var0_9:GetSlotRoleData() then
			return var0_0.TOGGLE_STATUS.STUDYING
		end
	end

	return var0_0.TOGGLE_STATUS.NORMAL
end

function var0_0.UpdateToggleStatus(arg0_10)
	eachChild(arg0_10.toggle, function(arg0_11)
		setActive(arg0_11, arg0_11.name == arg0_10.status)
	end)
end

function var0_0.QuickGetAward(arg0_12)
	local var0_12 = underscore.detect(arg0_12.slotIds, function(arg0_13)
		local var0_13 = arg0_12.buildingData:GetDelegationSlotData(arg0_13)

		return var0_13 and var0_13:GetSlotRewardData()
	end)
	local var1_12 = arg0_12.buildingData:GetDelegationSlotData(var0_12):GetSlotRewardData().formula_id
	local var2_12 = arg0_12.technologyAgency:GetTechnologyByFormulaId(var1_12).id

	arg0_12:emit(IslandMediator.GET_DELEGATION_AWARD, IslandTechnologyAgency.PLACE_ID, var0_12, 2, function()
		existCall(arg0_12.contextData.onGetAwardDone, var2_12)
	end)
end

function var0_0.UpdateTime(arg0_15)
	arg0_15.status = arg0_15:GetToggleStatus()

	arg0_15.uiList:eachActive(function(arg0_16, arg1_16)
		local var0_16 = arg0_15.slotIds[arg0_16 + 1]
		local var1_16 = arg0_15.buildingData:GetDelegationSlotData(var0_16)

		if var1_16 and var1_16:GetFormulaId() then
			local var2_16 = arg1_16:Find("content")
			local var3_16 = var1_16:GetSlotRoleData()

			setActive(var2_16:Find("icon_bg"), var3_16)

			if var3_16 then
				local var4_16 = var3_16:GetFinishTime() - arg0_15.timeMgr:GetServerTime()

				setSlider(var2_16:Find("silder"), 0, 1, 1 - var4_16 / var3_16:GetAllTime())
				setText(var2_16:Find("silder/Text"), arg0_15.timeMgr:DescCDTime(var4_16))
			end

			local var5_16 = var1_16:GetSlotRewardData()

			setActive(var2_16:Find("get"), var5_16)
			setActive(var2_16:Find("silder"), not var5_16)
			onButton(arg0_15, arg1_16, function()
				if not var5_16 then
					return
				end

				arg0_15:QuickGetAward()
			end, SFX_PANEL)
		else
			removeOnButton(arg1_16)
		end
	end)
	arg0_15:UpdateToggleStatus()
end

function var0_0.StartTimer(arg0_18)
	arg0_18.timer = Timer.New(function()
		arg0_18:UpdateTime()
	end, 1, -1)

	arg0_18.timer:Start()
end

function var0_0.StopTimer(arg0_20)
	if arg0_20.timer ~= nil then
		arg0_20.timer:Stop()

		arg0_20.timer = nil
	end
end

function var0_0.OffToggle(arg0_21)
	triggerToggle(arg0_21.toggle, false)
end

function var0_0.Hide(arg0_22)
	arg0_22:OffToggle()
	var0_0.super.Hide(arg0_22)
end

function var0_0.OnDestroy(arg0_23)
	arg0_23:StopTimer()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_23._tf, arg0_23._parentTf)
end

return var0_0
