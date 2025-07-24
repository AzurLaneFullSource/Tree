local var0_0 = class("AtelierFormulaOverlayYumiaView", import("view.activity.Atelier.base.AtelierFormulaOverlayView"))

function var0_0.InitCustom(arg0_1)
	setText(arg0_1:findTF("closeBtn/Text"), i18n("yumia_atelier_tip6"))
	setText(arg0_1:findTF("RestCount/Text_1"), i18n("yumia_atelier_tip8"))
	setText(arg0_1:findTF("List/Text"), i18n("yumia_atelier_tip9"))
end

function var0_0.didEnter(arg0_2)
	var0_0.super.didEnter(arg0_2)
	onButton(arg0_2, arg0_2:findTF("closeBtn"), function()
		arg0_2._parentClass:OnClickFormulaBack()
	end)
end

function var0_0.RefreshFormulaInfo(arg0_4, arg1_4)
	arg0_4.contextData.formulaId = arg1_4:GetConfigID()

	local var0_4 = {
		type = arg1_4:GetProduction()[1],
		id = arg1_4:GetProduction()[2]
	}

	arg0_4._parentClass:UpdateRyzaDrop(arg0_4:findTF("Icon"), var0_4)
	setText(arg0_4:findTF("Name"), arg1_4:GetName())
	setText(arg0_4:findTF("Description/Text"), arg1_4:GetDesc())

	local var1_4 = tostring(arg1_4:GetMaxLimit() - arg1_4:GetUsedCount())

	if arg1_4:GetMaxLimit() < 0 then
		var1_4 = "∞"
	end

	setText(arg0_4:findTF("RestCount/cntText"), var1_4)
end

function var0_0.Show(arg0_5, arg1_5)
	SetActive(arg0_5._go, arg1_5)
end

return var0_0
