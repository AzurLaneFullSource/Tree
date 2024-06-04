local var0 = class("SettingsWorldPanle", import(".SettingsNotificationPanel"))

function var0.GetUIName(arg0)
	return "SettingsWorld"
end

function var0.GetTitle(arg0)
	return i18n("world_setting_title")
end

function var0.GetTitleEn(arg0)
	return "  / OPERATION SETTINGS"
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.worldbossProgressTip = findTF(arg0._tf, "world_boss")
end

function var0.OnItemSwitch(arg0, arg1, arg2)
	getProxy(SettingsProxy):SetWorldFlag(arg1.key, arg2)
end

function var0.GetDefaultValue(arg0, arg1)
	return getProxy(SettingsProxy):GetWorldFlag(arg1.key)
end

function var0.GetList(arg0)
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

function var0.DisplayWorldBossProgressTipSettings(arg0)
	local var0 = pg.NewStoryMgr.GetInstance():IsPlayed("WorldG190")

	setActive(arg0.worldbossProgressTip, var0)

	if var0 then
		arg0:InitWorldBossProgressTipSettings()
	end
end

function var0.InitWorldBossProgressTipSettings(arg0)
	local var0 = arg0.worldbossProgressTip
	local var1 = arg0:GetWorldBossProgressTipConfig()
	local var2 = getProxy(SettingsProxy):GetWorldBossProgressTipFlag()

	local function var3(arg0, arg1)
		local var0 = tostring(var1[arg0])

		onToggle(arg0, arg1, function(arg0)
			if arg0 then
				getProxy(SettingsProxy):WorldBossProgressTipFlag(var0)
			end
		end, SFX_PANEL)

		if var0 == var2 then
			triggerToggle(arg1, true)
		end
	end

	local var4 = var0:Find("notify_tpl")

	var4:Find("mask/Text"):GetComponent("ScrollText"):SetText(i18n("world_boss_progress_tip_title"))

	for iter0 = 1, #var1 do
		var3(iter0, var4:Find(tostring(iter0)))
	end

	onButton(arg0, var4:Find("mask/Text"), function()
		pg.m02:sendNotification(NewSettingsMediator.SHOW_DESC, {
			desc = i18n("world_boss_progress_tip_desc")
		})
	end, SFX_PANEL)
end

function var0.GetWorldBossProgressTipConfig(arg0)
	local var0 = pg.gameset.joint_boss_ticket.description
	local var1 = {}

	table.insert(var1, "")

	local var2 = var0[1] + var0[2]

	table.insert(var1, var0[1] .. "&" .. var2)
	table.insert(var1, var2)

	return var1
end

function var0.OnUpdate(arg0)
	var0.super.OnUpdate(arg0)
	arg0:DisplayWorldBossProgressTipSettings()
end

return var0
