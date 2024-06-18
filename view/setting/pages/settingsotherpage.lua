local var0_0 = class("SettingsOtherPage", import(".SettingsOptionPage"))

function var0_0.OnShowTranscode(arg0_1, arg1_1)
	if PLATFORM_CODE == PLATFORM_JP then
		arg0_1:GetPanel(SettingsAccountJPPanle):showTranscode(arg1_1)
	end
end

function var0_0.OnCheckAllAccountState(arg0_2)
	if PLATFORM_CODE == PLATFORM_JP then
		arg0_2:GetPanel(SettingsAccountJPPanle):checkAllAccountState()
	elseif PLATFORM_CODE == PLATFORM_US then
		arg0_2:GetPanel(SettingsAccountUSPanle):checkAllAccountState_US()
	end
end

function var0_0.OnClearExchangeCode(arg0_3)
	local var0_3 = arg0_3:GetPanel(SettingsRedeemPanel)

	if var0_3 then
		var0_3:ClearExchangeCode()
	end
end

function var0_0.OnSecondPwdStateChange(arg0_4)
	local var0_4 = arg0_4:GetPanel(SettingsSecondPwLimitedOpPanle)

	if var0_4 then
		var0_4:UpdateBtnsState()
	end
end

function var0_0.GetPanels(arg0_5)
	local var0_5 = {
		SettingsSecondPasswordPanle,
		SettingsSecondPwLimitedOpPanle
	}

	if arg0_5:NeedRedeem() then
		table.insert(var0_5, 1, SettingsRedeemPanel)
	end

	if PLATFORM_CODE == PLATFORM_JP then
		table.insert(var0_5, 1, SettingsAccountJPPanle)
	end

	if PLATFORM_CODE == PLATFORM_US then
		table.insert(var0_5, 1, SettingsAccountUSPanle)
	end

	if PLATFORM_CODE == PLATFORM_CHT then
		table.insert(var0_5, 1, SettingsAccountTwPanle)

		if CSharpVersion >= 50 then
			table.insert(var0_5, SettingsAccountCHTPanle)
		end

		table.insert(var0_5, SettingsAgreementCHTPanle)
	end

	if PLATFORM_CODE == PLATFORM_CH then
		table.insert(var0_5, SettingsAgreementPanle)

		local var1_5 = LuaHelper.GetCHPackageType()

		if var1_5 == 1 and CSharpVersion >= 50 and not LOCK_SDK_SERVIVE then
			table.insert(var0_5, SettingsServicePanle)
		end

		if var1_5 == 1 or var1_5 == 3 and pg.SdkMgr.GetInstance():IsHuaweiPackage() then
			table.insert(var0_5, SettingsAccountCHPanle)
		end

		if var1_5 == 1 and OPEN_EXCEPTION_TEST then
			table.insert(var0_5, SettingsTestUploadExceptionPanle)
		end
	end

	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		table.insert(var0_5, SettingsAccountSpecialPanel)
	end

	return var0_5
end

function var0_0.NeedRedeem(arg0_6)
	local var0_6 = true

	if PLATFORM_CODE == PLATFORM_CH or PLATFORM_CODE == PLATFORM_KR then
		if PLATFORM == PLATFORM_IPHONEPLAYER then
			var0_6 = false
		end
	elseif PLATFORM_CODE == PLATFORM_JP then
		if PLATFORM == PLATFORM_IPHONEPLAYER then
			var0_6 = false
		end
	elseif PLATFORM_CODE == PLATFORM_US then
		var0_6 = false
	elseif PLATFORM_CODE == PLATFORM_CHT and PLATFORM == PLATFORM_IPHONEPLAYER then
		var0_6 = false
	end

	return var0_6
end

function var0_0.OnInitPanle(arg0_7)
	if PlayerPrefs.GetFloat("firstIntoOtherPanel") == 0 then
		local var0_7 = arg0_7:GetPanel(SettingsSecondPasswordPanle)

		arg0_7:ScrollToPanel(var0_7)
		PlayerPrefs.SetFloat("firstIntoOtherPanel", 1)
		PlayerPrefs.Save()
	end
end

return var0_0
