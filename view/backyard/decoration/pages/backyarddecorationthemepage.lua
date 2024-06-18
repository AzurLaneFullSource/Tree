local var0_0 = class("BackYardDecorationThemePage", import(".BackYardDecorationBasePage"))

function var0_0.getUIName(arg0_1)
	return "BackYardDecorationThemePage"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.msgbox = BackYardDecorationMsgBox.New(arg0_2._parentTf.parent.parent.parent.parent.parent, arg0_2.event, arg0_2.contextData)
	arg0_2.refreshList = {}
end

function var0_0.OnDisplayList(arg0_3)
	arg0_3:InitList()
end

function var0_0.InitList(arg0_4)
	arg0_4.displays = {}

	local var0_4 = arg0_4.dorm:GetPurchasedFurnitures()
	local var1_4 = getProxy(DormProxy):GetSystemThemes()

	for iter0_4, iter1_4 in ipairs(var1_4) do
		if iter1_4:IsPurchased(var0_4) then
			table.insert(arg0_4.displays, iter1_4)
		end
	end

	local var2_4 = 0

	if arg0_4.customTheme then
		for iter2_4, iter3_4 in pairs(arg0_4.customTheme) do
			var2_4 = var2_4 + 1

			table.insert(arg0_4.displays, iter3_4)
		end
	end

	if var2_4 < BackYardConst.MAX_USER_THEME then
		table.insert(arg0_4.displays, {
			id = "",
			isEmpty = true
		})
	end

	arg0_4:SortDisplays()
end

local function var1_0(arg0_5, arg1_5)
	local var0_5 = arg0_5.isEmpty and 1 or 0
	local var1_5 = arg1_5.isEmpty and 1 or 0

	if var0_5 == var1_5 then
		local var2_5 = arg0_5:IsSystem() and 1 or 0
		local var3_5 = arg1_5:IsSystem() and 1 or 0

		if var2_5 == var3_5 then
			if arg0_5.order == arg1_5.order then
				return arg0_5.id > arg1_5.id
			else
				return arg0_5.order > arg1_5.order
			end
		else
			return var2_5 < var3_5
		end
	else
		return var1_5 < var0_5
	end
end

local function var2_0(arg0_6, arg1_6)
	local var0_6 = arg0_6.isEmpty and 1 or 0
	local var1_6 = arg1_6.isEmpty and 1 or 0

	if var0_6 == var1_6 then
		local var2_6 = arg0_6:IsSystem() and 1 or 0
		local var3_6 = arg1_6:IsSystem() and 1 or 0

		if var2_6 == var3_6 then
			if arg0_6.order == arg1_6.order then
				return arg0_6.id < arg1_6.id
			else
				return arg0_6.order < arg1_6.order
			end
		else
			return var3_6 < var2_6
		end
	else
		return var1_6 < var0_6
	end
end

function var0_0.SortDisplays(arg0_7)
	table.sort(arg0_7.displays, function(arg0_8, arg1_8)
		if arg0_7.orderMode == BackYardDecorationFilterPanel.ORDER_MODE_ASC then
			return var2_0(arg0_8, arg1_8)
		else
			return var1_0(arg0_8, arg1_8)
		end
	end)
	arg0_7:SetTotalCount()
end

function var0_0.OnOrderModeUpdated(arg0_9)
	arg0_9:SortDisplays()
end

function var0_0.OnInitItem(arg0_10, arg1_10)
	local var0_10 = BackYardDecorationThemeCard.New(arg1_10)

	onButton(arg0_10, var0_10._tf, function()
		if var0_10:HasMask() then
			return
		end

		arg0_10.msgbox:ExecuteAction("Show", var0_10.themeVO, true)
	end)
	onButton(arg0_10, var0_10.add, function()
		local var0_12 = getProxy(DormProxy):GetTemplateNewID()

		arg0_10.msgbox:ExecuteAction("Show", {
			id = var0_12
		}, false)
	end)

	arg0_10.cards[arg1_10] = var0_10
end

function var0_0.OnUpdateItem(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.cards[arg2_13]

	if not var0_13 then
		arg0_13:OnInitItem(arg2_13)

		var0_13 = arg0_13.cards[arg2_13]
	end

	local var1_13 = arg0_13.lastDiaplys[arg1_13 + 1]

	var0_13:Update(var1_13, false)
end

function var0_0.OnThemeUpdated(arg0_14)
	arg0_14.currHouse = nil

	arg0_14:InitList()
end

function var0_0.OnApplyThemeBefore(arg0_15)
	arg0_15.currHouse = nil

	for iter0_15, iter1_15 in pairs(arg0_15.cards) do
		iter1_15:Update(iter1_15.themeVO, false)
	end

	arg0_15.temps = {}
end

function var0_0.OnApplyThemeAfter(arg0_16, arg1_16)
	for iter0_16, iter1_16 in pairs(arg0_16.cards) do
		if iter1_16.themeVO.id == arg1_16 then
			iter1_16:Update(iter1_16.themeVO, false)
		end
	end
end

function var0_0.SetTotalCount(arg0_17)
	if not arg0_17.searchKey or arg0_17.searchKey == "" then
		arg0_17.lastDiaplys = arg0_17.displays
	else
		arg0_17.lastDiaplys = {}

		for iter0_17, iter1_17 in ipairs(arg0_17.displays) do
			if iter1_17.id == "" or iter1_17:MatchSearchKey(arg0_17.searchKey) then
				table.insert(arg0_17.lastDiaplys, iter1_17)
			end
		end
	end

	arg0_17.scrollRect:SetTotalCount(#arg0_17.lastDiaplys)
end

function var0_0.OnSearchKeyChanged(arg0_18)
	arg0_18:SetTotalCount()
end

function var0_0.OnDestroy(arg0_19)
	arg0_19.msgbox:Destroy()

	for iter0_19, iter1_19 in pairs(arg0_19.cards or {}) do
		iter1_19:Dispose()
	end

	arg0_19.cards = nil
end

function var0_0.OnBackPressed(arg0_20)
	if arg0_20:GetLoaded() and arg0_20.msgbox:GetLoaded() and arg0_20.msgbox:isShowing() then
		arg0_20.msgbox:Hide()

		return true
	end

	return false
end

return var0_0
