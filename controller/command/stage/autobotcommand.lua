local var0_0 = class("AutoBotCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.isActiveBot
	local var2_1 = var0_1.toggle
	local var3_1 = var0_1.system
	local var4_1 = var0_0.GetAutoBotMark(var3_1)

	arg0_1:sendNotification(BattleMediator.UPDATE_AUTO_COUNT, {
		isOn = var1_1
	})

	if var0_0.autoBotSatisfied() then
		if PlayerPrefs.GetInt("autoBotIsAcitve" .. var4_1, 0) == not var1_1 then
			-- block empty
		else
			PlayerPrefs.SetInt("autoBotIsAcitve" .. var4_1, not var1_1 and 1 or 0)
			var0_0.activeBotHelp(not var1_1)
		end
	elseif not var1_1 then
		if var2_1 then
			onDelayTick(function()
				GetComponent(var2_1, typeof(Toggle)).isOn = false
			end, 0.1)
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_limit_tip"))
	end

	if var1_1 then
		arg0_1:sendNotification(GAME.AUTO_SUB, {
			isActiveSub = true,
			system = var3_1
		})
	end
end

function var0_0.autoBotSatisfied()
	local var0_3 = getProxy(ChapterProxy)

	return var0_3 and var0_3:getChapterById(AUTO_ENABLE_CHAPTER):isClear()
end

function var0_0.activeBotHelp(arg0_4)
	local var0_4 = getProxy(PlayerProxy)

	if not arg0_4 then
		if var0_0.autoBotHelp then
			pg.MsgboxMgr.GetInstance():hide()
		end

		return
	end

	if var0_4.botHelp then
		return
	end

	var0_0.autoBotHelp = true

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
				var0_0.autoBotHelp = false

				if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
					getProxy(SettingsProxy):setAutoBattleTip()
				end
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end

	var0_4.botHelp = true
end

function var0_0.GetAutoBotMark(arg0_7)
	if arg0_7 == SYSTEM_WORLD or arg0_7 == SYSTEM_WORLD_BOSS then
		return "_" .. SYSTEM_WORLD
	elseif arg0_7 == SYSTEM_GUILD then
		return "_" .. SYSTEM_GUILD
	else
		return ""
	end
end

return var0_0
