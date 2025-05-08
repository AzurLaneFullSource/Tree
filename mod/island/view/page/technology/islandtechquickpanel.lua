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
end

function var0_0.OnInit(arg0_3)
	arg0_3.slotIds = IslandTechnologyAgency.GetSlotIds()

	arg0_3.uiList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateItem(arg1_4, arg2_4)
		end
	end)

	arg0_3.timeMgr = pg.TimeMgr.GetInstance()
end

function var0_0.UpdateItem(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5.slotIds[arg1_5 + 1]
	local var1_5 = arg0_5.buildingData:GetDelegationSlotData(var0_5)
	local var2_5 = var1_5 and var1_5:GetFormulaId()

	setActive(arg2_5:Find("lock"), not var1_5)
	setActive(arg2_5:Find("empty"), var1_5 and not var2_5)
	setActive(arg2_5:Find("content"), var2_5)

	if var2_5 then
		local var3_5 = arg2_5:Find("content")
		local var4_5 = arg0_5.technologyAgency:GetTechnologyByFormulaId(var2_5)

		setText(var3_5:Find("title"), var4_5:getConfig("tech_name"))

		local var5_5 = var1_5:GetSlotRoleData()

		setActive(var3_5:Find("icon"), var5_5)

		if var5_5 then
			local var6_5 = IslandShip.StaticGetPrefab(var5_5.ship_id)

			GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var6_5, "", var3_5:Find("icon"))

			local var7_5 = var5_5:GetFinishTime() - arg0_5.timeMgr:GetServerTime()

			setSlider(var3_5:Find("silder"), 0, 1, 1 - var7_5 / var5_5:GetAllTime())
			setText(var3_5:Find("silder/Text"), arg0_5.timeMgr:DescCDTime(var7_5))
		end

		local var8_5 = var1_5:GetSlotRewardData()

		setActive(var3_5:Find("finished"), var8_5)

		if var8_5 then
			setSlider(var3_5:Find("silder"), 0, 1, 1)
			setText(var3_5:Find("silder/Text"), "00:00:00")
		end
	end
end

function var0_0.Flush(arg0_6)
	arg0_6:StopTimer()

	local var0_6 = getProxy(IslandProxy):GetIsland()

	arg0_6.technologyAgency = var0_6:GetTechnologyAgency()
	arg0_6.buildingData = var0_6:GetBuildingAgency():GetBuilding(IslandTechnologyAgency.PLACE_ID)

	arg0_6.uiList:align(#arg0_6.slotIds)
	arg0_6:StartTimer()
	arg0_6:UpdateTime()
end

function var0_0.GetToggleStatus(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.slotIds) do
		local var0_7 = arg0_7.buildingData:GetDelegationSlotData(iter1_7)

		if var0_7 and var0_7:GetSlotRewardData() then
			return var0_0.TOGGLE_STATUS.FINISHED
		end

		if var0_7 and var0_7:GetSlotRoleData() then
			return var0_0.TOGGLE_STATUS.STUDYING
		end
	end

	return var0_0.TOGGLE_STATUS.NORMAL
end

function var0_0.UpdateToggleStatus(arg0_8)
	local var0_8 = arg0_8:GetToggleStatus()

	onToggle(arg0_8, arg0_8.toggle, function(arg0_9)
		if arg0_9 then
			pg.UIMgr.GetInstance():OverlayPanelPB(arg0_8._tf, {
				pbList = {
					arg0_8.panel
				},
				groupName = LayerWeightConst.GROUP_DORM3D
			})
		else
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_8._tf, arg0_8._parentTf)
		end

		if var0_8 ~= var0_0.TOGGLE_STATUS.FINISHED then
			return
		end

		arg0_8:QuickGetAward()
	end, SFX_PANEL)
	eachChild(arg0_8.toggle, function(arg0_10)
		setActive(arg0_10, arg0_10.name == var0_8)
	end)
end

function var0_0.QuickGetAward(arg0_11)
	local var0_11 = underscore.detect(arg0_11.slotIds, function(arg0_12)
		local var0_12 = arg0_11.buildingData:GetDelegationSlotData(arg0_12)

		return var0_12 and var0_12:GetSlotRewardData()
	end)

	arg0_11:emit(IslandMediator.GET_DELEGATION_AWARD, IslandTechnologyAgency.PLACE_ID, var0_11, 2)
end

function var0_0.UpdateTime(arg0_13)
	arg0_13.uiList:eachActive(function(arg0_14, arg1_14)
		local var0_14 = arg0_13.slotIds[arg0_14 + 1]
		local var1_14 = arg0_13.buildingData:GetDelegationSlotData(var0_14)

		if var1_14 and var1_14:GetFormulaId() then
			local var2_14 = arg1_14:Find("content")
			local var3_14 = var1_14:GetSlotRoleData()

			setActive(var2_14:Find("icon"), var3_14)

			if var3_14 then
				local var4_14 = var3_14:GetFinishTime() - arg0_13.timeMgr:GetServerTime()

				setSlider(var2_14:Find("silder"), 0, 1, 1 - var4_14 / var3_14:GetAllTime())
				setText(var2_14:Find("silder/Text"), arg0_13.timeMgr:DescCDTime(var4_14))
			end

			local var5_14 = var1_14:GetSlotRewardData()

			setActive(var2_14:Find("finished"), var5_14)
			onButton(arg0_13, arg1_14, function()
				if not var5_14 then
					return
				end

				arg0_13:QuickGetAward()
			end, SFX_PANEL)

			if var5_14 then
				setSlider(var2_14:Find("silder"), 0, 1, 1)
				setText(var2_14:Find("silder/Text"), "00:00:00")
			end
		end
	end)
	arg0_13:UpdateToggleStatus()
end

function var0_0.StartTimer(arg0_16)
	arg0_16.timer = Timer.New(function()
		arg0_16:UpdateTime()
	end, 1, -1)

	arg0_16.timer:Start()
end

function var0_0.StopTimer(arg0_18)
	if arg0_18.timer ~= nil then
		arg0_18.timer:Stop()

		arg0_18.timer = nil
	end
end

function var0_0.OffToggle(arg0_19)
	triggerToggle(arg0_19.toggle, false)
end

function var0_0.Hide(arg0_20)
	arg0_20:OffToggle()
	var0_0.super.Hide(arg0_20)
end

function var0_0.OnDestroy(arg0_21)
	arg0_21:StopTimer()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21._tf, arg0_21._parentTf)
end

return var0_0
