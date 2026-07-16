ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleRecoilShieldBar = class("BattleRecoilShieldBar")
var0_0.Battle.BattleRecoilShieldBar.__name = "BattleRecoilShieldBar"

local var1_0 = var0_0.Battle.BattleRecoilShieldBar

var1_0.WARNING_VALUE = 0.1

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._recoilShieldBar = arg1_1
	arg0_1._recoilShieldBarGO = arg0_1._recoilShieldBar.gameObject
	arg0_1._progress = arg0_1._recoilShieldBar:Find("shield"):GetComponent(typeof(Image))

	setActive(arg0_1._progress, true)
	setActive(arg0_1._recoilShieldBar, true)

	arg0_1._lockBlock = false
end

function var1_0.SetActive(arg0_2, arg1_2)
	setActive(arg0_2._recoilShieldBar, arg1_2)
end

function var1_0.ConfigShieldBuff(arg0_3, arg1_3)
	arg0_3._recoilShieldBuffEffect = arg1_3
end

function var1_0.UpdateRecoilShieldProgress(arg0_4)
	local var0_4 = arg0_4._recoilShieldBuffEffect:GetCurrentRate()

	arg0_4._progress.fillAmount = var0_4
end

function var1_0.Dispose(arg0_5)
	arg0_5._recoilShieldBar = nil
	arg0_5._progress = nil
	arg0_5._recoilShieldBarGO = nil
end

function var1_0.GetGO(arg0_6)
	return arg0_6._aimBiasBarGO
end
