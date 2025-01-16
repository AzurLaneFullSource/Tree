local var0_0 = class("PlayerVitaeSpineBtn", import(".PlayerVitaeBaseBtn"))

function var0_0.GetBgName(arg0_1)
	if arg0_1:IsHrzType() then
		return "share/btn_l2d_atlas", "spine_painting_bg"
	else
		return "AdmiralUI_atlas", "sp"
	end
end

function var0_0.IsActive(arg0_2, arg1_2)
	local var0_2 = HXSet.autoHxShiftPath("spinepainting/" .. arg1_2:getPainting())

	return (checkABExist(var0_2))
end

function var0_0.GetDefaultValue(arg0_3)
	return getProxy(SettingsProxy):getCharacterSetting(arg0_3.ship.id, SHIP_FLAG_SP)
end

function var0_0.OnSwitch(arg0_4, arg1_4)
	if ShipGroup.GetChangeSkinData(arg0_4.ship.skinId) and true or false then
		getProxy(SettingsProxy):setCharacterSetting(arg0_4.ship.id, SHIP_FLAG_L2D, arg1_4)
	end

	getProxy(SettingsProxy):setCharacterSetting(arg0_4.ship.id, SHIP_FLAG_SP, arg1_4)

	return true
end

function var0_0.Load(arg0_5, arg1_5)
	var0_0.super.Load(arg0_5, arg1_5)

	if arg0_5:IsHrzType() then
		arg1_5.gameObject.name = "spine"
	end
end

return var0_0
