local var0 = class("VoteGroupRaceShipPage", import("..PreRace.VotePreRaceShipPage"))

function var0.getUIName(arg0)
	return "GroupRaceShips"
end

function var0.onInitItem(arg0, arg1)
	var0.super.onInitItem(arg0, arg1)

	local var0 = arg0.voteItems[arg1]

	onButton(arg0, var0.go, function()
		if arg0.CallBack and arg0.phase == VoteGroup.VOTE_STAGE then
			arg0.CallBack(var0, var0.voteShip.votes)
		end
	end, SFX_PANEL)
end

function var0.UpdateShips(arg0, arg1, arg2)
	arg0.scrollRect:SetTotalCount(#arg0.displays)
end

function var0.OnDestroy(arg0)
	return
end

return var0
