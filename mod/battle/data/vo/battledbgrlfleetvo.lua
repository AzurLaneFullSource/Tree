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
local var9 = class("BattleFleetVO")

var0.Battle.BattleFleetVO = var9
var9.__name = "BattleFleetVO"

function var9.Ctor(arg0, arg1)
	var0.EventDispatcher.AttachEventDispatcher(arg0)
	var0.EventListener.AttachEventListener(arg0)

	arg0._IFF = arg1
	arg0._lastDist = 0

	arg0:init()
end

function var9.UpdateMotion(arg0)
	if arg0._motionReferenceUnit then
		arg0._motionVO:UpdatePos(arg0._motionReferenceUnit)
		arg0._motionVO:UpdateVelocityAndDirection(arg0:GetFleetVelocity(), arg0._motionSourceFunc())
	end

	local var0 = math.max(arg0._motionVO:GetPos().x - arg0._rightBound, 0)

	if var0 >= 0 and var0 ~= arg0._lastDist then
		arg0._lastDist = var0

		arg0:DispatchEvent(var0.Event.New(var2.SHOW_BUFFER, {
			dist = var0
		}))
	end
end

function var9.UpdateAutoComponent(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._scoutList) do
		iter1:UpdateWeapon(arg1)
		iter1:UpdateAirAssist()
	end

	for iter2, iter3 in ipairs(arg0._mainList) do
		iter3:UpdateWeapon(arg1)
		iter3:UpdateAirAssist()
	end

	for iter4, iter5 in ipairs(arg0._cloakList) do
		iter5:UpdateCloak(arg1)
	end

	for iter6, iter7 in ipairs(arg0._subList) do
		iter7:UpdateWeapon(arg1)
		iter7:UpdateOxygen(arg1)
		iter7:UpdatePhaseSwitcher()
	end

	for iter8, iter9 in ipairs(arg0._manualSubList) do
		iter9:UpdateOxygen(arg1)
	end

	arg0._fleetAntiAir:Update(arg1)
	arg0._fleetRangeAntiAir:Update(arg1)
	arg0._fleetStaticSonar:Update(arg1)

	for iter10, iter11 in pairs(arg0._indieSonarList) do
		iter10:Update(arg1)
	end

	arg0:UpdateBuff(arg1)
end

function var9.UpdateBuff(arg0, arg1)
	local var0 = arg0._buffList

	for iter0, iter1 in pairs(var0) do
		iter1:Update(arg0, arg1)
	end
end

function var9.UpdateManualWeaponVO(arg0, arg1)
	arg0._chargeWeaponVO:Update(arg1)
	arg0._torpedoWeaponVO:Update(arg1)
	arg0._airAssistVO:Update(arg1)
	arg0._submarineDiveVO:Update(arg1)
	arg0._submarineFloatVO:Update(arg1)
	arg0._submarineBoostVO:Update(arg1)
	arg0._submarineShiftVO:Update(arg1)
end

function var9.UpdateFleetDamage(arg0, arg1)
	local var0 = var3.CalculateFleetDamage(arg1)

	arg0._currentDMGRatio = arg0._currentDMGRatio + var0

	arg0:DispatchFleetDamageChange()
end

function var9.UpdateFleetOverDamage(arg0, arg1)
	local var0 = var3.CalculateFleetOverDamage(arg0, arg1)

	arg0._currentDMGRatio = arg0._currentDMGRatio - var0

	arg0:DispatchFleetDamageChange()
end

function var9.DispatchFleetDamageChange(arg0)
	arg0:DispatchEvent(var0.Event.New(var2.FLEET_DMG_CHANGE, {}))
end

function var9.DispatchSonarScan(arg0, arg1)
	arg0:DispatchEvent(var0.Event.New(var2.SONAR_SCAN, {
		indieSonar = arg1
	}))
end

function var9.FreeMainUnit(arg0, arg1)
	if arg0._mainUnitFree then
		return
	end

	arg0._mainUnitFree = true

	for iter0, iter1 in ipairs(arg0._mainList) do
		local var0 = var0.Battle.BattleBuffUnit.New(arg1)

		iter1:AddBuff(var0)
		iter1:SetMainUnitStatic(false)
	end
end

function var9.RandomMainVictim(arg0, arg1)
	arg1 = arg1 or {}

	local var0 = {}
	local var1

	for iter0, iter1 in ipairs(arg0._mainList) do
		local var2 = true

		for iter2, iter3 in ipairs(arg1) do
			if iter1:GetAttrByName(iter3) == 1 then
				var2 = false

				break
			end
		end

		if var2 then
			table.insert(var0, iter1)
		end
	end

	if #var0 > 0 then
		var1 = var0[math.random(#var0)]
	end

	return var1
end

function var9.NearestUnitByType(arg0, arg1, arg2)
	local var0 = 999
	local var1

	for iter0, iter1 in ipairs(arg0._unitList) do
		local var2 = iter1:GetTemplate().type

		if table.contains(arg2, var2) then
			local var3 = iter1:GetPosition()
			local var4 = Vector3.BattleDistance(var3, arg1)

			if var4 < var0 then
				var0 = var4
				var1 = iter1
			end
		end
	end

	return var1
end

function var9.SetMotionSource(arg0, arg1)
	if arg1 == nil then
		function arg0._motionSourceFunc()
			local var0 = pg.UIMgr.GetInstance()

			return var0.hrz, var0.vtc
		end
	else
		arg0._motionSourceFunc = arg1
	end
end

function var9.SetSubAidData(arg0, arg1, arg2)
	arg0._submarineVO = var0.Battle.BattleSubmarineAidVO.New()

	if arg2 == var4.SubAidFlag.AID_EMPTY or arg2 == var4.SubAidFlag.OIL_EMPTY then
		arg0._submarineVO:SetUseable(false)
	else
		arg0._submarineVO:SetCount(arg2)
		arg0._submarineVO:SetTotal(arg1)
		arg0._submarineVO:SetUseable(true)
	end
end

function var9.SetBound(arg0, arg1, arg2, arg3, arg4)
	arg0._upperBound = arg1
	arg0._lowerBound = arg2
	arg0._leftBound = arg3
	arg0._rightBound = arg4
end

function var9.SetTotalBound(arg0, arg1, arg2, arg3, arg4)
	arg0._totalUpperBound = arg1
	arg0._totalLowerBound = arg2
	arg0._totalLeftBound = arg3
	arg0._totalRightBound = arg4
end

function var9.CalcSubmarineBaseLine(arg0, arg1)
	local var0 = (arg0._totalRightBound + arg0._totalLeftBound) * 0.5

	if arg0._IFF == var5.FRIENDLY_CODE then
		if arg1 == SYSTEM_DUEL then
			-- block empty
		else
			arg0._subAttackBaseLine = var0
			arg0._subRetreatBaseLine = arg0._leftBound - 10
		end
	elseif arg0._IFF == var5.FOE_CODE and arg1 == SYSTEM_DUEL then
		-- block empty
	end
end

function var9.SetExposeLine(arg0, arg1, arg2)
	arg0._visionLineX = arg1
	arg0._exposeLineX = arg2
end

function var9.AppendPlayerUnit(arg0, arg1)
	arg0._unitList[#arg0._unitList + 1] = arg1
	arg0._maxCount = arg0._maxCount + 1

	if arg1:IsMainFleetUnit() then
		arg0:appendMainUnit(arg1)
	else
		arg0:appendScoutUnit(arg1)
	end

	arg1:SetFleetVO(arg0)
	arg1:SetMotion(arg0._motionVO)
	arg1:RegisterEventListener(arg0, var1.UPDATE_HP, arg0.onUnitUpdateHP)
end

function var9.RemovePlayerUnit(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0._unitList) do
		if iter1 ~= arg1 then
			var0[#var0 + 1] = iter0
		else
			iter1:UnregisterEventListener(arg0, var1.UPDATE_HP)
			iter1:DeactiveCldBox()

			local var1 = iter1:GetChargeList()

			for iter2, iter3 in ipairs(var1) do
				if iter3:IsAttacking() then
					arg0._chargeWeaponVO:CancelFocus()
					arg0._chargeWeaponVO:ResetFocus()
					arg0:CancelChargeWeapon()
				end

				arg0._chargeWeaponVO:RemoveWeapon(iter3)
				iter3:Clear()
			end

			arg0._fleetAntiAir:RemoveCrewUnit(arg1)
			arg0._fleetRangeAntiAir:RemoveCrewUnit(arg1)
			arg0._fleetStaticSonar:RemoveCrewUnit(arg1)

			local var2 = iter1:GetTorpedoList()

			for iter4, iter5 in ipairs(var2) do
				arg0:RemoveManunalTorpedo(iter5)
			end

			local var3 = iter1:GetAirAssistList()

			if var3 then
				for iter6, iter7 in ipairs(var3) do
					arg0._airAssistVO:RemoveWeapon(iter7)
				end
			end
		end
	end

	for iter8, iter9 in ipairs(arg0._scoutList) do
		if iter9 == arg1 then
			if #arg0._scoutList == 1 then
				arg0:CancelChargeWeapon()
			end

			table.remove(arg0._scoutList, iter8)

			break
		end
	end

	for iter10, iter11 in ipairs(arg0._mainList) do
		if iter11 == arg1 then
			table.remove(arg0._mainList, iter10)

			break
		end
	end

	for iter12, iter13 in ipairs(arg0._cloakList) do
		if iter13 == arg1 then
			table.remove(arg0._cloakList, iter12)

			break
		end
	end

	for iter14, iter15 in ipairs(arg0._subList, i) do
		if iter15 == arg1 then
			table.remove(arg0._subList, iter14)

			break
		end
	end

	for iter16, iter17 in ipairs(arg0._manualSubList) do
		if iter17 == arg1 then
			table.remove(arg0._manualSubList, iter16)

			break
		end
	end

	if not arg0._manualSubUnit then
		arg0:refreshFleetFormation(var0)
	end
end

function var9.OverrideJoyStickAutoBot(arg0, arg1)
	arg0._autoBotAIID = arg1

	local var0 = var0.Event.New(var0.Battle.BattleEvent.OVERRIDE_AUTO_BOT)

	arg0:DispatchEvent(var0)
end

function var9.SnapShot(arg0)
	arg0._totalDMGRatio = var3.GetFleetTotalHP(arg0)
	arg0._currentDMGRatio = arg0._totalDMGRatio
end

function var9.GetIFF(arg0)
	return arg0._IFF
end

function var9.GetMaxCount(arg0)
	return arg0._maxCount
end

function var9.GetFlagShip(arg0)
	return arg0._flagShip
end

function var9.GetLeaderShip(arg0)
	return arg0._scoutList[1]
end

function var9.GetUnitList(arg0)
	return arg0._unitList
end

function var9.GetMainList(arg0)
	return arg0._mainList
end

function var9.GetScoutList(arg0)
	return arg0._scoutList
end

function var9.GetCloakList(arg0)
	return arg0._cloakList
end

function var9.GetSubBench(arg0)
	return arg0._manualSubBench
end

function var9.GetMotion(arg0)
	return arg0._motionVO
end

function var9.GetMotionReferenceUnit(arg0)
	return arg0._motionReferenceUnit
end

function var9.GetAutoBotAIID(arg0)
	return arg0._autoBotAIID
end

function var9.GetChargeWeaponVO(arg0)
	return arg0._chargeWeaponVO
end

function var9.GetTorpedoWeaponVO(arg0)
	return arg0._torpedoWeaponVO
end

function var9.GetAirAssistVO(arg0)
	return arg0._airAssistVO
end

function var9.GetSubAidVO(arg0)
	return arg0._submarineVO
end

function var9.GetSubFreeDiveVO(arg0)
	return arg0._submarineDiveVO
end

function var9.GetSubFreeFloatVO(arg0)
	return arg0._submarineFloatVO
end

function var9.GetSubBoostVO(arg0)
	return arg0._submarineBoostVO
end

function var9.GetSubSpecialVO(arg0)
	return arg0._submarineSpecialVO
end

function var9.GetSubShiftVO(arg0)
	return arg0._submarineShiftVO
end

function var9.GetFleetAntiAirWeapon(arg0)
	return arg0._fleetAntiAir
end

function var9.GetFleetRangeAntiAirWeapon(arg0)
	return arg0._fleetRangeAntiAir
end

function var9.GetFleetVelocity(arg0)
	return var3.GetFleetVelocity(arg0._scoutList)
end

function var9.GetFleetBound(arg0)
	return arg0._upperBound, arg0._lowerBound, arg0._leftBound, arg0._rightBound
end

function var9.GetFleetExposeLine(arg0)
	return arg0._exposeLineX
end

function var9.GetFleetVisionLine(arg0)
	return arg0._visionLineX
end

function var9.GetLeaderPersonality(arg0)
	return arg0._motionReferenceUnit:GetAutoPilotPreference()
end

function var9.GetDamageRatioResult(arg0)
	return string.format("%0.2f", arg0._currentDMGRatio / arg0._totalDMGRatio * 100), arg0._totalDMGRatio
end

function var9.GetDamageRatio(arg0)
	return arg0._currentDMGRatio / arg0._totalDMGRatio
end

function var9.GetSubmarineBaseLine(arg0)
	return arg0._subAttackBaseLine, arg0._subRetreatBaseLine
end

function var9.GetFleetSonar(arg0)
	return arg0._fleetStaticSonar
end

function var9.Dispose(arg0)
	var0.EventDispatcher.DetachEventDispatcher(arg0)
	var0.EventListener.DetachEventListener(arg0)

	arg0._leaderUnit = nil

	arg0._fleetAntiAir:Dispose()
	arg0._fleetRangeAntiAir:Dispose()
	arg0._fleetStaticSonar:Dispose()

	arg0._fleetStaticSonar = nil
	arg0._buffList = nil
	arg0._indieSonarList = nil
	arg0._scoutAimBias = nil
end

function var9.refreshFleetFormation(arg0, arg1)
	local var0 = var7.GetFormationTmpDataFromID(var5.FORMATION_ID).pos_offset

	arg0._unitList = var7.SortFleetList(arg1, arg0._unitList)

	local var1 = var5.BornOffset

	if not arg0._mainUnitFree then
		for iter0, iter1 in ipairs(arg0._unitList) do
			if not table.contains(arg0._subList, iter1) then
				local var2 = var0[iter0]

				iter1:UpdateFormationOffset(Vector3(var2.x, var2.y, var2.z) + var1 * (iter0 - 1))
			end
		end
	end

	if #arg0._scoutList > 0 then
		arg0._motionReferenceUnit = arg0._scoutList[1]
		arg0._leaderUnit = arg0._scoutList[1]

		arg0._leaderUnit:LeaderSetting()
		arg0._fleetAntiAir:SwitchHost(arg0._motionReferenceUnit)
		arg0._fleetStaticSonar:SwitchHost(arg0._motionReferenceUnit)

		for iter2, iter3 in pairs(arg0._indieSonarList) do
			iter2:SwitchHost(arg0._motionReferenceUnit)
		end

		arg0._motionVO:UpdatePos(arg0._motionReferenceUnit)
	elseif arg0._fleetAntiAir:GetCurrentState() ~= arg0._fleetAntiAir.STATE_DISABLE then
		local var3 = arg0._fleetAntiAir:GetCrewUnitList()

		for iter4, iter5 in pairs(var3) do
			arg0._motionReferenceUnit = iter4

			arg0._fleetAntiAir:SwitchHost(iter4)

			break
		end
	else
		arg0._motionReferenceUnit = arg0._mainList[1]
		arg0._leaderUnit = nil
	end

	if #arg0:GetUnitList() == 0 then
		return
	end

	local var4 = var0.Event.New(var0.Battle.BattleEvent.REFRESH_FLEET_FORMATION)

	arg0:DispatchEvent(var4)
end

function var9.init(arg0)
	arg0._chargeWeaponVO = var0.Battle.BattleChargeWeaponVO.New()
	arg0._torpedoWeaponVO = var0.Battle.BattleTorpedoWeaponVO.New()
	arg0._airAssistVO = var0.Battle.BattleAllInStrikeVO.New()
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

	arg0._fleetAntiAir = var0.Battle.BattleFleetAntiAirUnit.New()
	arg0._fleetRangeAntiAir = var0.Battle.BattleFleetRangeAntiAirUnit.New()
	arg0._motionVO = var0.Battle.BattleFleetMotionVO.New()
	arg0._fleetStaticSonar = var0.Battle.BattleFleetStaticSonar.New(arg0)
	arg0._indieSonarList = {}
	arg0._scoutList = {}
	arg0._mainList = {}
	arg0._subList = {}
	arg0._cloakList = {}
	arg0._manualSubList = {}
	arg0._manualSubBench = {}
	arg0._unitList = {}
	arg0._maxCount = 0
	arg0._blockCast = 0
	arg0._buffList = {}

	arg0:SetMotionSource()
end

function var9.appendScoutUnit(arg0, arg1)
	arg0._scoutList[#arg0._scoutList + 1] = arg1

	local var0 = arg1:GetTorpedoList()

	for iter0, iter1 in ipairs(var0) do
		arg0._torpedoWeaponVO:AppendWeapon(iter1)
	end

	if #arg1:GetHiveList() > 0 then
		local var1 = var7.CreateAllInStrike(arg1)

		for iter2, iter3 in ipairs(var1) do
			arg0._airAssistVO:AppendWeapon(iter3)
		end

		arg1:SetAirAssistList(var1)
	end

	arg0._fleetAntiAir:AppendCrewUnit(arg1)
	arg0._fleetStaticSonar:AppendCrewUnit(arg1)

	local var2 = 1
	local var3 = #arg0._unitList
	local var4 = {}

	while var2 < var3 do
		table.insert(var4, var2)

		var2 = var2 + 1
	end

	table.insert(var4, #arg0._scoutList, var2)
	arg0:refreshFleetFormation(var4)
end

function var9.appendMainUnit(arg0, arg1)
	if #arg0._mainList == 0 then
		arg0._flagShip = arg1
	end

	arg0._mainList[#arg0._mainList + 1] = arg1

	arg1:SetMainUnitIndex(#arg0._mainList)

	if ShipType.CloakShipType(arg1:GetTemplate().type) then
		arg0:AttachCloak(arg1)
	end

	local var0 = arg1:GetChargeList()

	for iter0, iter1 in ipairs(var0) do
		arg0._chargeWeaponVO:AppendWeapon(iter1)
	end

	local var1 = arg1:GetTorpedoList()

	for iter2, iter3 in ipairs(var1) do
		arg0._torpedoWeaponVO:AppendWeapon(iter3)
	end

	if #arg1:GetHiveList() > 0 then
		local var2 = var7.CreateAllInStrike(arg1)

		for iter4, iter5 in ipairs(var2) do
			arg0._airAssistVO:AppendWeapon(iter5)
		end

		arg1:SetAirAssistList(var2)
	end

	arg0._fleetAntiAir:AppendCrewUnit(arg1)
	arg0._fleetRangeAntiAir:AppendCrewUnit(arg1)
	arg0._fleetStaticSonar:AppendCrewUnit(arg1)

	local var3 = {}

	for iter6, iter7 in ipairs(arg0._unitList) do
		table.insert(var3, iter6)
	end

	arg0:refreshFleetFormation(var3)
end

function var9.appendSubUnit(arg0, arg1)
	arg0._subList[#arg0._subList + 1] = arg1

	arg1:SetMainUnitIndex(#arg0._subList)
end

function var9.FleetWarcry(arg0)
	local var0
	local var1 = math.random(0, 1)
	local var2 = arg0:GetScoutList()[1]
	local var3 = arg0:GetMainList()[1]

	if var3 == nil or var1 == 0 then
		var0 = var2
	elseif var1 == 1 then
		var0 = var3
	end

	local var4 = "battle"
	local var5 = var0:GetIntimacy()
	local var6 = var0.Battle.BattleDataFunction.GetWords(var0:GetSkinID(), var4, var5)

	var0:DispatchVoice(var4)
	var0:DispatchChat(var6, 2.5, var4)
end

function var9.FleetUnitSpwanFinish(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0._unitList) do
		var0 = var0 + iter1:GetGearScore()
	end

	for iter2, iter3 in ipairs(arg0._unitList) do
		var8.SetCurrent(iter3, "fleetGS", var0)
	end
end

function var9.SubWarcry(arg0)
	local var0 = arg0:GetSubList()[1]
	local var1 = "battle"
	local var2 = var0:GetIntimacy()
	local var3 = var0.Battle.BattleDataFunction.GetWords(var0:GetSkinID(), var1, var2)

	var0:DispatchVoice(var1)
	var0:DispatchChat(var3, 2.5, var1)
end

function var9.SetWeaponBlock(arg0, arg1)
	arg0._blockCast = arg0._blockCast + arg1
end

function var9.GetWeaponBlock(arg0)
	return arg0._blockCast > 0
end

function var9.CastChargeWeapon(arg0)
	if arg0:GetWeaponBlock() then
		return
	end

	local var0 = arg0._chargeWeaponVO:GetCurrentWeapon()

	if var0 ~= nil and var0:GetCurrentState() == var0.STATE_READY then
		var0:Charge()

		local var1 = {}
		local var2 = var0.Event.New(var0.Battle.BattleUnitEvent.POINT_HIT_CHARGE, var1)

		arg0:DispatchEvent(var2)
	end
end

function var9.CancelChargeWeapon(arg0)
	local var0 = arg0._chargeWeaponVO:GetCurrentWeapon()

	if var0 ~= nil and var0:GetCurrentState() == var0.STATE_PRECAST then
		local var1 = {}
		local var2 = var0.Event.New(var0.Battle.BattleUnitEvent.POINT_HIT_CANCEL, var1)

		arg0:DispatchEvent(var2)
		var0:CancelCharge()
	end
end

function var9.UnleashChrageWeapon(arg0)
	if arg0:GetWeaponBlock() then
		arg0:CancelChargeWeapon()

		return
	end

	local var0 = arg0._chargeWeaponVO:GetCurrentWeapon()

	if var0 ~= nil and var0:GetCurrentState() == var0.STATE_PRECAST then
		if var0:IsStrikeMode() then
			local var1 = arg0._motionVO:GetPos().x + var5.ChargeWeaponConfig.SIGHT_C
			local var2 = math.min(var1, arg0._totalRightBound)

			arg0:fireChargeWeapon(var0, true, Vector3.New(var2, 0, arg0._motionVO:GetPos().z))
		else
			var0:CancelCharge()
		end

		local var3 = {}
		local var4 = var0.Event.New(var0.Battle.BattleUnitEvent.POINT_HIT_CANCEL, var3)

		arg0:DispatchEvent(var4)
	end
end

function var9.QuickTagChrageWeapon(arg0, arg1)
	if arg0:GetWeaponBlock() then
		return
	end

	local var0 = arg0._chargeWeaponVO:GetCurrentWeapon()

	if var0 ~= nil and var0:GetCurrentState() == var0.STATE_READY then
		var0:QuickTag()

		if #var0:GetLockList() <= 0 then
			var0:CancelQuickTag()
		else
			arg0:fireChargeWeapon(var0, arg1)
		end
	end
end

function var9.fireChargeWeapon(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetHost()

	local function var1()
		local function var0()
			arg1:Fire(arg3)
		end

		arg1:DispatchBlink(var0)
	end

	if arg2 then
		if arg0._IFF == var5.FRIENDLY_CODE then
			arg0._chargeWeaponVO:PlayCutIn(var0, 1 / var5.FOCUS_MAP_RATE)
		end

		arg0._chargeWeaponVO:PlayFocus(var0, var1)
	else
		if arg0._IFF == var5.FRIENDLY_CODE then
			arg0._chargeWeaponVO:PlayCutIn(var0, 1)
		end

		var1()
	end
end

function var9.UnleashAllInStrike(arg0)
	if arg0:GetWeaponBlock() then
		return
	end

	local var0 = arg0._airAssistVO:GetCurrentWeapon()

	if var0 and var0:GetCurrentState() == var0.STATE_READY then
		local var1 = var0:GetHost()

		if arg0._IFF == var5.FRIENDLY_CODE and var1:IsMainFleetUnit() then
			arg0._airAssistVO:PlayCutIn(var1, 1)
		end

		var0:CLSBullet()
		var0:DispatchBlink()
		var0:Fire()
	end
end

function var9.CastTorpedo(arg0)
	if arg0:GetWeaponBlock() then
		return
	end

	local var0 = arg0._torpedoWeaponVO:GetCurrentWeapon()

	if var0 ~= nil and var0:GetCurrentState() == var0.STATE_READY then
		var0:Prepar()
	end
end

function var9.CancelTorpedo(arg0)
	local var0 = arg0._torpedoWeaponVO:GetCurrentWeapon()

	if var0 ~= nil and var0:GetCurrentState() == var0.STATE_PRECAST then
		var0:Cancel()
	end
end

function var9.UnleashTorpedo(arg0)
	if arg0:GetWeaponBlock() then
		arg0:CancelTorpedo()

		return
	end

	local var0 = arg0._torpedoWeaponVO:GetCurrentWeapon()

	if var0 ~= nil and var0:GetCurrentState() == var0.STATE_PRECAST then
		var0:Fire()
	end
end

function var9.QuickCastTorpedo(arg0)
	if arg0:GetWeaponBlock() then
		return
	end

	local var0 = arg0._torpedoWeaponVO:GetCurrentWeapon()

	if var0 ~= nil and var0:GetCurrentState() == var0.STATE_READY then
		var0:Fire(true)
	end
end

function var9.RemoveManunalTorpedo(arg0, arg1)
	if arg1:IsAttacking() then
		arg0:CancelTorpedo()
	end

	arg0._torpedoWeaponVO:RemoveWeapon(arg1)
	arg1:Clear()
end

function var9.CoupleEncourage(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg0._unitList) do
		local var2 = iter1:GetIntimacy()
		local var3 = var7.GetWords(iter1:GetSkinID(), "couple_encourage", var2)

		if #var3 > 0 then
			var0[iter1] = var3
		end
	end

	local var4 = var4.CPChatType
	local var5 = var4.CPChatTargetFunc

	local function var6(arg0, arg1)
		local var0 = {}

		if arg0 == var4.GROUP_ID then
			var0.groupIDList = arg1
		elseif arg0 == var4.SHIP_TYPE then
			var0.ship_type_list = arg1
		elseif arg0 == var4.RARE then
			var0.rarity = arg1[1]
		elseif arg0 == var4.NATIONALITY then
			var0.nationality = arg1[1]
		elseif arg0 == var4.ILLUSTRATOR then
			var0.illustrator = arg1[1]
		elseif arg0 == var4.TEAM then
			var0.teamIndex = arg1[1]
		end

		return var0
	end

	for iter2, iter3 in pairs(var0) do
		for iter4, iter5 in ipairs(iter3) do
			local var7 = iter5[1]
			local var8 = iter5[2]
			local var9 = iter5[4] or var4.GROUP_ID
			local var10 = var0.Battle.BattleTargetChoise.TargetAllHelp(iter2)

			if type(var9) == "table" then
				for iter6, iter7 in ipairs(var9) do
					local var11 = var6(iter7, var7[iter6])

					var10 = var0.Battle.BattleTargetChoise[var5[iter7]](iter2, var11, var10)
				end
			elseif type(var9) == "number" then
				local var12 = var6(var9, var7)

				var10 = var0.Battle.BattleTargetChoise[var5[var9]](iter2, var12, var10)
			end

			if var8 <= #var10 then
				local var13 = {
					cp = iter2,
					content = iter5[3],
					linkIndex = iter4
				}

				var1[#var1 + 1] = var13
			end
		end
	end

	if #var1 > 0 then
		local var14 = var1[math.random(#var1)]
		local var15 = "link" .. var14.linkIndex

		var14.cp:DispatchVoice(var15)
		var14.cp:DispatchChat(var14.content, 3, var15)
	end
end

function var9.onUnitUpdateHP(arg0, arg1)
	local var0 = arg1.Dispatcher
	local var1 = arg1.Data.dHP

	for iter0, iter1 in ipairs(arg0._unitList) do
		iter1:TriggerBuff(var4.BuffEffectType.ON_FRIENDLY_HP_RATIO_UPDATE, {
			unit = var0,
			dHP = var1
		})

		if iter1 ~= var0 then
			iter1:TriggerBuff(var4.BuffEffectType.ON_TEAMMATE_HP_RATIO_UPDATE, {
				unit = var0,
				dHP = var1
			})
		end
	end
end

function var9.SetSubUnitData(arg0, arg1)
	arg0._subUntiDataList = arg1
end

function var9.GetSubUnitData(arg0)
	return arg0._subUntiDataList
end

function var9.AddSubMarine(arg0, arg1)
	arg1:InitOxygen()

	local var0 = arg1:GetTemplate()
	local var1 = var0.Battle.BattleUnitPhaseSwitcher.New(arg1)

	local function var2()
		return arg1:GetRaidDuration()
	end

	var1:SetTemplateData(var7.GeneratePlayerSubmarinPhase(arg0._subAttackBaseLine, arg0._subRetreatBaseLine, arg1:GetAttrByName("raidDist"), var2, arg1:GetAttrByName("oxyAtkDuration")))

	arg0._unitList[#arg0._unitList + 1] = arg1
	arg0._subList[#arg0._subList + 1] = arg1

	arg1:SetFleetVO(arg0)
	arg1:RegisterEventListener(arg0, var1.UPDATE_HP, arg0.onUnitUpdateHP)
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

function var9.AppendIndieSonar(arg0, arg1, arg2)
	local var0 = var0.Battle.BattleIndieSonar.New(arg0, arg1, arg2)

	var0:SwitchHost(arg0._motionReferenceUnit)

	arg0._indieSonarList[var0] = true

	var0:Detect()
end

function var9.RemoveIndieSonar(arg0, arg1)
	for iter0, iter1 in pairs(arg0._indieSonarList) do
		if arg1 == iter0 then
			arg0._indieSonarList[iter0] = nil

			break
		end
	end
end

function var9.AttachFleetBuff(arg0, arg1)
	local var0 = arg1:GetID()
	local var1 = arg0:GetFleetBuff(var0)

	if var1 then
		var1:Stack(arg0)
	else
		arg0._buffList[var0] = arg1

		arg1:Attach(arg0)
	end
end

function var9.RemoveFleetBuff(arg0, arg1)
	local var0 = arg0:GetFleetBuff(arg1)

	if var0 then
		var0:Remove()
	end
end

function var9.GetFleetBuff(arg0, arg1)
	return arg0._buffList[arg1]
end

function var9.GetFleetBuffList(arg0)
	return arg0._buffList
end

function var9.Jamming(arg0, arg1)
	if arg1 then
		arg0._chargeWeaponVO:StartJamming()
		arg0._torpedoWeaponVO:StartJamming()
		arg0._airAssistVO:StartJamming()
	else
		arg0._chargeWeaponVO:JammingEliminate()
		arg0._torpedoWeaponVO:JammingEliminate()
		arg0._airAssistVO:JammingEliminate()
	end
end

function var9.Blinding(arg0, arg1)
	arg0:DispatchEvent(var0.Event.New(var2.FLEET_BLIND, {
		isBlind = arg1
	}))
end

function var9.UpdateHorizon(arg0)
	arg0:DispatchEvent(var0.Event.New(var2.FLEET_HORIZON_UPDATE, {}))
end

function var9.AutoBotUpdated(arg0, arg1)
	local var0 = arg1 and var4.BuffEffectType.ON_AUTOBOT or var4.BuffEffectType.ON_MANUAL

	for iter0, iter1 in ipairs(arg0._unitList) do
		iter1:TriggerBuff(var0)
	end
end

function var9.CloakFatalExpose(arg0)
	for iter0, iter1 in ipairs(arg0._cloakList) do
		iter1:GetCloak():ForceToMax()
	end
end

function var9.CloakInVision(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._cloakList) do
		iter1:GetCloak():AppendExposeSpeed(arg1)
	end
end

function var9.CloakOutVision(arg0)
	for iter0, iter1 in ipairs(arg0._cloakList) do
		iter1:GetCloak():AppendExposeSpeed(0)
	end
end

function var9.AttachCloak(arg0, arg1)
	if not arg1:GetCloak() then
		arg1:InitCloak()

		arg0._cloakList[#arg0._cloakList + 1] = arg1
	end
end

function var9.AttachNightCloak(arg0)
	arg0._scoutAimBias = var0.Battle.BattleUnitAimBiasComponent.New()

	arg0._scoutAimBias:ConfigRangeFormula(var3.CalculateMaxAimBiasRange, var3.CalculateBiasDecay)
	arg0._scoutAimBias:Active(arg0._scoutAimBias.STATE_ACTIVITING)
	arg0:DispatchEvent(var0.Event.New(var2.ADD_AIM_BIAS, {
		aimBias = arg0._scoutAimBias
	}))
end

function var9.GetFleetBias(arg0)
	return arg0._scoutAimBias
end
