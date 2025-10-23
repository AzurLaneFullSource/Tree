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
	return math.floor(Time.realtimeSinceStartup)
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

function var1_0.GetServerTimeMs(arg0_20)
	return math.ceil((Time.realtimeSinceStartup + arg0_20._serverUnitydelta) * 1000)
end

function var1_0.GetServerWeek(arg0_21)
	local var0_21 = arg0_21:GetServerTime()

	return arg0_21:GetServerTimestampWeek(var0_21)
end

function var1_0.GetServerOverWeek(arg0_22, arg1_22)
	local var0_22 = arg1_22 - (arg0_22:GetServerTimestampWeek(arg1_22) - 1) * 86400

	return (math.ceil((arg0_22:GetServerTime() - var0_22) / 604800))
end

function var1_0.GetServerTimestampWeek(arg0_23, arg1_23)
	local var0_23 = arg1_23 - arg0_23._sAnchorTime

	return math.ceil((var0_23 % var4_0 + 1) / var3_0)
end

function var1_0.GetServerHour(arg0_24)
	local var0_24 = arg0_24:GetServerTime() - arg0_24._sAnchorTime

	return math.floor(var0_24 % var3_0 / var2_0)
end

function var1_0.Table2ServerTime(arg0_25, arg1_25)
	arg1_25.isdst = arg0_25._isdstClient

	if arg0_25._isdstClient ~= SERVER_DAYLIGHT_SAVEING_TIME then
		if SERVER_DAYLIGHT_SAVEING_TIME then
			return arg0_25._AnchorDelta + os.time(arg1_25) - var2_0
		else
			return arg0_25._AnchorDelta + os.time(arg1_25) + var2_0
		end
	else
		return arg0_25._AnchorDelta + os.time(arg1_25)
	end
end

function var1_0.CTimeDescC(arg0_26, arg1_26, arg2_26)
	arg2_26 = arg2_26 or "%Y%m%d%H%M%S"

	return os.date(arg2_26, arg1_26)
end

function var1_0.STimeDescC(arg0_27, arg1_27, arg2_27, arg3_27)
	originalPrint("Before : ", arg1_27)

	arg2_27 = arg2_27 or "%Y/%m/%d %H:%M:%S"

	if arg3_27 then
		originalPrint("2after : ", os.date(arg2_27, arg1_27))

		return os.date(arg2_27, arg1_27 + os.time() - arg0_27:GetServerTime())
	else
		originalPrint("1after : ", os.date(arg2_27, arg1_27))

		return os.date(arg2_27, arg1_27)
	end
end

function var1_0.STimeDescS(arg0_28, arg1_28, arg2_28)
	arg2_28 = arg2_28 or "%Y/%m/%d %H:%M:%S"

	local var0_28 = 0

	if arg0_28._isdstClient ~= SERVER_DAYLIGHT_SAVEING_TIME then
		var0_28 = SERVER_DAYLIGHT_SAVEING_TIME and 3600 or -3600
	end

	return os.date(arg2_28, arg1_28 - arg0_28._AnchorDelta + var0_28)
end

function var1_0.CurrentSTimeDesc(arg0_29, arg1_29, arg2_29)
	if arg2_29 then
		return arg0_29:STimeDescS(arg0_29:GetServerTime(), arg1_29)
	else
		return arg0_29:STimeDescC(arg0_29:GetServerTime(), arg1_29)
	end
end

function var1_0.ChieseDescTime(arg0_30, arg1_30, arg2_30)
	local var0_30 = "%Y/%m/%d"
	local var1_30

	if arg2_30 then
		var1_30 = os.date(var0_30, arg1_30)
	else
		var1_30 = os.date(var0_30, arg1_30 + os.time() - arg0_30:GetServerTime())
	end

	local var2_30 = split(var1_30, "/")

	return NumberToChinese(var2_30[1], false) .. "年" .. NumberToChinese(var2_30[2], true) .. "月" .. NumberToChinese(var2_30[3], true) .. "日"
end

function var1_0.GetTimeToNextTime(arg0_31, arg1_31, arg2_31, arg3_31)
	arg1_31 = arg1_31 or arg0_31:GetServerTime()
	arg2_31 = arg2_31 or var3_0
	arg3_31 = arg3_31 or 0

	local var0_31 = arg1_31 - (arg0_31._sAnchorTime + arg3_31)

	return math.floor(var0_31 / arg2_31 + 1) * arg2_31 + arg0_31._sAnchorTime + arg3_31
end

function var1_0.GetNextTime(arg0_32, arg1_32, arg2_32, arg3_32, arg4_32)
	return arg0_32:GetTimeToNextTime(nil, arg4_32, arg1_32 * var2_0 + arg2_32 * 60 + arg3_32)
end

function var1_0.GetNextTimeByTimeStamp(arg0_33, arg1_33)
	return arg0_33:GetTimeToNextTime(arg1_33) - var3_0
end

function var1_0.GetNextWeekTime(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	return arg0_34:GetNextTime((arg1_34 - 1) * 24 + arg2_34, arg3_34, arg4_34, var4_0)
end

function var1_0.ParseTime(arg0_35, arg1_35)
	local var0_35 = tonumber(arg1_35)
	local var1_35 = var0_35 % 100
	local var2_35 = var0_35 / 100
	local var3_35 = var2_35 % 100
	local var4_35 = var2_35 / 100
	local var5_35 = var4_35 % 100
	local var6_35 = var4_35 / 100
	local var7_35 = var6_35 % 100
	local var8_35 = var6_35 / 100
	local var9_35 = var8_35 % 100
	local var10_35 = var8_35 / 100

	return arg0_35:Table2ServerTime({
		year = var10_35,
		month = var9_35,
		day = var7_35,
		hour = var5_35,
		min = var3_35,
		sec = var1_35
	})
end

function var1_0.ParseTimeEx(arg0_36, arg1_36, arg2_36)
	if arg2_36 == nil then
		arg2_36 = "(%d+)%-(%d+)%-(%d+)%s(%d+)%:(%d+)%:(%d+)"
	end

	local var0_36, var1_36, var2_36, var3_36, var4_36, var5_36 = arg1_36:match(arg2_36)

	return arg0_36:Table2ServerTime({
		year = var0_36,
		month = var1_36,
		day = var2_36,
		hour = var3_36,
		min = var4_36,
		sec = var5_36
	})
end

function var1_0.parseTimeFromConfig(arg0_37, arg1_37)
	return arg0_37:Table2ServerTime({
		year = arg1_37[1][1],
		month = arg1_37[1][2],
		day = arg1_37[1][3],
		hour = arg1_37[2][1],
		min = arg1_37[2][2],
		sec = arg1_37[2][3]
	})
end

function var1_0.DescDateFromConfig(arg0_38, arg1_38, arg2_38)
	arg2_38 = arg2_38 or "%d.%02d.%02d"

	return string.format(arg2_38, arg1_38[1][1], arg1_38[1][2], arg1_38[1][3])
end

function var1_0.DescCDTime(arg0_39, arg1_39)
	local var0_39 = math.floor(arg1_39 / 3600)

	arg1_39 = arg1_39 % 3600

	local var1_39 = math.floor(arg1_39 / 60)

	arg1_39 = arg1_39 % 60

	return string.format("%02d:%02d:%02d", var0_39, var1_39, arg1_39)
end

function var1_0.DescCDTimeForMinute(arg0_40, arg1_40)
	local var0_40 = math.floor(arg1_40 / 3600)

	arg1_40 = arg1_40 % 3600

	local var1_40 = math.floor(arg1_40 / 60)

	arg1_40 = arg1_40 % 60

	return string.format("%02d:%02d", var1_40, arg1_40)
end

function var1_0.parseTimeFrom(arg0_41, arg1_41)
	local var0_41 = math.floor(arg1_41 / var3_0)
	local var1_41 = math.fmod(math.floor(arg1_41 / 3600), 24)
	local var2_41 = math.fmod(math.floor(arg1_41 / 60), 60)
	local var3_41 = math.fmod(arg1_41, 60)

	return var0_41, var1_41, var2_41, var3_41
end

function var1_0.DiffDay(arg0_42, arg1_42, arg2_42)
	return math.floor((arg2_42 - arg0_42._sAnchorTime) / var3_0) - math.floor((arg1_42 - arg0_42._sAnchorTime) / var3_0)
end

function var1_0.IsSameDay(arg0_43, arg1_43, arg2_43)
	return math.floor((arg1_43 - arg0_43._sAnchorTime) / var3_0) == math.floor((arg2_43 - arg0_43._sAnchorTime) / var3_0)
end

function var1_0.IsSameWeek(arg0_44, arg1_44, arg2_44)
	return math.floor((arg1_44 - arg0_44._sAnchorTime) / var4_0) == math.floor((arg2_44 - arg0_44._sAnchorTime) / var4_0)
end

function var1_0.IsPassTimeByZero(arg0_45, arg1_45, arg2_45)
	return arg2_45 < math.fmod(arg1_45 - arg0_45._sAnchorTime, var3_0)
end

function var1_0.GetZeroTimeStamp(arg0_46, arg1_46)
	return arg1_46 - (arg1_46 - arg0_46._sAnchorTime) % var3_0
end

function var1_0.CalcMonthDays(arg0_47, arg1_47, arg2_47)
	local var0_47 = 30

	if arg2_47 == 2 then
		var0_47 = (arg1_47 % 4 == 0 and arg1_47 % 100 ~= 0 or arg1_47 % 400 == 0) and 29 or 28
	elseif _.include({
		1,
		3,
		5,
		7,
		8,
		10,
		12
	}, arg2_47) then
		var0_47 = 31
	end

	return var0_47
end

function var1_0.inPeriod(arg0_48, arg1_48, arg2_48)
	if arg1_48 and type(arg1_48) == "string" then
		return arg1_48 == "always"
	end

	if not arg1_48 or not arg2_48 then
		return true
	end

	local function var0_48(arg0_49)
		return arg0_49[1] * var2_0 + arg0_49[2] * 60 + arg0_49[3]
	end

	local var1_48 = (arg0_48:GetServerTime() - arg0_48._sAnchorTime) % var3_0
	local var2_48 = var0_48(arg1_48)
	local var3_48 = var0_48(arg2_48)

	return var2_48 <= var1_48 and var1_48 <= var3_48
end

function var1_0.inTime(arg0_50, arg1_50, arg2_50)
	if not arg1_50 then
		return true
	end

	if type(arg1_50) == "string" then
		return arg1_50 == "always"
	end

	if type(arg1_50[1]) == "string" then
		arg1_50 = {
			arg1_50[2],
			arg1_50[3]
		}
	end

	local function var0_50(arg0_51)
		return {
			year = arg0_51[1][1],
			month = arg0_51[1][2],
			day = arg0_51[1][3],
			hour = arg0_51[2][1],
			min = arg0_51[2][2],
			sec = arg0_51[2][3]
		}
	end

	local var1_50

	if #arg1_50 > 0 then
		var1_50 = var0_50(arg1_50[1] or {
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

	local var2_50

	if #arg1_50 > 1 then
		var2_50 = var0_50(arg1_50[2] or {
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

	local var3_50

	if var1_50 and var2_50 then
		local var4_50 = arg2_50 or arg0_50:GetServerTime()
		local var5_50 = arg0_50:Table2ServerTime(var1_50)
		local var6_50 = arg0_50:Table2ServerTime(var2_50)

		if var4_50 < var5_50 then
			return false, var1_50
		end

		if var6_50 < var4_50 then
			return false, nil
		end

		var3_50 = var2_50
	end

	return true, var3_50
end

function var1_0.passTime(arg0_52, arg1_52)
	if not arg1_52 then
		return true
	end

	local var0_52 = (function(arg0_53)
		local var0_53 = {}

		var0_53.year, var0_53.month, var0_53.day = unpack(arg0_53[1])
		var0_53.hour, var0_53.min, var0_53.sec = unpack(arg0_53[2])

		return var0_53
	end)(arg1_52 or {
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

	if var0_52 then
		return arg0_52:GetServerTime() > arg0_52:Table2ServerTime(var0_52)
	end

	return true
end
