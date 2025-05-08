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
	arg0_2.oneKeyPanel = arg0_2:findTF("window/one_key_panel")
	arg0_2.onekeyBtn = arg0_2:findTF("window/one_key_panel/fetch_btn")
	arg0_2.scrollRect = arg0_2:findTF("window/item_scrollview"):GetComponent("LScrollRect")

	setText(arg0_2:findTF("window/title/Text"), i18n1("仓库"))
	setText(arg0_2:findTF("window/batch_sell/Text"), i18n1("批量出售"))
	setText(arg0_2:findTF("window/sell_panel/price/label"), i18n1("合计价格:"))
	setText(arg0_2:findTF("window/sell_panel/cancel/Text"), i18n1("取消"))
	setText(arg0_2:findTF("window/sell_panel/batch_sell_1/Text"), i18n1("批量出售"))
	setText(arg0_2:findTF("window/one_key_panel/fetch_btn/Text"), i18n1("一键领取"))
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
		arg0_3:UdpateStyle()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.sellCancelBtn, function()
		arg0_3.mode = var0_0.MODE_VIEW

		arg0_3:SetTotalCount()
		arg0_3:UdpateStyle()

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
			content = i18n1("确定出售道具？"),
			onYes = function()
				if arg0_3.tagType == var0_0.INVENTORY_TYPE_OVERFLOW then
					arg0_3:emit(IslandMediator.ON_BATCH_SELL_ITEM_4_OVERFLOW, var0_9)
				else
					arg0_3:emit(IslandMediator.ON_BATCH_SELL_ITEM, var0_9)
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

function var0_0.UdpateStyle(arg0_14)
	setActive(arg0_14.sellPanel, arg0_14.mode == var0_0.MODE_EDIT)
	setActive(arg0_14.sortPaenl, arg0_14.mode == var0_0.MODE_VIEW and arg0_14.tagType ~= var0_0.INVENTORY_TYPE_OVERFLOW)
	setActive(arg0_14.oneKeyPanel, arg0_14.tagType == var0_0.INVENTORY_TYPE_OVERFLOW and arg0_14.mode ~= var0_0.MODE_EDIT)
	setActive(arg0_14.batchSellBtn, arg0_14.mode == var0_0.MODE_VIEW)
end

function var0_0.AddListeners(arg0_15)
	arg0_15:AddListener(IslandScene.ON_INVENTORY_FILTER, arg0_15.OnInventoryFilter)
	arg0_15:AddListener(GAME.ISLAND_UPGRADE_INVENTORY_DONE, arg0_15.OnUpgrade)
	arg0_15:AddListener(GAME.ISLAND_SELL_ITEM_DONE, arg0_15.OnSell)
	arg0_15:AddListener(GAME.ISLAND_GET_OVERFLOW_ITEM_DOME, arg0_15.OnSell)
end

function var0_0.RemoveListeners(arg0_16)
	arg0_16:RemoveListener(IslandScene.ON_INVENTORY_FILTER, arg0_16.OnInventoryFilter)
	arg0_16:RemoveListener(GAME.ISLAND_UPGRADE_INVENTORY_DONE, arg0_16.OnUpgrade)
	arg0_16:RemoveListener(GAME.ISLAND_SELL_ITEM_DONE, arg0_16.OnSell)
	arg0_16:RemoveListener(GAME.ISLAND_GET_OVERFLOW_ITEM_DOME, arg0_16.OnSell)
end

function var0_0.GetIndexData(arg0_17, arg1_17)
	assert(arg0_17.indexDatas[arg1_17])

	return arg0_17.indexDatas[arg1_17]
end

function var0_0.UpdateIndexData(arg0_18, arg1_18, arg2_18)
	assert(arg0_18.indexDatas[arg1_18])
	arg0_18.indexDatas[arg1_18]:SetData(arg2_18)
end

function var0_0.OnInventoryFilter(arg0_19, arg1_19)
	arg0_19:UpdateIndexData(arg0_19.tagType, arg1_19)
	arg0_19:FlushSortBtn()
	arg0_19:SetTotalCount()
end

function var0_0.OnUpgrade(arg0_20)
	arg0_20:SetTotalCount()
	arg0_20:FlushCapacity()
	arg0_20:ClosePage(IslandInventoryUpgradePage)
end

function var0_0.OnSell(arg0_21)
	arg0_21:SetTotalCount()
	arg0_21:FlushCapacity()
	arg0_21:ClosePage(IslandInventoryItemInfoPage)
end

function var0_0.SetUp(arg0_22)
	arg0_22.tagType = IslandItem.TYPE_MATERIAL
	arg0_22.mode = var0_0.MODE_VIEW
	arg0_22.asc = true
	arg0_22.cards = {}

	arg0_22:FlushTags()
	arg0_22:FlushFilterBtn()
	arg0_22:FlushSortBtn()
	arg0_22:FlushList()
	arg0_22:FlushCapacity()
	arg0_22:UdpateStyle()
end

function var0_0.FlushCapacity(arg0_23)
	if arg0_23.tagType == IslandItem.TYPE_MATERIAL then
		setActive(arg0_23.upgradeBtn, true)
		setActive(arg0_23.batchSellBtn, true)

		local var0_23 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
		local var1_23 = var0_23:GetLength()
		local var2_23 = var0_23:GetCapacity()

		arg0_23.capacityTxt.text = var1_23 .. "/" .. var2_23

		setButtonEnabled(arg0_23.upgradeBtn, not var0_23:IsMaxLevel())

		local var3_23 = var1_23 / var2_23

		setFillAmount(arg0_23.upgradeProg, var3_23)

		local var4_23 = var3_23 > 0.85 and Color.New(0.952941176470588, 0.423529411764706, 0.431372549019608, 1) or Color.New(0.223529411764706, 0.745098039215686, 1, 1)

		arg0_23.upgradeProg:GetComponent(typeof(Image)).color = var4_23
	elseif arg0_23.tagType == var0_0.INVENTORY_TYPE_OVERFLOW then
		setActive(arg0_23.upgradeBtn, false)
		setActive(arg0_23.batchSellBtn, true)
	else
		setActive(arg0_23.upgradeBtn, false)
		setActive(arg0_23.batchSellBtn, false)
	end
end

function var0_0.FlushTags(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.toggles) do
		onToggle(arg0_24, iter1_24, function(arg0_25)
			if arg0_25 then
				arg0_24:CheckEditMode(iter0_24)

				arg0_24.tagType = iter0_24

				arg0_24:FlushCapacity()
				arg0_24:FlushSortBtn()
				arg0_24:SetTotalCount()
				arg0_24:UdpateStyle()
			end
		end, SFX_PANEL)

		if iter0_24 == var0_0.INVENTORY_TYPE_OVERFLOW then
			setText(iter1_24:Find("Text"), i18n1("临时背包"))
		else
			setText(iter1_24:Find("Text"), IslandItemKind.Type2TagName(iter0_24))
		end
	end

	arg0_24:ActiveDefaultTag()
end

function var0_0.ActiveDefaultTag(arg0_26)
	local var0_26 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():ExistAnyOverFlowItem()

	setActive(arg0_26.toggles[var0_0.INVENTORY_TYPE_OVERFLOW], var0_26)

	if var0_26 then
		triggerToggle(arg0_26.toggles[var0_0.INVENTORY_TYPE_OVERFLOW], true)
	else
		triggerToggle(arg0_26.toggles[IslandItem.TYPE_MATERIAL], true)
	end
end

function var0_0.CheckEditMode(arg0_27, arg1_27)
	if arg0_27.tagType ~= arg1_27 and arg0_27.mode == var0_0.MODE_EDIT then
		triggerButton(arg0_27.sellCancelBtn)
	end
end

function var0_0.FlushFilterBtn(arg0_28)
	onButton(arg0_28, arg0_28.filterBtn, function()
		local var0_29 = arg0_28:GetIndexData(arg0_28.tagType)

		arg0_28:OpenPage(IslandInventoryIndexPage, var0_29)
	end, SFX_PANEL)
end

function var0_0.FlushSortBtn(arg0_30)
	local function var0_30()
		local var0_31 = arg0_30:GetIndexData(arg0_30.tagType)

		arg0_30.orderTxt.text = var0_31:GetSortText()
		arg0_30.orderArr.localScale = arg0_30.asc and Vector2(1, -1, 1) or Vector2(1, 1, 1)
	end

	onButton(arg0_30, arg0_30.orderBtn, function()
		arg0_30.asc = not arg0_30.asc

		var0_30()
		arg0_30:SetTotalCount()
	end, SFX_PANEL)
	var0_30()
end

function var0_0.FlushList(arg0_33)
	function arg0_33.scrollRect.onInitItem(arg0_34)
		arg0_33:OnInitItem(arg0_34)
	end

	function arg0_33.scrollRect.onUpdateItem(arg0_35, arg1_35)
		arg0_33:OnUpdateItem(arg0_35, arg1_35)
	end

	arg0_33:SetTotalCount()
end

function var0_0.SetTotalCount(arg0_36)
	arg0_36.displays = arg0_36:Filter()
	arg0_36.values = {}

	for iter0_36, iter1_36 in ipairs(arg0_36.displays) do
		table.insert(arg0_36.values, 0)
	end

	local var0_36 = arg0_36:GetIndexData(arg0_36.tagType)

	table.sort(arg0_36.displays, function(arg0_37, arg1_37)
		return var0_36:Sort(arg0_37, arg1_37, arg0_36.asc)
	end)
	arg0_36.scrollRect:SetTotalCount(#arg0_36.displays, -1)
end

function var0_0.OnInitItem(arg0_38, arg1_38)
	local var0_38 = IslandItemCard.New(arg1_38)

	onButton(arg0_38, var0_38._go, function()
		if arg0_38.mode == var0_0.MODE_VIEW then
			if arg0_38.tagType ~= var0_0.INVENTORY_TYPE_OVERFLOW then
				arg0_38:OnClickItem(var0_38)
			end
		elseif arg0_38.mode == var0_0.MODE_EDIT then
			arg0_38:OnClickItemForSell(var0_38)
		end
	end, SFX_PANEL)
	onButton(arg0_38, var0_38.calcPanel, function()
		if arg0_38.mode == var0_0.MODE_EDIT then
			arg0_38:UpdateSellPrice(var0_38, -1)
		end
	end, SFX_PANEL)
	onInputEndEdit(arg0_38, var0_38.valueInput, function(arg0_41)
		local var0_41 = table.indexof(arg0_38.displays, var0_38.item)

		if not var0_41 then
			return
		end

		local var1_41 = 0

		if not arg0_41 or arg0_41 == "" or not tonumber(arg0_41) then
			local var2_41 = 1
		end

		local var3_41 = tonumber(arg0_41) - arg0_38.values[var0_41]

		arg0_38:UpdateSellPrice(var0_38, var3_41)
	end)

	arg0_38.cards[arg1_38] = var0_38
end

function var0_0.OnClickItem(arg0_42, arg1_42)
	if arg1_42.item:IsInvitationLetter() then
		local var0_42 = arg1_42.item:GetName()
		local var1_42 = IslandItem.StaticGetUsageArg(arg1_42.item.id)
		local var2_42 = pg.island_ship[tonumber(var1_42)].name

		arg0_42:ShowMsgBox({
			content = i18n1("消耗" .. var0_42 .. "X1，邀请" .. var2_42 .. "\n加入队伍,是否确定？"),
			onYes = function()
				arg0_42:emit(IslandMediator.ON_USE_ITEM, arg1_42.item.id, 1)
			end
		})
	else
		arg0_42:ShowMsgBox({
			type = IslandMsgBox.TYPE_COMMON_ITEM,
			itemId = arg1_42.item.id
		})
	end
end

function var0_0.OnClickItemForSell(arg0_44, arg1_44)
	arg0_44:UpdateSellPrice(arg1_44, 1)
end

function var0_0.UpdateSellPrice(arg0_45, arg1_45, arg2_45)
	local var0_45 = table.indexof(arg0_45.displays, arg1_45.item)

	if not var0_45 then
		return
	end

	local var1_45 = arg0_45.values[var0_45] + arg2_45

	arg0_45.values[var0_45] = math.max(0, math.min(var1_45, arg1_45.item:GetCount()))

	arg1_45:UpdateValue(arg0_45.values[var0_45])

	local var2_45 = 0

	for iter0_45, iter1_45 in ipairs(arg0_45.values) do
		var2_45 = arg0_45.displays[iter0_45]:GetSellingPrice().count * iter1_45 + var2_45
	end

	arg0_45.sellPriceTxt.text = "x" .. var2_45
end

function var0_0.OnUpdateItem(arg0_46, arg1_46, arg2_46)
	local var0_46 = arg0_46.cards[arg2_46]

	if not var0_46 then
		arg0_46:OnInitItem(arg2_46)

		var0_46 = arg0_46.cards[arg2_46]
	end

	if arg0_46.displays[arg1_46 + 1] then
		var0_46:Update(arg0_46.displays[arg1_46 + 1], arg0_46.mode, arg0_46.values[arg1_46 + 1], arg0_46.tagType)
	end
end

function var0_0.Filter(arg0_47)
	local var0_47 = {}

	if arg0_47.tagType == var0_0.INVENTORY_TYPE_OVERFLOW then
		arg0_47:CollectOverFlowInventoryItems(var0_47)
	else
		arg0_47:CollectCommonInventoryItems(var0_47)
	end

	return var0_47
end

function var0_0.CollectOverFlowInventoryItems(arg0_48, arg1_48)
	local var0_48 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOverflowItemList()

	for iter0_48, iter1_48 in pairs(var0_48) do
		table.insert(arg1_48, iter1_48)
	end
end

function var0_0.CollectCommonInventoryItems(arg0_49, arg1_49)
	local var0_49 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetGroupedItemList()

	for iter0_49, iter1_49 in ipairs(var0_49) do
		if arg0_49.tagType == IslandItem.TYPE_MATERIAL and iter1_49:IsMaterial() and arg0_49.indexDatas[IslandItem.TYPE_MATERIAL]:Match(iter1_49) then
			table.insert(arg1_49, iter1_49)
		elseif arg0_49.tagType == IslandItem.TYPE_PROP and iter1_49:IsProp() and arg0_49.indexDatas[IslandItem.TYPE_PROP]:Match(iter1_49) then
			table.insert(arg1_49, iter1_49)
		elseif arg0_49.tagType == IslandItem.TYPE_SPECIAL_PROP and iter1_49:IsSpecialProp() and arg0_49.indexDatas[IslandItem.TYPE_SPECIAL_PROP]:Match(iter1_49) then
			table.insert(arg1_49, iter1_49)
		end
	end
end

function var0_0.OnDestroy(arg0_50)
	for iter0_50, iter1_50 in pairs(arg0_50.cards) do
		iter1_50:Dispose()
	end

	arg0_50.cards = {}
end

return var0_0
