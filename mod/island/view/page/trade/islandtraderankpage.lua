local var0_0 = class("IslandTradeRankPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandTradeRankUI"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("title/Text"), i18n("island_trade_rank_num_label"))
	setText(arg0_2._tf:Find("title/Text_1"), i18n("island_trade_rank_info_label"))
	setText(arg0_2._tf:Find("title/Text_2"), i18n("island_trade_rank_price_label"))
	setText(arg0_2._tf:Find("tpl/main/visit/Text"), i18n("island_visit_title"))
	setText(arg0_2._tf:Find("tpl/main/invite/Text"), i18n("island_trade_invite_label"))

	arg0_2.scrollrect = arg0_2._tf:Find("scrollrect"):GetComponent("LScrollRect")

	function arg0_2.scrollrect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollrect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	arg0_2.selfRankCard = IslandTradeRankCard.New(arg0_2._tf:Find("tpl"))
	arg0_2.cards = {}
end

function var0_0.Show(arg0_5, arg1_5, arg2_5)
	var0_0.super.Show(arg0_5)

	arg0_5.mode = arg2_5

	seriesAsync({
		function(arg0_6)
			arg0_5:RequestRank(arg0_6)
		end
	}, function()
		local var0_7, var1_7, var2_7 = arg0_5:GetDislays()

		arg0_5.rankNums = var2_7

		arg0_5:DisplayResult(var1_7, var0_7)
		arg0_5:UpdateSelfRank(var0_7)
	end)
end

function var0_0.GetDislays(arg0_8)
	local var0_8
	local var1_8

	if arg0_8.mode == IslandTradePage.MODE_SELL then
		var0_8, var1_8 = getProxy(IslandProxy):GetIsland():GetTradeAgency():GetSellRanks()
	elseif arg0_8.mode == IslandTradePage.MODE_PURCHAS then
		var0_8, var1_8 = getProxy(IslandProxy):GetIsland():GetTradeAgency():GetRanks()
	end

	local var2_8 = {}

	table.insert(var2_8, var1_8)

	for iter0_8, iter1_8 in ipairs(var0_8) do
		if iter1_8:IsVaild() then
			table.insert(var2_8, iter1_8)
		end
	end

	table.sort(var2_8, function(arg0_9, arg1_9)
		if arg0_8.mode == IslandTradePage.MODE_SELL then
			return arg0_9.value > arg1_9.value
		elseif arg0_8.mode == IslandTradePage.MODE_PURCHAS then
			return arg0_9.value < arg1_9.value
		end
	end)

	local var3_8 = {}
	local var4_8 = 0
	local var5_8 = 0

	for iter2_8, iter3_8 in ipairs(var2_8) do
		if iter3_8.value ~= var4_8 then
			var5_8 = var5_8 + 1
			var3_8[iter3_8.value] = var5_8
			var4_8 = iter3_8.value
		end
	end

	return var1_8, var2_8, var3_8
end

function var0_0.RequestRank(arg0_10, arg1_10)
	arg0_10:emit(IslandBaseMediator.REQ_TRADE_RANK, arg1_10)
end

function var0_0.DisplayResult(arg0_11, arg1_11, arg2_11)
	arg0_11.displays = {}

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		if iter1_11.id ~= arg2_11.id then
			table.insert(arg0_11.displays, iter1_11)
		end
	end

	arg0_11.scrollrect:SetTotalCount(#arg0_11.displays)
end

function var0_0.OnInitItem(arg0_12, arg1_12)
	local var0_12 = IslandTradeRankCard.New(arg1_12)

	onButton(arg0_12, var0_12.visitBtn, function()
		arg0_12:emit(IslandBaseMediator.ENTER_ISLAND, var0_12.id)
	end, SFX_PANEL)

	arg0_12.cards[arg1_12] = var0_12
end

function var0_0.OnUpdateItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.cards[arg2_14]

	if not var0_14 then
		arg0_14:OnInitItem(arg2_14)

		var0_14 = arg0_14.cards[arg2_14]
	end

	local var1_14 = arg0_14.displays[arg1_14 + 1]
	local var2_14 = arg0_14.rankNums[var1_14.value]

	assert(var2_14, var1_14.value)
	var0_14:Update(var2_14, var1_14, arg1_14)
end

function var0_0.UpdateSelfRank(arg0_15, arg1_15)
	local var0_15 = arg0_15.rankNums[arg1_15.value]

	arg0_15.selfRankCard:Update(var0_15, arg1_15, 0)
	onButton(arg0_15, arg0_15.selfRankCard.inviteBtn, function()
		arg0_15:emit(IslandTradePage.OPEN_INVITE_PAGE)
	end, SFX_PANEL)
end

function var0_0.OnDestory(arg0_17)
	ClearLScrollrect(arg0_17.scrollrect)

	for iter0_17, iter1_17 in pairs(arg0_17.cards) do
		iter1_17:Dispose()
	end

	arg0_17.cards = nil

	arg0_17.selfRankCard:Dispose()
end

return var0_0
