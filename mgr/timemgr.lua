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

function var1_0.GetServerDay(arg0_23, arg1_23)
	return (math.ceil((arg0_23:GetServerTime() - arg1_23) / 86400))
end

function var1_0.GetServerTimestampWeek(arg0_24, arg1_24)
	local var0_24 = arg1_24 - arg0_24._sAnchorTime

	return math.ceil((var0_24 % var4_0 + 1) / var3_0)
end

function var1_0.GetServerHour(arg0_25)
	local var0_25 = arg0_25:GetServerTime() - arg0_25._sAnchorTime

	return math.floor(var0_25 % var3_0 / var2_0)
end

function var1_0.Table2ServerTime(arg0_26, arg1_26)
	arg1_26.isdst = arg0_26._isdstClient

	if arg0_26._isdstClient ~= SERVER_DAYLIGHT_SAVEING_TIME then
		if SERVER_DAYLIGHT_SAVEING_TIME then
			return arg0_26._AnchorDelta + os.time(arg1_26) - var2_0
		else
			return arg0_26._AnchorDelta + os.time(arg1_26) + var2_0
		end
	else
		return arg0_26._AnchorDelta + os.time(arg1_26)
	end
end

function var1_0.CTimeDescC(arg0_27, arg1_27, arg2_27)
	arg2_27 = arg2_27 or "%Y%m%d%H%M%S"

	return os.date(arg2_27, arg1_27)
end

function var1_0.STimeDescC(arg0_28, arg1_28, arg2_28, arg3_28)
	originalPrint("Before : ", arg1_28)

	arg2_28 = arg2_28 or "%Y/%m/%d %H:%M:%S"

	if arg3_28 then
		originalPrint("2after : ", os.date(arg2_28, arg1_28))

		return os.date(arg2_28, arg1_28 + os.time() - arg0_28:GetServerTime())
	else
		originalPrint("1after : ", os.date(arg2_28, arg1_28))

		return os.date(arg2_28, arg1_28)
	end
end

function var1_0.STimeDescS(arg0_29, arg1_29, arg2_29)
	arg2_29 = arg2_29 or "%Y/%m/%d %H:%M:%S"

	local var0_29 = 0

	if arg0_29._isdstClient ~= SERVER_DAYLIGHT_SAVEING_TIME then
		var0_29 = SERVER_DAYLIGHT_SAVEING_TIME and 3600 or -3600
	end

	return os.date(arg2_29, arg1_29 - arg0_29._AnchorDelta + var0_29)
end

function var1_0.CurrentSTimeDesc(arg0_30, arg1_30, arg2_30)
	if arg2_30 then
		return arg0_30:STimeDescS(arg0_30:GetServerTime(), arg1_30)
	else
		return arg0_30:STimeDescC(arg0_30:GetServerTime(), arg1_30)
	end
end

function var1_0.ChieseDescTime(arg0_31, arg1_31, arg2_31)
	local var0_31 = "%Y/%m/%d"
	local var1_31

	if arg2_31 then
		var1_31 = os.date(var0_31, arg1_31)
	else
		var1_31 = os.date(var0_31, arg1_31 + os.time() - arg0_31:GetServerTime())
	end

	local var2_31 = split(var1_31, "/")

	return NumberToChinese(var2_31[1], false) .. "年" .. NumberToChinese(var2_31[2], true) .. "月" .. NumberToChinese(var2_31[3], true) .. "日"
end

function var1_0.GetTimeToNextTime(arg0_32, arg1_32, arg2_32, arg3_32)
	arg1_32 = arg1_32 or arg0_32:GetServerTime()
	arg2_32 = arg2_32 or var3_0
	arg3_32 = arg3_32 or 0

	local var0_32 = arg1_32 - (arg0_32._sAnchorTime + arg3_32)

	return math.floor(var0_32 / arg2_32 + 1) * arg2_32 + arg0_32._sAnchorTime + arg3_32
end

function var1_0.GetNextTime(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	return arg0_33:GetTimeToNextTime(nil, arg4_33, arg1_33 * var2_0 + arg2_33 * 60 + arg3_33)
end

function var1_0.GetNextTimeByTimeStamp(arg0_34, arg1_34)
	return arg0_34:GetTimeToNextTime(arg1_34) - var3_0
end

function var1_0.GetNextWeekTime(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35)
	return arg0_35:GetNextTime((arg1_35 - 1) * 24 + arg2_35, arg3_35, arg4_35, var4_0)
end

function var1_0.ParseTime(arg0_36, arg1_36)
	local var0_36 = tonumber(arg1_36)
	local var1_36 = var0_36 % 100
	local var2_36 = var0_36 / 100
	local var3_36 = var2_36 % 100
	local var4_36 = var2_36 / 100
	local var5_36 = var4_36 % 100
	local var6_36 = var4_36 / 100
	local var7_36 = var6_36 % 100
	local var8_36 = var6_36 / 100
	local var9_36 = var8_36 % 100
	local var10_36 = var8_36 / 100

	return arg0_36:Table2ServerTime({
		year = var10_36,
		month = var9_36,
		day = var7_36,
		hour = var5_36,
		min = var3_36,
		sec = var1_36
	})
end

function var1_0.ParseTimeEx(arg0_37, arg1_37, arg2_37)
	if arg2_37 == nil then
		arg2_37 = "(%d+)%-(%d+)%-(%d+)%s(%d+)%:(%d+)%:(%d+)"
	end

	local var0_37, var1_37, var2_37, var3_37, var4_37, var5_37 = arg1_37:match(arg2_37)

	return arg0_37:Table2ServerTime({
		year = var0_37,
		month = var1_37,
		day = var2_37,
		hour = var3_37,
		min = var4_37,
		sec = var5_37
	})
end

function var1_0.parseTimeFromConfig(arg0_38, arg1_38)
	return arg0_38:Table2ServerTime({
		year = arg1_38[1][1],
		month = arg1_38[1][2],
		day = arg1_38[1][3],
		hour = arg1_38[2][1],
		min = arg1_38[2][2],
		sec = arg1_38[2][3]
	})
end

function var1_0.DescDateFromConfig(arg0_39, arg1_39, arg2_39)
	arg2_39 = arg2_39 or "%d.%02d.%02d"

	return string.format(arg2_39, arg1_39[1][1], arg1_39[1][2], arg1_39[1][3])
end

function var1_0.DescCDTime(arg0_40, arg1_40)
	local var0_40 = arg1_40 < 0 and "-" or ""
	local var1_40 = math.abs(arg1_40)
	local var2_40 = math.floor(var1_40 / 3600)
	local var3_40 = var1_40 % 3600
	local var4_40 = math.floor(var3_40 / 60)
	local var5_40 = var3_40 % 60

	return var0_40 .. string.format("%02d:%02d:%02d", var2_40, var4_40, var5_40)
end

function var1_0.DescCDTimeForMinute(arg0_41, arg1_41)
	local var0_41 = arg1_41 < 0 and "-" or ""
	local var1_41 = math.abs(arg1_41)
	local var2_41 = math.floor(var1_41 / 3600)
	local var3_41 = var1_41 % 3600
	local var4_41 = math.floor(var3_41 / 60)
	local var5_41 = var3_41 % 60

	return var0_41 .. string.format("%02d:%02d", var4_41, var5_41)
end

function var1_0.parseTimeFrom(arg0_42, arg1_42)
	local var0_42 = math.floor(arg1_42 / var3_0)
	local var1_42 = math.fmod(math.floor(arg1_42 / 3600), 24)
	local var2_42 = math.fmod(math.floor(arg1_42 / 60), 60)
	local var3_42 = math.fmod(arg1_42, 60)

	return var0_42, var1_42, var2_42, var3_42
end

function var1_0.DiffDay(arg0_43, arg1_43, arg2_43)
	return math.floor((arg2_43 - arg0_43._sAnchorTime) / var3_0) - math.floor((arg1_43 - arg0_43._sAnchorTime) / var3_0)
end

function var1_0.IsSameDay(arg0_44, arg1_44, arg2_44)
	return math.floor((arg1_44 - arg0_44._sAnchorTime) / var3_0) == math.floor((arg2_44 - arg0_44._sAnchorTime) / var3_0)
end

function var1_0.IsSameWeek(arg0_45, arg1_45, arg2_45)
	return math.floor((arg1_45 - arg0_45._sAnchorTime) / var4_0) == math.floor((arg2_45 - arg0_45._sAnchorTime) / var4_0)
end

function var1_0.IsPassTimeByZero(arg0_46, arg1_46, arg2_46)
	return arg2_46 < math.fmod(arg1_46 - arg0_46._sAnchorTime, var3_0)
end

function var1_0.GetZeroTimeStamp(arg0_47, arg1_47)
	return arg1_47 - (arg1_47 - arg0_47._sAnchorTime) % var3_0
end

function var1_0.CalcMonthDays(arg0_48, arg1_48, arg2_48)
	local var0_48 = 30

	if arg2_48 == 2 then
		var0_48 = (arg1_48 % 4 == 0 and arg1_48 % 100 ~= 0 or arg1_48 % 400 == 0) and 29 or 28
	elseif _.include({
		1,
		3,
		5,
		7,
		8,
		10,
		12
	}, arg2_48) then
		var0_48 = 31
	end

	return var0_48
end

function var1_0.inPeriod(arg0_49, arg1_49, arg2_49)
	if arg1_49 and type(arg1_49) == "string" then
		return arg1_49 == "always"
	end

	if not arg1_49 or not arg2_49 then
		return true
	end

	local function var0_49(arg0_50)
		return arg0_50[1] * var2_0 + arg0_50[2] * 60 + arg0_50[3]
	end

	local var1_49 = (arg0_49:GetServerTime() - arg0_49._sAnchorTime) % var3_0
	local var2_49 = var0_49(arg1_49)
	local var3_49 = var0_49(arg2_49)

	return var2_49 <= var1_49 and var1_49 <= var3_49
end

function var1_0.inTime(arg0_51, arg1_51, arg2_51)
	if not arg1_51 then
		return true
	end

	if type(arg1_51) == "string" then
		return arg1_51 == "always"
	end

	if type(arg1_51[1]) == "string" then
		arg1_51 = {
			arg1_51[2],
			arg1_51[3]
		}
	end

	local function var0_51(arg0_52)
		return {
			year = arg0_52[1][1],
			month = arg0_52[1][2],
			day = arg0_52[1][3],
			hour = arg0_52[2][1],
			min = arg0_52[2][2],
			sec = arg0_52[2][3]
		}
	end

	local var1_51

	if #arg1_51 > 0 then
		var1_51 = var0_51(arg1_51[1] or {
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

	local var2_51

	if #arg1_51 > 1 then
		var2_51 = var0_51(arg1_51[2] or {
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

	local var3_51

	if var1_51 and var2_51 then
		local var4_51 = arg2_51 or arg0_51:GetServerTime()
		local var5_51 = arg0_51:Table2ServerTime(var1_51)
		local var6_51 = arg0_51:Table2ServerTime(var2_51)

		if var4_51 < var5_51 then
			return false, var1_51
		end

		if var6_51 < var4_51 then
			return false, nil
		end

		var3_51 = var2_51
	end

	return true, var3_51
end

function var1_0.passTime(arg0_53, arg1_53)
	if not arg1_53 then
		return true
	end

	local var0_53 = (function(arg0_54)
		local var0_54 = {}

		var0_54.year, var0_54.month, var0_54.day = unpack(arg0_54[1])
		var0_54.hour, var0_54.min, var0_54.sec = unpack(arg0_54[2])

		return var0_54
	end)(arg1_53 or {
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

	if var0_53 then
		return arg0_53:GetServerTime() > arg0_53:Table2ServerTime(var0_53)
	end

	return true
end
