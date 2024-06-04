local var0 = class("AutoBotCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.isActiveBot
	local var2 = var0.toggle
	local var3 = var0.system
	local var4 = var0.GetAutoBotMark(var3)

	if var0.autoBotSatisfied() then
		if PlayerPrefs.GetInt("autoBotIsAcitve" .. var4, 0) == not var1 then
			-- block empty
		else
			PlayerPrefs.SetInt("autoBotIsAcitve" .. var4, not var1 and 1 or 0)
			var0.activeBotHelp(not var1)
		end
	elseif not var1 then
		if var2 then
			onDelayTick(function()
				GetComponent(var2, typeof(Toggle)).isOn = false
			end, 0.1)
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_limit_tip"))
	end

	if var1 then
		arg0:sendNotification(GAME.AUTO_SUB, {
			isActiveSub = true,
			system = var3
		})
	end
end

function var0.autoBotSatisfied()
	local var0 = getProxy(ChapterProxy)

	return var0 and var0:getChapterById(AUTO_ENABLE_CHAPTER):isClear()
end

function var0.activeBotHelp(arg0)
	local var0 = getProxy(PlayerProxy)

	if not arg0 then
		if var0.autoBotHelp then
			pg.MsgboxMgr.GetInstance():hide()
		end

		return
	end

	if var0.botHelp then
		return
	end

	var0.autoBotHelp = true

	if getProxy(SettingsProxy):isTipAutoBattle() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			showStopRemind = true,
			toggleStatus = true,
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_auto"),
			custom = {
				{
					text = "text_iknow",
					sound = SFX_CANCEL,
					onCallback = function()
						if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
							getProxy(SettingsProxy):setAutoBattleTip()
						end
					end
				}
			},
			onClose = function()
				var0.autoBotHelp = false

				if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
					getProxy(SettingsProxy):setAutoBattleTip()
				end
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end

	var0.botHelp = true
end

function var0.GetAutoBotMark(arg0)
	if arg0 == SYSTEM_WORLD or arg0 == SYSTEM_WORLD_BOSS then
		return "_" .. SYSTEM_WORLD
	elseif arg0 == SYSTEM_GUILD then
		return "_" .. SYSTEM_GUILD
	else
		return ""
	end
end

return var0
