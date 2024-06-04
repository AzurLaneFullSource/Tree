ys = ys or {}

local var0 = ys

var0.Battle.BattleDamageRateView = class("BattleDamageRateView")
var0.Battle.BattleDamageRateView.__name = "BattleDamageRateView"

function var0.Battle.BattleDamageRateView.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0.tick_bar = arg1.transform:Find("tick_bar"):GetComponent(typeof(Image))
	arg0.tickBarOb = arg0.tick_bar.gameObject
	arg0.tick_bar.fillAmount = 0
end

function var0.Battle.BattleDamageRateView.UpdateScore(arg0, arg1, arg2)
	local var0 = arg0:CalScore(arg1, arg2)

	LeanTween.cancel(arg0.tickBarOb)
	LeanTween.value(arg0.tickBarOb, arg0.tick_bar.fillAmount, var0, 0.5):setOnUpdate(System.Action_float(function(arg0)
		arg0.tick_bar.fillAmount = arg0
	end))
end

function var0.Battle.BattleDamageRateView.CalScore(arg0, arg1, arg2)
	local var0 = pg.expedition_data_template[arg2]
	local var1 = {
		"c_score_point",
		"b_score_point",
		"a_score_point",
		"s_score_point",
		"score_max"
	}
	local var2 = {
		0,
		0.445,
		0.7,
		0.88,
		1
	}
	local var3 = 0

	for iter0, iter1 in ipairs(var1) do
		if arg1 < var0[iter1] then
			break
		end

		var3 = iter0
	end

	local var4 = 0

	if var3 < #var1 then
		local var5 = var0[var1[var3]]

		if var5 < 0 then
			var5 = 0
		end

		local var6 = (arg1 - var5) / (var0[var1[var3 + 1]] - var5)

		var4 = (var2[var3 + 1] - var2[var3]) * var6 + var2[var3]
	else
		var4 = 1
	end

	return var4
end

function var0.Battle.BattleDamageRateView.Dispose(arg0)
	LeanTween.cancel(arg0.tickBarOb)
end
