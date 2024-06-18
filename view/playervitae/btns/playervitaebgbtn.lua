local var0_0 = class("PlayerVitaeBGBtn", import(".PlayerVitaeBaseBtn"))

function var0_0.GetBgName(arg0_1)
	if arg0_1:IsHrzType() then
		return "AdmiralUI_atlas", "bg_bg"
	else
		return "AdmiralUI_atlas", "bg"
	end
end

function var0_0.IsActive(arg0_2, arg1_2)
	return arg1_2:getShipBgPrint() ~= arg1_2:rarity2bgPrintForGet()
end

function var0_0.GetDefaultValue(arg0_3)
	return getProxy(SettingsProxy):getCharacterSetting(arg0_3.ship.id, SHIP_FLAG_BG)
end

function var0_0.OnSwitch(arg0_4, arg1_4)
	getProxy(SettingsProxy):setCharacterSetting(arg0_4.ship.id, SHIP_FLAG_BG, arg1_4)

	return true
end

function var0_0.Load(arg0_5, arg1_5)
	var0_0.super.Load(arg0_5, arg1_5)

	if arg0_5:IsHrzType() then
		arg1_5.gameObject.name = "bg"
	end
end

return var0_0
