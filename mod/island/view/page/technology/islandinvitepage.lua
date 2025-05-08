local var0_0 = class("IslandInvitePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandInviteUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.contentText = arg0_2._tf:Find("Text")
	arg0_2.prevBtn = arg0_2._tf:Find("bottom/left_arr")
	arg0_2.nextBtn = arg0_2._tf:Find("bottom/right_arr")
	arg0_2.scrollrect = arg0_2._tf:Find("bottom/scroll"):GetComponent("LScrollRect")
	arg0_2.scrollrect.isNewLoadingMethod = true

	function arg0_2.scrollrect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollrect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("top/back"), function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("top/home"), function()
		arg0_5:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.prevBtn, function()
		arg0_5:OnPrev()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.nextBtn, function()
		arg0_5:OnNext()
	end, SFX_PANEL)

	arg0_5.cards = {}

	arg0_5:Flush()
end

function var0_0.AddListeners(arg0_10)
	arg0_10:AddListener(IslandCharacterAgency.ADD_SHIP, arg0_10.Flush)
end

function var0_0.RemoveListeners(arg0_11)
	arg0_11:RemoveListener(IslandCharacterAgency.ADD_SHIP, arg0_11.Flush)
end

function var0_0.Flush(arg0_12)
	arg0_12.triggerFirstCard = true
	arg0_12.displays = {}

	for iter0_12, iter1_12 in ipairs(pg.island_ship.all) do
		if IslandShip.StaticCanUnlock(iter1_12) then
			table.insert(arg0_12.displays, iter1_12)
		end
	end

	arg0_12.scrollrect:SetTotalCount(#arg0_12.displays, 0)
end

function var0_0.OnInitItem(arg0_13, arg1_13)
	local var0_13 = IslandInviteShipCard.New(arg1_13)

	onButton(arg0_13, var0_13.frameTF, function()
		for iter0_14, iter1_14 in pairs(arg0_13.cards) do
			iter1_14:UpdateSelected(nil)
		end

		arg0_13.selectedId = var0_13.configId

		var0_13:UpdateSelected(arg0_13.selectedId)
		setText(arg0_13.contentText, "目前选中的是:" .. pg.island_ship[arg0_13.selectedId].name)
	end, SFX_PANEL)
	arg0_13:AddDrag(var0_13.frameTF, function()
		local var0_15 = IslandShip.StaticGetUnlockItemId(var0_13.configId)

		if not var0_15 then
			return
		end

		local var1_15 = pg.island_item_data_template[var0_15].name
		local var2_15 = pg.island_ship[var0_13.configId].name

		arg0_13:ShowMsgBox({
			content = i18n1("消耗" .. var1_15 .. "X1，邀请" .. var2_15 .. "\n加入队伍,是否确定？"),
			onYes = function()
				arg0_13:emit(IslandMediator.ON_USE_ITEM, var0_15, 1)
			end
		})
	end)

	arg0_13.cards[arg1_13] = var0_13
end

function var0_0.OnUpdateItem(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.cards[arg2_17]

	if not var0_17 then
		arg0_17:OnInitItem(arg2_17)

		var0_17 = arg0_17.cards[arg2_17]
	end

	local var1_17 = arg0_17.displays[arg1_17 + 1]

	var0_17:Update(var1_17, arg0_17.selectedId)

	if arg0_17.triggerFirstCard and arg1_17 == 0 then
		arg0_17.triggerFirstCard = nil

		triggerButton(var0_17.frameTF)
	end
end

function var0_0.AddDrag(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = GetOrAddComponent(arg1_18, "EventTriggerListener")
	local var1_18
	local var2_18 = 0
	local var3_18 = 50
	local var4_18 = arg1_18.rect.height / 2

	var0_18:AddPointDownFunc(function()
		var2_18 = 0
		var1_18 = nil
	end)
	var0_18:AddDragFunc(function(arg0_20, arg1_20)
		local var0_20 = arg1_20.position

		if not var1_18 then
			var1_18 = var0_20
		end

		var2_18 = var0_20.y - var1_18.y

		if var2_18 > 0 then
			setLocalPosition(arg1_18, {
				x = 0,
				y = var2_18 - var4_18
			})
		else
			setLocalPosition(arg1_18, {
				x = 0,
				y = -var4_18
			})
		end
	end)
	var0_18:AddPointUpFunc(function(arg0_21, arg1_21)
		setLocalPosition(arg1_18, {
			x = 0,
			y = -var4_18
		})

		if var2_18 > var3_18 then
			existCall(arg2_18)
		else
			existCall(arg3_18)
		end
	end)
end

function var0_0.GetCommodityIndex(arg0_22, arg1_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.displays) do
		if iter1_22 == arg1_22 then
			return iter0_22
		end
	end
end

function var0_0.OnPrev(arg0_23)
	if not arg0_23.selectedId then
		return
	end

	local var0_23 = arg0_23:GetCommodityIndex(arg0_23.selectedId)

	if var0_23 - 1 > 0 then
		arg0_23:TriggerCommodity(var0_23, -1)
	end
end

function var0_0.OnNext(arg0_24)
	if not arg0_24.selectedId then
		return
	end

	local var0_24 = arg0_24:GetCommodityIndex(arg0_24.selectedId)

	if var0_24 + 1 <= #arg0_24.displays then
		arg0_24:TriggerCommodity(var0_24, 1)
	end
end

function var0_0.TriggerCommodity(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.displays[arg1_25]
	local var1_25 = arg0_25.displays[arg1_25 + arg2_25]
	local var2_25
	local var3_25

	for iter0_25, iter1_25 in pairs(arg0_25.cards) do
		if iter1_25._tf.gameObject.name ~= "-1" then
			if iter1_25.configId == var1_25 then
				var2_25 = iter1_25
			elseif iter1_25.configId == var0_25 then
				var3_25 = iter1_25
			end
		end
	end

	if var2_25 then
		triggerButton(var2_25.frameTF)
	end

	if var2_25 and var3_25 then
		arg0_25:CheckCardBound(var2_25, var3_25, arg2_25 > 0, arg1_25 + arg2_25)
	end
end

function var0_0.CheckCardBound(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	local var0_26 = getBounds(arg0_26.scrollrect.gameObject.transform)

	if arg3_26 then
		local var1_26 = getBounds(arg2_26._tf)
		local var2_26 = getBounds(arg1_26._tf)

		if math.ceil(var2_26:GetMax().x - var0_26:GetMax().x) > var1_26.size.x then
			local var3_26 = arg0_26.scrollrect:HeadIndexToValue(arg4_26 - 1) - arg0_26.scrollrect:HeadIndexToValue(arg4_26)
			local var4_26 = arg0_26.scrollrect.value - var3_26

			arg0_26.scrollrect:SetNormalizedPosition(var4_26, 0)
		end
	else
		local var5_26 = getBounds(arg1_26._tf)

		if getBounds(arg1_26._tf.parent):GetMin().x < var0_26:GetMin().x and var5_26:GetMin().x < var0_26:GetMin().x then
			local var6_26 = arg0_26.scrollrect:HeadIndexToValue(arg4_26 - 1)

			arg0_26.scrollrect:SetNormalizedPosition(var6_26, 0)
		end
	end
end

function var0_0.OnDestroy(arg0_27)
	return
end

return var0_0
