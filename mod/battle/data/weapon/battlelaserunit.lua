ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleConfig
local var4_0 = class("BattleLaserUnit", var0_0.Battle.BattleWeaponUnit)

var0_0.Battle.BattleLaserUnit = var4_0
var4_0.__name = "BattleLaserUnit"
var4_0.STATE_ATTACK = "FIB"
var4_0.BEAM_STATE_READY = "beamStateReady"
var4_0.BEAM_STATE_OVER_HEAT = "beamStateOverHeat"

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)
end

function var4_0.Clear(arg0_2)
	if arg0_2._alertTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_2._alertTimer)
	end

	arg0_2._alertTimer = nil

	for iter0_2, iter1_2 in ipairs(arg0_2._beamList) do
		if iter1_2:GetBeamState() == iter1_2.BEAM_STATE_ATTACK then
			arg0_2._dataProxy:RemoveAreaOfEffect(iter1_2:GetAoeData():GetUniqueID())
		end

		iter1_2:ClearBeam()
	end

	var4_0.super.Clear(arg0_2)
end

function var4_0.Update(arg0_3)
	arg0_3:UpdateReload()

	if arg0_3._currentState == arg0_3.STATE_READY then
		arg0_3:updateMovementInfo()

		local var0_3 = arg0_3:Tracking()

		if var0_3 then
			if arg0_3._preCastInfo.time ~= nil then
				arg0_3:PreCast(var0_3)
			else
				arg0_3._currentState = arg0_3.STATE_PRECAST_FINISH
			end
		end
	end

	if arg0_3._currentState == arg0_3.STATE_PRECAST then
		-- block empty
	elseif arg0_3._currentState == arg0_3.STATE_PRECAST_FINISH then
		arg0_3:updateMovementInfo()
		arg0_3:Fire(arg0_3:Tracking())
	end

	if arg0_3._attackStartTime then
		arg0_3:updateMovementInfo()
		arg0_3:updateBeamList()
	end
end

function var4_0.DoAttack(arg0_4, arg1_4)
	if arg1_4 == nil or not arg1_4:IsAlive() or arg0_4:outOfFireRange(arg1_4) then
		arg1_4 = nil
	end

	arg0_4._attackStartTime = pg.TimeMgr.GetInstance():GetCombatTime()

	if arg0_4._tmpData.aim_type == var2_0.WeaponAimType.AIM and arg1_4 ~= nil then
		arg0_4._aimPos = arg1_4:GetBeenAimedPosition()
	end

	arg0_4:cacheBulletID()

	for iter0_4, iter1_4 in ipairs(arg0_4._beamList) do
		iter1_4:ChangeBeamState(iter1_4.BEAM_STATE_READY)

		if var1_0.GetBarrageTmpDataFromID(iter1_4:GetBeamInfoID()).first_delay == 0 then
			arg0_4:createBeam(iter1_4)
		end
	end

	var0_0.Battle.PlayBattleSFX(arg0_4._tmpData.fire_sfx)
	arg0_4:TriggerBuffOnFire()
	arg0_4:CheckAndShake()
end

function var4_0.SetTemplateData(arg0_5, arg1_5)
	var4_0.super.SetTemplateData(arg0_5, arg1_5)
	arg0_5:initBeamList()
end

function var4_0.initBeamList(arg0_6)
	local var0_6 = arg0_6._tmpData.barrage_ID
	local var1_6 = arg0_6._tmpData.bullet_ID

	arg0_6._alertList = {}
	arg0_6._beamList = {}

	for iter0_6, iter1_6 in ipairs(var1_6) do
		arg0_6._beamList[iter0_6] = var0_0.Battle.BattleBeamUnit.New(iter1_6, var0_6[iter0_6])
	end
end

function var4_0.updateBeamList(arg0_7)
	local var0_7 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0_7._attackStartTime
	local var1_7 = 0

	for iter0_7, iter1_7 in ipairs(arg0_7._beamList) do
		if iter1_7:GetBeamState() == iter1_7.BEAM_STATE_READY then
			if var0_7 > var1_0.GetBarrageTmpDataFromID(iter1_7:GetBeamInfoID()).first_delay then
				arg0_7:createBeam(iter1_7)
			end
		elseif iter1_7:GetBeamState() == iter1_7.BEAM_STATE_ATTACK then
			if not iter1_7:IsBeamActive() then
				iter1_7:ClearBeam()

				var1_7 = var1_7 + 1
			else
				iter1_7:UpdateBeamPos(arg0_7._hostPos)
				iter1_7:UpdateBeamAngle()

				if iter1_7:CanDealDamage() then
					arg0_7:doBeamDamage(iter1_7)
				end
			end
		elseif iter1_7:GetBeamState() == iter1_7.BEAM_STATE_FINISH then
			var1_7 = var1_7 + 1
		end
	end

	if var1_7 == #arg0_7._beamList then
		arg0_7:EnterCoolDown()
	end
end

function var4_0.createBeam(arg0_8, arg1_8)
	local function var0_8(arg0_9)
		for iter0_9, iter1_9 in ipairs(arg0_9) do
			if iter1_9.Active then
				local var0_9 = arg0_8._dataProxy:GetUnitList()[iter1_9.UID]

				arg1_8:AddCldUnit(var0_9)
			end
		end
	end

	local function var1_8(arg0_10)
		if arg0_10.Active then
			local var0_10 = arg0_8._dataProxy:GetUnitList()[arg0_10.UID]

			arg1_8:RemoveCldUnit(var0_10)
		end
	end

	local var2_8 = var1_0.GetBarrageTmpDataFromID(arg1_8:GetBeamInfoID())
	local var3_8 = var1_0.GetBulletTmpDataFromID(arg1_8:GetBulletID())
	local var4_8 = var2_8.offset_x
	local var5_8 = var2_8.offset_z
	local var6_8 = var2_8.delta_offset_x
	local var7_8 = var2_8.delta_offset_z
	local var8_8 = var2_8.delay
	local var9_8 = arg0_8._host:GetIFF()
	local var10_8 = Vector3(arg0_8._hostPos.x + var4_8, 0, arg0_8._hostPos.z + var5_8)
	local var11_8 = arg0_8._dataProxy:SpawnLastingCubeArea(var2_0.AOEField.SURFACE, var9_8, var10_8, var6_8, var7_8, var8_8, var0_8, var1_8, false, var3_8.modle_ID)

	if arg0_8._aimPos == nil then
		arg1_8:SetAimAngle(0)
	elseif var2_8.offset_prioritise then
		arg1_8:SetAimPosition(arg0_8._aimPos, var10_8, var9_8)
	else
		local var12_8

		if var9_8 == var3_0.FRIENDLY_CODE then
			var12_8 = math.rad2Deg * math.atan2(arg0_8._aimPos.z - arg0_8._hostPos.z, arg0_8._aimPos.x - arg0_8._hostPos.x)
		elseif var9_8 == var3_0.FOE_CODE then
			var12_8 = math.rad2Deg * math.atan2(arg0_8._hostPos.z - arg0_8._aimPos.z, arg0_8._hostPos.x - arg0_8._aimPos.x)
		end

		arg1_8:SetAimAngle(var12_8)
	end

	if var9_8 == var3_0.FRIENDLY_CODE then
		var11_8:SetAnchorPointAlignment(var11_8.ALIGNMENT_LEFT)
	elseif var9_8 == var3_0.FOE_CODE then
		var11_8:SetAnchorPointAlignment(var11_8.ALIGNMENT_RIGHT)
	end

	var11_8:SetFXStatic(true)
	arg1_8:SetAoeData(var11_8)
	arg1_8:BeginFocus()
	arg1_8:ChangeBeamState(arg1_8.BEAM_STATE_ATTACK)
end

function var4_0.doBeamDamage(arg0_11, arg1_11)
	arg1_11:DealDamage()

	local var0_11 = arg0_11:Spawn(arg1_11:GetBulletID())
	local var1_11 = arg1_11:GetCldUnitList()

	for iter0_11, iter1_11 in pairs(var1_11) do
		if not iter1_11:IsAlive() or arg1_11:GetBeamExtraParam().mainFilter == true and iter1_11:IsMainFleetUnit() then
			-- block empty
		else
			arg0_11._dataProxy:HandleDamage(var0_11, iter1_11)

			local var2_11, var3_11 = var0_0.Battle.BattleFXPool.GetInstance():GetFX(arg1_11:GetFXID())

			pg.EffectMgr.GetInstance():PlayBattleEffect(var2_11, var3_11:Add(iter1_11:GetPosition()), true)
			var0_0.Battle.PlayBattleSFX(arg1_11:GetSFXID())
		end
	end

	arg0_11._dataProxy:RemoveBulletUnit(var0_11:GetUniqueID())
end

function var4_0.EnterCoolDown(arg0_12)
	arg0_12._attackStartTime = nil

	var4_0.super.EnterCoolDown(arg0_12)
end
