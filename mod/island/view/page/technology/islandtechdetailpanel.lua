local var0_0 = class("IslandTechDetailPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandTechDetailPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.selectedTF = arg0_2._tf:Find("selected")
	arg0_2.panel = arg0_2._tf:Find("panel")
	arg0_2.iconTF = arg0_2.panel:Find("icon_bg/icon")
	arg0_2.nameTF = arg0_2.panel:Find("title/Text")
	arg0_2.descPanel = arg0_2.panel:Find("desc")
	arg0_2.descTF = arg0_2.descPanel:Find("Text")
	arg0_2.unlockTF = arg0_2.panel:Find("unlock")

	setText(arg0_2.unlockTF:Find("title"), i18n("island_tech_unlock_need"))

	arg0_2.unlockUIList = UIItemList.New(arg0_2.unlockTF:Find("list"), arg0_2.unlockTF:Find("list/tpl"))
	arg0_2.normalTimeTextTF = arg0_2.panel:Find("status/normal/content/time/Text")
	arg0_2.timeTextTF = arg0_2.panel:Find("status/studying/time/Text")

	local var0_2 = arg0_2.panel:Find("status")

	setText(var0_2:Find("lock/content/Text"), i18n("island_tech_unlock_dev"))
	setText(var0_2:Find("unlock/Text"), i18n("island_tech_unlock_dev"))
	setText(var0_2:Find("normal/content/Text"), i18n("island_tech_dev_start"))
	setText(var0_2:Find("normal/cost/title"), i18n("island_tech_dev_cost"))
	setText(var0_2:Find("studying/Text"), i18n("island_tech_dev_starting"))
	setText(var0_2:Find("receive/Text"), i18n("island_tech_dev_success"))
	setText(var0_2:Find("finished/Text"), i18n("island_tech_dev_finish"))

	arg0_2.statusTFs = {
		[IslandTechnology.STATUS.LOCK] = var0_2:Find("lock"),
		[IslandTechnology.STATUS.UNLOCK] = var0_2:Find("unlock"),
		[IslandTechnology.STATUS.NORMAL] = var0_2:Find("normal"),
		[IslandTechnology.STATUS.STUDYING] = var0_2:Find("studying"),
		[IslandTechnology.STATUS.RECEIVE] = var0_2:Find("receive"),
		[IslandTechnology.STATUS.FINISHED] = var0_2:Find("finished")
	}
	arg0_2.costTF = arg0_2.panel:Find("status/normal/cost")
	arg0_2.costUIList = UIItemList.New(arg0_2.costTF:Find("list"), arg0_2.costTF:Find("list/tpl"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("close"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3.unlockUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg0_3.unlockCondList[arg1_5 + 1]

			setText(arg2_5:Find("Text"), IslandTechnology.GetUnlockText(var0_5))

			local var1_5 = arg0_3.showTechVO:MatchCondition(var0_5) and "1E90FF" or "F5F5F5"

			setTextColor(arg2_5:Find("Text"), Color.NewHex(var1_5))
			setImageColor(arg2_5:Find("dot"), Color.NewHex(var1_5))
		end
	end)
	arg0_3.costUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = arg0_3.costList[arg1_6 + 1]
			local var1_6 = arg0_3.inventoryAgency:GetOwnCount(var0_6.id)

			updateCustomDrop(arg2_6, var0_6)
			setText(arg2_6:Find("icon_bg/count_bg/count"), var1_6 .. "/" .. var0_6.count)
		end
	end)

	arg0_3.placeId = IslandTechnologyAgency.PLACE_ID
	arg0_3.baseEffectSpeed = pg.island_set.base_efficiency.key_value_int
end

function var0_0.Flush(arg0_7)
	arg0_7:StopTimer()

	local var0_7 = getProxy(IslandProxy):GetIsland()

	arg0_7.buildingAgency = var0_7:GetBuildingAgency()
	arg0_7.techAgency = var0_7:GetTechnologyAgency()
	arg0_7.inventoryAgency = var0_7:GetInventoryAgency()
	arg0_7.showTechVO = arg0_7.techAgency:GetTechnology(arg0_7.configId)

	LoadImageSpriteAsync("island/IslandTechnology/" .. arg0_7.showTechVO:getConfig("tech_icon"), arg0_7.iconTF, true)
	setText(arg0_7.nameTF, arg0_7.showTechVO:getConfig("tech_name"))
	setText(arg0_7.descTF, arg0_7.showTechVO:getConfig("tech_desc"))

	local var1_7 = arg0_7.showTechVO:GetFormulaId()
	local var2_7 = math.floor(pg.island_formula[var1_7].workload / arg0_7.baseEffectSpeed)

	setText(arg0_7.normalTimeTextTF, arg0_7.timeMgr:DescCDTime(var2_7))

	arg0_7.unlockCondList = Clone(arg0_7.showTechVO:getConfig("sys_unlock"))

	local var3_7 = arg0_7.showTechVO:getConfig("island_level")

	if var3_7 ~= 0 then
		table.insert(arg0_7.unlockCondList, 1, {
			0,
			var3_7
		})
	end

	arg0_7.unlockUIList:align(#arg0_7.unlockCondList)

	local var4_7 = arg0_7.showTechVO:GetStatus()

	for iter0_7, iter1_7 in pairs(arg0_7.statusTFs) do
		setActive(iter1_7, iter0_7 == var4_7)
	end

	local var5_7 = var4_7 == IslandTechnology.STATUS.LOCK or var4_7 == IslandTechnology.STATUS.UNLOCK

	setActive(arg0_7.unlockTF, var5_7)
	setActive(arg0_7.descPanel, not var5_7)

	arg0_7.costList = arg0_7.showTechVO:GetCostItems()

	arg0_7.costUIList:align(#arg0_7.costList)
	switch(var4_7, {
		[IslandTechnology.STATUS.LOCK] = function()
			onButton(arg0_7, arg0_7.statusTFs[var4_7], function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_tech_unlock_tip"))
			end, SFX_PANEL)
		end,
		[IslandTechnology.STATUS.UNLOCK] = function()
			onButton(arg0_7, arg0_7.statusTFs[var4_7], function()
				arg0_7:emit(IslandMediator.ON_UNLOCK_TECH, arg0_7.showTechVO.id)
			end, SFX_PANEL)
		end,
		[IslandTechnology.STATUS.NORMAL] = function()
			onButton(arg0_7, arg0_7.statusTFs[var4_7], function()
				if not arg0_7:CheckCost() then
					return
				end

				if not arg0_7.techAgency:GetEmptySlotId() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_tech_no_slot"))

					return
				end

				if arg0_7.showTechVO:IsAutoType() then
					existCall(arg0_7.contextData.onFinishImmd, arg0_7.showTechVO.id)
				else
					existCall(arg0_7.contextData.onSelecteShip)
				end
			end, SFX_PANEL)
		end,
		[IslandTechnology.STATUS.STUDYING] = function()
			onButton(arg0_7, arg0_7.statusTFs[var4_7]:Find("quick"), function()
				pg.TipsMgr.GetInstance():ShowTips("TODO")
			end, SFX_PANEL)
		end,
		[IslandTechnology.STATUS.RECEIVE] = function()
			onButton(arg0_7, arg0_7.statusTFs[var4_7], function()
				arg0_7:emit(IslandMediator.GET_DELEGATION_AWARD, arg0_7.placeId, arg0_7.showTechVO:GetSlotId(), 2, function()
					existCall(arg0_7.contextData.onGetAwardDone, arg0_7.showTechVO.id)
				end)
			end, SFX_PANEL)
		end
	}, function()
		return
	end)
	arg0_7:StartTimer()
	arg0_7:UpdateTime()
	setActive(arg0_7.selectedTF, arg0_7.selectedItemPos)

	if arg0_7.selectedItemPos then
		arg0_7:FlushSelectedItem()
	end
end

function var0_0.CheckCost(arg0_20)
	return underscore.all(arg0_20.costList or {}, function(arg0_21)
		return arg0_20.inventoryAgency:GetOwnCount(arg0_21.id) >= arg0_21.count
	end)
end

function var0_0.FlushSelectedItem(arg0_22)
	setAnchoredPosition(arg0_22.selectedTF, arg0_22.selectedItemPos)
	setActive(arg0_22.selectedTF:Find("selected"), true)

	arg0_22.selectedTF.name = arg0_22.configId

	local var0_22 = arg0_22.techAgency:GetTechnology(arg0_22.configId)

	setText(arg0_22.selectedTF:Find("name"), var0_22:getConfig("tech_name"))

	local var1_22 = var0_22:GetStatus()
	local var2_22 = var1_22 == IslandTechnology.STATUS.FINISHED

	setTextColor(arg0_22.selectedTF:Find("name"), Color.NewHex(var2_22 and "1b3650" or "ffffff"))
	LoadImageSpriteAsync("island/IslandTechnology/" .. var0_22:getConfig("tech_icon"), arg0_22.selectedTF:Find("icon"), true)
	setActive(arg0_22.selectedTF:Find("icon"), var1_22 ~= IslandTechnology.STATUS.STUDYING and var1_22 ~= IslandTechnology.STATUS.RECEIVE)
	setImageColor(arg0_22.selectedTF:Find("icon"), Color.NewHex(var2_22 and "455a81" or "ffffff"))
	eachChild(arg0_22.selectedTF:Find("back"), function(arg0_23)
		setActive(arg0_23, arg0_23.name == var1_22)
	end)
	setActive(arg0_22.selectedTF:Find("back/normal"), not var2_22 and var1_22 ~= IslandTechnology.STATUS.STUDYING)
	eachChild(arg0_22.selectedTF:Find("front"), function(arg0_24)
		setActive(arg0_24, arg0_24.name == var1_22)
	end)
end

function var0_0.Show(arg0_25, arg1_25, arg2_25)
	var0_0.super.Show(arg0_25)

	arg0_25.configId = arg1_25
	arg0_25.timeMgr = pg.TimeMgr.GetInstance()
	arg0_25.selectedItemPos = arg2_25

	arg0_25:Flush()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_25._tf, {
		groupName = LayerWeightConst.GROUP_ISLAND
	})
end

function var0_0.OnShipSelected(arg0_26, arg1_26)
	local var0_26 = arg0_26.techAgency:GetEmptySlotId()
	local var1_26 = arg0_26.showTechVO:GetFormulaId()

	arg0_26:emit(IslandMediator.START_DELEGATION, arg0_26.placeId, var0_26, arg1_26, var1_26, 1)
end

function var0_0.UpdateTime(arg0_27)
	local var0_27 = arg0_27.showTechVO:GetStatus()
	local var1_27 = arg0_27.buildingAgency:GetDelegationSlotDataByTechId(arg0_27.showTechVO.id)

	if var1_27 then
		if var1_27:GetSlotRewardData() then
			setText(arg0_27.timeTextTF, "00:00:00")
		else
			local var2_27 = var1_27:GetSlotRoleData():GetFinishTime() - arg0_27.timeMgr:GetServerTime()

			setText(arg0_27.timeTextTF, arg0_27.timeMgr:DescCDTime(var2_27))
		end
	else
		setText(arg0_27.timeTextTF, "??:??:??")
	end
end

function var0_0.StartTimer(arg0_28)
	arg0_28.timer = Timer.New(function()
		arg0_28:UpdateTime()
	end, 1, -1)

	arg0_28.timer:Start()
end

function var0_0.StopTimer(arg0_30)
	if arg0_30.timer ~= nil then
		arg0_30.timer:Stop()

		arg0_30.timer = nil
	end
end

function var0_0.OnHide(arg0_31)
	arg0_31:StopTimer()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_31._tf, arg0_31._parentTf)
end

function var0_0.OnDestroy(arg0_32)
	arg0_32:StopTimer()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_32._tf, arg0_32._parentTf)
end

return var0_0
