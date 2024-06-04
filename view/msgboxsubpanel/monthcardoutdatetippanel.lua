local var0 = class("MonthCardOutDateTipPanel", import(".MsgboxSubPanel"))

function var0.SetMonthCardEndDateLocal()
	local var0 = getProxy(PlayerProxy):getRawData()

	if not var0 or not var0.id then
		return
	end

	local var1 = var0:getCardById(VipCard.MONTH)

	if not var1 or var1.leftDate == 0 then
		return
	end

	PlayerPrefs.SetInt("MonthCardEndDate" .. var0.id, var1:getLeftDate())
	PlayerPrefs.Save()
end

function var0.GetMonthCardEndDate()
	local var0 = getProxy(PlayerProxy):getRawData()

	if not var0 or not var0.id then
		return 0
	end

	return PlayerPrefs.GetInt("MonthCardEndDate" .. var0.id, 0)
end

function var0.SetMonthCardTipDate(arg0)
	if not arg0 then
		return
	end

	local var0 = getProxy(PlayerProxy):getRawData()

	if not var0 or not var0.id then
		return
	end

	PlayerPrefs.SetInt("MonthCardTipDate" .. var0.id, arg0)
	PlayerPrefs.Save()
end

function var0.GetMonthCardTipDate()
	local var0 = getProxy(PlayerProxy):getRawData()

	if not var0 or not var0.id then
		return 0
	end

	return PlayerPrefs.GetInt("MonthCardTipDate" .. var0.id, 0)
end

function var0.SetMonthCardTagDate()
	local var0 = getProxy(PlayerProxy):getRawData()

	if not var0 or not var0.id then
		return
	end

	local var1 = pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)

	PlayerPrefs.SetInt("MonthCardTagDate" .. var0.id, var1)
	PlayerPrefs.Save()
end

function var0.GetShowMonthCardTag()
	local var0 = getProxy(PlayerProxy):getRawData()

	if not var0 or not var0.id then
		return false
	end

	local var1 = var0:getCardById(VipCard.MONTH)

	if not var1 or var1.leftDate == 0 then
		return false
	end

	local var2 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3 = var1:getLeftDate()

	if var2 < var3 - 259200 or var3 < var2 then
		return false
	end

	return var2 > PlayerPrefs.GetInt("MonthCardTagDate" .. var0.id, 0)
end

function var0.TryShowMonthCardTipPanel(arg0)
	local function var0()
		if arg0 then
			arg0()
		end
	end

	local var1 = var0.GetMonthCardEndDate()

	if var1 == 0 then
		var0()

		return
	end

	local var2 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3 = var0.GetMonthCardTipDate()

	if var2 >= var1 - 259200 and var3 < var1 - 259200 then
		var0.SetMonthCardTipDate(var2)

		local var4 = pg.TimeMgr.GetInstance():STimeDescS(math.min(var2, var1), "*t")
		local var5 = i18n("trade_card_tips4", var4.year, var4.month, var4.day)
		local var6 = pg.TimeMgr.GetInstance():STimeDescS(var1, "*t")
		local var7 = i18n("trade_card_tips4", var6.year, var6.month, var6.day)
		local var8 = var1 <= var2

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_MONTH_CARD_TIP,
			title = pg.MsgboxMgr.TITLE_INFORMATION,
			content = i18n(var8 and "trade_card_tips2" or "trade_card_tips3", var7),
			dateText = var5,
			yesText = i18n("trade_card_tips1"),
			weight = LayerWeightConst.TOP_LAYER,
			onClose = var0,
			onYes = function()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
					confirmMonthCard = true,
					wrap = ChargeScene.TYPE_DIAMOND
				})
			end
		})

		return
	end

	var0()
end

function var0.getUIName(arg0)
	return "Msgbox4MonthCardTip"
end

function var0.Init(arg0)
	var0.super.Init(arg0)
	setText(arg0._tf:Find("NameText"), pg.ship_data_statistics[312011].name)
end

function var0.UpdateView(arg0, arg1)
	arg0:PreRefresh(arg1)

	rtf(arg0.viewParent._window).sizeDelta = Vector2.New(960, 685)

	setText(arg0._tf:Find("Desc"), arg1.content)
	setText(arg0._tf:Find("Date"), arg1.dateText)
	arg0:PostRefresh(arg1)
end

return var0
