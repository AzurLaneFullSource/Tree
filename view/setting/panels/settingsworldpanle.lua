local var0_0 = class("SettingsWorldPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsWorld"
end

function var0_0.GetTitle(arg0_2)
	return i18n("world_setting_title")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / OPERATION SETTINGS"
end

function var0_0.OnInit(arg0_4)
	arg0_4.uilist = UIItemList.New(arg0_4._tf:Find("options"), arg0_4._tf:Find("options/notify_tpl"))

	arg0_4.uilist:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_4:UpdateItem(arg1_5 + 1, arg2_5)
		end
	end)

	arg0_4.worldbossProgressTip = findTF(arg0_4._tf, "world_boss")
end

function var0_0.UpdateItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.list[arg1_6]

	arg2_6:Find("mask/Text"):GetComponent("ScrollText"):SetText(var0_6.title)
	onButton(arg0_6, arg2_6:Find("mask/Text"), function()
		pg.m02:sendNotification(NewSettingsMediator.SHOW_DESC, var0_6)
	end, SFX_PANEL)
	removeOnToggle(arg2_6:Find("on"))

	if arg0_6:GetDefaultValue(var0_6) then
		triggerToggle(arg2_6:Find("on"), true)
	else
		triggerToggle(arg2_6:Find("off"), true)
	end

	onToggle(arg0_6, arg2_6:Find("on"), function(arg0_8)
		arg0_6:OnItemSwitch(var0_6, arg0_8)
	end, SFX_UI_TAG, SFX_UI_CANCEL)
end

function var0_0.OnItemSwitch(arg0_9, arg1_9, arg2_9)
	getProxy(SettingsProxy):SetWorldFlag(arg1_9.key, arg2_9)
end

function var0_0.GetDefaultValue(arg0_10, arg1_10)
	return getProxy(SettingsProxy):GetWorldFlag(arg1_10.key)
end

function var0_0.GetList(arg0_11)
	return {
		{
			key = "story_tips",
			title = i18n("world_setting_quickmode"),
			desc = i18n("world_setting_quickmodetip")
		},
		{
			key = "consume_item",
			title = i18n("world_setting_submititem"),
			desc = i18n("world_setting_submititemtip")
		},
		{
			key = "auto_save_area",
			title = i18n("world_setting_mapauto"),
			desc = i18n("world_setting_mapautotip")
		}
	}
end

function var0_0.DisplayWorldBossProgressTipSettings(arg0_12)
	local var0_12 = pg.NewStoryMgr.GetInstance():IsPlayed("WorldG190")

	setActive(arg0_12.worldbossProgressTip, var0_12)

	if var0_12 then
		arg0_12:InitWorldBossProgressTipSettings()
	end
end

function var0_0.InitWorldBossProgressTipSettings(arg0_13)
	local var0_13 = arg0_13.worldbossProgressTip
	local var1_13 = arg0_13:GetWorldBossProgressTipConfig()
	local var2_13 = getProxy(SettingsProxy):GetWorldBossProgressTipFlag()

	local function var3_13(arg0_14, arg1_14)
		local var0_14 = tostring(var1_13[arg0_14])

		onToggle(arg0_13, arg1_14, function(arg0_15)
			if arg0_15 then
				getProxy(SettingsProxy):WorldBossProgressTipFlag(var0_14)
			end
		end, SFX_PANEL)

		if var0_14 == var2_13 then
			triggerToggle(arg1_14, true)
		end
	end

	local var4_13 = var0_13:Find("notify_tpl")

	var4_13:Find("mask/Text"):GetComponent("ScrollText"):SetText(i18n("world_boss_progress_tip_title"))

	for iter0_13 = 1, #var1_13 do
		var3_13(iter0_13, var4_13:Find(tostring(iter0_13)))
	end

	onButton(arg0_13, var4_13:Find("mask/Text"), function()
		pg.m02:sendNotification(NewSettingsMediator.SHOW_DESC, {
			desc = i18n("world_boss_progress_tip_desc")
		})
	end, SFX_PANEL)
end

function var0_0.GetWorldBossProgressTipConfig(arg0_17)
	local var0_17 = pg.gameset.joint_boss_ticket.description
	local var1_17 = {}

	table.insert(var1_17, "")

	local var2_17 = var0_17[1] + var0_17[2]

	table.insert(var1_17, var0_17[1] .. "&" .. var2_17)
	table.insert(var1_17, var2_17)

	return var1_17
end

function var0_0.OnUpdate(arg0_18)
	arg0_18.list = arg0_18:GetList()

	arg0_18.uilist:align(#arg0_18.list)
	arg0_18:DisplayWorldBossProgressTipSettings()
end

return var0_0
