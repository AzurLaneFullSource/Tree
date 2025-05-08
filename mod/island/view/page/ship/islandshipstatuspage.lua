local var0_0 = class("IslandShipStatusPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipStatusUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.scrollRect = arg0_2:findTF("adapt/attr_panel/srcollrect"):GetComponent("LScrollRect")

	function arg0_2.scrollRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	arg0_2.giveBtn = arg0_2:findTF("adapt/attr_panel/send_panel/give_btn")
	arg0_2.emptyTr = arg0_2:findTF("adapt/attr_panel/send_panel/empty")
	arg0_2.giftEffectList = UIItemList.New(arg0_2:findTF("adapt/attr_panel/send_panel/list"), arg0_2:findTF("adapt/attr_panel/send_panel/list/tpl"))
	arg0_2.statusPanel = IslandShipStatusPanel.New(arg0_2:findTF("adapt/attr_panel/status"))

	setText(arg0_2.emptyTr:Find("Text"), i18n1("点击选择赠送的礼物"))
end

function var0_0.OnInit(arg0_5)
	arg0_5.cards = {}

	onButton(arg0_5, arg0_5.giveBtn, function()
		if not arg0_5.selectedId then
			return
		end

		local var0_6 = "island_energy_overflow" .. getProxy(PlayerProxy):getRawData().id

		if arg0_5:IsOverflowEnergy(arg0_5.shipId, arg0_5.selectedId) and arg0_5:ShouldTip(var0_6) then
			arg0_5:ShowMsgBox({
				type = IslandMsgBox.TYPE_REMIND,
				content = i18n1("赠送该礼物后角色的体力会超上限，超出的\n部分将会消失,是否确定赠送？"),
				key = var0_6,
				onYes = function()
					arg0_5:emit(IslandMediator.ON_GIVE_GIFT, arg0_5.selectedId, 1, arg0_5.shipId)
				end
			})
		else
			arg0_5:emit(IslandMediator.ON_GIVE_GIFT, arg0_5.selectedId, 1, arg0_5.shipId)
		end
	end, SFX_PANEL)
end

function var0_0.ShouldTip(arg0_8, arg1_8)
	local var0_8 = PlayerPrefs.GetInt(arg1_8, 0)

	if var0_8 == 0 then
		return true
	end

	return var0_8 <= pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.IsOverflowEnergy(arg0_9, arg1_9, arg2_9)
	local var0_9 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_9)
	local var1_9 = var0_9:GetEnergy()
	local var2_9 = var0_9:GetMaxEnergy()
	local var3_9 = IslandItem.StaticGetUsageArg(arg2_9)

	return var2_9 < var1_9 + tonumber(var3_9)
end

function var0_0.AddListeners(arg0_10)
	arg0_10:AddListener(GAME.ISLAND_USE_ITEM_DONE, arg0_10.OnUseItem)
end

function var0_0.RemoveListeners(arg0_11)
	arg0_11:RemoveListener(GAME.ISLAND_USE_ITEM_DONE, arg0_11.OnUseItem)
end

function var0_0.OnUseItem(arg0_12)
	arg0_12:FlushStatus(arg0_12.ship)
	arg0_12:FlushGifts()
end

function var0_0.OnShow(arg0_13, arg1_13)
	arg0_13.selectedId = nil

	local var0_13 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipByConfigId(arg1_13)

	if var0_13 == nil then
		return
	end

	arg0_13.ship = var0_13
	arg0_13.shipId = arg0_13.ship.id

	arg0_13:FlushStatus(var0_13)
	arg0_13:FlushGifts()
	arg0_13:UpdateSelected(arg0_13.selectedId)
end

function var0_0.FlushStatus(arg0_14, arg1_14)
	arg0_14.statusPanel:Flush(arg1_14)

	local var0_14 = arg1_14:GetValidStatus()

	onButton(arg0_14, arg0_14.statusPanel.viewBtn, function()
		arg0_14:ShowMsgBox({
			hideNo = true,
			type = IslandMsgBox.TYPE_STATUS,
			title = i18n1("详情"),
			statusList = var0_14
		})
	end, SFX_PANEL)
end

function var0_0.OnInitItem(arg0_16, arg1_16)
	local var0_16 = IslandGiftCard.New(arg1_16)

	onButton(arg0_16, var0_16.go, function()
		if var0_16.item:GetCount() <= 0 then
			arg0_16:ShowMsgBox({
				title = i18n1("详情"),
				type = IslandMsgBox.TYPE_ITEM_DESC,
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
end

function var0_0.CollectGiftEffect(arg0_23, arg1_23)
	local var0_23 = {}
	local var1_23 = IslandItem.StaticGetUsageArg(arg1_23)

	table.insert(var0_23, i18n1("角色体力+" .. var1_23))

	local var2_23 = arg0_23.ship:GetFavoriteGift()

	if table.contains(var2_23, arg1_23) then
		local var3_23 = IslandShip.StaticGetGiftStatue()
		local var4_23 = pg.island_ship_state[var3_23]

		table.insert(var0_23, var4_23.desc)
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
