local var0 = class("VotePreRaceShipPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "PreRaceShips"
end

function var0.OnInit(arg0)
	arg0.scrollRect = arg0._tf:GetComponent("LScrollRect")
	arg0.voteItems = {}

	function arg0.scrollRect.onInitItem(arg0)
		arg0:onInitItem(arg0)
	end

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1)
	end

	function arg0.scrollRect.onReturnItem(arg0, arg1)
		arg0:onReturnItem(arg0, arg1)
	end

	arg0._tf:SetAsFirstSibling()
end

function var0.onInitItem(arg0, arg1)
	local var0 = VoteShipItem.New(arg1)

	onButton(arg0, var0.go, function()
		if arg0.phase == VoteGroup.VOTE_STAGE then
			arg0.CallBack(var0)
		end
	end, SFX_PANEL)

	arg0.voteItems[arg1] = var0
end

function var0.SetCallBack(arg0, arg1)
	arg0.CallBack = arg1
end

function var0.onUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.voteItems[arg2]

	if not var0 then
		arg0:onInitItem(arg2)

		var0 = arg0.voteItems[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]

	arg0:UpdateShip(arg1, var0, var1)
end

function var0.UpdateShip(arg0, arg1, arg2, arg3)
	if arg0.phase ~= VoteGroup.VOTE_STAGE then
		local var0 = arg0.voteGroup:GetRank(arg3)
		local var1, var2 = arg0.voteGroup:CanRankToNextTurn(var0)

		arg2:update(arg3, {
			rank = var0,
			riseFlag = var1,
			resurgenceFlag = var2
		})
	else
		arg2:update(arg3, nil)
	end
end

function var0.onReturnItem(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.voteItems[arg2]

	if var0 then
		var0:clear()
	end
end

function var0.Update(arg0, arg1, arg2)
	arg0.voteGroup = arg1
	arg0.phase = arg1:GetStage()
	arg0.displays = arg2

	arg0:UpdateShips()
	arg0:Show()
end

function var0.UpdateShips(arg0)
	if arg0.phase == VoteGroup.VOTE_STAGE then
		shuffle(arg0.displays)
	end

	arg0.scrollRect:SetTotalCount(#arg0.displays)
end

function var0.OnDestroy(arg0)
	return
end

return var0
