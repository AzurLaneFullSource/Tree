local var0 = class("VoteRankScene", import("..VoteScene"))

function var0.init(arg0)
	var0.super.init(arg0)
	setActive(arg0:findTF("blur_panel/adapt/top/title_rank"), true)
	setActive(arg0:findTF("blur_panel/adapt/top/title"), false)
	setActive(arg0:findTF("main/right_panel/filter_bg"), false)
	setActive(arg0:findTF("main/right_panel/title/help"), false)
	setActive(arg0:findTF("main/right_panel/title/schedule"), false)
	setActive(arg0:findTF("main/right_panel/title/Text"), false)
end

function var0.GetPageMap(arg0)
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

function var0.initShips(arg0)
	arg0.displays = {}

	local var0 = arg0.contextData.voteGroup:GetRankList()
	local var1 = getInputText(arg0.search)

	for iter0, iter1 in ipairs(var0) do
		table.insert(arg0.displays, iter1)
	end

	local var2 = arg0:GetVotes()

	arg0.shipsPage:ExecuteAction("Update", arg0.contextData.voteGroup, arg0.displays, var2)
end

return var0
