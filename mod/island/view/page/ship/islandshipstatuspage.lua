local var0_0 = class("IslandShipStatusPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipStatusUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.scrollRect = arg0_2._tf:Find("adapt/attr_panel/srcollrect"):GetComponent("LScrollRect")

	function arg0_2.scrollRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	arg0_2.giveBtn = arg0_2._tf:Find("adapt/attr_panel/send_panel/give_btn")
	arg0_2.emptyTr = arg0_2._tf:Find("adapt/attr_panel/send_panel/empty")
	arg0_2.giftEffectList = UIItemList.New(arg0_2._tf:Find("adapt/attr_panel/send_panel/scrollrect/list"), arg0_2._tf:Find("adapt/attr_panel/send_panel/scrollrect/list/tpl"))
	arg0_2.statusPanel = IslandShipStatusPanel.New(arg0_2._tf:Find("adapt/attr_panel/status"), arg0_2._tf:Find("adapt/attr_panel/status_empty"))

	setText(arg0_2.emptyTr:Find("Text"), i18n("island_select_ship_gift"))

	arg0_2.powerTr = arg0_2._tf:Find("adapt/attr_panel/power")

	setText(arg0_2.powerTr:Find("Text"), i18n("island_gift_tip_title"))
end

function var0_0.OnInit(arg0_5)
	arg0_5.cards = {}

	onButton(arg0_5, arg0_5.giveBtn, function()
		if not arg0_5.selectedId then
			return
		end

		local var0_6 = {}

		if arg0_5.addPower + arg0_5.curPower > arg0_5.maxPower then
			table.insert(var0_6, function(arg0_7)
				arg0_5:ShowMsgBox({
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_gift_tip"),
					onYes = arg0_7
				})
			end)
		end

		local var1_6 = arg0_5:CollectGiftBuffs(arg0_5.selectedId)

		for iter0_6, iter1_6 in ipairs(var1_6) do
			table.insert(var0_6, function(arg0_8)
				IslandAddShipStatusHelper.CheckAddStatus(arg0_5, arg0_5.ship, iter1_6, arg0_8)
			end)
		end

		seriesAsync(var0_6, function()
			arg0_5:emit(IslandMediator.ON_GIVE_GIFT, arg0_5.selectedId, 1, arg0_5.shipId)
		end)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_10)
	arg0_10:AddListener(GAME.ISLAND_GIVE_GIFT_DONE, arg0_10.OnUseItem)
end

function var0_0.RemoveListeners(arg0_11)
	arg0_11:RemoveListener(GAME.ISLAND_GIVE_GIFT_DONE, arg0_11.OnUseItem)
end

function var0_0.OnUseItem(arg0_12)
	arg0_12.selectedId = nil

	arg0_12:FlushStatus(arg0_12.ship)
	arg0_12:FlushGifts()
	arg0_12:FlushPower()
end

function var0_0.OnShow(arg0_13, arg1_13)
	arg0_13.selectedId = nil

	local var0_13 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_13)

	if var0_13 == nil then
		return
	end

	arg0_13.ship = var0_13
	arg0_13.shipId = arg0_13.ship.id

	arg0_13:FlushStatus(var0_13)
	arg0_13:FlushGifts()
	arg0_13:FlushPower()
	arg0_13:UpdateSelected(arg0_13.selectedId)
end

function var0_0.FlushStatus(arg0_14, arg1_14)
	arg0_14.statusPanel:Flush(arg1_14)

	local var0_14 = arg1_14:GetDisplayStatus()

	onButton(arg0_14, arg0_14.statusPanel.viewBtn, function()
		arg0_14:ShowMsgBox({
			hideNo = true,
			type = IslandMsgBox.TYPE_SHIP_OWN_STATUS,
			title = i18n("island_word_ship_buff_desc"),
			statusList = var0_14
		})
	end, SFX_PANEL)
end

function var0_0.OnInitItem(arg0_16, arg1_16)
	local var0_16 = IslandGiftCard.New(arg1_16)

	onButton(arg0_16, var0_16.go, function()
		if var0_16.item:GetCount() <= 0 then
			arg0_16:ShowMsgBox({
				title = i18n("island_word_ship_buff_desc"),
				type = IslandMsgBox.TYPE_COMMON_ITEM,
				itemId = var0_16.item.id
			})

			return
		end

		arg0_16.selectedId = nil

		for iter0_17, iter1_17 in pairs(arg0_16.cards) do
			iter1_17:UpdateSelected(arg0_16.selectedId)
		end

		arg0_16:UpdateSelected(var0_16.itemId)
		var0_16:UpdateSelected(arg0_16.selectedId)
	end, SFX_PANEL)

	arg0_16.cards[arg1_16] = var0_16
end

function var0_0.OnUpdateItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.cards[arg2_18]

	if not var0_18 then
		arg0_18:OnInitItem(arg2_18)

		var0_18 = arg0_18.cards[arg2_18]
	end

	var0_18:Update(arg0_18.shipId, arg0_18.displays[arg1_18 + 1], arg0_18.selectedId)
end

function var0_0.FlushGifts(arg0_19)
	local var0_19 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetGifts()

	arg0_19.displays = {}

	for iter0_19, iter1_19 in pairs(var0_19) do
		table.insert(arg0_19.displays, iter1_19)
	end

	table.sort(arg0_19.displays, function(arg0_20, arg1_20)
		return arg0_20.id < arg1_20.id
	end)
	arg0_19.scrollRect:SetTotalCount(#arg0_19.displays)
end

function var0_0.UpdateSelected(arg0_21, arg1_21)
	arg0_21.selectedId = arg1_21

	setActive(arg0_21.emptyTr, arg0_21.selectedId == nil)
	setActive(arg0_21.giftEffectList.container, arg0_21.selectedId)

	if arg0_21.selectedId then
		local var0_21 = arg0_21:CollectGiftEffect(arg1_21)

		arg0_21.giftEffectList:make(function(arg0_22, arg1_22, arg2_22)
			if arg0_22 == UIItemList.EventUpdate then
				setText(arg2_22, var0_21[arg1_22 + 1])
			end
		end)
		arg0_21.giftEffectList:align(#var0_21)
	end

	arg0_21:FlushPower()
end

function var0_0.CollectGiftBuffs(arg0_23, arg1_23)
	local var0_23 = {}
	local var1_23 = IslandItem.StaticGetUsageArg(arg1_23)
	local var2_23 = arg0_23.ship:IsFavoriteGift(arg1_23) and IslandConst.GIFT_INDEX_FAVORITE or IslandConst.GIFT_INDEX_COMMON

	for iter0_23, iter1_23 in ipairs(var1_23) do
		if var2_23 == iter0_23 then
			local var3_23 = iter1_23[2]

			for iter2_23, iter3_23 in ipairs(var3_23) do
				table.insert(var0_23, iter3_23)
			end
		end
	end

	return var0_23
end

function var0_0.CollectGiftEffect(arg0_24, arg1_24)
	local var0_24 = {}
	local var1_24 = IslandItem.StaticGetUsageArg(arg1_24)
	local var2_24 = IslandConst.GIFT_INDEX_COMMON
	local var3_24 = IslandConst.GIFT_INDEX_FAVORITE
	local var4_24 = arg0_24.ship:IsFavoriteGift(arg1_24) and var1_24[var3_24] or var1_24[var2_24]

	if var4_24[var2_24] > 0 then
		table.insert(var0_24, i18n("island_word_ship_enengy_recover") .. var4_24[var2_24])
	end

	for iter0_24, iter1_24 in ipairs(var4_24[2]) do
		local var5_24 = pg.island_buff_template[iter1_24]

		table.insert(var0_24, var5_24.buff_desc)
	end

	return var0_24
end

function var0_0.GetGiftAddPower(arg0_25, arg1_25)
	if not arg1_25 then
		return 0
	end

	local var0_25 = IslandItem.StaticGetUsageArg(arg1_25)
	local var1_25 = IslandConst.GIFT_INDEX_COMMON
	local var2_25 = IslandConst.GIFT_INDEX_FAVORITE
	local var3_25 = arg0_25.ship:IsFavoriteGift(arg1_25) and var0_25[var2_25] or var0_25[var1_25]

	if var3_25[var1_25] > 0 then
		return var3_25[var1_25]
	end

	return 0
end

function var0_0.FlushPower(arg0_26)
	arg0_26.maxPower = arg0_26.ship:GetMaxEnergy()
	arg0_26.curPower = arg0_26.ship:GetCurrentEnergy()
	arg0_26.addPower = arg0_26:GetGiftAddPower(arg0_26.selectedId)

	local var0_26 = math.min(arg0_26.addPower, arg0_26.maxPower - arg0_26.curPower)
	local var1_26 = var0_26 > 0 and "+" .. var0_26 or ""

	setText(arg0_26.powerTr:Find("value"), arg0_26.curPower .. setColorStr(var1_26, "#4FD775") .. "/" .. arg0_26.maxPower)
	setSlider(arg0_26.powerTr:Find("progress"), 0, 1, arg0_26.curPower / arg0_26.maxPower)
	setSlider(arg0_26.powerTr:Find("progress/add"), 0, 1, arg0_26.addPower > 0 and (arg0_26.curPower + arg0_26.addPower) / arg0_26.maxPower or 0)
end

function var0_0.OnDestroy(arg0_27)
	ClearLScrollrect(arg0_27.scrollRect)
	arg0_27.statusPanel:Dispose()

	arg0_27.statusPanel = nil

	for iter0_27, iter1_27 in ipairs(arg0_27.cards or {}) do
		iter1_27:Dispose()
	end

	arg0_27.cards = nil
end

return var0_0
