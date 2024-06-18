ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = class("BattleDodgemCommand", var0_0.Battle.BattleSingleDungeonCommand)

var0_0.Battle.BattleDodgemCommand = var3_0
var3_0.__name = "BattleDodgemCommand"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.Initialize(arg0_2)
	var3_0.super.Initialize(arg0_2)
	arg0_2._dataProxy:DodgemCountInit()
end

function var3_0.DoPrologue(arg0_3)
	pg.UIMgr.GetInstance():Marching()

	local function var0_3()
		arg0_3._uiMediator:OpeningEffect(function()
			arg0_3._dataProxy:SetupDamageKamikazeShip(var0_0.Battle.BattleFormulas.CalcDamageLockS2M)
			arg0_3._dataProxy:SetupDamageCrush(var0_0.Battle.BattleFormulas.UnilateralCrush)
			arg0_3._uiMediator:ShowTimer()
			arg0_3._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0_3._waveUpdater:Start()
		end)
		arg0_3._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE):FleetWarcry()
	end

	arg0_3._uiMediator:SeaSurfaceShift(45, 0, nil, var0_3)
	arg0_3._uiMediator:ShowDodgemScoreBar()
end

function var3_0.initWaveModule(arg0_6)
	local function var0_6(arg0_7, arg1_7, arg2_7)
		arg0_6._dataProxy:SpawnMonster(arg0_7, arg1_7, arg2_7, var0_0.Battle.BattleConfig.FOE_CODE)
	end

	local function var1_6()
		if arg0_6._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = arg0_6._vertifyFail
			})

			return
		end

		arg0_6._dataProxy:CalcDodgemScore()
		arg0_6._state:BattleEnd()
	end

	arg0_6._waveUpdater = var0_0.Battle.BattleWaveUpdater.New(var0_6, nil, var1_6, nil)
end

function var3_0.onWillDie(arg0_9, arg1_9)
	local var0_9 = arg1_9.Dispatcher

	arg0_9._dataProxy:CalcDodgemCount(var0_9)

	local var1_9 = var0_9:GetDeathReason()

	if var0_9:GetTemplate().type == ShipType.JinBi and var1_9 == var0_0.Battle.BattleConst.UnitDeathReason.CRUSH then
		local var2_9 = arg0_9._dataProxy:GetScorePoint()

		var0_9:DispatchScorePoint(var2_9)
	end
end
