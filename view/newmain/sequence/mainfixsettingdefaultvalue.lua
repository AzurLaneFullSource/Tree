local var0_0 = class("MainFixSettingDefaultValue")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = pg.settings_other_template

	for iter0_1, iter1_1 in ipairs(var0_1.all) do
		local var1_1 = _G[var0_1[iter1_1].name]
		local var2_1 = var0_1[iter1_1].default

		if var1_1 ~= "" and not PlayerPrefs.HasKey(var1_1) then
			PlayerPrefs.SetInt(var1_1, var2_1)
		end
	end

	PlayerPrefs.Save()
	arg0_1:FixPlayerPrefsKey()
	arg1_1()
end

function var0_0.FixPlayerPrefsKey(arg0_2)
	local var0_2 = getProxy(PlayerProxy):getRawData()

	USAGE_NEW_MAINUI = "USAGE_NEW_MAINUI" .. var0_2.id
end

return var0_0
