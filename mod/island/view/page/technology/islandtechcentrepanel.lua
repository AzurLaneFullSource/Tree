local var0_0 = class("IslandTechCentrePanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandTechCentrePanel"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("view/content")

	arg0_2.uiList = UIItemList.New(var0_2, var0_2:Find("tpl"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.uiList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventInit then
			arg0_3:InitVerticalItem(arg1_4, arg2_4)
		elseif arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateVerticalItem(arg1_4, arg2_4)
		end
	end)
	arg0_3:InifConfigData()
end

function var0_0.InifConfigData(arg0_5)
	arg0_5.config = pg.island_technology_template
	arg0_5.level2Ids = {}
	arg0_5.levels = {}

	for iter0_5, iter1_5 in ipairs(arg0_5.config.get_id_list_by_tech_belong[IslandTechBelong.CENTRE]) do
		local var0_5 = arg0_5.config[iter1_5].island_level

		if not arg0_5.level2Ids[var0_5] then
			arg0_5.level2Ids[var0_5] = {}

			table.insert(arg0_5.levels, var0_5)
		end

		table.insert(arg0_5.level2Ids[var0_5], iter1_5)
	end

	table.sort(arg0_5.levels)

	arg0_5.level2UIList = {}
end

function var0_0.InitVerticalItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.levels[arg1_6 + 1]

	setText(arg2_6:Find("level/lv"), "LV." .. var0_6)
	setActive(arg2_6:Find("line"), arg1_6 + 1 ~= #arg0_6.levels)

	local var1_6 = arg0_6.level2Ids[var0_6]
	local var2_6 = arg2_6:Find("items_view/content")
	local var3_6 = UIItemList.New(var2_6, var2_6:Find("tpl"))

	var3_6:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventInit then
			arg2_6.name = var0_6

			arg0_6:InitItem(arg1_7, arg2_7, var0_6)
		elseif arg0_7 == UIItemList.EventUpdate then
			arg0_6:UpdateItem(arg1_7, arg2_7, var0_6)
		end
	end)

	arg0_6.level2UIList[var0_6] = var3_6
end

function var0_0.UpdateVerticalItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.levels[arg1_8 + 1]
	local var1_8 = arg0_8.level2Ids[var0_8]

	arg0_8.level2UIList[var0_8]:align(#var1_8)

	local var2_8 = arg0_8.levels[arg1_8]
	local var3_8 = var2_8 and arg0_8.level2Ids[var2_8] or {}

	setActive(arg2_8:Find("lock"), var0_8 > arg0_8.islandLevel or arg0_8:IsAnyUnFinish(var3_8))
end

function var0_0.IsAnyUnFinish(arg0_9, arg1_9)
	return underscore.any(arg1_9, function(arg0_10)
		return not arg0_9.techAgency:IsFinishedTech(arg0_10)
	end)
end

function var0_0.InitItem(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg0_11.level2Ids[arg3_11]
	local var1_11 = var0_11[arg1_11 + 1]

	arg2_11.name = var1_11

	local var2_11 = arg0_11.techAgency:GetTechnology(var0_11[arg1_11 + 1])

	setText(arg2_11:Find("corner/Text"), arg0_11.config[var1_11].tech_level)
	LoadImageSpriteAsync("island/IslandTechnology/" .. arg0_11.config[var1_11].tech_icon, arg2_11:Find("icon"), true)
	setActive(arg2_11:Find("line"), arg1_11 + 1 ~= #var0_11)
end

function var0_0.UpdateItem(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = arg0_12.level2Ids[arg3_12]
	local var1_12 = var0_12[arg1_12 + 1]
	local var2_12 = arg0_12.techAgency:GetTechnology(var0_12[arg1_12 + 1])
	local var3_12 = var2_12:GetStatus()

	setActive(arg2_12:Find("receive"), var3_12 == IslandTechnology.STATUS.RECEIVE)
	setActive(arg2_12:Find("studying"), var3_12 == IslandTechnology.STATUS.STUDYING)

	local var4_12 = var3_12 == IslandTechnology.STATUS.STUDYING or var3_12 == IslandTechnology.STATUS.NORMAL and var2_12:GetFinishedCnt() == 0

	setImageAlpha(arg2_12:Find("icon"), var4_12 and 0.5 or 1)
	onButton(arg0_12, arg2_12, function()
		existCall(arg0_12.contextData.onItemClick, var2_12.id)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_14)
	arg0_14.super.Show(arg0_14)
	arg0_14:Flush()
end

function var0_0.Flush(arg0_15)
	local var0_15 = getProxy(IslandProxy):GetIsland()

	arg0_15.islandLevel = var0_15:GetLevel()
	arg0_15.techAgency = var0_15:GetTechnologyAgency()

	arg0_15.uiList:align(#arg0_15.levels)
end

function var0_0.OnDestroy(arg0_16)
	return
end

return var0_0
