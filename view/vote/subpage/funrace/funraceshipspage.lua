local var0 = class("FunRaceShipsPage", import("..FinalsRece.VoteFinalsRaceShipsPage"))

function var0.getUIName(arg0)
	local var0 = arg0.contextData.voteGroup

	if var0:IsFunMetaRace() then
		return "FinalsRaceShipsForMeta"
	elseif var0:IsFunSireRace() then
		return "FinalsRaceShipsForSire"
	elseif var0:IsFunKidRace() then
		return "FinalsRaceShipsForKid"
	else
		assert(false)
	end
end

return var0
