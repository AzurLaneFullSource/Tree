local var0_0 = class("PlayerVitaeBMGBtn", import(".PlayerVitaeBaseBtn"))

function var0_0.GetBgName(arg0_1)
	return "AdmiralUI_atlas", "bgm"
end

function var0_0.IsActive(arg0_2, arg1_2)
	return arg1_2:IsBgmSkin()
end

function var0_0.GetDefaultValue(arg0_3)
	return getProxy(SettingsProxy):IsBGMEnable()
end

function var0_0.OnSwitch(arg0_4, arg1_4)
	getProxy(SettingsProxy):SetBgmFlag(arg1_4)

	local var0_4

	if arg1_4 then
		var0_4 = arg0_4.ship:GetSkinBgm()
	else
		var0_4 = "main"
	end

	pg.BgmMgr.GetInstance():Push(PlayerVitaeScene.__cname, var0_4)

	return true
end

function var0_0.Load(arg0_5, arg1_5)
	var0_0.super.Load(arg0_5, arg1_5)

	if arg0_5:IsHrzType() then
		arg1_5.gameObject.name = "bmg"
	end
end

return var0_0
