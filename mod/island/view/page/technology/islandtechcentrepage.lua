local var0_0 = class("IslandTechCentrePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandTechCentreUI"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("left")

	setText(var0_2:Find("level/name"), i18n1("岛屿等级"))

	arg0_2.levelTF = var0_2:Find("level/value")

	local var1_2 = arg0_2._tf:Find("right"):Find("view/content")

	arg0_2.uiList = UIItemList.New(var1_2, var1_2:Find("tpl"))
	arg0_2.detailPanel = IslandTechDetailPanel.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.quickPanel = IslandTechQuickPanel.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("top/back"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("top/home"), function()
		arg0_3:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	arg0_3.uiList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventInit then
			arg0_3:InitVerticalItem(arg1_6, arg2_6)
		elseif arg0_6 == UIItemList.EventUpdate then
			arg0_3:UpdateVerticalItem(arg1_6, arg2_6)
		end
	end)
	arg0_3:InifConfigData()
end

function var0_0.AddListeners(arg0_7)
	arg0_7:AddListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_7.Flush)
	arg0_7:AddListener(GAME.ISLAND_FINISH_TECH_IMMD_DONE, arg0_7.Flush)
	arg0_7:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_7.Flush)
	arg0_7:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_7.Flush)
end

function var0_0.RemoveListeners(arg0_8)
	arg0_8:RemoveListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_8.Flush)
	arg0_8:RemoveListener(GAME.ISLAND_FINISH_TECH_IMMD_DONE, arg0_8.Flush)
	arg0_8:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_8.Flush)
	arg0_8:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_8.Flush)
end

function var0_0.InifConfigData(arg0_9)
	arg0_9.config = pg.island_technology_template
	arg0_9.level2Ids = {}
	arg0_9.levels = {}

	for iter0_9, iter1_9 in ipairs(arg0_9.config.get_id_list_by_tech_belong[IslandTechBelong.CENTRE]) do
		local var0_9 = arg0_9.config[iter1_9].island_level

		if not arg0_9.level2Ids[var0_9] then
			arg0_9.level2Ids[var0_9] = {}

			table.insert(arg0_9.levels, var0_9)
		end

		table.insert(arg0_9.level2Ids[var0_9], iter1_9)
	end

	table.sort(arg0_9.levels)

	arg0_9.level2UIList = {}
end

function var0_0.InitVerticalItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.levels[arg1_10 + 1]

	setText(arg2_10:Find("level/lv"), "LV." .. var0_10)
	setActive(arg2_10:Find("line"), arg1_10 + 1 ~= #arg0_10.levels)

	local var1_10 = arg0_10.level2Ids[var0_10]
	local var2_10 = arg2_10:Find("items_view/content")
	local var3_10 = UIItemList.New(var2_10, var2_10:Find("tpl"))

	var3_10:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventInit then
			arg0_10:InitItem(arg1_11, arg2_11, var0_10)
		elseif arg0_11 == UIItemList.EventUpdate then
			arg0_10:UpdateItem(arg1_11, arg2_11, var0_10)
		end
	end)

	arg0_10.level2UIList[var0_10] = var3_10
end

function var0_0.UpdateVerticalItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.levels[arg1_12 + 1]

	setActive(arg2_12:Find("lock"), var0_12 > arg0_12.islandLevel)
	arg0_12.level2UIList[var0_12]:align(#arg0_12.level2Ids[var0_12])
end

function var0_0.InitItem(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg0_13.level2Ids[arg3_13]
	local var1_13 = var0_13[arg1_13 + 1]
	local var2_13 = arg0_13.techAgency:GetTechnology(var0_13[arg1_13 + 1])

	setText(arg2_13:Find("corner/Text"), arg0_13.config[var1_13].tech_level)
	LoadImageSpriteAsync("IslandTechnology/" .. arg0_13.config[var1_13].tech_icon, arg2_13:Find("icon"), true)
	setActive(arg2_13:Find("line"), arg1_13 + 1 ~= #var0_13)
end

function var0_0.UpdateItem(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = arg0_14.level2Ids[arg3_14]
	local var1_14 = var0_14[arg1_14 + 1]
	local var2_14 = arg0_14.techAgency:GetTechnology(var0_14[arg1_14 + 1])

	if not var2_14:IsUnlock() then
		local var3_14 = var2_14:CanUnlock()

		setActive(arg2_14:Find("unlock"), var3_14)
		onButton(arg0_14, arg2_14, function()
			if var2_14:CanUnlock() then
				arg0_14:emit(IslandMediator.ON_UNLOCK_TECH, var2_14.id)
			else
				pg.TipsMgr.GetInstance():ShowTips("不满足解锁条件")
			end
		end, SFX_PANEL)
	else
		onButton(arg0_14, arg2_14, function()
			arg0_14.detailPanel:ExecuteAction("Show", var2_14.id)
		end, SFX_PANEL)
		setActive(arg2_14:Find("unlock"), false)
	end
end

function var0_0.OnShow(arg0_17)
	local var0_17 = getProxy(IslandProxy):GetIsland()

	arg0_17.islandLevel = var0_17:GetLevel()

	setText(arg0_17.levelTF, arg0_17.islandLevel)

	arg0_17.techAgency = var0_17:GetTechnologyAgency()

	arg0_17.quickPanel:ExecuteAction("Show")
	arg0_17:Flush()
end

function var0_0.Flush(arg0_18)
	arg0_18.uiList:align(#arg0_18.levels)
	arg0_18.quickPanel:ExecuteAction("Flush")
end

function var0_0.OnHide(arg0_19)
	arg0_19.quickPanel:ExecuteAction("OffToggle")
	arg0_19.quickPanel:ExecuteAction("Hide")
end

function var0_0.OnDestroy(arg0_20)
	if arg0_20.detailPanel then
		arg0_20.detailPanel:Destroy()

		arg0_20.detailPanel = nil
	end

	if arg0_20.quickPanel then
		arg0_20.quickPanel:Destroy()

		arg0_20.quickPanel = nil
	end
end

return var0_0
