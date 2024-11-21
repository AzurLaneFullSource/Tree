local var0_0 = class("MainCrusingActSequence")

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
	end

	seriesAsync(var1_1, arg1_1)
end

function var0_0.ShowWindow(arg0_4, arg1_4)
	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = getProxy(ContextProxy):getCurrentContext(),
		context = Context.New({
			mediator = CrusingWindowMediator,
			viewComponent = CrusingWindowLayer2,
			data = {
				onClose = arg1_4
			}
		})
	})
end

function var0_0.CheckCrusingAct(arg0_5, arg1_5, arg2_5)
	local var0_5 = PlayerPrefs.GetInt(string.format("crusing_%d_last_time", arg1_5.id), 3)
	local var1_5 = arg1_5.stopTime - pg.TimeMgr.GetInstance():GetServerTime()
	local var2_5 = arg1_5:GetCrusingUnreceiveAward()

	if #var2_5 > 0 and var0_5 > math.floor(var1_5 / 86400) then
		PlayerPrefs.SetInt(string.format("crusing_%d_last_time", arg1_5.id), math.floor(var1_5 / 86400))
		arg0_5:ShowMsg(var2_5, var1_5, arg2_5)
	else
		arg2_5()
	end
end

function var0_0.ShowMsg(arg0_6, arg1_6, arg2_6, arg3_6)
	if arg2_6 < 86400 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("battlepass_acquire_attention", math.floor(arg2_6 / 86400), math.floor(arg2_6 % 86400 / 3600)),
			items = arg1_6,
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end,
			yesText = i18n("msgbox_text_forward"),
			onNo = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("battlepass_acquire_attention", math.floor(arg2_6 / 86400), math.floor(arg2_6 % 86400 / 3600)),
			items = arg1_6,
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end,
			yesText = i18n("msgbox_text_forward"),
			onNo = arg3_6,
			weight = LayerWeightConst.TOP_LAYER
		})
	end
end

return var0_0
