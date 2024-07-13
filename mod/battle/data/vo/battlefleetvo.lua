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

function var8_0.UpdateScoutUnitBound(arg0_20)
	local var0_20, var1_20, var2_20, var3_20, var4_20, var5_20 = arg0_20._fleetUnitBound:GetBound()

	for iter0_20, iter1_20 in ipairs(arg0_20._scoutList) do
		iter1_20:SetBound(var0_20, var1_20, var2_20, var3_20, var4_20, var5_20)
	end

	for iter2_20, iter3_20 in pairs(arg0_20._freezeList) do
		if not iter2_20:IsMainFleetUnit() then
			iter2_20:SetBound(var0_20, var1_20, var2_20, var3_20, var4_20, var5_20)
		end
	end
end

function var8_0.CalcSubmarineBaseLine(arg0_21, arg1_21)
	local var0_21 = (arg0_21._totalRightBound + arg0_21._totalLeftBound) * 0.5

	if arg0_21._IFF == var5_0.FRIENDLY_CODE then
		if arg1_21 == SYSTEM_DUEL then
			-- block empty
		else
			arg0_21._subAttackBaseLine = var0_21
			arg0_21._subRetreatBaseLine = arg0_21._leftBound - 10
		end
	elseif arg0_21._IFF == var5_0.FOE_CODE and arg1_21 == SYSTEM_DUEL then
		-- block empty
	end
end

function var8_0.SetExposeLine(arg0_22, arg1_22, arg2_22)
	arg0_22._visionLineX = arg1_22
	arg0_22._exposeLineX = arg2_22
end

function var8_0.AppendPlayerUnit(arg0_23, arg1_23)
	arg0_23._unitList[#arg0_23._unitList + 1] = arg1_23
	arg0_23._maxCount = arg0_23._maxCount + 1

	if arg1_23:IsMainFleetUnit() then
		arg0_23:appendMainUnit(arg1_23)
	else
		arg0_23:appendScoutUnit(arg1_23)
	end

	arg1_23:SetFleetVO(arg0_23)
	arg1_23:SetMotion(arg0_23._motionVO)
	arg1_23:RegisterEventListener(arg0_23, var1_0.UPDATE_HP, arg0_23.onUnitUpdateHP)
	arg1_23:RegisterEventListener(arg0_23, var1_0.UPDATE_CLOAK_STATE, arg0_23.onUnitCloakUpdate)

	if arg0_23._cardPuzzleComponent then
		arg0_23._cardPuzzleComponent:AppendUnit(arg1_23)
	end
end

function var8_0.RemovePlayerUnit(arg0_24, arg1_24, arg2_24)
	arg0_24._freezeList[arg1_24] = nil

	local var0_24 = {}

	for iter0_24, iter1_24 in ipairs(arg0_24._unitList) do
		if iter1_24 ~= arg1_24 then
			var0_24[#var0_24 + 1] = iter0_24
		else
			if not arg2_24 then
				iter1_24:UnregisterEventListener(arg0_24, var1_0.UPDATE_HP)
				iter1_24:UnregisterEventListener(arg0_24, var1_0.UPDATE_CLOAK_STATE)
				iter1_24:DeactiveCldBox()
			end

			local var1_24 = iter1_24:GetChargeList()

			for iter2_24, iter3_24 in ipairs(var1_24) do
				if iter3_24:IsAttacking() then
					arg0_24._chargeWeaponVO:CancelFocus()
					arg0_24._chargeWeaponVO:ResetFocus()
					arg0_24:CancelChargeWeapon()
				end

				arg0_24._chargeWeaponVO:RemoveWeapon(iter3_24)

				if not arg2_24 then
					iter3_24:Clear()
				end
			end

			arg0_24._fleetAntiAir:RemoveCrewUnit(arg1_24)
			arg0_24._fleetRangeAntiAir:RemoveCrewUnit(arg1_24)
			arg0_24._fleetStaticSonar:RemoveCrewUnit(arg1_24)

			local var2_24 = iter1_24:GetTorpedoList()

			for iter4_24, iter5_24 in ipairs(var2_24) do
				arg0_24:RemoveManunalTorpedo(iter5_24, arg2_24)
			end

			local var3_24 = iter1_24:GetAirAssistList()

			if var3_24 then
				for iter6_24, iter7_24 in ipairs(var3_24) do
					arg0_24._airAssistVO:RemoveWeapon(iter7_24)
				end
			end
		end
	end

	for iter8_24, iter9_24 in ipairs(arg0_24._scoutList) do
		if iter9_24 == arg1_24 then
			if #arg0_24._scoutList == 1 then
				arg0_24:CancelChargeWeapon()
			end

			table.remove(arg0_24._scoutList, iter8_24)

			break
		end
	end

	local function var4_24(arg0_25)
		for iter0_25, iter1_25 in ipairs(arg0_25) do
			if iter1_25 == arg1_24 then
				table.remove(arg0_25, iter0_25)

				break
			end
		end
	end

	var4_24(arg0_24._mainList)
	var4_24(arg0_24._cloakList)
	var4_24(arg0_24._subList)
	var4_24(arg0_24._manualSubList)

	if not arg0_24._manualSubUnit then
		arg0_24:refreshFleetFormation(var0_24)
	end
end

function var8_0.OverrideJoyStickAutoBot(arg0_26, arg1_26)
	arg0_26._autoBotAIID = arg1_26

	local var0_26 = var0_0.Event.New(var0_0.Battle.BattleEvent.OVERRIDE_AUTO_BOT)

	arg0_26:DispatchEvent(var0_26)
end

function var8_0.SnapShot(arg0_27)
	arg0_27._totalDMGRatio = var3_0.GetFleetTotalHP(arg0_27)
	arg0_27._currentDMGRatio = arg0_27._totalDMGRatio
end

function var8_0.GetIFF(arg0_28)
	return arg0_28._IFF
end

function var8_0.GetMaxCount(arg0_29)
	return arg0_29._maxCount
end

function var8_0.GetFlagShip(arg0_30)
	return arg0_30._flagShip
end

function var8_0.GetLeaderShip(arg0_31)
	return arg0_31._scoutList[1]
end

function var8_0.GetUnitList(arg0_32)
	return arg0_32._unitList
end

function var8_0.GetFreezeUnitList(arg0_33)
	return arg0_33._freezeList
end

function var8_0.GetMainList(arg0_34)
	return arg0_34._mainList
end

function var8_0.GetScoutList(arg0_35)
	return arg0_35._scoutList
end

function var8_0.GetFreezeShipByID(arg0_36, arg1_36)
	for iter0_36, iter1_36 in pairs(arg0_36._freezeList) do
		if arg1_36 == iter0_36:GetAttrByName("id") then
			return iter0_36
		end
	end
end

function var8_0.GetShipByID(arg0_37, arg1_37)
	for iter0_37, iter1_37 in ipairs(arg0_37._unitList) do
		if arg1_37 == iter1_37:GetAttrByName("id") then
			return iter1_37
		end
	end
end

function var8_0.GetCloakList(arg0_38)
	return arg0_38._cloakList
end

function var8_0.GetSubBench(arg0_39)
	return arg0_39._manualSubBench
end

function var8_0.GetUnitBound(arg0_40)
	return arg0_40._fleetUnitBound
end

function var8_0.GetMotion(arg0_41)
	return arg0_41._motionVO
end

function var8_0.GetMotionReferenceUnit(arg0_42)
	return arg0_42._motionReferenceUnit
end

function var8_0.GetAutoBotAIID(arg0_43)
	return arg0_43._autoBotAIID
end

function var8_0.GetChargeWeaponVO(arg0_44)
	return arg0_44._chargeWeaponVO
end

function var8_0.GetTorpedoWeaponVO(arg0_45)
	return arg0_45._torpedoWeaponVO
end

function var8_0.GetAirAssistVO(arg0_46)
	return arg0_46._airAssistVO
end

function var8_0.GetSubAidVO(arg0_47)
	return arg0_47._submarineVO
end

function var8_0.GetSubFreeDiveVO(arg0_48)
	return arg0_48._submarineDiveVO
end

function var8_0.GetSubFreeFloatVO(arg0_49)
	return arg0_49._submarineFloatVO
end

function var8_0.GetSubBoostVO(arg0_50)
	return arg0_50._submarineBoostVO
end

function var8_0.GetSubSpecialVO(arg0_51)
	return arg0_51._submarineSpecialVO
end

function var8_0.GetSubShiftVO(arg0_52)
	return arg0_52._submarineShiftVO
end

function var8_0.GetFleetAntiAirWeapon(arg0_53)
	return arg0_53._fleetAntiAir
end

function var8_0.GetFleetRangeAntiAirWeapon(arg0_54)
	return arg0_54._fleetRangeAntiAir
end

function var8_0.GetFleetVelocity(arg0_55)
	return var3_0.GetFleetVelocity(arg0_55._scoutList)
end

function var8_0.GetFleetBound(arg0_56)
	return arg0_56._upperBound, arg0_56._lowerBound, arg0_56._leftBound, arg0_56._rightBound
end

function var8_0.GetFleetUnitBound(arg0_57)
	return arg0_57._totalUpperBound, arg0_57._totalLowerBound
end

function var8_0.GetFleetExposeLine(arg0_58)
	return arg0_58._exposeLineX
end

function var8_0.GetFleetVisionLine(arg0_59)
	return arg0_59._visionLineX
end

function var8_0.GetLeaderPersonality(arg0_60)
	return arg0_60._motionReferenceUnit:GetAutoPilotPreference()
end

function var8_0.GetDamageRatioResult(arg0_61)
	return string.format("%0.2f", arg0_61._currentDMGRatio / arg0_61._totalDMGRatio * 100), arg0_61._totalDMGRatio
end

function var8_0.GetDamageRatio(arg0_62)
	return arg0_62._currentDMGRatio / arg0_62._totalDMGRatio
end

function var8_0.GetSubmarineBaseLine(arg0_63)
	return arg0_63._fixedSubRefLine or arg0_63._subAttackBaseLine, arg0_63._subRetreatBaseLine
end

function var8_0.GetFleetSonar(arg0_64)
	return arg0_64._fleetStaticSonar
end

function var8_0.Dispose(arg0_65)
	var0_0.EventDispatcher.DetachEventDispatcher(arg0_65)
	var0_0.EventListener.DetachEventListener(arg0_65)

	arg0_65._leaderUnit = nil

	arg0_65._fleetAntiAir:Dispose()
	arg0_65._fleetRangeAntiAir:Dispose()
	arg0_65._fleetStaticSonar:Dispose()

	arg0_65._fleetStaticSonar = nil
	arg0_65._buffList = nil
	arg0_65._indieSonarList = nil
	arg0_65._scoutAimBias = nil

	arg0_65._fleetAttr:Dispose()

	arg0_65._fleetAttr = nil
	arg0_65._freezeList = nil
end

function var8_0.refreshFleetFormation(arg0_66, arg1_66)
	local var0_66 = var7_0.GetFormationTmpDataFromID(var5_0.FORMATION_ID).pos_offset

	arg0_66._unitList = var7_0.SortFleetList(arg1_66, arg0_66._unitList)

	local var1_66 = var5_0.BornOffset

	if not arg0_66._mainUnitFree then
		for iter0_66, iter1_66 in ipairs(arg0_66._unitList) do
			if not table.contains(arg0_66._subList, iter1_66) then
				local var2_66 = var0_66[iter0_66] or var0_66[#var0_66]

				iter1_66:UpdateFormationOffset(Vector3(var2_66.x, var2_66.y, var2_66.z) + var1_66 * (iter0_66 - 1))
			end
		end
	end

	if #arg0_66._scoutList > 0 then
		arg0_66._motionReferenceUnit = arg0_66._scoutList[1]
		arg0_66._leaderUnit = arg0_66._scoutList[1]

		arg0_66._leaderUnit:LeaderSetting()
		arg0_66._fleetAntiAir:SwitchHost(arg0_66._motionReferenceUnit)
		arg0_66._fleetStaticSonar:SwitchHost(arg0_66._motionReferenceUnit)

		for iter2_66, iter3_66 in pairs(arg0_66._indieSonarList) do
			iter2_66:SwitchHost(arg0_66._motionReferenceUnit)
		end

		arg0_66._motionVO:UpdatePos(arg0_66._motionReferenceUnit)
	elseif arg0_66._fleetAntiAir:GetCurrentState() ~= arg0_66._fleetAntiAir.STATE_DISABLE then
		local var3_66 = arg0_66._fleetAntiAir:GetCrewUnitList()

		for iter4_66, iter5_66 in pairs(var3_66) do
			arg0_66._motionReferenceUnit = iter4_66

			arg0_66._fleetAntiAir:SwitchHost(iter4_66)

			break
		end
	else
		arg0_66._motionReferenceUnit = arg0_66._mainList[1]
		arg0_66._leaderUnit = nil
	end

	if #arg0_66:GetUnitList() == 0 then
		return
	end

	local var4_66 = var0_0.Event.New(var0_0.Battle.BattleEvent.REFRESH_FLEET_FORMATION)

	arg0_66:DispatchEvent(var4_66)
end

function var8_0.init(arg0_67)
	arg0_67._chargeWeaponVO = var0_0.Battle.BattleChargeWeaponVO.New()
	arg0_67._torpedoWeaponVO = var0_0.Battle.BattleTorpedoWeaponVO.New()
	arg0_67._airAssistVO = var0_0.Battle.BattleAllInStrikeVO.New()
	arg0_67._submarineDiveVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.DIVE_CD)
	arg0_67._submarineFloatVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.FLOAT_CD)
	arg0_67._submarineVOList = {
		arg0_67._submarineDiveVO,
		arg0_67._submarineFloatVO
	}
	arg0_67._submarineBoostVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.BOOST_CD)
	arg0_67._submarineShiftVO = var0_0.Battle.BattleSubmarineFuncVO.New(var5_0.SR_CONFIG.SHIFT_CD)
	arg0_67._submarineSpecialVO = var0_0.Battle.BattleSubmarineAidVO.New()

	arg0_67._submarineSpecialVO:SetCount(1)
	arg0_67._submarineSpecialVO:SetTotal(1)

	arg0_67._fleetAntiAir = var0_0.Battle.BattleFleetAntiAirUnit.New()
	arg0_67._fleetRangeAntiAir = var0_0.Battle.BattleFleetRangeAntiAirUnit.New()
	arg0_67._motionVO = var0_0.Battle.BattleFleetMotionVO.New()
	arg0_67._fleetStaticSonar = var0_0.Battle.BattleFleetStaticSonar.New(arg0_67)
	arg0_67._indieSonarList = {}
	arg0_67._scoutList = {}
	arg0_67._mainList = {}
	arg0_67._subList = {}
	arg0_67._supportList = {}
	arg0_67._cloakList = {}
	arg0_67._manualSubList = {}
	arg0_67._manualSubBench = {}
	arg0_67._unitList = {}
	arg0_67._maxCount = 0
	arg0_67._freezeList = {}
	arg0_67._blockCast = 0
	arg0_67._buffList = {}

	arg0_67:AttachFleetAttr()
	arg0_67:SetMotionSource()
end

function var8_0.appendScoutUnit(arg0_68, arg1_68)
	arg0_68._scoutList[#arg0_68._scoutList + 1] = arg1_68

	local var0_68 = arg1_68:GetTorpedoList()

	for iter0_68, iter1_68 in ipairs(var0_68) do
		arg0_68._torpedoWeaponVO:AppendWeapon(iter1_68)
	end

	if #arg1_68:GetHiveList() > 0 then
		local var1_68 = var7_0.CreateAllInStrike(arg1_68)

		for iter2_68, iter3_68 in ipairs(var1_68) do
			arg0_68._airAssistVO:AppendWeapon(iter3_68)
		end

		arg1_68:SetAirAssistList(var1_68)
	end

	arg0_68._fleetAntiAir:AppendCrewUnit(arg1_68)
	arg0_68._fleetStaticSonar:AppendCrewUnit(arg1_68)

	local var2_68 = 1
	local var3_68 = #arg0_68._unitList
	local var4_68 = {}

	while var2_68 < var3_68 do
		table.insert(var4_68, var2_68)

		var2_68 = var2_68 + 1
	end

	table.insert(var4_68, #arg0_68._scoutList, var2_68)
	arg0_68:refreshFleetFormation(var4_68)
end

function var8_0.appendMainUnit(arg0_69, arg1_69)
	if #arg0_69._mainList == 0 then
		arg0_69._flagShip = arg1_69
	end

	arg0_69._mainList[#arg0_69._mainList + 1] = arg1_69

	arg1_69:SetMainUnitIndex(#arg0_69._mainList)

	if ShipType.CloakShipType(arg1_69:GetTemplate().type) then
		arg0_69:AttachCloak(arg1_69)
	end

	local var0_69 = arg1_69:GetChargeList()

	for iter0_69, iter1_69 in ipairs(var0_69) do
		arg0_69._chargeWeaponVO:AppendWeapon(iter1_69)
	end

	local var1_69 = arg1_69:GetTorpedoList()

	for iter2_69, iter3_69 in ipairs(var1_69) do
		arg0_69._torpedoWeaponVO:AppendWeapon(iter3_69)
	end

	if #arg1_69:GetHiveList() > 0 then
		local var2_69 = var7_0.CreateAllInStrike(arg1_69)

		for iter4_69, iter5_69 in ipairs(var2_69) do
			arg0_69._airAssistVO:AppendWeapon(iter5_69)
		end

		arg1_69:SetAirAssistList(var2_69)
	end

	arg0_69._fleetAntiAir:AppendCrewUnit(arg1_69)
	arg0_69._fleetRangeAntiAir:AppendCrewUnit(arg1_69)
	arg0_69._fleetStaticSonar:AppendCrewUnit(arg1_69)

	local var3_69 = {}

	for iter6_69, iter7_69 in ipairs(arg0_69._unitList) do
		table.insert(var3_69, iter6_69)
	end

	arg0_69:refreshFleetFormation(var3_69)
end

function var8_0.appendSubUnit(arg0_70, arg1_70)
	arg0_70._subList[#arg0_70._subList + 1] = arg1_70

	arg1_70:SetMainUnitIndex(#arg0_70._subList)
end

function var8_0.FleetWarcry(arg0_71)
	local var0_71
	local var1_71 = math.random(0, 1)
	local var2_71 = arg0_71:GetScoutList()[1]
	local var3_71 = arg0_71:GetMainList()[1]

	if var3_71 == nil or var1_71 == 0 then
		var0_71 = var2_71
	elseif var1_71 == 1 then
		var0_71 = var3_71
	end

	local var4_71 = "battle"
	local var5_71 = var0_71:GetIntimacy()
	local var6_71 = var0_0.Battle.BattleDataFunction.GetWords(var0_71:GetSkinID(), var4_71, var5_71)

	var0_71:DispatchVoice(var4_71)
	var0_71:DispatchChat(var6_71, 2.5, var4_71)
end

function var8_0.FleetUnitSpwanFinish(arg0_72)
	local var0_72 = 0

	for iter0_72, iter1_72 in ipairs(arg0_72._unitList) do
		var0_72 = var0_72 + iter1_72:GetGearScore()
	end

	for iter2_72, iter3_72 in ipairs(arg0_72._unitList) do
		var6_0.SetCurrent(iter3_72, "fleetGS", var0_72)
	end
end

function var8_0.SubWarcry(arg0_73)
	local var0_73 = arg0_73:GetSubList()[1]
	local var1_73 = "battle"
	local var2_73 = var0_73:GetIntimacy()
	local var3_73 = var0_0.Battle.BattleDataFunction.GetWords(var0_73:GetSkinID(), var1_73, var2_73)

	var0_73:DispatchVoice(var1_73)
	var0_73:DispatchChat(var3_73, 2.5, var1_73)
end

function var8_0.SetWeaponBlock(arg0_74, arg1_74)
	arg0_74._blockCast = arg0_74._blockCast + arg1_74
end

function var8_0.GetWeaponBlock(arg0_75)
	return arg0_75._blockCast > 0
end

function var8_0.CastChargeWeapon(arg0_76)
	if arg0_76:GetWeaponBlock() then
		return
	end

	local var0_76 = arg0_76._chargeWeaponVO:GetCurrentWeapon()

	if var0_76 ~= nil and var0_76:GetCurrentState() == var0_76.STATE_READY then
		var0_76:Charge()

		local var1_76 = {}
		local var2_76 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.POINT_HIT_CHARGE, var1_76)

		arg0_76:DispatchEvent(var2_76)
	end
end

function var8_0.CancelChargeWeapon(arg0_77)
	local var0_77 = arg0_77._chargeWeaponVO:GetCurrentWeapon()

	if var0_77 ~= nil and var0_77:GetCurrentState() == var0_77.STATE_PRECAST then
		local var1_77 = {}
		local var2_77 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.POINT_HIT_CANCEL, var1_77)

		arg0_77:DispatchEvent(var2_77)
		var0_77:CancelCharge()
	end
end

function var8_0.UnleashChrageWeapon(arg0_78)
	if arg0_78:GetWeaponBlock() then
		arg0_78:CancelChargeWeapon()

		return
	end

	local var0_78 = arg0_78._chargeWeaponVO:GetCurrentWeapon()

	if var0_78 ~= nil and var0_78:GetCurrentState() == var0_78.STATE_PRECAST then
		if var0_78:IsStrikeMode() then
			local var1_78 = arg0_78._motionVO:GetPos().x + var5_0.ChargeWeaponConfig.SIGHT_C
			local var2_78 = math.min(var1_78, arg0_78._totalRightBound)

			arg0_78:fireChargeWeapon(var0_78, true, Vector3.New(var2_78, 0, arg0_78._motionVO:GetPos().z))
		else
			var0_78:CancelCharge()
		end

		local var3_78 = {}
		local var4_78 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.POINT_HIT_CANCEL, var3_78)

		arg0_78:DispatchEvent(var4_78)
	end
end

function var8_0.QuickTagChrageWeapon(arg0_79, arg1_79)
	if arg0_79:GetWeaponBlock() then
		return
	end

	local var0_79
	local var1_79 = arg0_79._chargeWeaponVO:GetCurrentWeapon()

	if var1_79 ~= nil and var1_79:GetCurrentState() == var1_79.STATE_READY then
		var1_79:QuickTag()

		if #var1_79:GetLockList() <= 0 then
			var1_79:CancelQuickTag()
		else
			var0_79 = arg0_79:fireChargeWeapon(var1_79, arg1_79)
		end
	end

	return var0_79
end

function var8_0.fireChargeWeapon(arg0_80, arg1_80, arg2_80, arg3_80)
	local var0_80 = arg1_80:GetHost()

	local function var1_80()
		local function var0_81()
			arg1_80:Fire(arg3_80)
		end

		arg1_80:DispatchBlink(var0_81)
	end

	if arg2_80 then
		if arg0_80._IFF == var5_0.FRIENDLY_CODE then
			arg0_80._chargeWeaponVO:PlayCutIn(var0_80, 1 / var5_0.FOCUS_MAP_RATE)
		end

		arg0_80._chargeWeaponVO:PlayFocus(var0_80, var1_80)
	else
		if arg0_80._IFF == var5_0.FRIENDLY_CODE then
			arg0_80._chargeWeaponVO:PlayCutIn(var0_80, 1)
		end

		var1_80()
	end
end

function var8_0.UnleashAllInStrike(arg0_83)
	if arg0_83:GetWeaponBlock() then
		return
	end

	local var0_83
	local var1_83 = arg0_83._airAssistVO:GetCurrentWeapon()

	if var1_83 and var1_83:GetCurrentState() == var1_83.STATE_READY then
		local var2_83 = var1_83:GetHost()

		if arg0_83._IFF == var5_0.FRIENDLY_CODE and var2_83:IsMainFleetUnit() then
			arg0_83._airAssistVO:PlayCutIn(var2_83, 1)
		end

		var1_83:CLSBullet()
		var1_83:DispatchBlink()

		var0_83 = var1_83:Fire()
	end

	return var0_83
end

function var8_0.CastTorpedo(arg0_84)
	if arg0_84:GetWeaponBlock() then
		return
	end

	local var0_84 = arg0_84._torpedoWeaponVO:GetCurrentWeapon()

	if var0_84 ~= nil and var0_84:GetCurrentState() == var0_84.STATE_READY and var0_84:Prepar() then
		arg0_84:FleetBuffTrigger(var4_0.BuffEffectType.ON_TORPEDO_BUTTON_PUSH)
	end
end

function var8_0.CancelTorpedo(arg0_85)
	local var0_85 = arg0_85._torpedoWeaponVO:GetCurrentWeapon()

	if var0_85 ~= nil and var0_85:GetCurrentState() == var0_85.STATE_PRECAST then
		var0_85:Cancel()
	end
end

function var8_0.UnleashTorpedo(arg0_86)
	if arg0_86:GetWeaponBlock() then
		arg0_86:CancelTorpedo()

		return
	end

	local var0_86 = arg0_86._torpedoWeaponVO:GetCurrentWeapon()

	if var0_86 ~= nil and var0_86:GetCurrentState() == var0_86.STATE_PRECAST then
		var0_86:Fire()
	end
end

function var8_0.QuickCastTorpedo(arg0_87)
	if arg0_87:GetWeaponBlock() then
		return
	end

	local var0_87
	local var1_87 = arg0_87._torpedoWeaponVO:GetCurrentWeapon()

	if var1_87 ~= nil and var1_87:GetCurrentState() == var1_87.STATE_READY then
		var0_87 = var1_87:Fire(true)
	end

	return var0_87
end

function var8_0.RemoveManunalTorpedo(arg0_88, arg1_88, arg2_88)
	if arg1_88:IsAttacking() then
		arg0_88:CancelTorpedo()
	end

	arg0_88._torpedoWeaponVO:RemoveWeapon(arg1_88)

	if not arg2_88 then
		arg1_88:Clear()
	end
end

function var8_0.CoupleEncourage(arg0_89)
	local var0_89 = {}
	local var1_89 = {}

	for iter0_89, iter1_89 in ipairs(arg0_89._unitList) do
		local var2_89 = iter1_89:GetIntimacy()
		local var3_89 = var7_0.GetWords(iter1_89:GetSkinID(), "couple_encourage", var2_89)

		if #var3_89 > 0 then
			var0_89[iter1_89] = var3_89
		end
	end

	local var4_89 = var4_0.CPChatType
	local var5_89 = var4_0.CPChatTargetFunc

	local function var6_89(arg0_90, arg1_90)
		local var0_90 = {}

		if arg0_90 == var4_89.GROUP_ID then
			var0_90.groupIDList = arg1_90
		elseif arg0_90 == var4_89.SHIP_TYPE then
			var0_90.ship_type_list = arg1_90
		elseif arg0_90 == var4_89.RARE then
			var0_90.rarity = arg1_90[1]
		elseif arg0_90 == var4_89.NATIONALITY then
			var0_90.nationality = arg1_90[1]
		elseif arg0_90 == var4_89.ILLUSTRATOR then
			var0_90.illustrator = arg1_90[1]
		elseif arg0_90 == var4_89.TEAM then
			var0_90.teamIndex = arg1_90[1]
		end

		return var0_90
	end

	for iter2_89, iter3_89 in pairs(var0_89) do
		for iter4_89, iter5_89 in ipairs(iter3_89) do
			local var7_89 = iter5_89[1]
			local var8_89 = iter5_89[2]
			local var9_89 = iter5_89[4] or var4_89.GROUP_ID
			local var10_89 = var0_0.Battle.BattleTargetChoise.TargetAllHelp(iter2_89)

			if type(var9_89) == "table" then
				for iter6_89, iter7_89 in ipairs(var9_89) do
					local var11_89 = var6_89(iter7_89, var7_89[iter6_89])

					var10_89 = var0_0.Battle.BattleTargetChoise[var5_89[iter7_89]](iter2_89, var11_89, var10_89)
				end
			elseif type(var9_89) == "number" then
				local var12_89 = var6_89(var9_89, var7_89)

				var10_89 = var0_0.Battle.BattleTargetChoise[var5_89[var9_89]](iter2_89, var12_89, var10_89)
			end

			if var8_89 <= #var10_89 then
				local var13_89 = {
					cp = iter2_89,
					content = iter5_89[3],
					linkIndex = iter4_89
				}

				var1_89[#var1_89 + 1] = var13_89
			end
		end
	end

	if #var1_89 > 0 then
		local var14_89 = var1_89[math.random(#var1_89)]
		local var15_89 = "link" .. var14_89.linkIndex

		var14_89.cp:DispatchVoice(var15_89)
		var14_89.cp:DispatchChat(var14_89.content, 3, var15_89)
	end
end

function var8_0.onUnitUpdateHP(arg0_91, arg1_91)
	local var0_91 = arg1_91.Dispatcher
	local var1_91 = arg1_91.Data.dHP

	for iter0_91, iter1_91 in ipairs(arg0_91._unitList) do
		iter1_91:TriggerBuff(var4_0.BuffEffectType.ON_FRIENDLY_HP_RATIO_UPDATE, {
			unit = var0_91,
			dHP = var1_91
		})

		if iter1_91 ~= var0_91 then
			iter1_91:TriggerBuff(var4_0.BuffEffectType.ON_TEAMMATE_HP_RATIO_UPDATE, {
				unit = var0_91,
				dHP = var1_91
			})
		end
	end
end

function var8_0.onUnitCloakUpdate(arg0_92, arg1_92)
	local var0_92 = arg1_92.Dispatcher
	local var1_92 = var6_0.GetCurrent(var0_92, "isCloak")

	for iter0_92, iter1_92 in ipairs(arg0_92._unitList) do
		iter1_92:TriggerBuff(var4_0.BuffEffectType.ON_CLOAK_UPDATE, {
			cloakState = var1_92
		})

		if iter1_92 ~= var0_92 then
			iter1_92:TriggerBuff(var4_0.BuffEffectType.ON_TEAMMATE_CLOAK_UPDATE, {
				cloakState = var1_92
			})
		end
	end
end

function var8_0.SetSubUnitData(arg0_93, arg1_93)
	arg0_93._subUntiDataList = arg1_93
end

function var8_0.GetSubUnitData(arg0_94)
	return arg0_94._subUntiDataList
end

function var8_0.AddSubMarine(arg0_95, arg1_95)
	arg1_95:InitOxygen()

	local var0_95 = arg1_95:GetTemplate()
	local var1_95 = var0_0.Battle.BattleUnitPhaseSwitcher.New(arg1_95)

	local function var2_95()
		return arg1_95:GetRaidDuration()
	end

	local var3_95 = arg0_95._fixedSubRefLine or arg0_95._subAttackBaseLine

	var1_95:SetTemplateData(var7_0.GeneratePlayerSubmarinPhase(var3_95, arg0_95._subRetreatBaseLine, arg1_95:GetAttrByName("raidDist"), var2_95, arg1_95:GetAttrByName("oxyAtkDuration")))

	arg0_95._unitList[#arg0_95._unitList + 1] = arg1_95
	arg0_95._subList[#arg0_95._subList + 1] = arg1_95

	arg1_95:SetFleetVO(arg0_95)
	arg1_95:RegisterEventListener(arg0_95, var1_0.UPDATE_HP, arg0_95.onUnitUpdateHP)
	arg1_95:RegisterEventListener(arg0_95, var1_0.UPDATE_CLOAK_STATE, arg0_95.onUnitCloakUpdate)
end

function var8_0.AddManualSubmarine(arg0_97, arg1_97)
	arg0_97._unitList[#arg0_97._unitList + 1] = arg1_97
	arg0_97._manualSubList[#arg0_97._manualSubList + 1] = arg1_97
	arg0_97._manualSubBench[#arg0_97._manualSubBench + 1] = arg1_97
	arg0_97._maxCount = arg0_97._maxCount + 1

	arg1_97:InitOxygen()
	arg1_97:SetFleetVO(arg0_97)
	arg1_97:SetMotion(arg0_97._motionVO)
	arg1_97:RegisterEventListener(arg0_97, var1_0.UPDATE_HP, arg0_97.onUnitUpdateHP)
	arg1_97:RegisterEventListener(arg0_97, var1_0.UPDATE_CLOAK_STATE, arg0_97.onUnitCloakUpdate)
end

function var8_0.GetSubList(arg0_98)
	return arg0_98._subList
end

function var8_0.ShiftManualSub(arg0_99)
	local var0_99

	if arg0_99._manualSubUnit then
		local var1_99 = arg0_99._manualSubUnit:GetTorpedoList()

		for iter0_99, iter1_99 in ipairs(var1_99) do
			if iter1_99:IsAttacking() then
				arg0_99:CancelTorpedo()
			end

			arg0_99._torpedoWeaponVO:RemoveWeapon(iter1_99)
		end

		if arg0_99._manualSubUnit:IsAlive() then
			table.insert(arg0_99._manualSubBench, arg0_99._manualSubUnit)
		end

		var0_99 = arg0_99._motionVO:GetPos():Clone()
	else
		var0_99 = arg0_99._manualSubList[1]:GetPosition():Clone()
	end

	arg0_99._manualSubUnit = table.remove(arg0_99._manualSubBench, 1)
	arg0_99._scoutList[1] = arg0_99._manualSubUnit

	local var2_99 = {}

	for iter2_99, iter3_99 in ipairs(arg0_99._manualSubBench) do
		for iter4_99, iter5_99 in ipairs(arg0_99._unitList) do
			if iter5_99 == iter3_99 then
				table.insert(var2_99, iter4_99)

				break
			end
		end
	end

	for iter6_99, iter7_99 in ipairs(arg0_99._unitList) do
		if iter7_99 == arg0_99._manualSubUnit then
			table.insert(var2_99, 1, iter6_99)

			break
		end
	end

	arg0_99:refreshFleetFormation(var2_99)
	arg0_99._manualSubUnit:SetMainUnitStatic(false)
	arg0_99._manualSubUnit:SetPosition(var0_99)
	arg0_99:UpdateMotion()
	arg0_99._submarineSpecialVO:SetUseable(false)

	local var3_99 = arg0_99._manualSubUnit:GetBuffList()

	for iter8_99, iter9_99 in pairs(var3_99) do
		if iter9_99:IsSubmarineSpecial() then
			arg0_99._submarineSpecialVO:SetCount(1)
			arg0_99._submarineSpecialVO:SetUseable(true)

			break
		end
	end

	arg0_99:ChangeSubmarineState(var0_0.Battle.OxyState.STATE_FREE_DIVE)
	arg0_99._torpedoWeaponVO:Reset()

	local var4_99 = arg0_99._manualSubUnit:GetTorpedoList()

	for iter10_99, iter11_99 in ipairs(var4_99) do
		if iter11_99:GetCurrentState() ~= iter11_99.STATE_OVER_HEAT then
			arg0_99._torpedoWeaponVO:AppendWeapon(iter11_99)
		end
	end

	for iter12_99, iter13_99 in ipairs(var4_99) do
		if iter13_99:GetCurrentState() == iter13_99.STATE_OVER_HEAT then
			arg0_99._torpedoWeaponVO:AppendWeapon(iter13_99)
		end
	end

	if var6_0.GetCurrent(arg0_99._manualSubUnit, "oxyMax") <= 0 then
		arg0_99._submarineDiveVO:SetActive(false)
		arg0_99._submarineFloatVO:SetActive(false)
	else
		arg0_99._submarineDiveVO:SetActive(true)
		arg0_99._submarineFloatVO:SetActive(true)
	end

	for iter14_99, iter15_99 in ipairs(arg0_99._manualSubBench) do
		iter15_99:SetPosition(var5_0.SUB_BENCH_POS[iter14_99])
		iter15_99:SetMainUnitStatic(true)
		iter15_99:ChangeOxygenState(var0_0.Battle.OxyState.STATE_FREE_BENCH)
	end

	arg0_99._submarineShiftVO:ResetCurrent()

	if #arg0_99._manualSubBench == 0 then
		arg0_99._submarineShiftVO:SetActive(false)
	end
end

function var8_0.ChangeSubmarineState(arg0_100, arg1_100, arg2_100)
	if not arg0_100._manualSubUnit then
		return
	end

	arg0_100._manualSubUnit:ChangeOxygenState(arg1_100)

	if arg2_100 then
		for iter0_100, iter1_100 in ipairs(arg0_100._submarineVOList) do
			iter1_100:ResetCurrent()
		end

		local var0_100 = arg0_100._submarineShiftVO:GetMax() - arg0_100._submarineShiftVO:GetCurrent()

		if arg0_100._submarineShiftVO:IsOverLoad() and var0_100 > var5_0.SR_CONFIG.DIVE_CD then
			-- block empty
		else
			arg0_100._submarineShiftVO:SetMax(var5_0.SR_CONFIG.DIVE_CD)
			arg0_100._submarineShiftVO:ResetCurrent()
		end
	end

	arg0_100:DispatchEvent(var0_0.Event.New(var2_0.MANUAL_SUBMARINE_SHIFT, {
		state = arg1_100
	}))
end

function var8_0.SubmarinBoost(arg0_101)
	arg0_101._manualSubUnit:Boost(Vector3.right, var5_0.SR_CONFIG.BOOST_SPEED, var5_0.SR_CONFIG.BOOST_DECAY, var5_0.SR_CONFIG.BOOST_DURATION, var5_0.SR_CONFIG.BOOST_DECAY_STAMP)
	arg0_101._submarineBoostVO:ResetCurrent()
end

function var8_0.UnleashSubmarineSpecial(arg0_102)
	if arg0_102:GetWeaponBlock() then
		return
	end

	arg0_102._submarineSpecialVO:Cast()
	arg0_102._manualSubUnit:TriggerBuff(var4_0.BuffEffectType.ON_SUBMARINE_FREE_SPECIAL)
end

function var8_0.FixSubRefLine(arg0_103, arg1_103)
	arg0_103._fixedSubRefLine = arg1_103
end

function var8_0.AppendIndieSonar(arg0_104, arg1_104, arg2_104)
	local var0_104 = var0_0.Battle.BattleIndieSonar.New(arg0_104, arg1_104, arg2_104)

	var0_104:SwitchHost(arg0_104._motionReferenceUnit)

	arg0_104._indieSonarList[var0_104] = true

	var0_104:Detect()
end

function var8_0.RemoveIndieSonar(arg0_105, arg1_105)
	for iter0_105, iter1_105 in pairs(arg0_105._indieSonarList) do
		if arg1_105 == iter0_105 then
			arg0_105._indieSonarList[iter0_105] = nil

			break
		end
	end
end

function var8_0.AttachFleetBuff(arg0_106, arg1_106)
	local var0_106 = arg1_106:GetID()
	local var1_106 = arg0_106:GetFleetBuff(var0_106)

	if var1_106 then
		var1_106:Stack(arg0_106)
	else
		arg0_106._buffList[var0_106] = arg1_106

		arg1_106:Attach(arg0_106)
	end
end

function var8_0.RemoveFleetBuff(arg0_107, arg1_107)
	local var0_107 = arg0_107:GetFleetBuff(arg1_107)

	if var0_107 then
		var0_107:Remove()
	end
end

function var8_0.GetFleetBuff(arg0_108, arg1_108)
	return arg0_108._buffList[arg1_108]
end

function var8_0.GetFleetBuffList(arg0_109)
	return arg0_109._buffList
end

function var8_0.AttachFleetAttr(arg0_110)
	arg0_110._fleetAttr = var0_0.Battle.BattleFleetAttrComponent.New(arg0_110)
end

function var8_0.GetFleetAttr(arg0_111)
	return arg0_111._fleetAttr
end

function var8_0.Jamming(arg0_112, arg1_112)
	if arg1_112 then
		arg0_112._chargeWeaponVO:StartJamming()
		arg0_112._torpedoWeaponVO:StartJamming()
		arg0_112._airAssistVO:StartJamming()
	else
		arg0_112._chargeWeaponVO:JammingEliminate()
		arg0_112._torpedoWeaponVO:JammingEliminate()
		arg0_112._airAssistVO:JammingEliminate()
	end
end

function var8_0.Blinding(arg0_113, arg1_113)
	arg0_113:DispatchEvent(var0_0.Event.New(var2_0.FLEET_BLIND, {
		isBlind = arg1_113
	}))
end

function var8_0.UpdateHorizon(arg0_114)
	arg0_114:DispatchEvent(var0_0.Event.New(var2_0.FLEET_HORIZON_UPDATE, {}))
end

function var8_0.AutoBotUpdated(arg0_115, arg1_115)
	local var0_115 = arg1_115 and var4_0.BuffEffectType.ON_AUTOBOT or var4_0.BuffEffectType.ON_MANUAL

	arg0_115:FleetBuffTrigger(var0_115)
end

function var8_0.CloakFatalExpose(arg0_116)
	for iter0_116, iter1_116 in ipairs(arg0_116._cloakList) do
		iter1_116:GetCloak():ForceToMax()
	end
end

function var8_0.CloakInVision(arg0_117, arg1_117)
	for iter0_117, iter1_117 in ipairs(arg0_117._cloakList) do
		iter1_117:GetCloak():AppendExposeSpeed(arg1_117)
	end
end

function var8_0.CloakOutVision(arg0_118)
	for iter0_118, iter1_118 in ipairs(arg0_118._cloakList) do
		iter1_118:GetCloak():AppendExposeSpeed(0)
	end
end

function var8_0.AttachCloak(arg0_119, arg1_119)
	if not arg1_119:GetCloak() then
		arg1_119:InitCloak()

		arg0_119._cloakList[#arg0_119._cloakList + 1] = arg1_119
	end
end

function var8_0.AttachNightCloak(arg0_120)
	arg0_120._scoutAimBias = var0_0.Battle.BattleUnitAimBiasComponent.New()

	arg0_120._scoutAimBias:ConfigRangeFormula(var3_0.CalculateMaxAimBiasRange, var3_0.CalculateBiasDecay)
	arg0_120._scoutAimBias:Active(arg0_120._scoutAimBias.STATE_ACTIVITING)
	arg0_120:DispatchEvent(var0_0.Event.New(var2_0.ADD_AIM_BIAS, {
		aimBias = arg0_120._scoutAimBias
	}))
end

function var8_0.GetFleetBias(arg0_121)
	return arg0_121._scoutAimBias
end

function var8_0.FreezeUnit(arg0_122, arg1_122)
	arg0_122:RemovePlayerUnit(arg1_122, true)

	arg0_122._freezeList[arg1_122] = true
end

function var8_0.ActiveFreezeUnit(arg0_123, arg1_123)
	arg0_123._freezeList[arg1_123] = nil
	arg0_123._unitList[#arg0_123._unitList + 1] = arg1_123
	arg0_123._maxCount = arg0_123._maxCount + 1

	if arg1_123:IsMainFleetUnit() then
		arg0_123:appendFreezeMainUnit(arg1_123)
	else
		arg0_123:activeFreezeScoutUnit(arg1_123)
	end

	arg1_123:SetFleetVO(arg0_123)
	arg1_123:SetMotion(arg0_123._motionVO)
	arg1_123:RegisterEventListener(arg0_123, var1_0.UPDATE_HP, arg0_123.onUnitUpdateHP)
	arg1_123:RegisterEventListener(arg0_123, var1_0.UPDATE_CLOAK_STATE, arg0_123.onUnitCloakUpdate)
end

function var8_0.UndoFusion(arg0_124)
	for iter0_124, iter1_124 in pairs(arg0_124._freezeList) do
		arg0_124._unitList[#arg0_124._unitList + 1] = iter0_124
		arg0_124._maxCount = arg0_124._maxCount + 1

		if iter0_124:IsMainFleetUnit() then
			arg0_124:appendFreezeMainUnit(iter0_124)
		else
			arg0_124:activeFreezeScoutUnit(iter0_124)
		end
	end

	local var0_124 = {}

	for iter2_124, iter3_124 in ipairs(arg0_124._unitList) do
		local var1_124 = iter3_124:GetAttrByName("hpProvideRate")

		if var1_124 ~= 0 then
			table.insert(var0_124, iter3_124)

			local var2_124, var3_124 = iter3_124:GetHP()
			local var4_124 = var3_124 - var2_124
			local var5_124 = 0

			for iter4_124, iter5_124 in pairs(var1_124) do
				local var6_124 = arg0_124:GetFreezeShipByID(iter4_124)

				if not var6_124 then
					arg0_124:GetShipByID(iter4_124)
				end

				local var7_124 = math.floor(iter5_124 * var4_124)

				var6_124:UpdateHP(var7_124 * -1, {})
			end
		end
	end

	for iter6_124, iter7_124 in ipairs(var0_124) do
		arg0_124:RemovePlayerUnit(iter7_124)
	end
end

function var8_0.appendFreezeMainUnit(arg0_125, arg1_125)
	arg0_125._mainList[#arg0_125._mainList + 1] = arg1_125

	arg1_125:SetMainUnitIndex(#arg0_125._mainList)

	if ShipType.CloakShipType(arg1_125:GetTemplate().type) then
		table.insert(arg0_125._cloakList, arg1_125)
	end

	local var0_125 = arg1_125:GetChargeList()

	for iter0_125, iter1_125 in ipairs(var0_125) do
		arg0_125._chargeWeaponVO:AppendFreezeWeapon(iter1_125)
	end

	local var1_125 = arg1_125:GetTorpedoList()

	for iter2_125, iter3_125 in ipairs(var1_125) do
		arg0_125._torpedoWeaponVO:AppendFreezeWeapon(iter3_125)
	end

	if arg1_125:GetAirAssistList() then
		local var2_125 = arg1_125:GetAirAssistList()

		for iter4_125, iter5_125 in ipairs(var2_125) do
			arg0_125._airAssistVO:AppendFreezeWeapon(iter5_125)
		end
	end

	arg0_125._fleetAntiAir:AppendCrewUnit(arg1_125)
	arg0_125._fleetRangeAntiAir:AppendCrewUnit(arg1_125)
	arg0_125._fleetStaticSonar:AppendCrewUnit(arg1_125)

	local var3_125 = {}

	for iter6_125, iter7_125 in ipairs(arg0_125._unitList) do
		table.insert(var3_125, iter6_125)
	end

	arg0_125:refreshFleetFormation(var3_125)
end

function var8_0.activeFreezeScoutUnit(arg0_126, arg1_126)
	arg0_126._scoutList[#arg0_126._scoutList + 1] = arg1_126

	local var0_126 = arg1_126:GetTorpedoList()

	for iter0_126, iter1_126 in ipairs(var0_126) do
		arg0_126._torpedoWeaponVO:AppendFreezeWeapon(iter1_126)
	end

	if arg1_126:GetAirAssistList() then
		local var1_126 = arg1_126:GetAirAssistList()

		for iter2_126, iter3_126 in ipairs(var1_126) do
			arg0_126._airAssistVO:AppendFreezeWeapon(iter3_126)
		end
	end

	arg0_126._fleetAntiAir:AppendCrewUnit(arg1_126)
	arg0_126._fleetStaticSonar:AppendCrewUnit(arg1_126)

	local var2_126 = 1
	local var3_126 = #arg0_126._unitList
	local var4_126 = {}

	while var2_126 < var3_126 do
		table.insert(var4_126, var2_126)

		var2_126 = var2_126 + 1
	end

	table.insert(var4_126, #arg0_126._scoutList, var2_126)
	arg0_126:refreshFleetFormation(var4_126)
end

function var8_0.AttachCardPuzzleComponent(arg0_127)
	arg0_127._cardPuzzleComponent = var0_0.Battle.BattleFleetCardPuzzleComponent.New(arg0_127)

	return arg0_127._cardPuzzleComponent
end

function var8_0.GetCardPuzzleComponent(arg0_128)
	return arg0_128._cardPuzzleComponent
end

function var8_0.AppendSupportUnit(arg0_129, arg1_129)
	arg0_129._supportList[#arg0_129._supportList + 1] = arg1_129
end

function var8_0.GetSupportUnitList(arg0_130)
	return arg0_130._supportList
end
