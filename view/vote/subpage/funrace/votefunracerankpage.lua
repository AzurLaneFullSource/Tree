local var0 = class("VoteFunRaceRankPage", import("..FinalsRece.VoteFinalsRaceRankPage"))

function var0.getUIName(arg0)
	local var0 = arg0.contextData.voteGroup

	if var0:IsFunMetaRace() then
		return "FinalsRaceRankForMeta"
	elseif var0:IsFunSireRace() then
		return "FinalsRaceRankForSire"
	elseif var0:IsFunKidRace() then
		return "FinalsRaceRankForKid"
	else
		assert(false)
	end
end

return var0
