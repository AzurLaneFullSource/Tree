local var0_0 = class("IslandInvitePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandInviteUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.contentText = arg0_2._tf:Find("Text")

	setText(arg0_2.contentText, "")

	arg0_2.prevBtn = arg0_2._tf:Find("bottom/left_arr")
	arg0_2.nextBtn = arg0_2._tf:Find("bottom/right_arr")
	arg0_2.scrollrect = arg0_2._tf:Find("bottom/scroll/content"):GetComponent("LScrollRect")
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
end

function var0_0.OnShow(arg0_10)
	arg0_10.triggerFirstCard = true
	arg0_10.selectedId = nil

	arg0_10:Flush()
end

function var0_0.Flush(arg0_11)
	arg0_11.triggerFirstCard = true
	arg0_11.displays = {}

	local var0_11 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetInviteList()

	for iter0_11, iter1_11 in ipairs(var0_11) do
		local var1_11 = IslandInvitation.New(iter1_11)

		table.insert(arg0_11.displays, var1_11)
	end

	arg0_11.scrollrect:SetTotalCount(#arg0_11.displays)
end

function var0_0.OnInitItem(arg0_12, arg1_12)
	local var0_12 = IslandInviteShipCard.New(arg1_12)

	onButton(arg0_12, var0_12.frameTF, function()
		for iter0_13, iter1_13 in pairs(arg0_12.cards) do
			iter1_13:UpdateSelected(nil)
		end

		arg0_12.selectedId = var0_12.item.shipId

		var0_12:UpdateSelected(arg0_12.selectedId)
	end, SFX_PANEL)
	arg0_12:AddDrag(var0_12.frameTF, function()
		arg0_12:emit(IslandMediator.INVITE_SHIP, var0_12.item.shipId)
	end)

	arg0_12.cards[arg1_12] = var0_12
end

function var0_0.OnUpdateItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.cards[arg2_15]

	if not var0_15 then
		arg0_15:OnInitItem(arg2_15)

		var0_15 = arg0_15.cards[arg2_15]
	end

	local var1_15 = arg0_15.displays[arg1_15 + 1]

	var0_15:Update(var1_15, arg0_15.selectedId)

	arg2_15.name = var0_15.item.shipId

	if arg0_15.triggerFirstCard and arg1_15 == 0 then
		arg0_15.triggerFirstCard = nil

		triggerButton(var0_15.frameTF)
	end
end

function var0_0.AddDrag(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = GetOrAddComponent(arg1_16, "EventTriggerListener")
	local var1_16
	local var2_16 = 0
	local var3_16 = 50
	local var4_16 = arg1_16.rect.height / 2

	var0_16:AddPointDownFunc(function()
		var2_16 = 0
		var1_16 = nil
	end)
	var0_16:AddDragFunc(function(arg0_18, arg1_18)
		local var0_18 = arg1_18.position

		if not var1_16 then
			var1_16 = var0_18
		end

		var2_16 = var0_18.y - var1_16.y

		if var2_16 > 0 then
			setLocalPosition(arg1_16, {
				x = 0,
				y = var2_16 - var4_16
			})
		else
			setLocalPosition(arg1_16, {
				x = 0,
				y = -var4_16
			})
		end
	end)
	var0_16:AddPointUpFunc(function(arg0_19, arg1_19)
		setLocalPosition(arg1_16, {
			x = 0,
			y = -var4_16
		})

		if var2_16 > var3_16 then
			existCall(arg2_16)
		else
			existCall(arg3_16)
		end
	end)
end

function var0_0.GetCommodityIndex(arg0_20, arg1_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.displays) do
		if iter1_20.shipId == arg1_20 then
			return iter0_20
		end
	end
end

function var0_0.OnPrev(arg0_21)
	if not arg0_21.selectedId then
		return
	end

	local var0_21 = arg0_21:GetCommodityIndex(arg0_21.selectedId)

	if var0_21 - 1 > 0 then
		arg0_21:TriggerCommodity(var0_21, -1)
	end
end

function var0_0.OnNext(arg0_22)
	if not arg0_22.selectedId then
		return
	end

	local var0_22 = arg0_22:GetCommodityIndex(arg0_22.selectedId)

	if var0_22 + 1 <= #arg0_22.displays then
		arg0_22:TriggerCommodity(var0_22, 1)
	end
end

function var0_0.TriggerCommodity(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.displays[arg1_23].shipId
	local var1_23 = arg0_23.displays[arg1_23 + arg2_23].shipId
	local var2_23
	local var3_23

	for iter0_23, iter1_23 in pairs(arg0_23.cards) do
		if iter1_23._tf.gameObject.name ~= "-1" then
			if iter1_23.item.shipId == var1_23 then
				var2_23 = iter1_23
			elseif iter1_23.item.shipId == var0_23 then
				var3_23 = iter1_23
			end
		end
	end

	if var2_23 then
		triggerButton(var2_23.frameTF)
	end

	if var2_23 and var3_23 then
		arg0_23:CheckCardBound(var2_23, var3_23, arg2_23 > 0, arg1_23 + arg2_23)
	end
end

function var0_0.CheckCardBound(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24)
	local var0_24 = getBounds(arg0_24.scrollrect.gameObject.transform)

	if arg3_24 then
		local var1_24 = getBounds(arg2_24._tf)
		local var2_24 = getBounds(arg1_24._tf)

		if math.ceil(var2_24:GetMax().x - var0_24:GetMax().x) > var1_24.size.x then
			local var3_24 = arg0_24.scrollrect:HeadIndexToValue(arg4_24 - 1) - arg0_24.scrollrect:HeadIndexToValue(arg4_24)
			local var4_24 = arg0_24.scrollrect.value - var3_24

			arg0_24.scrollrect:SetNormalizedPosition(var4_24, 0)
		end
	else
		local var5_24 = getBounds(arg1_24._tf)

		if getBounds(arg1_24._tf.parent):GetMin().x < var0_24:GetMin().x and var5_24:GetMin().x < var0_24:GetMin().x then
			local var6_24 = arg0_24.scrollrect:HeadIndexToValue(arg4_24 - 1)

			arg0_24.scrollrect:SetNormalizedPosition(var6_24, 0)
		end
	end
end

function var0_0.OnDestroy(arg0_25)
	return
end

return var0_0
