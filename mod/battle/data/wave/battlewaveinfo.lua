ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst.WaveTriggerType

var0.Battle.BattleWaveInfo = class("BattleWaveInfo")
var0.Battle.BattleWaveInfo.__name = "BattleWaveInfo"

local var2 = var0.Battle.BattleWaveInfo

var2.LOGIC_AND = 0
var2.LGOIC_OR = 1
var2.STATE_DEACTIVE = "STATE_DEACTIVE"
var2.STATE_ACTIVE = "STATE_ACTIVE"
var2.STATE_PASS = "STATE_PASS"
var2.STATE_FAIL = "STATE_FAIL"

function var2.Ctor(arg0)
	var0.EventDispatcher.AttachEventDispatcher(arg0)

	arg0._preWaves = {}
	arg0._postWaves = {}
	arg0._branchWaves = {}
end

function var2.IsReady(arg0)
	return arg0:IsPreWavesFinished()
end

function var2.IsFlagsPass(arg0)
	if not arg0._blockFlags or not next(arg0._blockFlags) then
		return true
	end

	local var0 = var0.Battle.BattleDataProxy.GetInstance():GetWaveFlags()

	if not var0 or not next(var0) then
		return false
	end

	for iter0, iter1 in ipairs(arg0._blockFlags) do
		if not table.contains(var0, iter1) then
			return false
		end
	end

	return true
end

function var2.IsPreWavesFinished(arg0)
	local var0 = #arg0._preWaves
	local var1

	if #arg0._preWaves == 0 then
		var1 = true
	elseif arg0._logicType == var2.LOGIC_AND then
		var1 = true

		for iter0, iter1 in ipairs(arg0._preWaves) do
			if not iter1:IsFinish() then
				var1 = false

				break
			end
		end
	elseif arg0._logicType == var2.LGOIC_OR then
		var1 = false

		for iter2, iter3 in ipairs(arg0._preWaves) do
			if iter3:IsFinish() then
				var1 = true

				break
			end
		end
	end

	return var1
end

function var2.IsFinish(arg0)
	return arg0:GetState() == var2.STATE_PASS or arg0:GetState() == var2.STATE_FAIL
end

function var2.DoBranch(arg0)
	for iter0, iter1 in ipairs(arg0._branchWaves) do
		local var0 = arg0._branchWaveIDs[iter1:GetIndex()]

		if var0 and iter1:GetState() == var2.STATE_PASS or not var0 and iter1:GetState() == var2.STATE_FAIL then
			-- block empty
		else
			arg0:doFail()

			return
		end
	end

	if not arg0:IsFlagsPass() then
		arg0:doFail()

		return
	end

	arg0:DoWave()
end

function var2.DoWave(arg0)
	arg0._state = var2.STATE_ACTIVE
end

function var2.AddMonster(arg0)
	return
end

function var2.RemoveMonster(arg0)
	return
end

function var2.SetWaveData(arg0, arg1)
	arg0._index = arg1.waveIndex
	arg0._isKeyWave = arg1.key
	arg0._logicType = arg1.conditionType or var2.LOGIC_AND
	arg0._param = arg1.triggerParams or {}
	arg0._preWaveIDs = arg1.preWaves or {}
	arg0._branchWaveIDs = arg1.conditionWaves or {}
	arg0._blockFlags = arg1.blockFlags
	arg0._type = arg1.triggerType
	arg0._state = var2.STATE_DEACTIVE
end

function var2.SetCallback(arg0, arg1, arg2)
	arg0._spawnFunc = arg1
	arg0._airFunc = arg2
end

function var2.AppendBranchWave(arg0, arg1)
	arg0._branchWaves[#arg0._branchWaves + 1] = arg1
end

function var2.AppendPreWave(arg0, arg1)
	arg0._preWaves[#arg0._preWaves + 1] = arg1
end

function var2.AppendPostWave(arg0, arg1)
	arg0._postWaves[#arg0._postWaves + 1] = arg1
end

function var2.IsKeyWave(arg0)
	return arg0._isKeyWave
end

function var2.GetPostWaves(arg0)
	return arg0._postWaves
end

function var2.GetIndex(arg0)
	return arg0._index
end

function var2.GetType(arg0)
	return arg0._type
end

function var2.GetState(arg0)
	return arg0._state
end

function var2.GetPreWaveIDs(arg0)
	return arg0._preWaveIDs
end

function var2.GetBranchWaveIDs(arg0)
	return arg0._branchWaveIDs
end

function var2.Dispose(arg0)
	var0.EventDispatcher.DetachEventDispatcher(arg0)
end

function var2.doPass(arg0)
	if not arg0:IsFinish() then
		arg0._state = var2.STATE_PASS

		arg0:DispatchEvent(var0.Event.New(var0.Battle.BattleEvent.WAVE_FINISH, {}))
	end
end

function var2.doFail(arg0)
	if not arg0:IsFinish() then
		arg0._state = var2.STATE_FAIL

		arg0:DispatchEvent(var0.Event.New(var0.Battle.BattleEvent.WAVE_FINISH, {}))
	end
end
