local var0_0 = class("IslandBookItemPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandBookItemUI"
end

function var0_0.GetIllustrationType(arg0_2)
	return IslandIllustration.TYPES.ITEM
end

function var0_0.GetHelpTip(arg0_3)
	return i18n("island_guide_help_item")
end

function var0_0.OnLoaded(arg0_4)
	setText(arg0_4._tf:Find("top/title/Text"), i18n("island_guide"))
	setText(arg0_4._tf:Find("top/title/Text/en"), i18n("island_guide_en"))

	arg0_4.viewTF = arg0_4._tf:Find("view")

	setActive(arg0_4._tf:Find("tpl"), false)

	arg0_4.scrollRect = arg0_4.viewTF:GetComponent("LScrollRect")

	function arg0_4.scrollRect.onInitItem(arg0_5)
		arg0_4:OnInitItem(arg0_5)
	end

	function arg0_4.scrollRect.onUpdateItem(arg0_6, arg1_6)
		arg0_4:OnUpdateItem(arg0_6, arg1_6)
	end

	arg0_4.rightTF = arg0_4._tf:Find("right")
	arg0_4.rightNameTF = arg0_4.rightTF:Find("name")
	arg0_4.rightEnNameTF = arg0_4.rightTF:Find("zs/Text")
	arg0_4.rightDescTF = arg0_4.rightTF:Find("desc")
	arg0_4.rightProgressTF = arg0_4.rightTF:Find("progress")
	arg0_4.unlockBtn = arg0_4.rightTF:Find("unlock_btn")

	setText(arg0_4.unlockBtn:Find("Text"), i18n("island_guide_do_active"))

	arg0_4.getPointBtn = arg0_4.rightTF:Find("get_btn")

	setText(arg0_4.getPointBtn:Find("Text"), i18n("island_guide_collectionpoint"))

	arg0_4.pointPanel = arg0_4._tf:Find("point_panel")
	arg0_4.pointLevelTF = arg0_4.pointPanel:Find("Text")
	arg0_4.pointAwardTF = arg0_4.pointPanel:Find("award")
	arg0_4.pointAwardIcon = arg0_4.pointPanel:Find("award/icon")
	arg0_4.getPointAwardBtn = arg0_4.pointPanel:Find("award/get")
	arg0_4.gotAllPointAwardTF = arg0_4.pointPanel:Find("award/got")
	arg0_4.openAwardWinBtn = arg0_4.pointPanel:Find("award_btn")
	arg0_4.pointSliderTF = arg0_4.pointPanel:Find("slider")
	arg0_4.pointProgressTF = arg0_4.pointPanel:Find("slider/progress")
	arg0_4.awardListBox = IslandBookAwardListBox.New(arg0_4._tf, arg0_4.event, setmetatable({
		ShowMsgBox = function(arg0_7, arg1_7)
			arg0_4:ShowMsgBox(arg1_7)
		end,
		type = arg0_4:GetIllustrationType()
	}, {
		__index = arg0_4.contextData
	}))
end

function var0_0.OnInit(arg0_8)
	onButton(arg0_8, arg0_8._tf:Find("top/back"), function()
		arg0_8:Hide()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.unlockBtn, function()
		local var0_10 = arg0_8:GetCanUnlockIds()

		if #var0_10 > 0 then
			arg0_8:emit(IslandMediator.UNLOCK_ILLUSTRATION, var0_10)
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.getPointBtn, function()
		arg0_8.getPointBtn:GetComponent(typeof(Animation)):Play()
		arg0_8:emit(IslandMediator.GET_COLLECT_POINT, arg0_8.canGetPointIds)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.openAwardWinBtn, function()
		arg0_8.openAwardWinBtn:GetComponent(typeof(Animation)):Play()
		arg0_8.awardListBox:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.getPointAwardBtn, function()
		arg0_8.pointAwardTF:GetComponent(typeof(Animation)):Play()
		arg0_8:emit(IslandMediator.GET_POINT_AWARD, arg0_8.curLevelId)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._tf:Find("top/help"), function()
		arg0_8:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = arg0_8:GetHelpTip(),
			title = i18n("island_guide_character_help")
		})
	end, SFX_PANEL)

	arg0_8.cards = {}
end

function var0_0.AddListeners(arg0_15)
	arg0_15:AddListener(GAME.ISLAND_UNLOCK_ILLUSTRATION_DONE, arg0_15.OnUnlockDone)
	arg0_15:AddListener(GAME.ISLAND_GET_COLLECT_POINT_DONE, arg0_15.Flush)
	arg0_15:AddListener(GAME.ISLAND_GET_POINT_AWARD_DONE, arg0_15.OnGetPointAwardDone)
end

function var0_0.RemoveListeners(arg0_16)
	arg0_16:RemoveListener(GAME.ISLAND_UNLOCK_ILLUSTRATION_DONE, arg0_16.OnUnlockDone)
	arg0_16:RemoveListener(GAME.ISLAND_GET_COLLECT_POINT_DONE, arg0_16.Flush)
	arg0_16:RemoveListener(GAME.ISLAND_GET_POINT_AWARD_DONE, arg0_16.OnGetPointAwardDone)
end

function var0_0.OnInitItem(arg0_17, arg1_17)
	local var0_17 = IslandIllustrationCard.New(arg1_17)

	arg0_17.cards[arg1_17] = var0_17

	onButton(arg0_17, var0_17._go, function()
		for iter0_18, iter1_18 in pairs(arg0_17.cards) do
			iter1_18:UpdateSelected(nil)
		end

		arg0_17.showIllustration = var0_17.illustration

		var0_17:UpdateSelected(arg0_17.showIllustration.id)
		arg0_17:FlushRightPanel()
	end, SFX_PANEL)
end

function var0_0.OnUpdateItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.cards[arg2_19]

	if not var0_19 then
		arg0_19:OnInitItem(arg2_19)

		var0_19 = arg0_19.cards[arg2_19]
	end

	local var1_19 = arg0_19.showList[arg1_19 + 1]

	if var1_19 then
		var0_19:Update(var1_19, arg0_19.showIllustration and arg0_19.showIllustration.id)
	end

	if arg0_19.triggerFirstCard and arg1_19 == 0 then
		arg0_19.triggerFirstCard = nil

		triggerButton(var0_19._go)
	end
end

function var0_0.OnShow(arg0_20)
	arg0_20.triggerFirstCard = true

	arg0_20:Flush()
end

function var0_0.GetCanUnlockIds(arg0_21)
	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(arg0_21.showList) do
		if iter1_21:GetStatus() == IslandIllustration.STATUS.CAN_UNLOCK then
			table.insert(var0_21, iter1_21.id)
		end
	end

	return var0_21
end

function var0_0.OnUnlockDone(arg0_22, arg1_22)
	for iter0_22, iter1_22 in pairs(arg0_22.cards) do
		iter1_22:PlayUnlockAnim(arg1_22.ids)
	end

	arg0_22:Flush()
end

function var0_0.OnGetPointAwardDone(arg0_23, arg1_23)
	local var0_23 = arg1_23.dropData.abilitys or {}

	for iter0_23, iter1_23 in ipairs(var0_23) do
		local var1_23 = pg.island_ability_template[iter1_23.id].unlock_text

		pg.TipsMgr.GetInstance():ShowTips(var1_23)
	end

	arg0_23:Flush()
end

function var0_0.Flush(arg0_24)
	arg0_24.bookAgency = getProxy(IslandProxy):GetIsland():GetBookAgency()
	arg0_24.showList = arg0_24.bookAgency:GetListByType(arg0_24:GetIllustrationType())

	table.sort(arg0_24.showList, CompareFuncs({
		function(arg0_25)
			return arg0_25:GetStatus() == IslandIllustration.STATUS.CAN_UNLOCK and 0 or 1
		end,
		function(arg0_26)
			return pg.island_illustrated_guide[arg0_26.id].order
		end,
		function(arg0_27)
			return arg0_27.id
		end
	}))
	arg0_24.scrollRect:SetTotalCount(#arg0_24.showList, -1)
	arg0_24:FlushRightPanel()
	arg0_24:FlushPointAwardInfos()
	arg0_24:FlushPointInfos()
end

function var0_0.FlushRightPanel(arg0_28)
	if not arg0_28.showIllustration then
		return
	end

	local var0_28 = arg0_28.showIllustration:GetStatus()

	setText(arg0_28.rightNameTF, arg0_28.showIllustration:GetName())
	setText(arg0_28.rightEnNameTF, arg0_28.showIllustration:GetEnName())

	local var1_28 = var0_28 == IslandIllustration.STATUS.UNLOCK and arg0_28.showIllustration:GetDesc() or i18n("island_guide_lock_desc")

	setText(arg0_28.rightDescTF, var1_28)
	setActive(arg0_28.unlockBtn, var0_28 == IslandIllustration.STATUS.CAN_UNLOCK)
	arg0_28:FlushOnlyItem()
end

function var0_0.FlushOnlyItem(arg0_29)
	local var0_29 = arg0_29:GetIllustrationType() == IslandIllustration.TYPES.ITEM

	setActive(arg0_29.rightProgressTF, var0_29)

	if var0_29 then
		local var1_29 = arg0_29.showIllustration:GetHistoryCnt()
		local var2_29 = arg0_29.showIllustration:GetCurTarget()

		setText(arg0_29.rightProgressTF, var2_29 and var1_29 .. "/" .. var2_29 or var1_29)
	end
end

function var0_0.FlushPointAwardInfos(arg0_30)
	local var0_30 = arg0_30:GetIllustrationType()

	arg0_30.pointAwardGotIds = arg0_30.bookAgency:GetPointAwardGotIds(var0_30)
	arg0_30.curLevelId = arg0_30.bookAgency:GetCurLevelPointAwardId(var0_30)
	arg0_30.awardConfig = pg.island_collection_reward[arg0_30.curLevelId]

	setText(arg0_30.pointLevelTF, i18n("island_book_collection_award_title", arg0_30.awardConfig.level))

	arg0_30.curPoint, arg0_30.targetPoint = arg0_30.bookAgency:GetCurPointInfos(var0_30)

	setText(arg0_30.pointProgressTF, arg0_30.curPoint .. "/" .. arg0_30.targetPoint)
	setSlider(arg0_30.pointSliderTF, 0, 1, arg0_30.curPoint / arg0_30.targetPoint)

	local var1_30 = arg0_30.bookAgency:IsGotAllPointAward(var0_30)

	setActive(arg0_30.gotAllPointAwardTF, var1_30)
	setActive(arg0_30.getPointAwardBtn, not var1_30 and arg0_30.curPoint >= arg0_30.targetPoint)

	local var2_30 = Drop.Create(arg0_30.awardConfig.award_display)

	GetImageSpriteFromAtlasAsync(var2_30:getIcon(), "", arg0_30.pointAwardIcon)
end

function var0_0.FlushPointInfos(arg0_31)
	arg0_31.canGetPointIds = {}

	for iter0_31, iter1_31 in ipairs(arg0_31.showList) do
		if iter1_31:GetStatus() == IslandIllustration.STATUS.UNLOCK and iter1_31:IsTip() then
			table.insert(arg0_31.canGetPointIds, iter1_31.id)
		end
	end

	setActive(arg0_31.getPointBtn, #arg0_31.canGetPointIds > 0)
end

function var0_0.OnDestroy(arg0_32)
	ClearLScrollrect(arg0_32.scrollRect)

	for iter0_32, iter1_32 in pairs(arg0_32.cards) do
		iter1_32:Dispose()
	end

	arg0_32.cards = {}

	if arg0_32.awardListBox then
		arg0_32.awardListBox:Destroy()

		arg0_32.awardListBox = nil
	end
end

return var0_0
