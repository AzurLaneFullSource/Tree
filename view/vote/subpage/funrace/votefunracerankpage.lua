local var0_0 = class("VoteFunRaceRankPage", import("..FinalsRece.VoteFinalsRaceRankPage"))

function var0_0.getUIName(arg0_1)
	local var0_1 = arg0_1.contextData.voteGroup

	if var0_1:IsFunMetaRace() then
		return "FinalsRaceRankForMeta"
	elseif var0_1:IsFunSireRace() then
		return "FinalsRaceRankForSire"
	elseif var0_1:IsFunKidRace() then
		return "FinalsRaceRankForKid"
	else
		assert(false)
	end
end

return var0_0
