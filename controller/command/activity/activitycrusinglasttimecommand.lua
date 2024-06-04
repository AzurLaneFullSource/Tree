local var0 = class("ActivityCrusingLastTimeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.awards
	local var2 = var0.time
	local var3 = var0.closeFunc

	if var2 < 86400 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("battlepass_acquire_attention", math.floor(var2 / 86400), math.floor(var2 % 86400 / 3600)),
			items = var1,
			onYes = function()
				arg0:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end,
			yesText = i18n("msgbox_text_forward"),
			onNo = function()
				arg0:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("battlepass_acquire_attention", math.floor(var2 / 86400), math.floor(var2 % 86400 / 3600)),
			items = var1,
			onYes = function()
				arg0:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end,
			yesText = i18n("msgbox_text_forward"),
			onNo = var3,
			weight = LayerWeightConst.TOP_LAYER
		})
	end
end

return var0
