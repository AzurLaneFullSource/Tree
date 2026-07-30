local var0_0 = class("MainCrusingActSequence")
local var1_0 = false

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)
	local var1_1 = {}

	if var0_1 and not var0_1:isEnd() then
		table.insert(var1_1, function(arg0_2)
			arg0_1:CheckCrusingAct(var0_1, arg0_2)
		end)

		if PlayerPrefs.GetInt("cursing_first_enter_scene:" .. var0_1.id, 0) == 0 then
			table.insert(var1_1, function(arg0_3)
				PlayerPrefs.SetInt("cursing_first_enter_scene:" .. var0_1.id, 1)
				arg0_1:ShowWindow(arg0_3)
			end)
		end

		table.insert(var1_1, function(arg0_4)
			if var1_0 then
				arg0_4()

				return
			end

			local var0_4 = var0_1.stopTime - pg.TimeMgr.GetInstance():GetServerTime()
			local var1_4 = math.floor(var0_4 / 86400)

			if PlayerPrefs.GetInt("crusing_last_remind_day_" .. var1_4) == 1 then
				arg0_4()

				return
			end

			var1_0 = true

			local var2_4 = pg.battlepass_event_pt[var0_1.id].map_name
			local var3_4 = i18n("cruise_title_" .. var2_4)

			if var1_4 <= pg.gameset.world_cruise_due_days.key_value then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					showStopRemind = true,
					hideNo = true,
					toggleStatus = true,
					content = i18n("world_cruise_due_tips", var3_4, var1_4),
					onYes = function()
						if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
							PlayerPrefs.SetInt("crusing_last_remind_day_" .. var1_4, 1)
						end

						arg0_4()
					end,
					onClose = function()
						if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
							PlayerPrefs.SetInt("crusing_last_remind_day_" .. var1_4, 1)
						end

						arg0_4()
					end
				})
			else
				arg0_4()
			end
		end)
	end

	seriesAsync(var1_1, arg1_1)
end

function var0_0.ShowWindow(arg0_7, arg1_7)
	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = getProxy(ContextProxy):getCurrentContext(),
		context = Context.New({
			mediator = CrusingWindowMediator,
			viewComponent = CrusingWindowLayer2,
			data = {
				onClose = arg1_7
			}
		})
	})
end

function var0_0.CheckCrusingAct(arg0_8, arg1_8, arg2_8)
	local var0_8 = PlayerPrefs.GetInt(string.format("crusing_%d_last_time", arg1_8.id), 3)
	local var1_8 = arg1_8.stopTime - pg.TimeMgr.GetInstance():GetServerTime()
	local var2_8 = arg1_8:GetCrusingUnreceiveAward()

	if #var2_8 > 0 and var0_8 > math.floor(var1_8 / 86400) then
		PlayerPrefs.SetInt(string.format("crusing_%d_last_time", arg1_8.id), math.floor(var1_8 / 86400))
		arg0_8:ShowMsg(var2_8, var1_8, arg2_8)
	else
		arg2_8()
	end
end

function var0_0.ShowMsg(arg0_9, arg1_9, arg2_9, arg3_9)
	if arg2_9 < 86400 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("battlepass_acquire_attention", math.floor(arg2_9 / 86400), math.floor(arg2_9 % 86400 / 3600)),
			items = arg1_9,
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end,
			yesText = i18n("msgbox_text_forward"),
			onNo = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end
		})
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("battlepass_acquire_attention", math.floor(arg2_9 / 86400), math.floor(arg2_9 % 86400 / 3600)),
			items = arg1_9,
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end,
			yesText = i18n("msgbox_text_forward"),
			onNo = arg3_9
		})
	end
end

return var0_0
