LimitChallengeConst = {}

local var0 = LimitChallengeConst

var0.OPEN_PRE_COMBAT_LAYER = "OPEN_PRE_COMBAT_LAYER"
var0.REQ_CHALLENGE_INFO = "LimitChallengeConst.REQ_CHALLENGE_INFO"
var0.REQ_CHALLENGE_INFO_DONE = "LimitChallengeConst.REQ_CHALLENGE_INFO_DONE"
var0.GET_CHALLENGE_AWARD = "LimitChallengeConst.GET_CHALLENGE_AWARD"
var0.GET_CHALLENGE_AWARD_DONE = "LimitChallengeConst.GET_CHALLENGE_AWARD_DONE"
var0.UPDATE_PASS_TIME = "LimitChallengeConst.UPDATE_PASS_TIME"

function var0.RequestInfo()
	if pg.constellation_challenge_month and #pg.constellation_challenge_month.all > 0 and LimitChallengeConst.GetCurMonthConfig() then
		pg.m02:sendNotification(LimitChallengeConst.REQ_CHALLENGE_INFO)
	end
end

function var0.GetNextMonthTS()
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = pg.TimeMgr.GetInstance():STimeDescS(var0, "%Y")
	local var2 = pg.TimeMgr.GetInstance():STimeDescS(var0, "%m")
	local var3 = tonumber(var1)
	local var4 = tonumber(var2)

	print("------------", tostring(var3), tostring(var4))

	local var5 = var4 + 1

	if var5 > 12 then
		var5 = 1
		var3 = var3 + 1
	end

	return pg.TimeMgr.GetInstance():Table2ServerTime({
		sec = 0,
		min = 0,
		hour = 0,
		day = 1,
		year = var3,
		month = var5
	})
end

function var0.GetCurMonth()
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = pg.TimeMgr.GetInstance():STimeDescS(var0, "%m")

	return (tonumber(var1))
end

function var0.GetCurMonthConfig()
	local var0 = var0.GetCurMonth()

	return pg.constellation_challenge_month[var0]
end

function var0.GetChallengeIDByLevel(arg0)
	return LimitChallengeConst.GetCurMonthConfig().stage[arg0]
end

function var0.GetStageIDByLevel(arg0)
	local var0 = var0.GetChallengeIDByLevel(arg0)

	return pg.expedition_constellation_challenge_template[var0].dungeon_id
end

function var0.GetChallengeIDByStageID(arg0)
	for iter0, iter1 in ipairs(pg.expedition_constellation_challenge_template.all) do
		local var0 = pg.expedition_constellation_challenge_template[iter1]

		if arg0 == var0.dungeon_id then
			return var0.id
		end
	end
end

function var0.IsOpen()
	local var0 = getProxy(PlayerProxy):getRawData().level
	local var1 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0, "LimitChallengeMediator")
	local var2 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0, "ChallengeMainMediator")

	return var1 and var2
end

function var0.IsInAct()
	local var0 = pg.constellation_challenge_month and #pg.constellation_challenge_month.all > 0 and LimitChallengeConst.GetCurMonthConfig()
	local var1 = checkExist(getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE), {
		"isEnd"
	}) == false

	return LOCK_LIMIT_CHALLENGE and var1 or var0
end

var0.RedPointKey = "LimitChallengeMonth"

function var0.SetRedPointMonth()
	PlayerPrefs.SetInt(var0.RedPointKey, var0.GetCurMonth())
end

function var0.GetRedPointMonth()
	return PlayerPrefs.GetInt(var0.RedPointKey, 0)
end

function var0.IsShowRedPoint()
	if LOCK_LIMIT_CHALLENGE then
		return false
	end

	if not var0.IsOpen() then
		return false
	end

	if not var0.IsInAct() then
		return false
	end

	if var0.GetRedPointMonth() == var0.GetCurMonth() then
		return false
	else
		local var0 = getProxy(LimitChallengeProxy)
		local var1 = var0.GetCurMonthConfig().stage

		for iter0, iter1 in ipairs(var1) do
			if not var0:isAwardedByChallengeID(iter1) then
				return true
			end
		end

		return false
	end
end

return var0
