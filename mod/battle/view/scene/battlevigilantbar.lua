ys = ys or {}

local var0 = ys

var0.Battle.BattleVigilantBar = class("BattleVigilantBar")
var0.Battle.BattleVigilantBar.__name = "BattleVigilantBar"

local var1 = var0.Battle.BattleVigilantBar

var1.MIN = 0.267
var1.MAX = 0.7335
var1.METER_LENGTH = var1.MAX - var1.MIN
var1.STATE_CALM = 0
var1.STATE_SUSPICIOUS = 1
var1.STATE_VIGILANT = 2
var1.STATE_ENGAGE = 3

function var1.Ctor(arg0, arg1)
	arg0._vigilantBar = arg1
	arg0._vigilantBarGO = arg0._vigilantBar.gameObject
	arg0._progress = arg0._vigilantBar:Find("progress"):GetComponent(typeof(Image))
	arg0._markList = {}
	arg0._markList[var1.STATE_CALM] = arg0._vigilantBar:Find("mark/" .. var1.STATE_CALM)
	arg0._markList[var1.STATE_SUSPICIOUS] = arg0._vigilantBar:Find("mark/" .. var1.STATE_SUSPICIOUS)
	arg0._markList[var1.STATE_VIGILANT] = arg0._vigilantBar:Find("mark/" .. var1.STATE_VIGILANT)
	arg0._markList[var1.STATE_ENGAGE] = arg0._vigilantBar:Find("mark/" .. var1.STATE_ENGAGE)
end

function var1.ConfigVigilant(arg0, arg1)
	arg0._vigilantState = arg1
end

function var1.UpdateVigilantProgress(arg0)
	local var0 = arg0._vigilantState:GetVigilantRate()

	arg0._progress.fillAmount = arg0.meterConvert(var0)
end

function var1.UpdateVigilantMark(arg0)
	local var0 = arg0._vigilantState:GetVigilantMark()

	for iter0, iter1 in ipairs(arg0._markList) do
		SetActive(iter1, var0 == iter0)
	end
end

function var1.UpdateVigilantBarPosition(arg0, arg1)
	arg0._vigilantBar.position = arg1
end

function var1.meterConvert(arg0)
	return var1.METER_LENGTH * arg0 + var1.MIN
end

function var1.Dispose(arg0)
	arg0._vigilantState = nil

	Object.Destroy(arg0._vigilantBarGO)

	arg0._vigilantBar = nil
	arg0._vigilantBarGO = nil
	arg0._markList = nil
	arg0._progress = nil
end
