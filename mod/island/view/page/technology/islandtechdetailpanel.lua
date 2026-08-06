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
	setText(var0_2:Find("finished/normal/Text"), i18n("island_tech_dev_finish"))

	arg0_2.noramlFinsh = var0_2:Find("finished/normal")
	arg0_2.mapFinsh = var0_2:Find("finished/map")
	arg0_2.mapFinshIcon = arg0_2.mapFinsh:Find("mapicon")
	arg0_2.mapFinshName = arg0_2.mapFinsh:Find("maptitle/name")
	arg0_2.npcTF = arg0_2.mapFinsh:Find("npc")
	arg0_2.npcIcon = arg0_2.npcTF:Find("npcicon")
	arg0_2.npcName = arg0_2.npcTF:Find("npcName")
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

	setText(arg0_2._tf:Find("panel/unlock/title"), i18n("island_tech_detail_unlocktitle"))
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

			local var2_6 = arg2_6:Find("icon_bg/count_bg/count")

			if var0_6.id == IslandItem.GOLD_ID then
				setText(var2_6, var1_6 < var0_6.count and setColorStr(var0_6.count, "#FF6767"))
			else
				setText(var2_6, (var1_6 < var0_6.count and setColorStr(var1_6, "#FF6767") or var1_6) .. "/" .. var0_6.count)
			end

			onButton(arg0_3, arg2_6, function()
				arg0_3.contextData:ShowMsgBox({
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var0_6
				})
			end)
		end
	end)

	arg0_3.placeId = IslandTechnologyAgency.PLACE_ID
	arg0_3.baseEffectSpeed = pg.island_set.base_efficiency.key_value_int
end

function var0_0.Flush(arg0_8)
	arg0_8:StopTimer()

	local var0_8 = getProxy(IslandProxy):GetIsland()

	arg0_8.buildingAgency = var0_8:GetBuildingAgency()
	arg0_8.techAgency = var0_8:GetTechnologyAgency()
	arg0_8.inventoryAgency = var0_8:GetInventoryAgency()
	arg0_8.showTechVO = arg0_8.techAgency:GetTechnology(arg0_8.configId)

	LoadImageSpriteAsync("island/IslandTechnology/" .. arg0_8.showTechVO:getConfig("tech_icon"), arg0_8.iconTF, true)
	setText(arg0_8.nameTF, arg0_8.showTechVO:getConfig("tech_name"))
	setText(arg0_8.descTF, arg0_8.showTechVO:getConfig("tech_desc"))

	local var1_8 = arg0_8.showTechVO:GetFormulaId()
	local var2_8 = math.floor(pg.island_formula[var1_8].workload / arg0_8.baseEffectSpeed)

	setText(arg0_8.normalTimeTextTF, arg0_8.timeMgr:DescCDTime(var2_8))

	arg0_8.unlockCondList = Clone(arg0_8.showTechVO:getConfig("sys_unlock"))

	local var3_8 = arg0_8.showTechVO:getConfig("island_level")

	if var3_8 ~= 0 then
		table.insert(arg0_8.unlockCondList, 1, {
			0,
			var3_8
		})
	end

	arg0_8.unlockUIList:align(#arg0_8.unlockCondList)

	local var4_8 = arg0_8.showTechVO:GetStatus()

	for iter0_8, iter1_8 in pairs(arg0_8.statusTFs) do
		setActive(iter1_8, iter0_8 == var4_8)
	end

	local var5_8 = var4_8 == IslandTechnology.STATUS.LOCK or var4_8 == IslandTechnology.STATUS.UNLOCK

	setActive(arg0_8.unlockTF, var5_8)
	setActive(arg0_8.descPanel, not var5_8)

	arg0_8.costList = arg0_8.showTechVO:GetCostItems()

	arg0_8.costUIList:align(#arg0_8.costList)
	setText(arg0_8._tf:Find("panel/desc/name"), arg0_8.showTechVO:getConfig("complete_title"))
	switch(var4_8, {
		[IslandTechnology.STATUS.LOCK] = function()
			onButton(arg0_8, arg0_8.statusTFs[var4_8], function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_tech_unlock_tip"))
			end, SFX_PANEL)
		end,
		[IslandTechnology.STATUS.UNLOCK] = function()
			onButton(arg0_8, arg0_8.statusTFs[var4_8], function()
				arg0_8:emit(IslandMediator.ON_UNLOCK_TECH, arg0_8.showTechVO.id)
			end, SFX_PANEL)
		end,
		[IslandTechnology.STATUS.NORMAL] = function()
			setGray(arg0_8.statusTFs[var4_8], not arg0_8:CheckCost(), false)
			onButton(arg0_8, arg0_8.statusTFs[var4_8], function()
				if not arg0_8:CheckCost() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_cost_notenough"))

					return
				end

				if not arg0_8.techAgency:GetEmptySlotId() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("island_tech_no_slot"))

					return
				end

				if arg0_8.showTechVO:IsAutoType() then
					existCall(arg0_8.contextData.onFinishImmd, arg0_8.showTechVO.id)
				else
					existCall(arg0_8.contextData.onSelecteShip, arg0_8.showTechVO:GetFormulaId())
				end
			end, SFX_PANEL)
		end,
		[IslandTechnology.STATUS.STUDYING] = function()
			onButton(arg0_8, arg0_8.statusTFs[var4_8]:Find("ticket"), function()
				existCall(arg0_8.contextData.openTicketPage, arg0_8.showTechVO:GetSlotId())
			end, SFX_PANEL)
		end,
		[IslandTechnology.STATUS.RECEIVE] = function()
			onButton(arg0_8, arg0_8.statusTFs[var4_8], function()
				arg0_8:emit(IslandMediator.GET_DELEGATION_AWARD, arg0_8.placeId, arg0_8.showTechVO:GetSlotId(), 2, function()
					existCall(arg0_8.contextData.onGetAwardDone, arg0_8.showTechVO.id)
				end)
			end, SFX_PANEL)
		end,
		[IslandTechnology.STATUS.FINISHED] = function()
			local var0_20 = arg0_8.showTechVO:getConfig("complete_map_id")

			if var0_20 == 0 then
				setActive(arg0_8.noramlFinsh, true)
				setActive(arg0_8.mapFinsh, false)

				return
			end

			setActive(arg0_8.noramlFinsh, false)
			setActive(arg0_8.mapFinsh, true)

			local var1_20 = var0_20

			LoadImageSpriteAtlasAsync("island/IslandMapIcon/" .. var1_20, "", arg0_8.mapFinshIcon)
			setText(arg0_8.mapFinshName, pg.island_map[var1_20].name)

			local var2_20 = arg0_8.showTechVO:getConfig("complete_character_id")

			if var2_20 == "" or #var2_20 == 0 then
				setActive(arg0_8.npcTF, false)

				return
			end

			setActive(arg0_8.npcTF, true)

			local var3_20 = pg.island_unit_character[var2_20[1]]

			GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var3_20.IslandShipIcon, "", arg0_8.npcIcon)
			setText(arg0_8.npcName, var3_20.name)
		end
	}, function()
		return
	end)
	arg0_8:StartTimer()
	arg0_8:UpdateTime()
	setActive(arg0_8.selectedTF, arg0_8.selectedItemPos)

	if arg0_8.selectedItemPos then
		arg0_8:FlushSelectedItem()
	end
end

function var0_0.CheckCost(arg0_22)
	return underscore.all(arg0_22.costList or {}, function(arg0_23)
		return arg0_22.inventoryAgency:GetOwnCount(arg0_23.id) >= arg0_23.count
	end)
end

function var0_0.FlushSelectedItem(arg0_24)
	setAnchoredPosition(arg0_24.selectedTF, arg0_24.selectedItemPos)
	setActive(arg0_24.selectedTF:Find("selected"), true)

	arg0_24.selectedTF.name = arg0_24.configId

	local var0_24 = arg0_24.techAgency:GetTechnology(arg0_24.configId)

	IslandTechTreePanel.SetTechName(arg0_24.selectedTF:Find("name"), var0_24:getConfig("tech_name"))

	local var1_24 = var0_24:GetStatus()
	local var2_24 = var1_24 == IslandTechnology.STATUS.FINISHED

	setTextColor(arg0_24.selectedTF:Find("name/Text"), Color.NewHex(var2_24 and "1b3650" or "ffffff"))
	setTextColor(arg0_24.selectedTF:Find("name/ScrollText"), Color.NewHex(var2_24 and "1b3650" or "ffffff"))
	LoadImageSpriteAsync("island/IslandTechnology/" .. var0_24:getConfig("tech_icon"), arg0_24.selectedTF:Find("icon"), true)
	setActive(arg0_24.selectedTF:Find("icon"), var1_24 ~= IslandTechnology.STATUS.STUDYING and var1_24 ~= IslandTechnology.STATUS.RECEIVE)
	setImageColor(arg0_24.selectedTF:Find("icon"), Color.NewHex(var2_24 and "455a81" or "ffffff"))
	eachChild(arg0_24.selectedTF:Find("back"), function(arg0_25)
		setActive(arg0_25, arg0_25.name == var1_24)
	end)
	setActive(arg0_24.selectedTF:Find("back/normal"), not var2_24 and var1_24 ~= IslandTechnology.STATUS.STUDYING)
	eachChild(arg0_24.selectedTF:Find("front"), function(arg0_26)
		setActive(arg0_26, arg0_26.name == var1_24)
	end)
end

function var0_0.Show(arg0_27, arg1_27, arg2_27)
	var0_0.super.Show(arg0_27)

	arg0_27.configId = arg1_27
	arg0_27.timeMgr = pg.TimeMgr.GetInstance()
	arg0_27.selectedItemPos = arg2_27

	arg0_27:Flush()
	arg0_27:OverlayPanel(arg0_27._tf)
end

function var0_0.OnShipSelected(arg0_28, arg1_28)
	local var0_28 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_28)
	local var1_28 = arg0_28.showTechVO:GetFormulaId()
	local var2_28 = pg.island_formula[var1_28]
	local var3_28 = math.floor(var2_28.stamina_cost * (1 - IslandProductCostHelper.GetReducePercentInPlace(arg1_28, arg0_28.placeId)))

	if math.max(var3_28, 1) > var0_28:GetCurrentEnergy() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_production_cost_notenough"))

		return
	end

	local var4_28 = arg0_28.techAgency:GetEmptySlotId()
	local var5_28 = arg0_28.showTechVO:GetFormulaId()

	arg0_28:emit(IslandMediator.START_DELEGATION, arg0_28.placeId, var4_28, arg1_28, var5_28, 1)
end

function var0_0.UpdateTime(arg0_29)
	local var0_29 = arg0_29.showTechVO:GetStatus()
	local var1_29 = arg0_29.buildingAgency:GetDelegationSlotDataByTechId(arg0_29.showTechVO.id)

	if var1_29 then
		if var1_29:GetSlotRewardData() then
			setText(arg0_29.timeTextTF, "00:00:00")
		else
			local var2_29 = var1_29:GetSlotRoleData():GetFinishTime() - arg0_29.timeMgr:GetServerTime()

			setText(arg0_29.timeTextTF, var2_29 > 0 and arg0_29.timeMgr:DescCDTime(var2_29) or "00:00:00")
		end
	else
		setText(arg0_29.timeTextTF, "??:??:??")
	end
end

function var0_0.StartTimer(arg0_30)
	arg0_30.timer = Timer.New(function()
		arg0_30:UpdateTime()
	end, 1, -1)

	arg0_30.timer:Start()
end

function var0_0.StopTimer(arg0_32)
	if arg0_32.timer ~= nil then
		arg0_32.timer:Stop()

		arg0_32.timer = nil
	end
end

function var0_0.OnHide(arg0_33)
	arg0_33:StopTimer()
	arg0_33:UnOverlayPanel(arg0_33._tf, arg0_33._parentTf)
end

function var0_0.OnDestroy(arg0_34)
	arg0_34:StopTimer()
	arg0_34:UnOverlayPanel(arg0_34._tf, arg0_34._parentTf)
end

return var0_0
