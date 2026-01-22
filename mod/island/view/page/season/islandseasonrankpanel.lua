local var0_0 = class("IslandSeasonRankPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandSeasonRankPanel"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("content")

	arg0_2.tipTF = var0_2:Find("tip")

	setText(arg0_2.tipTF, i18n("island_season_charts_refresh"))

	local var1_2 = var0_2:Find("header")

	setText(var1_2:Find("rank"), i18n("island_season_charts_ranking"))
	setText(var1_2:Find("info"), i18n("island_season_charts_information"))
	setText(var1_2:Find("pt"), i18n("island_season_charts_pt"))
	setText(var1_2:Find("award"), i18n("island_season_charts_award"))

	arg0_2.playerRankTF = var0_2:Find("player_rank")

	setActive(arg0_2.playerRankTF, false)

	arg0_2.rankRect = var0_2:Find("ranks"):GetComponent("LScrollRect")
	arg0_2.listEmptyTF = var0_2:Find("ranks/empty")
end

function var0_0.OnInit(arg0_3)
	arg0_3.rankType = PowerRank.TYPE_ISLAND_SEASON_PT
	arg0_3.cards = {}
	arg0_3.rankVOs = {}
	arg0_3.playerRankVOs = {}

	function arg0_3.rankRect.onInitItem(arg0_4)
		arg0_3:OnInitItem(arg0_4)
	end

	function arg0_3.rankRect.onUpdateItem(arg0_5, arg1_5)
		arg0_3:OnUpdateItem(arg0_5, arg1_5)
	end

	arg0_3.playerCard = IslandRankCard.New(arg0_3.playerRankTF, IslandRankCard.TYPE_SELF, arg0_3)
	arg0_3.newestId = IslandSeasonAgency.GetCurrentSeason()
end

function var0_0.OnInitItem(arg0_6, arg1_6)
	local var0_6 = IslandRankCard.New(arg1_6, IslandRankCard.TYPE_OTHER, arg0_6)

	arg0_6.cards[arg1_6] = var0_6
end

function var0_0.OnUpdateItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.cards[arg2_7]

	if not var0_7 then
		arg0_7:OnInitItem(arg2_7)

		var0_7 = arg0_7.cards[arg2_7]
	end

	local var1_7 = arg0_7.displayRankVOs[arg1_7 + 1]

	var0_7:Update(var1_7, arg0_7.seasonId)
end

function var0_0.Show(arg0_8)
	arg0_8.super.Show(arg0_8)
	arg0_8:Flush(arg0_8.newestId)
	IslandGuideChecker.CheckGuide("ISLAND_GUIDE_17")
end

function var0_0.Flush(arg0_9, arg1_9)
	arg0_9.seasonId = arg1_9

	if not arg0_9.rankVOs[arg0_9.seasonId] or getProxy(BillboardProxy):canFetch(arg0_9.rankType, arg0_9.seasonId) then
		arg0_9:emit(IslandMediator.ON_GET_SEASON_RANK, arg0_9.rankType, arg0_9.seasonId)
	else
		arg0_9:UpdataRankView()
	end
end

function var0_0.UpdateRankVOs(arg0_10, arg1_10, arg2_10, arg3_10)
	arg0_10.rankVOs[arg1_10] = arg2_10
	arg0_10.playerRankVOs[arg1_10] = arg3_10
end

function var0_0.UpdataRankView(arg0_11)
	arg0_11.displayRankVOs = {}

	local var0_11 = arg0_11.rankVOs[arg0_11.seasonId]

	for iter0_11, iter1_11 in ipairs(arg0_11.rankVOs[arg0_11.seasonId] or {}) do
		table.insert(arg0_11.displayRankVOs, iter1_11)
	end

	arg0_11.rankRect:SetTotalCount(#arg0_11.displayRankVOs)
	setActive(arg0_11.listEmptyTF, #arg0_11.displayRankVOs <= 0)

	local var1_11 = arg0_11.playerRankVOs[arg0_11.seasonId]

	setActive(arg0_11.playerRankTF, var1_11)

	if var1_11 then
		arg0_11.playerCard:Update(var1_11, arg0_11.seasonId)
	end

	setActive(arg0_11.tipTF, arg0_11.seasonId == arg0_11.newestId)
end

function var0_0.OnDestory(arg0_12)
	ClearLScrollrect(arg0_12.rankRect)

	for iter0_12, iter1_12 in ipairs(arg0_12.cards) do
		iter1_12:Dispose()
	end

	arg0_12.cards = nil

	arg0_12.playerCard:Dispose()
end

return var0_0
