local var0_0 = class("IslandAniamtionOpView", import(".IslandBaseSubView"))

function var0_0.GetUIName(arg0_1)
	return "IslandActionOpUI"
end

function var0_0.SetUIParent(arg0_2, arg1_2)
	setParent(arg1_2, arg0_2:GetView().topContainer)
end

function var0_0.FirstFlush(arg0_3)
	arg0_3.scrollrect = arg0_3._tf:Find("frame/scrollrect"):GetComponent("LScrollRect")

	function arg0_3.scrollrect.onInitItem(arg0_4)
		arg0_3:OnInitItem(arg0_4)
	end

	function arg0_3.scrollrect.onUpdateItem(arg0_5, arg1_5)
		arg0_3:OnUpdateItem(arg0_5, arg1_5)
	end

	setActive(arg0_3._go, false)
	onButton(arg0_3, arg0_3._go, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3._tf:Find("frame/tags/1"), function(arg0_7)
		if arg0_7 then
			arg0_3:ScrollToHead(1)
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3._tf:Find("frame/tags/2"), function(arg0_8)
		if arg0_8 then
			arg0_3:ScrollToHead(arg0_3.headDoubleIndex)
		end
	end, SFX_PANEL)

	arg0_3.cards = {}
	arg0_3.isShowing = false
	arg0_3.isInitList = false
end

function var0_0.OnMovePlayerBefore(arg0_9)
	local var0_9 = IslandConst.ANIMATION_MOVEMENT
	local var1_9 = arg0_9:GetView().player.animator

	if not var1_9:GetCurrentAnimatorStateInfo(0):IsName(var0_9) then
		local var2_9 = Animator.StringToHash(var0_9)

		for iter0_9 = 1, var1_9.layerCount do
			var1_9:CrossFadeInFixedTime(var2_9, 0, iter0_9 - 1)
		end
	end
end

function var0_0.Show(arg0_10, arg1_10)
	setActive(arg0_10._go, true)

	if not arg0_10.isInitList or arg1_10 then
		arg0_10:InitList()
	end

	arg0_10.isShowing = true
end

function var0_0.GetData(arg0_11)
	local var0_11 = {}
	local var1_11 = {}

	for iter0_11, iter1_11 in ipairs(pg.island_action.all) do
		local var2_11 = pg.island_action[iter1_11]

		if var2_11.type == IslandConst.ANIMATION_OP_SIGNLE then
			table.insert(var0_11, iter1_11)
		elseif var2_11.type == IslandConst.ANIMATION_OP_DOUBLE then
			table.insert(var1_11, iter1_11)
		end
	end

	return var0_11, var1_11
end

local function var1_0(arg0_12)
	local var0_12 = {}

	for iter0_12 = 1, #arg0_12, 2 do
		local var1_12 = arg0_12[iter0_12]
		local var2_12 = arg0_12[iter0_12 + 1]

		table.insert(var0_12, {
			var1_12,
			var2_12
		})
	end

	return var0_12
end

function var0_0.InitList(arg0_13)
	local var0_13, var1_13 = arg0_13:GetData()
	local var2_13 = {}
	local var3_13 = var1_0(var0_13)
	local var4_13 = var1_0(var1_13)

	for iter0_13, iter1_13 in ipairs(var3_13) do
		table.insert(var2_13, iter1_13)
	end

	local var5_13 = var0_13[#var0_13]

	for iter2_13, iter3_13 in ipairs(var4_13) do
		table.insert(var2_13, iter3_13)
	end

	arg0_13.displays = var2_13
	arg0_13.lastSingleId = var5_13
	arg0_13.headDoubleIndex = #var3_13 + 1

	arg0_13.scrollrect:SetTotalCount(#var2_13)

	arg0_13.isInitList = true
end

function var0_0.ScrollToHead(arg0_14, arg1_14)
	local var0_14 = arg0_14.scrollrect:HeadIndexToValue(arg1_14 - 1)

	arg0_14.scrollrect:ScrollTo(var0_14)
end

function var0_0.OnInitItem(arg0_15, arg1_15)
	local var0_15 = IslandAniamtionOpCard.New(arg1_15)

	onButton(arg0_15, var0_15.item1, function()
		arg0_15.selectedId = var0_15.firstId

		arg0_15:UpdateCardsSelected()
		arg0_15:PlayAniamtion(var0_15.firstId)
	end, SFX_PANEL)
	onButton(arg0_15, var0_15.item2, function()
		arg0_15.selectedId = var0_15.secondId

		arg0_15:UpdateCardsSelected()
		arg0_15:PlayAniamtion(var0_15.secondId)
	end, SFX_PANEL)

	arg0_15.cards[arg1_15] = var0_15
end

function var0_0.PlayAniamtion(arg0_18, arg1_18)
	if not arg1_18 then
		return
	end

	local var0_18 = arg0_18:GetView().player.animator

	if not var0_18 then
		return
	end

	local var1_18 = pg.island_action[arg1_18]

	if var1_18.type == IslandConst.ANIMATION_OP_SIGNLE then
		local var2_18 = Animator.StringToHash(var1_18.resource)

		for iter0_18 = 1, var0_18.layerCount do
			var0_18:CrossFadeInFixedTime(var2_18, 0.2, iter0_18 - 1)
		end
	else
		print("coming soon.................")
	end
end

function var0_0.UpdateCardsSelected(arg0_19)
	for iter0_19, iter1_19 in pairs(arg0_19.cards) do
		iter1_19:UpdateSelected(arg0_19.selectedId)
	end
end

function var0_0.OnUpdateItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.cards[arg2_20]

	if not var0_20 then
		arg0_20:OnInitItem(arg2_20)

		var0_20 = arg0_20.cards[arg2_20]
	end

	local var1_20 = arg0_20.displays[arg1_20 + 1]

	var0_20:Update(var1_20, arg0_20.selectedId, arg0_20.lastSingleId)
end

function var0_0.Hide(arg0_21)
	var0_0.super.Hide(arg0_21)
	arg0_21:Emit(ISLAND_EVT.CLOSE_ANIMATION_OP)

	arg0_21.isShowing = false
end

function var0_0.OnDispose(arg0_22)
	var0_0.super.OnDispose(arg0_22)

	for iter0_22, iter1_22 in pairs(arg0_22.cards) do
		iter1_22:Dispose()
	end

	arg0_22.cards = nil
	arg0_22.isShowing = false
end

return var0_0
