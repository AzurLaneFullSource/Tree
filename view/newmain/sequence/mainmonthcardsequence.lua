local var0_0 = class("MainMonthCardSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = MonthCardOutDateTipPanel.GetMonthCardEndDate()

	if var0_1 == 0 then
		arg1_1()

		return
	end

	local var1_1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_1 = MonthCardOutDateTipPanel.GetMonthCardTipDate()

	if var1_1 >= var0_1 - 259200 and var2_1 < var0_1 - 259200 then
		arg0_1:ShowMsg(var0_1, var1_1, arg1_1)
	else
		arg1_1()
	end
end

function var0_0.ShowMsg(arg0_2, arg1_2, arg2_2, arg3_2)
	MonthCardOutDateTipPanel.SetMonthCardTipDate(arg2_2)

	local var0_2 = pg.TimeMgr.GetInstance():STimeDescS(math.min(arg2_2, arg1_2), "*t")
	local var1_2 = i18n("trade_card_tips4", var0_2.year, var0_2.month, var0_2.day)
	local var2_2 = pg.TimeMgr.GetInstance():STimeDescS(arg1_2, "*t")
	local var3_2 = i18n("trade_card_tips4", var2_2.year, var2_2.month, var2_2.day)
	local var4_2 = arg1_2 <= arg2_2

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideNo = true,
		type = MSGBOX_TYPE_MONTH_CARD_TIP,
		title = pg.MsgboxMgr.TITLE_INFORMATION,
		content = i18n(var4_2 and "trade_card_tips2" or "trade_card_tips3", var3_2),
		dateText = var1_2,
		yesText = i18n("trade_card_tips1"),
		weight = LayerWeightConst.TOP_LAYER,
		onClose = arg3_2,
		onYes = function()
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
				confirmMonthCard = true,
				wrap = ChargeScene.TYPE_DIAMOND
			})
		end
	})
end

return var0_0
