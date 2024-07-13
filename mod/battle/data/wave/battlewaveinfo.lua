ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst.WaveTriggerType

var0_0.Battle.BattleWaveInfo = class("BattleWaveInfo")
var0_0.Battle.BattleWaveInfo.__name = "BattleWaveInfo"

local var2_0 = var0_0.Battle.BattleWaveInfo

var2_0.LOGIC_AND = 0
var2_0.LGOIC_OR = 1
var2_0.STATE_DEACTIVE = "STATE_DEACTIVE"
var2_0.STATE_ACTIVE = "STATE_ACTIVE"
var2_0.STATE_PASS = "STATE_PASS"
var2_0.STATE_FAIL = "STATE_FAIL"

function var2_0.Ctor(arg0_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)

	arg0_1._preWaves = {}
	arg0_1._postWaves = {}
	arg0_1._branchWaves = {}
end

function var2_0.IsReady(arg0_2)
	return arg0_2:IsPreWavesFinished()
end

function var2_0.IsFlagsPass(arg0_3)
	if not arg0_3._blockFlags or not next(arg0_3._blockFlags) then
		return true
	end

	local var0_3 = var0_0.Battle.BattleDataProxy.GetInstance():GetWaveFlags()

	if not var0_3 or not next(var0_3) then
		return false
	end

	for iter0_3, iter1_3 in ipairs(arg0_3._blockFlags) do
		if not table.contains(var0_3, iter1_3) then
			return false
		end
	end

	return true
end

function var2_0.IsPreWavesFinished(arg0_4)
	local var0_4 = #arg0_4._preWaves
	local var1_4

	if #arg0_4._preWaves == 0 then
		var1_4 = true
	elseif arg0_4._logicType == var2_0.LOGIC_AND then
		var1_4 = true

		for iter0_4, iter1_4 in ipairs(arg0_4._preWaves) do
			if not iter1_4:IsFinish() then
				var1_4 = false

				break
			end
		end
	elseif arg0_4._logicType == var2_0.LGOIC_OR then
		var1_4 = false

		for iter2_4, iter3_4 in ipairs(arg0_4._preWaves) do
			if iter3_4:IsFinish() then
				var1_4 = true

				break
			end
		end
	end

	return var1_4
end

function var2_0.IsFinish(arg0_5)
	return arg0_5:GetState() == var2_0.STATE_PASS or arg0_5:GetState() == var2_0.STATE_FAIL
end

function var2_0.DoBranch(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6._branchWaves) do
		local var0_6 = arg0_6._branchWaveIDs[iter1_6:GetIndex()]

		if var0_6 and iter1_6:GetState() == var2_0.STATE_PASS or not var0_6 and iter1_6:GetState() == var2_0.STATE_FAIL then
			-- block empty
		else
			arg0_6:doFail()

			return
		end
	end

	if not arg0_6:IsFlagsPass() then
		arg0_6:doFail()

		return
	end

	arg0_6:DoWave()
end

function var2_0.DoWave(arg0_7)
	arg0_7._state = var2_0.STATE_ACTIVE
end

function var2_0.AddMonster(arg0_8)
	return
end

function var2_0.RemoveMonster(arg0_9)
	return
end

function var2_0.SetWaveData(arg0_10, arg1_10)
	arg0_10._index = arg1_10.waveIndex
	arg0_10._isKeyWave = arg1_10.key
	arg0_10._logicType = arg1_10.conditionType or var2_0.LOGIC_AND
	arg0_10._param = arg1_10.triggerParams or {}
	arg0_10._preWaveIDs = arg1_10.preWaves or {}
	arg0_10._branchWaveIDs = arg1_10.conditionWaves or {}
	arg0_10._blockFlags = arg1_10.blockFlags
	arg0_10._type = arg1_10.triggerType
	arg0_10._state = var2_0.STATE_DEACTIVE
end

function var2_0.SetCallback(arg0_11, arg1_11, arg2_11)
	arg0_11._spawnFunc = arg1_11
	arg0_11._airFunc = arg2_11
end

function var2_0.AppendBranchWave(arg0_12, arg1_12)
	arg0_12._branchWaves[#arg0_12._branchWaves + 1] = arg1_12
end

function var2_0.AppendPreWave(arg0_13, arg1_13)
	arg0_13._preWaves[#arg0_13._preWaves + 1] = arg1_13
end

function var2_0.AppendPostWave(arg0_14, arg1_14)
	arg0_14._postWaves[#arg0_14._postWaves + 1] = arg1_14
end

function var2_0.IsKeyWave(arg0_15)
	return arg0_15._isKeyWave
end

function var2_0.GetPostWaves(arg0_16)
	return arg0_16._postWaves
end

function var2_0.GetIndex(arg0_17)
	return arg0_17._index
end

function var2_0.GetType(arg0_18)
	return arg0_18._type
end

function var2_0.GetState(arg0_19)
	return arg0_19._state
end

function var2_0.GetPreWaveIDs(arg0_20)
	return arg0_20._preWaveIDs
end

function var2_0.GetBranchWaveIDs(arg0_21)
	return arg0_21._branchWaveIDs
end

function var2_0.Dispose(arg0_22)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_22)
end

function var2_0.doPass(arg0_23)
	if not arg0_23:IsFinish() then
		arg0_23._state = var2_0.STATE_PASS

		arg0_23:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleEvent.WAVE_FINISH, {}))
	end
end

function var2_0.doFail(arg0_24)
	if not arg0_24:IsFinish() then
		arg0_24._state = var2_0.STATE_FAIL

		arg0_24:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleEvent.WAVE_FINISH, {}))
	end
end
