local var0_0 = class("BackYardDecorationFurniturePage", import(".BackYardDecorationBasePage"))

var0_0.SELECTED_FURNITRUE = "BackYardDecorationFurniturePage:SELECTED_FURNITRUE"

local function var1_0(arg0_1)
	if not var0_0.PageTypeList then
		var0_0.PageTypeList = {
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

	return var0_0.PageTypeList[arg0_1]
end

function var0_0.getUIName(arg0_2)
	return "BackYardDecorationFurniturePage"
end

function var0_0.OnFurnitureUpdated(arg0_3, arg1_3)
	for iter0_3, iter1_3 in pairs(arg0_3.cards) do
		if iter1_3.furniture:getConfig("id") == arg1_3:getConfig("id") then
			local var0_3, var1_3 = arg0_3:GetPutCntByConfigId(arg0_3.dorm, arg1_3:getConfig("id"))

			iter1_3:Flush(arg1_3, var0_3, var1_3)
		end
	end
end

function var0_0.GetPutCntByConfigId(arg0_4, arg1_4, arg2_4)
	local var0_4 = 0
	local var1_4 = {}

	for iter0_4, iter1_4 in pairs(arg1_4:GetThemeList()) do
		local var2_4 = iter1_4:GetSameFurnitureCnt(arg2_4)

		var0_4 = var0_4 + var2_4

		if var2_4 > 0 then
			table.insert(var1_4, iter0_4)
		end
	end

	local var3_4 = 0

	if #var1_4 > 1 then
		var3_4 = getProxy(DormProxy).floor
	elseif #var1_4 == 1 then
		var3_4 = var1_4[1]
	end

	return var0_4, var3_4
end

function var0_0.OnDisplayList(arg0_5)
	arg0_5.displays = arg0_5:GetDisplays()

	arg0_5:SortDisplays()
end

function var0_0.SortDisplays(arg0_6)
	if not arg0_6.contextData.filterPanel:GetLoaded() then
		local var0_6 = {}

		for iter0_6, iter1_6 in ipairs(arg0_6.displays) do
			local var1_6 = arg0_6:GetPutCntByConfigId(arg0_6.dorm, iter1_6.configId)
			local var2_6 = iter1_6:GetOwnCnt()

			var0_6[iter1_6.id] = var2_6 <= var1_6 and 0 or 1
		end

		local var3_6 = arg0_6.orderMode

		table.sort(arg0_6.displays, function(arg0_7, arg1_7)
			local var0_7 = var0_6[arg0_7.id]
			local var1_7 = var0_6[arg1_7.id]

			if var0_7 == var1_7 then
				local var2_7 = arg0_7.newFlag and 1 or 0
				local var3_7 = arg1_7.newFlag and 1 or 0

				if var2_7 == var3_7 then
					if var3_6 == BackYardDecorationFilterPanel.ORDER_MODE_ASC then
						return arg0_7.id < arg1_7.id
					elseif var3_6 == BackYardDecorationFilterPanel.ORDER_MODE_DASC then
						return arg0_7.id > arg1_7.id
					end
				else
					return var3_7 < var2_7
				end
			else
				return var0_7 < var1_7
			end
		end)
		arg0_6:SetTotalCount()
	else
		arg0_6.contextData.filterPanel:setFilterData(arg0_6:GetDisplays())
		arg0_6.contextData.filterPanel:filter()

		local var4_6 = arg0_6.contextData.filterPanel:GetFilterData()

		arg0_6:OnFilterDone(var4_6)
	end
end

function var0_0.OnOrderModeUpdated(arg0_8)
	arg0_8:SortDisplays()
end

function var0_0.change2ScrPos(arg0_9, arg1_9)
	local var0_9 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1_9 = arg0_9:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1_9, arg1_9, var0_9))
end

function var0_0.OnLoaded(arg0_10)
	arg0_10:bind(BackYardDecorationPutlistPage.SELECTED_FURNITRUE, function()
		arg0_10:ClearMark()
	end)
	arg0_10:bind(BackYardDecrationLayer.INNER_SELECTED_FURNITRUE, function(arg0_12, arg1_12)
		arg0_10:Selected(arg1_12)
	end)

	arg0_10.scrollRect = arg0_10._tf:GetComponent("LScrollRect")

	local function var0_10()
		if arg0_10.timer then
			arg0_10.timer:Stop()

			arg0_10.timer = nil
		end
	end

	local function var1_10(arg0_14)
		arg0_10.timer = Timer.New(arg0_14, 0.8, 1)

		arg0_10.timer:Start()
	end

	local function var2_10(arg0_15)
		local var0_15 = var0_0.change2ScrPos(arg0_10._tf:Find("content"), arg0_15.position)
		local var1_15

		for iter0_15, iter1_15 in pairs(arg0_10.cards) do
			local var2_15 = iter1_15._bg
			local var3_15 = iter1_15._tf.localPosition.x
			local var4_15 = iter1_15._tf.localPosition.y
			local var5_15 = Vector2(var3_15 + var2_15.rect.width / 2, var4_15 + var2_15.rect.height / 2)
			local var6_15 = Vector2(var3_15 + var2_15.rect.width / 2, var4_15 - var2_15.rect.height / 2)
			local var7_15 = Vector2(var3_15 - var2_15.rect.width / 2, var4_15 - var2_15.rect.height / 2)

			if var0_15.x > var7_15.x and var0_15.x < var6_15.x and var0_15.y > var6_15.y and var0_15.y < var5_15.y then
				var1_15 = iter1_15

				break
			end
		end

		return var1_15
	end

	local var3_10 = GetOrAddComponent(arg0_10._tf, typeof(EventTriggerListener))

	var3_10:AddPointDownFunc(function(arg0_16, arg1_16)
		arg0_10.downPosition = arg1_16.position

		local var0_16 = var2_10(arg1_16)

		if var0_16 then
			var0_10()
			var1_10(function()
				arg0_10.lock = true

				local var0_17 = var0_16._tf.position

				arg0_10.contextData.furnitureDescMsgBox:ExecuteAction("SetUp", var0_16.furniture, var0_17)
			end)
		end
	end)
	var3_10:AddPointUpFunc(function(arg0_18, arg1_18)
		var0_10()

		if arg0_10.lock then
			arg0_10.contextData.furnitureDescMsgBox:ExecuteAction("Hide")
			onNextTick(function()
				arg0_10.lock = false
			end)
		else
			local var0_18 = arg1_18.position

			if Vector2.Distance(var0_18, arg0_10.downPosition) > 1 then
				return
			end

			local var1_18 = var2_10(arg1_18)

			if var1_18 and var1_18:HasMask() and var1_18.furniture:isPaper() then
				arg0_10:emit(BackYardDecorationMediator.REMOVE_PAPER, var1_18.furniture)
			elseif var1_18 and not var1_18:HasMask() then
				local var2_18 = Clone(var1_18.furniture)

				arg0_10:emit(BackYardDecorationMediator.ADD_FURNITURE, var2_18)
			elseif var1_18 and var1_18:HasMask() then
				arg0_10:ClearMark()

				arg0_10.selectedId = var1_18.furniture.id

				var1_18:UpdateMark(arg0_10.selectedId)
				arg0_10:emit(BackYardDecorationMediator.ON_SELECTED_FURNITRUE, var1_18.furniture.id)
				arg0_10:emit(var0_0.SELECTED_FURNITRUE)
			end
		end
	end)
end

function var0_0.ClearMark(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.cards) do
		iter1_20:UpdateMark(-1)
	end

	arg0_20.selectedId = nil
end

function var0_0.Selected(arg0_21, arg1_21)
	arg0_21:ClearMark()

	for iter0_21, iter1_21 in pairs(arg0_21.cards) do
		if iter1_21.furniture.id == arg1_21 then
			iter1_21:UpdateMark(arg1_21)
		end
	end

	arg0_21.selectedId = arg1_21
end

function var0_0.OnInitItem(arg0_22, arg1_22)
	local var0_22 = BackYardDecorationCard.New(arg1_22)

	arg0_22.cards[arg1_22] = var0_22
end

function var0_0.OnUpdateItem(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.cards[arg2_23]

	if not var0_23 then
		arg0_23:OnInitItem(arg2_23)

		var0_23 = arg0_23.cards[arg2_23]
	end

	local var1_23 = arg0_23.lastDiaplys[arg1_23 + 1]

	if not var1_23 then
		return
	end

	local var2_23, var3_23 = arg0_23:GetPutCntByConfigId(arg0_23.dorm, var1_23:getConfig("id"))

	var0_23:Update(var1_23, var2_23, var3_23, arg0_23.selectedId or -1)
	var0_23:PlayEnterAnimation()
end

function var0_0.GetDisplays(arg0_24)
	local var0_24 = {}
	local var1_24 = arg0_24.dorm:GetPurchasedFurnitures()
	local var2_24 = var1_0(arg0_24.pageType)
	local var3_24 = pg.furniture_data_template.get_id_list_by_tag[var2_24]

	for iter0_24, iter1_24 in ipairs(var3_24 or {}) do
		local var4_24 = var1_24[iter1_24]

		if var4_24 then
			table.insert(var0_24, var4_24)
		end
	end

	return var0_24
end

function var0_0.OnFilterDone(arg0_25, arg1_25)
	arg0_25.displays = arg1_25

	arg0_25:SetTotalCount()
end

function var0_0.SetTotalCount(arg0_26)
	if not arg0_26.searchKey or arg0_26.searchKey == "" then
		arg0_26.lastDiaplys = arg0_26.displays
	else
		arg0_26.lastDiaplys = {}

		for iter0_26, iter1_26 in ipairs(arg0_26.displays) do
			if iter1_26:isMatchSearchKey(arg0_26.searchKey) then
				table.insert(arg0_26.lastDiaplys, iter1_26)
			end
		end
	end

	arg0_26.scrollRect:SetTotalCount(#arg0_26.lastDiaplys)
end

function var0_0.OnSearchKeyChanged(arg0_27)
	arg0_27:SetTotalCount()
end

function var0_0.OnDestroy(arg0_28)
	if arg0_28.timer then
		arg0_28.timer:Stop()

		arg0_28.timer = nil
	end

	for iter0_28, iter1_28 in pairs(arg0_28.cards or {}) do
		iter1_28:Dispose()
	end

	arg0_28.cards = nil
end

return var0_0
