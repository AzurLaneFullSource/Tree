local var0 = class("BackYardDecorationThemePage", import(".BackYardDecorationBasePage"))

function var0.getUIName(arg0)
	return "BackYardDecorationThemePage"
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.msgbox = BackYardDecorationMsgBox.New(arg0._parentTf.parent.parent.parent.parent.parent, arg0.event, arg0.contextData)
	arg0.refreshList = {}
end

function var0.OnDisplayList(arg0)
	arg0:InitList()
end

function var0.InitList(arg0)
	arg0.displays = {}

	local var0 = arg0.dorm:GetPurchasedFurnitures()
	local var1 = getProxy(DormProxy):GetSystemThemes()

	for iter0, iter1 in ipairs(var1) do
		if iter1:IsPurchased(var0) then
			table.insert(arg0.displays, iter1)
		end
	end

	local var2 = 0

	if arg0.customTheme then
		for iter2, iter3 in pairs(arg0.customTheme) do
			var2 = var2 + 1

			table.insert(arg0.displays, iter3)
		end
	end

	if var2 < BackYardConst.MAX_USER_THEME then
		table.insert(arg0.displays, {
			id = "",
			isEmpty = true
		})
	end

	arg0:SortDisplays()
end

local function var1(arg0, arg1)
	local var0 = arg0.isEmpty and 1 or 0
	local var1 = arg1.isEmpty and 1 or 0

	if var0 == var1 then
		local var2 = arg0:IsSystem() and 1 or 0
		local var3 = arg1:IsSystem() and 1 or 0

		if var2 == var3 then
			if arg0.order == arg1.order then
				return arg0.id > arg1.id
			else
				return arg0.order > arg1.order
			end
		else
			return var2 < var3
		end
	else
		return var1 < var0
	end
end

local function var2(arg0, arg1)
	local var0 = arg0.isEmpty and 1 or 0
	local var1 = arg1.isEmpty and 1 or 0

	if var0 == var1 then
		local var2 = arg0:IsSystem() and 1 or 0
		local var3 = arg1:IsSystem() and 1 or 0

		if var2 == var3 then
			if arg0.order == arg1.order then
				return arg0.id < arg1.id
			else
				return arg0.order < arg1.order
			end
		else
			return var3 < var2
		end
	else
		return var1 < var0
	end
end

function var0.SortDisplays(arg0)
	table.sort(arg0.displays, function(arg0, arg1)
		if arg0.orderMode == BackYardDecorationFilterPanel.ORDER_MODE_ASC then
			return var2(arg0, arg1)
		else
			return var1(arg0, arg1)
		end
	end)
	arg0:SetTotalCount()
end

function var0.OnOrderModeUpdated(arg0)
	arg0:SortDisplays()
end

function var0.OnInitItem(arg0, arg1)
	local var0 = BackYardDecorationThemeCard.New(arg1)

	onButton(arg0, var0._tf, function()
		if var0:HasMask() then
			return
		end

		arg0.msgbox:ExecuteAction("Show", var0.themeVO, true)
	end)
	onButton(arg0, var0.add, function()
		local var0 = getProxy(DormProxy):GetTemplateNewID()

		arg0.msgbox:ExecuteAction("Show", {
			id = var0
		}, false)
	end)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.lastDiaplys[arg1 + 1]

	var0:Update(var1, false)
end

function var0.OnThemeUpdated(arg0)
	arg0.currHouse = nil

	arg0:InitList()
end

function var0.OnApplyThemeBefore(arg0)
	arg0.currHouse = nil

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Update(iter1.themeVO, false)
	end

	arg0.temps = {}
end

function var0.OnApplyThemeAfter(arg0, arg1)
	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.themeVO.id == arg1 then
			iter1:Update(iter1.themeVO, false)
		end
	end
end

function var0.SetTotalCount(arg0)
	if not arg0.searchKey or arg0.searchKey == "" then
		arg0.lastDiaplys = arg0.displays
	else
		arg0.lastDiaplys = {}

		for iter0, iter1 in ipairs(arg0.displays) do
			if iter1.id == "" or iter1:MatchSearchKey(arg0.searchKey) then
				table.insert(arg0.lastDiaplys, iter1)
			end
		end
	end

	arg0.scrollRect:SetTotalCount(#arg0.lastDiaplys)
end

function var0.OnSearchKeyChanged(arg0)
	arg0:SetTotalCount()
end

function var0.OnDestroy(arg0)
	arg0.msgbox:Destroy()

	for iter0, iter1 in pairs(arg0.cards or {}) do
		iter1:Dispose()
	end

	arg0.cards = nil
end

function var0.OnBackPressed(arg0)
	if arg0:GetLoaded() and arg0.msgbox:GetLoaded() and arg0.msgbox:isShowing() then
		arg0.msgbox:Hide()

		return true
	end

	return false
end

return var0
