ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleAimbiasBar = class("BattleAimbiasBar")
var0_0.Battle.BattleAimbiasBar.__name = "BattleAimbiasBar"

local var1_0 = var0_0.Battle.BattleAimbiasBar

var1_0.WARNING_VALUE = 0.1

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._aimBiasBar = arg1_1
	arg0_1._aimBiasBarGO = arg0_1._aimBiasBar.gameObject
	arg0_1._progress = arg0_1._aimBiasBar:Find("bias"):GetComponent(typeof(Image))
	arg0_1._warning = arg0_1._aimBiasBar:Find("warning")
	arg0_1._lock = arg0_1._aimBiasBar:Find("lock")
	arg0_1._recovery = arg0_1._aimBiasBar:Find("recovery")

	setActive(arg0_1._lock, false)
	setActive(arg0_1._warning, false)
	setActive(arg0_1._progress, true)
	setActive(arg0_1._aimBiasBar, true)
	setActive(arg0_1._recovery, true)

	arg0_1._cacheSpeed = 0
	arg0_1._cacheWarningFlag = 0
	arg0_1._lockBlock = false
end

function var1_0.SetActive(arg0_2, arg1_2)
	setActive(arg0_2._aimBiasBar, arg1_2)
end

function var1_0.ConfigAimBias(arg0_3, arg1_3)
	arg0_3._aimBiasComponent = arg1_3
	arg0_3._hostile = arg1_3:IsHostile()
end

function var1_0.UpdateLockStateView(arg0_4)
	local var0_4 = arg0_4._aimBiasComponent:GetCurrentState() == arg0_4._aimBiasComponent.STATE_SKILL_EXPOSE

	setActive(arg0_4._lock, var0_4)

	if var0_4 then
		setActive(arg0_4._recovery, false)
		setActive(arg0_4._warning, false)
	elseif arg0_4._aimBiasComponent:GetDecayRatioSpeed() < 0 then
		setActive(arg0_4._recovery, true)
	elseif not arg0_4._hostile then
		local var1_4 = arg0_4._aimBiasComponent:GetCurrentRate()

		if var1_4 < var1_0.WARNING_VALUE and var1_4 > 0 then
			setActive(arg0_4._warning, true)
		end
	end

	arg0_4._lockBlock = var0_4
end

function var1_0.UpdateAimBiasProgress(arg0_5)
	local var0_5 = arg0_5._aimBiasComponent:GetCurrentRate()

	arg0_5._progress.fillAmount = var0_5

	local var1_5 = arg0_5._aimBiasComponent:GetDecayRatioSpeed()
	local var2_5 = var0_5 - var1_0.WARNING_VALUE

	if not arg0_5._lockBlock then
		local var3_5 = var1_5 < 0

		if var1_5 * arg0_5._cacheSpeed <= 0 then
			setActive(arg0_5._recovery, var3_5)
		end

		if not arg0_5._hostile then
			if var0_5 <= 0 then
				setActive(arg0_5._warning, false)
			elseif not var3_5 and var2_5 * arg0_5._cacheWarningFlag < 0 then
				setActive(arg0_5._warning, var0_5 < var1_0.WARNING_VALUE)
			end
		end
	end

	if arg0_5._hostile and var0_5 <= 0 then
		setActive(arg0_5._aimBiasBar, false)
	end

	arg0_5._cacheSpeed = var1_5
	arg0_5._cacheWarningFlag = var2_5
end

function var1_0.UpdateAimBiasConfig(arg0_6)
	return
end

function var1_0.Dispose(arg0_7)
	arg0_7._aimBiasBar = nil
	arg0_7._progress = nil
	arg0_7._warning = nil
	arg0_7._lock = nil
	arg0_7._aimBiasBarGO = nil
end

function var1_0.GetGO(arg0_8)
	return arg0_8._aimBiasBarGO
end
