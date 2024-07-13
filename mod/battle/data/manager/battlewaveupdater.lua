ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst.WaveTriggerType
local var2_0 = class("BattleWaveUpdater")

var0_0.Battle.BattleWaveUpdater = var2_0
var2_0.__name = "BattleWaveUpdater"
var2_0.PREWAVES_CONDITION_AND = 0
var2_0.PREWAVES_CONDITION_OR = 1

function var2_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.EventListener.AttachEventListener(arg0_1)

	arg0_1._spawnFunc = arg1_1
	arg0_1._airFighterFunc = arg2_1
	arg0_1._clearFunc = arg3_1
	arg0_1._spawnAreaFunc = arg4_1

	arg0_1:Init()
end

function var2_0.Init(arg0_2)
	arg0_2._monsterList = {}
	arg0_2._spawnList = {}
	arg0_2._airFighter = {}
	arg0_2._waveInfos = {}
	arg0_2._timerList = {}
	arg0_2._waveUnitAliveList = {}
	arg0_2._keyList = {}
	arg0_2._waveInfoList = {}
end

function var2_0.SetWavesData(arg0_3, arg1_3)
	arg0_3._waveTmpData = arg1_3

	for iter0_3, iter1_3 in ipairs(arg1_3.waves) do
		local var0_3 = iter1_3.triggerType
		local var1_3

		if var0_3 == var1_0.NORMAL then
			var1_3 = var0_0.Battle.BattleSpawnWave.New()

			var1_3:SetCallback(arg0_3._spawnFunc, arg0_3._airFighterFunc)
		elseif var0_3 == var1_0.TIMER then
			var1_3 = var0_0.Battle.BattleDelayWave.New()
		elseif var0_3 == var1_0.RANGE then
			var1_3 = var0_0.Battle.BattleRangeWave.New()

			var1_3:SetCallback(arg0_3._spawnAreaFunc)
		elseif var0_3 == var1_0.STORY then
			var1_3 = var0_0.Battle.BattleStoryWave.New()
		elseif var0_3 == var1_0.AID then
			var1_3 = var0_0.Battle.BattleAidWave.New()
		elseif var0_3 == var1_0.BGM then
			var1_3 = var0_0.Battle.BattleSwitchBGMWave.New()
		elseif var0_3 == var1_0.GUIDE then
			var1_3 = var0_0.Battle.BattleGuideWave.New()
		elseif var0_3 == var1_0.CAMERA then
			var1_3 = var0_0.Battle.BattleCameraWave.New()
		elseif var0_3 == var1_0.CLEAR then
			var1_3 = var0_0.Battle.BattleClearWave.New()
		elseif var0_3 == var1_0.JAMMING then
			var1_3 = var0_0.Battle.BattleJammingWave.New()
		elseif var0_3 == var1_0.ENVIRONMENT then
			var1_3 = var0_0.Battle.BattleEnvironmentWave.New()
		elseif var0_3 == var1_0.LABEL then
			var1_3 = var0_0.Battle.BattleLabelWave.New()
		elseif var0_3 == var1_0.CARD_PUZZLE then
			var1_3 = var0_0.Battle.BattleCardPuzzleWave.New()
		end

		var1_3:SetWaveData(iter1_3)
		var1_3:RegisterEventListener(arg0_3, var0_0.Battle.BattleEvent.WAVE_FINISH, arg0_3.onWaveFinish)

		arg0_3._waveInfoList[var1_3:GetIndex()] = var1_3

		if var1_3:IsKeyWave() then
			arg0_3._keyList[#arg0_3._keyList + 1] = var1_3
		end
	end

	for iter2_3, iter3_3 in pairs(arg0_3._waveInfoList) do
		for iter4_3, iter5_3 in ipairs(iter3_3:GetPreWaveIDs()) do
			local var2_3 = arg0_3._waveInfoList[iter5_3]

			if var2_3 then
				iter3_3:AppendPreWave(var2_3)
				var2_3:AppendPostWave(iter3_3)
			end
		end

		for iter6_3, iter7_3 in pairs(iter3_3:GetBranchWaveIDs()) do
			local var3_3 = arg0_3._waveInfoList[iter6_3]

			if var3_3 then
				iter3_3:AppendBranchWave(var3_3)
			end
		end
	end
end

function var2_0.Start(arg0_4)
	arg0_4._active = true

	for iter0_4, iter1_4 in pairs(arg0_4._waveInfoList) do
		if iter1_4:IsReady() then
			iter1_4:DoBranch()
		end
	end
end

function var2_0.AddMonster(arg0_5, arg1_5)
	for iter0_5, iter1_5 in pairs(arg0_5._waveInfoList) do
		iter1_5:AddMonster(arg1_5)
	end
end

function var2_0.RemoveMonster(arg0_6, arg1_6)
	for iter0_6, iter1_6 in pairs(arg0_6._waveInfoList) do
		iter1_6:RemoveMonster(arg1_6)
	end
end

function var2_0.onWaveFinish(arg0_7, arg1_7)
	if not arg0_7._active then
		return
	end

	if arg0_7:CheckAllKeyWave() then
		arg0_7._active = false

		arg0_7._clearFunc()
	end

	local var0_7 = arg1_7.Dispatcher:GetPostWaves()

	for iter0_7, iter1_7 in ipairs(var0_7) do
		if iter1_7:IsReady() and iter1_7:GetState() == iter1_7.STATE_DEACTIVE then
			iter1_7:DoBranch()
		end
	end
end

function var2_0.GetAllBossWave(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8._waveInfoList) do
		if iter1_8:GetType() == var1_0.NORMAL and iter1_8:IsBossWave() then
			table.insert(var0_8, iter1_8)
		end
	end

	return var0_8
end

function var2_0.CheckAllKeyWave(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9._keyList) do
		if not iter1_9:IsFinish() then
			return false
		end
	end

	return true
end

function var2_0.Clear(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10._timerList) do
		arg0_10:RemoveTimer(iter0_10)
	end

	for iter2_10, iter3_10 in pairs(arg0_10._waveInfoList) do
		iter3_10:UnregisterEventListener(arg0_10, var0_0.Battle.BattleEvent.WAVE_FINISH)
		iter3_10:Dispose()
	end

	arg0_10._waveInfoList = nil
	arg0_10._keyList = nil

	arg0_10:Init()
	var0_0.EventListener.DetachEventListener(arg0_10)
end

function var2_0.GetUnfinishedWaveCount(arg0_11)
	local var0_11 = 0

	for iter0_11, iter1_11 in pairs(arg0_11._waveInfoList) do
		if not iter1_11:IsFinish() then
			var0_11 = var0_11 + 1
		end
	end

	return var0_11
end
