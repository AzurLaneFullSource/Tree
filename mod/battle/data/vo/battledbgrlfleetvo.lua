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
local var9_0 = class("BattleFleetVO")

var0_0.Battle.BattleFleetVO = var9_0
var9_0.__name = "BattleFleetVO"

function var9_0.Ctor(arg0_1, arg1_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)
	var0_0.EventListener.AttachEventListener(arg0_1)

	arg0_1._IFF = arg1_1
	arg0_1._lastDist = 0

	arg0_1:init()
end

function var9_0.UpdateMotion(arg0_2)
	if arg0_2._motionReferenceUnit then
		arg0_2._motionVO:UpdatePos(arg0_2._motionReferenceUnit)
		arg0_2._motionVO:UpdateVelocityAndDirection(arg0_2:GetFleetVelocity(), arg0_2._motionSourceFunc())
	end

	local var0_2 = math.max(arg0_2._motionVO:GetPos().x - arg0_2._rightBound, 0)

	if var0_2 >= 0 and var0_2 ~= arg0_2._lastDist then
		arg0_2._lastDist = var0_2

		arg0_2:DispatchEvent(var0_0.Event.New(var2_0.SHOW_BUFFER, {
			dist = var0_2
		}))
	end
end

function var9_0.UpdateAutoComponent(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3._scoutList) do
		iter1_3:UpdateWeapon(arg1_3)
		iter1_3:UpdateAirAssist()
	end

	for iter2_3, iter3_3 in ipairs(arg0_3._mainList) do
		iter3_3:UpdateWeapon(arg1_3)
		iter3_3:UpdateAirAssist()
	end

	for iter4_3, iter5_3 in ipairs(arg0_3._cloakList) do
		iter5_3:UpdateCloak(arg1_3)
	end

	for iter6_3, iter7_3 in ipairs(arg0_3._subList) do
		iter7_3:UpdateWeapon(arg1_3)
		iter7_3:UpdateOxygen(arg1_3)
		iter7_3:UpdatePhaseSwitcher()
	end

	for iter8_3, iter9_3 in ipairs(arg0_3._manualSubList) do
		iter9_3:UpdateOxygen(arg1_3)
	end

	arg0_3._fleetAntiAir:Update(arg1_3)
	arg0_3._fleetRangeAntiAir:Update(arg1_3)
	arg0_3._fleetStaticSonar:Update(arg1_3)

	for iter10_3, iter11_3 in pairs(arg0_3._indieSonarList) do
		iter10_3:Update(arg1_3)
	end

	arg0_3:UpdateBuff(arg1_3)
end

function var9_0.UpdateBuff(arg0_4, arg1_4)
	local var0_4 = arg0_4._buffList

	for iter0_4, iter1_4 in pairs(var0_4) do
		iter1_4:Update(arg0_4, arg1_4)
	end
end

function var9_0.UpdateManualWeaponVO(arg0_5, arg1_5)
	arg0_5._chargeWeaponVO:Update(arg1_5)
	arg0_5._torpedoWeaponVO:Update(arg1_5)
	arg0_5._airAssistVO:Update(arg1_5)
	arg0_5._submarineDiveVO:Update(arg1_5)
	arg0_5._submarineFloatVO:Update(arg1_5)
	arg0_5._submarineBoostVO:Update(arg1_5)
	arg0_5._submarineShiftVO:Update(arg1_5)
end

function var9_0.UpdateFleetDamage(arg0_6, arg1_6)
	local var0_6 = var3_0.CalculateFleetDamage(arg1_6)

	arg0_6._currentDMGRatio = arg0_6._currentDMGRatio + var0_6

	arg0_6:DispatchFleetDamageChange()
end

function var9_0.UpdateFleetOverDamage(arg0_7, arg1_7)
	local var0_7 = var3_0.CalculateFleetOverDamage(arg0_7, arg1_7)

	arg0_7._currentDMGRatio = arg0_7._currentDMGRatio - var0_7

	arg0_7:DispatchFleetDamageChange()
end

function var9_0.DispatchFleetDamageChange(arg0_8)
	arg0_8:DispatchEvent(var0_0.Event.New(var2_0.FLEET_DMG_CHANGE, {}))
end

function var9_0.DispatchSonarScan(arg0_9, arg1_9)
	arg0_9:DispatchEvent(var0_0.Event.New(var2_0.SONAR_SCAN, {
		indieSonar = arg1_9
	}))
end

function var9_0.FreeMainUnit(arg0_10, arg1_10)
	if arg0_10._mainUnitFree then
		return
	end

	arg0_10._mainUnitFree = true

	for iter0_10, iter1_10 in ipairs(arg0_10._mainList) do
		local var0_10 = var0_0.Battle.BattleBuffUnit.New(arg1_10)

		iter1_10:AddBuff(var0_10)
		iter1_10:SetMainUnitStatic(false)
	end
end

function var9_0.RandomMainVictim(arg0_11, arg1_11)
	arg1_11 = arg1_11 or {}

	local var0_11 = {}
	local var1_11

	for iter0_11, iter1_11 in ipairs(arg0_11._mainList) do
		local var2_11 = true

		for iter2_11, iter3_11 in ipairs(arg1_11) do
			if iter1_11:GetAttrByName(iter3_11) == 1 then
				var2_11 = false

				break
			end
		end

		if var2_11 then
			table.insert(var0_11, iter1_11)
		end
	end

	if #var0_11 > 0 then
		var1_11 = var0_11[math.random(#var0_11)]
	end

	return var1_11
end

function var9_0.NearestUnitByType(arg0_12, arg1_12, arg2_12)
	local var0_12 = 999
	local var1_12

	for iter0_12, iter1_12 in ipairs(arg0_12._unitList) do
		local var2_12 = iter1_12:GetTemplate().type

		if table.contains(arg2_12, var2_12) then
			local var3_12 = iter1_12:GetPosition()
			local var4_12 = Vector3.BattleDistance(var3_12, arg1_12)

			if var4_12 < var0_12 then
				var0_12 = var4_12
				var1_12 = iter1_12
			end
		end
	end

	return var1_12
end

function var9_0.SetMotionSource(arg0_13, arg1_13)
	if arg1_13 == nil then
		function arg0_13._motionSourceFunc()
			local var0_14 = pg.UIMgr.GetInstance()

			return var0_14.hrz, var0_14.vtc
		end
	else
		arg0_13._motionSourceFunc = arg1_13
	end
end

function var9_0.SetSubAidData(arg0_15, arg1_15, arg2_15)
	arg0_15._submarineVO = var0_0.Battle.BattleSubmarineAidVO.New()

	if arg2_15 == var4_0.SubAidFlag.AID_EMPTY or arg2_15 == var4_0.SubAidFlag.OIL_EMPTY then
		arg0_15._submarineVO:SetUseable(false)
	else
		arg0_15._submarineVO:SetCount(arg2_15)
		arg0_15._submarineVO:SetTotal(arg1_15)
		arg0_15._submarineVO:SetUseable(true)
	end
end

function var9_0.SetBound(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	arg0_16._upperBound = arg1_16
	arg0_16._lowerBound = arg2_16
	arg0_16._leftBound = arg3_16
	arg0_16._rightBound = arg4_16
end

function var9_0.SetTotalBound(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	arg0_17._totalUpperBound = arg1_17
	arg0_17._totalLowerBound = arg2_17
	arg0_17._totalLeftBound = arg3_17
	arg0_17._totalRightBound = arg4_17
end

function var9_0.CalcSubmarineBaseLine(arg0_18, arg1_18)
	local var0_18 = (arg0_18._totalRightBound + arg0_18._totalLeftBound) * 0.5

	if arg0_18._IFF == var5_0.FRIENDLY_CODE then
		if arg1_18 == SYSTEM_DUEL then
			-- block empty
		else
			arg0_18._subAttackBaseLine = var0_18
			arg0_18._subRetreatBaseLine = arg0_18._leftBound - 10
		end
	elseif arg0_18._IFF == var5_0.FOE_CODE and arg1_18 == SYSTEM_DUEL then
		-- block empty
	end
end

function var9_0.SetExposeLine(arg0_19, arg1_19, arg2_19)
	arg0_19._visionLineX = arg1_19
	arg0_19._exposeLineX = arg2_19
end

function var9_0.AppendPlayerUnit(arg0_20, arg1_20)
	arg0_20._unitList[#arg0_20._unitList + 1] = arg1_20
	arg0_20._maxCount = arg0_20._maxCount + 1

	if arg1_20:IsMainFleetUnit() then
		arg0_20:appendMainUnit(arg1_20)
	else
		arg0_20:appendScoutUnit(arg1_20)
	end

	arg1_20:SetFleetVO(arg0_20)
	arg1_20:SetMotion(arg0_20._motionVO)
	arg1_20:RegisterEventListener(arg0_20, var1_0.UPDATE_HP, arg0_20.onUnitUpdateHP)
end

function var9_0.RemovePlayerUnit(arg0_21, arg1_21)
	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(arg0_21._unitList) do
		if iter1_21 ~= arg1_21 then
			var0_21[#var0_21 + 1] = iter0_21
		else
			iter1_21:UnregisterEventListener(arg0_21, var1_0.UPDATE_HP)
			iter1_21:DeactiveCldBox()

			local var1_21 = iter1_21:GetChargeList()

			for iter2_21, iter3_21 in ipairs(var1_21) do
				if iter3_21:IsAttacking() then
					arg0_21._chargeWeaponVO:CancelFocus()
					arg0_21._chargeWeaponVO:ResetFocus()
					arg0_21:CancelChargeWeapon()
				end

				arg0_21._chargeWeaponVO:RemoveWeapon(iter3_21)
				iter3_21:Clear()
			end

			arg0_21._fleetAntiAir:RemoveCrewUnit(arg1_21)
			arg0_21._fleetRangeAntiAir:RemoveCrewUnit(arg1_21)
			arg0_21._fleetStaticSonar:RemoveCrewUnit(arg1_21)

			local var2_21 = iter1_21:GetTorpedoList()

			for iter4_21, iter5_21 in ipairs(var2_21) do
				arg0_21:RemoveManunalTorpedo(iter5_21)
			end

			local var3_21 = iter1_21:GetAirAssistList()

			if var3_21 then
				for iter6_21, iter7_21 in ipairs(var3_21) do
					arg0_21._airAssistVO:RemoveWeapon(iter7_21)
				end
			end
		end
	end

	for iter8_21, iter9_21 in ipairs(arg0_21._scoutList) do
		if iter9_21 == arg1_21 then
			if #arg0_21._scoutList == 1 then
				arg0_21:CancelChargeWeapon()
			end

			table.remove(arg0_21._scoutList, iter8_21)

			break
		end
	end

	for iter10_21, iter11_21 in ipairs(arg0_21._mainList) do
		if iter11_21 == arg1_21 then
			table.remove(arg0_21._mainList, iter10_21)

			break
		end
	end

	for iter12_21, iter13_21 in ipairs(arg0_21._cloakList) do
		if iter13_21 == arg1_21 then
			table.remove(arg0_21._cloakList, iter12_21)

			break
		end
	end

	for iter14_21, iter15_21 in ipairs(arg0_21._subList, i) do
		if iter15_21 == arg1_21 then
			table.remove(arg0_21._subList, iter14_21)

			break
		end
	end

	for iter16_21, iter17_21 in ipairs(arg0_21._manualSubList) do
		if iter17_21 == arg1_21 then
			table.remove(arg0_21._manualSubList, iter16_21)

			break
		end
	end

	if not arg0_21._manualSubUnit then
		arg0_21:refreshFleetFormation(var0_21)
	end
end

function var9_0.OverrideJoyStickAutoBot(arg0_22, arg1_22)
	arg0_22._autoBotAIID = arg1_22

	local var0_22 = var0_0.Event.New(var0_0.Battle.BattleEvent.OVERRIDE_AUTO_BOT)

	arg0_22:DispatchEvent(var0_22)
end

function var9_0.SnapShot(arg0_23)
	arg0_23._totalDMGRatio = var3_0.GetFleetTotalHP(arg0_23)
	arg0_23._currentDMGRatio = arg0_23._totalDMGRatio
end

function var9_0.GetIFF(arg0_24)
	return arg0_24._IFF
end

function var9_0.GetMaxCount(arg0_25)
	return arg0_25._maxCount
end

function var9_0.GetFlagShip(arg0_26)
	return arg0_26._flagShip
end

function var9_0.GetLeaderShip(arg0_27)
	return arg0_27._scoutList[1]
end

function var9_0.GetUnitList(arg0_28)
	return arg0_28._unitList
end

function var9_0.GetMainList(arg0_29)
	return arg0_29._mainList
end

function var9_0.GetScoutList(arg0_30)
	return arg0_30._scoutList
end

function var9_0.GetCloakList(arg0_31)
	return arg0_31._cloakList
end

function var9_0.GetSubBench(arg0_32)
	return arg0_32._manualSubBench
end

function var9_0.GetMotion(arg0_33)
	return arg0_33._motionVO
end

function var9_0.GetMotionReferenceUnit(arg0_34)
	return arg0_34._motionReferenceUnit
end

function var9_0.GetAutoBotAIID(arg0_35)
	return arg0_35._autoBotAIID
end

function var9_0.GetChargeWeaponVO(arg0_36)
	return arg0_36._chargeWeaponVO
end

function var9_0.GetTorpedoWeaponVO(arg0_37)
	return arg0_37._torpedoWeaponVO
end

function var9_0.GetAirAssistVO(arg0_38)
	return arg0_38._airAssistVO
end

function var9_0.GetSubAidVO(arg0_39)
	return arg0_39._submarineVO
end

function var9_0.GetSubFreeDiveVO(arg0_40)
	return arg0_40._submarineDiveVO
end

function var9_0.GetSubFreeFloatVO(arg0_41)
	return arg0_41._submarineFloatVO
end

function var9_0.GetSubBoostVO(arg0_42)
	return arg0_42._submarineBoostVO
end

function var9_0.GetSubSpecialVO(arg0_43)
	return arg0_43._submarineSpecialVO
end

function var9_0.GetSubShiftVO(arg0_44)
	return arg0_44._submarineShiftVO
end

function var9_0.GetFleetAntiAirWeapon(arg0_45)
	return arg0_45._fleetAntiAir
end

function var9_0.GetFleetRangeAntiAirWeapon(arg0_46)
	return arg0_46._fleetRangeAntiAir
end

function var9_0.GetFleetVelocity(arg0_47)
	return var3_0.GetFleetVelocity(arg0_47._scoutList)
end

function var9_0.GetFleetBound(arg0_48)
	return arg0_48._upperBound, arg0_48._lowerBound, arg0_48._leftBound, arg0_48._rightBound
end

function var9_0.GetFleetExposeLine(arg0_49)
	return arg0_49._exposeLineX
end

function var9_0.GetFleetVisionLine(arg0_50)
	return arg0_50._visionLineX
end

function var9_0.GetLeaderPersonality(arg0_51)
	return arg0_51._motionReferenceUnit:GetAutoPilotPreference()
end

function var9_0.GetDamageRatioResult(arg0_52)
	return string.format("%0.2f", arg0_52._currentDMGRatio / arg0_52._totalDMGRatio * 100), arg0_52._totalDMGRatio
end

function var9_0.GetDamageRatio(arg0_53)
	return arg0_53._currentDMGRatio / arg0_53._totalDMGRatio
end

function var9_0.GetSubmarineBaseLine(arg0_54)
	return arg0_54._subAttackBaseLine, arg0_54._subRetreatBaseLine
end

function var9_0.GetFleetSonar(arg0_55)
	return arg0_55._fleetStaticSonar
end

function var9_0.Dispose(arg0_56)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_56)
	var0_0.EventListener.DetachEventListener(arg0_56)

	arg0_56._leaderUnit = nil

	arg0_56._fleetAntiAir:Dispose()
	arg0_56._fleetRangeAntiAir:Dispose()
	arg0_56._fleetStaticSonar:Dispose()

	arg0_56._fleetStaticSonar = nil
	arg0_56._buffList = nil
	arg0_56._indieSonarList = nil
	arg0_56._scoutAimBias = nil
end

function var9_0.refreshFleetFormation(arg0_57, arg1_57)
	local var0_57 = var7_0.GetFormationTmpDataFromID(var5_0.FORMATION_ID).pos_offset

	arg0_57._unitList = var7_0.SortFleetList(arg1_57, arg0_57._unitList)

	local var1_57 = var5_0.BornOffset

	if not arg0_57._mainUnitFree then
		for iter0_57, iter1_57 in ipairs(arg0_57._unitList) do
			if not table.contains(arg0_57._subList, iter1_57) then
				local var2_57 = var0_57[iter0_57]

				iter1_57:UpdateFormationOffset(Vector3(var2_57.x, var2_57.y, var2_57.z) + var1_57 * (iter0_57 - 1))
			end
		end
	end

	if #arg0_57._scoutList > 0 then
		arg0_57._motionReferenceUnit = arg0_57._scoutList[1]
		arg0_57._leaderUnit = arg0_57._scoutList[1]

		arg0_57._leaderUnit:LeaderSetting()
		arg0_57._fleetAntiAir:SwitchHost(arg0_57._motionReferenceUnit)
		arg0_57._fleetStaticSonar:SwitchHost(arg0_57._motionReferenceUnit)

		for iter2_57, iter3_57 in pairs(arg0_57._indieSonarList) do
			iter2_57:SwitchHost(arg0_57._motionReferenceUnit)
		end

		arg0_57._motionVO:UpdatePos(arg0_57._motionReferenceUnit)
	elseif arg0_57._fleetAntiAir:GetCurrentState() ~= arg0_57._fleetAntiAir.STATE_DISABLE then
		local var3_57 = arg0_57._fleetAntiAir:GetCrewUnitList()

		for iter4_57, iter5_57 in pairs(var3_57) do
			arg0_57._motionReferenceUnit = iter4_57

			arg0_57._fleetAntiAir:SwitchHost(iter4_57)

			break
		end
	else
		arg0_57._motionReferenceUnit = arg0_57._mainList[1]
		arg0_57._leaderUnit = nil
	end

	if #arg0_57:GetUnitList() == 0 then
		return
	end

	local var4_57 = var0_0.Event.New(var0_0.Battle.BattleEvent.REFRESH_FLEET_FORMATION)

	arg0_57:DispatchEvent(var4_57)
end

function var9_0.init(arg0_58)
	arg0_58._chargeWeaponVO = var0_0.Battle.BattleChargeWeaponVO.New()
	arg0_58._torpedoWeaponVO = var0_0.Battle.BattleTorpedoWeaponVO.New()
	arg0_58._airAssistVO = var0_0.Battle.BattleAllInStrikeVO.New()
	arg0_58._submarineDiveVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.DIVE_CD)
	arg0_58._submarineFloatVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.FLOAT_CD)
	arg0_58._submarineVOList = {
		arg0_58._submarineDiveVO,
		arg0_58._submarineFloatVO
	}
	arg0_58._submarineBoostVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.BOOST_CD)
	arg0_58._submarineShiftVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.SHIFT_CD)
	arg0_58._submarineSpecialVO = var0_0.Battle.BattleSubmarineAidVO.New()

	arg0_58._submarineSpecialVO:SetCount(1)
	arg0_58._submarineSpecialVO:SetTotal(1)

	arg0_58._fleetAntiAir = var0_0.Battle.BattleFleetAntiAirUnit.New()
	arg0_58._fleetRangeAntiAir = var0_0.Battle.BattleFleetRangeAntiAirUnit.New()
	arg0_58._motionVO = var0_0.Battle.BattleFleetMotionVO.New()
	arg0_58._fleetStaticSonar = var0_0.Battle.BattleFleetStaticSonar.New(arg0_58)
	arg0_58._indieSonarList = {}
	arg0_58._scoutList = {}
	arg0_58._mainList = {}
	arg0_58._subList = {}
	arg0_58._cloakList = {}
	arg0_58._manualSubList = {}
	arg0_58._manualSubBench = {}
	arg0_58._unitList = {}
	arg0_58._maxCount = 0
	arg0_58._blockCast = 0
	arg0_58._buffList = {}

	arg0_58:SetMotionSource()
end

function var9_0.appendScoutUnit(arg0_59, arg1_59)
	arg0_59._scoutList[#arg0_59._scoutList + 1] = arg1_59

	local var0_59 = arg1_59:GetTorpedoList()

	for iter0_59, iter1_59 in ipairs(var0_59) do
		arg0_59._torpedoWeaponVO:AppendWeapon(iter1_59)
	end

	if #arg1_59:GetHiveList() > 0 then
		local var1_59 = var7_0.CreateAllInStrike(arg1_59)

		for iter2_59, iter3_59 in ipairs(var1_59) do
			arg0_59._airAssistVO:AppendWeapon(iter3_59)
		end

		arg1_59:SetAirAssistList(var1_59)
	end

	arg0_59._fleetAntiAir:AppendCrewUnit(arg1_59)
	arg0_59._fleetStaticSonar:AppendCrewUnit(arg1_59)

	local var2_59 = 1
	local var3_59 = #arg0_59._unitList
	local var4_59 = {}

	while var2_59 < var3_59 do
		table.insert(var4_59, var2_59)

		var2_59 = var2_59 + 1
	end

	table.insert(var4_59, #arg0_59._scoutList, var2_59)
	arg0_59:refreshFleetFormation(var4_59)
end

function var9_0.appendMainUnit(arg0_60, arg1_60)
	if #arg0_60._mainList == 0 then
		arg0_60._flagShip = arg1_60
	end

	arg0_60._mainList[#arg0_60._mainList + 1] = arg1_60

	arg1_60:SetMainUnitIndex(#arg0_60._mainList)

	if ShipType.CloakShipType(arg1_60:GetTemplate().type) then
		arg0_60:AttachCloak(arg1_60)
	end

	local var0_60 = arg1_60:GetChargeList()

	for iter0_60, iter1_60 in ipairs(var0_60) do
		arg0_60._chargeWeaponVO:AppendWeapon(iter1_60)
	end

	local var1_60 = arg1_60:GetTorpedoList()

	for iter2_60, iter3_60 in ipairs(var1_60) do
		arg0_60._torpedoWeaponVO:AppendWeapon(iter3_60)
	end

	if #arg1_60:GetHiveList() > 0 then
		local var2_60 = var7_0.CreateAllInStrike(arg1_60)

		for iter4_60, iter5_60 in ipairs(var2_60) do
			arg0_60._airAssistVO:AppendWeapon(iter5_60)
		end

		arg1_60:SetAirAssistList(var2_60)
	end

	arg0_60._fleetAntiAir:AppendCrewUnit(arg1_60)
	arg0_60._fleetRangeAntiAir:AppendCrewUnit(arg1_60)
	arg0_60._fleetStaticSonar:AppendCrewUnit(arg1_60)

	local var3_60 = {}

	for iter6_60, iter7_60 in ipairs(arg0_60._unitList) do
		table.insert(var3_60, iter6_60)
	end

	arg0_60:refreshFleetFormation(var3_60)
end

function var9_0.appendSubUnit(arg0_61, arg1_61)
	arg0_61._subList[#arg0_61._subList + 1] = arg1_61

	arg1_61:SetMainUnitIndex(#arg0_61._subList)
end

function var9_0.FleetWarcry(arg0_62)
	local var0_62
	local var1_62 = math.random(0, 1)
	local var2_62 = arg0_62:GetScoutList()[1]
	local var3_62 = arg0_62:GetMainList()[1]

	if var3_62 == nil or var1_62 == 0 then
		var0_62 = var2_62
	elseif var1_62 == 1 then
		var0_62 = var3_62
	end

	local var4_62 = "battle"
	local var5_62 = var0_62:GetIntimacy()
	local var6_62 = var0_0.Battle.BattleDataFunction.GetWords(var0_62:GetSkinID(), var4_62, var5_62)

	var0_62:DispatchVoice(var4_62)
	var0_62:DispatchChat(var6_62, 2.5, var4_62)
end

function var9_0.FleetUnitSpwanFinish(arg0_63)
	local var0_63 = 0

	for iter0_63, iter1_63 in ipairs(arg0_63._unitList) do
		var0_63 = var0_63 + iter1_63:GetGearScore()
	end

	for iter2_63, iter3_63 in ipairs(arg0_63._unitList) do
		var8_0.SetCurrent(iter3_63, "fleetGS", var0_63)
	end
end

function var9_0.SubWarcry(arg0_64)
	local var0_64 = arg0_64:GetSubList()[1]
	local var1_64 = "battle"
	local var2_64 = var0_64:GetIntimacy()
	local var3_64 = var0_0.Battle.BattleDataFunction.GetWords(var0_64:GetSkinID(), var1_64, var2_64)

	var0_64:DispatchVoice(var1_64)
	var0_64:DispatchChat(var3_64, 2.5, var1_64)
end

function var9_0.SetWeaponBlock(arg0_65, arg1_65)
	arg0_65._blockCast = arg0_65._blockCast + arg1_65
end

function var9_0.GetWeaponBlock(arg0_66)
	return arg0_66._blockCast > 0
end

function var9_0.CastChargeWeapon(arg0_67)
	if arg0_67:GetWeaponBlock() then
		return
	end

	local var0_67 = arg0_67._chargeWeaponVO:GetCurrentWeapon()

	if var0_67 ~= nil and var0_67:GetCurrentState() == var0_67.STATE_READY then
		var0_67:Charge()

		local var1_67 = {}
		local var2_67 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.POINT_HIT_CHARGE, var1_67)

		arg0_67:DispatchEvent(var2_67)
	end
end

function var9_0.CancelChargeWeapon(arg0_68)
	local var0_68 = arg0_68._chargeWeaponVO:GetCurrentWeapon()

	if var0_68 ~= nil and var0_68:GetCurrentState() == var0_68.STATE_PRECAST then
		local var1_68 = {}
		local var2_68 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.POINT_HIT_CANCEL, var1_68)

		arg0_68:DispatchEvent(var2_68)
		var0_68:CancelCharge()
	end
end

function var9_0.UnleashChrageWeapon(arg0_69)
	if arg0_69:GetWeaponBlock() then
		arg0_69:CancelChargeWeapon()

		return
	end

	local var0_69 = arg0_69._chargeWeaponVO:GetCurrentWeapon()

	if var0_69 ~= nil and var0_69:GetCurrentState() == var0_69.STATE_PRECAST then
		if var0_69:IsStrikeMode() then
			local var1_69 = arg0_69._motionVO:GetPos().x + var5_0.ChargeWeaponConfig.SIGHT_C
			local var2_69 = math.min(var1_69, arg0_69._totalRightBound)

			arg0_69:fireChargeWeapon(var0_69, true, Vector3.New(var2_69, 0, arg0_69._motionVO:GetPos().z))
		else
			var0_69:CancelCharge()
		end

		local var3_69 = {}
		local var4_69 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.POINT_HIT_CANCEL, var3_69)

		arg0_69:DispatchEvent(var4_69)
	end
end

function var9_0.QuickTagChrageWeapon(arg0_70, arg1_70)
	if arg0_70:GetWeaponBlock() then
		return
	end

	local var0_70 = arg0_70._chargeWeaponVO:GetCurrentWeapon()

	if var0_70 ~= nil and var0_70:GetCurrentState() == var0_70.STATE_READY then
		var0_70:QuickTag()

		if #var0_70:GetLockList() <= 0 then
			var0_70:CancelQuickTag()
		else
			arg0_70:fireChargeWeapon(var0_70, arg1_70)
		end
	end
end

function var9_0.fireChargeWeapon(arg0_71, arg1_71, arg2_71, arg3_71)
	local var0_71 = arg1_71:GetHost()

	local function var1_71()
		local function var0_72()
			arg1_71:Fire(arg3_71)
		end

		arg1_71:DispatchBlink(var0_72)
	end

	if arg2_71 then
		if arg0_71._IFF == var5_0.FRIENDLY_CODE then
			arg0_71._chargeWeaponVO:PlayCutIn(var0_71, 1 / var5_0.FOCUS_MAP_RATE)
		end

		arg0_71._chargeWeaponVO:PlayFocus(var0_71, var1_71)
	else
		if arg0_71._IFF == var5_0.FRIENDLY_CODE then
			arg0_71._chargeWeaponVO:PlayCutIn(var0_71, 1)
		end

		var1_71()
	end
end

function var9_0.UnleashAllInStrike(arg0_74)
	if arg0_74:GetWeaponBlock() then
		return
	end

	local var0_74 = arg0_74._airAssistVO:GetCurrentWeapon()

	if var0_74 and var0_74:GetCurrentState() == var0_74.STATE_READY then
		local var1_74 = var0_74:GetHost()

		if arg0_74._IFF == var5_0.FRIENDLY_CODE and var1_74:IsMainFleetUnit() then
			arg0_74._airAssistVO:PlayCutIn(var1_74, 1)
		end

		var0_74:CLSBullet()
		var0_74:DispatchBlink()
		var0_74:Fire()
	end
end

function var9_0.CastTorpedo(arg0_75)
	if arg0_75:GetWeaponBlock() then
		return
	end

	local var0_75 = arg0_75._torpedoWeaponVO:GetCurrentWeapon()

	if var0_75 ~= nil and var0_75:GetCurrentState() == var0_75.STATE_READY then
		var0_75:Prepar()
	end
end

function var9_0.CancelTorpedo(arg0_76)
	local var0_76 = arg0_76._torpedoWeaponVO:GetCurrentWeapon()

	if var0_76 ~= nil and var0_76:GetCurrentState() == var0_76.STATE_PRECAST then
		var0_76:Cancel()
	end
end

function var9_0.UnleashTorpedo(arg0_77)
	if arg0_77:GetWeaponBlock() then
		arg0_77:CancelTorpedo()

		return
	end

	local var0_77 = arg0_77._torpedoWeaponVO:GetCurrentWeapon()

	if var0_77 ~= nil and var0_77:GetCurrentState() == var0_77.STATE_PRECAST then
		var0_77:Fire()
	end
end

function var9_0.QuickCastTorpedo(arg0_78)
	if arg0_78:GetWeaponBlock() then
		return
	end

	local var0_78 = arg0_78._torpedoWeaponVO:GetCurrentWeapon()

	if var0_78 ~= nil and var0_78:GetCurrentState() == var0_78.STATE_READY then
		var0_78:Fire(true)
	end
end

function var9_0.RemoveManunalTorpedo(arg0_79, arg1_79)
	if arg1_79:IsAttacking() then
		arg0_79:CancelTorpedo()
	end

	arg0_79._torpedoWeaponVO:RemoveWeapon(arg1_79)
	arg1_79:Clear()
end

function var9_0.CoupleEncourage(arg0_80)
	local var0_80 = {}
	local var1_80 = {}

	for iter0_80, iter1_80 in ipairs(arg0_80._unitList) do
		local var2_80 = iter1_80:GetIntimacy()
		local var3_80 = var7_0.GetWords(iter1_80:GetSkinID(), "couple_encourage", var2_80)

		if #var3_80 > 0 then
			var0_80[iter1_80] = var3_80
		end
	end

	local var4_80 = var4_0.CPChatType
	local var5_80 = var4_0.CPChatTargetFunc

	local function var6_80(arg0_81, arg1_81)
		local var0_81 = {}

		if arg0_81 == var4_80.GROUP_ID then
			var0_81.groupIDList = arg1_81
		elseif arg0_81 == var4_80.SHIP_TYPE then
			var0_81.ship_type_list = arg1_81
		elseif arg0_81 == var4_80.RARE then
			var0_81.rarity = arg1_81[1]
		elseif arg0_81 == var4_80.NATIONALITY then
			var0_81.nationality = arg1_81[1]
		elseif arg0_81 == var4_80.ILLUSTRATOR then
			var0_81.illustrator = arg1_81[1]
		elseif arg0_81 == var4_80.TEAM then
			var0_81.teamIndex = arg1_81[1]
		end

		return var0_81
	end

	for iter2_80, iter3_80 in pairs(var0_80) do
		for iter4_80, iter5_80 in ipairs(iter3_80) do
			local var7_80 = iter5_80[1]
			local var8_80 = iter5_80[2]
			local var9_80 = iter5_80[4] or var4_80.GROUP_ID
			local var10_80 = var0_0.Battle.BattleTargetChoise.TargetAllHelp(iter2_80)

			if type(var9_80) == "table" then
				for iter6_80, iter7_80 in ipairs(var9_80) do
					local var11_80 = var6_80(iter7_80, var7_80[iter6_80])

					var10_80 = var0_0.Battle.BattleTargetChoise[var5_80[iter7_80]](iter2_80, var11_80, var10_80)
				end
			elseif type(var9_80) == "number" then
				local var12_80 = var6_80(var9_80, var7_80)

				var10_80 = var0_0.Battle.BattleTargetChoise[var5_80[var9_80]](iter2_80, var12_80, var10_80)
			end

			if var8_80 <= #var10_80 then
				local var13_80 = {
					cp = iter2_80,
					content = iter5_80[3],
					linkIndex = iter4_80
				}

				var1_80[#var1_80 + 1] = var13_80
			end
		end
	end

	if #var1_80 > 0 then
		local var14_80 = var1_80[math.random(#var1_80)]
		local var15_80 = "link" .. var14_80.linkIndex

		var14_80.cp:DispatchVoice(var15_80)
		var14_80.cp:DispatchChat(var14_80.content, 3, var15_80)
	end
end

function var9_0.onUnitUpdateHP(arg0_82, arg1_82)
	local var0_82 = arg1_82.Dispatcher
	local var1_82 = arg1_82.Data.dHP

	for iter0_82, iter1_82 in ipairs(arg0_82._unitList) do
		iter1_82:TriggerBuff(var4_0.BuffEffectType.ON_FRIENDLY_HP_RATIO_UPDATE, {
			unit = var0_82,
			dHP = var1_82
		})

		if iter1_82 ~= var0_82 then
			iter1_82:TriggerBuff(var4_0.BuffEffectType.ON_TEAMMATE_HP_RATIO_UPDATE, {
				unit = var0_82,
				dHP = var1_82
			})
		end
	end
end

function var9_0.SetSubUnitData(arg0_83, arg1_83)
	arg0_83._subUntiDataList = arg1_83
end

function var9_0.GetSubUnitData(arg0_84)
	return arg0_84._subUntiDataList
end

function var9_0.AddSubMarine(arg0_85, arg1_85)
	arg1_85:InitOxygen()

	local var0_85 = arg1_85:GetTemplate()
	local var1_85 = var0_0.Battle.BattleUnitPhaseSwitcher.New(arg1_85)

	local function var2_85()
		return arg1_85:GetRaidDuration()
	end

	var1_85:SetTemplateData(var7_0.GeneratePlayerSubmarinPhase(arg0_85._subAttackBaseLine, arg0_85._subRetreatBaseLine, arg1_85:GetAttrByName("raidDist"), var2_85, arg1_85:GetAttrByName("oxyAtkDuration")))

	arg0_85._unitList[#arg0_85._unitList + 1] = arg1_85
	arg0_85._subList[#arg0_85._subList + 1] = arg1_85

	arg1_85:SetFleetVO(arg0_85)
	arg1_85:RegisterEventListener(arg0_85, var1_0.UPDATE_HP, arg0_85.onUnitUpdateHP)
end

function var9_0.AddManualSubmarine(arg0_87, arg1_87)
	arg0_87._unitList[#arg0_87._unitList + 1] = arg1_87
	arg0_87._manualSubList[#arg0_87._manualSubList + 1] = arg1_87
	arg0_87._manualSubBench[#arg0_87._manualSubBench + 1] = arg1_87
	arg0_87._maxCount = arg0_87._maxCount + 1

	arg1_87:InitOxygen()
	arg1_87:SetFleetVO(arg0_87)
	arg1_87:SetMotion(arg0_87._motionVO)
	arg1_87:RegisterEventListener(arg0_87, var1_0.UPDATE_HP, arg0_87.onUnitUpdateHP)
end

function var9_0.GetSubList(arg0_88)
	return arg0_88._subList
end

function var9_0.ShiftManualSub(arg0_89)
	local var0_89

	if arg0_89._manualSubUnit then
		local var1_89 = arg0_89._manualSubUnit:GetTorpedoList()

		for iter0_89, iter1_89 in ipairs(var1_89) do
			if iter1_89:IsAttacking() then
				arg0_89:CancelTorpedo()
			end

			arg0_89._torpedoWeaponVO:RemoveWeapon(iter1_89)
		end

		if arg0_89._manualSubUnit:IsAlive() then
			table.insert(arg0_89._manualSubBench, arg0_89._manualSubUnit)
		end

		var0_89 = arg0_89._motionVO:GetPos():Clone()
	else
		var0_89 = arg0_89._manualSubList[1]:GetPosition():Clone()
	end

	arg0_89._manualSubUnit = table.remove(arg0_89._manualSubBench, 1)
	arg0_89._scoutList[1] = arg0_89._manualSubUnit

	local var2_89 = {}

	for iter2_89, iter3_89 in ipairs(arg0_89._manualSubBench) do
		for iter4_89, iter5_89 in ipairs(arg0_89._unitList) do
			if iter5_89 == iter3_89 then
				table.insert(var2_89, iter4_89)

				break
			end
		end
	end

	for iter6_89, iter7_89 in ipairs(arg0_89._unitList) do
		if iter7_89 == arg0_89._manualSubUnit then
			table.insert(var2_89, 1, iter6_89)

			break
		end
	end

	arg0_89:refreshFleetFormation(var2_89)
	arg0_89._manualSubUnit:SetMainUnitStatic(false)
	arg0_89._manualSubUnit:SetPosition(var0_89)
	arg0_89:UpdateMotion()
	arg0_89._submarineSpecialVO:SetUseable(false)

	local var3_89 = arg0_89._manualSubUnit:GetBuffList()

	for iter8_89, iter9_89 in pairs(var3_89) do
		if iter9_89:IsSubmarineSpecial() then
			arg0_89._submarineSpecialVO:SetCount(1)
			arg0_89._submarineSpecialVO:SetUseable(true)

			break
		end
	end

	arg0_89:ChangeSubmarineState(var0_0.Battle.OxyState.STATE_FREE_DIVE)
	arg0_89._torpedoWeaponVO:Reset()

	local var4_89 = arg0_89._manualSubUnit:GetTorpedoList()

	for iter10_89, iter11_89 in ipairs(var4_89) do
		if iter11_89:GetCurrentState() ~= iter11_89.STATE_OVER_HEAT then
			arg0_89._torpedoWeaponVO:AppendWeapon(iter11_89)
		end
	end

	for iter12_89, iter13_89 in ipairs(var4_89) do
		if iter13_89:GetCurrentState() == iter13_89.STATE_OVER_HEAT then
			arg0_89._torpedoWeaponVO:AppendWeapon(iter13_89)
		end
	end

	for iter14_89, iter15_89 in ipairs(arg0_89._manualSubBench) do
		iter15_89:SetPosition(var5_0.SUB_BENCH_POS[iter14_89])
		iter15_89:SetMainUnitStatic(true)
		iter15_89:ChangeOxygenState(var0_0.Battle.OxyState.STATE_FREE_BENCH)
	end

	arg0_89._submarineShiftVO:ResetCurrent()

	if #arg0_89._manualSubBench == 0 then
		arg0_89._submarineShiftVO:SetActive(false)
	end
end

function var9_0.ChangeSubmarineState(arg0_90, arg1_90, arg2_90)
	if not arg0_90._manualSubUnit then
		return
	end

	arg0_90._manualSubUnit:ChangeOxygenState(arg1_90)

	if arg2_90 then
		for iter0_90, iter1_90 in ipairs(arg0_90._submarineVOList) do
			iter1_90:ResetCurrent()
		end

		local var0_90 = arg0_90._submarineShiftVO:GetMax() - arg0_90._submarineShiftVO:GetCurrent()

		if arg0_90._submarineShiftVO:IsOverLoad() and var0_90 > var5_0.SR_CONFIG.DIVE_CD then
			-- block empty
		else
			arg0_90._submarineShiftVO:SetMax(var5_0.SR_CONFIG.DIVE_CD)
			arg0_90._submarineShiftVO:ResetCurrent()
		end
	end

	arg0_90:DispatchEvent(var0_0.Event.New(var2_0.MANUAL_SUBMARINE_SHIFT, {
		state = arg1_90
	}))
end

function var9_0.SubmarinBoost(arg0_91)
	arg0_91._manualSubUnit:Boost(Vector3.right, var5_0.SR_CONFIG.BOOST_SPEED, var5_0.SR_CONFIG.BOOST_DECAY, var5_0.SR_CONFIG.BOOST_DURATION, var5_0.SR_CONFIG.BOOST_DECAY_STAMP)
	arg0_91._submarineBoostVO:ResetCurrent()
end

function var9_0.UnleashSubmarineSpecial(arg0_92)
	if arg0_92:GetWeaponBlock() then
		return
	end

	arg0_92._submarineSpecialVO:Cast()
	arg0_92._manualSubUnit:TriggerBuff(var4_0.BuffEffectType.ON_SUBMARINE_FREE_SPECIAL)
end

function var9_0.AppendIndieSonar(arg0_93, arg1_93, arg2_93)
	local var0_93 = var0_0.Battle.BattleIndieSonar.New(arg0_93, arg1_93, arg2_93)

	var0_93:SwitchHost(arg0_93._motionReferenceUnit)

	arg0_93._indieSonarList[var0_93] = true

	var0_93:Detect()
end

function var9_0.RemoveIndieSonar(arg0_94, arg1_94)
	for iter0_94, iter1_94 in pairs(arg0_94._indieSonarList) do
		if arg1_94 == iter0_94 then
			arg0_94._indieSonarList[iter0_94] = nil

			break
		end
	end
end

function var9_0.AttachFleetBuff(arg0_95, arg1_95)
	local var0_95 = arg1_95:GetID()
	local var1_95 = arg0_95:GetFleetBuff(var0_95)

	if var1_95 then
		var1_95:Stack(arg0_95)
	else
		arg0_95._buffList[var0_95] = arg1_95

		arg1_95:Attach(arg0_95)
	end
end

function var9_0.RemoveFleetBuff(arg0_96, arg1_96)
	local var0_96 = arg0_96:GetFleetBuff(arg1_96)

	if var0_96 then
		var0_96:Remove()
	end
end

function var9_0.GetFleetBuff(arg0_97, arg1_97)
	return arg0_97._buffList[arg1_97]
end

function var9_0.GetFleetBuffList(arg0_98)
	return arg0_98._buffList
end

function var9_0.Jamming(arg0_99, arg1_99)
	if arg1_99 then
		arg0_99._chargeWeaponVO:StartJamming()
		arg0_99._torpedoWeaponVO:StartJamming()
		arg0_99._airAssistVO:StartJamming()
	else
		arg0_99._chargeWeaponVO:JammingEliminate()
		arg0_99._torpedoWeaponVO:JammingEliminate()
		arg0_99._airAssistVO:JammingEliminate()
	end
end

function var9_0.Blinding(arg0_100, arg1_100)
	arg0_100:DispatchEvent(var0_0.Event.New(var2_0.FLEET_BLIND, {
		isBlind = arg1_100
	}))
end

function var9_0.UpdateHorizon(arg0_101)
	arg0_101:DispatchEvent(var0_0.Event.New(var2_0.FLEET_HORIZON_UPDATE, {}))
end

function var9_0.AutoBotUpdated(arg0_102, arg1_102)
	local var0_102 = arg1_102 and var4_0.BuffEffectType.ON_AUTOBOT or var4_0.BuffEffectType.ON_MANUAL

	for iter0_102, iter1_102 in ipairs(arg0_102._unitList) do
		iter1_102:TriggerBuff(var0_102)
	end
end

function var9_0.CloakFatalExpose(arg0_103)
	for iter0_103, iter1_103 in ipairs(arg0_103._cloakList) do
		iter1_103:GetCloak():ForceToMax()
	end
end

function var9_0.CloakInVision(arg0_104, arg1_104)
	for iter0_104, iter1_104 in ipairs(arg0_104._cloakList) do
		iter1_104:GetCloak():AppendExposeSpeed(arg1_104)
	end
end

function var9_0.CloakOutVision(arg0_105)
	for iter0_105, iter1_105 in ipairs(arg0_105._cloakList) do
		iter1_105:GetCloak():AppendExposeSpeed(0)
	end
end

function var9_0.AttachCloak(arg0_106, arg1_106)
	if not arg1_106:GetCloak() then
		arg1_106:InitCloak()

		arg0_106._cloakList[#arg0_106._cloakList + 1] = arg1_106
	end
end

function var9_0.AttachNightCloak(arg0_107)
	arg0_107._scoutAimBias = var0_0.Battle.BattleUnitAimBiasComponent.New()

	arg0_107._scoutAimBias:ConfigRangeFormula(var3_0.CalculateMaxAimBiasRange, var3_0.CalculateBiasDecay)
	arg0_107._scoutAimBias:Active(arg0_107._scoutAimBias.STATE_ACTIVITING)
	arg0_107:DispatchEvent(var0_0.Event.New(var2_0.ADD_AIM_BIAS, {
		aimBias = arg0_107._scoutAimBias
	}))
end

function var9_0.GetFleetBias(arg0_108)
	return arg0_108._scoutAimBias
end
