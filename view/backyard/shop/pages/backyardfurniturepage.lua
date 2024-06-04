local var0 = class("BackYardFurniturePage", import(".BackYardShopBasePage"))
local var1 = Furniture.INDEX_TO_SHOP_TYPE

table.insert(var1, 1, {})

local function var2(arg0)
	return var1[arg0]
end

function var0.getUIName(arg0)
	return "BackYardFurniturePage"
end

function var0.OnLoaded(arg0)
	arg0.scrollRect = arg0:findTF("adpter/frame/bg"):GetComponent("LScrollRect")
	arg0.searchInput = arg0:findTF("adpter/search")
	arg0.searchClear = arg0:findTF("adpter/search/clear")
	arg0.filterBtn = arg0:findTF("adpter/filter")
	arg0.filterBtnTxt = arg0.filterBtn:Find("Text"):GetComponent(typeof(Text))
	arg0.filterBtnTxt.text = i18n("word_default")
	arg0.orderBtn = arg0:findTF("adpter/order")
	arg0.orderBtnIcon = arg0.orderBtn:Find("icon")
	arg0.orderBtnTxt = arg0.orderBtn:Find("Text"):GetComponent(typeof(Text))

	setText(arg0.searchInput:Find("Placeholder"), i18n("courtyard_label_search_holder"))
end

function var0.OnInit(arg0)
	arg0.cards = {}

	function arg0.scrollRect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	onInputChanged(arg0, arg0.searchInput, function()
		local var0 = getInputText(arg0.searchInput)

		setActive(arg0.searchClear, var0 ~= "")
		arg0:OnSearchKeyChange()
	end)
	onButton(arg0, arg0.searchClear, function()
		setInputText(arg0.searchInput, "")
	end, SFX_PANEL)

	arg0.orderMode = BackYardDecorationFilterPanel.ORDER_MODE_DASC
	arg0.orderBtnIcon.localScale = Vector3(1, -1, 1)

	local function var0(arg0)
		local var0 = ""

		if arg0 == BackYardDecorationFilterPanel.ORDER_MODE_ASC then
			var0 = i18n("word_asc")
		elseif arg0 == BackYardDecorationFilterPanel.ORDER_MODE_DASC then
			var0 = i18n("word_desc")
		end

		arg0.orderBtnTxt.text = var0
	end

	onToggle(arg0, arg0.orderBtn, function(arg0)
		arg0.orderMode = arg0 and BackYardDecorationFilterPanel.ORDER_MODE_ASC or BackYardDecorationFilterPanel.ORDER_MODE_DASC

		var0(arg0.orderMode)
		arg0:UpdateFliterData()
		arg0.contextData.filterPanel:Sort()
		arg0:OnFilterDone()

		arg0.orderBtnIcon.localScale = Vector3(1, arg0 and 1 or -1, 1)
	end, SFX_PANEL)
	var0(arg0.orderMode)

	function arg0.contextData.filterPanel.confirmFunc()
		local var0 = arg0.contextData.filterPanel.sortTxt

		arg0.filterBtnTxt.text = var0

		arg0:OnFilterDone()
	end

	onButton(arg0, arg0.filterBtn, function()
		arg0.contextData.filterPanel:setFilterData(arg0:GetData())
		arg0.contextData.filterPanel:ExecuteAction("Show")
	end, SFX_PANEL)
	arg0:UpdateFliterData()
end

function var0.UpdateFliterData(arg0)
	arg0.contextData.filterPanel:updateOrderMode(arg0.orderMode)
end

function var0.OnFilterDone(arg0)
	arg0.displays = arg0.contextData.filterPanel:GetFilterData()

	arg0.scrollRect:SetTotalCount(#arg0.displays)
end

function var0.OnDisplayUpdated(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.displays) do
		if iter1.id == arg1.id then
			arg0.displays[iter0] = arg1

			break
		end
	end
end

function var0.OnCardUpdated(arg0, arg1)
	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.furniture.id == arg1.id then
			iter1:Update(arg1)

			break
		end
	end
end

function var0.OnDormUpdated(arg0)
	arg0:UpdateFliterData()
end

function var0.OnSetUp(arg0)
	arg0:InitFurnitureList()
end

function var0.OnSearchKeyChange(arg0)
	arg0:InitFurnitureList()
end

function var0.InitFurnitureList(arg0)
	local var0 = arg0:GetData()

	arg0.contextData.filterPanel:setFilterData(var0)
	arg0.contextData.filterPanel:filter()
	arg0:OnFilterDone()
end

function var0.GetData(arg0)
	local var0 = {}
	local var1 = arg0.dorm:GetPurchasedFurnitures()

	local function var2(arg0)
		local var0 = var1[arg0.id]

		return pg.furniture_shop_template[arg0.id] and not arg0:isNotForSale() and (not arg0:isForActivity() or not not var0) and not not arg0:inTime()
	end

	local function var3(arg0)
		local var0 = getInputText(arg0.searchInput)

		if not var0 or var0 == "" then
			return true
		else
			return arg0:isMatchSearchKey(var0)
		end
	end

	local function var4(arg0)
		local var0 = var1[arg0] or Furniture.New({
			id = arg0
		})

		if var2(var0) and var3(var0) then
			table.insert(var0, var0)
		end
	end

	if arg0.pageType == 5 then
		for iter0, iter1 in ipairs(pg.furniture_data_template.get_id_list_by_tag[7]) do
			var4(iter1)
		end
	else
		local var5 = var2(arg0.pageType)
		local var6 = pg.furniture_data_template.get_id_list_by_type

		for iter2, iter3 in ipairs(var5) do
			for iter4, iter5 in ipairs(var6[iter3] or {}) do
				var4(iter5)
			end
		end
	end

	return var0
end

function var0.OnInitItem(arg0, arg1)
	local var0 = BackYardFurnitureCard.New(arg1)

	onButton(arg0, var0._go, function()
		if var0.furniture:canPurchase() then
			arg0.contextData.furnitureMsgBox:ExecuteAction("SetUp", var0.furniture, arg0.dorm, arg0.player)
		end
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]

	var0:Update(var1)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Clear()
	end
end

return var0
