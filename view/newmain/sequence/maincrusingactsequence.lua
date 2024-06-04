local var0 = class("MainCrusingActSequence")

function var0.Execute(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)
	local var1 = {}

	if var0 and not var0:isEnd() then
		table.insert(var1, function(arg0)
			arg0:CheckCrusingAct(var0, arg0)
		end)

		if PlayerPrefs.GetInt("cursing_first_enter_scene:" .. var0.id, 0) == 0 then
			table.insert(var1, function(arg0)
				PlayerPrefs.SetInt("cursing_first_enter_scene:" .. var0.id, 1)
				arg0:ShowWindow(arg0)
			end)
		end
	end

	seriesAsync(var1, arg1)
end

function var0.ShowWindow(arg0, arg1)
	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = getProxy(ContextProxy):getCurrentContext(),
		context = Context.New({
			mediator = CrusingWindowMediator,
			viewComponent = CrusingWindowLayer,
			data = {
				onClose = arg1
			}
		})
	})
end

function var0.CheckCrusingAct(arg0, arg1, arg2)
	local var0 = PlayerPrefs.GetInt(string.format("crusing_%d_last_time", arg1.id), 3)
	local var1 = arg1.stopTime - pg.TimeMgr.GetInstance():GetServerTime()
	local var2 = arg1:GetCrusingUnreceiveAward()

	if #var2 > 0 and var0 > math.floor(var1 / 86400) then
		PlayerPrefs.SetInt(string.format("crusing_%d_last_time", arg1.id), math.floor(var1 / 86400))
		arg0:ShowMsg(var2, var1, arg2)
	else
		arg2()
	end
end

function var0.ShowMsg(arg0, arg1, arg2, arg3)
	if arg2 < 86400 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("battlepass_acquire_attention", math.floor(arg2 / 86400), math.floor(arg2 % 86400 / 3600)),
			items = arg1,
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
			content = i18n("battlepass_acquire_attention", math.floor(arg2 / 86400), math.floor(arg2 % 86400 / 3600)),
			items = arg1,
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end,
			yesText = i18n("msgbox_text_forward"),
			onNo = arg3,
			weight = LayerWeightConst.TOP_LAYER
		})
	end
end

return var0
