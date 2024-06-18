local var0_0 = class("BackYardFurniturePage", import(".BackYardShopBasePage"))
local var1_0 = Furniture.INDEX_TO_SHOP_TYPE

table.insert(var1_0, 1, {})

local function var2_0(arg0_1)
	return var1_0[arg0_1]
end

function var0_0.getUIName(arg0_2)
	return "BackYardFurniturePage"
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.scrollRect = arg0_3:findTF("adpter/frame/bg"):GetComponent("LScrollRect")
	arg0_3.searchInput = arg0_3:findTF("adpter/search")
	arg0_3.searchClear = arg0_3:findTF("adpter/search/clear")
	arg0_3.filterBtn = arg0_3:findTF("adpter/filter")
	arg0_3.filterBtnTxt = arg0_3.filterBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_3.filterBtnTxt.text = i18n("word_default")
	arg0_3.orderBtn = arg0_3:findTF("adpter/order")
	arg0_3.orderBtnIcon = arg0_3.orderBtn:Find("icon")
	arg0_3.orderBtnTxt = arg0_3.orderBtn:Find("Text"):GetComponent(typeof(Text))

	setText(arg0_3.searchInput:Find("Placeholder"), i18n("courtyard_label_search_holder"))
end

function var0_0.OnInit(arg0_4)
	arg0_4.cards = {}

	function arg0_4.scrollRect.onInitItem(arg0_5)
		arg0_4:OnInitItem(arg0_5)
	end

	function arg0_4.scrollRect.onUpdateItem(arg0_6, arg1_6)
		arg0_4:OnUpdateItem(arg0_6, arg1_6)
	end

	onInputChanged(arg0_4, arg0_4.searchInput, function()
		local var0_7 = getInputText(arg0_4.searchInput)

		setActive(arg0_4.searchClear, var0_7 ~= "")
		arg0_4:OnSearchKeyChange()
	end)
	onButton(arg0_4, arg0_4.searchClear, function()
		setInputText(arg0_4.searchInput, "")
	end, SFX_PANEL)

	arg0_4.orderMode = BackYardDecorationFilterPanel.ORDER_MODE_DASC
	arg0_4.orderBtnIcon.localScale = Vector3(1, -1, 1)

	local function var0_4(arg0_9)
		local var0_9 = ""

		if arg0_9 == BackYardDecorationFilterPanel.ORDER_MODE_ASC then
			var0_9 = i18n("word_asc")
		elseif arg0_9 == BackYardDecorationFilterPanel.ORDER_MODE_DASC then
			var0_9 = i18n("word_desc")
		end

		arg0_4.orderBtnTxt.text = var0_9
	end

	onToggle(arg0_4, arg0_4.orderBtn, function(arg0_10)
		arg0_4.orderMode = arg0_10 and BackYardDecorationFilterPanel.ORDER_MODE_ASC or BackYardDecorationFilterPanel.ORDER_MODE_DASC

		var0_4(arg0_4.orderMode)
		arg0_4:UpdateFliterData()
		arg0_4.contextData.filterPanel:Sort()
		arg0_4:OnFilterDone()

		arg0_4.orderBtnIcon.localScale = Vector3(1, arg0_10 and 1 or -1, 1)
	end, SFX_PANEL)
	var0_4(arg0_4.orderMode)

	function arg0_4.contextData.filterPanel.confirmFunc()
		local var0_11 = arg0_4.contextData.filterPanel.sortTxt

		arg0_4.filterBtnTxt.text = var0_11

		arg0_4:OnFilterDone()
	end

	onButton(arg0_4, arg0_4.filterBtn, function()
		arg0_4.contextData.filterPanel:setFilterData(arg0_4:GetData())
		arg0_4.contextData.filterPanel:ExecuteAction("Show")
	end, SFX_PANEL)
	arg0_4:UpdateFliterData()
end

function var0_0.UpdateFliterData(arg0_13)
	arg0_13.contextData.filterPanel:updateOrderMode(arg0_13.orderMode)
end

function var0_0.OnFilterDone(arg0_14)
	arg0_14.displays = arg0_14.contextData.filterPanel:GetFilterData()

	arg0_14.scrollRect:SetTotalCount(#arg0_14.displays)
end

function var0_0.OnDisplayUpdated(arg0_15, arg1_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.displays) do
		if iter1_15.id == arg1_15.id then
			arg0_15.displays[iter0_15] = arg1_15

			break
		end
	end
end

function var0_0.OnCardUpdated(arg0_16, arg1_16)
	for iter0_16, iter1_16 in pairs(arg0_16.cards) do
		if iter1_16.furniture.id == arg1_16.id then
			iter1_16:Update(arg1_16)

			break
		end
	end
end

function var0_0.OnDormUpdated(arg0_17)
	arg0_17:UpdateFliterData()
end

function var0_0.OnSetUp(arg0_18)
	arg0_18:InitFurnitureList()
end

function var0_0.OnSearchKeyChange(arg0_19)
	arg0_19:InitFurnitureList()
end

function var0_0.InitFurnitureList(arg0_20)
	local var0_20 = arg0_20:GetData()

	arg0_20.contextData.filterPanel:setFilterData(var0_20)
	arg0_20.contextData.filterPanel:filter()
	arg0_20:OnFilterDone()
end

function var0_0.GetData(arg0_21)
	local var0_21 = {}
	local var1_21 = arg0_21.dorm:GetPurchasedFurnitures()

	local function var2_21(arg0_22)
		local var0_22 = var1_21[arg0_22.id]

		return pg.furniture_shop_template[arg0_22.id] and not arg0_22:isNotForSale() and (not arg0_22:isForActivity() or not not var0_22) and not not arg0_22:inTime()
	end

	local function var3_21(arg0_23)
		local var0_23 = getInputText(arg0_21.searchInput)

		if not var0_23 or var0_23 == "" then
			return true
		else
			return arg0_23:isMatchSearchKey(var0_23)
		end
	end

	local function var4_21(arg0_24)
		local var0_24 = var1_21[arg0_24] or Furniture.New({
			id = arg0_24
		})

		if var2_21(var0_24) and var3_21(var0_24) then
			table.insert(var0_21, var0_24)
		end
	end

	if arg0_21.pageType == 5 then
		for iter0_21, iter1_21 in ipairs(pg.furniture_data_template.get_id_list_by_tag[7]) do
			var4_21(iter1_21)
		end
	else
		local var5_21 = var2_0(arg0_21.pageType)
		local var6_21 = pg.furniture_data_template.get_id_list_by_type

		for iter2_21, iter3_21 in ipairs(var5_21) do
			for iter4_21, iter5_21 in ipairs(var6_21[iter3_21] or {}) do
				var4_21(iter5_21)
			end
		end
	end

	return var0_21
end

function var0_0.OnInitItem(arg0_25, arg1_25)
	local var0_25 = BackYardFurnitureCard.New(arg1_25)

	onButton(arg0_25, var0_25._go, function()
		if var0_25.furniture:canPurchase() then
			arg0_25.contextData.furnitureMsgBox:ExecuteAction("SetUp", var0_25.furniture, arg0_25.dorm, arg0_25.player)
		end
	end, SFX_PANEL)

	arg0_25.cards[arg1_25] = var0_25
end

function var0_0.OnUpdateItem(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg0_27.cards[arg2_27]

	if not var0_27 then
		arg0_27:OnInitItem(arg2_27)

		var0_27 = arg0_27.cards[arg2_27]
	end

	local var1_27 = arg0_27.displays[arg1_27 + 1]

	var0_27:Update(var1_27)
end

function var0_0.OnDestroy(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28.cards) do
		iter1_28:Clear()
	end
end

return var0_0
