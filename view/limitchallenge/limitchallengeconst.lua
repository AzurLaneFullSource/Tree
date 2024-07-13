LimitChallengeConst = {}

local var0_0 = LimitChallengeConst

var0_0.OPEN_PRE_COMBAT_LAYER = "OPEN_PRE_COMBAT_LAYER"
var0_0.REQ_CHALLENGE_INFO = "LimitChallengeConst.REQ_CHALLENGE_INFO"
var0_0.REQ_CHALLENGE_INFO_DONE = "LimitChallengeConst.REQ_CHALLENGE_INFO_DONE"
var0_0.GET_CHALLENGE_AWARD = "LimitChallengeConst.GET_CHALLENGE_AWARD"
var0_0.GET_CHALLENGE_AWARD_DONE = "LimitChallengeConst.GET_CHALLENGE_AWARD_DONE"
var0_0.UPDATE_PASS_TIME = "LimitChallengeConst.UPDATE_PASS_TIME"

function var0_0.RequestInfo()
	if pg.constellation_challenge_month and #pg.constellation_challenge_month.all > 0 and LimitChallengeConst.GetCurMonthConfig() then
		pg.m02:sendNotification(LimitChallengeConst.REQ_CHALLENGE_INFO)
	end
end

function var0_0.GetNextMonthTS()
	local var0_2 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_2 = pg.TimeMgr.GetInstance():STimeDescS(var0_2, "%Y")
	local var2_2 = pg.TimeMgr.GetInstance():STimeDescS(var0_2, "%m")
	local var3_2 = tonumber(var1_2)
	local var4_2 = tonumber(var2_2)

	print("------------", tostring(var3_2), tostring(var4_2))

	local var5_2 = var4_2 + 1

	if var5_2 > 12 then
		var5_2 = 1
		var3_2 = var3_2 + 1
	end

	return pg.TimeMgr.GetInstance():Table2ServerTime({
		sec = 0,
		min = 0,
		hour = 0,
		day = 1,
		year = var3_2,
		month = var5_2
	})
end

function var0_0.GetCurMonth()
	local var0_3 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_3 = pg.TimeMgr.GetInstance():STimeDescS(var0_3, "%m")

	return (tonumber(var1_3))
end

function var0_0.GetCurMonthConfig()
	local var0_4 = var0_0.GetCurMonth()

	return pg.constellation_challenge_month[var0_4]
end

function var0_0.GetChallengeIDByLevel(arg0_5)
	return LimitChallengeConst.GetCurMonthConfig().stage[arg0_5]
end

function var0_0.GetStageIDByLevel(arg0_6)
	local var0_6 = var0_0.GetChallengeIDByLevel(arg0_6)

	return pg.expedition_constellation_challenge_template[var0_6].dungeon_id
end

function var0_0.GetChallengeIDByStageID(arg0_7)
	for iter0_7, iter1_7 in ipairs(pg.expedition_constellation_challenge_template.all) do
		local var0_7 = pg.expedition_constellation_challenge_template[iter1_7]

		if arg0_7 == var0_7.dungeon_id then
			return var0_7.id
		end
	end
end

function var0_0.IsOpen()
	local var0_8 = getProxy(PlayerProxy):getRawData().level
	local var1_8 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_8, "LimitChallengeMediator")
	local var2_8 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_8, "ChallengeMainMediator")

	return var1_8 and var2_8
end

function var0_0.IsInAct()
	local var0_9 = pg.constellation_challenge_month and #pg.constellation_challenge_month.all > 0 and LimitChallengeConst.GetCurMonthConfig()
	local var1_9 = checkExist(getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE), {
		"isEnd"
	}) == false

	return LOCK_LIMIT_CHALLENGE and var1_9 or var0_9
end

var0_0.RedPointKey = "LimitChallengeMonth"

function var0_0.SetRedPointMonth()
	PlayerPrefs.SetInt(var0_0.RedPointKey, var0_0.GetCurMonth())
end

function var0_0.GetRedPointMonth()
	return PlayerPrefs.GetInt(var0_0.RedPointKey, 0)
end

function var0_0.IsShowRedPoint()
	if LOCK_LIMIT_CHALLENGE then
		return false
	end

	if not var0_0.IsOpen() then
		return false
	end

	if not var0_0.IsInAct() then
		return false
	end

	if var0_0.GetRedPointMonth() == var0_0.GetCurMonth() then
		return false
	else
		local var0_12 = getProxy(LimitChallengeProxy)
		local var1_12 = var0_0.GetCurMonthConfig().stage

		for iter0_12, iter1_12 in ipairs(var1_12) do
			if not var0_12:isAwardedByChallengeID(iter1_12) then
				return true
			end
		end

		return false
	end
end

return var0_0
