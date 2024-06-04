local var0 = class("BillboardProxy", import(".NetProxy"))

var0.FETCH_LIST_DONE = "BillboardProxy:FETCH_LIST_DONE"
var0.NONTIMER = {}

function var0.register(arg0)
	var0.NONTIMER = {
		PowerRank.TYPE_MILITARY_RANK,
		PowerRank.TYPE_BOSSRUSH
	}
	arg0.data = {}
	arg0.playerData = {}
	arg0.timeStamps = {}
	arg0.hashList = {}
	arg0.hashCount = 0
end

function var0.setPlayerRankData(arg0, arg1, arg2, arg3)
	local var0 = arg0:getHashId(arg1, arg2)

	if table.contains(var0.NONTIMER, arg1) then
		return
	end

	arg0.playerData[var0] = arg3
end

function var0.getPlayerRankData(arg0, arg1, arg2)
	return arg0.playerData[arg0:getHashId(arg1, arg2)]
end

function var0.setRankList(arg0, arg1, arg2, arg3)
	local var0 = arg0:getHashId(arg1, arg2)

	if table.contains(var0.NONTIMER, arg1) then
		return
	end

	arg0.data[var0] = arg3
	arg0.timeStamps[var0] = GetHalfHour()
end

function var0.getRankList(arg0, arg1, arg2)
	return arg0.data[arg0:getHashId(arg1, arg2)]
end

function var0.canFetch(arg0, arg1, arg2)
	if table.contains(var0.NONTIMER, arg1) then
		return true
	end

	local var0 = arg0:getHashId(arg1, arg2)

	if not arg0.timeStamps[var0] or pg.TimeMgr.GetInstance():GetServerTime() > arg0.timeStamps[var0] then
		return true
	end

	return false
end

function var0.getHashId(arg0, arg1, arg2)
	local var0

	if arg2 then
		arg0.hashList[arg1] = arg0.hashList[arg1] or {}
		var0 = arg0.hashList[arg1][arg2]
	else
		var0 = arg0.hashList[arg1]
	end

	if var0 then
		return var0
	else
		arg0.hashCount = arg0.hashCount + 1

		if arg2 then
			arg0.hashList[arg1][arg2] = arg0.hashCount
		else
			arg0.hashList[arg1] = arg0.hashCount
		end

		return arg0.hashCount
	end
end

return var0
