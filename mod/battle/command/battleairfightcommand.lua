ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = class("BattleAirFightCommand", var0_0.Battle.BattleSingleDungeonCommand)

var0_0.Battle.BattleAirFightCommand = var3_0
var3_0.__name = "BattleAirFightCommand"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.AddEvent(arg0_2, ...)
	var3_0.super.AddEvent(arg0_2, ...)
	arg0_2._dataProxy:RegisterEventListener(arg0_2, var2_0.COMMON_DATA_INIT_FINISH, arg0_2.onBattleDataInitFinished)
end

function var3_0.RemoveEvent(arg0_3, ...)
	arg0_3._dataProxy:UnregisterEventListener(arg0_3, var2_0.COMMON_DATA_INIT_FINISH)
	var3_0.super.RemoveEvent(arg0_3, ...)
end

function var3_0.DoPrologue(arg0_4)
	pg.UIMgr.GetInstance():Marching()

	local function var0_4()
		arg0_4._uiMediator:OpeningEffect(function()
			local var0_6 = var0_0.Battle.BattleFormulas
			local var1_6 = var0_6.CreateContextCalculateDamage()

			local function var2_6(arg0_7, arg1_7, ...)
				local var0_7 = arg1_7:GetIFF()

				if var0_7 == var0_0.Battle.BattleConfig.FRIENDLY_CODE then
					return 1, {
						isMiss = false,
						isCri = false,
						isDamagePrevent = false
					}
				elseif var0_7 == var0_0.Battle.BattleConfig.FOE_CODE then
					return var1_6(arg0_7, arg1_7, ...)
				end
			end

			local function var3_6(arg0_8, arg1_8)
				local var0_8, var1_8 = var0_6.CalculateCrashDamage(arg0_8, arg1_8)
				local var2_8 = 1

				var1_8 = arg1_8:GetIFF() == var0_0.Battle.BattleConfig.FRIENDLY_CODE and 1 or var1_8

				return var2_8, var1_8
			end

			arg0_4._dataProxy:SetupCalculateDamage(var2_6)
			arg0_4._dataProxy:SetupDamageKamikazeShip(var0_0.Battle.BattleFormulas.CalcDamageLockS2M)
			arg0_4._dataProxy:SetupDamageCrush(var3_6)
			arg0_4._uiMediator:ShowTimer()
			arg0_4._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0_4._waveUpdater:Start()
		end, SYSTEM_AIRFIGHT)
		arg0_4._dataProxy:InitAllFleetUnitsWeaponCD()
	end

	arg0_4._uiMediator:SeaSurfaceShift(1, 15, nil, var0_4)
	arg0_4._dataProxy:AutoStatistics(0)

	local var1_4 = arg0_4._state:GetSceneMediator()

	arg0_4._uiMediator:ShowAirFightScoreBar()
end

function var3_0.initWaveModule(arg0_9)
	local function var0_9(arg0_10, arg1_10, arg2_10)
		arg0_9._dataProxy:SpawnMonster(arg0_10, arg1_10, arg2_10, var0_0.Battle.BattleConfig.FOE_CODE)
	end

	local function var1_9()
		if arg0_9._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_9._vertifyFail
			})

			return
		end

		arg0_9._dataProxy:CalcAirFightScore()
		arg0_9._state:BattleEnd()
	end

	arg0_9._waveUpdater = var0_0.Battle.BattleWaveUpdater.New(var0_9, nil, var1_9, nil)
end

function var3_0.onBattleDataInitFinished(arg0_12)
	arg0_12._dataProxy:AirFightInit()

	local var0_12 = arg0_12._userFleet:GetScoutList()

	for iter0_12, iter1_12 in ipairs(var0_12) do
		iter1_12:HideWaveFx()
	end
end

function var3_0.RegisterUnitEvent(arg0_13, arg1_13, ...)
	var3_0.super.RegisterUnitEvent(arg0_13, arg1_13, ...)

	if arg1_13:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_13:RegisterEventListener(arg0_13, var1_0.UPDATE_HP, arg0_13.onPlayerHPUpdate)
	end
end

function var3_0.UnregisterUnitEvent(arg0_14, arg1_14, ...)
	if arg1_14:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_14:UnregisterEventListener(arg0_14, var1_0.UPDATE_HP)
	end

	var3_0.super.UnregisterUnitEvent(arg0_14, arg1_14, ...)
end

var3_0.ShipType2Point = {
	[ShipType.YuLeiTing] = 200,
	[ShipType.JinBi] = 300,
	[ShipType.ZiBao] = 3000
}
var3_0.BeenHitDecreasePoint = 10

function var3_0.onWillDie(arg0_15, arg1_15)
	local var0_15 = arg1_15.Dispatcher
	local var1_15 = var0_15:GetDeathReason()
	local var2_15 = var0_15:GetTemplate().type

	if var1_15 == var0_0.Battle.BattleConst.UnitDeathReason.CRUSH or var1_15 == var0_0.Battle.BattleConst.UnitDeathReason.KILLED then
		local var3_15 = var3_0.ShipType2Point[var2_15]

		if var3_15 and var3_15 > 0 then
			arg0_15._dataProxy:AddAirFightScore(var3_15)
		end
	end
end

function var3_0.onPlayerHPUpdate(arg0_16, arg1_16)
	if arg1_16.Data.dHP <= 0 then
		arg0_16._dataProxy:DecreaseAirFightScore(var3_0.BeenHitDecreasePoint * -arg1_16.Data.dHP)
	end
end
