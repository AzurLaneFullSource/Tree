local var0 = class("SettingsOtherPage", import(".SettingsOptionPage"))

function var0.OnShowTranscode(arg0, arg1)
	if PLATFORM_CODE == PLATFORM_JP then
		arg0:GetPanel(SettingsAccountJPPanle):showTranscode(arg1)
	end
end

function var0.OnCheckAllAccountState(arg0)
	if PLATFORM_CODE == PLATFORM_JP then
		arg0:GetPanel(SettingsAccountJPPanle):checkAllAccountState()
	elseif PLATFORM_CODE == PLATFORM_US then
		arg0:GetPanel(SettingsAccountUSPanle):checkAllAccountState_US()
	end
end

function var0.OnClearExchangeCode(arg0)
	local var0 = arg0:GetPanel(SettingsRedeemPanel)

	if var0 then
		var0:ClearExchangeCode()
	end
end

function var0.OnSecondPwdStateChange(arg0)
	local var0 = arg0:GetPanel(SettingsSecondPwLimitedOpPanle)

	if var0 then
		var0:UpdateBtnsState()
	end
end

function var0.GetPanels(arg0)
	local var0 = {
		SettingsSecondPasswordPanle,
		SettingsSecondPwLimitedOpPanle
	}

	if arg0:NeedRedeem() then
		table.insert(var0, 1, SettingsRedeemPanel)
	end

	if PLATFORM_CODE == PLATFORM_JP then
		table.insert(var0, 1, SettingsAccountJPPanle)
	end

	if PLATFORM_CODE == PLATFORM_US then
		table.insert(var0, 1, SettingsAccountUSPanle)
	end

	if PLATFORM_CODE == PLATFORM_CHT then
		table.insert(var0, 1, SettingsAccountTwPanle)

		if CSharpVersion >= 50 then
			table.insert(var0, SettingsAccountCHTPanle)
		end

		table.insert(var0, SettingsAgreementCHTPanle)
	end

	if PLATFORM_CODE == PLATFORM_CH then
		table.insert(var0, SettingsAgreementPanle)

		local var1 = LuaHelper.GetCHPackageType()

		if var1 == 1 and CSharpVersion >= 50 and not LOCK_SDK_SERVIVE then
			table.insert(var0, SettingsServicePanle)
		end

		if var1 == 1 or var1 == 3 and pg.SdkMgr.GetInstance():IsHuaweiPackage() then
			table.insert(var0, SettingsAccountCHPanle)
		end

		if var1 == 1 and OPEN_EXCEPTION_TEST then
			table.insert(var0, SettingsTestUploadExceptionPanle)
		end
	end

	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US then
		table.insert(var0, SettingsAccountSpecialPanel)
	end

	return var0
end

function var0.NeedRedeem(arg0)
	local var0 = true

	if PLATFORM_CODE == PLATFORM_CH or PLATFORM_CODE == PLATFORM_KR then
		if PLATFORM == PLATFORM_IPHONEPLAYER then
			var0 = false
		end
	elseif PLATFORM_CODE == PLATFORM_JP then
		if PLATFORM == PLATFORM_IPHONEPLAYER then
			var0 = false
		end
	elseif PLATFORM_CODE == PLATFORM_US then
		var0 = false
	elseif PLATFORM_CODE == PLATFORM_CHT and PLATFORM == PLATFORM_IPHONEPLAYER then
		var0 = false
	end

	return var0
end

function var0.OnInitPanle(arg0)
	if PlayerPrefs.GetFloat("firstIntoOtherPanel") == 0 then
		local var0 = arg0:GetPanel(SettingsSecondPasswordPanle)

		arg0:ScrollToPanel(var0)
		PlayerPrefs.SetFloat("firstIntoOtherPanel", 1)
		PlayerPrefs.Save()
	end
end

return var0
