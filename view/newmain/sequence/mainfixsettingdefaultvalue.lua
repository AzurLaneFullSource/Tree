local var0_0 = class("MainFixSettingDefaultValue")

function var0_0.Ctor(arg0_1)
	arg0_1.isExecute = false
end

function var0_0.Execute(arg0_2, arg1_2)
	if arg0_2.isExecute then
		arg1_2()

		return
	end

	arg0_2.isExecute = true

	local var0_2 = pg.settings_other_template

	for iter0_2, iter1_2 in ipairs(var0_2.all) do
		local var1_2 = _G[var0_2[iter1_2].name]
		local var2_2 = var0_2[iter1_2].default

		if not noEmptyStr(var1_2) then
			print("settings_other_template without register this key:", var0_2[iter1_2].name)
		elseif not PlayerPrefs.HasKey(var1_2) then
			PlayerPrefs.SetInt(var1_2, var2_2)
		end
	end

	arg0_2:FixMainSceneSettings()
	PlayerPrefs.Save()
	arg0_2:FixPlayerPrefsKey()
	arg1_2()
end

function var0_0.FixMainSceneSettings(arg0_3)
	local var0_3 = {
		SettingsMainScenePanel.STANDBY_MODE_KEY,
		SettingsMainScenePanel.FLAGSHIP_INTERACTION_KEY
	}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var1_3 = iter1_3 .. "_" .. getProxy(PlayerProxy):getRawData().id

		if not PlayerPrefs.HasKey(var1_3) then
			PlayerPrefs.SetInt(var1_3, 1)
		end
	end
end

function var0_0.FixPlayerPrefsKey(arg0_4)
	local var0_4 = getProxy(PlayerProxy):getRawData()

	USAGE_NEW_MAINUI = "USAGE_NEW_MAINUI" .. var0_4.id

	if not PlayerPrefs.HasKey(USAGE_NEW_MAINUI) then
		PlayerPrefs.GetInt(USAGE_NEW_MAINUI, 2)
		PlayerPrefs.Save()
	end

	local var1_4 = PlayerPrefs.GetInt(USAGE_NEW_MAINUI, 1)

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildNewMainUI({
		isLogin = 1,
		isNewMainUI = var1_4
	}))
end

function var0_0.Dispose(arg0_5)
	arg0_5.isExecute = false
end

return var0_0
