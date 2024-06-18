local var0_0 = class("MainRefundSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(UserProxy)

	if var0_1.data.limitServerIds and #var0_1.data.limitServerIds > 0 then
		pg.m02:sendNotification(GAME.GET_REFUND_INFO, {
			callback = function()
				arg0_1:ShowTip(arg1_1)
			end
		})
	else
		arg1_1()
	end
end

function var0_0.ShowTip(arg0_3, arg1_3)
	if getProxy(PlayerProxy):getRefundInfo() then
		local var0_3 = getProxy(ServerProxy)
		local var1_3 = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideClose = true,
			content = i18n("Supplement_pay1"),
			onYes = function()
				if var1_3 then
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
		arg1_3()
	end
end

return var0_0
