ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = class("BattleDALCollabSingleDungeonCommand", var0_0.Battle.BattleSingleDungeonCommand)

var0_0.Battle.BattleDALCollabSingleDungeonCommand = var3_0
var3_0.__name = "BattleDALCollabSingleDungeonCommand"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.DoPrologue(arg0_2)
	pg.UIMgr.GetInstance():Marching()

	local function var0_2()
		arg0_2._uiMediator:OpeningEffect(function()
			arg0_2._uiMediator:ShowAutoBtn()
			arg0_2._uiMediator:ShowTimer()
			arg0_2._state:GetCommandByName(var0_0.Battle.BattleControllerWeaponCommand.__name):TryAutoSub()
			arg0_2._state:ChangeState(var0_0.Battle.BattleState.BATTLE_STATE_FIGHT)
			arg0_2._waveUpdater:Start()

			if arg0_2._dataProxy:GetInitData().hideAllButtons then
				arg0_2._dataProxy:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleEvent.HIDE_INTERACTABLE_BUTTONS, {
					isActive = false
				}))
			end
		end)
		arg0_2._dataProxy:GetFleetByIFF(var0_0.Battle.BattleConfig.FRIENDLY_CODE):FleetWarcry()
		arg0_2._dataProxy:InitAllFleetUnitsWeaponCD()
		arg0_2._dataProxy:TirggerBattleStartBuffs()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_2._shiftTimer)

		arg0_2._shiftTimer = nil
	end

	local function var1_2()
		local var0_5 = arg0_2._dataProxy:GetInitData().DALAidBuffIDs
		local var1_5

		for iter0_5, iter1_5 in ipairs(var0_5) do
			var1_5 = var0_0.Battle.BattleBuffUnit.New(iter1_5, 1)
		end

		if var1_5 then
			local var2_5 = arg0_2._dataProxy:GetFleetList()

			for iter2_5, iter3_5 in pairs(var2_5) do
				local var3_5 = iter3_5:GetUnitList()
				local var4_5 = iter3_5:GetMainList()[1]

				for iter4_5, iter5_5 in ipairs(var3_5) do
					if iter5_5 == var4_5 then
						iter5_5:AddBuff(var1_5)
						iter5_5:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_DAL_COLLAB_FLAG_SHIP)
					end
				end
			end

			arg0_2._shiftTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, 2, var0_2, true)
		else
			var0_2()
		end
	end

	arg0_2._uiMediator:SeaSurfaceShift(45, 0, nil, var1_2)
end
