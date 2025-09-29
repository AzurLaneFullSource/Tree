local var0_0 = class("IslandTechCentrePanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandTechCentrePanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.viewTF = arg0_2._tf:Find("view")
	arg0_2.scrollRect = arg0_2.viewTF:Find("content"):GetComponent("LScrollRect")

	function arg0_2.scrollRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end
end

function var0_0.OnInit(arg0_5)
	arg0_5:InifConfigData()

	arg0_5.cards = {}
end

function var0_0.InifConfigData(arg0_6)
	arg0_6.config = pg.island_technology_template
	arg0_6.level2Ids = {}
	arg0_6.levels = {}
	arg0_6.allIds = arg0_6.config.get_id_list_by_tech_belong[IslandTechBelong.CENTRE]

	for iter0_6, iter1_6 in ipairs(arg0_6.allIds) do
		local var0_6 = arg0_6.config[iter1_6].island_level

		if not arg0_6.level2Ids[var0_6] then
			arg0_6.level2Ids[var0_6] = {}

			table.insert(arg0_6.levels, var0_6)
		end

		table.insert(arg0_6.level2Ids[var0_6], iter1_6)
	end

	for iter2_6, iter3_6 in pairs(arg0_6.level2Ids) do
		table.sort(iter3_6, CompareFuncs({
			function(arg0_7)
				return arg0_6.config[arg0_7].axis[2]
			end,
			function(arg0_8)
				return arg0_8
			end
		}))
	end

	table.sort(arg0_6.levels)

	arg0_6.level2UIList = {}
end

function var0_0.OnInitItem(arg0_9, arg1_9)
	local var0_9 = IslandTechCentreCard.New(arg1_9)

	arg0_9.cards[arg1_9] = var0_9
end

function var0_0.OnUpdateItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.cards[arg2_10]

	if not var0_10 then
		arg0_10:OnInitItem(arg2_10)

		var0_10 = arg0_10.cards[arg2_10]
	end

	local var1_10 = arg1_10 + 1
	local var2_10 = arg0_10.levels[var1_10]
	local var3_10 = arg0_10.level2Ids[var2_10]
	local var4_10 = arg0_10.levels[arg1_10]
	local var5_10 = var4_10 and arg0_10.level2Ids[var4_10] or {}
	local var6_10 = var2_10 > arg0_10.islandLevel or arg0_10:IsAnyUnFinish(var5_10)
	local var7_10 = var1_10 == #arg0_10.levels

	var0_10:Update(var2_10, var3_10, var7_10, var6_10, arg0_10.contextData.onItemClick)
end

function var0_0.IsAnyUnFinish(arg0_11, arg1_11)
	return underscore.any(arg1_11, function(arg0_12)
		return not arg0_11.techAgency:IsFinishedTech(arg0_12)
	end)
end

function var0_0.Show(arg0_13)
	arg0_13.super.Show(arg0_13)
	arg0_13:Flush()
	arg0_13:AutoFocus()
end

function var0_0.Flush(arg0_14)
	local var0_14 = getProxy(IslandProxy):GetIsland()

	arg0_14.islandLevel = var0_14:GetLevel()
	arg0_14.techAgency = var0_14:GetTechnologyAgency()
	arg0_14.scrollRect.enabled = true

	arg0_14.scrollRect:SetTotalCount(#arg0_14.levels, 0)
end

function var0_0.AutoFocus(arg0_15)
	local var0_15 = arg0_15:GetFocusTechId()
	local var1_15 = arg0_15.config[var0_15].island_level
	local var2_15 = table.indexof(arg0_15.levels, var1_15)

	arg0_15.scrollRect:ScrollTo(math.max(var2_15 - 4, 0) / (#arg0_15.levels - 7))
end

function var0_0.GetFocusTechId(arg0_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in ipairs(arg0_16.allIds) do
		local var1_16 = arg0_16.techAgency:GetTechnology(iter1_16):GetStatus()

		if not var0_16[var1_16] then
			var0_16[var1_16] = {}
		end

		table.insert(var0_16[var1_16], iter1_16)
	end

	for iter2_16, iter3_16 in ipairs(IslandTechTreePanel.FocusPriorities) do
		local var2_16 = var0_16[iter3_16]

		if var2_16 and #var2_16 > 0 then
			table.sort(var2_16, CompareFuncs({
				function(arg0_17)
					return arg0_16.config[arg0_17].island_level
				end,
				function(arg0_18)
					return arg0_18
				end
			}))

			return var2_16[1]
		end
	end

	return arg0_16.allIds[1]
end

function var0_0.OnDestroy(arg0_19)
	ClearLScrollrect(arg0_19.scrollRect)

	for iter0_19, iter1_19 in pairs(arg0_19.cards) do
		iter1_19:Dispose()
	end

	arg0_19.cards = {}
end

return var0_0
