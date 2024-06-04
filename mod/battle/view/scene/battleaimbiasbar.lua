ys = ys or {}

local var0 = ys

var0.Battle.BattleAimbiasBar = class("BattleAimbiasBar")
var0.Battle.BattleAimbiasBar.__name = "BattleAimbiasBar"

local var1 = var0.Battle.BattleAimbiasBar

var1.WARNING_VALUE = 0.1

function var1.Ctor(arg0, arg1)
	arg0._aimBiasBar = arg1
	arg0._aimBiasBarGO = arg0._aimBiasBar.gameObject
	arg0._progress = arg0._aimBiasBar:Find("bias"):GetComponent(typeof(Image))
	arg0._warning = arg0._aimBiasBar:Find("warning")
	arg0._lock = arg0._aimBiasBar:Find("lock")
	arg0._recovery = arg0._aimBiasBar:Find("recovery")

	setActive(arg0._lock, false)
	setActive(arg0._warning, false)
	setActive(arg0._progress, true)
	setActive(arg0._aimBiasBar, true)
	setActive(arg0._recovery, true)

	arg0._cacheSpeed = 0
	arg0._cacheWarningFlag = 0
	arg0._lockBlock = false
end

function var1.SetActive(arg0, arg1)
	setActive(arg0._aimBiasBar, arg1)
end

function var1.ConfigAimBias(arg0, arg1)
	arg0._aimBiasComponent = arg1
	arg0._hostile = arg1:IsHostile()
end

function var1.UpdateLockStateView(arg0)
	local var0 = arg0._aimBiasComponent:GetCurrentState() == arg0._aimBiasComponent.STATE_SKILL_EXPOSE

	setActive(arg0._lock, var0)

	if var0 then
		setActive(arg0._recovery, false)
		setActive(arg0._warning, false)
	elseif arg0._aimBiasComponent:GetDecayRatioSpeed() < 0 then
		setActive(arg0._recovery, true)
	elseif not arg0._hostile then
		local var1 = arg0._aimBiasComponent:GetCurrentRate()

		if var1 < var1.WARNING_VALUE and var1 > 0 then
			setActive(arg0._warning, true)
		end
	end

	arg0._lockBlock = var0
end

function var1.UpdateAimBiasProgress(arg0)
	local var0 = arg0._aimBiasComponent:GetCurrentRate()

	arg0._progress.fillAmount = var0

	local var1 = arg0._aimBiasComponent:GetDecayRatioSpeed()
	local var2 = var0 - var1.WARNING_VALUE

	if not arg0._lockBlock then
		local var3 = var1 < 0

		if var1 * arg0._cacheSpeed <= 0 then
			setActive(arg0._recovery, var3)
		end

		if not arg0._hostile then
			if var0 <= 0 then
				setActive(arg0._warning, false)
			elseif not var3 and var2 * arg0._cacheWarningFlag < 0 then
				setActive(arg0._warning, var0 < var1.WARNING_VALUE)
			end
		end
	end

	if arg0._hostile and var0 <= 0 then
		setActive(arg0._aimBiasBar, false)
	end

	arg0._cacheSpeed = var1
	arg0._cacheWarningFlag = var2
end

function var1.UpdateAimBiasConfig(arg0)
	return
end

function var1.Dispose(arg0)
	arg0._aimBiasBar = nil
	arg0._progress = nil
	arg0._warning = nil
	arg0._lock = nil
	arg0._aimBiasBarGO = nil
end

function var1.GetGO(arg0)
	return arg0._aimBiasBarGO
end
