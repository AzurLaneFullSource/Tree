local var0_0 = class("FunRaceShipsPage", import("..FinalsRece.VoteFinalsRaceShipsPage"))

function var0_0.getUIName(arg0_1)
	local var0_1 = arg0_1.contextData.voteGroup

	if var0_1:IsFunMetaRace() then
		return "FinalsRaceShipsForMeta"
	elseif var0_1:IsFunSireRace() then
		return "FinalsRaceShipsForSire"
	elseif var0_1:IsFunKidRace() then
		return "FinalsRaceShipsForKid"
	else
		assert(false)
	end
end

return var0_0
