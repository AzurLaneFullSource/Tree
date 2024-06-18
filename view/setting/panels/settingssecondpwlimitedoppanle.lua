local var0_0 = class("SettingsSecondPwLimitedOpPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsSecondPwLimitedOp"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_Secpwlimop")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / PROTECTION LIST"
end

function var0_0.OnInit(arg0_4)
	arg0_4.uiList = UIItemList.New(findTF(arg0_4._tf, "options"), findTF(arg0_4._tf, "options/notify_tpl"))

	arg0_4.uiList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_4:UpdateItem(arg1_5 + 1, arg2_5)
		end
	end)
	arg0_4:SetData()
end

function var0_0.SetData(arg0_6)
	arg0_6.rawdata = getProxy(SecondaryPWDProxy):getRawData()
end

function var0_0.UpdateItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.list[arg1_7]
	local var1_7 = var0_7.key

	findTF(arg2_7, "mask/Text"):GetComponent("ScrollText"):SetText(var0_7.title)

	local var2_7 = pg.SecondaryPWDMgr.GetInstance()

	onButton(arg0_7, arg2_7, function()
		local var0_8 = table.contains(arg0_7.rawdata.system_list, var1_7)
		local var1_8

		if not var0_8 then
			var1_8 = Clone(arg0_7.rawdata.system_list)
			var1_8[#var1_8 + 1] = var1_7

			table.sort(var1_8, function(arg0_9, arg1_9)
				return arg0_9 < arg1_9
			end)
		elseif var0_8 then
			var1_8 = Clone(arg0_7.rawdata.system_list)

			for iter0_8 = #var1_8, 1, -1 do
				if var1_8[iter0_8] == var1_7 then
					table.remove(var1_8, iter0_8)
				end
			end
		end

		var2_7:ChangeSetting(var1_8, function()
			arg0_7:UpdateBtnsState()
		end)
	end, SFX_UI_TAG)
end

function var0_0.UpdateBtnsState(arg0_11)
	if not arg0_11:IsLoaded() then
		return
	end

	local function var0_11(arg0_12, arg1_12)
		local var0_12 = arg0_12.key
		local var1_12 = table.contains(arg0_11.rawdata.system_list, var0_12)

		arg1_12:GetComponent(typeof(Button)).interactable = arg0_11.rawdata.state > 0

		triggerToggle(arg1_12:Find("on"), var1_12)
		triggerToggle(arg1_12:Find("off"), not var1_12)
	end

	arg0_11.uiList:eachActive(function(arg0_13, arg1_13)
		local var0_13 = arg0_11.list[arg0_13 + 1]

		var0_11(var0_13, arg1_13)
	end)
end

function var0_0.OnUpdate(arg0_14)
	arg0_14.list = arg0_14:GetList()

	arg0_14.uiList:align(#arg0_14.list)
	arg0_14:UpdateBtnsState()
end

function var0_0.GetList(arg0_15)
	local var0_15 = pg.SecondaryPWDMgr.GetInstance()
	local var1_15 = {
		{
			key = var0_15.UNLOCK_SHIP,
			title = i18n("words_settings_unlock_ship")
		},
		{
			key = var0_15.RESOLVE_EQUIPMENT,
			title = i18n("words_settings_resolve_equip")
		},
		{
			key = var0_15.UNLOCK_COMMANDER,
			title = i18n("words_settings_unlock_commander")
		},
		{
			key = var0_15.CREATE_INHERIT,
			title = i18n("words_settings_create_inherit")
		}
	}

	for iter0_15 = #var1_15, 1, -1 do
		local var2_15 = var1_15[iter0_15]

		if not table.contains(var0_15.LIMITED_OPERATION, var2_15.key) then
			table.remove(var1_15, iter0_15)
		end
	end

	return var1_15
end

return var0_0
