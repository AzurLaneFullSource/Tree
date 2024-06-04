ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst.WaveTriggerType
local var2 = class("BattleWaveUpdater")

var0.Battle.BattleWaveUpdater = var2
var2.__name = "BattleWaveUpdater"
var2.PREWAVES_CONDITION_AND = 0
var2.PREWAVES_CONDITION_OR = 1

function var2.Ctor(arg0, arg1, arg2, arg3, arg4)
	var0.EventListener.AttachEventListener(arg0)

	arg0._spawnFunc = arg1
	arg0._airFighterFunc = arg2
	arg0._clearFunc = arg3
	arg0._spawnAreaFunc = arg4

	arg0:Init()
end

function var2.Init(arg0)
	arg0._monsterList = {}
	arg0._spawnList = {}
	arg0._airFighter = {}
	arg0._waveInfos = {}
	arg0._timerList = {}
	arg0._waveUnitAliveList = {}
	arg0._keyList = {}
	arg0._waveInfoList = {}
end

function var2.SetWavesData(arg0, arg1)
	arg0._waveTmpData = arg1

	for iter0, iter1 in ipairs(arg1.waves) do
		local var0 = iter1.triggerType
		local var1

		if var0 == var1.NORMAL then
			var1 = var0.Battle.BattleSpawnWave.New()

			var1:SetCallback(arg0._spawnFunc, arg0._airFighterFunc)
		elseif var0 == var1.TIMER then
			var1 = var0.Battle.BattleDelayWave.New()
		elseif var0 == var1.RANGE then
			var1 = var0.Battle.BattleRangeWave.New()

			var1:SetCallback(arg0._spawnAreaFunc)
		elseif var0 == var1.STORY then
			var1 = var0.Battle.BattleStoryWave.New()
		elseif var0 == var1.AID then
			var1 = var0.Battle.BattleAidWave.New()
		elseif var0 == var1.BGM then
			var1 = var0.Battle.BattleSwitchBGMWave.New()
		elseif var0 == var1.GUIDE then
			var1 = var0.Battle.BattleGuideWave.New()
		elseif var0 == var1.CAMERA then
			var1 = var0.Battle.BattleCameraWave.New()
		elseif var0 == var1.CLEAR then
			var1 = var0.Battle.BattleClearWave.New()
		elseif var0 == var1.JAMMING then
			var1 = var0.Battle.BattleJammingWave.New()
		elseif var0 == var1.ENVIRONMENT then
			var1 = var0.Battle.BattleEnvironmentWave.New()
		elseif var0 == var1.LABEL then
			var1 = var0.Battle.BattleLabelWave.New()
		elseif var0 == var1.CARD_PUZZLE then
			var1 = var0.Battle.BattleCardPuzzleWave.New()
		end

		var1:SetWaveData(iter1)
		var1:RegisterEventListener(arg0, var0.Battle.BattleEvent.WAVE_FINISH, arg0.onWaveFinish)

		arg0._waveInfoList[var1:GetIndex()] = var1

		if var1:IsKeyWave() then
			arg0._keyList[#arg0._keyList + 1] = var1
		end
	end

	for iter2, iter3 in pairs(arg0._waveInfoList) do
		for iter4, iter5 in ipairs(iter3:GetPreWaveIDs()) do
			local var2 = arg0._waveInfoList[iter5]

			if var2 then
				iter3:AppendPreWave(var2)
				var2:AppendPostWave(iter3)
			end
		end

		for iter6, iter7 in pairs(iter3:GetBranchWaveIDs()) do
			local var3 = arg0._waveInfoList[iter6]

			if var3 then
				iter3:AppendBranchWave(var3)
			end
		end
	end
end

function var2.Start(arg0)
	arg0._active = true

	for iter0, iter1 in pairs(arg0._waveInfoList) do
		if iter1:IsReady() then
			iter1:DoBranch()
		end
	end
end

function var2.AddMonster(arg0, arg1)
	for iter0, iter1 in pairs(arg0._waveInfoList) do
		iter1:AddMonster(arg1)
	end
end

function var2.RemoveMonster(arg0, arg1)
	for iter0, iter1 in pairs(arg0._waveInfoList) do
		iter1:RemoveMonster(arg1)
	end
end

function var2.onWaveFinish(arg0, arg1)
	if not arg0._active then
		return
	end

	if arg0:CheckAllKeyWave() then
		arg0._active = false

		arg0._clearFunc()
	end

	local var0 = arg1.Dispatcher:GetPostWaves()

	for iter0, iter1 in ipairs(var0) do
		if iter1:IsReady() and iter1:GetState() == iter1.STATE_DEACTIVE then
			iter1:DoBranch()
		end
	end
end

function var2.GetAllBossWave(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0._waveInfoList) do
		if iter1:GetType() == var1.NORMAL and iter1:IsBossWave() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var2.CheckAllKeyWave(arg0)
	for iter0, iter1 in ipairs(arg0._keyList) do
		if not iter1:IsFinish() then
			return false
		end
	end

	return true
end

function var2.Clear(arg0)
	for iter0, iter1 in pairs(arg0._timerList) do
		arg0:RemoveTimer(iter0)
	end

	for iter2, iter3 in pairs(arg0._waveInfoList) do
		iter3:UnregisterEventListener(arg0, var0.Battle.BattleEvent.WAVE_FINISH)
		iter3:Dispose()
	end

	arg0._waveInfoList = nil
	arg0._keyList = nil

	arg0:Init()
	var0.EventListener.DetachEventListener(arg0)
end

function var2.GetUnfinishedWaveCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0._waveInfoList) do
		if not iter1:IsFinish() then
			var0 = var0 + 1
		end
	end

	return var0
end
