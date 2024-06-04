local var0 = class("VoteFinalsRaceShipsPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "FinalsRaceShips"
end

function var0.OnLoaded(arg0)
	arg0.num1TF = arg0:findTF("content/head/num1")
	arg0.num2TF = arg0:findTF("content/head/num2")
	arg0.num3TF = arg0:findTF("content/head/num3")
	arg0.UIlist = UIItemList.New(arg0:findTF("content/ships"), arg0:findTF("content/ships/ship_tpl"))
end

function var0.SetCallBack(arg0, arg1)
	arg0.CallBack = arg1
end

function var0.Update(arg0, arg1, arg2, arg3)
	arg0.voteGroup = arg1
	arg0.count = arg3
	arg0.phase = arg1:GetStage()
	arg0.displays = {}
	arg0.topList = {}

	local var0 = arg1:GetRankList()

	for iter0, iter1 in ipairs(arg2) do
		if iter1.group == var0[1].group or iter1.group == var0[2].group or iter1.group == var0[3].group then
			table.insert(arg0.topList, iter1)
		else
			table.insert(arg0.displays, iter1)
		end
	end

	arg0:UpdateTop3(var0[1], var0[2], var0[3])
	arg0:UpdateShips()
	arg0:Show()
end

function var0.UpdateTop3(arg0, arg1, arg2, arg3)
	arg0:UpdateVoteShip(arg0.num1TF, arg1)
	arg0:UpdateVoteShip(arg0.num2TF, arg2)
	arg0:UpdateVoteShip(arg0.num3TF, arg3)
	setActive(arg0.num1TF, _.any(arg0.topList, function(arg0)
		return arg0.group == arg1.group
	end))
	setActive(arg0.num2TF, _.any(arg0.topList, function(arg0)
		return arg0.group == arg2.group
	end))
	setActive(arg0.num3TF, _.any(arg0.topList, function(arg0)
		return arg0.group == arg3.group
	end))
end

function var0.UpdateShips(arg0)
	arg0.UIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.displays[arg1 + 1]
			local var1 = VoteShipItem.New(arg2)

			var1:update(var0)
			onButton(arg0, var1.go, function()
				if arg0.CallBack and arg0.phase == VoteGroup.VOTE_STAGE then
					arg0.CallBack(var1, var1.voteShip.votes)
				end
			end, SFX_PANEL)
		end
	end)
	arg0.UIlist:align(math.max(#arg0.displays, 0))
end

function var0.contains(arg0, arg1, arg2)
	return _.any(arg1, function(arg0)
		return arg0.group == arg2.group
	end)
end

function var0.UpdateVoteShip(arg0, arg1, arg2)
	if not arg2 then
		setActive(arg1, false)

		return
	end

	setText(arg1:Find("name"), shortenString(arg2:getShipName(), 5))

	local var0 = arg2:getPainting()

	arg0:LoadPainting(arg1:Find("mask"), var0)
	onButton(arg0, arg1, function()
		if arg0.CallBack and arg0.phase == VoteGroup.VOTE_STAGE then
			arg0.CallBack({
				voteShip = arg2
			}, arg2.votes)
		end
	end, SFX_PANEL)
end

function var0.LoadPainting(arg0, arg1, arg2)
	LoadSpriteAsync("VoteShips/" .. arg2, function(arg0)
		setImageSprite(arg1:Find("icon"), arg0, false)
	end)
end

function var0.OnDestroy(arg0)
	return
end

return var0
