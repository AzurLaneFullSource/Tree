local var0 = class("PlayerVitaeBGBtn", import(".PlayerVitaeBaseBtn"))

function var0.GetBgName(arg0)
	if arg0:IsHrzType() then
		return "AdmiralUI_atlas", "bg_bg"
	else
		return "AdmiralUI_atlas", "bg"
	end
end

function var0.IsActive(arg0, arg1)
	return arg1:getShipBgPrint() ~= arg1:rarity2bgPrintForGet()
end

function var0.GetDefaultValue(arg0)
	return getProxy(SettingsProxy):getCharacterSetting(arg0.ship.id, SHIP_FLAG_BG)
end

function var0.OnSwitch(arg0, arg1)
	getProxy(SettingsProxy):setCharacterSetting(arg0.ship.id, SHIP_FLAG_BG, arg1)

	return true
end

function var0.Load(arg0, arg1)
	var0.super.Load(arg0, arg1)

	if arg0:IsHrzType() then
		arg1.gameObject.name = "bg"
	end
end

return var0
