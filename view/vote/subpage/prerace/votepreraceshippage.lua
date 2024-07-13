local var0_0 = class("VotePreRaceShipPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PreRaceShips"
end

function var0_0.OnInit(arg0_2)
	arg0_2.scrollRect = arg0_2._tf:GetComponent("LScrollRect")
	arg0_2.voteItems = {}

	function arg0_2.scrollRect.onInitItem(arg0_3)
		arg0_2:onInitItem(arg0_3)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:onUpdateItem(arg0_4, arg1_4)
	end

	function arg0_2.scrollRect.onReturnItem(arg0_5, arg1_5)
		arg0_2:onReturnItem(arg0_5, arg1_5)
	end

	arg0_2._tf:SetAsFirstSibling()
end

function var0_0.onInitItem(arg0_6, arg1_6)
	local var0_6 = VoteShipItem.New(arg1_6)

	onButton(arg0_6, var0_6.go, function()
		if arg0_6.phase == VoteGroup.VOTE_STAGE then
			arg0_6.CallBack(var0_6)
		end
	end, SFX_PANEL)

	arg0_6.voteItems[arg1_6] = var0_6
end

function var0_0.SetCallBack(arg0_8, arg1_8)
	arg0_8.CallBack = arg1_8
end

function var0_0.onUpdateItem(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.voteItems[arg2_9]

	if not var0_9 then
		arg0_9:onInitItem(arg2_9)

		var0_9 = arg0_9.voteItems[arg2_9]
	end

	local var1_9 = arg0_9.displays[arg1_9 + 1]

	arg0_9:UpdateShip(arg1_9, var0_9, var1_9)
end

function var0_0.UpdateShip(arg0_10, arg1_10, arg2_10, arg3_10)
	if arg0_10.phase ~= VoteGroup.VOTE_STAGE then
		local var0_10 = arg0_10.voteGroup:GetRank(arg3_10)
		local var1_10, var2_10 = arg0_10.voteGroup:CanRankToNextTurn(var0_10)

		arg2_10:update(arg3_10, {
			rank = var0_10,
			riseFlag = var1_10,
			resurgenceFlag = var2_10
		})
	else
		arg2_10:update(arg3_10, nil)
	end
end

function var0_0.onReturnItem(arg0_11, arg1_11, arg2_11)
	if arg0_11.exited then
		return
	end

	local var0_11 = arg0_11.voteItems[arg2_11]

	if var0_11 then
		var0_11:clear()
	end
end

function var0_0.Update(arg0_12, arg1_12, arg2_12)
	arg0_12.voteGroup = arg1_12
	arg0_12.phase = arg1_12:GetStage()
	arg0_12.displays = arg2_12

	arg0_12:UpdateShips()
	arg0_12:Show()
end

function var0_0.UpdateShips(arg0_13)
	if arg0_13.phase == VoteGroup.VOTE_STAGE then
		shuffle(arg0_13.displays)
	end

	arg0_13.scrollRect:SetTotalCount(#arg0_13.displays)
end

function var0_0.OnDestroy(arg0_14)
	return
end

return var0_0
