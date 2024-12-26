pg = pg or {}

local var0_0 = pg

var0_0.TimeMgr = singletonClass("TimeMgr")

local var1_0 = var0_0.TimeMgr

var1_0._Timer = nil
var1_0._BattleTimer = nil
var1_0._sAnchorTime = 0
var1_0._AnchorDelta = 0
var1_0._serverUnitydelta = 0
var1_0._isdstClient = false

local var2_0 = 3600
local var3_0 = 86400
local var4_0 = 604800

function var1_0.Ctor(arg0_1)
	arg0_1._battleTimerList = {}
end

function var1_0.Init(arg0_2)
	print("initializing time manager...")

	arg0_2._Timer = TimeUtil.NewUnityTimer()

	UpdateBeat:Add(arg0_2.Update, arg0_2)
	UpdateBeat:Add(arg0_2.BattleUpdate, arg0_2)
end

function var1_0.Update(arg0_3)
	arg0_3._Timer:Schedule()
end

function var1_0.BattleUpdate(arg0_4)
	if arg0_4._stopCombatTime > 0 then
		arg0_4._cobTime = arg0_4._stopCombatTime - arg0_4._waitTime
	else
		arg0_4._cobTime = Time.time - arg0_4._waitTime
	end
end

function var1_0.AddTimer(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	return arg0_5._Timer:SetTimer(arg1_5, arg2_5 * 1000, arg3_5 * 1000, arg4_5)
end

function var1_0.RemoveTimer(arg0_6, arg1_6)
	if arg1_6 == nil or arg1_6 == 0 then
		return
	end

	arg0_6._Timer:DeleteTimer(arg1_6)
end

var1_0._waitTime = 0
var1_0._stopCombatTime = 0
var1_0._cobTime = 0

function var1_0.GetCombatTime(arg0_7)
	return arg0_7._cobTime
end

function var1_0.ResetCombatTime(arg0_8)
	arg0_8._waitTime = 0
	arg0_8._cobTime = Time.time
end

function var1_0.GetCombatDeltaTime()
	return Time.fixedDeltaTime
end

function var1_0.PauseBattleTimer(arg0_10)
	arg0_10._stopCombatTime = Time.time

	for iter0_10, iter1_10 in pairs(arg0_10._battleTimerList) do
		iter0_10:Pause()
	end
end

function var1_0.ResumeBattleTimer(arg0_11)
	arg0_11._waitTime = arg0_11._waitTime + Time.time - arg0_11._stopCombatTime
	arg0_11._stopCombatTime = 0

	for iter0_11, iter1_11 in pairs(arg0_11._battleTimerList) do
		iter0_11:Resume()
	end
end

function var1_0.AddBattleTimer(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12, arg5_12, arg6_12)
	arg2_12 = arg2_12 or -1
	arg5_12 = arg5_12 or false
	arg6_12 = arg6_12 or false

	local var0_12 = Timer.New(arg4_12, arg3_12, arg2_12, arg5_12)

	arg0_12._battleTimerList[var0_12] = true

	if not arg6_12 then
		var0_12:Start()
	end

	if arg0_12._stopCombatTime ~= 0 then
		var0_12:Pause()
	end

	return var0_12
end

function var1_0.ScaleBattleTimer(arg0_13, arg1_13)
	Time.timeScale = arg1_13
end

function var1_0.RemoveBattleTimer(arg0_14, arg1_14)
	if arg1_14 then
		arg0_14._battleTimerList[arg1_14] = nil

		arg1_14:Stop()
	end
end

function var1_0.RemoveAllBattleTimer(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15._battleTimerList) do
		iter0_15:Stop()
	end

	arg0_15._battleTimerList = {}
end

function var1_0.RealtimeSinceStartup(arg0_16)
	return math.ceil(Time.realtimeSinceStartup)
end

function var1_0.SetServerTime(arg0_17, arg1_17, arg2_17)
	arg0_17:_SetServerTime_(arg1_17, arg2_17, arg0_17:RealtimeSinceStartup())
end

function var1_0._SetServerTime_(arg0_18, arg1_18, arg2_18, arg3_18)
	if PLATFORM_CODE == PLATFORM_US then
		SERVER_DAYLIGHT_SAVEING_TIME = false
	end

	arg0_18._isdstClient = os.date("*t").isdst
	arg0_18._serverUnitydelta = arg1_18 - arg3_18
	arg0_18._sAnchorTime = arg2_18 - (SERVER_DAYLIGHT_SAVEING_TIME and 3600 or 0)
	arg0_18._AnchorDelta = arg2_18 - os.time({
		year = 2020,
		month = 11,
		hour = 0,
		min = 0,
		sec = 0,
		day = 23,
		isdst = false
	})
end

function var1_0.GetServerTime(arg0_19)
	return arg0_19:RealtimeSinceStartup() + arg0_19._serverUnitydelta
end

function var1_0.GetServerWeek(arg0_20)
	local var0_20 = arg0_20:GetServerTime()

	return arg0_20:GetServerTimestampWeek(var0_20)
end

function var1_0.GetServerOverWeek(arg0_21, arg1_21)
	local var0_21 = arg1_21 - (arg0_21:GetServerTimestampWeek(arg1_21) - 1) * 86400

	return (math.ceil((arg0_21:GetServerTime() - var0_21) / 604800))
end

function var1_0.GetServerTimestampWeek(arg0_22, arg1_22)
	local var0_22 = arg1_22 - arg0_22._sAnchorTime

	return math.ceil((var0_22 % var4_0 + 1) / var3_0)
end

function var1_0.GetServerHour(arg0_23)
	local var0_23 = arg0_23:GetServerTime() - arg0_23._sAnchorTime

	return math.floor(var0_23 % var3_0 / var2_0)
end

function var1_0.Table2ServerTime(arg0_24, arg1_24)
	arg1_24.isdst = arg0_24._isdstClient

	if arg0_24._isdstClient ~= SERVER_DAYLIGHT_SAVEING_TIME then
		if SERVER_DAYLIGHT_SAVEING_TIME then
			return arg0_24._AnchorDelta + os.time(arg1_24) - var2_0
		else
			return arg0_24._AnchorDelta + os.time(arg1_24) + var2_0
		end
	else
		return arg0_24._AnchorDelta + os.time(arg1_24)
	end
end

function var1_0.CTimeDescC(arg0_25, arg1_25, arg2_25)
	arg2_25 = arg2_25 or "%Y%m%d%H%M%S"

	return os.date(arg2_25, arg1_25)
end

function var1_0.STimeDescC(arg0_26, arg1_26, arg2_26, arg3_26)
	originalPrint("Before : ", arg1_26)

	arg2_26 = arg2_26 or "%Y/%m/%d %H:%M:%S"

	if arg3_26 then
		originalPrint("2after : ", os.date(arg2_26, arg1_26))

		return os.date(arg2_26, arg1_26 + os.time() - arg0_26:GetServerTime())
	else
		originalPrint("1after : ", os.date(arg2_26, arg1_26))

		return os.date(arg2_26, arg1_26)
	end
end

function var1_0.STimeDescS(arg0_27, arg1_27, arg2_27)
	arg2_27 = arg2_27 or "%Y/%m/%d %H:%M:%S"

	local var0_27 = 0

	if arg0_27._isdstClient ~= SERVER_DAYLIGHT_SAVEING_TIME then
		var0_27 = SERVER_DAYLIGHT_SAVEING_TIME and 3600 or -3600
	end

	return os.date(arg2_27, arg1_27 - arg0_27._AnchorDelta + var0_27)
end

function var1_0.CurrentSTimeDesc(arg0_28, arg1_28, arg2_28)
	if arg2_28 then
		return arg0_28:STimeDescS(arg0_28:GetServerTime(), arg1_28)
	else
		return arg0_28:STimeDescC(arg0_28:GetServerTime(), arg1_28)
	end
end

function var1_0.ChieseDescTime(arg0_29, arg1_29, arg2_29)
	local var0_29 = "%Y/%m/%d"
	local var1_29

	if arg2_29 then
		var1_29 = os.date(var0_29, arg1_29)
	else
		var1_29 = os.date(var0_29, arg1_29 + os.time() - arg0_29:GetServerTime())
	end

	local var2_29 = split(var1_29, "/")

	return NumberToChinese(var2_29[1], false) .. "年" .. NumberToChinese(var2_29[2], true) .. "月" .. NumberToChinese(var2_29[3], true) .. "日"
end

function var1_0.GetTimeToNextTime(arg0_30, arg1_30, arg2_30, arg3_30)
	arg1_30 = arg1_30 or arg0_30:GetServerTime()
	arg2_30 = arg2_30 or var3_0
	arg3_30 = arg3_30 or 0

	local var0_30 = arg1_30 - (arg0_30._sAnchorTime + arg3_30)

	return math.floor(var0_30 / arg2_30 + 1) * arg2_30 + arg0_30._sAnchorTime + arg3_30
end

function var1_0.GetNextTime(arg0_31, arg1_31, arg2_31, arg3_31, arg4_31)
	return arg0_31:GetTimeToNextTime(nil, arg4_31, arg1_31 * var2_0 + arg2_31 * 60 + arg3_31)
end

function var1_0.GetNextTimeByTimeStamp(arg0_32, arg1_32)
	return arg0_32:GetTimeToNextTime(arg1_32) - var3_0
end

function var1_0.GetNextWeekTime(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	return arg0_33:GetNextTime((arg1_33 - 1) * 24 + arg2_33, arg3_33, arg4_33, var4_0)
end

function var1_0.ParseTime(arg0_34, arg1_34)
	local var0_34 = tonumber(arg1_34)
	local var1_34 = var0_34 % 100
	local var2_34 = var0_34 / 100
	local var3_34 = var2_34 % 100
	local var4_34 = var2_34 / 100
	local var5_34 = var4_34 % 100
	local var6_34 = var4_34 / 100
	local var7_34 = var6_34 % 100
	local var8_34 = var6_34 / 100
	local var9_34 = var8_34 % 100
	local var10_34 = var8_34 / 100

	return arg0_34:Table2ServerTime({
		year = var10_34,
		month = var9_34,
		day = var7_34,
		hour = var5_34,
		min = var3_34,
		sec = var1_34
	})
end

function var1_0.ParseTimeEx(arg0_35, arg1_35, arg2_35)
	if arg2_35 == nil then
		arg2_35 = "(%d+)%-(%d+)%-(%d+)%s(%d+)%:(%d+)%:(%d+)"
	end

	local var0_35, var1_35, var2_35, var3_35, var4_35, var5_35 = arg1_35:match(arg2_35)

	return arg0_35:Table2ServerTime({
		year = var0_35,
		month = var1_35,
		day = var2_35,
		hour = var3_35,
		min = var4_35,
		sec = var5_35
	})
end

function var1_0.parseTimeFromConfig(arg0_36, arg1_36)
	return arg0_36:Table2ServerTime({
		year = arg1_36[1][1],
		month = arg1_36[1][2],
		day = arg1_36[1][3],
		hour = arg1_36[2][1],
		min = arg1_36[2][2],
		sec = arg1_36[2][3]
	})
end

function var1_0.DescDateFromConfig(arg0_37, arg1_37, arg2_37)
	arg2_37 = arg2_37 or "%d.%02d.%02d"

	return string.format(arg2_37, arg1_37[1][1], arg1_37[1][2], arg1_37[1][3])
end

function var1_0.DescCDTime(arg0_38, arg1_38)
	local var0_38 = math.floor(arg1_38 / 3600)

	arg1_38 = arg1_38 % 3600

	local var1_38 = math.floor(arg1_38 / 60)

	arg1_38 = arg1_38 % 60

	return string.format("%02d:%02d:%02d", var0_38, var1_38, arg1_38)
end

function var1_0.DescCDTimeForMinute(arg0_39, arg1_39)
	local var0_39 = math.floor(arg1_39 / 3600)

	arg1_39 = arg1_39 % 3600

	local var1_39 = math.floor(arg1_39 / 60)

	arg1_39 = arg1_39 % 60

	return string.format("%02d:%02d", var1_39, arg1_39)
end

function var1_0.parseTimeFrom(arg0_40, arg1_40)
	local var0_40 = math.floor(arg1_40 / var3_0)
	local var1_40 = math.fmod(math.floor(arg1_40 / 3600), 24)
	local var2_40 = math.fmod(math.floor(arg1_40 / 60), 60)
	local var3_40 = math.fmod(arg1_40, 60)

	return var0_40, var1_40, var2_40, var3_40
end

function var1_0.DiffDay(arg0_41, arg1_41, arg2_41)
	return math.floor((arg2_41 - arg0_41._sAnchorTime) / var3_0) - math.floor((arg1_41 - arg0_41._sAnchorTime) / var3_0)
end

function var1_0.IsSameDay(arg0_42, arg1_42, arg2_42)
	return math.floor((arg1_42 - arg0_42._sAnchorTime) / var3_0) == math.floor((arg2_42 - arg0_42._sAnchorTime) / var3_0)
end

function var1_0.IsPassTimeByZero(arg0_43, arg1_43, arg2_43)
	return arg2_43 < math.fmod(arg1_43 - arg0_43._sAnchorTime, var3_0)
end

function var1_0.CalcMonthDays(arg0_44, arg1_44, arg2_44)
	local var0_44 = 30

	if arg2_44 == 2 then
		var0_44 = (arg1_44 % 4 == 0 and arg1_44 % 100 ~= 0 or arg1_44 % 400 == 0) and 29 or 28
	elseif _.include({
		1,
		3,
		5,
		7,
		8,
		10,
		12
	}, arg2_44) then
		var0_44 = 31
	end

	return var0_44
end

function var1_0.inPeriod(arg0_45, arg1_45, arg2_45)
	if arg1_45 and type(arg1_45) == "string" then
		return arg1_45 == "always"
	end

	if not arg1_45 or not arg2_45 then
		return true
	end

	local function var0_45(arg0_46)
		return arg0_46[1] * var2_0 + arg0_46[2] * 60 + arg0_46[3]
	end

	local var1_45 = (arg0_45:GetServerTime() - arg0_45._sAnchorTime) % var3_0
	local var2_45 = var0_45(arg1_45)
	local var3_45 = var0_45(arg2_45)

	return var2_45 <= var1_45 and var1_45 <= var3_45
end

function var1_0.inTime(arg0_47, arg1_47, arg2_47)
	if not arg1_47 then
		return true
	end

	if type(arg1_47) == "string" then
		return arg1_47 == "always"
	end

	if type(arg1_47[1]) == "string" then
		arg1_47 = {
			arg1_47[2],
			arg1_47[3]
		}
	end

	local function var0_47(arg0_48)
		return {
			year = arg0_48[1][1],
			month = arg0_48[1][2],
			day = arg0_48[1][3],
			hour = arg0_48[2][1],
			min = arg0_48[2][2],
			sec = arg0_48[2][3]
		}
	end

	local var1_47

	if #arg1_47 > 0 then
		var1_47 = var0_47(arg1_47[1] or {
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

	local var2_47

	if #arg1_47 > 1 then
		var2_47 = var0_47(arg1_47[2] or {
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

	local var3_47

	if var1_47 and var2_47 then
		local var4_47 = arg2_47 or arg0_47:GetServerTime()
		local var5_47 = arg0_47:Table2ServerTime(var1_47)
		local var6_47 = arg0_47:Table2ServerTime(var2_47)

		if var4_47 < var5_47 then
			return false, var1_47
		end

		if var6_47 < var4_47 then
			return false, nil
		end

		var3_47 = var2_47
	end

	return true, var3_47
end

function var1_0.passTime(arg0_49, arg1_49)
	if not arg1_49 then
		return true
	end

	local var0_49 = (function(arg0_50)
		local var0_50 = {}

		var0_50.year, var0_50.month, var0_50.day = unpack(arg0_50[1])
		var0_50.hour, var0_50.min, var0_50.sec = unpack(arg0_50[2])

		return var0_50
	end)(arg1_49 or {
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

	if var0_49 then
		return arg0_49:GetServerTime() > arg0_49:Table2ServerTime(var0_49)
	end

	return true
end
