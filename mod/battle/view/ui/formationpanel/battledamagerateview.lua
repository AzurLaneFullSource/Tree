ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleDamageRateView = class("BattleDamageRateView")
var0_0.Battle.BattleDamageRateView.__name = "BattleDamageRateView"

function var0_0.Battle.BattleDamageRateView.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1.tick_bar = arg1_1.transform:Find("tick_bar"):GetComponent(typeof(Image))
	arg0_1.tickBarOb = arg0_1.tick_bar.gameObject
	arg0_1.tick_bar.fillAmount = 0
end

function var0_0.Battle.BattleDamageRateView.UpdateScore(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2:CalScore(arg1_2, arg2_2)

	LeanTween.cancel(arg0_2.tickBarOb)
	LeanTween.value(arg0_2.tickBarOb, arg0_2.tick_bar.fillAmount, var0_2, 0.5):setOnUpdate(System.Action_float(function(arg0_3)
		arg0_2.tick_bar.fillAmount = arg0_3
	end))
end

function var0_0.Battle.BattleDamageRateView.CalScore(arg0_4, arg1_4, arg2_4)
	local var0_4 = pg.expedition_data_template[arg2_4]
	local var1_4 = {
		"c_score_point",
		"b_score_point",
		"a_score_point",
		"s_score_point",
		"score_max"
	}
	local var2_4 = {
		0,
		0.445,
		0.7,
		0.88,
		1
	}
	local var3_4 = 0

	for iter0_4, iter1_4 in ipairs(var1_4) do
		if arg1_4 < var0_4[iter1_4] then
			break
		end

		var3_4 = iter0_4
	end

	local var4_4 = 0

	if var3_4 < #var1_4 then
		local var5_4 = var0_4[var1_4[var3_4]]

		if var5_4 < 0 then
			var5_4 = 0
		end

		local var6_4 = (arg1_4 - var5_4) / (var0_4[var1_4[var3_4 + 1]] - var5_4)

		var4_4 = (var2_4[var3_4 + 1] - var2_4[var3_4]) * var6_4 + var2_4[var3_4]
	else
		var4_4 = 1
	end

	return var4_4
end

function var0_0.Battle.BattleDamageRateView.Dispose(arg0_5)
	LeanTween.cancel(arg0_5.tickBarOb)
end
