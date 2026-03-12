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
		local var0_7, var1_7 = arg0_5:GetDislays()

		arg0_5.rankNums = arg0_5:GenRank(var0_7, var1_7)

		arg0_5:DisplayResult(var1_7)
		arg0_5:UpdateSelfRank(var0_7)
	end)
end

function var0_0.GenRank(arg0_8, arg1_8, arg2_8)
	local var0_8 = {}

	table.insert(var0_8, arg1_8)

	for iter0_8, iter1_8 in ipairs(arg2_8) do
		table.insert(var0_8, iter1_8)
	end

	table.sort(var0_8, function(arg0_9, arg1_9)
		if arg0_8.mode == IslandTradePage.MODE_SELL then
			return arg0_9.value > arg1_9.value
		elseif arg0_8.mode == IslandTradePage.MODE_PURCHAS then
			return arg0_9.value < arg1_9.value
		end
	end)

	local var1_8 = {}

	for iter2_8, iter3_8 in ipairs(var0_8) do
		var1_8[iter3_8.id] = iter2_8
	end

	return var1_8
end

function var0_0.GetDislays(arg0_10)
	local var0_10
	local var1_10

	if arg0_10.mode == IslandTradePage.MODE_SELL then
		var0_10, var1_10 = getProxy(IslandProxy):GetIsland():GetTradeAgency():GetSellRanks()
	elseif arg0_10.mode == IslandTradePage.MODE_PURCHAS then
		var0_10, var1_10 = getProxy(IslandProxy):GetIsland():GetTradeAgency():GetRanks()
	end

	local var2_10 = {}

	for iter0_10, iter1_10 in ipairs(var0_10) do
		table.insert(var2_10, iter1_10)
	end

	table.sort(var2_10, function(arg0_11, arg1_11)
		if arg0_10.mode == IslandTradePage.MODE_SELL then
			return arg0_11.value > arg1_11.value
		elseif arg0_10.mode == IslandTradePage.MODE_PURCHAS then
			return arg0_11.value < arg1_11.value
		end
	end)

	return var1_10, var2_10
end

function var0_0.RequestRank(arg0_12, arg1_12)
	arg0_12:emit(IslandBaseMediator.REQ_TRADE_RANK, arg1_12)
end

function var0_0.DisplayResult(arg0_13, arg1_13)
	arg0_13.displays = {}

	for iter0_13, iter1_13 in ipairs(arg1_13) do
		table.insert(arg0_13.displays, iter1_13)
	end

	table.sort(arg0_13.displays, function(arg0_14, arg1_14)
		if arg0_13.mode == IslandTradePage.MODE_SELL then
			return arg0_14.value > arg1_14.value
		elseif arg0_13.mode == IslandTradePage.MODE_PURCHAS then
			return arg0_14.value < arg1_14.value
		end
	end)

	local var0_13 = #arg0_13.displays

	arg0_13.scrollrect:SetTotalCount(var0_13)
end

function var0_0.OnInitItem(arg0_15, arg1_15)
	local var0_15 = IslandTradeRankCard.New(arg1_15)

	onButton(arg0_15, var0_15.visitBtn, function()
		arg0_15:emit(IslandBaseMediator.ENTER_ISLAND, var0_15.id)
	end, SFX_PANEL)

	arg0_15.cards[arg1_15] = var0_15
end

function var0_0.OnUpdateItem(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.cards[arg2_17]

	if not var0_17 then
		arg0_17:OnInitItem(arg2_17)

		var0_17 = arg0_17.cards[arg2_17]
	end

	local var1_17 = arg0_17.displays[arg1_17 + 1]
	local var2_17 = arg0_17.rankNums[var1_17.id]

	var0_17:Update(var2_17, var1_17, arg1_17)
end

function var0_0.UpdateSelfRank(arg0_18, arg1_18)
	local var0_18 = arg0_18.rankNums[arg1_18.id]

	arg0_18.selfRankCard:Update(var0_18, arg1_18, 0)
	onButton(arg0_18, arg0_18.selfRankCard.inviteBtn, function()
		arg0_18:emit(IslandTradePage.OPEN_INVITE_PAGE)
	end, SFX_PANEL)
end

function var0_0.OnDestory(arg0_20)
	ClearLScrollrect(arg0_20.scrollrect)

	for iter0_20, iter1_20 in pairs(arg0_20.cards) do
		iter1_20:Dispose()
	end

	arg0_20.cards = nil

	arg0_20.selfRankCard:Dispose()
end

return var0_0
