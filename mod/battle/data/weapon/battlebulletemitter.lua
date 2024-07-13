ys = ys or {}

local var0_0 = ys
local var1_0 = pg
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleDataFunction
local var4_0 = math
local var5_0 = class("BattleBulletEmitter")

var0_0.Battle.BattleBulletEmitter = var5_0
var5_0.__name = "BattleBulletEmitter"
var5_0.STATE_ACTIVE = "ACTIVE"
var5_0.STATE_STOP = "STOP"

function var5_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._spawnFunc = arg1_1
	arg0_1._stopFunc = arg2_1
	arg0_1._barrageID = arg3_1
	arg0_1._barrageTemp = var3_0.GetBarrageTmpDataFromID(arg3_1)
	arg0_1._offsetPriority = arg0_1._barrageTemp.offset_prioritise
	arg0_1._isRandomAngle = arg0_1._barrageTemp.random_angle
	arg0_1._timerList = {}

	if arg0_1._barrageTemp.delta_delay ~= 0 then
		arg0_1.PrimalIteration = arg0_1._advancePrimalIteration
	elseif arg0_1._barrageTemp.delay ~= 0 then
		arg0_1.PrimalIteration = arg0_1._averagePrimalIteration
	else
		arg0_1.PrimalIteration = arg0_1._nonDelayPrimalIteration
	end

	arg0_1._primalMax = arg0_1._barrageTemp.primal_repeat + 1

	function arg0_1.timerCb(arg0_2)
		arg0_1._timerList[arg0_2](arg0_1, arg0_2)
	end
end

function var5_0.Ready(arg0_3)
	arg0_3._state = arg0_3.STATE_ACTIVE
	arg0_3._seniorCounter = -1

	arg0_3:ClearAllTimer()
end

function var5_0.Fire(arg0_4, arg1_4, arg2_4)
	arg0_4._target = arg1_4
	arg0_4._dir = arg2_4 or var2_0.UnitDir.RIGHT

	if not arg0_4._convertedDirBarrage then
		arg0_4._convertedDirBarrage = var3_0.GetConvertedBarrageTableFromID(arg0_4._barrageID, arg0_4._dir)[arg0_4._dir]
	end

	arg0_4:SeniorIteration()
end

function var5_0.Stop(arg0_5)
	arg0_5._state = arg0_5.STATE_STOP
	arg0_5._target = nil

	arg0_5:ClearAllTimer()
	arg0_5._stopFunc(arg0_5)
end

function var5_0.Interrupt(arg0_6)
	arg0_6._state = arg0_6.STATE_STOP
	arg0_6._target = nil

	arg0_6:ClearAllTimer()
end

function var5_0.Destroy(arg0_7)
	arg0_7._spawnFunc = nil
	arg0_7._stopFunc = nil
	arg0_7._convertedDirBarrage = nil

	if arg0_7._timerList then
		arg0_7:ClearAllTimer()
	end
end

function var5_0.GetState(arg0_8)
	return arg0_8._state
end

function var5_0.ClearAllTimer(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9._timerList) do
		var1_0.TimeMgr.GetInstance():RemoveBattleTimer(iter0_9)
	end

	arg0_9._timerList = {}
end

function var5_0.GenerateBullet(arg0_10)
	local var0_10 = arg0_10._convertedDirBarrage[arg0_10._primalCounter]
	local var1_10 = var0_10.OffsetX

	arg0_10._delay = var0_10.Delay

	local var2_10

	if arg0_10._isRandomAngle then
		var2_10 = (var4_0.random() - 0.5) * var0_10.Angle
	else
		var2_10 = var0_10.Angle
	end

	local var3_10 = arg0_10._spawnFunc(var1_10, var0_10.OffsetZ, var2_10, arg0_10._offsetPriority, arg0_10._target, arg0_10._primalCounter)

	if var3_10 then
		local var4_10 = var3_0.GenerateTransBarrage(arg0_10._barrageID, arg0_10._dir, arg0_10._primalCounter)

		var3_10:SetBarrageTransformTempate(var4_10)
	end

	arg0_10:Interation()
end

function var5_0.DelaySeniorFunc(arg0_11, arg1_11)
	var1_0.TimeMgr.GetInstance():RemoveBattleTimer(arg1_11)

	arg0_11._timerList[arg1_11] = nil

	arg0_11:PrimalIteration()
end

function var5_0.SeniorIteration(arg0_12)
	if arg0_12._state ~= arg0_12.STATE_ACTIVE then
		return
	end

	arg0_12._seniorCounter = arg0_12._seniorCounter + 1

	if arg0_12._seniorCounter > arg0_12._barrageTemp.senior_repeat then
		arg0_12:Stop()
	else
		arg0_12:InitParam()

		local var0_12

		if arg0_12._seniorCounter == 0 then
			var0_12 = arg0_12._barrageTemp.first_delay
		else
			var0_12 = arg0_12._barrageTemp.senior_delay
		end

		if var0_12 > 0 then
			local var1_12 = var1_0.TimeMgr.GetInstance():AddBattleTimer("spawnBullet", -1, var0_12, arg0_12.timerCb, true)

			arg0_12._timerList[var1_12] = arg0_12.DelaySeniorFunc
		else
			arg0_12:PrimalIteration()
		end
	end
end

function var5_0.InitParam(arg0_13)
	arg0_13._delay = arg0_13._barrageTemp.delay
	arg0_13._primalCounter = 1
end

function var5_0.Interation(arg0_14)
	arg0_14._primalCounter = arg0_14._primalCounter + 1
end

function var5_0.SetTimeScale(arg0_15, arg1_15)
	if arg0_15._timerList then
		for iter0_15, iter1_15 in pairs(arg0_15._timerList) do
			iter0_15:SetScale(arg1_15)
		end
	end
end

function var5_0.DelayPrimalConst(arg0_16, arg1_16)
	arg0_16:GenerateBullet()

	if arg0_16._primalCounter > arg0_16._primalMax then
		var1_0.TimeMgr.GetInstance():RemoveBattleTimer(arg1_16)

		arg0_16._timerList[arg1_16] = nil

		arg0_16:SeniorIteration()
	end
end

function var5_0._averagePrimalIteration(arg0_17)
	if arg0_17._state ~= arg0_17.STATE_ACTIVE then
		return
	end

	local var0_17 = var1_0.TimeMgr.GetInstance():AddBattleTimer("spawnBullet", -1, arg0_17._delay, arg0_17.timerCb, true)

	arg0_17._timerList[var0_17] = arg0_17.DelayPrimalConst
end

function var5_0.DelayPrimalAdvance(arg0_18, arg1_18)
	var1_0.TimeMgr.GetInstance():RemoveBattleTimer(arg1_18)

	arg0_18._timerList[arg1_18] = nil

	arg0_18:GenerateBullet()

	if arg0_18._primalCounter > arg0_18._primalMax then
		arg0_18:SeniorIteration()
	else
		arg0_18:PrimalIteration()
	end
end

function var5_0._advancePrimalIteration(arg0_19)
	if arg0_19._state ~= arg0_19.STATE_ACTIVE then
		return
	end

	if arg0_19._delay == 0 then
		arg0_19:GenerateBullet()

		if arg0_19._primalCounter > arg0_19._primalMax then
			arg0_19:SeniorIteration()
		else
			arg0_19:PrimalIteration()
		end
	else
		local var0_19 = var1_0.TimeMgr.GetInstance():AddBattleTimer("spawnBullet", -1, arg0_19._delay, arg0_19.timerCb, true)

		arg0_19._timerList[var0_19] = arg0_19.DelayPrimalAdvance
	end
end

function var5_0._nonDelayPrimalIteration(arg0_20)
	if arg0_20._state ~= arg0_20.STATE_ACTIVE then
		return
	end

	arg0_20:GenerateBullet()

	if arg0_20._primalCounter > arg0_20._primalMax then
		arg0_20:SeniorIteration()
	else
		arg0_20:PrimalIteration()
	end
end
