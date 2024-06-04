ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = class("BattleAirFightCommand", var0.Battle.BattleSingleDungeonCommand)

var0.Battle.BattleAirFightCommand = var3
var3.__name = "BattleAirFightCommand"

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.AddEvent(arg0, ...)
	var3.super.AddEvent(arg0, ...)
	arg0._dataProxy:RegisterEventListener(arg0, var2.COMMON_DATA_INIT_FINISH, arg0.onBattleDataInitFinished)
end

function var3.RemoveEvent(arg0, ...)
	arg0._dataProxy:UnregisterEventListener(arg0, var2.COMMON_DATA_INIT_FINISH)
	var3.super.RemoveEvent(arg0, ...)
end

function var3.DoPrologue(arg0)
	pg.UIMgr.GetInstance():Marching()

	local var0 = function()
		arg0._uiMediator:OpeningEffect(function()
			arg0._dataProxy:SetupCalculateDamage(var0.Battle.BattleFormulas.FriendInvincibleDamage)
			arg0._dataProxy:SetupDamageKamikazeShip(var0.Battle.BattleFormulas.CalcDamageLockS2M)
			arg0._dataProxy:SetupDamageCrush(var0.Battle.BattleFormulas.FriendInvincibleCrashDamage)
			arg0._uiMediator:ShowTimer()
			arg0._state:ChangeState(var0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0._waveUpdater:Start()
		end, SYSTEM_AIRFIGHT)
		arg0._dataProxy:InitAllFleetUnitsWeaponCD()
	end

	arg0._uiMediator:SeaSurfaceShift(1, 15, nil, var0)

	local var1 = arg0._state:GetSceneMediator()

	var1:InitPopScorePool()
	var1:EnablePopContainer(var0.Battle.BattlePopNumManager.CONTAINER_HP, false)
	var1:EnablePopContainer(var0.Battle.BattlePopNumManager.CONTAINER_SCORE, false)
	var1:EnablePopContainer(var0.Battle.BattleHPBarManager.ROOT_NAME, false)
	arg0._uiMediator:ShowAirFightScoreBar()
end

function var3.initWaveModule(arg0)
	local var0 = function(arg0, arg1, arg2)
		arg0._dataProxy:SpawnMonster(arg0, arg1, arg2, var0.Battle.BattleConfig.FOE_CODE)
	end

	local function var1()
		if arg0._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0._vertifyFail
			})

			return
		end

		arg0._dataProxy:CalcAirFightScore()
		arg0._state:BattleEnd()
	end

	arg0._waveUpdater = var0.Battle.BattleWaveUpdater.New(var0, nil, var1, nil)
end

function var3.onBattleDataInitFinished(arg0)
	arg0._dataProxy:AirFightInit()

	local var0 = arg0._userFleet:GetScoutList()

	for iter0, iter1 in ipairs(var0) do
		iter1:HideWaveFx()
	end
end

function var3.RegisterUnitEvent(arg0, arg1, ...)
	var3.super.RegisterUnitEvent(arg0, arg1, ...)

	if arg1:GetUnitType() == var0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1:RegisterEventListener(arg0, var1.UPDATE_HP, arg0.onPlayerHPUpdate)
	end
end

function var3.UnregisterUnitEvent(arg0, arg1, ...)
	if arg1:GetUnitType() == var0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		arg1:UnregisterEventListener(arg0, var1.UPDATE_HP)
	end

	var3.super.UnregisterUnitEvent(arg0, arg1, ...)
end

var3.ShipType2Point = {
	[ShipType.YuLeiTing] = 200,
	[ShipType.JinBi] = 300,
	[ShipType.ZiBao] = 3000
}
var3.BeenHitDecreasePoint = 10

function var3.onWillDie(arg0, arg1)
	local var0 = arg1.Dispatcher
	local var1 = var0:GetDeathReason()
	local var2 = var0:GetTemplate().type

	if var1 == var0.Battle.BattleConst.UnitDeathReason.CRUSH or var1 == var0.Battle.BattleConst.UnitDeathReason.KILLED then
		local var3 = var3.ShipType2Point[var2]

		if var3 and var3 > 0 then
			arg0._dataProxy:AddAirFightScore(var3)
		end
	end
end

function var3.onPlayerHPUpdate(arg0, arg1)
	if arg1.Data.dHP <= 0 then
		arg0._dataProxy:DecreaseAirFightScore(var3.BeenHitDecreasePoint * -arg1.Data.dHP)
	end
end
