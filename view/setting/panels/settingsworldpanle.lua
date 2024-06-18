local var0_0 = class("SettingsWorldPanle", import(".SettingsNotificationPanel"))

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
	var0_0.super.OnInit(arg0_4)

	arg0_4.worldbossProgressTip = findTF(arg0_4._tf, "world_boss")
end

function var0_0.OnItemSwitch(arg0_5, arg1_5, arg2_5)
	getProxy(SettingsProxy):SetWorldFlag(arg1_5.key, arg2_5)
end

function var0_0.GetDefaultValue(arg0_6, arg1_6)
	return getProxy(SettingsProxy):GetWorldFlag(arg1_6.key)
end

function var0_0.GetList(arg0_7)
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

function var0_0.DisplayWorldBossProgressTipSettings(arg0_8)
	local var0_8 = pg.NewStoryMgr.GetInstance():IsPlayed("WorldG190")

	setActive(arg0_8.worldbossProgressTip, var0_8)

	if var0_8 then
		arg0_8:InitWorldBossProgressTipSettings()
	end
end

function var0_0.InitWorldBossProgressTipSettings(arg0_9)
	local var0_9 = arg0_9.worldbossProgressTip
	local var1_9 = arg0_9:GetWorldBossProgressTipConfig()
	local var2_9 = getProxy(SettingsProxy):GetWorldBossProgressTipFlag()

	local function var3_9(arg0_10, arg1_10)
		local var0_10 = tostring(var1_9[arg0_10])

		onToggle(arg0_9, arg1_10, function(arg0_11)
			if arg0_11 then
				getProxy(SettingsProxy):WorldBossProgressTipFlag(var0_10)
			end
		end, SFX_PANEL)

		if var0_10 == var2_9 then
			triggerToggle(arg1_10, true)
		end
	end

	local var4_9 = var0_9:Find("notify_tpl")

	var4_9:Find("mask/Text"):GetComponent("ScrollText"):SetText(i18n("world_boss_progress_tip_title"))

	for iter0_9 = 1, #var1_9 do
		var3_9(iter0_9, var4_9:Find(tostring(iter0_9)))
	end

	onButton(arg0_9, var4_9:Find("mask/Text"), function()
		pg.m02:sendNotification(NewSettingsMediator.SHOW_DESC, {
			desc = i18n("world_boss_progress_tip_desc")
		})
	end, SFX_PANEL)
end

function var0_0.GetWorldBossProgressTipConfig(arg0_13)
	local var0_13 = pg.gameset.joint_boss_ticket.description
	local var1_13 = {}

	table.insert(var1_13, "")

	local var2_13 = var0_13[1] + var0_13[2]

	table.insert(var1_13, var0_13[1] .. "&" .. var2_13)
	table.insert(var1_13, var2_13)

	return var1_13
end

function var0_0.OnUpdate(arg0_14)
	var0_0.super.OnUpdate(arg0_14)
	arg0_14:DisplayWorldBossProgressTipSettings()
end

return var0_0
