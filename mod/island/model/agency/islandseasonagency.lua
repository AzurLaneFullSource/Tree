local var0_0 = class("IslandSeasonAgency", import(".IslandBaseAgency"))

var0_0.ADD_PT = "IslandSeasonAgency.ADD_PT"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.season = IslandSeason.New(arg1_1.season)
	arg0_1.reviews = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.season_review_list or {}) do
		arg0_1.reviews[iter1_1.id] = IslandSeasonReview.New(iter1_1)
	end
end

function var0_0.NeedReset(arg0_2)
	return arg0_2.season.id < var0_0.GetCurrentSeason()
end

function var0_0.Reset(arg0_3, arg1_3)
	arg0_3.season = IslandSeason.New({
		id = var0_0.GetCurrentSeason()
	})

	if arg1_3 then
		arg0_3.reviews[arg1_3.id] = arg1_3
	end
end

function var0_0.IsShowResetTip(arg0_4)
	return arg0_4.season:NeedTip()
end

function var0_0.SetResetTipFlag(arg0_5, arg1_5)
	arg0_5.season:SetTipFlag(arg1_5)
end

function var0_0.GetSeason(arg0_6)
	return arg0_6.season
end

function var0_0.AddPt(arg0_7, arg1_7)
	arg0_7.season:AddPt(arg1_7)
	arg0_7:DispatchEvent(var0_0.ADD_PT)
end

function var0_0.GetReviewData(arg0_8, arg1_8)
	return arg0_8.reviews[arg1_8]
end

function var0_0.GetHighestRank(arg0_9)
	local var0_9 = math.huge

	for iter0_9, iter1_9 in pairs(arg0_9.reviews) do
		local var1_9 = iter1_9:GetRecordData(IslandSeasonReview.KEYS.PT_RANK)

		if var1_9 < var0_9 then
			var0_9 = var1_9
		end
	end

	return var0_9
end

function var0_0.GetSeasonNum(arg0_10)
	return #underscore.keys(arg0_10.reviews) + (arg0_10.season:GetPt() > 0 and 1 or 0)
end

function var0_0.IsCurSeasonPtZero(arg0_11)
	return arg0_11.season:GetPt() == 0
end

function var0_0.GetCurrentSeason()
	local var0_12 = Clone(pg.island_season.all)

	return var0_12[#var0_12]
end

return var0_0
