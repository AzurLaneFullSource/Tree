local var0_0 = class("AtelierFormulaListView", import("view.base.BasePanel"))

var0_0.FilterAll = bit.bor(1, 2, 4)

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject
	arg0_1._tf = arg1_1
	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	local var0_2 = arg0_2._tf:Find("Frame/Item")

	setActive(var0_2, false)

	arg0_2.formulaRect = GetComponent(arg0_2._tf:Find("Frame/ScrollView"), "LScrollRect")

	function arg0_2.formulaRect.onUpdateItem(arg0_3, arg1_3)
		arg0_2:UpdateFormulaItem(arg0_3 + 1, arg1_3)
	end

	setActive(arg0_2._go, false)
	arg0_2:InitCustom()
end

function var0_0.InitCustom(arg0_4)
	arg0_4.formulaFilterButtons = _.map({
		1,
		2,
		3
	}, function(arg0_5)
		return arg0_4._tf:Find("Frame/Tabs"):GetChild(arg0_5 - 1)
	end)

	setText(arg0_4._tf:Find("Frame/Empty"), i18n("ryza_tip_no_recipe"))
	setText(arg0_4._tf:Find("Frame/Filter/Text"), i18n("ryza_toggle_only_composite"))
	setText(arg0_4._tf:Find("Frame/Item/Lock/Text"), i18n("ryza_tip_unlock_all_tools"))
	setText(arg0_4._tf:Find("Bar/Text"), i18n("ryza_tip_select_recipe"))
end

function var0_0.SetContextData(arg0_6, arg1_6)
	arg0_6.contextData = arg1_6
end

function var0_0.SetActivity(arg0_7, arg1_7)
	arg0_7.activity = arg1_7
end

function var0_0.didEnter(arg0_8)
	arg0_8.contextData.filterType = var0_0.FilterAll

	for iter0_8, iter1_8 in pairs(arg0_8.formulaFilterButtons) do
		onButton(arg0_8, iter1_8, function()
			if arg0_8.contextData.filterType == var0_0.FilterAll then
				arg0_8.contextData.filterType = bit.lshift(1, iter0_8 - 1)
			else
				arg0_8.contextData.filterType = bit.bxor(arg0_8.contextData.filterType, bit.lshift(1, iter0_8 - 1))

				if arg0_8.contextData.filterType == 0 then
					arg0_8.contextData.filterType = var0_0.FilterAll
				end
			end

			arg0_8:UpdateFilterButtons()
			arg0_8:FilterFormulas()
			arg0_8:UpdateFormulaList()
		end, SFX_PANEL)
	end

	onToggle(arg0_8, arg0_8._tf:Find("Frame/Filter/Toggle"), function(arg0_10)
		arg0_8.showOnlyComposite = arg0_10

		arg0_8:FilterFormulas()
		arg0_8:UpdateFormulaList()
	end)
end

function var0_0.ShowFormulaList(arg0_11)
	setActive(arg0_11._go, true)
	setParent(arg0_11._go, arg0_11._parentClass.top)
	arg0_11._tf:SetSiblingIndex(0)
	arg0_11:UpdateFilterButtons()
	arg0_11:FilterFormulas()
	arg0_11:UpdateFormulaList()
end

function var0_0.UpdateFilterButtons(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12.formulaFilterButtons) do
		local var0_12 = arg0_12.contextData.filterType ~= var0_0.FilterAll

		var0_12 = var0_12 and bit.band(arg0_12.contextData.filterType, bit.lshift(1, iter0_12 - 1)) > 0

		setActive(iter1_12:Find("Selected"), var0_12)
	end
end

local var1_0 = {
	[AtelierFormula.TYPE.EQUIP] = "ryza_word_equip",
	[AtelierFormula.TYPE.ITEM] = "word_item",
	[AtelierFormula.TYPE.TOOL] = "word_tool",
	[AtelierFormula.TYPE.OTHER] = "word_other"
}

function var0_0.UpdateFormulaItem(arg0_13, arg1_13, arg2_13)
	local var0_13 = tf(arg2_13)
	local var1_13 = arg0_13.filterFormulas[arg1_13]
	local var2_13 = var1_13:GetProduction()

	arg0_13._parentClass:UpdateRyzaDrop(var0_13:Find("BG/Icon"), {
		type = var2_13[1],
		id = var2_13[2]
	}, true)

	local var3_13 = var1_0[var1_13:GetType()]
	local var4_13 = var1_13:GetType() ~= AtelierFormula.TYPE.TOOL and not arg0_13.activity:IsCompleteAllTools(var1_13:getConfig("version"))

	setActive(var0_13:Find("Lock"), var4_13)
	setActive(var0_13:Find("BG"), not var4_13)
	setText(var0_13:Find("BG/Type"), i18n(var3_13))
	setScrollText(var0_13:Find("BG/Name/Text"), var1_13:GetName())

	local var5_13

	if var1_13:GetMaxLimit() > 0 then
		var5_13 = var1_13:GetMaxLimit() - var1_13:GetUsedCount() .. "/" .. var1_13:GetMaxLimit()
	else
		var5_13 = "∞"
	end

	local var6_13 = var1_13:IsAvaliable()

	setActive(var0_13:Find("BG/Count"), var6_13)
	setActive(var0_13:Find("Completed"), not var6_13)

	if var6_13 then
		local var7_13 = AtelierFormula.IsFormualCanComposite(var1_13, arg0_13.activity, arg0_13.contextData.versionIndex)
		local var8_13 = arg0_13.contextData.versionIndex
		local var9_13 = "ffffff"

		if var8_13 and var8_13 == 2 then
			var9_13 = SummerFeastScene.TransformColor(var7_13 and "62e587" or "f27878")
		else
			var9_13 = SummerFeastScene.TransformColor(var7_13 and "4fb3a3" or "d55a54")
		end

		setTextColor(var0_13:Find("BG/Count"), var9_13)
	end

	setText(var0_13:Find("BG/Count"), var5_13)
	onButton(arg0_13, var0_13, function()
		if not var6_13 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_composite_invalid"))

			return
		end

		if var4_13 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_unlock_all_tools"))

			return
		end

		arg0_13._parentClass:OnClickFormula(var1_13)
	end, SFX_PANEL)
end

function var0_0.FilterFormulas(arg0_15)
	arg0_15.filterFormulas = {}

	local var0_15 = arg0_15.contextData.versionIndex

	for iter0_15, iter1_15 in pairs(arg0_15.activity:GetFormulasByVersion(var0_15)) do
		if arg0_15:IsFormulaTypeFit(iter1_15) and (not arg0_15.showOnlyComposite or iter1_15:IsAvaliable() and AtelierFormula.IsFormualCanComposite(iter1_15, arg0_15.activity, var0_15)) then
			table.insert(arg0_15.filterFormulas, iter1_15)
		end
	end

	table.sort(arg0_15.filterFormulas, function(arg0_16, arg1_16)
		local var0_16 = {
			function(arg0_17)
				return arg0_17:IsAvaliable() and 0 or 1
			end,
			function(arg0_18)
				if arg0_18:GetType() ~= AtelierFormula.TYPE.TOOL and not arg0_15.activity:IsCompleteAllTools(arg0_18:getConfig("version")) then
					return 1
				else
					return 0
				end
			end,
			function(arg0_19)
				return arg0_19:GetConfigID()
			end
		}

		for iter0_16, iter1_16 in ipairs(var0_16) do
			local var1_16 = iter1_16(arg0_16)
			local var2_16 = iter1_16(arg1_16)

			if var1_16 ~= var2_16 then
				return var1_16 < var2_16
			end
		end

		return false
	end)
end

function var0_0.IsFormulaTypeFit(arg0_20, arg1_20)
	local var0_20 = arg0_20.contextData.filterType

	if var0_20 == var0_0.FilterAll then
		return true
	end

	return switch(arg1_20:GetType(), {
		[AtelierFormula.TYPE.EQUIP] = function()
			return bit.band(var0_20, 1) > 0
		end,
		[AtelierFormula.TYPE.ITEM] = function()
			return bit.band(var0_20, 2) > 0
		end,
		[AtelierFormula.TYPE.TOOL] = function()
			return bit.band(var0_20, 4) > 0
		end,
		[AtelierFormula.TYPE.OTHER] = function()
			return bit.band(var0_20, 4) > 0
		end
	})
end

function var0_0.UpdateFormulaList(arg0_25)
	local var0_25 = #arg0_25.filterFormulas
	local var1_25 = var0_25 == 0

	setActive(arg0_25._tf:Find("Frame/Empty"), var1_25)
	setActive(arg0_25._tf:Find("Frame/ScrollView"), not var1_25)
	arg0_25.formulaRect:SetTotalCount(var0_25)
end

function var0_0.willExit(arg0_26)
	arg0_26:detach()
end

return var0_0
