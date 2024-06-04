ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleFormulas
local var4 = var0.Battle.BattleConst
local var5 = var0.Battle.BattleConfig
local var6 = var0.Battle.BattleAttr
local var7 = var0.Battle.BattleDataFunction
local var8 = var0.Battle.BattleAttr
local var9 = class("BattleFleetManualSubComponent")

var0.Battle.BattleFleetManualSubComponent = var9
var9.__name = "BattleFleetManualSubComponent"

function var9.Ctor(arg0, arg1)
	arg0._fleetVO = arg1

	arg0:init()
	arg0:attachFunction()
end

function var9.attachFunction(arg0)
	arg0._fleetVO.GetSubBench = var9.GetSubBench
	arg0._fleetVO.GetSubFreeDiveVO = var9.GetSubFreeDiveVO
	arg0._fleetVO.GetSubFreeFloatVO = var9.GetSubFreeFloatVO
	arg0._fleetVO.GetSubBoostVO = var9.GetSubBoostVO
	arg0._fleetVO.GetSubSpecialVO = var9.GetSubSpecialVO
	arg0._fleetVO.GetSubShiftVO = var9.GetSubShiftVO
	arg0._fleetVO.AddManualSubmarine = var9.AddManualSubmarine
end

function var9.UpdateAutoComponent(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._manualSubList) do
		iter1:UpdateOxygen(arg1)
	end
end

function var9.UpdateManualWeaponVO(arg0, arg1)
	arg0._submarineDiveVO:Update(arg1)
	arg0._submarineFloatVO:Update(arg1)
	arg0._submarineBoostVO:Update(arg1)
	arg0._submarineShiftVO:Update(arg1)
end

function var9.RemovePlayerUnit(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._subList, i) do
		if iter1 == arg1 then
			table.remove(arg0._subList, iter0)

			break
		end
	end

	for iter2, iter3 in ipairs(arg0._manualSubList) do
		if iter3 == arg1 then
			table.remove(arg0._manualSubList, iter2)

			break
		end
	end

	if not arg0._manualSubUnit then
		arg0:refreshFleetFormation(indexList)
	end
end

function var9.AddManualSubmarine(arg0, arg1)
	arg0._unitList[#arg0._unitList + 1] = arg1
	arg0._manualSubList[#arg0._manualSubList + 1] = arg1
	arg0._manualSubBench[#arg0._manualSubBench + 1] = arg1
	arg0._maxCount = arg0._maxCount + 1

	arg1:InitOxygen()
	arg1:SetFleetVO(arg0)
	arg1:SetMotion(arg0._motionVO)
	arg1:RegisterEventListener(arg0, var1.UPDATE_HP, arg0.onUnitUpdateHP)
end

function var9.GetSubBench(arg0)
	return arg0._manualSubBench
end

function var9.GetSubFreeDiveVO(arg0)
	return arg0._manualSubComponent._submarineDiveVO
end

function var9.GetSubFreeFloatVO(arg0)
	return arg0._manualSubComponent._submarineFloatVO
end

function var9.GetSubBoostVO(arg0)
	return arg0._manualSubComponent._submarineBoostVO
end

function var9.GetSubSpecialVO(arg0)
	return arg0._manualSubComponent._submarineSpecialVO
end

function var9.GetSubShiftVO(arg0)
	return arg0._manualSubComponent._submarineShiftVO
end

function var9.init(arg0)
	arg0._submarineDiveVO = var0.Battle.BattleSubmarineFuncVO.New(var5.SR_CONFIG.DIVE_CD)
	arg0._submarineFloatVO = var0.Battle.BattleSubmarineFuncVO.New(var5.SR_CONFIG.FLOAT_CD)
	arg0._submarineVOList = {
		arg0._submarineDiveVO,
		arg0._submarineFloatVO
	}
	arg0._submarineBoostVO = var0.Battle.BattleSubmarineFuncVO.New(var5.SR_CONFIG.BOOST_CD)
	arg0._submarineShiftVO = var0.Battle.BattleSubmarineFuncVO.New(var5.SR_CONFIG.SHIFT_CD)
	arg0._submarineSpecialVO = var0.Battle.BattleSubmarineAidVO.New()

	arg0._submarineSpecialVO:SetCount(1)
	arg0._submarineSpecialVO:SetTotal(1)

	arg0._manualSubList = {}
	arg0._manualSubBench = {}
	arg0._unitList = {}
	arg0._maxCount = 0
end

function var9.SetSubUnitData(arg0, arg1)
	arg0._subUntiDataList = arg1
end

function var9.GetSubUnitData(arg0)
	return arg0._subUntiDataList
end

function var9.GetSubList(arg0)
	return arg0._subList
end

function var9.ShiftManualSub(arg0)
	local var0

	if arg0._manualSubUnit then
		local var1 = arg0._manualSubUnit:GetTorpedoList()

		for iter0, iter1 in ipairs(var1) do
			if iter1:IsAttacking() then
				arg0:CancelTorpedo()
			end

			arg0._torpedoWeaponVO:RemoveWeapon(iter1)
		end

		if arg0._manualSubUnit:IsAlive() then
			table.insert(arg0._manualSubBench, arg0._manualSubUnit)
		end

		var0 = arg0._motionVO:GetPos():Clone()
	else
		var0 = arg0._manualSubList[1]:GetPosition():Clone()
	end

	arg0._manualSubUnit = table.remove(arg0._manualSubBench, 1)
	arg0._scoutList[1] = arg0._manualSubUnit

	local var2 = {}

	for iter2, iter3 in ipairs(arg0._manualSubBench) do
		for iter4, iter5 in ipairs(arg0._unitList) do
			if iter5 == iter3 then
				table.insert(var2, iter4)

				break
			end
		end
	end

	for iter6, iter7 in ipairs(arg0._unitList) do
		if iter7 == arg0._manualSubUnit then
			table.insert(var2, 1, iter6)

			break
		end
	end

	arg0:refreshFleetFormation(var2)
	arg0._manualSubUnit:SetMainUnitStatic(false)
	arg0._manualSubUnit:SetPosition(var0)
	arg0:UpdateMotion()
	arg0._submarineSpecialVO:SetUseable(false)

	local var3 = arg0._manualSubUnit:GetBuffList()

	for iter8, iter9 in pairs(var3) do
		if iter9:IsSubmarineSpecial() then
			arg0._submarineSpecialVO:SetCount(1)
			arg0._submarineSpecialVO:SetUseable(true)

			break
		end
	end

	arg0:ChangeSubmarineState(var0.Battle.OxyState.STATE_FREE_DIVE)
	arg0._torpedoWeaponVO:Reset()

	local var4 = arg0._manualSubUnit:GetTorpedoList()

	for iter10, iter11 in ipairs(var4) do
		if iter11:GetCurrentState() ~= iter11.STATE_OVER_HEAT then
			arg0._torpedoWeaponVO:AppendWeapon(iter11)
		end
	end

	for iter12, iter13 in ipairs(var4) do
		if iter13:GetCurrentState() == iter13.STATE_OVER_HEAT then
			arg0._torpedoWeaponVO:AppendWeapon(iter13)
		end
	end

	for iter14, iter15 in ipairs(arg0._manualSubBench) do
		iter15:SetPosition(var5.SUB_BENCH_POS[iter14])
		iter15:SetMainUnitStatic(true)
		iter15:ChangeOxygenState(var0.Battle.OxyState.STATE_FREE_BENCH)
	end

	arg0._submarineShiftVO:ResetCurrent()

	if #arg0._manualSubBench == 0 then
		arg0._submarineShiftVO:SetActive(false)
	end
end

function var9.ChangeSubmarineState(arg0, arg1, arg2)
	if not arg0._manualSubUnit then
		return
	end

	arg0._manualSubUnit:ChangeOxygenState(arg1)

	if arg2 then
		for iter0, iter1 in ipairs(arg0._submarineVOList) do
			iter1:ResetCurrent()
		end

		local var0 = arg0._submarineShiftVO:GetMax() - arg0._submarineShiftVO:GetCurrent()

		if arg0._submarineShiftVO:IsOverLoad() and var0 > var5.SR_CONFIG.DIVE_CD then
			-- block empty
		else
			arg0._submarineShiftVO:SetMax(var5.SR_CONFIG.DIVE_CD)
			arg0._submarineShiftVO:ResetCurrent()
		end
	end

	arg0:DispatchEvent(var0.Event.New(var2.MANUAL_SUBMARINE_SHIFT, {
		state = arg1
	}))
end

function var9.SubmarinBoost(arg0)
	arg0._manualSubUnit:Boost(Vector3.right, var5.SR_CONFIG.BOOST_SPEED, var5.SR_CONFIG.BOOST_DECAY, var5.SR_CONFIG.BOOST_DURATION, var5.SR_CONFIG.BOOST_DECAY_STAMP)
	arg0._submarineBoostVO:ResetCurrent()
end

function var9.UnleashSubmarineSpecial(arg0)
	if arg0:GetWeaponBlock() then
		return
	end

	arg0._submarineSpecialVO:Cast()
	arg0._manualSubUnit:TriggerBuff(var4.BuffEffectType.ON_SUBMARINE_FREE_SPECIAL)
end
