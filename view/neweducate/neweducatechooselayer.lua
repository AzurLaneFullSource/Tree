local var0_0 = class("NewEducateChooseLayer", import("view.newEducate.base.NewEducateBaseUI"))

var0_0.TYPE = {
	TAROT = 1,
	ENTYR = 2
}

function var0_0.getUIName(arg0_1)
	return "NewEducateChooseUI"
end

function var0_0.preload(arg0_2, arg1_2)
	seriesAsync({
		function(arg0_3)
			local var0_3 = getProxy(NewEducateProxy):GetCurChar()

			if #var0_3:GetFSM():GetPriorityState():GetChoices() > 0 then
				arg0_3()
			else
				pg.m02:sendNotification(GAME.NEW_EDUCATE_REQUEST_CHOICES, {
					id = var0_3.id,
					callback = arg0_3
				})
			end
		end
	}, arg1_2)
end

function var0_0.init(arg0_4)
	arg0_4.blockTF = arg0_4._tf:Find("block")

	setActive(arg0_4.blockTF, true)

	arg0_4.showPanel = arg0_4._tf:Find("show_panel")

	setText(arg0_4.showPanel:Find("title"), i18n("child2_choose_title"))

	arg0_4.tipBtn = arg0_4.showPanel:Find("tip")

	setText(arg0_4.showPanel:Find("refresh/Text"), i18n("child2_refresh_title"))

	arg0_4.refreshCntText = arg0_4.showPanel:Find("refresh/value"):GetComponent(typeof(Text))
	arg0_4.toggleTF = arg0_4.showPanel:Find("toggle")

	setText(arg0_4.toggleTF:Find("Text"), i18n("child2_show_detail_desc"))

	arg0_4.tarotTF = arg0_4.showPanel:Find("current/tarot")
	arg0_4.tarotCard = NewEducateTarotCard.New(arg0_4.tarotTF)
	arg0_4.emptyTarotTF = arg0_4.showPanel:Find("current/empty")

	setText(arg0_4.emptyTarotTF:Find("Text"), i18n("child2_tarot_empty"))

	arg0_4.tarotUIList = UIItemList.New(arg0_4.showPanel:Find("tarot_list"), arg0_4.showPanel:Find("tarot_list/tpl"))

	arg0_4.tarotUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventInit then
			arg2_5.name = arg1_5 + 1
			arg0_4.cards[arg1_5 + 1] = NewEducateTarotCard.New(arg2_5)
		elseif arg0_5 == UIItemList.EventUpdate then
			arg0_4:UpdateTarotChoice(arg1_5, arg2_5)
		end
	end)

	arg0_4.entryUIList = UIItemList.New(arg0_4.showPanel:Find("entry_list"), arg0_4.showPanel:Find("entry_list/tpl"))

	arg0_4.entryUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventInit then
			arg2_6.name = arg1_6 + 1
			arg0_4.cards[arg1_6 + 1] = NewEducateEntryCard.New(arg2_6)
		elseif arg0_6 == UIItemList.EventUpdate then
			arg0_4:UpdateEntryChoice(arg1_6, arg2_6)
		end
	end)

	arg0_4.giveupBtn = arg0_4.showPanel:Find("btns/giveup")

	setText(arg0_4.giveupBtn:Find("Text"), i18n("child2_choose_giveup"))

	arg0_4.hideBtn = arg0_4.showPanel:Find("btns/hide")

	setText(arg0_4.hideBtn:Find("Text"), i18n("child2_choose_hide"))

	arg0_4.hidePanel = arg0_4._tf:Find("hide_panel")
	arg0_4.showBtn = arg0_4.hidePanel:Find("show")

	setActive(arg0_4.showPanel, true)
	setActive(arg0_4.hidePanel, false)

	arg0_4.emptyIds = pg.gameset.child2_pool_exhausted_token.description
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7.tipBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.child2_choose_help.tip
		})
	end, SFX_PANEL)
	onToggle(arg0_7, arg0_7.toggleTF, function(arg0_9)
		NewEducateHelper.SetTarotDeatilDescData(arg0_9)
		arg0_7:SwitchDescMode(arg0_9)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.giveupBtn, function()
		arg0_7:emit(NewEducateChooseMediator.ON_GIVE_UP_CHOICE)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.hideBtn, function()
		arg0_7:UnOverlayPanel(arg0_7._tf)
		setActive(arg0_7.showPanel, false)
		setActive(arg0_7.hidePanel, true)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.showBtn, function()
		setActive(arg0_7.showPanel, true)
		setActive(arg0_7.hidePanel, false)
		arg0_7:BlurPanel(arg0_7._tf, {
			groupDelta = 3
		})
	end, SFX_PANEL)

	arg0_7.config = pg.child2_benefit_list
	arg0_7.tarotRefreshCnt = pg.gameset.child2_tarot_refresh_limit.key_value
	arg0_7.entryRefreshCnt = pg.gameset.child2_effect_refresh_limit.key_value
	arg0_7.cards = {}

	arg0_7:UpdateView()
	triggerButton(arg0_7.showBtn)
	triggerToggle(arg0_7.toggleTF, NewEducateHelper.IsShowTarotDeatilDesc())
	NewEducateGuideSequence.CheckGuide(arg0_7.__cname)

	arg0_7.isMaked = false

	onDelayTick(function()
		setActive(arg0_7.blockTF, false)
	end, tonumber(pg.gameset.child2_select_sleep_time.description))
end

function var0_0.IsPoolEmpty(arg0_14)
	return underscore.any(arg0_14.emptyIds, function(arg0_15)
		return table.contains(arg0_14.choices, arg0_15)
	end)
end

function var0_0.UpdateView(arg0_16)
	arg0_16.tarotId = arg0_16.contextData.char:GetTarotId()
	arg0_16.state = arg0_16.contextData.char:GetFSM():GetPriorityState()
	arg0_16.choices = arg0_16.state:GetChoices()
	arg0_16.usedCnts = arg0_16.state:GetUsedCnts()

	arg0_16:UpdateRefreshCnt()

	arg0_16.type = arg0_16.config[arg0_16.choices[1]].type == NewEducateBuff.TYPE.TAROT and var0_0.TYPE.TAROT or var0_0.TYPE.ENTYR

	arg0_16:UpdateTarotPanel()
	arg0_16:UpdateGiveUpBtn()
	arg0_16:UpdateChoices()
	setActive(arg0_16.hideBtn, arg0_16.tarotId)
end

function var0_0.UpdateRefreshCnt(arg0_17)
	arg0_17.refreshCnt = arg0_17.contextData.char:GetResByType(NewEducateChar.RES_TYPE.REFRESH_CHOICE)
	arg0_17.refreshCntText.text = arg0_17.refreshCnt
end

function var0_0.UpdateTarotPanel(arg0_18)
	setActive(arg0_18.emptyTarotTF, not arg0_18.tarotId)
	setActive(arg0_18.tarotTF, arg0_18.tarotId)

	if arg0_18.tarotId then
		arg0_18.tarotCard:Update(arg0_18.tarotId, NewEducateTarotCard.TYPE.CURRENT)
	end
end

function var0_0.UpdateGiveUpBtn(arg0_19)
	setActive(arg0_19.giveupBtn, arg0_19.tarotId)

	if arg0_19.tarotId then
		local var0_19 = arg0_19.state:IsFromShop() and "shop_disclaim_refund" or "event_disclaim_refund"
		local var1_19 = arg0_19.contextData.char:getConfig(var0_19)
		local var2_19 = arg0_19.type == var0_0.TYPE.TAROT and var1_19[2] or var1_19[2]

		setText(arg0_19.giveupBtn:Find("res/Text"), "+" .. var2_19[3])
	end
end

function var0_0.UpdateChoices(arg0_20)
	setActive(arg0_20.tarotUIList.container, arg0_20.type == var0_0.TYPE.TAROT)
	setActive(arg0_20.entryUIList.container, arg0_20.type == var0_0.TYPE.ENTYR)
	;(arg0_20.type == var0_0.TYPE.TAROT and arg0_20.tarotUIList or arg0_20.entryUIList):align(#arg0_20.choices)
end

function var0_0.UpdateTarotChoice(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg1_21 + 1
	local var1_21 = arg0_21.choices[var0_21]

	arg0_21.cards[var0_21]:Update(var1_21)
	onButton(arg0_21, arg2_21, function()
		seriesAsync({
			function(arg0_23)
				if arg0_21.tarotId then
					arg0_21:emit(var0_0.ON_BOX, {
						content = i18n("child2_replace_sure_tip"),
						onYes = arg0_23
					})
				else
					arg0_23()
				end
			end
		}, function()
			arg0_21:emit(NewEducateChooseMediator.ON_MAKE_CHOICE, var0_21)
		end)
	end, SFX_PANEL)
	arg0_21:UpdateRefreshBtn(var0_21, arg2_21:Find("refresh_blue"), arg2_21:Find("refresh_grey"))
end

function var0_0.UpdateEntryChoice(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg1_25 + 1
	local var1_25 = arg0_25.choices[var0_25]

	arg0_25.cards[var0_25]:Update(var1_25)
	onButton(arg0_25, arg2_25, function()
		if arg0_25.isMaked then
			return
		end

		arg0_25:emit(NewEducateChooseMediator.ON_MAKE_CHOICE, var0_25)

		arg0_25.isMaked = true
	end, SFX_PANEL)
	arg0_25:UpdateRefreshBtn(var0_25, arg2_25:Find("refresh_blue"), arg2_25:Find("refresh_grey"))
end

function var0_0.UpdateRefreshBtn(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = arg0_27.usedCnts[arg1_27]
	local var1_27 = (arg0_27.type == var0_0.TYPE.TAROT and arg0_27.tarotRefreshCnt or arg0_27.entryRefreshCnt) - var0_27
	local var2_27 = arg0_27.refreshCnt > 0 and var1_27 > 0
	local var3_27 = arg0_27:IsPoolEmpty()

	setText(arg2_27:Find("Text"), math.min(var1_27, arg0_27.refreshCnt))
	setText(arg3_27:Find("Text"), math.min(var1_27, arg0_27.refreshCnt))
	setActive(arg2_27, var2_27 and not var3_27)
	setActive(arg3_27, not var2_27 or var3_27)
	onButton(arg0_27, arg2_27, function()
		if not var2_27 then
			return
		end

		arg0_27:emit(NewEducateChooseMediator.ON_REFRESH_CHOICE, arg1_27)
	end, SFX_PANEL)
	onButton(arg0_27, arg3_27, function()
		if not var3_27 then
			return
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("child2_pool_exhausted"))
	end, SFX_PANEL)
end

function var0_0.GetUIList(arg0_30)
	return arg0_30.type == var0_0.TYPE.TAROT and arg0_30.tarotUIList or arg0_30.entryUIList
end

function var0_0.SwitchDescMode(arg0_31, arg1_31)
	if arg0_31.tarotId then
		arg0_31.tarotCard:UpdateDescMode(arg1_31)
	end

	arg0_31:GetUIList():eachActive(function(arg0_32, arg1_32)
		arg0_31.cards[arg0_32 + 1]:UpdateDescMode(arg1_31)
	end)
end

function var0_0.UpdateDataAfterRefresh(arg0_33)
	arg0_33.state = arg0_33.contextData.char:GetFSM():GetPriorityState()
	arg0_33.choices = arg0_33.state:GetChoices()
	arg0_33.usedCnts = arg0_33.state:GetUsedCnts()

	arg0_33:UpdateRefreshCnt()
	arg0_33:GetUIList():eachActive(function(arg0_34, arg1_34)
		arg0_33:UpdateRefreshBtn(arg0_34 + 1, arg1_34:Find("refresh_blue"), arg1_34:Find("refresh_grey"))
	end)
end

function var0_0.OnRefreshDone(arg0_35, arg1_35)
	arg0_35:UpdateDataAfterRefresh()
	eachChild(arg0_35:GetUIList().container, function(arg0_36)
		if tonumber(arg0_36.name) == arg1_35.idx then
			local var0_36 = arg0_36:GetComponent(typeof(DftAniEvent))

			var0_36:SetTriggerEvent(function()
				var0_36:SetTriggerEvent(nil)
				arg0_35.cards[arg1_35.idx]:Update(arg1_35.newId)
				arg0_35.cards[arg1_35.idx]:UpdateDescMode(arg0_35.toggleTF:GetComponent(typeof(Toggle)).isOn)
			end)

			local var1_36 = arg0_35.type == var0_0.TYPE.TAROT and "Anim_Neweducate_talent_tpl_change" or "Anim_Neweducate_tentry_tpl_change1"

			arg0_36:GetComponent(typeof(Animation)):Play(var1_36)
		end
	end)
end

function var0_0.OnMakeChoiceDone(arg0_38, arg1_38)
	local var0_38 = arg0_38.type == var0_0.TYPE.TAROT and "Anim_Neweducate_talent_tpl_out" or "Anim_Neweducate_entry_tpl_out1"

	eachChild(arg0_38:GetUIList().container, function(arg0_39)
		if tonumber(arg0_39.name) ~= arg1_38.idx then
			arg0_39:GetComponent(typeof(Animation)):Play(var0_38)
		end
	end)
	seriesAsync({
		function(arg0_40)
			onDelayTick(arg0_40, 0.15)
		end,
		function(arg0_41)
			if #arg1_38.drops > 0 then
				arg0_38:emit(var0_0.ON_DROP, {
					items = arg1_38.drops,
					removeFunc = function()
						arg0_41()
					end
				})
			else
				arg0_41()
			end
		end
	}, function()
		arg0_38:closeView()
	end)
end

function var0_0.OnGiveUpDone(arg0_44, arg1_44)
	seriesAsync({
		function(arg0_45)
			if #arg1_44.drops > 0 then
				arg0_44:emit(var0_0.ON_DROP, {
					items = arg1_44.drops,
					removeFunc = function()
						arg0_45()
					end
				})
			else
				arg0_45()
			end
		end
	}, function()
		arg0_44:closeView()
	end)
end

function var0_0.onBackPressed(arg0_48)
	return
end

function var0_0.willExit(arg0_49)
	for iter0_49, iter1_49 in ipairs(arg0_49.cards) do
		iter1_49:Dispose()
	end

	arg0_49.cards = {}

	arg0_49.tarotCard:Dispose()
	arg0_49:UnOverlayPanel(arg0_49._tf)
	existCall(arg0_49.contextData.onExit)
end

return var0_0
