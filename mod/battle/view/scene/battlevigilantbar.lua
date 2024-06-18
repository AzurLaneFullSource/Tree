ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleVigilantBar = class("BattleVigilantBar")
var0_0.Battle.BattleVigilantBar.__name = "BattleVigilantBar"

local var1_0 = var0_0.Battle.BattleVigilantBar

var1_0.MIN = 0.267
var1_0.MAX = 0.7335
var1_0.METER_LENGTH = var1_0.MAX - var1_0.MIN
var1_0.STATE_CALM = 0
var1_0.STATE_SUSPICIOUS = 1
var1_0.STATE_VIGILANT = 2
var1_0.STATE_ENGAGE = 3

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._vigilantBar = arg1_1
	arg0_1._vigilantBarGO = arg0_1._vigilantBar.gameObject
	arg0_1._progress = arg0_1._vigilantBar:Find("progress"):GetComponent(typeof(Image))
	arg0_1._markList = {}
	arg0_1._markList[var1_0.STATE_CALM] = arg0_1._vigilantBar:Find("mark/" .. var1_0.STATE_CALM)
	arg0_1._markList[var1_0.STATE_SUSPICIOUS] = arg0_1._vigilantBar:Find("mark/" .. var1_0.STATE_SUSPICIOUS)
	arg0_1._markList[var1_0.STATE_VIGILANT] = arg0_1._vigilantBar:Find("mark/" .. var1_0.STATE_VIGILANT)
	arg0_1._markList[var1_0.STATE_ENGAGE] = arg0_1._vigilantBar:Find("mark/" .. var1_0.STATE_ENGAGE)
end

function var1_0.ConfigVigilant(arg0_2, arg1_2)
	arg0_2._vigilantState = arg1_2
end

function var1_0.UpdateVigilantProgress(arg0_3)
	local var0_3 = arg0_3._vigilantState:GetVigilantRate()

	arg0_3._progress.fillAmount = arg0_3.meterConvert(var0_3)
end

function var1_0.UpdateVigilantMark(arg0_4)
	local var0_4 = arg0_4._vigilantState:GetVigilantMark()

	for iter0_4, iter1_4 in ipairs(arg0_4._markList) do
		SetActive(iter1_4, var0_4 == iter0_4)
	end
end

function var1_0.UpdateVigilantBarPosition(arg0_5, arg1_5)
	arg0_5._vigilantBar.position = arg1_5
end

function var1_0.meterConvert(arg0_6)
	return var1_0.METER_LENGTH * arg0_6 + var1_0.MIN
end

function var1_0.Dispose(arg0_7)
	arg0_7._vigilantState = nil

	Object.Destroy(arg0_7._vigilantBarGO)

	arg0_7._vigilantBar = nil
	arg0_7._vigilantBarGO = nil
	arg0_7._markList = nil
	arg0_7._progress = nil
end
