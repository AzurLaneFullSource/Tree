local var0_0 = class("VoteGroup", import("..BaseVO"))

var0_0.VOTE_STAGE = 1
var0_0.STTLEMENT_STAGE = 2
var0_0.DISPLAY_STAGE = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.list = arg1_1.list

	arg0_1:updateRankMap()
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_vote
end

function var0_0.isResurrectionRace(arg0_3)
	return arg0_3:getConfig("type") == VoteConst.RACE_TYPE_RESURGENCE
end

function var0_0.isFinalsRace(arg0_4)
	return arg0_4:getConfig("type") == VoteConst.RACE_TYPE_FINAL
end

function var0_0.IsPrevResurrectionRace(arg0_5)
	return arg0_5:getConfig("type") == VoteConst.RACE_TYPE_PRE_RESURGENCE
end

function var0_0.IsFunRace(arg0_6)
	return arg0_6:getConfig("type") == VoteConst.RACE_TYPE_FUN
end

function var0_0.IsFunMetaRace(arg0_7)
	return arg0_7:IsFunRace() and arg0_7:getConfig("sub_type") == 2
end

function var0_0.IsFunSireRace(arg0_8)
	return arg0_8:IsFunRace() and arg0_8:getConfig("sub_type") == 1
end

function var0_0.IsFunKidRace(arg0_9)
	return arg0_9:IsFunRace() and arg0_9:getConfig("sub_type") == 3
end

function var0_0.GetRankMark(arg0_10)
	local var0_10 = 0
	local var1_10 = 0
	local var2_10 = arg0_10:getConfig("rank_to_next")

	for iter0_10, iter1_10 in ipairs(var2_10) do
		local var3_10 = iter1_10[1]
		local var4_10 = iter1_10[2]
		local var5_10 = pg.activity_vote[var3_10]

		if var5_10 and (var5_10.type == VoteConst.RACE_TYPE_RESURGENCE or var5_10.type == VoteConst.RACE_TYPE_PRE_RESURGENCE) then
			var1_10 = #var4_10
		else
			var0_10 = var0_10 + #var4_10
		end
	end

	return var0_10, var1_10
end

function var0_0.CanRankToNextTurn(arg0_11, arg1_11)
	local var0_11, var1_11 = arg0_11:GetRankMark()
	local var2_11 = arg1_11 <= var0_11
	local var3_11 = var0_11 < arg1_11 and arg1_11 <= var0_11 + var1_11

	return var2_11, var3_11
end

function var0_0.GetRiseColor(arg0_12, arg1_12)
	local var0_12, var1_12 = arg0_12:CanRankToNextTurn(arg1_12)
	local var2_12 = arg0_12:IsOpening()
	local var3_12 = COLOR_WHITE

	if not var2_12 and var0_12 then
		var3_12 = "#FEDD6C"
	elseif not var2_12 and var1_12 then
		var3_12 = "#77e4de"
	end

	return var3_12
end

function var0_0.getList(arg0_13)
	return arg0_13.list
end

function var0_0.UpdateVoteCnt(arg0_14, arg1_14, arg2_14)
	for iter0_14, iter1_14 in ipairs(arg0_14.list) do
		if iter1_14:isSamaGroup(arg1_14) then
			iter1_14:UpdateVoteCnt(arg2_14)
		end
	end

	arg0_14:updateRankMap()
end

function var0_0.updateRankMap(arg0_15)
	if arg0_15:IsOpening() then
		table.sort(arg0_15.list, function(arg0_16, arg1_16)
			return arg0_16:getScore() > arg1_16:getScore()
		end)
	end

	arg0_15.rankMaps = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.list) do
		arg0_15.rankMaps[iter1_15.group] = iter0_15
	end
end

function var0_0.GetRank(arg0_17, arg1_17)
	return arg0_17.rankMaps[arg1_17.group] or 0
end

function var0_0.GetStage(arg0_18)
	local var0_18 = arg0_18:getConfig("time_vote")
	local var1_18 = arg0_18:getConfig("time_vote_client")
	local var2_18 = arg0_18:getConfig("time_show")

	if pg.TimeMgr.GetInstance():inTime(var0_18) then
		return var0_0.VOTE_STAGE
	elseif pg.TimeMgr.GetInstance():inTime(var1_18) then
		return var0_0.STTLEMENT_STAGE
	elseif pg.TimeMgr.GetInstance():inTime(var2_18) then
		return var0_0.DISPLAY_STAGE
	else
		assert(false)
	end
end

function var0_0.IsOpening(arg0_19)
	return arg0_19:GetStage() == var0_0.VOTE_STAGE
end

function var0_0.getTimeDesc(arg0_20)
	local var0_20 = arg0_20:getConfig("time_vote")

	return var0_0.GetTimeDesc(var0_20, arg0_20:getConfig("type"))
end

function var0_0.GetTimeDesc(arg0_21, arg1_21)
	return table.concat(arg0_21[1][1], ".") .. (arg1_21 == 1 and i18n("word_maintain") or "(" .. string.format("%02u:%02u", arg0_21[1][2][1], arg0_21[1][2][2]) .. ")") .. " ~ " .. arg0_21[2][1][1] .. "." .. arg0_21[2][1][2] .. "." .. arg0_21[2][1][3] .. "(" .. string.format("%02u:%02u", arg0_21[2][2][1], arg0_21[2][2][2]) .. ")"
end

function var0_0.GetTimeDesc2(arg0_22, arg1_22)
	local var0_22 = table.concat(arg0_22[1][1], ".") .. (arg1_22 == 1 and "<size=18>" .. i18n("word_maintain") .. "</size>" or "(" .. string.format("<size=18>%02u:%02u</size>", arg0_22[1][2][1], arg0_22[1][2][2]) .. ")") .. " ~ " .. arg0_22[2][1][1] .. "." .. arg0_22[2][1][2] .. "." .. arg0_22[2][1][3] .. "<size=18>(" .. string.format("%02u:%02u", arg0_22[2][2][1], arg0_22[2][2][2]) .. ")</size>"

	return "<size=21>" .. var0_22 .. "</size>"
end

function var0_0.GetVotes(arg0_23, arg1_23)
	if arg0_23:IsOpening() then
		return arg1_23:GetGameVotes()
	else
		return arg1_23:getTotalVotes()
	end
end

function var0_0.GetRankList(arg0_24)
	local var0_24 = arg0_24:getList()
	local var1_24 = {}
	local var2_24 = {}

	for iter0_24, iter1_24 in ipairs(var0_24) do
		table.insert(var1_24, iter1_24)

		var2_24[iter1_24.group] = arg0_24:GetRank(iter1_24)
	end

	table.sort(var1_24, function(arg0_25, arg1_25)
		return var2_24[arg0_25.group] < var2_24[arg1_25.group]
	end)

	return var1_24
end

return var0_0
