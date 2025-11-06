local var0_0 = class("IslandInventoryPage", import("...base.IslandBasePage"))
local var1_0 = 101
local var2_0 = 102
local var3_0 = 103
local var4_0 = false

var0_0.INVENTORY_TYPE_OVERFLOW = 100
var0_0.INVENTORY_TYPE_COMMON = 101
var0_0.MODE_VIEW = 0
var0_0.MODE_EDIT = 1

function var0_0.getUIName(arg0_1)
	return "IslandInventoryUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2._tf:Find("window/close_btn")
	arg0_2.filterBtn = arg0_2._tf:Find("window/sort_panel/index")
	arg0_2.orderBtn = arg0_2._tf:Find("window/sort_panel/sort")
	arg0_2.orderTxt = arg0_2._tf:Find("window/sort_panel/sort/Text"):GetComponent(typeof(Text))
	arg0_2.orderArr = arg0_2._tf:Find("window/sort_panel/sort/arr")
	arg0_2.toggles = {
		[var0_0.INVENTORY_TYPE_OVERFLOW] = arg0_2._tf:Find("window/toggles/0"),
		[IslandItem.TYPE_MATERIAL] = arg0_2._tf:Find("window/toggles/1"),
		[IslandItem.TYPE_PROP] = arg0_2._tf:Find("window/toggles/2"),
		[IslandItem.TYPE_SPECIAL_PROP] = arg0_2._tf:Find("window/toggles/3")
	}
	arg0_2.indexDatas = {
		[var0_0.INVENTORY_TYPE_OVERFLOW] = IslandInventoryIndexData.New(var1_0),
		[IslandItem.TYPE_MATERIAL] = IslandInventoryIndexData.New(var1_0),
		[IslandItem.TYPE_PROP] = IslandInventoryIndexData.New(var2_0),
		[IslandItem.TYPE_SPECIAL_PROP] = IslandInventoryIndexData.New(var3_0)
	}
	arg0_2.capacityTxt = arg0_2._tf:Find("window/upgrade/Text"):GetComponent(typeof(Text))
	arg0_2.upgradeBtn = arg0_2._tf:Find("window/upgrade")
	arg0_2.upgradeProg = arg0_2._tf:Find("window/upgrade/bar")
	arg0_2.batchSellBtn = arg0_2._tf:Find("window/batch_sell")
	arg0_2.sellPanel = arg0_2._tf:Find("window/sell_panel")

	setText(arg0_2.sellPanel:Find("tip"), i18n("island_quickselect_tip"))

	arg0_2.sortPaenl = arg0_2._tf:Find("window/sort_panel")
	arg0_2.sellBtn = arg0_2._tf:Find("window/sell_panel/batch_sell_1")
	arg0_2.sellCancelBtn = arg0_2._tf:Find("window/sell_panel/cancel")
	arg0_2.sellAllBtn = arg0_2._tf:Find("window/sell_panel/all")

	setActive(arg0_2.sellAllBtn, var4_0)

	arg0_2.sellAllFlagTF = arg0_2.sellAllBtn:Find("flag")
	arg0_2.sellPriceTxt = arg0_2._tf:Find("window/sell_panel/price/Text"):GetComponent(typeof(Text))

	LoadImageSpriteAsync("island/" .. getIslandSeasonPtInfo().icon, arg0_2._tf:Find("window/sell_panel/price/Text/icon"))

	arg0_2.oneKeyPanel = arg0_2._tf:Find("window/one_key_panel")
	arg0_2.onekeyBtn = arg0_2._tf:Find("window/one_key_panel/fetch_btn")
	arg0_2.scrollRect = arg0_2._tf:Find("window/item_scrollview"):GetComponent("LScrollRect")

	setText(arg0_2._tf:Find("window/title/Text"), i18n("island_bag_title"))
	setText(arg0_2._tf:Find("window/batch_sell/Text"), i18n("island_batch_covert"))
	setText(arg0_2._tf:Find("window/sell_panel/price/label"), i18n("island_total_price"))
	setText(arg0_2._tf:Find("window/sell_panel/cancel/Text"), i18n("word_cancel"))
	setText(arg0_2._tf:Find("window/sell_panel/all/Text"), i18n("island_selectall"))
	setText(arg0_2._tf:Find("window/sell_panel/batch_sell_1/Text"), i18n("island_batch_covert"))
	setText(arg0_2._tf:Find("window/one_key_panel/fetch_btn/Text"), i18n("mail_get_oneclick"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.upgradeBtn, function()
		arg0_3:OpenPage(IslandInventoryUpgradePage)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.batchSellBtn, function()
		arg0_3.mode = var0_0.MODE_EDIT

		arg0_3:SetTotalCount()
		arg0_3:UpdateStyle()

		arg0_3.sellPriceTxt.text = "x 0"
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.sellCancelBtn, function()
		arg0_3.mode = var0_0.MODE_VIEW

		arg0_3:SetTotalCount()
		arg0_3:UpdateStyle()

		for iter0_8, iter1_8 in ipairs(arg0_3.values) do
			arg0_3.values[iter0_8] = 0
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.sellAllBtn, function(arg0_9)
		if not var4_0 then
			return
		end

		if arg0_3.selAllFlag then
			arg0_3:UpdataUnselAll()
		else
			arg0_3:UpdataSelAll()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.sellBtn, function()
		local var0_10 = arg0_3:GetSellItems()

		if #var0_10 <= 0 then
			return
		end

		arg0_3:ShowMsgBox({
			content = i18n("island_season_window_transformtip"),
			onYes = function()
				if arg0_3.tagType == var0_0.INVENTORY_TYPE_OVERFLOW then
					arg0_3:emit(IslandMediator.ON_CONVERT_SEASON_PT_4_OVERFLOW, var0_10)
				else
					arg0_3:emit(IslandMediator.ON_CONVERT_SEASON_PT, var0_10)
				end
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.onekeyBtn, function()
		if arg0_3.tagType ~= var0_0.INVENTORY_TYPE_OVERFLOW then
			return
		end

		arg0_3:emit(IslandMediator.ONE_KEY)
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_13)
	arg0_13:SetUp()
end

function var0_0.GetSellItems(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14.values) do
		local var1_14 = arg0_14.displays[iter0_14]

		var0_14[var1_14.id] = (var0_14[var1_14.id] or 0) + iter1_14
	end

	local var2_14 = {}

	for iter2_14, iter3_14 in pairs(var0_14) do
		if iter3_14 > 0 then
			table.insert(var2_14, {
				id = iter2_14,
				num = iter3_14
			})
		end
	end

	return var2_14
end

function var0_0.UpdateStyle(arg0_15)
	setActive(arg0_15.sellPanel, arg0_15.mode == var0_0.MODE_EDIT)
	setActive(arg0_15.sortPaenl, arg0_15.mode == var0_0.MODE_VIEW and arg0_15.tagType ~= var0_0.INVENTORY_TYPE_OVERFLOW)
	setActive(arg0_15.oneKeyPanel, arg0_15.tagType == var0_0.INVENTORY_TYPE_OVERFLOW and arg0_15.mode ~= var0_0.MODE_EDIT)
	setActive(arg0_15.batchSellBtn, arg0_15.mode == var0_0.MODE_VIEW)

	if arg0_15.mode == var0_0.MODE_EDIT then
		arg0_15:CheckSelAllFlag()
	end
end

function var0_0.AddListeners(arg0_16)
	arg0_16:AddListener(IslandScene.ON_INVENTORY_FILTER, arg0_16.OnInventoryFilter)
	arg0_16:AddListener(GAME.ISLAND_UPGRADE_INVENTORY_DONE, arg0_16.OnUpgrade)
	arg0_16:AddListener(GAME.ISLAND_CONVERT_SEASON_PT_DONE, arg0_16.OnSell)
	arg0_16:AddListener(GAME.ISLAND_GET_OVERFLOW_ITEM_DOME, arg0_16.OnSell)
	arg0_16:AddListener(GAME.ISLAND_INVITE_SHIP_DONE, arg0_16.OnUseInvitation)
end

function var0_0.RemoveListeners(arg0_17)
	arg0_17:RemoveListener(IslandScene.ON_INVENTORY_FILTER, arg0_17.OnInventoryFilter)
	arg0_17:RemoveListener(GAME.ISLAND_UPGRADE_INVENTORY_DONE, arg0_17.OnUpgrade)
	arg0_17:RemoveListener(GAME.ISLAND_CONVERT_SEASON_PT_DONE, arg0_17.OnSell)
	arg0_17:RemoveListener(GAME.ISLAND_GET_OVERFLOW_ITEM_DOME, arg0_17.OnSell)
	arg0_17:RemoveListener(GAME.ISLAND_INVITE_SHIP_DONE, arg0_17.OnUseInvitation)
end

function var0_0.OnUseInvitation(arg0_18)
	arg0_18:SetTotalCount()
end

function var0_0.GetIndexData(arg0_19, arg1_19)
	assert(arg0_19.indexDatas[arg1_19])

	return arg0_19.indexDatas[arg1_19]
end

function var0_0.UpdateIndexData(arg0_20, arg1_20, arg2_20)
	assert(arg0_20.indexDatas[arg1_20])
	arg0_20.indexDatas[arg1_20]:SetData(arg2_20)
end

function var0_0.OnInventoryFilter(arg0_21, arg1_21)
	arg0_21:UpdateIndexData(arg0_21.tagType, arg1_21)
	arg0_21:FlushSortBtn()
	arg0_21:SetTotalCount()
end

function var0_0.OnUpgrade(arg0_22)
	arg0_22:SetTotalCount()
	arg0_22:FlushCapacity()
	arg0_22:ClosePage(IslandInventoryUpgradePage)
end

function var0_0.OnSell(arg0_23)
	arg0_23.mode = var0_0.MODE_VIEW

	arg0_23:SetTotalCount()
	arg0_23:UpdateStyle()
	arg0_23:FlushCapacity()

	arg0_23.sellPriceTxt.text = "x 0"
end

function var0_0.SetUp(arg0_24)
	arg0_24.tagType = IslandItem.TYPE_MATERIAL
	arg0_24.mode = var0_0.MODE_VIEW
	arg0_24.asc = true
	arg0_24.cards = {}

	arg0_24:FlushTags()
	arg0_24:FlushFilterBtn()
	arg0_24:FlushSortBtn()
	arg0_24:FlushList()
	arg0_24:FlushCapacity()
	arg0_24:UpdateStyle()
end

function var0_0.FlushCapacity(arg0_25)
	if arg0_25.tagType == IslandItem.TYPE_MATERIAL then
		setActive(arg0_25.upgradeBtn, true)
		setActive(arg0_25.batchSellBtn, true)

		local var0_25 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
		local var1_25 = var0_25:GetLength()
		local var2_25 = var0_25:GetCapacity()

		setButtonEnabled(arg0_25.upgradeBtn, not var0_25:IsMaxLevel())

		local var3_25 = var1_25 / var2_25
		local var4_25 = math.min(var3_25, 1)

		arg0_25:managedTween(LeanTween.value, nil, go(arg0_25.upgradeBtn), 0, var3_25, var4_25):setOnUpdate(System.Action_float(function(arg0_26)
			arg0_25.capacityTxt.text = calcFloor(var2_25 * arg0_26) .. "/" .. var2_25

			setFillAmount(arg0_25.upgradeProg, arg0_26)
		end)):setOnComplete(System.Action(function()
			arg0_25.capacityTxt.text = var1_25 .. "/" .. var2_25

			setFillAmount(arg0_25.upgradeProg, var3_25)
		end))

		local var5_25 = var3_25 > 0.85 and Color.New(0.952941176470588, 0.423529411764706, 0.431372549019608, 1) or Color.New(0.223529411764706, 0.745098039215686, 1, 1)

		arg0_25.upgradeProg:GetComponent(typeof(Image)).color = var5_25
	elseif arg0_25.tagType == var0_0.INVENTORY_TYPE_OVERFLOW then
		setActive(arg0_25.upgradeBtn, false)
		setActive(arg0_25.batchSellBtn, true)
	else
		setActive(arg0_25.upgradeBtn, false)
		setActive(arg0_25.batchSellBtn, false)
	end
end

function var0_0.FlushTags(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28.toggles) do
		onToggle(arg0_28, iter1_28, function(arg0_29)
			if arg0_29 then
				arg0_28:CheckEditMode(iter0_28)

				arg0_28.tagType = iter0_28

				arg0_28:FlushCapacity()
				arg0_28:FlushSortBtn()
				arg0_28:SetTotalCount()
				arg0_28:UpdateStyle()
			end
		end, SFX_PANEL)

		if iter0_28 == var0_0.INVENTORY_TYPE_OVERFLOW then
			setText(iter1_28:Find("Text"), i18n("island_word_temp"))
		else
			setText(iter1_28:Find("Text"), IslandItemKind.Type2TagName(iter0_28))
		end
	end

	arg0_28:ActiveDefaultTag()
end

function var0_0.ActiveDefaultTag(arg0_30)
	local var0_30 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():ExistAnyOverFlowItem()

	setActive(arg0_30.toggles[var0_0.INVENTORY_TYPE_OVERFLOW], var0_30)

	if var0_30 then
		triggerToggle(arg0_30.toggles[var0_0.INVENTORY_TYPE_OVERFLOW], true)
	else
		triggerToggle(arg0_30.toggles[IslandItem.TYPE_MATERIAL], true)
	end
end

function var0_0.CheckEditMode(arg0_31, arg1_31)
	if arg0_31.tagType ~= arg1_31 and arg0_31.mode == var0_0.MODE_EDIT then
		triggerButton(arg0_31.sellCancelBtn)
	end
end

function var0_0.FlushFilterBtn(arg0_32)
	onButton(arg0_32, arg0_32.filterBtn, function()
		local var0_33 = arg0_32:GetIndexData(arg0_32.tagType)

		arg0_32:OpenPage(IslandInventoryIndexPage, var0_33)
	end, SFX_PANEL)
end

function var0_0.FlushSortBtn(arg0_34)
	local function var0_34()
		local var0_35 = arg0_34:GetIndexData(arg0_34.tagType)

		arg0_34.orderTxt.text = var0_35:GetSortText()
		arg0_34.orderArr.localScale = arg0_34.asc and Vector2(1, -1, 1) or Vector2(1, 1, 1)
	end

	onButton(arg0_34, arg0_34.orderBtn, function()
		arg0_34.asc = not arg0_34.asc

		var0_34()
		arg0_34:SetTotalCount()
	end, SFX_PANEL)
	var0_34()
end

function var0_0.FlushList(arg0_37)
	function arg0_37.scrollRect.onInitItem(arg0_38)
		arg0_37:OnInitItem(arg0_38)
	end

	function arg0_37.scrollRect.onUpdateItem(arg0_39, arg1_39)
		arg0_37:OnUpdateItem(arg0_39, arg1_39)
	end

	arg0_37:SetTotalCount()
end

function var0_0.SetTotalCount(arg0_40)
	arg0_40.displays = arg0_40:Filter()
	arg0_40.values = {}
	arg0_40.selAllFlag = false

	for iter0_40, iter1_40 in ipairs(arg0_40.displays) do
		table.insert(arg0_40.values, 0)
	end

	local var0_40 = arg0_40:GetIndexData(arg0_40.tagType)

	table.sort(arg0_40.displays, function(arg0_41, arg1_41)
		return var0_40:Sort(arg0_41, arg1_41, arg0_40.asc)
	end)
	arg0_40.scrollRect:SetTotalCount(#arg0_40.displays, -1)
end

function var0_0.OnInitItem(arg0_42, arg1_42)
	local var0_42 = IslandItemCard.New(arg1_42)

	onButton(arg0_42, var0_42._go, function()
		if arg0_42.mode == var0_0.MODE_VIEW then
			if arg0_42.tagType ~= var0_0.INVENTORY_TYPE_OVERFLOW then
				arg0_42:OnClickItem(var0_42)
			end
		elseif arg0_42.mode == var0_0.MODE_EDIT then
			arg0_42:OnClickItemForSell(var0_42)
		end
	end, SFX_PANEL)
	onButton(arg0_42, var0_42.reduceBtn, function()
		if arg0_42.mode == var0_0.MODE_EDIT then
			arg0_42:UpdateSellPrice(var0_42, -1)
		end
	end, SFX_PANEL)
	onInputEndEdit(arg0_42, var0_42.valueInput, function(arg0_45)
		local var0_45 = table.indexof(arg0_42.displays, var0_42.item)

		if not var0_45 then
			return
		end

		local var1_45 = 0

		if not arg0_45 or arg0_45 == "" or not tonumber(arg0_45) then
			local var2_45 = 1
		end

		local var3_45 = tonumber(arg0_45) - arg0_42.values[var0_45]

		arg0_42:UpdateSellPrice(var0_42, var3_45)
	end)
	pressPersistTrigger(var0_42.calcPanel, 0.5, function()
		if arg0_42.mode == var0_0.MODE_EDIT then
			arg0_42:UpdateSellPrice(var0_42, 1)
		end
	end, nil, true, true, 0.1, SFX_PANEL)

	arg0_42.cards[arg1_42] = var0_42
end

function var0_0.OnClickItem(arg0_47, arg1_47)
	if isa(arg1_47.item, IslandInvitation) then
		local var0_47 = arg1_47.item:GetShipName()

		arg0_47:ShowMsgBox({
			content = i18n("island_open_ship_tip"),
			onYes = function()
				arg0_47:Hide()
				arg0_47:emit(IslandBaseMediator.SWITCH_MAP, IslandConst.LABORATORY_MAP_ID, IslandConst.LETTEROFINVITATION_SP)
			end
		})
	else
		arg0_47:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_ITEM,
			itemId = arg1_47.item.id
		})
	end
end

function var0_0.OnClickItemForSell(arg0_49, arg1_49)
	arg0_49:UpdateSellPrice(arg1_49, 1)
end

function var0_0._IsSelAll(arg0_50)
	for iter0_50, iter1_50 in ipairs(arg0_50.values) do
		if iter1_50 ~= arg0_50.displays[iter0_50]:GetCount() then
			return false
		end
	end

	return true
end

function var0_0.CheckSelAllFlag(arg0_51)
	arg0_51.selAllFlag = arg0_51:_IsSelAll()

	setActive(arg0_51.sellAllFlagTF, arg0_51.selAllFlag)
end

function var0_0.UpdataSelAll(arg0_52)
	arg0_52.values = {}

	for iter0_52, iter1_52 in ipairs(arg0_52.displays) do
		arg0_52.values[iter0_52] = iter1_52:GetCount()
	end

	arg0_52.scrollRect:SetTotalCount(#arg0_52.displays, -1)

	local var0_52 = 0

	for iter2_52, iter3_52 in ipairs(arg0_52.values) do
		var0_52 = arg0_52.displays[iter2_52]:GetConvertPt() * iter3_52 + var0_52
	end

	arg0_52.sellPriceTxt.text = "x " .. var0_52
	arg0_52.selAllFlag = true

	setActive(arg0_52.sellAllFlagTF, arg0_52.selAllFlag)
end

function var0_0.UpdataUnselAll(arg0_53)
	arg0_53:SetTotalCount()

	arg0_53.sellPriceTxt.text = "x 0"
	arg0_53.selAllFlag = false

	setActive(arg0_53.sellAllFlagTF, arg0_53.selAllFlag)
end

function var0_0.UpdateSellPrice(arg0_54, arg1_54, arg2_54)
	local var0_54 = table.indexof(arg0_54.displays, arg1_54.item)

	if not var0_54 then
		return
	end

	local var1_54 = arg0_54.values[var0_54] + arg2_54

	arg0_54.values[var0_54] = math.max(0, math.min(var1_54, arg1_54.item:GetCount()))

	arg1_54:UpdateValue(arg0_54.values[var0_54])

	local var2_54 = 0

	for iter0_54, iter1_54 in ipairs(arg0_54.values) do
		var2_54 = arg0_54.displays[iter0_54]:GetConvertPt() * iter1_54 + var2_54
	end

	arg0_54.sellPriceTxt.text = "x " .. var2_54

	arg0_54:CheckSelAllFlag()
end

function var0_0.OnUpdateItem(arg0_55, arg1_55, arg2_55)
	local var0_55 = arg0_55.cards[arg2_55]

	if not var0_55 then
		arg0_55:OnInitItem(arg2_55)

		var0_55 = arg0_55.cards[arg2_55]
	end

	if arg0_55.displays[arg1_55 + 1] then
		var0_55:Update(arg0_55.displays[arg1_55 + 1], arg0_55.mode, arg0_55.values[arg1_55 + 1], arg0_55.tagType)
	end
end

function var0_0.Filter(arg0_56)
	local var0_56 = {}

	if arg0_56.tagType == var0_0.INVENTORY_TYPE_OVERFLOW then
		arg0_56:CollectOverFlowInventoryItems(var0_56)
	else
		arg0_56:CollectCommonInventoryItems(var0_56)
	end

	if arg0_56.mode == var0_0.MODE_EDIT then
		var0_56 = underscore.select(var0_56, function(arg0_57)
			return arg0_57:CanConvert()
		end)
	end

	return var0_56
end

function var0_0.CollectOverFlowInventoryItems(arg0_58, arg1_58)
	local var0_58 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOverflowItemList()

	for iter0_58, iter1_58 in pairs(var0_58) do
		table.insert(arg1_58, iter1_58)
	end
end

function var0_0.CollectCommonInventoryItems(arg0_59, arg1_59)
	local var0_59 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetGroupedItemList()

	for iter0_59, iter1_59 in ipairs(var0_59) do
		if arg0_59.tagType == IslandItem.TYPE_MATERIAL and iter1_59:IsMaterial() and arg0_59.indexDatas[IslandItem.TYPE_MATERIAL]:Match(iter1_59) then
			table.insert(arg1_59, iter1_59)
		elseif arg0_59.tagType == IslandItem.TYPE_PROP and iter1_59:IsProp() and arg0_59.indexDatas[IslandItem.TYPE_PROP]:Match(iter1_59) then
			table.insert(arg1_59, iter1_59)
		elseif arg0_59.tagType == IslandItem.TYPE_SPECIAL_PROP and iter1_59:IsSpecialProp() and arg0_59.indexDatas[IslandItem.TYPE_SPECIAL_PROP]:Match(iter1_59) then
			table.insert(arg1_59, iter1_59)
		end
	end

	if arg0_59.tagType == IslandItem.TYPE_SPECIAL_PROP then
		local var1_59 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetInviteList()

		for iter2_59, iter3_59 in ipairs(var1_59) do
			local var2_59 = IslandInvitation.New(iter3_59)

			if arg0_59.indexDatas[IslandItem.TYPE_SPECIAL_PROP]:Match(var2_59) then
				table.insert(arg1_59, var2_59)
			end
		end
	end
end

function var0_0.OnDestroy(arg0_60)
	ClearLScrollrect(arg0_60.scrollRect)

	for iter0_60, iter1_60 in pairs(arg0_60.cards) do
		iter1_60:Dispose()
	end

	arg0_60.cards = {}
end

return var0_0
