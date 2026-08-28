local var0_0 = class("ChapterAutoPanel", import("view.base.BaseSubView"))

var0_0.TIP_KEY = "CHAPTER_AUTO_HELP_TIP"

function var0_0.getUIName(arg0_1)
	return "ChapterAutoPanel"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2.uiTitleText, i18n("auto_battle_headline"))
	setText(arg0_2.uiTitleEnText, i18n("auto_battle_headline_en"))
	setText(arg0_2.uiStartBtn:Find("Text"), i18n("auto_battle_confirm_button"))
	setText(arg0_2.uiTipText, i18n("auto_battle_info_tips"))
	setText(arg0_2.uiTipText2, i18n("auto_battle_info_tips"))
	setText(arg0_2.uiLeftDescText, i18n("auto_battle_cnt"))
	setText(arg0_2.uiRightDescText, i18n("auto_battle_cnt_book"))
	setText(arg0_2.uiLeftContentTF:Find("conmuse_time/header"), i18n("auto_battle_time_left"))
	setText(arg0_2.uiLeftContentTF:Find("remain_time/header"), i18n("auto_battle_cost_time"))
	setText(arg0_2.uiRightContentTF:Find("oil/header"), i18n("auto_battle_cost_extra"))
	setText(arg0_2.uiRightContentTF:Find("ticket/header"), i18n("auto_battle_cost_extra"))
	setText(arg0_2.uiLeftAddBtn:Find("Text"), i18n("auto_battle_add_time"))
	setText(arg0_2.uiLeftProficiencyHeaderText, i18n("auto_battle_class_exp_head"))
	setText(arg0_2.uiLeftAwardHeaderText, i18n("auto_battle_base_loot"))
	setText(arg0_2.uiRightAwardHeaderText, i18n("auto_battle_extra_loot"))

	arg0_2.oilCostTF = arg0_2.uiRightContentTF:Find("oil")
	arg0_2.ticketCostTF = arg0_2.uiRightContentTF:Find("ticket")
	arg0_2.awardEmptyTF = arg0_2._tf:Find("bottom/drops/frame/empty")

	setText(arg0_2.awardEmptyTF:Find("Text"), i18n("auto_battle_extra_loot_lock"))

	arg0_2.ticketUIList = UIItemList.New(arg0_2.uiTicketTF, arg0_2.uiTicketTF:Find("tpl"))
	arg0_2.awardUIList = UIItemList.New(arg0_2.uiRightAwardContentTF, arg0_2.uiRightAwardContentTF:Find("item"))
	arg0_2.leftPageUtil = ChapterAutoPageUtil.New(arg0_2.uiLeftContentTF:Find("value_bg/left"), arg0_2.uiLeftContentTF:Find("value_bg/right"), arg0_2.uiLeftContentTF:Find("max"), arg0_2.uiLeftContentTF:Find("value_bg/value"))
	arg0_2.rightPageUtil = ChapterAutoPageUtil.New(arg0_2.uiRightContentTF:Find("value_bg/left"), arg0_2.uiRightContentTF:Find("value_bg/right"), arg0_2.uiRightContentTF:Find("max"), arg0_2.uiRightContentTF:Find("value_bg/value"))
	arg0_2.addTimePanel = ChapterAutoAddTimePanel.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.playerId = getProxy(PlayerProxy):getRawData().id
end

function var0_0.OnInit(arg0_3)
	arg0_3.ticketUIList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_3.ticketList[arg1_4 + 1]

			setText(arg2_4:Find("Text"), var0_4:GetCount())

			local var1_4 = var0_4:IsForever()

			setActive(arg2_4:Find("time"), not var1_4)

			if not var1_4 then
				local var2_4 = var0_4:GetRemainTime()
				local var3_4 = var2_4 > 86400
				local var4_4 = var3_4 and "auto_battle_book_day" or "auto_battle_book_hour"
				local var5_4 = math.floor(var2_4 / (var3_4 and 86400 or 3600))

				setText(arg2_4:Find("time/Text"), i18n(var4_4, var5_4))
			end
		end
	end)
	arg0_3.awardUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_3:UpdateAwardTpl(arg1_5, arg2_5)
		end
	end)
	arg0_3.leftPageUtil:setNumUpdate(function(arg0_6)
		arg0_3.count = arg0_6

		arg0_3:UpdateLeftContent()
	end)
	arg0_3.rightPageUtil:setNumUpdate(function(arg0_7)
		arg0_3.ticketCnt = arg0_7

		arg0_3:UpdateRightContent()
	end)
	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.uiCloseBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.uiLeftAddBtn, function()
		arg0_3.addTimePanel:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("top/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("auto_battle_help")
		})
	end, SFX_PANEL)

	arg0_3.remasterTicketCost = getProxy(ChapterProxy):getRemasterTicketCost()
end

function var0_0.Show(arg0_12)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
	var0_0.super.Show(arg0_12)
end

function var0_0.Hide(arg0_13)
	var0_0.super.Hide(arg0_13)

	if arg0_13.addTimePanel and arg0_13.addTimePanel:isShowing() then
		arg0_13.addTimePanel:Hide()
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf, arg0_13._parentTf)
end

function var0_0.Enter(arg0_14, arg1_14)
	arg0_14.chapter = arg1_14

	local var0_14 = arg1_14.id

	arg0_14.config = pg.chapter_auto_statistics[var0_14]
	arg0_14.oilCostOnce = arg0_14.config.oil_limit
	arg0_14.proficiencyOnce = arg0_14.config.base_class_exp

	local var1_14 = getProxy(ChapterAutoProxy)

	arg0_14.timeCostOnce = var1_14:GetRecord(ChapterAutoProxy.TYPE.SLG, var0_14)
	arg0_14.remainTime = var1_14:GetRemainTime()
	arg0_14.storeOil = var1_14:GetOil()

	setActive(arg0_14.uiStoreOilTF, arg0_14.storeOil > 0)
	setText(arg0_14.uiStoreOilTF:Find("Text"), i18n("auto_battle_oil_store_tip", arg0_14.storeOil))

	arg0_14.count = arg0_14.remainTime >= arg0_14.timeCostOnce and 1 or 0
	arg0_14.ticketCnt = 0

	arg0_14:RefreshTickets()
	arg0_14.leftPageUtil:setDefaultNum(arg0_14.count)
	arg0_14:RefreshLeftPageUtil()
	arg0_14:UpdateLeftContent()
	arg0_14.rightPageUtil:setDefaultNum(0)
	arg0_14:RefreshRightPageUtil()
	arg0_14:UpdateRightContent()

	arg0_14.awards = var0_0.GetAwards(arg0_14.chapter)

	arg0_14.awardUIList:align(#arg0_14.awards)
	arg0_14:Show()

	if arg0_14:NeedHelpPop() then
		arg0_14:PopHelpTip()
	end
end

function var0_0.RefreshView(arg0_15)
	arg0_15:Enter(arg0_15.chapter)
end

function var0_0.RefreshLeftPageUtil(arg0_16)
	arg0_16.maxCnt = arg0_16.remainTime > 0 and math.ceil(arg0_16.remainTime / arg0_16.timeCostOnce) or 0

	arg0_16.leftPageUtil:setMaxNum(arg0_16.maxCnt)
	arg0_16.leftPageUtil:SetTipInfo({
		arg0_16.maxCnt
	}, {
		i18n("auto_battle_time_limit_reached")
	})
end

function var0_0.UpdateLeftContent(arg0_17)
	local var0_17 = pg.TimeMgr.GetInstance()
	local var1_17 = var0_17:DescCDTime(arg0_17.remainTime)

	setText(arg0_17.uiLeftRemainText, arg0_17.remainTime < 0 and setColorStr(var1_17, COLOR_RED) or var1_17)
	setText(arg0_17.uiLeftConsumeText, var0_17:DescCDTime(arg0_17.timeCostOnce * arg0_17.count))
	setText(arg0_17.uiLeftProficiencyText, arg0_17.proficiencyOnce * arg0_17.count)
	arg0_17:RefreshRightPageUtil()
end

function var0_0.RefreshRightPageUtil(arg0_18)
	arg0_18.maxTicketCnt = math.min(arg0_18.ownTicketCnt, arg0_18.count)

	arg0_18.rightPageUtil:setMaxNum(arg0_18.maxTicketCnt)
	arg0_18.rightPageUtil:SetTipInfo({
		arg0_18.count,
		arg0_18.ownTicketCnt
	}, {
		i18n("auto_battle_book_times_reached"),
		i18n("auto_battle_book_max_reached")
	})
	arg0_18.rightPageUtil:setCurNum(math.min(arg0_18.ticketCnt, arg0_18.maxTicketCnt))
end

function var0_0.RefreshTickets(arg0_19)
	local var0_19 = getProxy(ChapterAutoProxy)

	arg0_19.ticketList = var0_19:GetTicketListByType(ChapterAutoTicket.TYPE.MAIN)

	table.sort(arg0_19.ticketList, CompareFuncs({
		function(arg0_20)
			return arg0_20.id
		end
	}))
	arg0_19.ticketUIList:align(#arg0_19.ticketList)

	arg0_19.ownTicketCnt = var0_19:GetValidTicketCntByType(ChapterAutoTicket.TYPE.MAIN)
end

function var0_0.UpdateRightContent(arg0_21)
	local var0_21 = arg0_21.ticketCnt <= 0
	local var1_21 = arg0_21.oilCostOnce * arg0_21.ticketCnt
	local var2_21 = i18n("auto_battle_cost_oil", var1_21)
	local var3_21 = getProxy(PlayerProxy):getRawData()
	local var4_21 = var1_21 - arg0_21.storeOil > var3_21.oil

	if var4_21 then
		var2_21 = string.gsub(var2_21, "#92fc63", COLOR_RED)
	end

	setText(arg0_21.uiRightCostOilText, var0_21 and "" or var2_21)

	local var5_21 = i18n("auto_battle_cost_book", arg0_21.ticketCnt)
	local var6_21 = arg0_21.ticketCnt > arg0_21.ownTicketCnt

	if var6_21 then
		var5_21 = string.gsub(var5_21, "#92fc63", COLOR_RED)
	end

	setText(arg0_21.uiRightCostTicketText, var0_21 and "" or var5_21)
	setActive(arg0_21.awardEmptyTF, var0_21)
	setActive(arg0_21.oilCostTF:Find("empty"), var0_21)
	setActive(arg0_21.ticketCostTF:Find("empty"), var0_21)

	GetOrAddComponent(arg0_21.oilCostTF, typeof(CanvasGroup)).alpha = var0_21 and 0.5 or 1
	GetOrAddComponent(arg0_21.ticketCostTF, typeof(CanvasGroup)).alpha = var0_21 and 0.5 or 1

	onButton(arg0_21, arg0_21.uiStartBtn, function()
		if arg0_21.count <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_times_zero"))

			return
		end

		if var4_21 or var6_21 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_not_enough_resource"))

			return
		end

		local var0_22 = getProxy(ChapterProxy)
		local var1_22 = var0_22:getMapById(arg0_21.chapter:getConfig("map")):isRemaster()

		if var1_22 and var0_22.remasterTickets < arg0_21.ticketCnt * arg0_21.remasterTicketCost then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_tickets_not_enough"))

			return
		end

		arg0_21:OnStart(var1_22)
	end, SFX_PANEL)
end

function var0_0.OnStart(arg0_23, arg1_23)
	seriesAsync({
		function(arg0_24)
			if arg1_23 and arg0_23.ticketCnt > 0 and PlayerPrefs.GetString("remaster_tip") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					showStopRemind = true,
					content = i18n("levelScene_activate_remaster_auto", arg0_23.ticketCnt * arg0_23.remasterTicketCost),
					onYes = function()
						if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
							PlayerPrefs.SetString("remaster_tip", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))
						end

						arg0_24()
					end
				})

				return
			end

			arg0_24()
		end
	}, function()
		pg.m02:sendNotification(GAME.START_CHAPTER_AUTO, {
			type = ChapterAutoProxy.TYPE.SLG,
			id = arg0_23.chapter.id,
			num = arg0_23.count,
			ticketNum = arg0_23.ticketCnt
		})
	end)
end

function var0_0.UpdateAwardTpl(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27.awards[arg1_27 + 1]
	local var1_27 = Drop.Create(var0_27)

	updateDrop(arg2_27, var1_27)
	onButton(arg0_27, arg2_27, function()
		if ({
			[99] = true
		})[var1_27:getConfig("type")] then
			local function var0_28(arg0_29)
				local var0_29 = var1_27:getConfig("display_icon")
				local var1_29 = {}

				for iter0_29, iter1_29 in ipairs(var0_29) do
					local var2_29 = iter1_29[1]
					local var3_29 = iter1_29[2]
					local var4_29 = var2_29 == DROP_TYPE_SHIP and not table.contains(arg0_29, var3_29)

					var1_29[#var1_29 + 1] = {
						type = var2_29,
						id = var3_29,
						anonymous = var4_29
					}
				end

				arg0_27:emit(BaseUI.ON_DROP_LIST, {
					item2Row = true,
					itemList = var1_29,
					content = var1_27:getConfig("display")
				})
			end

			arg0_27:emit(LevelMediator2.GET_CHAPTER_DROP_SHIP_LIST, arg0_27.chapter.id, var0_28)
		else
			arg0_27:emit(BaseUI.ON_DROP, var1_27)
		end
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_30)
	if arg0_30.addTimePanel ~= nil then
		arg0_30.addTimePanel:Destroy()

		arg0_30.addTimePanel = nil
	end

	arg0_30.leftPageUtil:Dispose()
	arg0_30.rightPageUtil:Dispose()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_30._tf, arg0_30._parentTf)
end

function var0_0.NeedHelpPop(arg0_31)
	return PlayerPrefs.GetInt(var0_0.TIP_KEY .. "_" .. arg0_31.playerId, 0) == 0
end

function var0_0.PopHelpTip(arg0_32)
	PlayerPrefs.SetInt(var0_0.TIP_KEY .. "_" .. arg0_32.playerId, 1)
	PlayerPrefs.Save()
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		type = MSGBOX_TYPE_HELP,
		helps = i18n("auto_battle_help")
	})
end

function var0_0.GetAwards(arg0_33)
	local var0_33 = LevelInfoView.getChapterAwards(arg0_33)
	local var1_33 = pg.chapter_auto_statistics[arg0_33.id].drop_display_extra

	if type(var1_33) == "table" then
		for iter0_33, iter1_33 in ipairs(var1_33) do
			table.insert(var0_33, {
				iter1_33[1],
				iter1_33[2]
			})
		end
	end

	return var0_33
end

return var0_0
