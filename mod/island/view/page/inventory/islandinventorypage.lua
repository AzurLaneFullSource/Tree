local var0_0 = class("IslandInventoryPage", import("...base.IslandBasePage"))
local var1_0 = 101
local var2_0 = 102
local var3_0 = 103

var0_0.INVENTORY_TYPE_OVERFLOW = 100
var0_0.INVENTORY_TYPE_COMMON = 101
var0_0.MODE_VIEW = 0
var0_0.MODE_EDIT = 1

function var0_0.getUIName(arg0_1)
	return "IslandInventoryUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("window/close_btn")
	arg0_2.filterBtn = arg0_2:findTF("window/sort_panel/index")
	arg0_2.orderBtn = arg0_2:findTF("window/sort_panel/sort")
	arg0_2.orderTxt = arg0_2:findTF("window/sort_panel/sort/Text"):GetComponent(typeof(Text))
	arg0_2.orderArr = arg0_2:findTF("window/sort_panel/sort/arr")
	arg0_2.toggles = {
		[var0_0.INVENTORY_TYPE_OVERFLOW] = arg0_2:findTF("window/toggles/0"),
		[IslandItem.TYPE_MATERIAL] = arg0_2:findTF("window/toggles/1"),
		[IslandItem.TYPE_PROP] = arg0_2:findTF("window/toggles/2"),
		[IslandItem.TYPE_SPECIAL_PROP] = arg0_2:findTF("window/toggles/3")
	}
	arg0_2.indexDatas = {
		[var0_0.INVENTORY_TYPE_OVERFLOW] = IslandInventoryIndexData.New(var1_0),
		[IslandItem.TYPE_MATERIAL] = IslandInventoryIndexData.New(var1_0),
		[IslandItem.TYPE_PROP] = IslandInventoryIndexData.New(var2_0),
		[IslandItem.TYPE_SPECIAL_PROP] = IslandInventoryIndexData.New(var3_0)
	}
	arg0_2.capacityTxt = arg0_2:findTF("window/upgrade/Text"):GetComponent(typeof(Text))
	arg0_2.upgradeBtn = arg0_2:findTF("window/upgrade")
	arg0_2.upgradeProg = arg0_2:findTF("window/upgrade/bar")
	arg0_2.batchSellBtn = arg0_2:findTF("window/batch_sell")
	arg0_2.sellPanel = arg0_2:findTF("window/sell_panel")
	arg0_2.sortPaenl = arg0_2:findTF("window/sort_panel")
	arg0_2.sellBtn = arg0_2:findTF("window/sell_panel/batch_sell_1")
	arg0_2.sellCancelBtn = arg0_2:findTF("window/sell_panel/cancel")
	arg0_2.sellPriceTxt = arg0_2:findTF("window/sell_panel/price/Text"):GetComponent(typeof(Text))

	LoadImageSpriteAsync("island/" .. getIslandSeasonPtInfo().icon, arg0_2:findTF("window/sell_panel/price/Text/icon"))

	arg0_2.oneKeyPanel = arg0_2:findTF("window/one_key_panel")
	arg0_2.onekeyBtn = arg0_2:findTF("window/one_key_panel/fetch_btn")
	arg0_2.scrollRect = arg0_2:findTF("window/item_scrollview"):GetComponent("LScrollRect")

	setText(arg0_2:findTF("window/title/Text"), i18n("island_bag_title"))
	setText(arg0_2:findTF("window/batch_sell/Text"), i18n("island_batch_covert"))
	setText(arg0_2:findTF("window/sell_panel/price/label"), i18n("island_total_price"))
	setText(arg0_2:findTF("window/sell_panel/cancel/Text"), i18n("word_cancel"))
	setText(arg0_2:findTF("window/sell_panel/batch_sell_1/Text"), i18n("island_batch_covert"))
	setText(arg0_2:findTF("window/one_key_panel/fetch_btn/Text"), i18n("mail_get_oneclick"))
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
	onButton(arg0_3, arg0_3.sellBtn, function()
		local var0_9 = arg0_3:GetSellItems()

		if #var0_9 <= 0 then
			return
		end

		arg0_3:ShowMsgBox({
			content = i18n("island_season_window_transformtip"),
			onYes = function()
				if arg0_3.tagType == var0_0.INVENTORY_TYPE_OVERFLOW then
					arg0_3:emit(IslandMediator.ON_CONVERT_SEASON_PT_4_OVERFLOW, var0_9)
				else
					arg0_3:emit(IslandMediator.ON_CONVERT_SEASON_PT, var0_9)
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

function var0_0.OnShow(arg0_12)
	arg0_12:SetUp()
end

function var0_0.GetSellItems(arg0_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13.values) do
		local var1_13 = arg0_13.displays[iter0_13]

		var0_13[var1_13.id] = (var0_13[var1_13.id] or 0) + iter1_13
	end

	local var2_13 = {}

	for iter2_13, iter3_13 in pairs(var0_13) do
		if iter3_13 > 0 then
			table.insert(var2_13, {
				id = iter2_13,
				num = iter3_13
			})
		end
	end

	return var2_13
end

function var0_0.UpdateStyle(arg0_14)
	setActive(arg0_14.sellPanel, arg0_14.mode == var0_0.MODE_EDIT)
	setActive(arg0_14.sortPaenl, arg0_14.mode == var0_0.MODE_VIEW and arg0_14.tagType ~= var0_0.INVENTORY_TYPE_OVERFLOW)
	setActive(arg0_14.oneKeyPanel, arg0_14.tagType == var0_0.INVENTORY_TYPE_OVERFLOW and arg0_14.mode ~= var0_0.MODE_EDIT)
	setActive(arg0_14.batchSellBtn, arg0_14.mode == var0_0.MODE_VIEW)
end

function var0_0.AddListeners(arg0_15)
	arg0_15:AddListener(IslandScene.ON_INVENTORY_FILTER, arg0_15.OnInventoryFilter)
	arg0_15:AddListener(GAME.ISLAND_UPGRADE_INVENTORY_DONE, arg0_15.OnUpgrade)
	arg0_15:AddListener(GAME.ISLAND_CONVERT_SEASON_PT_DONE, arg0_15.OnSell)
	arg0_15:AddListener(GAME.ISLAND_GET_OVERFLOW_ITEM_DOME, arg0_15.OnSell)
	arg0_15:AddListener(GAME.ISLAND_INVITE_SHIP_DONE, arg0_15.OnUseInvitation)
end

function var0_0.RemoveListeners(arg0_16)
	arg0_16:RemoveListener(IslandScene.ON_INVENTORY_FILTER, arg0_16.OnInventoryFilter)
	arg0_16:RemoveListener(GAME.ISLAND_UPGRADE_INVENTORY_DONE, arg0_16.OnUpgrade)
	arg0_16:RemoveListener(GAME.ISLAND_CONVERT_SEASON_PT_DONE, arg0_16.OnSell)
	arg0_16:RemoveListener(GAME.ISLAND_GET_OVERFLOW_ITEM_DOME, arg0_16.OnSell)
	arg0_16:RemoveListener(GAME.ISLAND_INVITE_SHIP_DONE, arg0_16.OnUseInvitation)
end

function var0_0.OnUseInvitation(arg0_17)
	arg0_17:SetTotalCount()
end

function var0_0.GetIndexData(arg0_18, arg1_18)
	assert(arg0_18.indexDatas[arg1_18])

	return arg0_18.indexDatas[arg1_18]
end

function var0_0.UpdateIndexData(arg0_19, arg1_19, arg2_19)
	assert(arg0_19.indexDatas[arg1_19])
	arg0_19.indexDatas[arg1_19]:SetData(arg2_19)
end

function var0_0.OnInventoryFilter(arg0_20, arg1_20)
	arg0_20:UpdateIndexData(arg0_20.tagType, arg1_20)
	arg0_20:FlushSortBtn()
	arg0_20:SetTotalCount()
end

function var0_0.OnUpgrade(arg0_21)
	arg0_21:SetTotalCount()
	arg0_21:FlushCapacity()
	arg0_21:ClosePage(IslandInventoryUpgradePage)
end

function var0_0.OnSell(arg0_22)
	arg0_22.mode = var0_0.MODE_VIEW

	arg0_22:SetTotalCount()
	arg0_22:UpdateStyle()
	arg0_22:FlushCapacity()

	arg0_22.sellPriceTxt.text = "x 0"
end

function var0_0.SetUp(arg0_23)
	arg0_23.tagType = IslandItem.TYPE_MATERIAL
	arg0_23.mode = var0_0.MODE_VIEW
	arg0_23.asc = true
	arg0_23.cards = {}

	arg0_23:FlushTags()
	arg0_23:FlushFilterBtn()
	arg0_23:FlushSortBtn()
	arg0_23:FlushList()
	arg0_23:FlushCapacity()
	arg0_23:UpdateStyle()
end

function var0_0.FlushCapacity(arg0_24)
	if arg0_24.tagType == IslandItem.TYPE_MATERIAL then
		setActive(arg0_24.upgradeBtn, true)
		setActive(arg0_24.batchSellBtn, true)

		local var0_24 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
		local var1_24 = var0_24:GetLength()
		local var2_24 = var0_24:GetCapacity()

		setButtonEnabled(arg0_24.upgradeBtn, not var0_24:IsMaxLevel())

		local var3_24 = var1_24 / var2_24
		local var4_24 = math.min(var3_24, 1)

		arg0_24:managedTween(LeanTween.value, nil, go(arg0_24.upgradeBtn), 0, var3_24, var4_24):setOnUpdate(System.Action_float(function(arg0_25)
			arg0_24.capacityTxt.text = calcFloor(var2_24 * arg0_25) .. "/" .. var2_24

			setFillAmount(arg0_24.upgradeProg, arg0_25)
		end)):setOnComplete(System.Action(function()
			arg0_24.capacityTxt.text = var1_24 .. "/" .. var2_24

			setFillAmount(arg0_24.upgradeProg, var3_24)
		end))

		local var5_24 = var3_24 > 0.85 and Color.New(0.952941176470588, 0.423529411764706, 0.431372549019608, 1) or Color.New(0.223529411764706, 0.745098039215686, 1, 1)

		arg0_24.upgradeProg:GetComponent(typeof(Image)).color = var5_24
	elseif arg0_24.tagType == var0_0.INVENTORY_TYPE_OVERFLOW then
		setActive(arg0_24.upgradeBtn, false)
		setActive(arg0_24.batchSellBtn, true)
	else
		setActive(arg0_24.upgradeBtn, false)
		setActive(arg0_24.batchSellBtn, false)
	end
end

function var0_0.FlushTags(arg0_27)
	for iter0_27, iter1_27 in pairs(arg0_27.toggles) do
		onToggle(arg0_27, iter1_27, function(arg0_28)
			if arg0_28 then
				arg0_27:CheckEditMode(iter0_27)

				arg0_27.tagType = iter0_27

				arg0_27:FlushCapacity()
				arg0_27:FlushSortBtn()
				arg0_27:SetTotalCount()
				arg0_27:UpdateStyle()
			end
		end, SFX_PANEL)

		if iter0_27 == var0_0.INVENTORY_TYPE_OVERFLOW then
			setText(iter1_27:Find("Text"), i18n("island_word_temp"))
		else
			setText(iter1_27:Find("Text"), IslandItemKind.Type2TagName(iter0_27))
		end
	end

	arg0_27:ActiveDefaultTag()
end

function var0_0.ActiveDefaultTag(arg0_29)
	local var0_29 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():ExistAnyOverFlowItem()

	setActive(arg0_29.toggles[var0_0.INVENTORY_TYPE_OVERFLOW], var0_29)

	if var0_29 then
		triggerToggle(arg0_29.toggles[var0_0.INVENTORY_TYPE_OVERFLOW], true)
	else
		triggerToggle(arg0_29.toggles[IslandItem.TYPE_MATERIAL], true)
	end
end

function var0_0.CheckEditMode(arg0_30, arg1_30)
	if arg0_30.tagType ~= arg1_30 and arg0_30.mode == var0_0.MODE_EDIT then
		triggerButton(arg0_30.sellCancelBtn)
	end
end

function var0_0.FlushFilterBtn(arg0_31)
	onButton(arg0_31, arg0_31.filterBtn, function()
		local var0_32 = arg0_31:GetIndexData(arg0_31.tagType)

		arg0_31:OpenPage(IslandInventoryIndexPage, var0_32)
	end, SFX_PANEL)
end

function var0_0.FlushSortBtn(arg0_33)
	local function var0_33()
		local var0_34 = arg0_33:GetIndexData(arg0_33.tagType)

		arg0_33.orderTxt.text = var0_34:GetSortText()
		arg0_33.orderArr.localScale = arg0_33.asc and Vector2(1, -1, 1) or Vector2(1, 1, 1)
	end

	onButton(arg0_33, arg0_33.orderBtn, function()
		arg0_33.asc = not arg0_33.asc

		var0_33()
		arg0_33:SetTotalCount()
	end, SFX_PANEL)
	var0_33()
end

function var0_0.FlushList(arg0_36)
	function arg0_36.scrollRect.onInitItem(arg0_37)
		arg0_36:OnInitItem(arg0_37)
	end

	function arg0_36.scrollRect.onUpdateItem(arg0_38, arg1_38)
		arg0_36:OnUpdateItem(arg0_38, arg1_38)
	end

	arg0_36:SetTotalCount()
end

function var0_0.SetTotalCount(arg0_39)
	arg0_39.displays = arg0_39:Filter()
	arg0_39.values = {}

	for iter0_39, iter1_39 in ipairs(arg0_39.displays) do
		table.insert(arg0_39.values, 0)
	end

	local var0_39 = arg0_39:GetIndexData(arg0_39.tagType)

	table.sort(arg0_39.displays, function(arg0_40, arg1_40)
		return var0_39:Sort(arg0_40, arg1_40, arg0_39.asc)
	end)
	arg0_39.scrollRect:SetTotalCount(#arg0_39.displays, -1)
end

function var0_0.OnInitItem(arg0_41, arg1_41)
	local var0_41 = IslandItemCard.New(arg1_41)

	onButton(arg0_41, var0_41._go, function()
		if arg0_41.mode == var0_0.MODE_VIEW then
			if arg0_41.tagType ~= var0_0.INVENTORY_TYPE_OVERFLOW then
				arg0_41:OnClickItem(var0_41)
			end
		elseif arg0_41.mode == var0_0.MODE_EDIT then
			arg0_41:OnClickItemForSell(var0_41)
		end
	end, SFX_PANEL)
	onButton(arg0_41, var0_41.calcPanel, function()
		if arg0_41.mode == var0_0.MODE_EDIT then
			arg0_41:UpdateSellPrice(var0_41, -1)
		end
	end, SFX_PANEL)
	onInputEndEdit(arg0_41, var0_41.valueInput, function(arg0_44)
		local var0_44 = table.indexof(arg0_41.displays, var0_41.item)

		if not var0_44 then
			return
		end

		local var1_44 = 0

		if not arg0_44 or arg0_44 == "" or not tonumber(arg0_44) then
			local var2_44 = 1
		end

		local var3_44 = tonumber(arg0_44) - arg0_41.values[var0_44]

		arg0_41:UpdateSellPrice(var0_41, var3_44)
	end)

	arg0_41.cards[arg1_41] = var0_41
end

function var0_0.OnClickItem(arg0_45, arg1_45)
	if isa(arg1_45.item, IslandInvitation) then
		local var0_45 = arg1_45.item:GetShipName()

		arg0_45:ShowMsgBox({
			content = i18n("island_open_ship_tip"),
			onYes = function()
				arg0_45:Hide()
				arg0_45:emit(IslandBaseMediator.SWITCH_MAP, IslandConst.LABORATORY_MAP_ID, IslandConst.LETTEROFINVITATION_SP)
			end
		})
	else
		arg0_45:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_ITEM,
			itemId = arg1_45.item.id
		})
	end
end

function var0_0.OnClickItemForSell(arg0_47, arg1_47)
	arg0_47:UpdateSellPrice(arg1_47, 1)
end

function var0_0.UpdateSellPrice(arg0_48, arg1_48, arg2_48)
	local var0_48 = table.indexof(arg0_48.displays, arg1_48.item)

	if not var0_48 then
		return
	end

	local var1_48 = arg0_48.values[var0_48] + arg2_48

	arg0_48.values[var0_48] = math.max(0, math.min(var1_48, arg1_48.item:GetCount()))

	arg1_48:UpdateValue(arg0_48.values[var0_48])

	local var2_48 = 0

	for iter0_48, iter1_48 in ipairs(arg0_48.values) do
		var2_48 = arg0_48.displays[iter0_48]:GetConvertPt() * iter1_48 + var2_48
	end

	arg0_48.sellPriceTxt.text = "x " .. var2_48
end

function var0_0.OnUpdateItem(arg0_49, arg1_49, arg2_49)
	local var0_49 = arg0_49.cards[arg2_49]

	if not var0_49 then
		arg0_49:OnInitItem(arg2_49)

		var0_49 = arg0_49.cards[arg2_49]
	end

	if arg0_49.displays[arg1_49 + 1] then
		var0_49:Update(arg0_49.displays[arg1_49 + 1], arg0_49.mode, arg0_49.values[arg1_49 + 1], arg0_49.tagType)
	end
end

function var0_0.Filter(arg0_50)
	local var0_50 = {}

	if arg0_50.tagType == var0_0.INVENTORY_TYPE_OVERFLOW then
		arg0_50:CollectOverFlowInventoryItems(var0_50)
	else
		arg0_50:CollectCommonInventoryItems(var0_50)
	end

	if arg0_50.mode == var0_0.MODE_EDIT then
		var0_50 = underscore.select(var0_50, function(arg0_51)
			return arg0_51:CanConvert()
		end)
	end

	return var0_50
end

function var0_0.CollectOverFlowInventoryItems(arg0_52, arg1_52)
	local var0_52 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOverflowItemList()

	for iter0_52, iter1_52 in pairs(var0_52) do
		table.insert(arg1_52, iter1_52)
	end
end

function var0_0.CollectCommonInventoryItems(arg0_53, arg1_53)
	local var0_53 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetGroupedItemList()

	for iter0_53, iter1_53 in ipairs(var0_53) do
		if arg0_53.tagType == IslandItem.TYPE_MATERIAL and iter1_53:IsMaterial() and arg0_53.indexDatas[IslandItem.TYPE_MATERIAL]:Match(iter1_53) then
			table.insert(arg1_53, iter1_53)
		elseif arg0_53.tagType == IslandItem.TYPE_PROP and iter1_53:IsProp() and arg0_53.indexDatas[IslandItem.TYPE_PROP]:Match(iter1_53) then
			table.insert(arg1_53, iter1_53)
		elseif arg0_53.tagType == IslandItem.TYPE_SPECIAL_PROP and iter1_53:IsSpecialProp() and arg0_53.indexDatas[IslandItem.TYPE_SPECIAL_PROP]:Match(iter1_53) then
			table.insert(arg1_53, iter1_53)
		end
	end

	if arg0_53.tagType == IslandItem.TYPE_SPECIAL_PROP then
		local var1_53 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetInviteList()

		for iter2_53, iter3_53 in ipairs(var1_53) do
			local var2_53 = IslandInvitation.New(iter3_53)

			if arg0_53.indexDatas[IslandItem.TYPE_SPECIAL_PROP]:Match(var2_53) then
				table.insert(arg1_53, var2_53)
			end
		end
	end
end

function var0_0.OnDestroy(arg0_54)
	ClearLScrollrect(arg0_54.scrollRect)

	for iter0_54, iter1_54 in pairs(arg0_54.cards) do
		iter1_54:Dispose()
	end

	arg0_54.cards = {}
end

return var0_0
