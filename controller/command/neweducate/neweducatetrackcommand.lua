local var0_0 = class("NewEducateTrackCommand", pm.SimpleCommand)

var0_0.TYPE_NEW_EDUCATE_ENTER = 10001
var0_0.TYPE_NEW_EDUCATE_ENDING = 10002
var0_0.TYPE_NEW_EDUCATE_PLAN = 10003
var0_0.TYPE_NEW_EDUCATE_SITE = 10004
var0_0.TYPE_NEW_EDUCATE_TALENT = 10005
var0_0.TYPE_NEW_EDUCATE_POLARIOD = 10006
var0_0.TYPE_NEW_EDUCATE_MEMORY = 10007
var0_0.TYPE_NEW_EDUCATE_ROUND_END = 10008

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1.body

	print("TRACK NEW_EDUCATE\n", table.CastToString(var0_1))

	if not pg.ConnectionMgr.GetInstance():getConnection() or not pg.ConnectionMgr.GetInstance():isConnected() then
		return
	end

	local var1_1 = var0_1.args and _.map(_.range(var0_1.args.Count), function(arg0_2)
		return var0_1.args[arg0_2] or 0
	end) or {}
	local var2_1 = var0_1.strs and _.map(_.range(var0_1.strs.Count), function(arg0_3)
		return var0_1.strs[arg0_3] or ""
	end) or {}

	pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildNewEducate({
		track_typ = var0_1.trackType,
		int_args = var1_1,
		str_args = var2_1
	}))
end

function var0_0.BuildDataEnter(arg0_4, arg1_4, arg2_4)
	return {
		trackType = var0_0.TYPE_NEW_EDUCATE_ENTER,
		args = {
			arg0_4,
			arg1_4,
			arg2_4 or 0,
			Count = 3
		}
	}
end

function var0_0.BuildDataEnding(arg0_5, arg1_5, arg2_5)
	return {
		trackType = var0_0.TYPE_NEW_EDUCATE_ENDING,
		args = {
			arg0_5,
			arg1_5,
			arg2_5,
			Count = 3
		}
	}
end

function var0_0.BuildDataPlan(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	return {
		trackType = var0_0.TYPE_NEW_EDUCATE_PLAN,
		args = {
			arg0_6,
			arg1_6,
			arg2_6,
			Count = 3
		},
		strs = {
			arg3_6,
			arg4_6,
			Count = 2
		}
	}
end

function var0_0.BuildDataSite(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	return {
		trackType = var0_0.TYPE_NEW_EDUCATE_SITE,
		args = {
			arg0_7,
			arg1_7,
			arg2_7,
			arg3_7,
			arg4_7,
			Count = 5
		}
	}
end

function var0_0.BuildDataTalent(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8, arg5_8)
	return {
		trackType = var0_0.TYPE_NEW_EDUCATE_TALENT,
		args = {
			arg0_8,
			arg1_8,
			arg2_8,
			arg3_8,
			arg4_8 or 0,
			Count = 5
		},
		strs = {
			arg5_8,
			Count = 1
		}
	}
end

function var0_0.BuildDataPolariod(arg0_9, arg1_9, arg2_9)
	return {
		trackType = var0_0.TYPE_NEW_EDUCATE_POLARIOD,
		args = {
			arg0_9,
			arg1_9,
			arg2_9,
			Count = 3
		}
	}
end

function var0_0.BuildDataMemory(arg0_10, arg1_10, arg2_10)
	return {
		trackType = var0_0.TYPE_NEW_EDUCATE_MEMORY,
		args = {
			arg0_10,
			arg1_10,
			arg2_10,
			Count = 3
		}
	}
end

function var0_0.BuildDataRoundEnd(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11, arg6_11, arg7_11, arg8_11)
	return {
		trackType = var0_0.TYPE_NEW_EDUCATE_ROUND_END,
		args = {
			arg0_11,
			arg1_11,
			arg2_11,
			arg3_11,
			arg4_11,
			arg5_11,
			arg6_11,
			Count = 7
		},
		strs = {
			arg7_11,
			arg8_11,
			Count = 2
		}
	}
end

return var0_0
