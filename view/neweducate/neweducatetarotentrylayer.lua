local var0_0 = class("NewEducateTarotEntryLayer", import("view.newEducate.base.NewEducateBaseUI"))

var0_0.TYPE = {
	SHOP = 2,
	DROP = 3,
	NORMAL = 1
}

function var0_0.getUIName(arg0_1)
	return "NewEducateTarotEntryUI"
end

function var0_0.init(arg0_2)
	arg0_2.progressPart = NewEducateTopProgress.New(arg0_2._tf:Find("progress"), arg0_2)
	arg0_2.resPart = NewEducateTopRes.New(arg0_2._tf:Find("res"), arg0_2)
	arg0_2.toggleTF = arg0_2._tf:Find("toggle")

	setText(arg0_2.toggleTF:Find("Text"), i18n("child2_show_detail_desc"))

	arg0_2.tarotTF = arg0_2._tf:Find("tarot")
	arg0_2.tarotCard = NewEducateTarotCard.New(arg0_2.tarotTF)

	setText(arg0_2._tf:Find("all/Text"), i18n("child2_all_entry_title"))

	arg0_2.allEntryCntText = arg0_2._tf:Find("all/value"):GetComponent(typeof(Text))
	arg0_2.scrollRect = arg0_2._tf:Find("view/content"):GetComponent("LScrollRect")
	arg0_2.detailTF = arg0_2._tf:Find("detail")
	arg0_2.detailEntryCard = NewEducateEntryCard.New(arg0_2.detailTF:Find("entry"))
	arg0_2.detailLevelText = arg0_2.detailTF:Find("level/Text"):GetComponent(typeof(Text))
	arg0_2.upgradeTF = arg0_2._tf:Find("upgrade")
	arg0_2.upgradeBtn = arg0_2.upgradeTF:Find("btn")

	setText(arg0_2.upgradeBtn:Find("Text"), i18n("child2_word_upgrade"))

	arg0_2.giveupBtn = arg0_2._tf:Find("giveup")

	setText(arg0_2.giveupBtn:Find("Text"), i18n("child2_word_giveup"))

	arg0_2.goBtn = arg0_2._tf:Find("go")

	setText(arg0_2.goBtn:Find("Text"), i18n("child2_go_shop"))

	arg0_2.summaryTF = arg0_2._tf:Find("summary")
	arg0_2.summaryToggleTF = arg0_2.summaryTF:Find("toggle")
	arg0_2.pctUIList = UIItemList.New(arg0_2.summaryTF:Find("list"), arg0_2.summaryTF:Find("list/tpl"))
	arg0_2.playerID = getProxy(PlayerProxy):getRawData().id
end

function var0_0.didEnter(arg0_3)
	arg0_3:BlurPanel(arg0_3._tf, {
		groupDelta = 3
	})
	onButton(arg0_3, arg0_3.progressPart._tf:Find("back"), function()
		arg0_3:onBackPressed()
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.toggleTF, function(arg0_5)
		NewEducateHelper.SetTarotDeatilDescData(arg0_5)
		arg0_3:SwitchDescMode(arg0_5)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.giveupBtn, function()
		arg0_3:emit(NewEducateTarotEntryMediator.ON_GIVE_UP_ENTRY_UP)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.upgradeBtn, function()
		seriesAsync({
			function(arg0_8)
				if arg0_3.type == var0_0.TYPE.SHOP then
					arg0_3:emit(NewEducateTarotEntryMediator.ON_SHOPPING, arg0_3.contextData.goodId, arg0_8)
				else
					arg0_8()
				end
			end
		}, function(arg0_9)
			arg0_3.showpDrops = arg0_9 or {}

			arg0_3:emit(NewEducateTarotEntryMediator.ON_UPGRADE_ENTRY, arg0_3.selectId)
		end)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.goBtn, function()
		if arg0_3.contextData.char:GetFSM():CheckPriorityStystem() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("child2_priority_tip"))

			return
		end

		arg0_3:emit(var0_0.GO_SCENE, SCENE.NEW_EDUCATE_MAP, {
			openShop = true
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("tip"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.child2_choose_help.tip
		})
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.summaryToggleTF, function(arg0_12)
		local var0_12 = arg0_12 and i18n("child2_benefit_summary2") or i18n("child2_benefit_summary")

		setText(arg0_3.summaryToggleTF:Find("Text"), var0_12)
		arg0_3.pctUIList:align(#arg0_3.showPctList)
		PlayerPrefs.SetInt(arg0_3:GetBenefitShowLocalKey(), arg0_12 and 1 or 0)
	end, SFX_PANEL)
	arg0_3.pctUIList:make(function(arg0_13, arg1_13, arg2_13)
		local var0_13 = arg0_3.showPctList[arg1_13 + 1].drop
		local var1_13 = NewEducateHelper.GetDropConfig(var0_13)

		if arg0_13 == UIItemList.EventInit then
			LoadImageSpriteAtlasAsync("ui/neweducatecommonui_atlas", var1_13.icon, arg2_13:Find("Image"), true)
		elseif arg0_13 == UIItemList.EventUpdate then
			local var2_13 = arg0_3.summaryToggleTF:GetComponent(typeof(Toggle)).isOn
			local var3_13 = arg0_3.showPctList[arg1_13 + 1].a
			local var4_13 = arg0_3.showPctList[arg1_13 + 1].b

			setText(arg2_13:Find("Text"), (var2_13 and var4_13 or var3_13) .. "%")
			setText(arg2_13:Find("info/content/name"), var1_13.name)

			local var5_13 = i18n("child2_benefit_summary") .. var3_13 .. "%" .. "\n" .. i18n("child2_benefit_summary2") .. var4_13 .. "%"

			setText(arg2_13:Find("info/content/desc"), var5_13)

			local var6_13 = arg0_3.contextData.char:GetOwnCnt(var0_13)

			if var0_13.type == NewEducateConst.DROP_TYPE.ATTR then
				local var7_13, var8_13 = NewEducateInfoPanel.GetArrtInfo(var1_13.rank, var6_13)

				setText(arg2_13:Find("info/content/value"), var8_13)
			else
				setText(arg2_13:Find("info/content/value"), var6_13)
			end
		end
	end)

	function arg0_3.scrollRect.onInitItem(arg0_14)
		arg0_3:OnInitItem(arg0_14)
	end

	function arg0_3.scrollRect.onUpdateItem(arg0_15, arg1_15)
		arg0_3:OnUpdateItem(arg0_15, arg1_15)
	end

	arg0_3.cards = {}
	arg0_3.triggerFirstCard = true
	arg0_3.config = pg.child2_benefit_list
	arg0_3.type = arg0_3.contextData.type or var0_0.TYPE.NORMAL

	arg0_3:UpdateView()
	triggerToggle(arg0_3.toggleTF, NewEducateHelper.IsShowTarotDeatilDesc())
end

function var0_0.GetBenefitShowLocalKey(arg0_16)
	return NewEducateConst.NEW_EDUCATE_BENEFIT_SHOW_MAX .. "_" .. arg0_16.playerID .. "_" .. arg0_16.contextData.char.id
end

function var0_0.UpdateView(arg0_17)
	arg0_17.progressPart:Update(arg0_17.contextData.char)
	arg0_17.resPart:Update(arg0_17.contextData.char)

	arg0_17.tarotId = arg0_17.contextData.char:GetTarotId()
	arg0_17.entries = arg0_17.contextData.char:GetBenefitData():GetListByType(NewEducateBuff.TYPE.ENTRY)

	arg0_17:UpdateTarotPanel()
	arg0_17:UpdateSummary()
	arg0_17:UpdateBtns()
	arg0_17.scrollRect:SetTotalCount(#arg0_17.entries)

	if #arg0_17.entries == 0 then
		setActive(arg0_17.detailTF, false)
		setActive(arg0_17.upgradeTF, false)
	end
end

function var0_0.UpdateTarotPanel(arg0_18)
	setActive(arg0_18.tarotCard._tf, arg0_18.tarotId)

	if arg0_18.tarotId then
		arg0_18.tarotCard:Update(arg0_18.tarotId, NewEducateTarotCard.TYPE.CURRENT)
	end
end

function var0_0.UpdateRight(arg0_19)
	local var0_19 = arg0_19.type ~= var0_0.TYPE.NORMAL and arg0_19.config[arg0_19.selectId].next_level ~= 0

	setActive(arg0_19.upgradeTF, var0_19)
	setActive(arg0_19.detailTF, not var0_19)

	if var0_19 then
		arg0_19:UpdataUpgrade()
	else
		arg0_19:UpdataDetail()
	end
end

function var0_0.UpdataUpgrade(arg0_20)
	setActive(arg0_20.upgradeBtn:Find("res"), arg0_20.type == var0_0.TYPE.SHOP)

	if arg0_20.type == var0_0.TYPE.SHOP then
		setText(arg0_20.upgradeBtn:Find("res/Text"), "-" .. arg0_20.contextData.cost)
	end

	local var0_20 = arg0_20.config[arg0_20.selectId]

	setText(arg0_20.upgradeTF:Find("name"), var0_20.name)
	setText(arg0_20.upgradeTF:Find("before/level/Text"), "LV." .. var0_20.benefit_level)
	setText(arg0_20.upgradeTF:Find("before/desc/Text"), var0_20.desc)

	local var1_20 = var0_20.next_level

	setText(arg0_20.upgradeTF:Find("after/level/Text"), "LV." .. arg0_20.config[var1_20].benefit_level)
	setText(arg0_20.upgradeTF:Find("after/desc/Text"), var0_20.upgrade_desc)
end

function var0_0.UpdataDetail(arg0_21)
	setActive(arg0_21.detailTF, arg0_21.selectId)

	if arg0_21.selectId then
		arg0_21.detailLevelText.text = "Lv." .. arg0_21.config[arg0_21.selectId].benefit_level

		arg0_21.detailEntryCard:Update(arg0_21.selectId)
		arg0_21.detailEntryCard:UpdateCountDesc()
		arg0_21.detailEntryCard:UpdateDescMode(arg0_21.toggleTF:GetComponent(typeof(Toggle)).isOn)
	end
end

function var0_0.UpdateSummary(arg0_22)
	local var0_22 = underscore.select(arg0_22.contextData.char:GetPermanentData():GetAllBuffIds(), function(arg0_23)
		return arg0_22.config[arg0_23].type == NewEducateBuff.TYPE.ENTRY and NewEducateBuff.IsVisible(arg0_23)
	end)

	arg0_22.allEntryCntText.text = #arg0_22.entries .. "/" .. #var0_22

	local var1_22 = arg0_22.contextData.char:GetBenefitData()

	arg0_22.showPctList = {}

	for iter0_22, iter1_22 in ipairs(NewEducateBenefit.GetDisplayPctList(arg0_22.contextData.char)) do
		local var2_22, var3_22 = var1_22:GetDisplayPctByDrop(iter1_22)

		table.insert(arg0_22.showPctList, {
			drop = iter1_22,
			a = var2_22,
			b = var3_22
		})
	end

	local var4_22 = PlayerPrefs.GetInt(arg0_22:GetBenefitShowLocalKey())

	triggerToggle(arg0_22.summaryToggleTF, var4_22 == 1)
end

function var0_0.UpdateBtns(arg0_24)
	setActive(arg0_24.giveupBtn, arg0_24.type == var0_0.TYPE.DROP)
	setActive(arg0_24.goBtn, arg0_24:GetGoBtnVisibility())
end

function var0_0.GetGoBtnVisibility(arg0_25)
	if arg0_25.type ~= var0_0.TYPE.NORMAL then
		return false
	end

	if not arg0_25.contextData.char:IsUnlock("shop") then
		return false
	end

	if arg0_25.contextData.char:GetFSM():CheckStystem() == NewEducateFSM.SYSTEM.ENDING then
		return false
	end

	if arg0_25.contextData.char:GetFSM():GetSystemNo() == NewEducateFSM.SYSTEM.ENDING then
		return false
	end

	if arg0_25.contextData.inShop then
		return false
	end

	return true
end

function var0_0.OnInitItem(arg0_26, arg1_26)
	local var0_26 = NewEducateEntryCard.New(arg1_26)

	arg0_26.cards[arg1_26] = var0_26
end

function var0_0.OnUpdateItem(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27.cards[arg2_27]

	if not var0_27 then
		arg0_27:OnInitItem(arg2_27)

		var0_27 = arg0_27.cards[arg2_27]
	end

	local var1_27 = arg0_27.entries[arg1_27 + 1].id

	var0_27:Update(var1_27)
	setActive(var0_27._tf:Find("sel"), false)
	onButton(arg0_27, var0_27._go, function()
		for iter0_28, iter1_28 in pairs(arg0_27.cards) do
			setActive(iter1_28._tf:Find("sel"), false)
		end

		arg0_27.selectId = var1_27

		setActive(var0_27._tf:Find("sel"), true)

		if not arg0_27.triggerFirstCard then
			setActive(var0_27._tf:Find("sel"), true)
			var0_27._tf:Find("sel"):GetComponent(typeof(Animation)):Play("Anim_NewEducateTarotEntryUI_tpl_sel")
		end

		arg0_27:UpdateRight()
	end, SFX_PANEL)

	if arg0_27.triggerFirstCard and arg1_27 == 0 then
		triggerButton(var0_27._go)

		arg0_27.triggerFirstCard = nil
	end
end

function var0_0.SwitchDescMode(arg0_29, arg1_29)
	if arg0_29.tarotId then
		arg0_29.tarotCard:UpdateDescMode(arg1_29)
	end

	if arg0_29.selectId then
		arg0_29.detailEntryCard:UpdateDescMode(arg1_29)
	end

	for iter0_29, iter1_29 in pairs(arg0_29.cards) do
		iter1_29:UpdateDescMode(arg1_29)
	end
end

function var0_0.OnUpgradeDone(arg0_30, arg1_30)
	for iter0_30, iter1_30 in pairs(arg0_30.cards) do
		if iter1_30.id == arg1_30.entryId then
			iter1_30._tf:Find("sel"):GetComponent(typeof(Animation)):Play("Anim_NewEducateTarotEntryUI_tpl_sel2")
		end
	end

	seriesAsync({
		function(arg0_31)
			onDelayTick(arg0_31, 0.2)
		end,
		function(arg0_32)
			if #arg1_30.drops > 0 or #arg0_30.showpDrops > 0 then
				arg0_30:emit(var0_0.ON_DROP, {
					items = table.mergeArray(arg1_30.drops, arg0_30.showpDrops),
					removeFunc = arg0_32
				})

				arg0_30.showpDrops = {}
			else
				arg0_32()
			end
		end
	}, function()
		arg0_30:closeView()
	end)
end

function var0_0.onBackPressed(arg0_34)
	if arg0_34.type == var0_0.TYPE.DROP then
		return
	end

	arg0_34:closeView()
end

function var0_0.willExit(arg0_35)
	ClearLScrollrect(arg0_35.scrollRect)

	for iter0_35, iter1_35 in pairs(arg0_35.cards) do
		iter1_35:Dispose()
	end

	arg0_35.cards = {}

	arg0_35.tarotCard:Dispose()
	arg0_35.detailEntryCard:Dispose()
	arg0_35.progressPart:Dispose()
	arg0_35.resPart:Dispose()
	arg0_35:UnOverlayPanel(arg0_35._tf)
	existCall(arg0_35.contextData.onExit)
end

return var0_0
