local var0_0 = class("IslandBookItemPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandBookItemUI"
end

function var0_0.GetIllustrationType(arg0_2)
	return IslandIllustration.TYPES.ITEM
end

function var0_0.OnLoaded(arg0_3)
	setText(arg0_3._tf:Find("top/title/Text"), i18n("island_guide"))
	setText(arg0_3._tf:Find("top/title/Text/en"), i18n("island_guide_en"))

	arg0_3.viewTF = arg0_3._tf:Find("view")

	setActive(arg0_3._tf:Find("tpl"), false)

	arg0_3.scrollRect = arg0_3.viewTF:GetComponent("LScrollRect")

	function arg0_3.scrollRect.onInitItem(arg0_4)
		arg0_3:OnInitItem(arg0_4)
	end

	function arg0_3.scrollRect.onUpdateItem(arg0_5, arg1_5)
		arg0_3:OnUpdateItem(arg0_5, arg1_5)
	end

	arg0_3.rightTF = arg0_3._tf:Find("right")
	arg0_3.rightNameTF = arg0_3.rightTF:Find("name")
	arg0_3.rightEnNameTF = arg0_3.rightTF:Find("zs/Text")
	arg0_3.rightDescTF = arg0_3.rightTF:Find("desc")
	arg0_3.unlockBtn = arg0_3.rightTF:Find("unlock_btn")

	setText(arg0_3.unlockBtn:Find("Text"), i18n("island_guide_do_active"))
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6._tf:Find("top/back"), function()
		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.unlockBtn, function()
		arg0_6:emit(IslandMediator.UNLOCK_ILLUSTRATION, arg0_6.showIllustration.id)
	end, SFX_PANEL)

	arg0_6.cards = {}
end

function var0_0.AddListeners(arg0_9)
	arg0_9:AddListener(GAME.ISLAND_UNLOCK_ILLUSTRATION_DONE, arg0_9.OnUnlockDone)
	arg0_9:AddListener(GAME.ISLAND_GET_COLLECT_POINT_DONE, arg0_9.Flush)
	arg0_9:AddListener(GAME.ISLAND_GET_POINT_AWARD_DONE, arg0_9.OnGetPoointAwardDone)
end

function var0_0.RemoveListeners(arg0_10)
	arg0_10:RemoveListener(GAME.ISLAND_UNLOCK_ILLUSTRATION_DONE, arg0_10.OnUnlockDone)
	arg0_10:RemoveListener(GAME.ISLAND_GET_COLLECT_POINT_DONE, arg0_10.Flush)
	arg0_10:RemoveListener(GAME.ISLAND_GET_POINT_AWARD_DONE, arg0_10.OnGetPoointAwardDone)
end

function var0_0.OnInitItem(arg0_11, arg1_11)
	local var0_11 = IslandIllustrationCard.New(arg1_11)

	arg0_11.cards[arg1_11] = var0_11

	onButton(arg0_11, var0_11._go, function()
		for iter0_12, iter1_12 in pairs(arg0_11.cards) do
			iter1_12:UpdateSelected(nil)
		end

		arg0_11.showIllustration = var0_11.illustration

		var0_11:UpdateSelected(arg0_11.showIllustration.id)
		arg0_11:FlushRightPanel()
	end, SFX_PANEL)
end

function var0_0.OnUpdateItem(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.cards[arg2_13]

	if not var0_13 then
		arg0_13:OnInitItem(arg2_13)

		var0_13 = arg0_13.cards[arg2_13]
	end

	local var1_13 = arg0_13.showList[arg1_13 + 1]

	if var1_13 then
		var0_13:Update(var1_13, arg0_13.showIllustration and arg0_13.showIllustration.id)
	end

	if arg0_13.triggerFirstCard and arg1_13 == 0 then
		arg0_13.triggerFirstCard = nil

		triggerButton(var0_13._go)
	end
end

function var0_0.OnShow(arg0_14)
	arg0_14.triggerFirstCard = true

	arg0_14:Flush()
end

function var0_0.OnUnlockDone(arg0_15, arg1_15)
	for iter0_15, iter1_15 in pairs(arg0_15.cards) do
		iter1_15:PlayUnlockAnim(arg1_15.id)
	end

	arg0_15:Flush()
end

function var0_0.OnGetPoointAwardDone(arg0_16, arg1_16)
	local var0_16 = arg1_16.dropData.abilitys or {}

	for iter0_16, iter1_16 in ipairs(var0_16) do
		local var1_16 = pg.island_ability_template[iter1_16.id].unlock_text

		pg.TipsMgr.GetInstance():ShowTips(var1_16)
	end

	arg0_16:Flush()
end

function var0_0.Flush(arg0_17)
	arg0_17.bookAgency = getProxy(IslandProxy):GetIsland():GetBookAgency()
	arg0_17.showList = arg0_17.bookAgency:GetListByType(arg0_17:GetIllustrationType())

	table.sort(arg0_17.showList, CompareFuncs({
		function(arg0_18)
			return pg.island_illustrated_guide[arg0_18.id].order
		end,
		function(arg0_19)
			return arg0_19.id
		end
	}))
	arg0_17.scrollRect:SetTotalCount(#arg0_17.showList, -1)
	arg0_17:FlushRightPanel()
end

function var0_0.FlushRightPanel(arg0_20)
	if not arg0_20.showIllustration then
		return
	end

	local var0_20 = arg0_20.showIllustration:GetStatus()

	setText(arg0_20.rightNameTF, arg0_20.showIllustration:GetName())
	setText(arg0_20.rightEnNameTF, arg0_20.showIllustration:GetEnName())

	local var1_20 = var0_20 == IslandIllustration.STATUS.UNLOCK and arg0_20.showIllustration:GetDesc() or i18n("island_guide_lock_desc")

	setText(arg0_20.rightDescTF, var1_20)
	setActive(arg0_20.unlockBtn, var0_20 == IslandIllustration.STATUS.CAN_UNLOCK)
end

function var0_0.OnDestroy(arg0_21)
	ClearLScrollrect(arg0_21.scrollRect)

	for iter0_21, iter1_21 in pairs(arg0_21.cards) do
		iter1_21:Dispose()
	end

	arg0_21.cards = {}
end

return var0_0
