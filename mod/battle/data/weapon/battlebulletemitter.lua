ys = ys or {}

local var0 = ys
local var1 = pg
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleDataFunction
local var4 = math
local var5 = class("BattleBulletEmitter")

var0.Battle.BattleBulletEmitter = var5
var5.__name = "BattleBulletEmitter"
var5.STATE_ACTIVE = "ACTIVE"
var5.STATE_STOP = "STOP"

function var5.Ctor(arg0, arg1, arg2, arg3)
	arg0._spawnFunc = arg1
	arg0._stopFunc = arg2
	arg0._barrageID = arg3
	arg0._barrageTemp = var3.GetBarrageTmpDataFromID(arg3)
	arg0._offsetPriority = arg0._barrageTemp.offset_prioritise
	arg0._isRandomAngle = arg0._barrageTemp.random_angle
	arg0._timerList = {}

	if arg0._barrageTemp.delta_delay ~= 0 then
		arg0.PrimalIteration = arg0._advancePrimalIteration
	elseif arg0._barrageTemp.delay ~= 0 then
		arg0.PrimalIteration = arg0._averagePrimalIteration
	else
		arg0.PrimalIteration = arg0._nonDelayPrimalIteration
	end

	arg0._primalMax = arg0._barrageTemp.primal_repeat + 1

	function arg0.timerCb(arg0)
		arg0._timerList[arg0](arg0, arg0)
	end
end

function var5.Ready(arg0)
	arg0._state = arg0.STATE_ACTIVE
	arg0._seniorCounter = -1

	arg0:ClearAllTimer()
end

function var5.Fire(arg0, arg1, arg2)
	arg0._target = arg1
	arg0._dir = arg2 or var2.UnitDir.RIGHT

	if not arg0._convertedDirBarrage then
		arg0._convertedDirBarrage = var3.GetConvertedBarrageTableFromID(arg0._barrageID, arg0._dir)[arg0._dir]
	end

	arg0:SeniorIteration()
end

function var5.Stop(arg0)
	arg0._state = arg0.STATE_STOP
	arg0._target = nil

	arg0:ClearAllTimer()
	arg0._stopFunc(arg0)
end

function var5.Interrupt(arg0)
	arg0._state = arg0.STATE_STOP
	arg0._target = nil

	arg0:ClearAllTimer()
end

function var5.Destroy(arg0)
	arg0._spawnFunc = nil
	arg0._stopFunc = nil
	arg0._convertedDirBarrage = nil

	if arg0._timerList then
		arg0:ClearAllTimer()
	end
end

function var5.GetState(arg0)
	return arg0._state
end

function var5.ClearAllTimer(arg0)
	for iter0, iter1 in pairs(arg0._timerList) do
		var1.TimeMgr.GetInstance():RemoveBattleTimer(iter0)
	end

	arg0._timerList = {}
end

function var5.GenerateBullet(arg0)
	local var0 = arg0._convertedDirBarrage[arg0._primalCounter]
	local var1 = var0.OffsetX

	arg0._delay = var0.Delay

	local var2

	if arg0._isRandomAngle then
		var2 = (var4.random() - 0.5) * var0.Angle
	else
		var2 = var0.Angle
	end

	local var3 = arg0._spawnFunc(var1, var0.OffsetZ, var2, arg0._offsetPriority, arg0._target, arg0._primalCounter)

	if var3 then
		local var4 = var3.GenerateTransBarrage(arg0._barrageID, arg0._dir, arg0._primalCounter)

		var3:SetBarrageTransformTempate(var4)
	end

	arg0:Interation()
end

function var5.DelaySeniorFunc(arg0, arg1)
	var1.TimeMgr.GetInstance():RemoveBattleTimer(arg1)

	arg0._timerList[arg1] = nil

	arg0:PrimalIteration()
end

function var5.SeniorIteration(arg0)
	if arg0._state ~= arg0.STATE_ACTIVE then
		return
	end

	arg0._seniorCounter = arg0._seniorCounter + 1

	if arg0._seniorCounter > arg0._barrageTemp.senior_repeat then
		arg0:Stop()
	else
		arg0:InitParam()

		local var0

		if arg0._seniorCounter == 0 then
			var0 = arg0._barrageTemp.first_delay
		else
			var0 = arg0._barrageTemp.senior_delay
		end

		if var0 > 0 then
			local var1 = var1.TimeMgr.GetInstance():AddBattleTimer("spawnBullet", -1, var0, arg0.timerCb, true)

			arg0._timerList[var1] = arg0.DelaySeniorFunc
		else
			arg0:PrimalIteration()
		end
	end
end

function var5.InitParam(arg0)
	arg0._delay = arg0._barrageTemp.delay
	arg0._primalCounter = 1
end

function var5.Interation(arg0)
	arg0._primalCounter = arg0._primalCounter + 1
end

function var5.SetTimeScale(arg0, arg1)
	if arg0._timerList then
		for iter0, iter1 in pairs(arg0._timerList) do
			iter0:SetScale(arg1)
		end
	end
end

function var5.DelayPrimalConst(arg0, arg1)
	arg0:GenerateBullet()

	if arg0._primalCounter > arg0._primalMax then
		var1.TimeMgr.GetInstance():RemoveBattleTimer(arg1)

		arg0._timerList[arg1] = nil

		arg0:SeniorIteration()
	end
end

function var5._averagePrimalIteration(arg0)
	if arg0._state ~= arg0.STATE_ACTIVE then
		return
	end

	local var0 = var1.TimeMgr.GetInstance():AddBattleTimer("spawnBullet", -1, arg0._delay, arg0.timerCb, true)

	arg0._timerList[var0] = arg0.DelayPrimalConst
end

function var5.DelayPrimalAdvance(arg0, arg1)
	var1.TimeMgr.GetInstance():RemoveBattleTimer(arg1)

	arg0._timerList[arg1] = nil

	arg0:GenerateBullet()

	if arg0._primalCounter > arg0._primalMax then
		arg0:SeniorIteration()
	else
		arg0:PrimalIteration()
	end
end

function var5._advancePrimalIteration(arg0)
	if arg0._state ~= arg0.STATE_ACTIVE then
		return
	end

	if arg0._delay == 0 then
		arg0:GenerateBullet()

		if arg0._primalCounter > arg0._primalMax then
			arg0:SeniorIteration()
		else
			arg0:PrimalIteration()
		end
	else
		local var0 = var1.TimeMgr.GetInstance():AddBattleTimer("spawnBullet", -1, arg0._delay, arg0.timerCb, true)

		arg0._timerList[var0] = arg0.DelayPrimalAdvance
	end
end

function var5._nonDelayPrimalIteration(arg0)
	if arg0._state ~= arg0.STATE_ACTIVE then
		return
	end

	arg0:GenerateBullet()

	if arg0._primalCounter > arg0._primalMax then
		arg0:SeniorIteration()
	else
		arg0:PrimalIteration()
	end
end
