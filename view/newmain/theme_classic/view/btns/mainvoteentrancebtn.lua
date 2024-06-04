local var0 = class("MainVoteEntranceBtn", import(".MainBaseSpcailActBtn"))

function var0.GetContainer(arg0)
	return arg0.root.parent:Find("eventPanel")
end

function var0.InShowTime(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	return var0 and not var0:isEnd()
end

function var0.GetUIName(arg0)
	return "MainUIVoteActBtn"
end

function var0.OnClick(arg0)
	arg0.event:emit(NewMainMediator.GO_SCENE, SCENE.VOTEENTRANCE)
end

function var0.OnInit(arg0)
	setActive(arg0._tf:Find("tip"), arg0:ShouldTipNewRace() or arg0:ShouldTipVotes() or arg0:ShouldTipAward() or arg0:ShouldTipFinalAward())

	local var0 = getProxy(VoteProxy):IsAllRaceEnd()
	local var1 = arg0:AnyVoteActIsOpening()

	setActive(arg0._tf:Find("unopen"), not var0 and var1)
	setActive(arg0._tf:Find("end"), var0)

	arg0._tf:GetComponent(typeof(Image)).enabled = not var0 and not var1
end

function var0.AnyVoteActIsOpening(arg0)
	return getProxy(VoteProxy):AnyVoteActIsOpening()
end

function var0.ShouldTipFinalAward(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	if not var0 or var0:isEnd() then
		return false
	end

	local var1 = var0:getConfig("config_client")[2] or -1
	local var2 = getProxy(TaskProxy):getTaskById(var1) or getProxy(TaskProxy):getFinishTaskById(var1)

	return var2 and var2:isFinish() and not var2:isReceive()
end

function var0.ShouldTipNewRace(arg0)
	local var0 = getProxy(VoteProxy):GetVoteGroupList()
	local var1 = getProxy(PlayerProxy):getRawData().id

	for iter0, iter1 in ipairs(var0) do
		if iter1 and iter1:IsOpening() and getProxy(VoteProxy):IsNewRace(iter1) then
			return true
		end
	end

	return false
end

function var0.ShouldTipVotes(arg0)
	local var0 = getProxy(VoteProxy):GetVoteGroupList()

	for iter0, iter1 in ipairs(var0) do
		if getProxy(VoteProxy):GetVotesByConfigId(iter1.configId) > 0 then
			return true
		end
	end

	return false
end

function var0.ShouldTipAward(arg0)
	return getProxy(VoteProxy):ExistPastVoteAward()
end

return var0
