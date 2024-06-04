local var0 = class("SettingsSecondPwLimitedOpPanle", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsSecondPwLimitedOp"
end

function var0.GetTitle(arg0)
	return i18n("Settings_title_Secpwlimop")
end

function var0.GetTitleEn(arg0)
	return "  / PROTECTION LIST"
end

function var0.OnInit(arg0)
	arg0.uiList = UIItemList.New(findTF(arg0._tf, "options"), findTF(arg0._tf, "options/notify_tpl"))

	arg0.uiList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateItem(arg1 + 1, arg2)
		end
	end)
	arg0:SetData()
end

function var0.SetData(arg0)
	arg0.rawdata = getProxy(SecondaryPWDProxy):getRawData()
end

function var0.UpdateItem(arg0, arg1, arg2)
	local var0 = arg0.list[arg1]
	local var1 = var0.key

	findTF(arg2, "mask/Text"):GetComponent("ScrollText"):SetText(var0.title)

	local var2 = pg.SecondaryPWDMgr.GetInstance()

	onButton(arg0, arg2, function()
		local var0 = table.contains(arg0.rawdata.system_list, var1)
		local var1

		if not var0 then
			var1 = Clone(arg0.rawdata.system_list)
			var1[#var1 + 1] = var1

			table.sort(var1, function(arg0, arg1)
				return arg0 < arg1
			end)
		elseif var0 then
			var1 = Clone(arg0.rawdata.system_list)

			for iter0 = #var1, 1, -1 do
				if var1[iter0] == var1 then
					table.remove(var1, iter0)
				end
			end
		end

		var2:ChangeSetting(var1, function()
			arg0:UpdateBtnsState()
		end)
	end, SFX_UI_TAG)
end

function var0.UpdateBtnsState(arg0)
	if not arg0:IsLoaded() then
		return
	end

	local function var0(arg0, arg1)
		local var0 = arg0.key
		local var1 = table.contains(arg0.rawdata.system_list, var0)

		arg1:GetComponent(typeof(Button)).interactable = arg0.rawdata.state > 0

		triggerToggle(arg1:Find("on"), var1)
		triggerToggle(arg1:Find("off"), not var1)
	end

	arg0.uiList:eachActive(function(arg0, arg1)
		local var0 = arg0.list[arg0 + 1]

		var0(var0, arg1)
	end)
end

function var0.OnUpdate(arg0)
	arg0.list = arg0:GetList()

	arg0.uiList:align(#arg0.list)
	arg0:UpdateBtnsState()
end

function var0.GetList(arg0)
	local var0 = pg.SecondaryPWDMgr.GetInstance()
	local var1 = {
		{
			key = var0.UNLOCK_SHIP,
			title = i18n("words_settings_unlock_ship")
		},
		{
			key = var0.RESOLVE_EQUIPMENT,
			title = i18n("words_settings_resolve_equip")
		},
		{
			key = var0.UNLOCK_COMMANDER,
			title = i18n("words_settings_unlock_commander")
		},
		{
			key = var0.CREATE_INHERIT,
			title = i18n("words_settings_create_inherit")
		}
	}

	for iter0 = #var1, 1, -1 do
		local var2 = var1[iter0]

		if not table.contains(var0.LIMITED_OPERATION, var2.key) then
			table.remove(var1, iter0)
		end
	end

	return var1
end

return var0
