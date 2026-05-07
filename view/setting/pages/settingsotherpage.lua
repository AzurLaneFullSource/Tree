local var0_0 = class("SettingsOtherPage", import(".SettingsOptionPage"))

function var0_0.OnClearExchangeCode(arg0_1)
	local var0_1 = arg0_1:GetPanel(SettingsRedeemPanel)

	if var0_1 then
		var0_1:ClearExchangeCode()
	end
end

function var0_0.OnSecondPwdStateChange(arg0_2)
	local var0_2 = arg0_2:GetPanel(SettingsSecondPwLimitedOpPanle)

	if var0_2 then
		var0_2:UpdateBtnsState()
	end
end

function var0_0.GetPanels(arg0_3)
	local var0_3 = {
		SettingsSecondPasswordPanle,
		SettingsSecondPwLimitedOpPanle
	}

	if arg0_3:NeedRedeem() then
		table.insert(var0_3, 1, SettingsRedeemPanel)
	end

	if PLATFORM_CODE == PLATFORM_JP then
		table.insert(var0_3, 1, SettingsAccountJPPanle)
	end

	if PLATFORM_CODE == PLATFORM_US then
		table.insert(var0_3, 1, SettingsAccountUSPanle)
	end

	if PLATFORM_CODE == PLATFORM_CHT then
		table.insert(var0_3, 1, SettingsAccountTwPanle)

		if CSharpVersion >= 50 then
			table.insert(var0_3, SettingsAccountCHTPanle)
		end

		table.insert(var0_3, SettingsAgreementCHTPanle)
	end

	if PLATFORM_CODE == PLATFORM_CH then
		table.insert(var0_3, SettingsAgreementPanle)

		local var1_3 = LuaHelper.GetCHPackageType()

		if var1_3 == 1 and CSharpVersion >= 50 and not LOCK_SDK_SERVIVE then
			table.insert(var0_3, SettingsServicePanle)
		end

		if var1_3 == 1 or var1_3 == 3 and pg.SdkMgr.GetInstance():IsHuaweiPackage() then
			table.insert(var0_3, SettingsAccountCHPanle)
		end

		if var1_3 == 1 and OPEN_EXCEPTION_TEST then
			table.insert(var0_3, SettingsTestUploadExceptionPanle)
		end
	end

	return var0_3
end

function var0_0.NeedRedeem(arg0_4)
	local var0_4 = true

	if PLATFORM_CODE == PLATFORM_CH or PLATFORM_CODE == PLATFORM_KR then
		if PLATFORM == PLATFORM_IPHONEPLAYER then
			var0_4 = false
		end
	elseif PLATFORM_CODE == PLATFORM_JP then
		if PLATFORM == PLATFORM_IPHONEPLAYER then
			var0_4 = false
		end
	elseif PLATFORM_CODE == PLATFORM_US then
		if PLATFORM == PLATFORM_IPHONEPLAYER then
			var0_4 = false
		end
	elseif PLATFORM_CODE == PLATFORM_CHT and PLATFORM == PLATFORM_IPHONEPLAYER then
		var0_4 = false
	end

	return var0_4
end

function var0_0.OnInitPanle(arg0_5)
	if PlayerPrefs.GetInt("firstIntoOtherPanel", 0) == 0 then
		local var0_5 = arg0_5:GetPanel(SettingsSecondPasswordPanle)

		arg0_5:ScrollToPanel(var0_5)
		PlayerPrefs.DeleteKey("firstIntoOtherPanel")
		PlayerPrefs.SetInt("firstIntoOtherPanel", 1)
		PlayerPrefs.Save()
	end
end

return var0_0
