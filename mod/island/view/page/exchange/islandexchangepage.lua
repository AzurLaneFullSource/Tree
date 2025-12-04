local var0_0 = class("IslandExchangePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandExchangeUI"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_exchange_title"))
	setText(arg0_2._tf:Find("top/title/Text/en"), i18n("island_exchange_title_en"))

	local var0_2 = arg0_2._tf:Find("adapt/toggles/content")

	arg0_2.toggleUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	local var1_2 = arg0_2._tf:Find("adapt/left")

	setText(var1_2:Find("tip"), i18n("island_quickselect_tip"))

	arg0_2.allBtn = var1_2:Find("btn_all")
	arg0_2.allFlagTF = arg0_2.allBtn:Find("flag")

	setText(arg0_2.allBtn:Find("Text"), i18n("island_selectall"))

	arg0_2.deleteBtn = var1_2:Find("btn_delete")
	arg0_2.scrollRect = var1_2:Find("view"):GetComponent("LScrollRect")
	arg0_2.emptyTF = var1_2:Find("empty")

	local var2_2 = arg0_2._tf:Find("adapt/right")

	arg0_2.itemNameTxt = var2_2:Find("title/name"):GetComponent(typeof(Text))
	arg0_2.itemTF = var2_2:Find("bg_item/item")

	setText(var2_2:Find("bg_count/Text"), i18n("island_exchange_own_count"))

	arg0_2.itemOwnTxt = var2_2:Find("bg_count/content/Text"):GetComponent(typeof(Text))
	arg0_2.itemAddTxt = var2_2:Find("bg_count/content/add"):GetComponent(typeof(Text))
	arg0_2.exchangeBtn = var2_2:Find("btn_exchange")

	setText(arg0_2.exchangeBtn:Find("Text"), i18n("island_exchange_btn_text"))

	arg0_2.blockTF = arg0_2._tf:Find("block")
	arg0_2.itemAnim = var2_2:Find("bg_item"):GetComponent(typeof(Animation))
	arg0_2.itemAnimEvent = var2_2:Find("bg_item"):GetComponent(typeof(DftAniEvent))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("top/back"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.allBtn, function(arg0_5)
		if arg0_3.selAllFlag or #arg0_3.displays == 0 then
			return
		end

		arg0_3:SelecteAll()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.deleteBtn, function()
		arg0_3:SetTotalCount()

		arg0_3.itemAddTxt.text = ""
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.itemTF, function()
		arg0_3:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = arg0_3.showDropData
		})
	end)
	arg0_3.itemAnimEvent:SetTriggerEvent(function()
		arg0_3:SendExchangeProto()
	end)
	arg0_3.itemAnimEvent:SetEndEvent(function()
		setActive(arg0_3.blockTF, false)
		arg0_3.itemAnim:Play("anim_IslandExchangeUI_Craft_loop")
	end)
	onButton(arg0_3, arg0_3.exchangeBtn, function()
		if getProxy(IslandProxy):GetIsland():GetInventoryAgency():ExistAnyOverFlowItem() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_bag_max_tip"))

			return
		end

		arg0_3.exchangeItems = arg0_3:GetExchangeItems()

		if #arg0_3.exchangeItems <= 0 then
			return
		end

		arg0_3:ShowMsgBox({
			content = i18n("island_exchange_sure_tip"),
			onYes = function()
				arg0_3.itemAnim:Play("anim_IslandExchangeUI_Craft")
				setActive(arg0_3.blockTF, true)
			end
		})
	end, SFX_PANEL)
	arg0_3.toggleUIList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			arg0_3:UpdateToggleItem(arg1_12, arg2_12)
		end
	end)

	function arg0_3.scrollRect.onInitItem(arg0_13)
		arg0_3:OnInitItem(arg0_13)
	end

	function arg0_3.scrollRect.onUpdateItem(arg0_14, arg1_14)
		arg0_3:OnUpdateItem(arg0_14, arg1_14)
	end
end

function var0_0.SendExchangeProto(arg0_15)
	arg0_15:emit(IslandMediator.EXCHANGE_ITME, arg0_15.exchangeItems, arg0_15.showItemId, arg0_15.totalAddCnt)
end

function var0_0.OnShow(arg0_16, arg1_16)
	arg0_16.firstFlush = true
	arg0_16.cards = {}
	arg0_16.showIds = arg1_16 or pg.island_exchange_group.all

	arg0_16.toggleUIList:align(#arg0_16.showIds)
	triggerToggle(arg0_16.toggleUIList.container:GetChild(0):Find("title"), true)
	setActive(arg0_16.blockTF, false)
	arg0_16.itemAnim:Play("anim_IslandExchangeUI_Craft_loop")
	arg0_16:BlurPanel()
end

function var0_0.AddListeners(arg0_17)
	arg0_17:AddListener(GAME.ISLAND_EXCHANGE_ITEM_DONE, arg0_17.OnExchangeDone)
end

function var0_0.RemoveListeners(arg0_18)
	arg0_18:RemoveListener(GAME.ISLAND_EXCHANGE_ITEM_DONE, arg0_18.OnExchangeDone)
end

function var0_0.OnExchangeDone(arg0_19)
	arg0_19:FlushGroup()
end

function var0_0.UpdateToggleItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.showIds[arg1_20 + 1]
	local var1_20 = pg.island_exchange_group[var0_20]

	setText(arg2_20:Find("title/name"), var1_20.text[1])
	setText(arg2_20:Find("title/name/en"), var1_20.text[2])
	GetImageSpriteFromAtlasAsync("island/islandshopicon", var1_20.text[3], arg2_20:Find("title/sel/icon"))
	onToggle(arg0_20, arg2_20:Find("title"), function(arg0_21)
		if arg0_21 then
			triggerToggle(arg2_20:Find("list"):GetChild(0), true)
		end
	end, SFX_PANEL)

	local var2_20 = var1_20.exchange_group

	UIItemList.StaticAlign(arg2_20:Find("list"), arg2_20:Find("list/tpl"), #var2_20, function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = arg1_22 + 1
			local var1_22 = var2_20[var0_22][1]
			local var2_22 = var2_20[var0_22][2]

			setText(arg2_22:Find("name"), var1_22)
			setText(arg2_22:Find("sel/name"), var1_22)
			setActive(arg2_22:Find("line2"), var0_22 ~= #var2_20)
			onToggle(arg0_20, arg2_22, function(arg0_23)
				if arg0_23 then
					if not arg0_20.firstFlush and arg0_20.showGroupId and arg0_20.showGroupId == var2_22 then
						return
					end

					arg0_20.firstFlush = false
					arg0_20.showGroupId = var2_22

					arg0_20:FlushGroup()
				end
			end, SFX_PANEL)
		end
	end)
end

function var0_0.FlushGroup(arg0_24)
	arg0_24:SetTotalCount()

	local var0_24 = pg.island_item_data_template[arg0_24.showItemId]

	arg0_24.itemNameTxt.text = var0_24.name
	arg0_24.itemOwnTxt.text = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOwnCount(arg0_24.showItemId)
	arg0_24.itemAddTxt.text = ""
	arg0_24.showDropData = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = arg0_24.showItemId
	})

	updateIslandItem(arg0_24.itemTF, arg0_24.showDropData)
end

function var0_0.SetTotalCount(arg0_25)
	arg0_25.displays = arg0_25:CollectDisplayItems()
	arg0_25.values = {}

	for iter0_25, iter1_25 in ipairs(arg0_25.displays) do
		table.insert(arg0_25.values, 0)
	end

	arg0_25.scrollRect:SetTotalCount(#arg0_25.displays, -1)
	setActive(arg0_25.emptyTF, #arg0_25.displays == 0)

	arg0_25.selAllFlag = false

	setActive(arg0_25.allFlagTF, arg0_25.selAllFlag)
end

function var0_0.UpdateCount(arg0_26)
	arg0_26.totalAddCnt = 0

	for iter0_26, iter1_26 in ipairs(arg0_26.values) do
		local var0_26 = arg0_26.displays[iter0_26]

		arg0_26.totalAddCnt = arg0_26.totalAddCnt + var0_26.targetNum * iter1_26
	end

	arg0_26.itemAddTxt.text = arg0_26.totalAddCnt > 0 and "+" .. arg0_26.totalAddCnt or ""
end

function var0_0.OnInitItem(arg0_27, arg1_27)
	local var0_27 = IslandExchangeItemCard.New(arg1_27)

	onButton(arg0_27, var0_27._go, function()
		arg0_27:UpdateCardSel(var0_27, 1)
	end, SFX_PANEL)
	onButton(arg0_27, var0_27.reduceBtn, function()
		arg0_27:UpdateCardSel(var0_27, -1)
	end, SFX_PANEL)
	onInputEndEdit(arg0_27, var0_27.valueInput, function(arg0_30)
		local var0_30 = table.indexof(arg0_27.displays, var0_27.item)

		if not var0_30 then
			return
		end

		local var1_30 = 0

		if not arg0_30 or arg0_30 == "" or not tonumber(arg0_30) then
			local var2_30 = 1
		end

		local var3_30 = tonumber(arg0_30) - arg0_27.values[var0_30]

		arg0_27:UpdateCardSel(var0_27, var3_30)
	end)
	pressPersistTrigger(var0_27.calcPanel, 0.5, function()
		arg0_27:UpdateCardSel(var0_27, 1)
	end, nil, true, true, 0.1, SFX_PANEL)

	arg0_27.cards[arg1_27] = var0_27
end

function var0_0.OnUpdateItem(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32.cards[arg2_32]

	if not var0_32 then
		arg0_32:OnInitItem(arg2_32)

		var0_32 = arg0_32.cards[arg2_32]
	end

	if arg0_32.displays[arg1_32 + 1] then
		var0_32:Update(arg0_32.displays[arg1_32 + 1], arg0_32.values[arg1_32 + 1])
	end
end

function var0_0.UpdateCardSel(arg0_33, arg1_33, arg2_33)
	local var0_33 = table.indexof(arg0_33.displays, arg1_33.item)

	if not var0_33 then
		return
	end

	local var1_33 = arg0_33.values[var0_33] + arg2_33

	arg0_33.values[var0_33] = math.max(0, math.min(var1_33, arg1_33.item:GetCount()))

	arg1_33:UpdateValue(arg0_33.values[var0_33])
	arg0_33:UpdateCount()
	arg0_33:CheckSelAllFlag()
end

function var0_0._IsSelAll(arg0_34)
	for iter0_34, iter1_34 in ipairs(arg0_34.values) do
		if iter1_34 ~= arg0_34.displays[iter0_34]:GetCount() then
			return false
		end
	end

	return true
end

function var0_0.CheckSelAllFlag(arg0_35)
	arg0_35.selAllFlag = arg0_35:_IsSelAll()

	setActive(arg0_35.allFlagTF, arg0_35.selAllFlag)
end

function var0_0.SelecteAll(arg0_36)
	arg0_36.values = {}

	for iter0_36, iter1_36 in ipairs(arg0_36.displays) do
		arg0_36.values[iter0_36] = iter1_36:GetCount()
	end

	arg0_36.scrollRect:SetTotalCount(#arg0_36.displays, -1)
	arg0_36:UpdateCount()

	arg0_36.selAllFlag = true

	setActive(arg0_36.allFlagTF, arg0_36.selAllFlag)
end

function var0_0.CollectDisplayItems(arg0_37)
	local var0_37 = {}
	local var1_37 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	local var2_37 = pg.island_exchange_template

	arg0_37.showExchangeIds = var2_37.get_id_list_by_group[arg0_37.showGroupId]
	arg0_37.showItemId = var2_37[arg0_37.showExchangeIds[1]].target_item

	for iter0_37, iter1_37 in ipairs(arg0_37.showExchangeIds) do
		local var3_37 = var2_37[iter1_37].origin_item
		local var4_37 = var1_37:GetItemById(var3_37)

		if var4_37 then
			local var5_37 = Clone(var4_37)

			var5_37.exchangeId = iter1_37
			var5_37.targetNum = var2_37[iter1_37].target_num

			table.insert(var0_37, var5_37)
		end
	end

	return var0_37
end

function var0_0.GetExchangeItems(arg0_38)
	local var0_38 = {}

	for iter0_38, iter1_38 in ipairs(arg0_38.values) do
		local var1_38 = arg0_38.displays[iter0_38]

		if iter1_38 > 0 then
			table.insert(var0_38, {
				exchangeId = var1_38.exchangeId,
				itemId = var1_38.id,
				num = iter1_38
			})
		end
	end

	return var0_38
end

function var0_0.OnHide(arg0_39)
	arg0_39.itemAnim:Stop()
	arg0_39:UnBlurPanel()
end

function var0_0.OnDisable(arg0_40)
	arg0_40:OnHide()
end

function var0_0.OnDestroy(arg0_41)
	arg0_41:OnHide()
	ClearLScrollrect(arg0_41.scrollRect)

	for iter0_41, iter1_41 in pairs(arg0_41.cards) do
		iter1_41:Dispose()
	end

	arg0_41.cards = {}

	arg0_41.itemAnimEvent:SetTriggerEvent(nil)
	arg0_41.itemAnimEvent:SetEndEvent(nil)
end

return var0_0
