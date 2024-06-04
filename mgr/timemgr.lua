pg = pg or {}

local var0 = pg

var0.TimeMgr = singletonClass("TimeMgr")

local var1 = var0.TimeMgr

var1._Timer = nil
var1._BattleTimer = nil
var1._sAnchorTime = 0
var1._AnchorDelta = 0
var1._serverUnitydelta = 0
var1._isdstClient = false

local var2 = 3600
local var3 = 86400
local var4 = 604800

function var1.Ctor(arg0)
	arg0._battleTimerList = {}
end

function var1.Init(arg0)
	print("initializing time manager...")

	arg0._Timer = TimeUtil.NewUnityTimer()

	UpdateBeat:Add(arg0.Update, arg0)
	UpdateBeat:Add(arg0.BattleUpdate, arg0)
end

function var1.Update(arg0)
	arg0._Timer:Schedule()
end

function var1.BattleUpdate(arg0)
	if arg0._stopCombatTime > 0 then
		arg0._cobTime = arg0._stopCombatTime - arg0._waitTime
	else
		arg0._cobTime = Time.time - arg0._waitTime
	end
end

function var1.AddTimer(arg0, arg1, arg2, arg3, arg4)
	return arg0._Timer:SetTimer(arg1, arg2 * 1000, arg3 * 1000, arg4)
end

function var1.RemoveTimer(arg0, arg1)
	if arg1 == nil or arg1 == 0 then
		return
	end

	arg0._Timer:DeleteTimer(arg1)
end

var1._waitTime = 0
var1._stopCombatTime = 0
var1._cobTime = 0

function var1.GetCombatTime(arg0)
	return arg0._cobTime
end

function var1.ResetCombatTime(arg0)
	arg0._waitTime = 0
	arg0._cobTime = Time.time
end

function var1.GetCombatDeltaTime()
	return Time.fixedDeltaTime
end

function var1.PauseBattleTimer(arg0)
	arg0._stopCombatTime = Time.time

	for iter0, iter1 in pairs(arg0._battleTimerList) do
		iter0:Pause()
	end
end

function var1.ResumeBattleTimer(arg0)
	arg0._waitTime = arg0._waitTime + Time.time - arg0._stopCombatTime
	arg0._stopCombatTime = 0

	for iter0, iter1 in pairs(arg0._battleTimerList) do
		iter0:Resume()
	end
end

function var1.AddBattleTimer(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	arg2 = arg2 or -1
	arg5 = arg5 or false
	arg6 = arg6 or false

	local var0 = Timer.New(arg4, arg3, arg2, arg5)

	arg0._battleTimerList[var0] = true

	if not arg6 then
		var0:Start()
	end

	if arg0._stopCombatTime ~= 0 then
		var0:Pause()
	end

	return var0
end

function var1.ScaleBattleTimer(arg0, arg1)
	Time.timeScale = arg1
end

function var1.RemoveBattleTimer(arg0, arg1)
	if arg1 then
		arg0._battleTimerList[arg1] = nil

		arg1:Stop()
	end
end

function var1.RemoveAllBattleTimer(arg0)
	for iter0, iter1 in pairs(arg0._battleTimerList) do
		iter0:Stop()
	end

	arg0._battleTimerList = {}
end

function var1.RealtimeSinceStartup(arg0)
	return math.ceil(Time.realtimeSinceStartup)
end

function var1.SetServerTime(arg0, arg1, arg2)
	arg0:_SetServerTime_(arg1, arg2, arg0:RealtimeSinceStartup())
end

function var1._SetServerTime_(arg0, arg1, arg2, arg3)
	if PLATFORM_CODE == PLATFORM_US then
		SERVER_DAYLIGHT_SAVEING_TIME = false
	end

	arg0._isdstClient = os.date("*t").isdst
	arg0._serverUnitydelta = arg1 - arg3
	arg0._sAnchorTime = arg2 - (SERVER_DAYLIGHT_SAVEING_TIME and 3600 or 0)
	arg0._AnchorDelta = arg2 - os.time({
		year = 2020,
		month = 11,
		hour = 0,
		min = 0,
		sec = 0,
		day = 23,
		isdst = false
	})
end

function var1.GetServerTime(arg0)
	return arg0:RealtimeSinceStartup() + arg0._serverUnitydelta
end

function var1.GetServerWeek(arg0)
	local var0 = arg0:GetServerTime()

	return arg0:GetServerTimestampWeek(var0)
end

function var1.GetServerTimestampWeek(arg0, arg1)
	local var0 = arg1 - arg0._sAnchorTime

	return math.ceil((var0 % var4 + 1) / var3)
end

function var1.GetServerHour(arg0)
	local var0 = arg0:GetServerTime() - arg0._sAnchorTime

	return math.floor(var0 % var3 / var2)
end

function var1.Table2ServerTime(arg0, arg1)
	arg1.isdst = arg0._isdstClient

	if arg0._isdstClient ~= SERVER_DAYLIGHT_SAVEING_TIME then
		if SERVER_DAYLIGHT_SAVEING_TIME then
			return arg0._AnchorDelta + os.time(arg1) - var2
		else
			return arg0._AnchorDelta + os.time(arg1) + var2
		end
	else
		return arg0._AnchorDelta + os.time(arg1)
	end
end

function var1.CTimeDescC(arg0, arg1, arg2)
	arg2 = arg2 or "%Y%m%d%H%M%S"

	return os.date(arg2, arg1)
end

function var1.STimeDescC(arg0, arg1, arg2, arg3)
	originalPrint("Before : ", arg1)

	arg2 = arg2 or "%Y/%m/%d %H:%M:%S"

	if arg3 then
		originalPrint("2after : ", os.date(arg2, arg1))

		return os.date(arg2, arg1 + os.time() - arg0:GetServerTime())
	else
		originalPrint("1after : ", os.date(arg2, arg1))

		return os.date(arg2, arg1)
	end
end

function var1.STimeDescS(arg0, arg1, arg2)
	arg2 = arg2 or "%Y/%m/%d %H:%M:%S"

	local var0 = 0

	if arg0._isdstClient ~= SERVER_DAYLIGHT_SAVEING_TIME then
		var0 = SERVER_DAYLIGHT_SAVEING_TIME and 3600 or -3600
	end

	return os.date(arg2, arg1 - arg0._AnchorDelta + var0)
end

function var1.CurrentSTimeDesc(arg0, arg1, arg2)
	if arg2 then
		return arg0:STimeDescS(arg0:GetServerTime(), arg1)
	else
		return arg0:STimeDescC(arg0:GetServerTime(), arg1)
	end
end

function var1.ChieseDescTime(arg0, arg1, arg2)
	local var0 = "%Y/%m/%d"
	local var1

	if arg2 then
		var1 = os.date(var0, arg1)
	else
		var1 = os.date(var0, arg1 + os.time() - arg0:GetServerTime())
	end

	local var2 = split(var1, "/")

	return NumberToChinese(var2[1], false) .. "年" .. NumberToChinese(var2[2], true) .. "月" .. NumberToChinese(var2[3], true) .. "日"
end

function var1.GetTimeToNextTime(arg0, arg1, arg2, arg3)
	arg1 = arg1 or arg0:GetServerTime()
	arg2 = arg2 or var3
	arg3 = arg3 or 0

	local var0 = arg1 - (arg0._sAnchorTime + arg3)

	return math.floor(var0 / arg2 + 1) * arg2 + arg0._sAnchorTime + arg3
end

function var1.GetNextTime(arg0, arg1, arg2, arg3, arg4)
	return arg0:GetTimeToNextTime(nil, arg4, arg1 * var2 + arg2 * 60 + arg3)
end

function var1.GetNextTimeByTimeStamp(arg0, arg1)
	return arg0:GetTimeToNextTime(arg1) - var3
end

function var1.GetNextWeekTime(arg0, arg1, arg2, arg3, arg4)
	return arg0:GetNextTime((arg1 - 1) * 24 + arg2, arg3, arg4, var4)
end

function var1.ParseTime(arg0, arg1)
	local var0 = tonumber(arg1)
	local var1 = var0 % 100
	local var2 = var0 / 100
	local var3 = var2 % 100
	local var4 = var2 / 100
	local var5 = var4 % 100
	local var6 = var4 / 100
	local var7 = var6 % 100
	local var8 = var6 / 100
	local var9 = var8 % 100
	local var10 = var8 / 100

	return arg0:Table2ServerTime({
		year = var10,
		month = var9,
		day = var7,
		hour = var5,
		min = var3,
		sec = var1
	})
end

function var1.ParseTimeEx(arg0, arg1, arg2)
	if arg2 == nil then
		arg2 = "(%d+)%-(%d+)%-(%d+)%s(%d+)%:(%d+)%:(%d+)"
	end

	local var0, var1, var2, var3, var4, var5 = arg1:match(arg2)

	return arg0:Table2ServerTime({
		year = var0,
		month = var1,
		day = var2,
		hour = var3,
		min = var4,
		sec = var5
	})
end

function var1.parseTimeFromConfig(arg0, arg1)
	return arg0:Table2ServerTime({
		year = arg1[1][1],
		month = arg1[1][2],
		day = arg1[1][3],
		hour = arg1[2][1],
		min = arg1[2][2],
		sec = arg1[2][3]
	})
end

function var1.DescDateFromConfig(arg0, arg1, arg2)
	arg2 = arg2 or "%d.%02d.%02d"

	return string.format(arg2, arg1[1][1], arg1[1][2], arg1[1][3])
end

function var1.DescCDTime(arg0, arg1)
	local var0 = math.floor(arg1 / 3600)

	arg1 = arg1 % 3600

	local var1 = math.floor(arg1 / 60)

	arg1 = arg1 % 60

	return string.format("%02d:%02d:%02d", var0, var1, arg1)
end

function var1.DescCDTimeForMinute(arg0, arg1)
	local var0 = math.floor(arg1 / 3600)

	arg1 = arg1 % 3600

	local var1 = math.floor(arg1 / 60)

	arg1 = arg1 % 60

	return string.format("%02d:%02d", var1, arg1)
end

function var1.parseTimeFrom(arg0, arg1)
	local var0 = math.floor(arg1 / var3)
	local var1 = math.fmod(math.floor(arg1 / 3600), 24)
	local var2 = math.fmod(math.floor(arg1 / 60), 60)
	local var3 = math.fmod(arg1, 60)

	return var0, var1, var2, var3
end

function var1.DiffDay(arg0, arg1, arg2)
	return math.floor((arg2 - arg0._sAnchorTime) / var3) - math.floor((arg1 - arg0._sAnchorTime) / var3)
end

function var1.IsSameDay(arg0, arg1, arg2)
	return math.floor((arg1 - arg0._sAnchorTime) / var3) == math.floor((arg2 - arg0._sAnchorTime) / var3)
end

function var1.IsPassTimeByZero(arg0, arg1, arg2)
	return arg2 < math.fmod(arg1 - arg0._sAnchorTime, var3)
end

function var1.CalcMonthDays(arg0, arg1, arg2)
	local var0 = 30

	if arg2 == 2 then
		var0 = (arg1 % 4 == 0 and arg1 % 100 ~= 0 or arg1 % 400 == 0) and 29 or 28
	elseif _.include({
		1,
		3,
		5,
		7,
		8,
		10,
		12
	}, arg2) then
		var0 = 31
	end

	return var0
end

function var1.inTime(arg0, arg1, arg2)
	if not arg1 then
		return true
	end

	if type(arg1) == "string" then
		return arg1 == "always"
	end

	if type(arg1[1]) == "string" then
		arg1 = {
			arg1[2],
			arg1[3]
		}
	end

	local function var0(arg0)
		return {
			year = arg0[1][1],
			month = arg0[1][2],
			day = arg0[1][3],
			hour = arg0[2][1],
			min = arg0[2][2],
			sec = arg0[2][3]
		}
	end

	local var1

	if #arg1 > 0 then
		var1 = var0(arg1[1] or {
			{
				2000,
				1,
				1
			},
			{
				0,
				0,
				0
			}
		})
	end

	local var2

	if #arg1 > 1 then
		var2 = var0(arg1[2] or {
			{
				2000,
				1,
				1
			},
			{
				0,
				0,
				0
			}
		})
	end

	local var3

	if var1 and var2 then
		local var4 = arg2 or arg0:GetServerTime()
		local var5 = arg0:Table2ServerTime(var1)
		local var6 = arg0:Table2ServerTime(var2)

		if var4 < var5 then
			return false, var1
		end

		if var6 < var4 then
			return false, nil
		end

		var3 = var2
	end

	return true, var3
end

function var1.passTime(arg0, arg1)
	if not arg1 then
		return true
	end

	local var0 = (function(arg0)
		local var0 = {}

		var0.year, var0.month, var0.day = unpack(arg0[1])
		var0.hour, var0.min, var0.sec = unpack(arg0[2])

		return var0
	end)(arg1 or {
		{
			2000,
			1,
			1
		},
		{
			0,
			0,
			0
		}
	})

	if var0 then
		return arg0:GetServerTime() > arg0:Table2ServerTime(var0)
	end

	return true
end
