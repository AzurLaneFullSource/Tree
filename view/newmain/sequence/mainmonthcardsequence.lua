local var0 = class("MainMonthCardSequence")

function var0.Execute(arg0, arg1)
	local var0 = MonthCardOutDateTipPanel.GetMonthCardEndDate()

	if var0 == 0 then
		arg1()

		return
	end

	local var1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2 = MonthCardOutDateTipPanel.GetMonthCardTipDate()

	if var1 >= var0 - 259200 and var2 < var0 - 259200 then
		arg0:ShowMsg(var0, var1, arg1)
	else
		arg1()
	end
end

function var0.ShowMsg(arg0, arg1, arg2, arg3)
	MonthCardOutDateTipPanel.SetMonthCardTipDate(arg2)

	local var0 = pg.TimeMgr.GetInstance():STimeDescS(math.min(arg2, arg1), "*t")
	local var1 = i18n("trade_card_tips4", var0.year, var0.month, var0.day)
	local var2 = pg.TimeMgr.GetInstance():STimeDescS(arg1, "*t")
	local var3 = i18n("trade_card_tips4", var2.year, var2.month, var2.day)
	local var4 = arg1 <= arg2

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		type = MSGBOX_TYPE_MONTH_CARD_TIP,
		title = pg.MsgboxMgr.TITLE_INFORMATION,
		content = i18n(var4 and "trade_card_tips2" or "trade_card_tips3", var3),
		dateText = var1,
		yesText = i18n("trade_card_tips1"),
		weight = LayerWeightConst.TOP_LAYER,
		onClose = arg3,
		onYes = function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
				confirmMonthCard = true,
				wrap = ChargeScene.TYPE_DIAMOND
			})
		end
	})
end

return var0
