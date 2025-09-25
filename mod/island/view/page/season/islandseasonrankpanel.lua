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

	arg0_3.playerCard = IslandRankCard.New(arg0_3.playerRankTF, IslandRankCard.TYPE_SELF)
	arg0_3.newestId = IslandSeasonAgency.GetCurrentSeason()

	if arg0_3.newestId > 1 then
		arg0_3.switchPanel = IslandSeasonSwitchPanel.New(arg0_3._tf, arg0_3.event, setmetatable({
			count = arg0_3.newestId,
			onSelected = function(arg0_6)
				arg0_3:Flush(arg0_6)
			end,
			defaultSelId = arg0_3.newestId
		}, {
			__index = arg0_3.contextData
		}))
	end
end

function var0_0.OnInitItem(arg0_7, arg1_7)
	local var0_7 = IslandRankCard.New(arg1_7, IslandRankCard.TYPE_OTHER)

	arg0_7.cards[arg1_7] = var0_7
end

function var0_0.OnUpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.cards[arg2_8]

	if not var0_8 then
		arg0_8:OnInitItem(arg2_8)

		var0_8 = arg0_8.cards[arg2_8]
	end

	local var1_8 = arg0_8.displayRankVOs[arg1_8 + 1]

	var0_8:Update(var1_8, arg0_8.seasonId)
end

function var0_0.Show(arg0_9)
	arg0_9.super.Show(arg0_9)

	if arg0_9.newestId == 1 then
		arg0_9:Flush(arg0_9.newestId)
	else
		arg0_9.switchPanel:ExecuteAction("Show")
	end

	IslandGuideChecker.CheckGuide("ISLAND_GUIDE_17")
end

function var0_0.Flush(arg0_10, arg1_10)
	arg0_10.seasonId = arg1_10

	if not arg0_10.rankVOs[arg0_10.seasonId] or getProxy(BillboardProxy):canFetch(arg0_10.rankType, arg0_10.seasonId) then
		arg0_10:emit(IslandMediator.ON_GET_SEASON_RANK, arg0_10.rankType, arg0_10.seasonId)
	else
		arg0_10:UpdataRankView()
	end
end

function var0_0.UpdateRankVOs(arg0_11, arg1_11, arg2_11, arg3_11)
	arg0_11.rankVOs[arg1_11] = arg2_11
	arg0_11.playerRankVOs[arg1_11] = arg3_11
end

function var0_0.UpdataRankView(arg0_12)
	arg0_12.displayRankVOs = {}

	local var0_12 = arg0_12.rankVOs[arg0_12.seasonId]

	for iter0_12, iter1_12 in ipairs(arg0_12.rankVOs[arg0_12.seasonId]) do
		table.insert(arg0_12.displayRankVOs, iter1_12)
	end

	arg0_12.rankRect:SetTotalCount(#arg0_12.displayRankVOs)
	setActive(arg0_12.listEmptyTF, #arg0_12.displayRankVOs <= 0)

	local var1_12 = arg0_12.playerRankVOs[arg0_12.seasonId]

	setActive(arg0_12.playerRankTF, var1_12)

	if var1_12 then
		arg0_12.playerCard:Update(var1_12, arg0_12.seasonId)
	end

	setActive(arg0_12.tipTF, arg0_12.seasonId == arg0_12.newestId)
end

function var0_0.OnDestory(arg0_13)
	ClearLScrollrect(arg0_13.rankRect)

	for iter0_13, iter1_13 in ipairs(arg0_13.cards) do
		iter1_13:Dispose()
	end

	arg0_13.cards = nil

	arg0_13.playerCard:Dispose()
end

return var0_0
