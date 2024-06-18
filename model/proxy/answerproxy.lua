local var0_0 = class("AnswerProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.scores = {}

	arg0_1:on(26011, function(arg0_2)
		arg0_1.scores = {}

		_.each(arg0_2.subject, function(arg0_3)
			arg0_1.scores[arg0_3.id] = arg0_3.score
		end)
	end)
end

function var0_0.getScore(arg0_4, arg1_4)
	return arg0_4.scores[arg1_4]
end

function var0_0.setScore(arg0_5, arg1_5, arg2_5)
	arg0_5.scores[arg1_5] = arg2_5 and math.clamp(arg2_5, 0, 100) or nil
end

function var0_0.getAverage(arg0_6)
	local var0_6 = 0
	local var1_6 = 0

	for iter0_6, iter1_6 in pairs(arg0_6.scores) do
		var0_6 = var0_6 + 1
		var1_6 = var1_6 + iter1_6
	end

	return var0_6 > 0 and var1_6 / var0_6
end

function var0_0.isSubjectOpen(arg0_7, arg1_7, arg2_7)
	return arg1_7:getDayIndex() >= arg2_7 + 1
end

return var0_0
