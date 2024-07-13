local var0_0 = class("VoteFinalsRaceShipsPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "FinalsRaceShips"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.num1TF = arg0_2:findTF("content/head/num1")
	arg0_2.num2TF = arg0_2:findTF("content/head/num2")
	arg0_2.num3TF = arg0_2:findTF("content/head/num3")
	arg0_2.UIlist = UIItemList.New(arg0_2:findTF("content/ships"), arg0_2:findTF("content/ships/ship_tpl"))
end

function var0_0.SetCallBack(arg0_3, arg1_3)
	arg0_3.CallBack = arg1_3
end

function var0_0.Update(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4.voteGroup = arg1_4
	arg0_4.count = arg3_4
	arg0_4.phase = arg1_4:GetStage()
	arg0_4.displays = {}
	arg0_4.topList = {}

	local var0_4 = arg1_4:GetRankList()

	for iter0_4, iter1_4 in ipairs(arg2_4) do
		if iter1_4.group == var0_4[1].group or iter1_4.group == var0_4[2].group or iter1_4.group == var0_4[3].group then
			table.insert(arg0_4.topList, iter1_4)
		else
			table.insert(arg0_4.displays, iter1_4)
		end
	end

	arg0_4:UpdateTop3(var0_4[1], var0_4[2], var0_4[3])
	arg0_4:UpdateShips()
	arg0_4:Show()
end

function var0_0.UpdateTop3(arg0_5, arg1_5, arg2_5, arg3_5)
	arg0_5:UpdateVoteShip(arg0_5.num1TF, arg1_5)
	arg0_5:UpdateVoteShip(arg0_5.num2TF, arg2_5)
	arg0_5:UpdateVoteShip(arg0_5.num3TF, arg3_5)
	setActive(arg0_5.num1TF, _.any(arg0_5.topList, function(arg0_6)
		return arg0_6.group == arg1_5.group
	end))
	setActive(arg0_5.num2TF, _.any(arg0_5.topList, function(arg0_7)
		return arg0_7.group == arg2_5.group
	end))
	setActive(arg0_5.num3TF, _.any(arg0_5.topList, function(arg0_8)
		return arg0_8.group == arg3_5.group
	end))
end

function var0_0.UpdateShips(arg0_9)
	arg0_9.UIlist:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_9.displays[arg1_10 + 1]
			local var1_10 = VoteShipItem.New(arg2_10)

			var1_10:update(var0_10)
			onButton(arg0_9, var1_10.go, function()
				if arg0_9.CallBack and arg0_9.phase == VoteGroup.VOTE_STAGE then
					arg0_9.CallBack(var1_10, var1_10.voteShip.votes)
				end
			end, SFX_PANEL)
		end
	end)
	arg0_9.UIlist:align(math.max(#arg0_9.displays, 0))
end

function var0_0.contains(arg0_12, arg1_12, arg2_12)
	return _.any(arg1_12, function(arg0_13)
		return arg0_13.group == arg2_12.group
	end)
end

function var0_0.UpdateVoteShip(arg0_14, arg1_14, arg2_14)
	if not arg2_14 then
		setActive(arg1_14, false)

		return
	end

	setText(arg1_14:Find("name"), shortenString(arg2_14:getShipName(), 5))

	local var0_14 = arg2_14:getPainting()

	arg0_14:LoadPainting(arg1_14:Find("mask"), var0_14)
	onButton(arg0_14, arg1_14, function()
		if arg0_14.CallBack and arg0_14.phase == VoteGroup.VOTE_STAGE then
			arg0_14.CallBack({
				voteShip = arg2_14
			}, arg2_14.votes)
		end
	end, SFX_PANEL)
end

function var0_0.LoadPainting(arg0_16, arg1_16, arg2_16)
	LoadSpriteAsync("VoteShips/" .. arg2_16, function(arg0_17)
		setImageSprite(arg1_16:Find("icon"), arg0_17, false)
	end)
end

function var0_0.OnDestroy(arg0_18)
	return
end

return var0_0
