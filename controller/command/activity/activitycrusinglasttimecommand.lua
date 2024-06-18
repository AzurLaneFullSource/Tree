local var0_0 = class("ActivityCrusingLastTimeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.awards
	local var2_1 = var0_1.time
	local var3_1 = var0_1.closeFunc

	if var2_1 < 86400 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("battlepass_acquire_attention", math.floor(var2_1 / 86400), math.floor(var2_1 % 86400 / 3600)),
			items = var1_1,
			onYes = function()
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end,
			yesText = i18n("msgbox_text_forward"),
			onNo = function()
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_ITEM_BOX,
			content = i18n("battlepass_acquire_attention", math.floor(var2_1 / 86400), math.floor(var2_1 % 86400 / 3600)),
			items = var1_1,
			onYes = function()
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
			end,
			yesText = i18n("msgbox_text_forward"),
			onNo = var3_1,
			weight = LayerWeightConst.TOP_LAYER
		})
	end
end

return var0_0
