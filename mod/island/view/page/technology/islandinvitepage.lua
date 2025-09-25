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
	onButton(arg0_5, arg0_5.prevBtn, function()
		arg0_5:OnPrev()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.nextBtn, function()
		arg0_5:OnNext()
	end, SFX_PANEL)

	arg0_5.cards = {}
end

function var0_0.AddListeners(arg0_9)
	arg0_9:AddListener(IslandCharacterAgency.ADD_SHIP, arg0_9.Flush)
end

function var0_0.RemoveListeners(arg0_10)
	arg0_10:RemoveListener(IslandCharacterAgency.ADD_SHIP, arg0_10.Flush)
end

function var0_0.OnShow(arg0_11)
	arg0_11.triggerFirstCard = true
	arg0_11.selectedId = nil

	arg0_11:Flush()
end

function var0_0.Flush(arg0_12)
	arg0_12.triggerFirstCard = true
	arg0_12.displays = {}

	local var0_12 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetInviteList()

	for iter0_12, iter1_12 in ipairs(var0_12) do
		local var1_12 = IslandInvitation.New(iter1_12)

		table.insert(arg0_12.displays, var1_12)
	end

	arg0_12.scrollrect:SetTotalCount(#arg0_12.displays)
end

function var0_0.OnInitItem(arg0_13, arg1_13)
	local var0_13 = IslandInviteShipCard.New(arg1_13)

	onButton(arg0_13, var0_13.frameTF, function()
		for iter0_14, iter1_14 in pairs(arg0_13.cards) do
			iter1_14:UpdateSelected(nil)
		end

		arg0_13.selectedId = var0_13.item.shipId

		var0_13:UpdateSelected(arg0_13.selectedId)
	end, SFX_PANEL)
	arg0_13:AddDrag(var0_13.frameTF, function()
		arg0_13:emit(IslandMediator.INVITE_SHIP, var0_13.item.shipId)
	end)

	arg0_13.cards[arg1_13] = var0_13
end

function var0_0.OnUpdateItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.cards[arg2_16]

	if not var0_16 then
		arg0_16:OnInitItem(arg2_16)

		var0_16 = arg0_16.cards[arg2_16]
	end

	local var1_16 = arg0_16.displays[arg1_16 + 1]

	var0_16:Update(var1_16, arg0_16.selectedId)

	arg2_16.name = var0_16.item.shipId

	if arg0_16.triggerFirstCard and arg1_16 == 0 then
		arg0_16.triggerFirstCard = nil

		triggerButton(var0_16.frameTF)
	end
end

function var0_0.AddDrag(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = GetOrAddComponent(arg1_17, "EventTriggerListener")
	local var1_17
	local var2_17 = 0
	local var3_17 = 50
	local var4_17 = arg1_17.rect.height / 2

	var0_17:AddPointDownFunc(function()
		var2_17 = 0
		var1_17 = nil
	end)
	var0_17:AddDragFunc(function(arg0_19, arg1_19)
		local var0_19 = arg1_19.position

		if not var1_17 then
			var1_17 = var0_19
		end

		var2_17 = var0_19.y - var1_17.y

		if var2_17 > 0 then
			setLocalPosition(arg1_17, {
				x = 0,
				y = var2_17 - var4_17
			})
		else
			setLocalPosition(arg1_17, {
				x = 0,
				y = -var4_17
			})
		end
	end)
	var0_17:AddPointUpFunc(function(arg0_20, arg1_20)
		setLocalPosition(arg1_17, {
			x = 0,
			y = -var4_17
		})

		if var2_17 > var3_17 then
			existCall(arg2_17)
		else
			existCall(arg3_17)
		end
	end)
end

function var0_0.GetCommodityIndex(arg0_21, arg1_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.displays) do
		if iter1_21.shipId == arg1_21 then
			return iter0_21
		end
	end
end

function var0_0.OnPrev(arg0_22)
	if not arg0_22.selectedId then
		return
	end

	local var0_22 = arg0_22:GetCommodityIndex(arg0_22.selectedId)

	if var0_22 - 1 > 0 then
		arg0_22:TriggerCommodity(var0_22, -1)
	end
end

function var0_0.OnNext(arg0_23)
	if not arg0_23.selectedId then
		return
	end

	local var0_23 = arg0_23:GetCommodityIndex(arg0_23.selectedId)

	if var0_23 + 1 <= #arg0_23.displays then
		arg0_23:TriggerCommodity(var0_23, 1)
	end
end

function var0_0.TriggerCommodity(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.displays[arg1_24].shipId
	local var1_24 = arg0_24.displays[arg1_24 + arg2_24].shipId
	local var2_24
	local var3_24

	for iter0_24, iter1_24 in pairs(arg0_24.cards) do
		if iter1_24._tf.gameObject.name ~= "-1" then
			if iter1_24.item.shipId == var1_24 then
				var2_24 = iter1_24
			elseif iter1_24.item.shipId == var0_24 then
				var3_24 = iter1_24
			end
		end
	end

	if var2_24 then
		triggerButton(var2_24.frameTF)
	end

	if var2_24 and var3_24 then
		arg0_24:CheckCardBound(var2_24, var3_24, arg2_24 > 0, arg1_24 + arg2_24)
	end
end

function var0_0.CheckCardBound(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25)
	local var0_25 = getBounds(arg0_25.scrollrect.gameObject.transform)

	if arg3_25 then
		local var1_25 = getBounds(arg2_25._tf)
		local var2_25 = getBounds(arg1_25._tf)

		if math.ceil(var2_25:GetMax().x - var0_25:GetMax().x) > var1_25.size.x then
			local var3_25 = arg0_25.scrollrect:HeadIndexToValue(arg4_25 - 1) - arg0_25.scrollrect:HeadIndexToValue(arg4_25)
			local var4_25 = arg0_25.scrollrect.value - var3_25

			arg0_25.scrollrect:SetNormalizedPosition(var4_25, 0)
		end
	else
		local var5_25 = getBounds(arg1_25._tf)

		if getBounds(arg1_25._tf.parent):GetMin().x < var0_25:GetMin().x and var5_25:GetMin().x < var0_25:GetMin().x then
			local var6_25 = arg0_25.scrollrect:HeadIndexToValue(arg4_25 - 1)

			arg0_25.scrollrect:SetNormalizedPosition(var6_25, 0)
		end
	end
end

function var0_0.OnDestroy(arg0_26)
	return
end

return var0_0
