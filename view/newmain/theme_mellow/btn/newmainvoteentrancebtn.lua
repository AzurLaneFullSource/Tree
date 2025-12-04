local var0_0 = class("NewMainVoteEntranceBtn")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1.event = arg2_1
end

function var0_0.Init(arg0_2, arg1_2)
	arg0_2.tip = arg0_2._tf:Find("tip")

	setActive(arg0_2.tip, arg0_2:IsShowTip())
	onButton(arg0_2, arg0_2._tf, function()
		arg0_2.event:emit(NewMainMediator.GO_SCENE, SCENE.VOTEENTRANCE)
	end, SFX_MAIN)

	local var0_2 = getProxy(VoteProxy):IsAllRaceEnd()
	local var1_2 = arg0_2:AnyVoteActIsOpening()

	setActive(arg0_2._tf:Find("unopen"), not var0_2 and var1_2)
	setActive(arg0_2._tf:Find("end"), var0_2)

	arg0_2._tf:GetComponent(typeof(Image)).enabled = not var0_2 and not var1_2
end

function var0_0.InShowTime(arg0_4)
	local var0_4 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	return var0_4 and not var0_4:isEnd()
end

function var0_0.AnyVoteActIsOpening(arg0_5)
	return getProxy(VoteProxy):AnyVoteActIsOpening()
end

function var0_0.IsShowTip(arg0_6)
	return arg0_6:ShouldTipNewRace() or arg0_6:ShouldTipVotes() or arg0_6:ShouldTipAward() or arg0_6:ShouldTipFinalAward()
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

function var0_0.Hide(arg0_11)
	if arg0_11._tf then
		setActive(arg0_11._tf, false)
	end
end

function var0_0.Dispose(arg0_12)
	return
end

return var0_0
