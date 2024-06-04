ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = class("BattleDodgemCommand", var0.Battle.BattleSingleDungeonCommand)

var0.Battle.BattleDodgemCommand = var3
var3.__name = "BattleDodgemCommand"

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.Initialize(arg0)
	var3.super.Initialize(arg0)
	arg0._dataProxy:DodgemCountInit()
end

function var3.DoPrologue(arg0)
	pg.UIMgr.GetInstance():Marching()

	local var0 = function()
		arg0._uiMediator:OpeningEffect(function()
			arg0._dataProxy:SetupDamageKamikazeShip(var0.Battle.BattleFormulas.CalcDamageLockS2M)
			arg0._dataProxy:SetupDamageCrush(var0.Battle.BattleFormulas.UnilateralCrush)
			arg0._uiMediator:ShowTimer()
			arg0._state:ChangeState(var0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0._waveUpdater:Start()
		end)
		arg0._dataProxy:GetFleetByIFF(var0.Battle.BattleConfig.FRIENDLY_CODE):FleetWarcry()
	end

	arg0._uiMediator:SeaSurfaceShift(45, 0, nil, var0)
	arg0._uiMediator:ShowDodgemScoreBar()
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

		arg0._dataProxy:CalcDodgemScore()
		arg0._state:BattleEnd()
	end

	arg0._waveUpdater = var0.Battle.BattleWaveUpdater.New(var0, nil, var1, nil)
end

function var3.onWillDie(arg0, arg1)
	local var0 = arg1.Dispatcher

	arg0._dataProxy:CalcDodgemCount(var0)

	local var1 = var0:GetDeathReason()

	if var0:GetTemplate().type == ShipType.JinBi and var1 == var0.Battle.BattleConst.UnitDeathReason.CRUSH then
		local var2 = arg0._dataProxy:GetScorePoint()

		var0:DispatchScorePoint(var2)
	end
end
