local var0 = class("MainRefundSequence")

function var0.Execute(arg0, arg1)
	local var0 = getProxy(UserProxy)

	if var0.data.limitServerIds and #var0.data.limitServerIds > 0 then
		pg.m02:sendNotification(GAME.GET_REFUND_INFO, {
			callback = function()
				arg0:ShowTip(arg1)
			end
		})
	else
		arg1()
	end
end

function var0.ShowTip(arg0, arg1)
	if getProxy(PlayerProxy):getRefundInfo() then
		local var0 = getProxy(ServerProxy)
		local var1 = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideClose = true,
			content = i18n("Supplement_pay1"),
			onYes = function()
				if var1 then
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.BACK_CHARGE)
				else
					Application.Quit()
				end
			end,
			onNo = function()
				pg.m02:sendNotification(GAME.LOGOUT, {
					code = 0
				})
			end,
			yesText = i18n("Supplement_pay4"),
			noText = i18n("word_back")
		})
	else
		arg1()
	end
end

return var0
