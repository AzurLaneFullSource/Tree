ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleDuelDamageRateView")

var0.Battle.BattleDuelDamageRateView = var3
var3.__name = "BattleDuelDamageRateView"

function var3.Ctor(arg0, arg1)
	var0.EventListener.AttachEventListener(arg0)

	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0._progressList = {}
	arg0._rateBarList = {}
	arg0._fleetList = {}
	arg0._rateBarList[var2.FRIENDLY_CODE] = arg0._tf:Find("leftDamageBar")
	arg0._rateBarList[var2.FOE_CODE] = arg0._tf:Find("rightDamageBar")
end

function var3.SetActive(arg0, arg1)
	setActive(arg0._go, arg1)
end

function var3.SetFleetVO(arg0, arg1, arg2)
	arg0._fleetList[arg1] = true

	local var0 = arg0._rateBarList[arg1:GetIFF()]

	var0:Find("nameText"):GetComponent(typeof(Text)).text = arg2.name
	var0:Find("LVText"):GetComponent(typeof(Text)).text = "Lv." .. arg2.level

	local var1 = var0:Find("bar/progress"):GetComponent(typeof(Image))

	arg0._progressList[arg1:GetIFF()] = var1

	arg1:RegisterEventListener(arg0, var1.FLEET_DMG_CHANGE, arg0.onDMGChange)
end

function var3.onDMGChange(arg0, arg1)
	local var0 = arg1.Dispatcher
	local var1 = var0:GetIFF()

	arg0._progressList[var1].fillAmount = var0:GetDamageRatio()
end

function var3.Dispose(arg0)
	for iter0, iter1 in pairs(arg0._fleetList) do
		iter0:UnregisterEventListener(arg0, var1.FLEET_DMG_CHANGE)
	end

	arg0._rateBarList = nil
	arg0._progressList = nil
end
