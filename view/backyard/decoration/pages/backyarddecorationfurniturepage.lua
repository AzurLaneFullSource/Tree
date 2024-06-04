local var0 = class("BackYardDecorationFurniturePage", import(".BackYardDecorationBasePage"))

var0.SELECTED_FURNITRUE = "BackYardDecorationFurniturePage:SELECTED_FURNITRUE"

local function var1(arg0)
	if not var0.PageTypeList then
		var0.PageTypeList = {
			0,
			1,
			7,
			2,
			3,
			4,
			5,
			6,
			8
		}
	end

	return var0.PageTypeList[arg0]
end

function var0.getUIName(arg0)
	return "BackYardDecorationFurniturePage"
end

function var0.OnFurnitureUpdated(arg0, arg1)
	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.furniture:getConfig("id") == arg1:getConfig("id") then
			local var0, var1 = arg0:GetPutCntByConfigId(arg0.dorm, arg1:getConfig("id"))

			iter1:Flush(arg1, var0, var1)
		end
	end
end

function var0.GetPutCntByConfigId(arg0, arg1, arg2)
	local var0 = 0
	local var1 = {}

	for iter0, iter1 in pairs(arg1:GetThemeList()) do
		local var2 = iter1:GetSameFurnitureCnt(arg2)

		var0 = var0 + var2

		if var2 > 0 then
			table.insert(var1, iter0)
		end
	end

	local var3 = 0

	if #var1 > 1 then
		var3 = getProxy(DormProxy).floor
	elseif #var1 == 1 then
		var3 = var1[1]
	end

	return var0, var3
end

function var0.OnDisplayList(arg0)
	arg0.displays = arg0:GetDisplays()

	arg0:SortDisplays()
end

function var0.SortDisplays(arg0)
	if not arg0.contextData.filterPanel:GetLoaded() then
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.displays) do
			local var1 = arg0:GetPutCntByConfigId(arg0.dorm, iter1.configId)
			local var2 = iter1:GetOwnCnt()

			var0[iter1.id] = var2 <= var1 and 0 or 1
		end

		local var3 = arg0.orderMode

		table.sort(arg0.displays, function(arg0, arg1)
			local var0 = var0[arg0.id]
			local var1 = var0[arg1.id]

			if var0 == var1 then
				local var2 = arg0.newFlag and 1 or 0
				local var3 = arg1.newFlag and 1 or 0

				if var2 == var3 then
					if var3 == BackYardDecorationFilterPanel.ORDER_MODE_ASC then
						return arg0.id < arg1.id
					elseif var3 == BackYardDecorationFilterPanel.ORDER_MODE_DASC then
						return arg0.id > arg1.id
					end
				else
					return var3 < var2
				end
			else
				return var0 < var1
			end
		end)
		arg0:SetTotalCount()
	else
		arg0.contextData.filterPanel:setFilterData(arg0:GetDisplays())
		arg0.contextData.filterPanel:filter()

		local var4 = arg0.contextData.filterPanel:GetFilterData()

		arg0:OnFilterDone(var4)
	end
end

function var0.OnOrderModeUpdated(arg0)
	arg0:SortDisplays()
end

function var0.change2ScrPos(arg0, arg1)
	local var0 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1 = arg0:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1, arg1, var0))
end

function var0.OnLoaded(arg0)
	arg0:bind(BackYardDecorationPutlistPage.SELECTED_FURNITRUE, function()
		arg0:ClearMark()
	end)
	arg0:bind(BackYardDecrationLayer.INNER_SELECTED_FURNITRUE, function(arg0, arg1)
		arg0:Selected(arg1)
	end)

	arg0.scrollRect = arg0._tf:GetComponent("LScrollRect")

	local function var0()
		if arg0.timer then
			arg0.timer:Stop()

			arg0.timer = nil
		end
	end

	local function var1(arg0)
		arg0.timer = Timer.New(arg0, 0.8, 1)

		arg0.timer:Start()
	end

	local function var2(arg0)
		local var0 = var0.change2ScrPos(arg0._tf:Find("content"), arg0.position)
		local var1

		for iter0, iter1 in pairs(arg0.cards) do
			local var2 = iter1._bg
			local var3 = iter1._tf.localPosition.x
			local var4 = iter1._tf.localPosition.y
			local var5 = Vector2(var3 + var2.rect.width / 2, var4 + var2.rect.height / 2)
			local var6 = Vector2(var3 + var2.rect.width / 2, var4 - var2.rect.height / 2)
			local var7 = Vector2(var3 - var2.rect.width / 2, var4 - var2.rect.height / 2)

			if var0.x > var7.x and var0.x < var6.x and var0.y > var6.y and var0.y < var5.y then
				var1 = iter1

				break
			end
		end

		return var1
	end

	local var3 = GetOrAddComponent(arg0._tf, typeof(EventTriggerListener))

	var3:AddPointDownFunc(function(arg0, arg1)
		arg0.downPosition = arg1.position

		local var0 = var2(arg1)

		if var0 then
			var0()
			var1(function()
				arg0.lock = true

				local var0 = var0._tf.position

				arg0.contextData.furnitureDescMsgBox:ExecuteAction("SetUp", var0.furniture, var0)
			end)
		end
	end)
	var3:AddPointUpFunc(function(arg0, arg1)
		var0()

		if arg0.lock then
			arg0.contextData.furnitureDescMsgBox:ExecuteAction("Hide")
			onNextTick(function()
				arg0.lock = false
			end)
		else
			local var0 = arg1.position

			if Vector2.Distance(var0, arg0.downPosition) > 1 then
				return
			end

			local var1 = var2(arg1)

			if var1 and var1:HasMask() and var1.furniture:isPaper() then
				arg0:emit(BackYardDecorationMediator.REMOVE_PAPER, var1.furniture)
			elseif var1 and not var1:HasMask() then
				local var2 = Clone(var1.furniture)

				arg0:emit(BackYardDecorationMediator.ADD_FURNITURE, var2)
			elseif var1 and var1:HasMask() then
				arg0:ClearMark()

				arg0.selectedId = var1.furniture.id

				var1:UpdateMark(arg0.selectedId)
				arg0:emit(BackYardDecorationMediator.ON_SELECTED_FURNITRUE, var1.furniture.id)
				arg0:emit(var0.SELECTED_FURNITRUE)
			end
		end
	end)
end

function var0.ClearMark(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		iter1:UpdateMark(-1)
	end

	arg0.selectedId = nil
end

function var0.Selected(arg0, arg1)
	arg0:ClearMark()

	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.furniture.id == arg1 then
			iter1:UpdateMark(arg1)
		end
	end

	arg0.selectedId = arg1
end

function var0.OnInitItem(arg0, arg1)
	local var0 = BackYardDecorationCard.New(arg1)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.lastDiaplys[arg1 + 1]

	if not var1 then
		return
	end

	local var2, var3 = arg0:GetPutCntByConfigId(arg0.dorm, var1:getConfig("id"))

	var0:Update(var1, var2, var3, arg0.selectedId or -1)
	var0:PlayEnterAnimation()
end

function var0.GetDisplays(arg0)
	local var0 = {}
	local var1 = arg0.dorm:GetPurchasedFurnitures()
	local var2 = var1(arg0.pageType)
	local var3 = pg.furniture_data_template.get_id_list_by_tag[var2]

	for iter0, iter1 in ipairs(var3 or {}) do
		local var4 = var1[iter1]

		if var4 then
			table.insert(var0, var4)
		end
	end

	return var0
end

function var0.OnFilterDone(arg0, arg1)
	arg0.displays = arg1

	arg0:SetTotalCount()
end

function var0.SetTotalCount(arg0)
	if not arg0.searchKey or arg0.searchKey == "" then
		arg0.lastDiaplys = arg0.displays
	else
		arg0.lastDiaplys = {}

		for iter0, iter1 in ipairs(arg0.displays) do
			if iter1:isMatchSearchKey(arg0.searchKey) then
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
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	for iter0, iter1 in pairs(arg0.cards or {}) do
		iter1:Dispose()
	end

	arg0.cards = nil
end

return var0
