local var0_0 = class("VoteFunRaceShipsPageForRank", import("..FinalsRece.VoteFinalsRaceShipsPageForRank"))

function var0_0.getUIName(arg0_1)
	local var0_1 = arg0_1.contextData.voteGroup

	if var0_1:IsFunMetaRace() then
		return "FinalsRaceShipsRankForMeta"
	elseif var0_1:IsFunSireRace() then
		return "FinalsRaceShipsRankForSire"
	elseif var0_1:IsFunKidRace() then
		return "FinalsRaceShipsRankForKid"
	else
		assert(false)
	end
end

return var0_0
