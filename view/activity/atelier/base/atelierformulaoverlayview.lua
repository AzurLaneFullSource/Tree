local var0_0 = class("AtelierFormulaOverlayView", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject
	arg0_1._tf = arg1_1
	arg0_1._parentClass = arg2_1
	arg0_1.bundleName = arg2_1.bundleName

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2:InitCustom()
end

function var0_0.InitCustom(arg0_3)
	return
end

function var0_0.SetContextData(arg0_4, arg1_4)
	arg0_4.contextData = arg1_4
end

function var0_0.SetActivity(arg0_5, arg1_5)
	arg0_5.activity = arg1_5
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6._tf:Find("List"), function()
		arg0_6._parentClass:OnClickFormulaBack()
	end)
end

local var1_0 = {
	[AtelierFormula.TYPE.EQUIP] = "text_equip",
	[AtelierFormula.TYPE.ITEM] = "text_item",
	[AtelierFormula.TYPE.TOOL] = "text_other",
	[AtelierFormula.TYPE.OTHER] = "text_other"
}

function var0_0.RefreshFormulaInfo(arg0_8, arg1_8)
	arg0_8.contextData.formulaId = arg1_8:GetConfigID()

	arg0_8._parentClass.loader:GetSpriteQuiet(arg0_8.bundleName, var1_0[arg1_8:GetType()], description:Find("Type"))

	local var0_8 = {
		type = arg1_8:GetProduction()[1],
		id = arg1_8:GetProduction()[2]
	}

	arg0_8._parentClass:UpdateRyzaDrop(arg0_8._tf:Find("Icon"), var0_8)
	setText(arg0_8._tf:Find("Name"), arg1_8:GetName())
	setText(arg0_8._tf:Find("Description/Text"), arg1_8:GetDesc())

	local var1_8 = tostring(arg1_8:GetMaxLimit() - arg1_8:GetUsedCount())

	if arg1_8:GetMaxLimit() < 0 then
		var1_8 = "∞"
	end

	setText(arg0_8._tf:Find("RestCount/Text"), i18n("ryza_rest_produce_count", var1_8))
end

function var0_0.willExit(arg0_9)
	arg0_9:detach()
end

return var0_0
