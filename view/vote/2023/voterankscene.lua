local var0_0 = class("VoteRankScene", import("..VoteScene"))

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)
	setActive(arg0_1:findTF("blur_panel/adapt/top/title_rank"), true)
	setActive(arg0_1:findTF("blur_panel/adapt/top/title"), false)
	setActive(arg0_1:findTF("main/right_panel/filter_bg"), false)
	setActive(arg0_1:findTF("main/right_panel/title/help"), false)
	setActive(arg0_1:findTF("main/right_panel/title/schedule"), false)
	setActive(arg0_1:findTF("main/right_panel/title/Text"), false)
end

function var0_0.GetPageMap(arg0_2)
	return {
		[VoteConst.RACE_TYPE_PRE] = {
			VotePreRaceShipPage,
			VoteGroupRaceRankPage
		},
		[VoteConst.RACE_TYPE_GROUP] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[VoteConst.RACE_TYPE_RESURGENCE] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[VoteConst.RACE_TYPE_FINAL] = {
			VoteFinalsRaceShipsPageForRank,
			VoteFinalsRaceRankPage
		},
		[VoteConst.RACE_TYPE_PRE_RESURGENCE] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[VoteConst.RACE_TYPE_FUN] = {
			VoteFunRaceShipsPageForRank,
			VoteFunRaceRankPage
		}
	}
end

function var0_0.initShips(arg0_3)
	arg0_3.displays = {}

	local var0_3 = arg0_3.contextData.voteGroup:GetRankList()
	local var1_3 = getInputText(arg0_3.search)

	for iter0_3, iter1_3 in ipairs(var0_3) do
		table.insert(arg0_3.displays, iter1_3)
	end

	local var2_3 = arg0_3:GetVotes()

	arg0_3.shipsPage:ExecuteAction("Update", arg0_3.contextData.voteGroup, arg0_3.displays, var2_3)
end

return var0_0
