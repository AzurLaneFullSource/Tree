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
	arg0_2.toggle = arg0_2._tf:Find("adapt/toggle")
	arg0_2.panel = arg0_2._tf:Find("adapt/panel")

	local var0_2 = arg0_2.panel:Find("content")
	local var1_2 = var0_2:Find("tpl")

	setText(var1_2:Find("lock/content/tip/Text"), i18n("island_tech_lock"))
	setText(var1_2:Find("empty/content/Text"), i18n("island_tech_empty"))

	arg0_2.uiList = UIItemList.New(var0_2, var1_2)

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
			arg0_3:OverlayPanel(arg0_3._tf, {
				pbList = {
					arg0_3.panel
				}
			})
		else
			arg0_3:UnOverlayPanel(arg0_3._tf, arg0_3._parentTf)
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
	if underscore.any(arg0_9.slotIds, function(arg0_10)
		local var0_10 = arg0_9.buildingData:GetDelegationSlotData(arg0_10)

		return var0_10 and var0_10:GetSlotRewardData()
	end) then
		return var0_0.TOGGLE_STATUS.FINISHED
	end

	if underscore.any(arg0_9.slotIds, function(arg0_11)
		local var0_11 = arg0_9.buildingData:GetDelegationSlotData(arg0_11)

		return var0_11 and var0_11:GetSlotRoleData()
	end) then
		return var0_0.TOGGLE_STATUS.STUDYING
	end

	return var0_0.TOGGLE_STATUS.NORMAL
end

function var0_0.UpdateToggleStatus(arg0_12)
	eachChild(arg0_12.toggle, function(arg0_13)
		setActive(arg0_13, arg0_13.name == arg0_12.status)
	end)
end

function var0_0.QuickGetAward(arg0_14)
	local var0_14 = underscore.detect(arg0_14.slotIds, function(arg0_15)
		local var0_15 = arg0_14.buildingData:GetDelegationSlotData(arg0_15)

		return var0_15 and var0_15:GetSlotRewardData()
	end)
	local var1_14 = arg0_14.buildingData:GetDelegationSlotData(var0_14):GetSlotRewardData().formula_id
	local var2_14 = arg0_14.technologyAgency:GetTechnologyByFormulaId(var1_14).id

	arg0_14:emit(IslandMediator.GET_DELEGATION_AWARD, IslandTechnologyAgency.PLACE_ID, var0_14, 2, function()
		existCall(arg0_14.contextData.onGetAwardDone, var2_14)
	end)
end

function var0_0.UpdateTime(arg0_17)
	arg0_17.status = arg0_17:GetToggleStatus()

	arg0_17.uiList:eachActive(function(arg0_18, arg1_18)
		local var0_18 = arg0_17.slotIds[arg0_18 + 1]
		local var1_18 = arg0_17.buildingData:GetDelegationSlotData(var0_18)

		if var1_18 and var1_18:GetFormulaId() then
			local var2_18 = arg1_18:Find("content")
			local var3_18 = var1_18:GetSlotRoleData()

			setActive(var2_18:Find("icon_bg"), var3_18)

			if var3_18 then
				local var4_18 = var3_18:GetFinishTime() - arg0_17.timeMgr:GetServerTime()

				setSlider(var2_18:Find("silder"), 0, 1, 1 - var4_18 / var3_18:GetAllTime())
				setText(var2_18:Find("silder/Text"), var4_18 > 0 and arg0_17.timeMgr:DescCDTime(var4_18) or "00:00:00")
			end

			local var5_18 = var1_18:GetSlotRewardData()

			setActive(var2_18:Find("get"), var5_18)
			setActive(var2_18:Find("silder"), not var5_18)
			onButton(arg0_17, arg1_18, function()
				if not var5_18 then
					return
				end

				arg0_17:QuickGetAward()
			end, SFX_PANEL)
		else
			removeOnButton(arg1_18)
		end
	end)
	arg0_17:UpdateToggleStatus()
end

function var0_0.StartTimer(arg0_20)
	arg0_20.timer = Timer.New(function()
		arg0_20:UpdateTime()
	end, 1, -1)

	arg0_20.timer:Start()
end

function var0_0.StopTimer(arg0_22)
	if arg0_22.timer ~= nil then
		arg0_22.timer:Stop()

		arg0_22.timer = nil
	end
end

function var0_0.OffToggle(arg0_23)
	triggerToggle(arg0_23.toggle, false)
end

function var0_0.Hide(arg0_24)
	arg0_24:OffToggle()
	var0_0.super.Hide(arg0_24)
end

function var0_0.OnDestroy(arg0_25)
	arg0_25:StopTimer()
	arg0_25:UnOverlayPanel(arg0_25._tf, arg0_25._parentTf)
end

return var0_0
