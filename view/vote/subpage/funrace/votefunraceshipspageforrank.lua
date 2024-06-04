local var0 = class("VoteFunRaceShipsPageForRank", import("..FinalsRece.VoteFinalsRaceShipsPageForRank"))

function var0.getUIName(arg0)
	local var0 = arg0.contextData.voteGroup

	if var0:IsFunMetaRace() then
		return "FinalsRaceShipsRankForMeta"
	elseif var0:IsFunSireRace() then
		return "FinalsRaceShipsRankForSire"
	elseif var0:IsFunKidRace() then
		return "FinalsRaceShipsRankForKid"
	else
		assert(false)
	end
end

return var0
