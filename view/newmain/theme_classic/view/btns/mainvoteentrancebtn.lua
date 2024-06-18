local var0_0 = class("MainVoteEntranceBtn", import(".MainBaseSpcailActBtn"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root.parent:Find("eventPanel")
end

function var0_0.InShowTime(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	return var0_2 and not var0_2:isEnd()
end

function var0_0.GetUIName(arg0_3)
	return "MainUIVoteActBtn"
end

function var0_0.OnClick(arg0_4)
	arg0_4.event:emit(NewMainMediator.GO_SCENE, SCENE.VOTEENTRANCE)
end

function var0_0.OnInit(arg0_5)
	setActive(arg0_5._tf:Find("tip"), arg0_5:ShouldTipNewRace() or arg0_5:ShouldTipVotes() or arg0_5:ShouldTipAward() or arg0_5:ShouldTipFinalAward())

	local var0_5 = getProxy(VoteProxy):IsAllRaceEnd()
	local var1_5 = arg0_5:AnyVoteActIsOpening()

	setActive(arg0_5._tf:Find("unopen"), not var0_5 and var1_5)
	setActive(arg0_5._tf:Find("end"), var0_5)

	arg0_5._tf:GetComponent(typeof(Image)).enabled = not var0_5 and not var1_5
end

function var0_0.AnyVoteActIsOpening(arg0_6)
	return getProxy(VoteProxy):AnyVoteActIsOpening()
end

function var0_0.ShouldTipFinalAward(arg0_7)
	local var0_7 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	if not var0_7 or var0_7:isEnd() then
		return false
	end

	local var1_7 = var0_7:getConfig("config_client")[2] or -1
	local var2_7 = getProxy(TaskProxy):getTaskById(var1_7) or getProxy(TaskProxy):getFinishTaskById(var1_7)

	return var2_7 and var2_7:isFinish() and not var2_7:isReceive()
end

function var0_0.ShouldTipNewRace(arg0_8)
	local var0_8 = getProxy(VoteProxy):GetVoteGroupList()
	local var1_8 = getProxy(PlayerProxy):getRawData().id

	for iter0_8, iter1_8 in ipairs(var0_8) do
		if iter1_8 and iter1_8:IsOpening() and getProxy(VoteProxy):IsNewRace(iter1_8) then
			return true
		end
	end

	return false
end

function var0_0.ShouldTipVotes(arg0_9)
	local var0_9 = getProxy(VoteProxy):GetVoteGroupList()

	for iter0_9, iter1_9 in ipairs(var0_9) do
		if getProxy(VoteProxy):GetVotesByConfigId(iter1_9.configId) > 0 then
			return true
		end
	end

	return false
end

function var0_0.ShouldTipAward(arg0_10)
	return getProxy(VoteProxy):ExistPastVoteAward()
end

return var0_0
