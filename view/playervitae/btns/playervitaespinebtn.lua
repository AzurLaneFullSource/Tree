local var0 = class("PlayerVitaeSpineBtn", import(".PlayerVitaeBaseBtn"))

function var0.GetBgName(arg0)
	if arg0:IsHrzType() then
		return "share/btn_l2d_atlas", "spine_painting_bg"
	else
		return "AdmiralUI_atlas", "sp"
	end
end

function var0.IsActive(arg0, arg1)
	local var0 = HXSet.autoHxShiftPath("spinepainting/" .. arg1:getPainting())

	return (checkABExist(var0))
end

function var0.GetDefaultValue(arg0)
	return getProxy(SettingsProxy):getCharacterSetting(arg0.ship.id, SHIP_FLAG_SP)
end

function var0.OnSwitch(arg0, arg1)
	getProxy(SettingsProxy):setCharacterSetting(arg0.ship.id, SHIP_FLAG_SP, arg1)

	return true
end

function var0.Load(arg0, arg1)
	var0.super.Load(arg0, arg1)

	if arg0:IsHrzType() then
		arg1.gameObject.name = "spine"
	end
end

return var0
