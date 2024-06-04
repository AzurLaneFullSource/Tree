local var0 = class("PlayerVitaeBMGBtn", import(".PlayerVitaeBaseBtn"))

function var0.GetBgName(arg0)
	return "AdmiralUI_atlas", "bgm"
end

function var0.IsActive(arg0, arg1)
	return arg1:IsBgmSkin()
end

function var0.GetDefaultValue(arg0)
	return getProxy(SettingsProxy):IsBGMEnable()
end

function var0.OnSwitch(arg0, arg1)
	getProxy(SettingsProxy):SetBgmFlag(arg1)

	local var0

	if arg1 then
		var0 = arg0.ship:GetSkinBgm()
	else
		var0 = "main"
	end

	pg.BgmMgr.GetInstance():Push(PlayerVitaeScene.__cname, var0)

	return true
end

function var0.Load(arg0, arg1)
	var0.super.Load(arg0, arg1)

	if arg0:IsHrzType() then
		arg1.gameObject.name = "bmg"
	end
end

return var0
