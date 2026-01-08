ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleFormulas
local var4_0 = var0_0.Battle.BattleConst
local var5_0 = var0_0.Battle.BattleConfig
local var6_0 = var0_0.Battle.BattleAttr
local var7_0 = var0_0.Battle.BattleDataFunction
local var8_0 = class("BattleFleetVO")

var0_0.Battle.BattleFleetVO = var8_0
var8_0.__name = "BattleFleetVO"

function var8_0.Ctor(arg0_1, arg1_1)
	var0_0.EventDispatcher.AttachEventDispatcher(arg0_1)
	var0_0.EventListener.AttachEventListener(arg0_1)

	arg0_1._IFF = arg1_1
	arg0_1._lastDist = 0

	arg0_1:init()
end

function var8_0.UpdateMotion(arg0_2)
	local var0_2 = 0

	if arg0_2._motionReferenceUnit then
		arg0_2._motionVO:UpdatePos(arg0_2._motionReferenceUnit)
		arg0_2._motionVO:UpdateVelocityAndDirection(arg0_2:GetFleetVelocity(), arg0_2._motionSourceFunc())

		var0_2 = math.max(arg0_2._motionVO:GetPos().x - arg0_2._rightBound, 0)
	end

	if var0_2 >= 0 and var0_2 ~= arg0_2._lastDist then
		arg0_2._lastDist = var0_2

		arg0_2:DispatchEvent(var0_0.Event.New(var2_0.SHOW_BUFFER, {
			dist = var0_2
		}))
	end
end

function var8_0.UpdateAutoComponent(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3._scoutList) do
		iter1_3:UpdateWeapon(arg1_3)
		iter1_3:UpdateAirAssist()
	end

	for iter2_3, iter3_3 in ipairs(arg0_3._mainList) do
		iter3_3:UpdateWeapon(arg1_3)
		iter3_3:UpdateAirAssist()
	end

	for iter4_3, iter5_3 in ipairs(arg0_3._supportList) do
		iter5_3:UpdateWeapon(arg1_3)
	end

	for iter6_3, iter7_3 in ipairs(arg0_3._cloakList) do
		iter7_3:UpdateCloak(arg1_3)
	end

	for iter8_3, iter9_3 in ipairs(arg0_3._subList) do
		iter9_3:UpdateWeapon(arg1_3)
		iter9_3:UpdateOxygen(arg1_3)
		iter9_3:UpdatePhaseSwitcher()
	end

	for iter10_3, iter11_3 in ipairs(arg0_3._manualSubList) do
		iter11_3:UpdateOxygen(arg1_3)
	end

	arg0_3._fleetAntiAir:Update(arg1_3)
	arg0_3._fleetRangeAntiAir:Update(arg1_3)
	arg0_3._fleetStaticSonar:Update(arg1_3)

	for iter12_3, iter13_3 in pairs(arg0_3._indieSonarList) do
		iter12_3:Update(arg1_3)
	end

	arg0_3:UpdateBuff(arg1_3)

	if arg0_3._cardPuzzleComponent then
		arg0_3._cardPuzzleComponent:Update(arg1_3)
	end
end

function var8_0.UpdateBuff(arg0_4, arg1_4)
	local var0_4 = arg0_4._buffList

	for iter0_4, iter1_4 in pairs(var0_4) do
		iter1_4:Update(arg0_4, arg1_4)
	end
end

function var8_0.UpdateManualWeaponVO(arg0_5, arg1_5)
	arg0_5._chargeWeaponVO:Update(arg1_5)
	arg0_5._torpedoWeaponVO:Update(arg1_5)
	arg0_5._airAssistVO:Update(arg1_5)
	arg0_5._submarineDiveVO:Update(arg1_5)
	arg0_5._submarineFloatVO:Update(arg1_5)
	arg0_5._submarineBoostVO:Update(arg1_5)
	arg0_5._submarineShiftVO:Update(arg1_5)
end

function var8_0.UpdateFleetDamage(arg0_6, arg1_6)
	local var0_6 = var3_0.CalculateFleetDamage(arg1_6)

	arg0_6._currentDMGRatio = arg0_6._currentDMGRatio + var0_6

	arg0_6:DispatchFleetDamageChange()
end

function var8_0.UpdateFleetOverDamage(arg0_7, arg1_7)
	local var0_7 = var3_0.CalculateFleetOverDamage(arg0_7, arg1_7)

	arg0_7._currentDMGRatio = arg0_7._currentDMGRatio - var0_7

	arg0_7:DispatchFleetDamageChange()
end

function var8_0.DispatchFleetDamageChange(arg0_8)
	arg0_8:DispatchEvent(var0_0.Event.New(var2_0.FLEET_DMG_CHANGE, {}))
end

function var8_0.DispatchSonarScan(arg0_9, arg1_9)
	arg0_9:DispatchEvent(var0_0.Event.New(var2_0.SONAR_SCAN, {
		indieSonar = arg1_9
	}))
end

function var8_0.FleetBuffTrigger(arg0_10, arg1_10, arg2_10)
	for iter0_10, iter1_10 in ipairs(arg0_10._unitList) do
		iter1_10:TriggerBuff(arg1_10, arg2_10)
	end
end

function var8_0.FreeMainUnit(arg0_11, arg1_11)
	if arg0_11._mainUnitFree then
		return
	end

	arg0_11._mainUnitFree = true

	for iter0_11, iter1_11 in ipairs(arg0_11._mainList) do
		local var0_11 = var0_0.Battle.BattleBuffUnit.New(arg1_11)

		iter1_11:AddBuff(var0_11)
		iter1_11:SetMainUnitStatic(false)
	end
end

function var8_0.RandomMainVictim(arg0_12, arg1_12)
	arg1_12 = arg1_12 or {}

	local var0_12 = {}
	local var1_12

	for iter0_12, iter1_12 in ipairs(arg0_12._mainList) do
		local var2_12 = true

		for iter2_12, iter3_12 in ipairs(arg1_12) do
			if iter1_12:GetAttrByName(iter3_12) >= 1 then
				var2_12 = false

				break
			end
		end

		if var2_12 then
			table.insert(var0_12, iter1_12)
		end
	end

	if #var0_12 > 0 then
		var1_12 = var0_12[math.random(#var0_12)]
	end

	return var1_12
end

function var8_0.NearestUnitByType(arg0_13, arg1_13, arg2_13)
	local var0_13 = 999
	local var1_13

	for iter0_13, iter1_13 in ipairs(arg0_13._unitList) do
		local var2_13 = iter1_13:GetTemplate().type

		if table.contains(arg2_13, var2_13) then
			local var3_13 = iter1_13:GetPosition()
			local var4_13 = Vector3.BattleDistance(var3_13, arg1_13)

			if var4_13 < var0_13 then
				var0_13 = var4_13
				var1_13 = iter1_13
			end
		end
	end

	return var1_13
end

function var8_0.SetMotionSource(arg0_14, arg1_14)
	if arg1_14 == nil then
		function arg0_14._motionSourceFunc()
			local var0_15 = pg.UIMgr.GetInstance()

			return var0_15.hrz, var0_15.vtc
		end
	else
		arg0_14._motionSourceFunc = arg1_14
	end
end

function var8_0.SetSubAidData(arg0_16, arg1_16, arg2_16)
	arg0_16._submarineVO = var0_0.Battle.BattleSubmarineAidVO.New()

	if arg2_16 == var4_0.SubAidFlag.AID_EMPTY or arg2_16 == var4_0.SubAidFlag.OIL_EMPTY then
		arg0_16._submarineVO:SetUseable(false)
	else
		arg0_16._submarineVO:SetCount(arg2_16)
		arg0_16._submarineVO:SetTotal(arg1_16)
		arg0_16._submarineVO:SetUseable(true)
	end
end

function var8_0.SetAutobotBound(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	arg0_17._upperBound = arg1_17
	arg0_17._lowerBound = arg2_17
	arg0_17._leftBound = arg3_17
	arg0_17._rightBound = arg4_17
end

function var8_0.SetTotalBound(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	arg0_18._totalUpperBound = arg1_18
	arg0_18._totalLowerBound = arg2_18
	arg0_18._totalLeftBound = arg3_18
	arg0_18._totalRightBound = arg4_18
end

function var8_0.SetUnitBound(arg0_19, arg1_19, arg2_19)
	arg0_19._fleetUnitBound = var0_0.Battle.BattleFleetBound.New(arg0_19._IFF)

	arg0_19._fleetUnitBound:ConfigAreaData(arg1_19, arg2_19)
	arg0_19._fleetUnitBound:SwtichCommon()
end

function var8_0.SetChapterPlayType(arg0_20, arg1_20)
	arg0_20._chapterType = arg1_20
end

function var8_0.GetLeftBoundDistance(arg0_21)
	if arg0_21._chapterType and arg0_21._chapterType == 5 then
		return math.abs(arg0_21._motionVO:GetPos().x - arg0_21._leftBound)
	end
end

function var8_0.UpdateScoutUnitBound(arg0_22)
	local var0_22, var1_22, var2_22, var3_22, var4_22, var5_22 = arg0_22._fleetUnitBound:GetBound()

	for iter0_22, iter1_22 in ipairs(arg0_22._scoutList) do
		iter1_22:SetBound(var0_22, var1_22, var2_22, var3_22, var4_22, var5_22)
	end

	for iter2_22, iter3_22 in pairs(arg0_22._freezeList) do
		if not iter2_22:IsMainFleetUnit() then
			iter2_22:SetBound(var0_22, var1_22, var2_22, var3_22, var4_22, var5_22)
		end
	end
end

function var8_0.CalcSubmarineBaseLine(arg0_23, arg1_23)
	local var0_23 = (arg0_23._totalRightBound + arg0_23._totalLeftBound) * 0.5

	if arg0_23._IFF == var5_0.FRIENDLY_CODE then
		if arg1_23 == SYSTEM_DUEL then
			-- block empty
		else
			arg0_23._subAttackBaseLine = var0_23
			arg0_23._subRetreatBaseLine = arg0_23._leftBound - 10
		end
	elseif arg0_23._IFF == var5_0.FOE_CODE and arg1_23 == SYSTEM_DUEL then
		-- block empty
	end
end

function var8_0.SetExposeLine(arg0_24, arg1_24, arg2_24)
	arg0_24._visionLineX = arg1_24
	arg0_24._exposeLineX = arg2_24
end

function var8_0.AppendPlayerUnit(arg0_25, arg1_25)
	arg0_25._unitList[#arg0_25._unitList + 1] = arg1_25
	arg0_25._maxCount = arg0_25._maxCount + 1

	if arg1_25:IsMainFleetUnit() then
		arg0_25:appendMainUnit(arg1_25)
	else
		arg0_25:appendScoutUnit(arg1_25)
	end

	arg1_25:SetFleetVO(arg0_25)
	arg1_25:SetMotion(arg0_25._motionVO)
	arg1_25:RegisterEventListener(arg0_25, var1_0.UPDATE_HP, arg0_25.onUnitUpdateHP)
	arg1_25:RegisterEventListener(arg0_25, var1_0.UPDATE_CLOAK_STATE, arg0_25.onUnitCloakUpdate)

	if arg0_25._cardPuzzleComponent then
		arg0_25._cardPuzzleComponent:AppendUnit(arg1_25)
	end
end

function var8_0.RemovePlayerUnit(arg0_26, arg1_26, arg2_26)
	arg0_26._freezeList[arg1_26] = nil

	local var0_26 = {}

	for iter0_26, iter1_26 in ipairs(arg0_26._unitList) do
		if iter1_26 ~= arg1_26 then
			var0_26[#var0_26 + 1] = iter0_26
		else
			if not arg2_26 then
				iter1_26:UnregisterEventListener(arg0_26, var1_0.UPDATE_HP)
				iter1_26:UnregisterEventListener(arg0_26, var1_0.UPDATE_CLOAK_STATE)
				iter1_26:DeactiveCldBox()
			end

			local var1_26 = iter1_26:GetChargeList()

			for iter2_26, iter3_26 in ipairs(var1_26) do
				if iter3_26:IsAttacking() then
					arg0_26._chargeWeaponVO:CancelFocus()
					arg0_26._chargeWeaponVO:ResetFocus()
					arg0_26:CancelChargeWeapon()
				end

				arg0_26._chargeWeaponVO:RemoveWeapon(iter3_26)

				if not arg2_26 then
					iter3_26:Clear()
				end
			end

			arg0_26._fleetAntiAir:RemoveCrewUnit(arg1_26)
			arg0_26._fleetRangeAntiAir:RemoveCrewUnit(arg1_26)
			arg0_26._fleetStaticSonar:RemoveCrewUnit(arg1_26)

			local var2_26 = iter1_26:GetTorpedoList()

			for iter4_26, iter5_26 in ipairs(var2_26) do
				arg0_26:RemoveManunalTorpedo(iter5_26, arg2_26)
			end

			local var3_26 = iter1_26:GetAirAssistList()

			if var3_26 then
				for iter6_26, iter7_26 in ipairs(var3_26) do
					arg0_26._airAssistVO:RemoveWeapon(iter7_26)
				end
			end
		end
	end

	for iter8_26, iter9_26 in ipairs(arg0_26._scoutList) do
		if iter9_26 == arg1_26 then
			if #arg0_26._scoutList == 1 then
				arg0_26:CancelChargeWeapon()
			end

			table.remove(arg0_26._scoutList, iter8_26)

			break
		end
	end

	local function var4_26(arg0_27)
		for iter0_27, iter1_27 in ipairs(arg0_27) do
			if iter1_27 == arg1_26 then
				table.remove(arg0_27, iter0_27)

				break
			end
		end
	end

	var4_26(arg0_26._mainList)
	var4_26(arg0_26._cloakList)
	var4_26(arg0_26._subList)
	var4_26(arg0_26._manualSubList)

	if not arg0_26._manualSubUnit then
		arg0_26:refreshFleetFormation(var0_26)
	end
end

function var8_0.OverrideJoyStickAutoBot(arg0_28, arg1_28)
	arg0_28._autoBotAIID = arg1_28

	local var0_28 = var0_0.Event.New(var0_0.Battle.BattleEvent.OVERRIDE_AUTO_BOT)

	arg0_28:DispatchEvent(var0_28)
end

function var8_0.SnapShot(arg0_29)
	arg0_29._totalDMGRatio = var3_0.GetFleetTotalHP(arg0_29)
	arg0_29._currentDMGRatio = arg0_29._totalDMGRatio
end

function var8_0.GetIFF(arg0_30)
	return arg0_30._IFF
end

function var8_0.GetMaxCount(arg0_31)
	return arg0_31._maxCount
end

function var8_0.GetFlagShip(arg0_32)
	return arg0_32._flagShip
end

function var8_0.GetLeaderShip(arg0_33)
	return arg0_33._scoutList[1]
end

function var8_0.GetUnitList(arg0_34)
	return arg0_34._unitList
end

function var8_0.GetFreezeUnitList(arg0_35)
	return arg0_35._freezeList
end

function var8_0.GetMainList(arg0_36)
	return arg0_36._mainList
end

function var8_0.GetScoutList(arg0_37)
	return arg0_37._scoutList
end

function var8_0.GetFreezeShipByID(arg0_38, arg1_38)
	for iter0_38, iter1_38 in pairs(arg0_38._freezeList) do
		if arg1_38 == iter0_38:GetAttrByName("id") then
			return iter0_38
		end
	end
end

function var8_0.GetShipByID(arg0_39, arg1_39)
	for iter0_39, iter1_39 in ipairs(arg0_39._unitList) do
		if arg1_39 == iter1_39:GetAttrByName("id") then
			return iter1_39
		end
	end
end

function var8_0.GetCloakList(arg0_40)
	return arg0_40._cloakList
end

function var8_0.GetSubBench(arg0_41)
	return arg0_41._manualSubBench
end

function var8_0.GetUnitBound(arg0_42)
	return arg0_42._fleetUnitBound
end

function var8_0.GetMotion(arg0_43)
	return arg0_43._motionVO
end

function var8_0.GetMotionReferenceUnit(arg0_44)
	return arg0_44._motionReferenceUnit
end

function var8_0.GetAutoBotAIID(arg0_45)
	return arg0_45._autoBotAIID
end

function var8_0.GetChargeWeaponVO(arg0_46)
	return arg0_46._chargeWeaponVO
end

function var8_0.GetTorpedoWeaponVO(arg0_47)
	return arg0_47._torpedoWeaponVO
end

function var8_0.GetAirAssistVO(arg0_48)
	return arg0_48._airAssistVO
end

function var8_0.GetSubAidVO(arg0_49)
	return arg0_49._submarineVO
end

function var8_0.GetSubFreeDiveVO(arg0_50)
	return arg0_50._submarineDiveVO
end

function var8_0.GetSubFreeFloatVO(arg0_51)
	return arg0_51._submarineFloatVO
end

function var8_0.GetSubBoostVO(arg0_52)
	return arg0_52._submarineBoostVO
end

function var8_0.GetSubSpecialVO(arg0_53)
	return arg0_53._submarineSpecialVO
end

function var8_0.GetSubShiftVO(arg0_54)
	return arg0_54._submarineShiftVO
end

function var8_0.GetFleetAntiAirWeapon(arg0_55)
	return arg0_55._fleetAntiAir
end

function var8_0.GetFleetRangeAntiAirWeapon(arg0_56)
	return arg0_56._fleetRangeAntiAir
end

function var8_0.GetFleetVelocity(arg0_57)
	return var3_0.GetFleetVelocity(arg0_57._scoutList)
end

function var8_0.GetFleetBound(arg0_58)
	return arg0_58._upperBound, arg0_58._lowerBound, arg0_58._leftBound, arg0_58._rightBound
end

function var8_0.GetFleetUnitBound(arg0_59)
	return arg0_59._totalUpperBound, arg0_59._totalLowerBound
end

function var8_0.GetFleetExposeLine(arg0_60)
	return arg0_60._exposeLineX
end

function var8_0.GetFleetVisionLine(arg0_61)
	return arg0_61._visionLineX
end

function var8_0.GetLeaderPersonality(arg0_62)
	return arg0_62._motionReferenceUnit:GetAutoPilotPreference()
end

function var8_0.GetDamageRatioResult(arg0_63)
	return string.format("%0.2f", arg0_63._currentDMGRatio / arg0_63._totalDMGRatio * 100), arg0_63._totalDMGRatio
end

function var8_0.GetDamageRatio(arg0_64)
	return arg0_64._currentDMGRatio / arg0_64._totalDMGRatio
end

function var8_0.GetSubmarineBaseLine(arg0_65)
	return arg0_65._fixedSubRefLine or arg0_65._subAttackBaseLine, arg0_65._subRetreatBaseLine
end

function var8_0.GetFleetSonar(arg0_66)
	return arg0_66._fleetStaticSonar
end

function var8_0.Dispose(arg0_67)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_67)
	var0_0.EventListener.DetachEventListener(arg0_67)

	arg0_67._leaderUnit = nil

	arg0_67._fleetAntiAir:Dispose()
	arg0_67._fleetRangeAntiAir:Dispose()
	arg0_67._fleetStaticSonar:Dispose()

	arg0_67._fleetStaticSonar = nil
	arg0_67._buffList = nil
	arg0_67._indieSonarList = nil
	arg0_67._scoutAimBias = nil

	arg0_67._fleetAttr:Dispose()

	arg0_67._fleetAttr = nil
	arg0_67._freezeList = nil
end

function var8_0.refreshFleetFormation(arg0_68, arg1_68)
	local var0_68 = var7_0.GetFormationTmpDataFromID(var5_0.FORMATION_ID).pos_offset

	arg0_68._unitList = var7_0.SortFleetList(arg1_68, arg0_68._unitList)

	local var1_68 = var5_0.BornOffset

	if not arg0_68._mainUnitFree then
		for iter0_68, iter1_68 in ipairs(arg0_68._unitList) do
			if not table.contains(arg0_68._subList, iter1_68) then
				local var2_68 = var0_68[iter0_68] or var0_68[#var0_68]

				iter1_68:UpdateFormationOffset(Vector3(var2_68.x, var2_68.y, var2_68.z) + var1_68 * (iter0_68 - 1))
			end
		end
	end

	if #arg0_68._scoutList > 0 then
		arg0_68._motionReferenceUnit = arg0_68._scoutList[1]
		arg0_68._leaderUnit = arg0_68._scoutList[1]

		arg0_68._leaderUnit:LeaderSetting()
		arg0_68._fleetAntiAir:SwitchHost(arg0_68._motionReferenceUnit)
		arg0_68._fleetStaticSonar:SwitchHost(arg0_68._motionReferenceUnit)

		for iter2_68, iter3_68 in pairs(arg0_68._indieSonarList) do
			iter2_68:SwitchHost(arg0_68._motionReferenceUnit)
		end

		arg0_68._motionVO:UpdatePos(arg0_68._motionReferenceUnit)
	elseif arg0_68._fleetAntiAir:GetCurrentState() ~= arg0_68._fleetAntiAir.STATE_DISABLE then
		local var3_68 = arg0_68._fleetAntiAir:GetCrewUnitList()

		for iter4_68, iter5_68 in pairs(var3_68) do
			arg0_68._motionReferenceUnit = iter4_68

			arg0_68._fleetAntiAir:SwitchHost(iter4_68)

			break
		end
	else
		arg0_68._motionReferenceUnit = arg0_68._mainList[1]
		arg0_68._leaderUnit = nil
	end

	if #arg0_68:GetUnitList() == 0 then
		return
	end

	local var4_68 = var0_0.Event.New(var0_0.Battle.BattleEvent.REFRESH_FLEET_FORMATION)

	arg0_68:DispatchEvent(var4_68)
end

function var8_0.init(arg0_69)
	arg0_69._chargeWeaponVO = var0_0.Battle.BattleChargeWeaponVO.New()
	arg0_69._torpedoWeaponVO = var0_0.Battle.BattleTorpedoWeaponVO.New()
	arg0_69._airAssistVO = var0_0.Battle.BattleAllInStrikeVO.New()
	arg0_69._submarineDiveVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.DIVE_CD)
	arg0_69._submarineFloatVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.FLOAT_CD)
	arg0_69._submarineVOList = {
		arg0_69._submarineDiveVO,
		arg0_69._submarineFloatVO
	}
	arg0_69._submarineBoostVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.BOOST_CD)
	arg0_69._submarineShiftVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.SHIFT_CD)
	arg0_69._submarineSpecialVO = var0_0.Battle.BattleSubmarineAidVO.New()

	arg0_69._submarineSpecialVO:SetCount(1)
	arg0_69._submarineSpecialVO:SetTotal(1)

	arg0_69._fleetAntiAir = var0_0.Battle.BattleFleetAntiAirUnit.New()
	arg0_69._fleetRangeAntiAir = var0_0.Battle.BattleFleetRangeAntiAirUnit.New()
	arg0_69._motionVO = var0_0.Battle.BattleFleetMotionVO.New()
	arg0_69._fleetStaticSonar = var0_0.Battle.BattleFleetStaticSonar.New(arg0_69)
	arg0_69._indieSonarList = {}
	arg0_69._scoutList = {}
	arg0_69._mainList = {}
	arg0_69._subList = {}
	arg0_69._supportList = {}
	arg0_69._cloakList = {}
	arg0_69._manualSubList = {}
	arg0_69._manualSubBench = {}
	arg0_69._unitList = {}
	arg0_69._maxCount = 0
	arg0_69._freezeList = {}
	arg0_69._blockCast = 0
	arg0_69._buffList = {}

	arg0_69:AttachFleetAttr()
	arg0_69:SetMotionSource()
end

function var8_0.appendScoutUnit(arg0_70, arg1_70)
	arg0_70._scoutList[#arg0_70._scoutList + 1] = arg1_70

	local var0_70 = arg1_70:GetTorpedoList()

	for iter0_70, iter1_70 in ipairs(var0_70) do
		arg0_70._torpedoWeaponVO:AppendWeapon(iter1_70)
	end

	if #arg1_70:GetHiveList() > 0 then
		local var1_70 = var7_0.CreateAllInStrike(arg1_70)

		for iter2_70, iter3_70 in ipairs(var1_70) do
			arg0_70._airAssistVO:AppendWeapon(iter3_70)
		end

		arg1_70:SetAirAssistList(var1_70)
	end

	arg0_70._fleetAntiAir:AppendCrewUnit(arg1_70)
	arg0_70._fleetStaticSonar:AppendCrewUnit(arg1_70)

	local var2_70 = 1
	local var3_70 = #arg0_70._unitList
	local var4_70 = {}

	while var2_70 < var3_70 do
		table.insert(var4_70, var2_70)

		var2_70 = var2_70 + 1
	end

	table.insert(var4_70, #arg0_70._scoutList, var2_70)
	arg0_70:refreshFleetFormation(var4_70)
end

function var8_0.appendMainUnit(arg0_71, arg1_71)
	if #arg0_71._mainList == 0 then
		arg0_71._flagShip = arg1_71
	end

	arg0_71._mainList[#arg0_71._mainList + 1] = arg1_71

	arg1_71:SetMainUnitIndex(#arg0_71._mainList)

	if ShipType.CloakShipType(arg1_71:GetTemplate().type) then
		arg0_71:AttachCloak(arg1_71)
	end

	local var0_71 = arg1_71:GetChargeList()

	for iter0_71, iter1_71 in ipairs(var0_71) do
		arg0_71._chargeWeaponVO:AppendWeapon(iter1_71)
	end

	local var1_71 = arg1_71:GetTorpedoList()

	for iter2_71, iter3_71 in ipairs(var1_71) do
		arg0_71._torpedoWeaponVO:AppendWeapon(iter3_71)
	end

	if #arg1_71:GetHiveList() > 0 then
		local var2_71 = var7_0.CreateAllInStrike(arg1_71)

		for iter4_71, iter5_71 in ipairs(var2_71) do
			arg0_71._airAssistVO:AppendWeapon(iter5_71)
		end

		arg1_71:SetAirAssistList(var2_71)
	end

	arg0_71._fleetAntiAir:AppendCrewUnit(arg1_71)
	arg0_71._fleetRangeAntiAir:AppendCrewUnit(arg1_71)
	arg0_71._fleetStaticSonar:AppendCrewUnit(arg1_71)

	local var3_71 = {}

	for iter6_71, iter7_71 in ipairs(arg0_71._unitList) do
		table.insert(var3_71, iter6_71)
	end

	arg0_71:refreshFleetFormation(var3_71)
end

function var8_0.appendSubUnit(arg0_72, arg1_72)
	arg0_72._subList[#arg0_72._subList + 1] = arg1_72

	arg1_72:SetMainUnitIndex(#arg0_72._subList)
end

function var8_0.FleetWarcry(arg0_73)
	local var0_73
	local var1_73 = math.random(0, 1)
	local var2_73 = arg0_73:GetScoutList()[1]
	local var3_73 = arg0_73:GetMainList()[1]

	if var3_73 == nil or var1_73 == 0 then
		var0_73 = var2_73
	elseif var1_73 == 1 then
		var0_73 = var3_73
	end

	local var4_73 = "battle"
	local var5_73 = var0_73:GetIntimacy()
	local var6_73 = var0_0.Battle.BattleDataFunction.GetWords(var0_73:GetSkinID(), var4_73, var5_73)

	var0_73:DispatchVoice(var4_73)
	var0_73:DispatchChat(var6_73, 2.5, var4_73)
end

function var8_0.FleetUnitSpwanFinish(arg0_74)
	local var0_74 = 0

	for iter0_74, iter1_74 in ipairs(arg0_74._unitList) do
		var0_74 = var0_74 + iter1_74:GetGearScore()
	end

	for iter2_74, iter3_74 in ipairs(arg0_74._unitList) do
		var6_0.SetCurrent(iter3_74, "fleetGS", var0_74)
	end
end

function var8_0.SubWarcry(arg0_75)
	local var0_75 = arg0_75:GetSubList()[1]
	local var1_75 = "battle"
	local var2_75 = var0_75:GetIntimacy()
	local var3_75 = var0_0.Battle.BattleDataFunction.GetWords(var0_75:GetSkinID(), var1_75, var2_75)

	var0_75:DispatchVoice(var1_75)
	var0_75:DispatchChat(var3_75, 2.5, var1_75)
end

function var8_0.SetWeaponBlock(arg0_76, arg1_76)
	arg0_76._blockCast = arg0_76._blockCast + arg1_76
end

function var8_0.GetWeaponBlock(arg0_77)
	return arg0_77._blockCast > 0
end

function var8_0.CastChargeWeapon(arg0_78)
	if arg0_78:GetWeaponBlock() then
		return
	end

	local var0_78 = arg0_78._chargeWeaponVO:GetCurrentWeapon()

	if var0_78 ~= nil and var0_78:GetCurrentState() == var0_78.STATE_READY then
		var0_78:Charge()

		local var1_78 = {}
		local var2_78 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.POINT_HIT_CHARGE, var1_78)

		arg0_78:DispatchEvent(var2_78)
	end
end

function var8_0.CancelChargeWeapon(arg0_79)
	local var0_79 = arg0_79._chargeWeaponVO:GetCurrentWeapon()

	if var0_79 ~= nil and var0_79:GetCurrentState() == var0_79.STATE_PRECAST then
		local var1_79 = {}
		local var2_79 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.POINT_HIT_CANCEL, var1_79)

		arg0_79:DispatchEvent(var2_79)
		var0_79:CancelCharge()
	end
end

function var8_0.UnleashChrageWeapon(arg0_80)
	if arg0_80:GetWeaponBlock() then
		arg0_80:CancelChargeWeapon()

		return
	end

	local var0_80 = arg0_80._chargeWeaponVO:GetCurrentWeapon()

	if var0_80 ~= nil and var0_80:GetCurrentState() == var0_80.STATE_PRECAST then
		if var0_80:IsStrikeMode() then
			local var1_80 = arg0_80._motionVO:GetPos().x + var5_0.ChargeWeaponConfig.SIGHT_C
			local var2_80 = math.min(var1_80, arg0_80._totalRightBound)

			arg0_80:fireChargeWeapon(var0_80, true, Vector3.New(var2_80, 0, arg0_80._motionVO:GetPos().z))
		else
			var0_80:CancelCharge()
		end

		local var3_80 = {}
		local var4_80 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.POINT_HIT_CANCEL, var3_80)

		arg0_80:DispatchEvent(var4_80)
	end
end

function var8_0.QuickTagChrageWeapon(arg0_81, arg1_81)
	if arg0_81:GetWeaponBlock() then
		return
	end

	local var0_81
	local var1_81 = arg0_81._chargeWeaponVO:GetCurrentWeapon()

	if var1_81 ~= nil and var1_81:GetCurrentState() == var1_81.STATE_READY then
		var1_81:QuickTag()

		if #var1_81:GetLockList() <= 0 then
			var1_81:CancelQuickTag()
		else
			var0_81 = arg0_81:fireChargeWeapon(var1_81, arg1_81)
		end
	end

	return var0_81
end

function var8_0.fireChargeWeapon(arg0_82, arg1_82, arg2_82, arg3_82)
	local var0_82 = arg1_82:GetHost()

	local function var1_82()
		local function var0_83()
			arg1_82:Fire(arg3_82)
		end

		arg1_82:DispatchBlink(var0_83)
	end

	if arg1_82:GetType() == var4_0.EquipmentType.POINT_AIR_STRIKE then
		arg1_82:Fire(arg3_82)
	elseif arg2_82 then
		if arg0_82._IFF == var5_0.FRIENDLY_CODE then
			arg0_82._chargeWeaponVO:PlayCutIn(var0_82, 1 / var5_0.FOCUS_MAP_RATE)
		end

		arg0_82._chargeWeaponVO:PlayFocus(var0_82, var1_82)
	else
		if arg0_82._IFF == var5_0.FRIENDLY_CODE then
			arg0_82._chargeWeaponVO:PlayCutIn(var0_82, 1)
		end

		var1_82()
	end
end

function var8_0.UnleashAllInStrike(arg0_85)
	if arg0_85:GetWeaponBlock() then
		return
	end

	local var0_85
	local var1_85 = arg0_85._airAssistVO:GetCurrentWeapon()

	if var1_85 and var1_85:GetCurrentState() == var1_85.STATE_READY then
		local var2_85 = var1_85:GetHost()

		if arg0_85._IFF == var5_0.FRIENDLY_CODE and var2_85:IsMainFleetUnit() then
			arg0_85._airAssistVO:PlayCutIn(var2_85, 1)
		end

		var1_85:CLSBullet()
		var1_85:DispatchBlink()

		var0_85 = var1_85:Fire()
	end

	return var0_85
end

function var8_0.CastTorpedo(arg0_86)
	if arg0_86:GetWeaponBlock() then
		return
	end

	local var0_86 = arg0_86._torpedoWeaponVO:GetCurrentWeapon()

	if var0_86 ~= nil and var0_86:GetCurrentState() == var0_86.STATE_READY and var0_86:Prepar() then
		arg0_86:FleetBuffTrigger(var4_0.BuffEffectType.ON_TORPEDO_BUTTON_PUSH)
	end
end

function var8_0.CancelTorpedo(arg0_87)
	local var0_87 = arg0_87._torpedoWeaponVO:GetCurrentWeapon()

	if var0_87 ~= nil and var0_87:GetCurrentState() == var0_87.STATE_PRECAST then
		var0_87:Cancel()
	end
end

function var8_0.UnleashTorpedo(arg0_88)
	if arg0_88:GetWeaponBlock() then
		arg0_88:CancelTorpedo()

		return
	end

	local var0_88 = arg0_88._torpedoWeaponVO:GetCurrentWeapon()

	if var0_88 ~= nil and var0_88:GetCurrentState() == var0_88.STATE_PRECAST then
		var0_88:Fire()
	end
end

function var8_0.QuickCastTorpedo(arg0_89)
	if arg0_89:GetWeaponBlock() then
		return
	end

	local var0_89
	local var1_89 = arg0_89._torpedoWeaponVO:GetCurrentWeapon()

	if var1_89 ~= nil and var1_89:GetCurrentState() == var1_89.STATE_READY then
		var0_89 = var1_89:Fire(true)
	end

	return var0_89
end

function var8_0.RemoveManunalTorpedo(arg0_90, arg1_90, arg2_90)
	if arg1_90:IsAttacking() then
		arg0_90:CancelTorpedo()
	end

	arg0_90._torpedoWeaponVO:RemoveWeapon(arg1_90)

	if not arg2_90 then
		arg1_90:Clear()
	end
end

function var8_0.CoupleEncourage(arg0_91)
	local var0_91 = {}
	local var1_91 = {}

	for iter0_91, iter1_91 in ipairs(arg0_91._unitList) do
		local var2_91 = iter1_91:GetIntimacy()
		local var3_91 = var7_0.GetWords(iter1_91:GetSkinID(), "couple_encourage", var2_91)

		if #var3_91 > 0 then
			var0_91[iter1_91] = var3_91
		end
	end

	local var4_91 = var4_0.CPChatType
	local var5_91 = var4_0.CPChatTargetFunc

	local function var6_91(arg0_92, arg1_92)
		local var0_92 = {}

		if arg0_92 == var4_91.GROUP_ID then
			var0_92.groupIDList = arg1_92
		elseif arg0_92 == var4_91.SHIP_TYPE then
			var0_92.ship_type_list = arg1_92
		elseif arg0_92 == var4_91.RARE then
			var0_92.rarity = arg1_92[1]
		elseif arg0_92 == var4_91.NATIONALITY then
			var0_92.nationality = arg1_92[1]
		elseif arg0_92 == var4_91.ILLUSTRATOR then
			var0_92.illustrator = arg1_92[1]
		elseif arg0_92 == var4_91.TEAM then
			var0_92.teamIndex = arg1_92[1]
		end

		return var0_92
	end

	for iter2_91, iter3_91 in pairs(var0_91) do
		for iter4_91, iter5_91 in ipairs(iter3_91) do
			local var7_91 = iter5_91[1]
			local var8_91 = iter5_91[2]
			local var9_91 = iter5_91[4] or var4_91.GROUP_ID
			local var10_91 = var0_0.Battle.BattleTargetChoise.TargetAllHelp(iter2_91)

			if type(var9_91) == "table" then
				for iter6_91, iter7_91 in ipairs(var9_91) do
					local var11_91 = var6_91(iter7_91, var7_91[iter6_91])

					var10_91 = var0_0.Battle.BattleTargetChoise[var5_91[iter7_91]](iter2_91, var11_91, var10_91)
				end
			elseif type(var9_91) == "number" then
				local var12_91 = var6_91(var9_91, var7_91)

				var10_91 = var0_0.Battle.BattleTargetChoise[var5_91[var9_91]](iter2_91, var12_91, var10_91)
			end

			if var8_91 <= #var10_91 then
				local var13_91 = {
					cp = iter2_91,
					content = iter5_91[3],
					linkIndex = iter4_91
				}

				var1_91[#var1_91 + 1] = var13_91
			end
		end
	end

	if #var1_91 > 0 then
		local var14_91 = var1_91[math.random(#var1_91)]
		local var15_91 = "link" .. var14_91.linkIndex

		var14_91.cp:DispatchVoice(var15_91)
		var14_91.cp:DispatchChat(var14_91.content, 3, var15_91)
	end
end

function var8_0.onUnitUpdateHP(arg0_93, arg1_93)
	local var0_93 = arg1_93.Dispatcher
	local var1_93 = arg1_93.Data.dHP

	for iter0_93, iter1_93 in ipairs(arg0_93._unitList) do
		iter1_93:TriggerBuff(var4_0.BuffEffectType.ON_FRIENDLY_HP_RATIO_UPDATE, {
			unit = var0_93,
			dHP = var1_93
		})

		if iter1_93 ~= var0_93 then
			iter1_93:TriggerBuff(var4_0.BuffEffectType.ON_TEAMMATE_HP_RATIO_UPDATE, {
				unit = var0_93,
				dHP = var1_93
			})
		end
	end
end

function var8_0.onUnitCloakUpdate(arg0_94, arg1_94)
	local var0_94 = arg1_94.Dispatcher
	local var1_94 = var6_0.GetCurrent(var0_94, "isCloak")

	for iter0_94, iter1_94 in ipairs(arg0_94._unitList) do
		iter1_94:TriggerBuff(var4_0.BuffEffectType.ON_CLOAK_UPDATE, {
			cloakState = var1_94
		})

		if iter1_94 ~= var0_94 then
			iter1_94:TriggerBuff(var4_0.BuffEffectType.ON_TEAMMATE_CLOAK_UPDATE, {
				cloakState = var1_94
			})
		end
	end
end

function var8_0.SetSubUnitData(arg0_95, arg1_95)
	arg0_95._subUntiDataList = arg1_95
end

function var8_0.GetSubUnitData(arg0_96)
	return arg0_96._subUntiDataList
end

function var8_0.AddSubMarine(arg0_97, arg1_97)
	arg1_97:InitOxygen()

	local var0_97 = arg1_97:GetTemplate()
	local var1_97 = var0_0.Battle.BattleUnitPhaseSwitcher.New(arg1_97)

	local function var2_97()
		return arg1_97:GetRaidDuration()
	end

	local var3_97 = arg0_97._fixedSubRefLine or arg0_97._subAttackBaseLine

	var1_97:SetTemplateData(var7_0.GeneratePlayerSubmarinPhase(var3_97, arg0_97._subRetreatBaseLine, arg1_97:GetAttrByName("raidDist"), var2_97, arg1_97:GetAttrByName("oxyAtkDuration")))

	arg0_97._unitList[#arg0_97._unitList + 1] = arg1_97
	arg0_97._subList[#arg0_97._subList + 1] = arg1_97

	arg1_97:SetFleetVO(arg0_97)
	arg1_97:RegisterEventListener(arg0_97, var1_0.UPDATE_HP, arg0_97.onUnitUpdateHP)
	arg1_97:RegisterEventListener(arg0_97, var1_0.UPDATE_CLOAK_STATE, arg0_97.onUnitCloakUpdate)
end

function var8_0.AddManualSubmarine(arg0_99, arg1_99)
	arg0_99._unitList[#arg0_99._unitList + 1] = arg1_99
	arg0_99._manualSubList[#arg0_99._manualSubList + 1] = arg1_99
	arg0_99._manualSubBench[#arg0_99._manualSubBench + 1] = arg1_99
	arg0_99._maxCount = arg0_99._maxCount + 1

	arg1_99:InitOxygen()
	arg1_99:SetFleetVO(arg0_99)
	arg1_99:SetMotion(arg0_99._motionVO)
	arg1_99:RegisterEventListener(arg0_99, var1_0.UPDATE_HP, arg0_99.onUnitUpdateHP)
	arg1_99:RegisterEventListener(arg0_99, var1_0.UPDATE_CLOAK_STATE, arg0_99.onUnitCloakUpdate)
end

function var8_0.GetSubList(arg0_100)
	return arg0_100._subList
end

function var8_0.ShiftManualSub(arg0_101)
	local var0_101

	if arg0_101._manualSubUnit then
		local var1_101 = arg0_101._manualSubUnit:GetTorpedoList()

		for iter0_101, iter1_101 in ipairs(var1_101) do
			if iter1_101:IsAttacking() then
				arg0_101:CancelTorpedo()
			end

			arg0_101._torpedoWeaponVO:RemoveWeapon(iter1_101)
		end

		if arg0_101._manualSubUnit:IsAlive() then
			table.insert(arg0_101._manualSubBench, arg0_101._manualSubUnit)
		end

		var0_101 = arg0_101._motionVO:GetPos():Clone()
	else
		var0_101 = arg0_101._manualSubList[1]:GetPosition():Clone()
	end

	arg0_101._manualSubUnit = table.remove(arg0_101._manualSubBench, 1)
	arg0_101._scoutList[1] = arg0_101._manualSubUnit

	local var2_101 = {}

	for iter2_101, iter3_101 in ipairs(arg0_101._manualSubBench) do
		for iter4_101, iter5_101 in ipairs(arg0_101._unitList) do
			if iter5_101 == iter3_101 then
				table.insert(var2_101, iter4_101)

				break
			end
		end
	end

	for iter6_101, iter7_101 in ipairs(arg0_101._unitList) do
		if iter7_101 == arg0_101._manualSubUnit then
			table.insert(var2_101, 1, iter6_101)

			break
		end
	end

	arg0_101:refreshFleetFormation(var2_101)
	arg0_101._manualSubUnit:SetMainUnitStatic(false)
	arg0_101._manualSubUnit:SetPosition(var0_101)
	arg0_101:UpdateMotion()
	arg0_101._submarineSpecialVO:SetUseable(false)

	local var3_101 = arg0_101._manualSubUnit:GetBuffList()

	for iter8_101, iter9_101 in pairs(var3_101) do
		if iter9_101:IsSubmarineSpecial() then
			arg0_101._submarineSpecialVO:SetCount(1)
			arg0_101._submarineSpecialVO:SetUseable(true)

			break
		end
	end

	arg0_101:ChangeSubmarineState(var0_0.Battle.OxyState.STATE_FREE_DIVE)
	arg0_101._torpedoWeaponVO:Reset()

	local var4_101 = arg0_101._manualSubUnit:GetTorpedoList()

	for iter10_101, iter11_101 in ipairs(var4_101) do
		if iter11_101:GetCurrentState() ~= iter11_101.STATE_OVER_HEAT then
			arg0_101._torpedoWeaponVO:AppendWeapon(iter11_101)
		end
	end

	for iter12_101, iter13_101 in ipairs(var4_101) do
		if iter13_101:GetCurrentState() == iter13_101.STATE_OVER_HEAT then
			arg0_101._torpedoWeaponVO:AppendWeapon(iter13_101)
		end
	end

	if var6_0.GetCurrent(arg0_101._manualSubUnit, "oxyMax") <= 0 then
		arg0_101._submarineDiveVO:SetActive(false)
		arg0_101._submarineFloatVO:SetActive(false)
	else
		arg0_101._submarineDiveVO:SetActive(true)
		arg0_101._submarineFloatVO:SetActive(true)
	end

	for iter14_101, iter15_101 in ipairs(arg0_101._manualSubBench) do
		iter15_101:SetPosition(var5_0.SUB_BENCH_POS[iter14_101])
		iter15_101:SetMainUnitStatic(true)
		iter15_101:ChangeOxygenState(var0_0.Battle.OxyState.STATE_FREE_BENCH)
	end

	arg0_101._submarineShiftVO:ResetCurrent()

	if #arg0_101._manualSubBench == 0 then
		arg0_101._submarineShiftVO:SetActive(false)
	end
end

function var8_0.ChangeSubmarineState(arg0_102, arg1_102, arg2_102)
	if not arg0_102._manualSubUnit then
		return
	end

	arg0_102._manualSubUnit:ChangeOxygenState(arg1_102)

	if arg2_102 then
		for iter0_102, iter1_102 in ipairs(arg0_102._submarineVOList) do
			iter1_102:ResetCurrent()
		end

		local var0_102 = arg0_102._submarineShiftVO:GetMax() - arg0_102._submarineShiftVO:GetCurrent()

		if arg0_102._submarineShiftVO:IsOverLoad() and var0_102 > var5_0.SR_CONFIG.DIVE_CD then
			-- block empty
		else
			arg0_102._submarineShiftVO:SetMax(var5_0.SR_CONFIG.DIVE_CD)
			arg0_102._submarineShiftVO:ResetCurrent()
		end
	end

	arg0_102:DispatchEvent(var0_0.Event.New(var2_0.MANUAL_SUBMARINE_SHIFT, {
		state = arg1_102
	}))
end

function var8_0.SubmarinBoost(arg0_103)
	arg0_103._manualSubUnit:Boost(Vector3.right, var5_0.SR_CONFIG.BOOST_SPEED, var5_0.SR_CONFIG.BOOST_DECAY, var5_0.SR_CONFIG.BOOST_DURATION, var5_0.SR_CONFIG.BOOST_DECAY_STAMP)
	arg0_103._submarineBoostVO:ResetCurrent()
end

function var8_0.UnleashSubmarineSpecial(arg0_104)
	if arg0_104:GetWeaponBlock() then
		return
	end

	arg0_104._submarineSpecialVO:Cast()
	arg0_104._manualSubUnit:TriggerBuff(var4_0.BuffEffectType.ON_SUBMARINE_FREE_SPECIAL)
end

function var8_0.FixSubRefLine(arg0_105, arg1_105)
	arg0_105._fixedSubRefLine = arg1_105
end

function var8_0.AppendIndieSonar(arg0_106, arg1_106, arg2_106)
	if not arg0_106._motionReferenceUnit then
		return
	end

	local var0_106 = var0_0.Battle.BattleIndieSonar.New(arg0_106, arg1_106, arg2_106)

	var0_106:SwitchHost(arg0_106._motionReferenceUnit)

	arg0_106._indieSonarList[var0_106] = true

	var0_106:Detect()
end

function var8_0.RemoveIndieSonar(arg0_107, arg1_107)
	for iter0_107, iter1_107 in pairs(arg0_107._indieSonarList) do
		if arg1_107 == iter0_107 then
			arg0_107._indieSonarList[iter0_107] = nil

			break
		end
	end
end

function var8_0.AttachFleetBuff(arg0_108, arg1_108)
	local var0_108 = arg1_108:GetID()
	local var1_108 = arg0_108:GetFleetBuff(var0_108)

	if var1_108 then
		var1_108:Stack(arg0_108)
	else
		arg0_108._buffList[var0_108] = arg1_108

		arg1_108:Attach(arg0_108)
	end
end

function var8_0.RemoveFleetBuff(arg0_109, arg1_109)
	local var0_109 = arg0_109:GetFleetBuff(arg1_109)

	if var0_109 then
		var0_109:Remove()
	end
end

function var8_0.GetFleetBuff(arg0_110, arg1_110)
	return arg0_110._buffList[arg1_110]
end

function var8_0.GetFleetBuffList(arg0_111)
	return arg0_111._buffList
end

function var8_0.AttachFleetAttr(arg0_112)
	arg0_112._fleetAttr = var0_0.Battle.BattleFleetAttrComponent.New(arg0_112)
end

function var8_0.GetFleetAttr(arg0_113)
	return arg0_113._fleetAttr
end

function var8_0.Jamming(arg0_114, arg1_114)
	if arg1_114 then
		arg0_114._chargeWeaponVO:StartJamming()
		arg0_114._torpedoWeaponVO:StartJamming()
		arg0_114._airAssistVO:StartJamming()
	else
		arg0_114._chargeWeaponVO:JammingEliminate()
		arg0_114._torpedoWeaponVO:JammingEliminate()
		arg0_114._airAssistVO:JammingEliminate()
	end
end

function var8_0.Blinding(arg0_115, arg1_115)
	arg0_115:DispatchEvent(var0_0.Event.New(var2_0.FLEET_BLIND, {
		isBlind = arg1_115
	}))
end

function var8_0.UpdateHorizon(arg0_116)
	arg0_116:DispatchEvent(var0_0.Event.New(var2_0.FLEET_HORIZON_UPDATE, {}))
end

function var8_0.AutoBotUpdated(arg0_117, arg1_117)
	local var0_117 = arg1_117 and var4_0.BuffEffectType.ON_AUTOBOT or var4_0.BuffEffectType.ON_MANUAL

	arg0_117:FleetBuffTrigger(var0_117)
end

function var8_0.CloakFatalExpose(arg0_118)
	for iter0_118, iter1_118 in ipairs(arg0_118._cloakList) do
		iter1_118:GetCloak():ForceToMax()
	end
end

function var8_0.CloakInVision(arg0_119, arg1_119)
	for iter0_119, iter1_119 in ipairs(arg0_119._cloakList) do
		iter1_119:GetCloak():AppendExposeSpeed(arg1_119)
	end
end

function var8_0.CloakOutVision(arg0_120)
	for iter0_120, iter1_120 in ipairs(arg0_120._cloakList) do
		iter1_120:GetCloak():AppendExposeSpeed(0)
	end
end

function var8_0.AttachCloak(arg0_121, arg1_121)
	if not arg1_121:GetCloak() then
		arg1_121:InitCloak()

		arg0_121._cloakList[#arg0_121._cloakList + 1] = arg1_121
	end
end

function var8_0.AttachNightCloak(arg0_122)
	arg0_122._scoutAimBias = var0_0.Battle.BattleUnitAimBiasComponent.New()

	arg0_122._scoutAimBias:ConfigRangeFormula(var3_0.CalculateMaxAimBiasRange, var3_0.CalculateBiasDecay)
	arg0_122._scoutAimBias:Active(arg0_122._scoutAimBias.STATE_ACTIVITING)
	arg0_122:DispatchEvent(var0_0.Event.New(var2_0.ADD_AIM_BIAS, {
		aimBias = arg0_122._scoutAimBias
	}))
end

function var8_0.GetFleetBias(arg0_123)
	return arg0_123._scoutAimBias
end

function var8_0.FreezeUnit(arg0_124, arg1_124)
	arg0_124:RemovePlayerUnit(arg1_124, true)

	arg0_124._freezeList[arg1_124] = true
end

function var8_0.ActiveFreezeUnit(arg0_125, arg1_125)
	arg0_125._freezeList[arg1_125] = nil
	arg0_125._unitList[#arg0_125._unitList + 1] = arg1_125
	arg0_125._maxCount = arg0_125._maxCount + 1

	if arg1_125:IsMainFleetUnit() then
		arg0_125:appendFreezeMainUnit(arg1_125)
	else
		arg0_125:activeFreezeScoutUnit(arg1_125)
	end

	arg1_125:SetFleetVO(arg0_125)
	arg1_125:SetMotion(arg0_125._motionVO)
	arg1_125:RegisterEventListener(arg0_125, var1_0.UPDATE_HP, arg0_125.onUnitUpdateHP)
	arg1_125:RegisterEventListener(arg0_125, var1_0.UPDATE_CLOAK_STATE, arg0_125.onUnitCloakUpdate)
end

function var8_0.UndoFusion(arg0_126)
	for iter0_126, iter1_126 in pairs(arg0_126._freezeList) do
		arg0_126._unitList[#arg0_126._unitList + 1] = iter0_126
		arg0_126._maxCount = arg0_126._maxCount + 1

		if iter0_126:IsMainFleetUnit() then
			arg0_126:appendFreezeMainUnit(iter0_126)
		else
			arg0_126:activeFreezeScoutUnit(iter0_126)
		end
	end

	local var0_126 = {}

	for iter2_126, iter3_126 in ipairs(arg0_126._unitList) do
		local var1_126 = iter3_126:GetAttrByName("hpProvideRate")

		if var1_126 ~= 0 then
			table.insert(var0_126, iter3_126)

			local var2_126, var3_126 = iter3_126:GetHP()
			local var4_126 = var3_126 - var2_126
			local var5_126 = 0

			for iter4_126, iter5_126 in pairs(var1_126) do
				local var6_126 = arg0_126:GetFreezeShipByID(iter4_126)

				if not var6_126 then
					arg0_126:GetShipByID(iter4_126)
				end

				local var7_126 = math.floor(iter5_126 * var4_126)

				var6_126:UpdateHP(var7_126 * -1, {})
			end
		end
	end

	for iter6_126, iter7_126 in ipairs(var0_126) do
		arg0_126:RemovePlayerUnit(iter7_126)
	end
end

function var8_0.appendFreezeMainUnit(arg0_127, arg1_127)
	arg0_127._mainList[#arg0_127._mainList + 1] = arg1_127

	arg1_127:SetMainUnitIndex(#arg0_127._mainList)

	if ShipType.CloakShipType(arg1_127:GetTemplate().type) then
		table.insert(arg0_127._cloakList, arg1_127)
	end

	local var0_127 = arg1_127:GetChargeList()

	for iter0_127, iter1_127 in ipairs(var0_127) do
		arg0_127._chargeWeaponVO:AppendFreezeWeapon(iter1_127)
	end

	local var1_127 = arg1_127:GetTorpedoList()

	for iter2_127, iter3_127 in ipairs(var1_127) do
		arg0_127._torpedoWeaponVO:AppendFreezeWeapon(iter3_127)
	end

	if arg1_127:GetAirAssistList() then
		local var2_127 = arg1_127:GetAirAssistList()

		for iter4_127, iter5_127 in ipairs(var2_127) do
			arg0_127._airAssistVO:AppendFreezeWeapon(iter5_127)
		end
	end

	arg0_127._fleetAntiAir:AppendCrewUnit(arg1_127)
	arg0_127._fleetRangeAntiAir:AppendCrewUnit(arg1_127)
	arg0_127._fleetStaticSonar:AppendCrewUnit(arg1_127)

	local var3_127 = {}

	for iter6_127, iter7_127 in ipairs(arg0_127._unitList) do
		table.insert(var3_127, iter6_127)
	end

	arg0_127:refreshFleetFormation(var3_127)
end

function var8_0.activeFreezeScoutUnit(arg0_128, arg1_128)
	arg0_128._scoutList[#arg0_128._scoutList + 1] = arg1_128

	local var0_128 = arg1_128:GetTorpedoList()

	for iter0_128, iter1_128 in ipairs(var0_128) do
		arg0_128._torpedoWeaponVO:AppendFreezeWeapon(iter1_128)
	end

	if arg1_128:GetAirAssistList() then
		local var1_128 = arg1_128:GetAirAssistList()

		for iter2_128, iter3_128 in ipairs(var1_128) do
			arg0_128._airAssistVO:AppendFreezeWeapon(iter3_128)
		end
	end

	arg0_128._fleetAntiAir:AppendCrewUnit(arg1_128)
	arg0_128._fleetStaticSonar:AppendCrewUnit(arg1_128)

	local var2_128 = 1
	local var3_128 = #arg0_128._unitList
	local var4_128 = {}

	while var2_128 < var3_128 do
		table.insert(var4_128, var2_128)

		var2_128 = var2_128 + 1
	end

	table.insert(var4_128, #arg0_128._scoutList, var2_128)
	arg0_128:refreshFleetFormation(var4_128)
end

function var8_0.AttachCardPuzzleComponent(arg0_129)
	arg0_129._cardPuzzleComponent = var0_0.Battle.BattleFleetCardPuzzleComponent.New(arg0_129)

	return arg0_129._cardPuzzleComponent
end

function var8_0.GetCardPuzzleComponent(arg0_130)
	return arg0_130._cardPuzzleComponent
end

function var8_0.AppendSupportUnit(arg0_131, arg1_131)
	arg0_131._supportList[#arg0_131._supportList + 1] = arg1_131
end

function var8_0.GetSupportUnitList(arg0_132)
	return arg0_132._supportList
end
