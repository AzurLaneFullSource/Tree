ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleFormulas
local var4_0 = var0_0.Battle.BattleConst
local var5_0 = var0_0.Battle.BattleConfig
local var6_0 = var0_0.Battle.BattleAttr
local var7_0 = var0_0.Battle.BattleDataFunction
local var8_0 = var0_0.Battle.BattleAttr
local var9_0 = class("BattleFleetManualSubComponent")

var0_0.Battle.BattleFleetManualSubComponent = var9_0
var9_0.__name = "BattleFleetManualSubComponent"

function var9_0.Ctor(arg0_1, arg1_1)
	arg0_1._fleetVO = arg1_1

	arg0_1:init()
	arg0_1:attachFunction()
end

function var9_0.attachFunction(arg0_2)
	arg0_2._fleetVO.GetSubBench = var9_0.GetSubBench
	arg0_2._fleetVO.GetSubFreeDiveVO = var9_0.GetSubFreeDiveVO
	arg0_2._fleetVO.GetSubFreeFloatVO = var9_0.GetSubFreeFloatVO
	arg0_2._fleetVO.GetSubBoostVO = var9_0.GetSubBoostVO
	arg0_2._fleetVO.GetSubSpecialVO = var9_0.GetSubSpecialVO
	arg0_2._fleetVO.GetSubShiftVO = var9_0.GetSubShiftVO
	arg0_2._fleetVO.AddManualSubmarine = var9_0.AddManualSubmarine
end

function var9_0.UpdateAutoComponent(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3._manualSubList) do
		iter1_3:UpdateOxygen(arg1_3)
	end
end

function var9_0.UpdateManualWeaponVO(arg0_4, arg1_4)
	arg0_4._submarineDiveVO:Update(arg1_4)
	arg0_4._submarineFloatVO:Update(arg1_4)
	arg0_4._submarineBoostVO:Update(arg1_4)
	arg0_4._submarineShiftVO:Update(arg1_4)
end

function var9_0.RemovePlayerUnit(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg0_5._subList, i) do
		if iter1_5 == arg1_5 then
			table.remove(arg0_5._subList, iter0_5)

			break
		end
	end

	for iter2_5, iter3_5 in ipairs(arg0_5._manualSubList) do
		if iter3_5 == arg1_5 then
			table.remove(arg0_5._manualSubList, iter2_5)

			break
		end
	end

	if not arg0_5._manualSubUnit then
		arg0_5:refreshFleetFormation(indexList)
	end
end

function var9_0.AddManualSubmarine(arg0_6, arg1_6)
	arg0_6._unitList[#arg0_6._unitList + 1] = arg1_6
	arg0_6._manualSubList[#arg0_6._manualSubList + 1] = arg1_6
	arg0_6._manualSubBench[#arg0_6._manualSubBench + 1] = arg1_6
	arg0_6._maxCount = arg0_6._maxCount + 1

	arg1_6:InitOxygen()
	arg1_6:SetFleetVO(arg0_6)
	arg1_6:SetMotion(arg0_6._motionVO)
	arg1_6:RegisterEventListener(arg0_6, var1_0.UPDATE_HP, arg0_6.onUnitUpdateHP)
end

function var9_0.GetSubBench(arg0_7)
	return arg0_7._manualSubBench
end

function var9_0.GetSubFreeDiveVO(arg0_8)
	return arg0_8._manualSubComponent._submarineDiveVO
end

function var9_0.GetSubFreeFloatVO(arg0_9)
	return arg0_9._manualSubComponent._submarineFloatVO
end

function var9_0.GetSubBoostVO(arg0_10)
	return arg0_10._manualSubComponent._submarineBoostVO
end

function var9_0.GetSubSpecialVO(arg0_11)
	return arg0_11._manualSubComponent._submarineSpecialVO
end

function var9_0.GetSubShiftVO(arg0_12)
	return arg0_12._manualSubComponent._submarineShiftVO
end

function var9_0.init(arg0_13)
	arg0_13._submarineDiveVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.DIVE_CD)
	arg0_13._submarineFloatVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.FLOAT_CD)
	arg0_13._submarineVOList = {
		arg0_13._submarineDiveVO,
		arg0_13._submarineFloatVO
	}
	arg0_13._submarineBoostVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.BOOST_CD)
	arg0_13._submarineShiftVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.SHIFT_CD)
	arg0_13._submarineSpecialVO = var0_0.Battle.BattleSubmarineAidVO.New()

	arg0_13._submarineSpecialVO:SetCount(1)
	arg0_13._submarineSpecialVO:SetTotal(1)

	arg0_13._manualSubList = {}
	arg0_13._manualSubBench = {}
	arg0_13._unitList = {}
	arg0_13._maxCount = 0
end

function var9_0.SetSubUnitData(arg0_14, arg1_14)
	arg0_14._subUntiDataList = arg1_14
end

function var9_0.GetSubUnitData(arg0_15)
	return arg0_15._subUntiDataList
end

function var9_0.GetSubList(arg0_16)
	return arg0_16._subList
end

function var9_0.ShiftManualSub(arg0_17)
	local var0_17

	if arg0_17._manualSubUnit then
		local var1_17 = arg0_17._manualSubUnit:GetTorpedoList()

		for iter0_17, iter1_17 in ipairs(var1_17) do
			if iter1_17:IsAttacking() then
				arg0_17:CancelTorpedo()
			end

			arg0_17._torpedoWeaponVO:RemoveWeapon(iter1_17)
		end

		if arg0_17._manualSubUnit:IsAlive() then
			table.insert(arg0_17._manualSubBench, arg0_17._manualSubUnit)
		end

		var0_17 = arg0_17._motionVO:GetPos():Clone()
	else
		var0_17 = arg0_17._manualSubList[1]:GetPosition():Clone()
	end

	arg0_17._manualSubUnit = table.remove(arg0_17._manualSubBench, 1)
	arg0_17._scoutList[1] = arg0_17._manualSubUnit

	local var2_17 = {}

	for iter2_17, iter3_17 in ipairs(arg0_17._manualSubBench) do
		for iter4_17, iter5_17 in ipairs(arg0_17._unitList) do
			if iter5_17 == iter3_17 then
				table.insert(var2_17, iter4_17)

				break
			end
		end
	end

	for iter6_17, iter7_17 in ipairs(arg0_17._unitList) do
		if iter7_17 == arg0_17._manualSubUnit then
			table.insert(var2_17, 1, iter6_17)

			break
		end
	end

	arg0_17:refreshFleetFormation(var2_17)
	arg0_17._manualSubUnit:SetMainUnitStatic(false)
	arg0_17._manualSubUnit:SetPosition(var0_17)
	arg0_17:UpdateMotion()
	arg0_17._submarineSpecialVO:SetUseable(false)

	local var3_17 = arg0_17._manualSubUnit:GetBuffList()

	for iter8_17, iter9_17 in pairs(var3_17) do
		if iter9_17:IsSubmarineSpecial() then
			arg0_17._submarineSpecialVO:SetCount(1)
			arg0_17._submarineSpecialVO:SetUseable(true)

			break
		end
	end

	arg0_17:ChangeSubmarineState(var0_0.Battle.OxyState.STATE_FREE_DIVE)
	arg0_17._torpedoWeaponVO:Reset()

	local var4_17 = arg0_17._manualSubUnit:GetTorpedoList()

	for iter10_17, iter11_17 in ipairs(var4_17) do
		if iter11_17:GetCurrentState() ~= iter11_17.STATE_OVER_HEAT then
			arg0_17._torpedoWeaponVO:AppendWeapon(iter11_17)
		end
	end

	for iter12_17, iter13_17 in ipairs(var4_17) do
		if iter13_17:GetCurrentState() == iter13_17.STATE_OVER_HEAT then
			arg0_17._torpedoWeaponVO:AppendWeapon(iter13_17)
		end
	end

	for iter14_17, iter15_17 in ipairs(arg0_17._manualSubBench) do
		iter15_17:SetPosition(var5_0.SUB_BENCH_POS[iter14_17])
		iter15_17:SetMainUnitStatic(true)
		iter15_17:ChangeOxygenState(var0_0.Battle.OxyState.STATE_FREE_BENCH)
	end

	arg0_17._submarineShiftVO:ResetCurrent()

	if #arg0_17._manualSubBench == 0 then
		arg0_17._submarineShiftVO:SetActive(false)
	end
end

function var9_0.ChangeSubmarineState(arg0_18, arg1_18, arg2_18)
	if not arg0_18._manualSubUnit then
		return
	end

	arg0_18._manualSubUnit:ChangeOxygenState(arg1_18)

	if arg2_18 then
		for iter0_18, iter1_18 in ipairs(arg0_18._submarineVOList) do
			iter1_18:ResetCurrent()
		end

		local var0_18 = arg0_18._submarineShiftVO:GetMax() - arg0_18._submarineShiftVO:GetCurrent()

		if arg0_18._submarineShiftVO:IsOverLoad() and var0_18 > var5_0.SR_CONFIG.DIVE_CD then
			-- block empty
		else
			arg0_18._submarineShiftVO:SetMax(var5_0.SR_CONFIG.DIVE_CD)
			arg0_18._submarineShiftVO:ResetCurrent()
		end
	end

	arg0_18:DispatchEvent(var0_0.Event.New(var2_0.MANUAL_SUBMARINE_SHIFT, {
		state = arg1_18
	}))
end

function var9_0.SubmarinBoost(arg0_19)
	arg0_19._manualSubUnit:Boost(Vector3.right, var5_0.SR_CONFIG.BOOST_SPEED, var5_0.SR_CONFIG.BOOST_DECAY, var5_0.SR_CONFIG.BOOST_DURATION, var5_0.SR_CONFIG.BOOST_DECAY_STAMP)
	arg0_19._submarineBoostVO:ResetCurrent()
end

function var9_0.UnleashSubmarineSpecial(arg0_20)
	if arg0_20:GetWeaponBlock() then
		return
	end

	arg0_20._submarineSpecialVO:Cast()
	arg0_20._manualSubUnit:TriggerBuff(var4_0.BuffEffectType.ON_SUBMARINE_FREE_SPECIAL)
end
