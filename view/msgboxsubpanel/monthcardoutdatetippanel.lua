local var0_0 = class("MonthCardOutDateTipPanel", import(".MsgboxSubPanel"))

function var0_0.SetMonthCardEndDateLocal()
	local var0_1 = getProxy(PlayerProxy):getRawData()

	if not var0_1 or not var0_1.id then
		return
	end

	local var1_1 = var0_1:getCardById(VipCard.MONTH)

	if not var1_1 or var1_1.leftDate == 0 then
		return
	end

	PlayerPrefs.SetInt("MonthCardEndDate" .. var0_1.id, var1_1:getLeftDate())
	PlayerPrefs.Save()
end

function var0_0.GetMonthCardEndDate()
	local var0_2 = getProxy(PlayerProxy):getRawData()

	if not var0_2 or not var0_2.id then
		return 0
	end

	return PlayerPrefs.GetInt("MonthCardEndDate" .. var0_2.id, 0)
end

function var0_0.SetMonthCardTipDate(arg0_3)
	if not arg0_3 then
		return
	end

	local var0_3 = getProxy(PlayerProxy):getRawData()

	if not var0_3 or not var0_3.id then
		return
	end

	PlayerPrefs.SetInt("MonthCardTipDate" .. var0_3.id, arg0_3)
	PlayerPrefs.Save()
end

function var0_0.GetMonthCardTipDate()
	local var0_4 = getProxy(PlayerProxy):getRawData()

	if not var0_4 or not var0_4.id then
		return 0
	end

	return PlayerPrefs.GetInt("MonthCardTipDate" .. var0_4.id, 0)
end

function var0_0.SetMonthCardTagDate()
	local var0_5 = getProxy(PlayerProxy):getRawData()

	if not var0_5 or not var0_5.id then
		return
	end

	local var1_5 = pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)

	PlayerPrefs.SetInt("MonthCardTagDate" .. var0_5.id, var1_5)
	PlayerPrefs.Save()
end

function var0_0.GetShowMonthCardTag()
	local var0_6 = getProxy(PlayerProxy):getRawData()

	if not var0_6 or not var0_6.id then
		return false
	end

	local var1_6 = var0_6:getCardById(VipCard.MONTH)

	if not var1_6 or var1_6.leftDate == 0 then
		return false
	end

	local var2_6 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3_6 = var1_6:getLeftDate()

	if var2_6 < var3_6 - 259200 or var3_6 < var2_6 then
		return false
	end

	return var2_6 > PlayerPrefs.GetInt("MonthCardTagDate" .. var0_6.id, 0)
end

function var0_0.TryShowMonthCardTipPanel(arg0_7)
	local function var0_7()
		if arg0_7 then
			arg0_7()
		end
	end

	local var1_7 = var0_0.GetMonthCardEndDate()

	if var1_7 == 0 then
		var0_7()

		return
	end

	local var2_7 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3_7 = var0_0.GetMonthCardTipDate()

	if var2_7 >= var1_7 - 259200 and var3_7 < var1_7 - 259200 then
		var0_0.SetMonthCardTipDate(var2_7)

		local var4_7 = pg.TimeMgr.GetInstance():STimeDescS(math.min(var2_7, var1_7), "*t")
		local var5_7 = i18n("trade_card_tips4", var4_7.year, var4_7.month, var4_7.day)
		local var6_7 = pg.TimeMgr.GetInstance():STimeDescS(var1_7, "*t")
		local var7_7 = i18n("trade_card_tips4", var6_7.year, var6_7.month, var6_7.day)
		local var8_7 = var1_7 <= var2_7

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_MONTH_CARD_TIP,
			title = pg.MsgboxMgr.TITLE_INFORMATION,
			content = i18n(var8_7 and "trade_card_tips2" or "trade_card_tips3", var7_7),
			dateText = var5_7,
			yesText = i18n("trade_card_tips1"),
			weight = LayerWeightConst.TOP_LAYER,
			onClose = var0_7,
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
					confirmMonthCard = true,
					wrap = ChargeScene.TYPE_DIAMOND
				})
			end
		})

		return
	end

	var0_7()
end

function var0_0.getUIName(arg0_10)
	return "Msgbox4MonthCardTip"
end

function var0_0.Init(arg0_11)
	var0_0.super.Init(arg0_11)
	setText(arg0_11._tf:Find("NameText"), pg.ship_data_statistics[312011].name)
end

function var0_0.UpdateView(arg0_12, arg1_12)
	arg0_12:PreRefresh(arg1_12)

	rtf(arg0_12.viewParent._window).sizeDelta = Vector2.New(960, 685)

	setText(arg0_12._tf:Find("Desc"), arg1_12.content)
	setText(arg0_12._tf:Find("Date"), arg1_12.dateText)
	arg0_12:PostRefresh(arg1_12)
end

return var0_0
