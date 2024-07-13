local var0_0 = class("VoteGroupRaceShipPage", import("..PreRace.VotePreRaceShipPage"))

function var0_0.getUIName(arg0_1)
	return "GroupRaceShips"
end

function var0_0.onInitItem(arg0_2, arg1_2)
	var0_0.super.onInitItem(arg0_2, arg1_2)

	local var0_2 = arg0_2.voteItems[arg1_2]

	onButton(arg0_2, var0_2.go, function()
		if arg0_2.CallBack and arg0_2.phase == VoteGroup.VOTE_STAGE then
			arg0_2.CallBack(var0_2, var0_2.voteShip.votes)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateShips(arg0_4, arg1_4, arg2_4)
	arg0_4.scrollRect:SetTotalCount(#arg0_4.displays)
end

function var0_0.OnDestroy(arg0_5)
	return
end

return var0_0
