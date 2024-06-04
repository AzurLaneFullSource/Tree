ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleConfig
local var4 = class("BattleLaserUnit", var0.Battle.BattleWeaponUnit)

var0.Battle.BattleLaserUnit = var4
var4.__name = "BattleLaserUnit"
var4.STATE_ATTACK = "FIB"
var4.BEAM_STATE_READY = "beamStateReady"
var4.BEAM_STATE_OVER_HEAT = "beamStateOverHeat"

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)
end

function var4.Clear(arg0)
	if arg0._alertTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._alertTimer)
	end

	arg0._alertTimer = nil

	for iter0, iter1 in ipairs(arg0._beamList) do
		if iter1:GetBeamState() == iter1.BEAM_STATE_ATTACK then
			arg0._dataProxy:RemoveAreaOfEffect(iter1:GetAoeData():GetUniqueID())
		end

		iter1:ClearBeam()
	end

	var4.super.Clear(arg0)
end

function var4.Update(arg0)
	arg0:UpdateReload()

	if arg0._currentState == arg0.STATE_READY then
		arg0:updateMovementInfo()

		local var0 = arg0:Tracking()

		if var0 then
			if arg0._preCastInfo.time ~= nil then
				arg0:PreCast(var0)
			else
				arg0._currentState = arg0.STATE_PRECAST_FINISH
			end
		end
	end

	if arg0._currentState == arg0.STATE_PRECAST then
		-- block empty
	elseif arg0._currentState == arg0.STATE_PRECAST_FINISH then
		arg0:updateMovementInfo()
		arg0:Fire(arg0:Tracking())
	end

	if arg0._attackStartTime then
		arg0:updateMovementInfo()
		arg0:updateBeamList()
	end
end

function var4.DoAttack(arg0, arg1)
	if arg1 == nil or not arg1:IsAlive() or arg0:outOfFireRange(arg1) then
		arg1 = nil
	end

	arg0._attackStartTime = pg.TimeMgr.GetInstance():GetCombatTime()

	if arg0._tmpData.aim_type == var2.WeaponAimType.AIM and arg1 ~= nil then
		arg0._aimPos = arg1:GetBeenAimedPosition()
	end

	arg0:cacheBulletID()

	for iter0, iter1 in ipairs(arg0._beamList) do
		iter1:ChangeBeamState(iter1.BEAM_STATE_READY)

		if var1.GetBarrageTmpDataFromID(iter1:GetBeamInfoID()).first_delay == 0 then
			arg0:createBeam(iter1)
		end
	end

	var0.Battle.PlayBattleSFX(arg0._tmpData.fire_sfx)
	arg0:TriggerBuffOnFire()
	arg0:CheckAndShake()
end

function var4.SetTemplateData(arg0, arg1)
	var4.super.SetTemplateData(arg0, arg1)
	arg0:initBeamList()
end

function var4.initBeamList(arg0)
	local var0 = arg0._tmpData.barrage_ID
	local var1 = arg0._tmpData.bullet_ID

	arg0._alertList = {}
	arg0._beamList = {}

	for iter0, iter1 in ipairs(var1) do
		arg0._beamList[iter0] = var0.Battle.BattleBeamUnit.New(iter1, var0[iter0])
	end
end

function var4.updateBeamList(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0._attackStartTime
	local var1 = 0

	for iter0, iter1 in ipairs(arg0._beamList) do
		if iter1:GetBeamState() == iter1.BEAM_STATE_READY then
			if var0 > var1.GetBarrageTmpDataFromID(iter1:GetBeamInfoID()).first_delay then
				arg0:createBeam(iter1)
			end
		elseif iter1:GetBeamState() == iter1.BEAM_STATE_ATTACK then
			if not iter1:IsBeamActive() then
				iter1:ClearBeam()

				var1 = var1 + 1
			else
				iter1:UpdateBeamPos(arg0._hostPos)
				iter1:UpdateBeamAngle()

				if iter1:CanDealDamage() then
					arg0:doBeamDamage(iter1)
				end
			end
		elseif iter1:GetBeamState() == iter1.BEAM_STATE_FINISH then
			var1 = var1 + 1
		end
	end

	if var1 == #arg0._beamList then
		arg0:EnterCoolDown()
	end
end

function var4.createBeam(arg0, arg1)
	local function var0(arg0)
		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				local var0 = arg0._dataProxy:GetUnitList()[iter1.UID]

				arg1:AddCldUnit(var0)
			end
		end
	end

	local function var1(arg0)
		if arg0.Active then
			local var0 = arg0._dataProxy:GetUnitList()[arg0.UID]

			arg1:RemoveCldUnit(var0)
		end
	end

	local var2 = var1.GetBarrageTmpDataFromID(arg1:GetBeamInfoID())
	local var3 = var1.GetBulletTmpDataFromID(arg1:GetBulletID())
	local var4 = var2.offset_x
	local var5 = var2.offset_z
	local var6 = var2.delta_offset_x
	local var7 = var2.delta_offset_z
	local var8 = var2.delay
	local var9 = arg0._host:GetIFF()
	local var10 = Vector3(arg0._hostPos.x + var4, 0, arg0._hostPos.z + var5)
	local var11 = arg0._dataProxy:SpawnLastingCubeArea(var2.AOEField.SURFACE, var9, var10, var6, var7, var8, var0, var1, false, var3.modle_ID)

	if arg0._aimPos == nil then
		arg1:SetAimAngle(0)
	elseif var2.offset_prioritise then
		arg1:SetAimPosition(arg0._aimPos, var10, var9)
	else
		local var12

		if var9 == var3.FRIENDLY_CODE then
			var12 = math.rad2Deg * math.atan2(arg0._aimPos.z - arg0._hostPos.z, arg0._aimPos.x - arg0._hostPos.x)
		elseif var9 == var3.FOE_CODE then
			var12 = math.rad2Deg * math.atan2(arg0._hostPos.z - arg0._aimPos.z, arg0._hostPos.x - arg0._aimPos.x)
		end

		arg1:SetAimAngle(var12)
	end

	if var9 == var3.FRIENDLY_CODE then
		var11:SetAnchorPointAlignment(var11.ALIGNMENT_LEFT)
	elseif var9 == var3.FOE_CODE then
		var11:SetAnchorPointAlignment(var11.ALIGNMENT_RIGHT)
	end

	var11:SetFXStatic(true)
	arg1:SetAoeData(var11)
	arg1:BeginFocus()
	arg1:ChangeBeamState(arg1.BEAM_STATE_ATTACK)
end

function var4.doBeamDamage(arg0, arg1)
	arg1:DealDamage()

	local var0 = arg0:Spawn(arg1:GetBulletID())
	local var1 = arg1:GetCldUnitList()

	for iter0, iter1 in pairs(var1) do
		if not iter1:IsAlive() or arg1:GetBeamExtraParam().mainFilter == true and iter1:IsMainFleetUnit() then
			-- block empty
		else
			arg0._dataProxy:HandleDamage(var0, iter1)

			local var2, var3 = var0.Battle.BattleFXPool.GetInstance():GetFX(arg1:GetFXID())

			pg.EffectMgr.GetInstance():PlayBattleEffect(var2, var3:Add(iter1:GetPosition()), true)
			var0.Battle.PlayBattleSFX(arg1:GetSFXID())
		end
	end

	arg0._dataProxy:RemoveBulletUnit(var0:GetUniqueID())
end

function var4.EnterCoolDown(arg0)
	arg0._attackStartTime = nil

	var4.super.EnterCoolDown(arg0)
end
