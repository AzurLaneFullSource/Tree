local var0 = class("MainFixSettingDefaultValue")

function var0.Execute(arg0, arg1)
	local var0 = pg.settings_other_template

	for iter0, iter1 in ipairs(var0.all) do
		local var1 = _G[var0[iter1].name]
		local var2 = var0[iter1].default

		if var1 ~= "" and not PlayerPrefs.HasKey(var1) then
			PlayerPrefs.SetInt(var1, var2)
		end
	end

	PlayerPrefs.Save()
	arg0:FixPlayerPrefsKey()
	arg1()
end

function var0.FixPlayerPrefsKey(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	USAGE_NEW_MAINUI = "USAGE_NEW_MAINUI" .. var0.id
end

return var0
