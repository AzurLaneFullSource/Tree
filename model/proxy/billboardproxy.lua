local var0_0 = class("BillboardProxy", import(".NetProxy"))

var0_0.FETCH_LIST_DONE = "BillboardProxy:FETCH_LIST_DONE"
var0_0.NONTIMER = {}

function var0_0.register(arg0_1)
	var0_0.NONTIMER = {
		PowerRank.TYPE_MILITARY_RANK,
		PowerRank.TYPE_BOSSRUSH
	}
	arg0_1.data = {}
	arg0_1.playerData = {}
	arg0_1.timeStamps = {}
	arg0_1.hashList = {}
	arg0_1.hashCount = 0
end

function var0_0.setPlayerRankData(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = arg0_2:getHashId(arg1_2, arg2_2)

	if table.contains(var0_0.NONTIMER, arg1_2) then
		return
	end

	arg0_2.playerData[var0_2] = arg3_2
end

function var0_0.getPlayerRankData(arg0_3, arg1_3, arg2_3)
	return arg0_3.playerData[arg0_3:getHashId(arg1_3, arg2_3)]
end

function var0_0.setRankList(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = arg0_4:getHashId(arg1_4, arg2_4)

	if table.contains(var0_0.NONTIMER, arg1_4) then
		return
	end

	arg0_4.data[var0_4] = arg3_4
	arg0_4.timeStamps[var0_4] = GetHalfHour()
end

function var0_0.getRankList(arg0_5, arg1_5, arg2_5)
	return arg0_5.data[arg0_5:getHashId(arg1_5, arg2_5)]
end

function var0_0.canFetch(arg0_6, arg1_6, arg2_6)
	if table.contains(var0_0.NONTIMER, arg1_6) then
		return true
	end

	local var0_6 = arg0_6:getHashId(arg1_6, arg2_6)

	if not arg0_6.timeStamps[var0_6] or pg.TimeMgr.GetInstance():GetServerTime() > arg0_6.timeStamps[var0_6] then
		return true
	end

	return false
end

function var0_0.getHashId(arg0_7, arg1_7, arg2_7)
	local var0_7

	if arg2_7 then
		arg0_7.hashList[arg1_7] = arg0_7.hashList[arg1_7] or {}
		var0_7 = arg0_7.hashList[arg1_7][arg2_7]
	else
		var0_7 = arg0_7.hashList[arg1_7]
	end

	if var0_7 then
		return var0_7
	else
		arg0_7.hashCount = arg0_7.hashCount + 1

		if arg2_7 then
			arg0_7.hashList[arg1_7][arg2_7] = arg0_7.hashCount
		else
			arg0_7.hashList[arg1_7] = arg0_7.hashCount
		end

		return arg0_7.hashCount
	end
end

return var0_0
