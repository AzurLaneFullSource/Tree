local var0 = class("VoteGroup", import("..BaseVO"))

var0.VOTE_STAGE = 1
var0.STTLEMENT_STAGE = 2
var0.DISPLAY_STAGE = 3

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.list = arg1.list

	arg0:updateRankMap()
end

function var0.bindConfigTable(arg0)
	return pg.activity_vote
end

function var0.isResurrectionRace(arg0)
	return arg0:getConfig("type") == VoteConst.RACE_TYPE_RESURGENCE
end

function var0.isFinalsRace(arg0)
	return arg0:getConfig("type") == VoteConst.RACE_TYPE_FINAL
end

function var0.IsPrevResurrectionRace(arg0)
	return arg0:getConfig("type") == VoteConst.RACE_TYPE_PRE_RESURGENCE
end

function var0.IsFunRace(arg0)
	return arg0:getConfig("type") == VoteConst.RACE_TYPE_FUN
end

function var0.IsFunMetaRace(arg0)
	return arg0:IsFunRace() and arg0:getConfig("sub_type") == 2
end

function var0.IsFunSireRace(arg0)
	return arg0:IsFunRace() and arg0:getConfig("sub_type") == 1
end

function var0.IsFunKidRace(arg0)
	return arg0:IsFunRace() and arg0:getConfig("sub_type") == 3
end

function var0.GetRankMark(arg0)
	local var0 = 0
	local var1 = 0
	local var2 = arg0:getConfig("rank_to_next")

	for iter0, iter1 in ipairs(var2) do
		local var3 = iter1[1]
		local var4 = iter1[2]
		local var5 = pg.activity_vote[var3]

		if var5 and (var5.type == VoteConst.RACE_TYPE_RESURGENCE or var5.type == VoteConst.RACE_TYPE_PRE_RESURGENCE) then
			var1 = #var4
		else
			var0 = var0 + #var4
		end
	end

	return var0, var1
end

function var0.CanRankToNextTurn(arg0, arg1)
	local var0, var1 = arg0:GetRankMark()
	local var2 = arg1 <= var0
	local var3 = var0 < arg1 and arg1 <= var0 + var1

	return var2, var3
end

function var0.GetRiseColor(arg0, arg1)
	local var0, var1 = arg0:CanRankToNextTurn(arg1)
	local var2 = arg0:IsOpening()
	local var3 = COLOR_WHITE

	if not var2 and var0 then
		var3 = "#FEDD6C"
	elseif not var2 and var1 then
		var3 = "#77e4de"
	end

	return var3
end

function var0.getList(arg0)
	return arg0.list
end

function var0.UpdateVoteCnt(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg0.list) do
		if iter1:isSamaGroup(arg1) then
			iter1:UpdateVoteCnt(arg2)
		end
	end

	arg0:updateRankMap()
end

function var0.updateRankMap(arg0)
	if arg0:IsOpening() then
		table.sort(arg0.list, function(arg0, arg1)
			return arg0:getScore() > arg1:getScore()
		end)
	end

	arg0.rankMaps = {}

	for iter0, iter1 in ipairs(arg0.list) do
		arg0.rankMaps[iter1.group] = iter0
	end
end

function var0.GetRank(arg0, arg1)
	return arg0.rankMaps[arg1.group] or 0
end

function var0.GetStage(arg0)
	local var0 = arg0:getConfig("time_vote")
	local var1 = arg0:getConfig("time_vote_client")
	local var2 = arg0:getConfig("time_show")

	if pg.TimeMgr.GetInstance():inTime(var0) then
		return var0.VOTE_STAGE
	elseif pg.TimeMgr.GetInstance():inTime(var1) then
		return var0.STTLEMENT_STAGE
	elseif pg.TimeMgr.GetInstance():inTime(var2) then
		return var0.DISPLAY_STAGE
	else
		assert(false)
	end
end

function var0.IsOpening(arg0)
	return arg0:GetStage() == var0.VOTE_STAGE
end

function var0.getTimeDesc(arg0)
	local var0 = arg0:getConfig("time_vote")

	return var0.GetTimeDesc(var0, arg0:getConfig("type"))
end

function var0.GetTimeDesc(arg0, arg1)
	return table.concat(arg0[1][1], ".") .. (arg1 == 1 and i18n("word_maintain") or "(" .. string.format("%02u:%02u", arg0[1][2][1], arg0[1][2][2]) .. ")") .. " ~ " .. arg0[2][1][1] .. "." .. arg0[2][1][2] .. "." .. arg0[2][1][3] .. "(" .. string.format("%02u:%02u", arg0[2][2][1], arg0[2][2][2]) .. ")"
end

function var0.GetTimeDesc2(arg0, arg1)
	local var0 = table.concat(arg0[1][1], ".") .. (arg1 == 1 and "<size=18>" .. i18n("word_maintain") .. "</size>" or "(" .. string.format("<size=18>%02u:%02u</size>", arg0[1][2][1], arg0[1][2][2]) .. ")") .. " ~ " .. arg0[2][1][1] .. "." .. arg0[2][1][2] .. "." .. arg0[2][1][3] .. "<size=18>(" .. string.format("%02u:%02u", arg0[2][2][1], arg0[2][2][2]) .. ")</size>"

	return "<size=21>" .. var0 .. "</size>"
end

function var0.GetVotes(arg0, arg1)
	if arg0:IsOpening() then
		return arg1:GetGameVotes()
	else
		return arg1:getTotalVotes()
	end
end

function var0.GetRankList(arg0)
	local var0 = arg0:getList()
	local var1 = {}
	local var2 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, iter1)

		var2[iter1.group] = arg0:GetRank(iter1)
	end

	table.sort(var1, function(arg0, arg1)
		return var2[arg0.group] < var2[arg1.group]
	end)

	return var1
end

return var0
