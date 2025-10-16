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
end

function var0_0.OnInit(arg0_5)
	arg0_5.cards = {}

	onButton(arg0_5, arg0_5.giveBtn, function()
		if not arg0_5.selectedId then
			return
		end

		local var0_6 = {}
		local var1_6 = arg0_5:CollectGiftBuffs(arg0_5.selectedId)

		for iter0_6, iter1_6 in ipairs(var1_6) do
			table.insert(var0_6, function(arg0_7)
				IslandAddShipStatusHelper.CheckAddStatus(arg0_5, arg0_5.ship, iter1_6, arg0_7)
			end)
		end

		seriesAsync(var0_6, function()
			arg0_5:emit(IslandMediator.ON_GIVE_GIFT, arg0_5.selectedId, 1, arg0_5.shipId)
		end)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_9)
	arg0_9:AddListener(GAME.ISLAND_GIVE_GIFT_DONE, arg0_9.OnUseItem)
end

function var0_0.RemoveListeners(arg0_10)
	arg0_10:RemoveListener(GAME.ISLAND_GIVE_GIFT_DONE, arg0_10.OnUseItem)
end

function var0_0.OnUseItem(arg0_11)
	arg0_11.selectedId = nil

	arg0_11:FlushStatus(arg0_11.ship)
	arg0_11:FlushGifts()
end

function var0_0.OnShow(arg0_12, arg1_12)
	arg0_12.selectedId = nil

	local var0_12 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_12)

	if var0_12 == nil then
		return
	end

	arg0_12.ship = var0_12
	arg0_12.shipId = arg0_12.ship.id

	arg0_12:FlushStatus(var0_12)
	arg0_12:FlushGifts()
	arg0_12:UpdateSelected(arg0_12.selectedId)
end

function var0_0.FlushStatus(arg0_13, arg1_13)
	arg0_13.statusPanel:Flush(arg1_13)

	local var0_13 = arg1_13:GetDisplayStatus()

	onButton(arg0_13, arg0_13.statusPanel.viewBtn, function()
		arg0_13:ShowMsgBox({
			hideNo = true,
			type = IslandMsgBox.TYPE_SHIP_OWN_STATUS,
			title = i18n("island_word_ship_buff_desc"),
			statusList = var0_13
		})
	end, SFX_PANEL)
end

function var0_0.OnInitItem(arg0_15, arg1_15)
	local var0_15 = IslandGiftCard.New(arg1_15)

	onButton(arg0_15, var0_15.go, function()
		if var0_15.item:GetCount() <= 0 then
			arg0_15:ShowMsgBox({
				title = i18n("island_word_ship_buff_desc"),
				type = IslandMsgBox.TYPE_COMMON_ITEM,
				itemId = var0_15.item.id
			})

			return
		end

		arg0_15.selectedId = nil

		for iter0_16, iter1_16 in pairs(arg0_15.cards) do
			iter1_16:UpdateSelected(arg0_15.selectedId)
		end

		arg0_15:UpdateSelected(var0_15.itemId)
		var0_15:UpdateSelected(arg0_15.selectedId)
	end, SFX_PANEL)

	arg0_15.cards[arg1_15] = var0_15
end

function var0_0.OnUpdateItem(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.cards[arg2_17]

	if not var0_17 then
		arg0_17:OnInitItem(arg2_17)

		var0_17 = arg0_17.cards[arg2_17]
	end

	var0_17:Update(arg0_17.shipId, arg0_17.displays[arg1_17 + 1], arg0_17.selectedId)
end

function var0_0.FlushGifts(arg0_18)
	local var0_18 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetGifts()

	arg0_18.displays = {}

	for iter0_18, iter1_18 in pairs(var0_18) do
		table.insert(arg0_18.displays, iter1_18)
	end

	table.sort(arg0_18.displays, function(arg0_19, arg1_19)
		return arg0_19.id < arg1_19.id
	end)
	arg0_18.scrollRect:SetTotalCount(#arg0_18.displays)
end

function var0_0.UpdateSelected(arg0_20, arg1_20)
	arg0_20.selectedId = arg1_20

	setActive(arg0_20.emptyTr, arg0_20.selectedId == nil)
	setActive(arg0_20.giftEffectList.container, arg0_20.selectedId)

	if arg0_20.selectedId then
		local var0_20 = arg0_20:CollectGiftEffect(arg1_20)

		arg0_20.giftEffectList:make(function(arg0_21, arg1_21, arg2_21)
			if arg0_21 == UIItemList.EventUpdate then
				setText(arg2_21, var0_20[arg1_21 + 1])
			end
		end)
		arg0_20.giftEffectList:align(#var0_20)
	end
end

function var0_0.CollectGiftBuffs(arg0_22, arg1_22)
	local var0_22 = {}
	local var1_22 = IslandItem.StaticGetUsageArg(arg1_22)
	local var2_22 = arg0_22.ship:IsFavoriteGift(arg1_22) and IslandConst.GIFT_INDEX_FAVORITE or IslandConst.GIFT_INDEX_COMMON

	for iter0_22, iter1_22 in ipairs(var1_22) do
		if var2_22 == iter0_22 then
			local var3_22 = iter1_22[2]

			for iter2_22, iter3_22 in ipairs(var3_22) do
				table.insert(var0_22, iter3_22)
			end
		end
	end

	return var0_22
end

function var0_0.CollectGiftEffect(arg0_23, arg1_23)
	local var0_23 = {}
	local var1_23 = IslandItem.StaticGetUsageArg(arg1_23)
	local var2_23 = IslandConst.GIFT_INDEX_COMMON
	local var3_23 = IslandConst.GIFT_INDEX_FAVORITE
	local var4_23 = arg0_23.ship:IsFavoriteGift(arg1_23) and var1_23[var3_23] or var1_23[var2_23]

	if var4_23[var2_23] > 0 then
		table.insert(var0_23, i18n("island_word_ship_enengy_recover") .. var4_23[var2_23])
	end

	for iter0_23, iter1_23 in ipairs(var4_23[2]) do
		local var5_23 = pg.island_buff_template[iter1_23]

		table.insert(var0_23, var5_23.buff_desc)
	end

	return var0_23
end

function var0_0.OnDestroy(arg0_24)
	ClearLScrollrect(arg0_24.scrollRect)
	arg0_24.statusPanel:Dispose()

	arg0_24.statusPanel = nil

	for iter0_24, iter1_24 in ipairs(arg0_24.cards or {}) do
		iter1_24:Dispose()
	end

	arg0_24.cards = nil
end

return var0_0
