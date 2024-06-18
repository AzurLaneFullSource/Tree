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

function var1_0.GetServerTimestampWeek(arg0_21, arg1_21)
	local var0_21 = arg1_21 - arg0_21._sAnchorTime

	return math.ceil((var0_21 % var4_0 + 1) / var3_0)
end

function var1_0.GetServerHour(arg0_22)
	local var0_22 = arg0_22:GetServerTime() - arg0_22._sAnchorTime

	return math.floor(var0_22 % var3_0 / var2_0)
end

function var1_0.Table2ServerTime(arg0_23, arg1_23)
	arg1_23.isdst = arg0_23._isdstClient

	if arg0_23._isdstClient ~= SERVER_DAYLIGHT_SAVEING_TIME then
		if SERVER_DAYLIGHT_SAVEING_TIME then
			return arg0_23._AnchorDelta + os.time(arg1_23) - var2_0
		else
			return arg0_23._AnchorDelta + os.time(arg1_23) + var2_0
		end
	else
		return arg0_23._AnchorDelta + os.time(arg1_23)
	end
end

function var1_0.CTimeDescC(arg0_24, arg1_24, arg2_24)
	arg2_24 = arg2_24 or "%Y%m%d%H%M%S"

	return os.date(arg2_24, arg1_24)
end

function var1_0.STimeDescC(arg0_25, arg1_25, arg2_25, arg3_25)
	originalPrint("Before : ", arg1_25)

	arg2_25 = arg2_25 or "%Y/%m/%d %H:%M:%S"

	if arg3_25 then
		originalPrint("2after : ", os.date(arg2_25, arg1_25))

		return os.date(arg2_25, arg1_25 + os.time() - arg0_25:GetServerTime())
	else
		originalPrint("1after : ", os.date(arg2_25, arg1_25))

		return os.date(arg2_25, arg1_25)
	end
end

function var1_0.STimeDescS(arg0_26, arg1_26, arg2_26)
	arg2_26 = arg2_26 or "%Y/%m/%d %H:%M:%S"

	local var0_26 = 0

	if arg0_26._isdstClient ~= SERVER_DAYLIGHT_SAVEING_TIME then
		var0_26 = SERVER_DAYLIGHT_SAVEING_TIME and 3600 or -3600
	end

	return os.date(arg2_26, arg1_26 - arg0_26._AnchorDelta + var0_26)
end

function var1_0.CurrentSTimeDesc(arg0_27, arg1_27, arg2_27)
	if arg2_27 then
		return arg0_27:STimeDescS(arg0_27:GetServerTime(), arg1_27)
	else
		return arg0_27:STimeDescC(arg0_27:GetServerTime(), arg1_27)
	end
end

function var1_0.ChieseDescTime(arg0_28, arg1_28, arg2_28)
	local var0_28 = "%Y/%m/%d"
	local var1_28

	if arg2_28 then
		var1_28 = os.date(var0_28, arg1_28)
	else
		var1_28 = os.date(var0_28, arg1_28 + os.time() - arg0_28:GetServerTime())
	end

	local var2_28 = split(var1_28, "/")

	return NumberToChinese(var2_28[1], false) .. "年" .. NumberToChinese(var2_28[2], true) .. "月" .. NumberToChinese(var2_28[3], true) .. "日"
end

function var1_0.GetTimeToNextTime(arg0_29, arg1_29, arg2_29, arg3_29)
	arg1_29 = arg1_29 or arg0_29:GetServerTime()
	arg2_29 = arg2_29 or var3_0
	arg3_29 = arg3_29 or 0

	local var0_29 = arg1_29 - (arg0_29._sAnchorTime + arg3_29)

	return math.floor(var0_29 / arg2_29 + 1) * arg2_29 + arg0_29._sAnchorTime + arg3_29
end

function var1_0.GetNextTime(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30)
	return arg0_30:GetTimeToNextTime(nil, arg4_30, arg1_30 * var2_0 + arg2_30 * 60 + arg3_30)
end

function var1_0.GetNextTimeByTimeStamp(arg0_31, arg1_31)
	return arg0_31:GetTimeToNextTime(arg1_31) - var3_0
end

function var1_0.GetNextWeekTime(arg0_32, arg1_32, arg2_32, arg3_32, arg4_32)
	return arg0_32:GetNextTime((arg1_32 - 1) * 24 + arg2_32, arg3_32, arg4_32, var4_0)
end

function var1_0.ParseTime(arg0_33, arg1_33)
	local var0_33 = tonumber(arg1_33)
	local var1_33 = var0_33 % 100
	local var2_33 = var0_33 / 100
	local var3_33 = var2_33 % 100
	local var4_33 = var2_33 / 100
	local var5_33 = var4_33 % 100
	local var6_33 = var4_33 / 100
	local var7_33 = var6_33 % 100
	local var8_33 = var6_33 / 100
	local var9_33 = var8_33 % 100
	local var10_33 = var8_33 / 100

	return arg0_33:Table2ServerTime({
		year = var10_33,
		month = var9_33,
		day = var7_33,
		hour = var5_33,
		min = var3_33,
		sec = var1_33
	})
end

function var1_0.ParseTimeEx(arg0_34, arg1_34, arg2_34)
	if arg2_34 == nil then
		arg2_34 = "(%d+)%-(%d+)%-(%d+)%s(%d+)%:(%d+)%:(%d+)"
	end

	local var0_34, var1_34, var2_34, var3_34, var4_34, var5_34 = arg1_34:match(arg2_34)

	return arg0_34:Table2ServerTime({
		year = var0_34,
		month = var1_34,
		day = var2_34,
		hour = var3_34,
		min = var4_34,
		sec = var5_34
	})
end

function var1_0.parseTimeFromConfig(arg0_35, arg1_35)
	return arg0_35:Table2ServerTime({
		year = arg1_35[1][1],
		month = arg1_35[1][2],
		day = arg1_35[1][3],
		hour = arg1_35[2][1],
		min = arg1_35[2][2],
		sec = arg1_35[2][3]
	})
end

function var1_0.DescDateFromConfig(arg0_36, arg1_36, arg2_36)
	arg2_36 = arg2_36 or "%d.%02d.%02d"

	return string.format(arg2_36, arg1_36[1][1], arg1_36[1][2], arg1_36[1][3])
end

function var1_0.DescCDTime(arg0_37, arg1_37)
	local var0_37 = math.floor(arg1_37 / 3600)

	arg1_37 = arg1_37 % 3600

	local var1_37 = math.floor(arg1_37 / 60)

	arg1_37 = arg1_37 % 60

	return string.format("%02d:%02d:%02d", var0_37, var1_37, arg1_37)
end

function var1_0.DescCDTimeForMinute(arg0_38, arg1_38)
	local var0_38 = math.floor(arg1_38 / 3600)

	arg1_38 = arg1_38 % 3600

	local var1_38 = math.floor(arg1_38 / 60)

	arg1_38 = arg1_38 % 60

	return string.format("%02d:%02d", var1_38, arg1_38)
end

function var1_0.parseTimeFrom(arg0_39, arg1_39)
	local var0_39 = math.floor(arg1_39 / var3_0)
	local var1_39 = math.fmod(math.floor(arg1_39 / 3600), 24)
	local var2_39 = math.fmod(math.floor(arg1_39 / 60), 60)
	local var3_39 = math.fmod(arg1_39, 60)

	return var0_39, var1_39, var2_39, var3_39
end

function var1_0.DiffDay(arg0_40, arg1_40, arg2_40)
	return math.floor((arg2_40 - arg0_40._sAnchorTime) / var3_0) - math.floor((arg1_40 - arg0_40._sAnchorTime) / var3_0)
end

function var1_0.IsSameDay(arg0_41, arg1_41, arg2_41)
	return math.floor((arg1_41 - arg0_41._sAnchorTime) / var3_0) == math.floor((arg2_41 - arg0_41._sAnchorTime) / var3_0)
end

function var1_0.IsPassTimeByZero(arg0_42, arg1_42, arg2_42)
	return arg2_42 < math.fmod(arg1_42 - arg0_42._sAnchorTime, var3_0)
end

function var1_0.CalcMonthDays(arg0_43, arg1_43, arg2_43)
	local var0_43 = 30

	if arg2_43 == 2 then
		var0_43 = (arg1_43 % 4 == 0 and arg1_43 % 100 ~= 0 or arg1_43 % 400 == 0) and 29 or 28
	elseif _.include({
		1,
		3,
		5,
		7,
		8,
		10,
		12
	}, arg2_43) then
		var0_43 = 31
	end

	return var0_43
end

function var1_0.inTime(arg0_44, arg1_44, arg2_44)
	if not arg1_44 then
		return true
	end

	if type(arg1_44) == "string" then
		return arg1_44 == "always"
	end

	if type(arg1_44[1]) == "string" then
		arg1_44 = {
			arg1_44[2],
			arg1_44[3]
		}
	end

	local function var0_44(arg0_45)
		return {
			year = arg0_45[1][1],
			month = arg0_45[1][2],
			day = arg0_45[1][3],
			hour = arg0_45[2][1],
			min = arg0_45[2][2],
			sec = arg0_45[2][3]
		}
	end

	local var1_44

	if #arg1_44 > 0 then
		var1_44 = var0_44(arg1_44[1] or {
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

	local var2_44

	if #arg1_44 > 1 then
		var2_44 = var0_44(arg1_44[2] or {
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

	local var3_44

	if var1_44 and var2_44 then
		local var4_44 = arg2_44 or arg0_44:GetServerTime()
		local var5_44 = arg0_44:Table2ServerTime(var1_44)
		local var6_44 = arg0_44:Table2ServerTime(var2_44)

		if var4_44 < var5_44 then
			return false, var1_44
		end

		if var6_44 < var4_44 then
			return false, nil
		end

		var3_44 = var2_44
	end

	return true, var3_44
end

function var1_0.passTime(arg0_46, arg1_46)
	if not arg1_46 then
		return true
	end

	local var0_46 = (function(arg0_47)
		local var0_47 = {}

		var0_47.year, var0_47.month, var0_47.day = unpack(arg0_47[1])
		var0_47.hour, var0_47.min, var0_47.sec = unpack(arg0_47[2])

		return var0_47
	end)(arg1_46 or {
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

	if var0_46 then
		return arg0_46:GetServerTime() > arg0_46:Table2ServerTime(var0_46)
	end

	return true
end
