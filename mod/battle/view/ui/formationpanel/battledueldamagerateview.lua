ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleDuelDamageRateView")

var0_0.Battle.BattleDuelDamageRateView = var3_0
var3_0.__name = "BattleDuelDamageRateView"

function var3_0.Ctor(arg0_1, arg1_1)
	var0_0.EventListener.AttachEventListener(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._progressList = {}
	arg0_1._rateBarList = {}
	arg0_1._fleetList = {}
	arg0_1._rateBarList[var2_0.FRIENDLY_CODE] = arg0_1._tf:Find("leftDamageBar")
	arg0_1._rateBarList[var2_0.FOE_CODE] = arg0_1._tf:Find("rightDamageBar")
end

function var3_0.SetActive(arg0_2, arg1_2)
	setActive(arg0_2._go, arg1_2)
end

function var3_0.SetFleetVO(arg0_3, arg1_3, arg2_3)
	arg0_3._fleetList[arg1_3] = true

	local var0_3 = arg0_3._rateBarList[arg1_3:GetIFF()]

	var0_3:Find("nameText"):GetComponent(typeof(Text)).text = arg2_3.name
	var0_3:Find("LVText"):GetComponent(typeof(Text)).text = "Lv." .. arg2_3.level

	local var1_3 = var0_3:Find("bar/progress"):GetComponent(typeof(Image))

	arg0_3._progressList[arg1_3:GetIFF()] = var1_3

	arg1_3:RegisterEventListener(arg0_3, var1_0.FLEET_DMG_CHANGE, arg0_3.onDMGChange)
end

function var3_0.onDMGChange(arg0_4, arg1_4)
	local var0_4 = arg1_4.Dispatcher
	local var1_4 = var0_4:GetIFF()

	arg0_4._progressList[var1_4].fillAmount = var0_4:GetDamageRatio()
end

function var3_0.Dispose(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5._fleetList) do
		iter0_5:UnregisterEventListener(arg0_5, var1_0.FLEET_DMG_CHANGE)
	end

	arg0_5._rateBarList = nil
	arg0_5._progressList = nil
end
