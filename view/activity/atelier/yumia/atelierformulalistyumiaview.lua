local var0_0 = class("AtelierFormulaListYumiaView", import("view.activity.Atelier.base.AtelierFormulaListView"))

var0_0.FilterAll = bit.bor(1)
var0_0.FORMULA_TYPE = {
	EQUIP = 1,
	ITEM = 2
}

function var0_0.InitCustom(arg0_1)
	arg0_1.formulaFilterButtons = _.map({
		1,
		2
	}, function(arg0_2)
		return arg0_1._tf:Find("Frame/Tabs"):GetChild(arg0_2 - 1)
	end)

	setText(arg0_1._tf:Find("Bar/Text"), i18n("yumia_atelier_tip5"))
	setText(arg0_1._tf:Find("Frame/Tabs/Equip/UnSelected/Text"), i18n("yumia_atelier_tip2"))
	setText(arg0_1._tf:Find("Frame/Tabs/Equip/Selected/Text"), i18n("yumia_atelier_tip2"))
	setText(arg0_1._tf:Find("Frame/Tabs/Item/UnSelected/Text"), i18n("yumia_atelier_tip3"))
	setText(arg0_1._tf:Find("Frame/Tabs/Item/Selected/Text"), i18n("yumia_atelier_tip3"))
	setText(arg0_1._tf:Find("Frame/title/Text"), i18n("yumia_atelier_tip4"))
	setCanvasGroupAlpha(arg0_1._tf:Find("Frame"), 0)
end

function var0_0.didEnter(arg0_3)
	arg0_3.contextData.filterType = var0_0.FORMULA_TYPE.EQUIP

	for iter0_3, iter1_3 in pairs(arg0_3.formulaFilterButtons) do
		onButton(arg0_3, iter1_3, function()
			arg0_3.contextData.filterType = iter0_3

			arg0_3:UpdateFilterButtons()
			arg0_3:FilterFormulas()
			arg0_3:UpdateFormulaList()
		end, SFX_PANEL)
	end

	onToggle(arg0_3, arg0_3._tf:Find("Frame/Filter/Toggle"), function(arg0_5)
		arg0_3.showOnlyComposite = arg0_5

		arg0_3:FilterFormulas()
		arg0_3:UpdateFormulaList()
	end)
end

function var0_0.UpdateFilterButtons(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6.formulaFilterButtons) do
		setActive(iter1_6:Find("Selected"), arg0_6.contextData.filterType == iter0_6)
	end
end

function var0_0.FilterFormulas(arg0_7)
	arg0_7.filterFormulas = {}

	local var0_7 = arg0_7.contextData.versionIndex

	for iter0_7, iter1_7 in pairs(arg0_7.activity:GetFormulasByVersion(var0_7)) do
		if arg0_7:IsFormulaTypeFit(iter1_7) then
			if not arg0_7.showOnlyComposite then
				table.insert(arg0_7.filterFormulas, iter1_7)
			elseif iter1_7:IsAvaliable() and AtelierFormula.IsFormualCanComposite(iter1_7, arg0_7.activity, var0_7) then
				table.insert(arg0_7.filterFormulas, iter1_7)
			end
		end
	end

	table.sort(arg0_7.filterFormulas, function(arg0_8, arg1_8)
		local var0_8 = {
			function(arg0_9)
				return arg0_9:IsAvaliable() and 0 or 1
			end,
			function(arg0_10)
				if arg0_10:GetType() ~= AtelierFormula.TYPE.TOOL and not arg0_7.activity:IsCompleteAllTools(arg0_10:getConfig("version")) then
					return 1
				else
					return 0
				end
			end,
			function(arg0_11)
				return arg0_11:GetConfigID()
			end
		}

		for iter0_8, iter1_8 in ipairs(var0_8) do
			local var1_8 = iter1_8(arg0_8)
			local var2_8 = iter1_8(arg1_8)

			if var1_8 ~= var2_8 then
				return var1_8 < var2_8
			end
		end

		return false
	end)
end

function var0_0.IsFormulaTypeFit(arg0_12, arg1_12)
	local var0_12 = arg0_12.contextData.filterType

	return switch(arg1_12:GetType(), {
		[AtelierFormula.TYPE.EQUIP] = function()
			return var0_12 == var0_0.FORMULA_TYPE.EQUIP
		end,
		[AtelierFormula.TYPE.ITEM] = function()
			return var0_12 == var0_0.FORMULA_TYPE.ITEM
		end,
		[AtelierFormula.TYPE.TOOL] = function()
			return var0_12 == var0_0.FORMULA_TYPE.ITEM
		end,
		[AtelierFormula.TYPE.OTHER] = function()
			return var0_12 == var0_0.FORMULA_TYPE.ITEM
		end
	})
end

return var0_0
