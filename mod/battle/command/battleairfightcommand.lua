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
			arg0_4._dataProxy:SetupCalculateDamage(var0_0.Battle.BattleFormulas.FriendInvincibleDamage)
			arg0_4._dataProxy:SetupDamageKamikazeShip(var0_0.Battle.BattleFormulas.CalcDamageLockS2M)
			arg0_4._dataProxy:SetupDamageCrush(var0_0.Battle.BattleFormulas.FriendInvincibleCrashDamage)
			arg0_4._uiMediator:ShowTimer()
			arg0_4._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0_4._waveUpdater:Start()
		end, SYSTEM_AIRFIGHT)
		arg0_4._dataProxy:InitAllFleetUnitsWeaponCD()
	end

	arg0_4._uiMediator:SeaSurfaceShift(1, 15, nil, var0_4)

	local var1_4 = arg0_4._state:GetSceneMediator()

	var1_4:InitPopScorePool()
	var1_4:EnablePopContainer(var0_0.Battle.BattlePopNumManager.CONTAINER_HP, false)
	var1_4:EnablePopContainer(var0_0.Battle.BattlePopNumManager.CONTAINER_SCORE, false)
	var1_4:EnablePopContainer(var0_0.Battle.BattleHPBarManager.ROOT_NAME, false)
	arg0_4._uiMediator:ShowAirFightScoreBar()
end

function var3_0.initWaveModule(arg0_7)
	local function var0_7(arg0_8, arg1_8, arg2_8)
		arg0_7._dataProxy:SpawnMonster(arg0_8, arg1_8, arg2_8, var0_0.Battle.BattleConfig.FOE_CODE)
	end

	local function var1_7()
		if arg0_7._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_7._vertifyFail
			})

			return
		end

		arg0_7._dataProxy:CalcAirFightScore()
		arg0_7._state:BattleEnd()
	end

	arg0_7._waveUpdater = var0_0.Battle.BattleWaveUpdater.New(var0_7, nil, var1_7, nil)
end

function var3_0.onBattleDataInitFinished(arg0_10)
	arg0_10._dataProxy:AirFightInit()

	local var0_10 = arg0_10._userFleet:GetScoutList()

	for iter0_10, iter1_10 in ipairs(var0_10) do
		iter1_10:HideWaveFx()
	end
end

function var3_0.RegisterUnitEvent(arg0_11, arg1_11, ...)
	var3_0.super.RegisterUnitEvent(arg0_11, arg1_11, ...)

	if arg1_11:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_11:RegisterEventListener(arg0_11, var1_0.UPDATE_HP, arg0_11.onPlayerHPUpdate)
	end
end

function var3_0.UnregisterUnitEvent(arg0_12, arg1_12, ...)
	if arg1_12:GetUnitType() == var0_0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1_12:UnregisterEventListener(arg0_12, var1_0.UPDATE_HP)
	end

	var3_0.super.UnregisterUnitEvent(arg0_12, arg1_12, ...)
end

var3_0.ShipType2Point = {
	[ShipType.YuLeiTing] = 200,
	[ShipType.JinBi] = 300,
	[ShipType.ZiBao] = 3000
}
var3_0.BeenHitDecreasePoint = 10

function var3_0.onWillDie(arg0_13, arg1_13)
	local var0_13 = arg1_13.Dispatcher
	local var1_13 = var0_13:GetDeathReason()
	local var2_13 = var0_13:GetTemplate().type

	if var1_13 == var0_0.Battle.BattleConst.UnitDeathReason.CRUSH or var1_13 == var0_0.Battle.BattleConst.UnitDeathReason.KILLED then
		local var3_13 = var3_0.ShipType2Point[var2_13]

		if var3_13 and var3_13 > 0 then
			arg0_13._dataProxy:AddAirFightScore(var3_13)
		end
	end
end

function var3_0.onPlayerHPUpdate(arg0_14, arg1_14)
	if arg1_14.Data.dHP <= 0 then
		arg0_14._dataProxy:DecreaseAirFightScore(var3_0.BeenHitDecreasePoint * -arg1_14.Data.dHP)
	end
end
