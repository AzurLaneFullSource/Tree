local var0_0 = class("IslandShopExchangePage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandShopExchangeUI"
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	var0_0.super.Ctor(arg0_2, arg1_2, arg2_2.event, arg2_2.contextData)

	arg0_2.viewComponent = arg2_2
end

function var0_0.OnLoaded(arg0_3)
	local var0_3 = arg0_3._tf:Find("adapt/left")

	setText(var0_3:Find("tip"), i18n("island_quickselect_tip"))

	arg0_3.allBtn = var0_3:Find("btn_all")
	arg0_3.allFlagTF = arg0_3.allBtn:Find("flag")

	setText(arg0_3.allBtn:Find("Text"), i18n("island_selectall"))

	arg0_3.deleteBtn = var0_3:Find("btn_delete")
	arg0_3.scrollRect = var0_3:Find("view"):GetComponent("LScrollRect")
	arg0_3.emptyTF = var0_3:Find("empty")

	local var1_3 = arg0_3._tf:Find("adapt/right")

	arg0_3.itemNameTxt = var1_3:Find("title/name"):GetComponent(typeof(Text))
	arg0_3.itemTF = var1_3:Find("bg_item/item")

	setText(var1_3:Find("bg_count/Text"), i18n("island_exchange_own_count"))

	arg0_3.itemOwnTxt = var1_3:Find("bg_count/content/Text"):GetComponent(typeof(Text))
	arg0_3.itemAddTxt = var1_3:Find("bg_count/content/add"):GetComponent(typeof(Text))
	arg0_3.exchangeBtn = var1_3:Find("btn_exchange")

	setText(arg0_3.exchangeBtn:Find("Text"), i18n("island_exchange_btn_text"))

	arg0_3.blockTF = arg0_3._tf:Find("block")
	arg0_3.itemAnim = var1_3:Find("bg_item"):GetComponent(typeof(Animation))
	arg0_3.itemAnimEvent = var1_3:Find("bg_item"):GetComponent(typeof(DftAniEvent))
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4.allBtn, function(arg0_5)
		if arg0_4.selAllFlag or #arg0_4.displays == 0 then
			return
		end

		arg0_4:SelecteAll()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.deleteBtn, function()
		arg0_4:SetTotalCount()

		arg0_4.itemAddTxt.text = ""
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.itemTF, function()
		arg0_4.viewComponent:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = arg0_4.showDropData
		})
	end)
	arg0_4.itemAnimEvent:SetTriggerEvent(function()
		arg0_4:SendExchangeProto()
	end)
	arg0_4.itemAnimEvent:SetEndEvent(function()
		setActive(arg0_4.blockTF, false)
		arg0_4.itemAnim:Play("anim_IslandExchangeUI_Craft_loop")
	end)
	onButton(arg0_4, arg0_4.exchangeBtn, function()
		if getProxy(IslandProxy):GetIsland():GetInventoryAgency():ExistAnyOverFlowItem() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_bag_max_tip"))

			return
		end

		arg0_4.exchangeItems = arg0_4:GetExchangeItems()

		if #arg0_4.exchangeItems <= 0 then
			return
		end

		arg0_4.viewComponent:ShowMsgBox({
			content = i18n("island_exchange_sure_tip"),
			onYes = function()
				arg0_4.itemAnim:Play("anim_IslandExchangeUI_Craft")
				setActive(arg0_4.blockTF, true)
			end
		})
	end, SFX_PANEL)

	function arg0_4.scrollRect.onInitItem(arg0_12)
		arg0_4:OnInitItem(arg0_12)
	end

	function arg0_4.scrollRect.onUpdateItem(arg0_13, arg1_13)
		arg0_4:OnUpdateItem(arg0_13, arg1_13)
	end

	arg0_4.cards = {}
end

function var0_0.SendExchangeProto(arg0_14)
	arg0_14:emit(IslandMediator.EXCHANGE_ITME, arg0_14.exchangeItems, arg0_14.showItemId, arg0_14.totalAddCnt)
end

function var0_0.Show(arg0_15)
	var0_0.super.Show(arg0_15)

	arg0_15.groupConfig = pg.island_exchange_group

	setActive(arg0_15.blockTF, false)
	arg0_15.itemAnim:Play("anim_IslandExchangeUI_Craft_loop")
	arg0_15:OverlayPanel(arg0_15._tf, {
		pbList = {
			arg0_15._tf:Find("bg")
		}
	})
end

function var0_0.FlushGroup(arg0_16, arg1_16)
	arg0_16.showGroupId = arg1_16 or arg0_16.showGroupId or arg0_16.groupConfig[arg0_16.groupConfig.all[1]].exchange_group[1][2]

	if arg0_16:isShowing() then
		arg0_16:SetTotalCount()
	end

	local var0_16 = pg.island_item_data_template[arg0_16.showItemId]

	arg0_16.itemNameTxt.text = var0_16.name
	arg0_16.itemOwnTxt.text = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOwnCount(arg0_16.showItemId)
	arg0_16.itemAddTxt.text = ""
	arg0_16.showDropData = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = arg0_16.showItemId
	})

	updateIslandItem(arg0_16.itemTF, arg0_16.showDropData)
end

function var0_0.SetTotalCount(arg0_17)
	arg0_17.displays = arg0_17:CollectDisplayItems()
	arg0_17.values = {}

	for iter0_17, iter1_17 in ipairs(arg0_17.displays) do
		table.insert(arg0_17.values, 0)
	end

	arg0_17.scrollRect:SetTotalCount(#arg0_17.displays, -1)
	setActive(arg0_17.emptyTF, #arg0_17.displays == 0)

	arg0_17.selAllFlag = false

	setActive(arg0_17.allFlagTF, arg0_17.selAllFlag)
end

function var0_0.UpdateCount(arg0_18)
	arg0_18.totalAddCnt = 0

	for iter0_18, iter1_18 in ipairs(arg0_18.values) do
		local var0_18 = arg0_18.displays[iter0_18]

		arg0_18.totalAddCnt = arg0_18.totalAddCnt + var0_18.targetNum * iter1_18
	end

	arg0_18.itemAddTxt.text = arg0_18.totalAddCnt > 0 and "+" .. arg0_18.totalAddCnt or ""
end

function var0_0.OnInitItem(arg0_19, arg1_19)
	local var0_19 = IslandExchangeItemCard.New(arg1_19)

	onButton(arg0_19, var0_19._go, function()
		arg0_19:UpdateCardSel(var0_19, 1)
	end, SFX_PANEL)
	onButton(arg0_19, var0_19.reduceBtn, function()
		arg0_19:UpdateCardSel(var0_19, -1)
	end, SFX_PANEL)
	onInputEndEdit(arg0_19, var0_19.valueInput, function(arg0_22)
		local var0_22 = table.indexof(arg0_19.displays, var0_19.item)

		if not var0_22 then
			return
		end

		local var1_22 = 0

		if not arg0_22 or arg0_22 == "" or not tonumber(arg0_22) then
			local var2_22 = 1
		end

		local var3_22 = tonumber(arg0_22) - arg0_19.values[var0_22]

		arg0_19:UpdateCardSel(var0_19, var3_22)
	end)
	pressPersistTrigger(var0_19.calcPanel, 0.5, function()
		arg0_19:UpdateCardSel(var0_19, 1)
	end, nil, true, true, 0.1, SFX_PANEL)

	arg0_19.cards[arg1_19] = var0_19
end

function var0_0.OnUpdateItem(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.cards[arg2_24]

	if not var0_24 then
		arg0_24:OnInitItem(arg2_24)

		var0_24 = arg0_24.cards[arg2_24]
	end

	if arg0_24.displays[arg1_24 + 1] then
		var0_24:Update(arg0_24.displays[arg1_24 + 1], arg0_24.values[arg1_24 + 1])
	end
end

function var0_0.UpdateCardSel(arg0_25, arg1_25, arg2_25)
	local var0_25 = table.indexof(arg0_25.displays, arg1_25.item)

	if not var0_25 then
		return
	end

	local var1_25 = arg0_25.values[var0_25] + arg2_25

	arg0_25.values[var0_25] = math.max(0, math.min(var1_25, arg1_25.item:GetCount()))

	arg1_25:UpdateValue(arg0_25.values[var0_25])
	arg0_25:UpdateCount()
	arg0_25:CheckSelAllFlag()
end

function var0_0._IsSelAll(arg0_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.values) do
		if iter1_26 ~= arg0_26.displays[iter0_26]:GetCount() then
			return false
		end
	end

	return true
end

function var0_0.CheckSelAllFlag(arg0_27)
	arg0_27.selAllFlag = arg0_27:_IsSelAll()

	setActive(arg0_27.allFlagTF, arg0_27.selAllFlag)
end

function var0_0.SelecteAll(arg0_28)
	arg0_28.values = {}

	for iter0_28, iter1_28 in ipairs(arg0_28.displays) do
		arg0_28.values[iter0_28] = iter1_28:GetCount()
	end

	arg0_28.scrollRect:SetTotalCount(#arg0_28.displays, -1)
	arg0_28:UpdateCount()

	arg0_28.selAllFlag = true

	setActive(arg0_28.allFlagTF, arg0_28.selAllFlag)
end

function var0_0.CollectDisplayItems(arg0_29)
	local var0_29 = {}
	local var1_29 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var2_29 = pg.island_exchange_template

	arg0_29.showExchangeIds = var2_29.get_id_list_by_group[arg0_29.showGroupId]
	arg0_29.showItemId = var2_29[arg0_29.showExchangeIds[1]].target_item

	for iter0_29, iter1_29 in ipairs(arg0_29.showExchangeIds) do
		local var3_29 = var2_29[iter1_29].origin_item
		local var4_29 = var1_29:GetItemById(var3_29)

		if var4_29 then
			local var5_29 = Clone(var4_29)

			var5_29.exchangeId = iter1_29
			var5_29.targetNum = var2_29[iter1_29].target_num

			table.insert(var0_29, var5_29)
		end
	end

	return var0_29
end

function var0_0.GetExchangeItems(arg0_30)
	local var0_30 = {}

	for iter0_30, iter1_30 in ipairs(arg0_30.values) do
		local var1_30 = arg0_30.displays[iter0_30]

		if iter1_30 > 0 then
			table.insert(var0_30, {
				exchangeId = var1_30.exchangeId,
				itemId = var1_30.id,
				num = iter1_30
			})
		end
	end

	return var0_30
end

function var0_0.OnHide(arg0_31)
	arg0_31.itemAnim:Stop()
	setActive(arg0_31.blockTF, false)
	arg0_31:UnOverlayPanel(arg0_31._tf, arg0_31._parentTf)
end

function var0_0.OnDestroy(arg0_32)
	arg0_32:OnHide()
	ClearLScrollrect(arg0_32.scrollRect)

	for iter0_32, iter1_32 in pairs(arg0_32.cards) do
		iter1_32:Dispose()
	end

	arg0_32.cards = {}

	arg0_32.itemAnimEvent:SetTriggerEvent(nil)
	arg0_32.itemAnimEvent:SetEndEvent(nil)
end

return var0_0
