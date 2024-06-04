local var0 = class("AnswerProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0.scores = {}

	arg0:on(26011, function(arg0)
		arg0.scores = {}

		_.each(arg0.subject, function(arg0)
			arg0.scores[arg0.id] = arg0.score
		end)
	end)
end

function var0.getScore(arg0, arg1)
	return arg0.scores[arg1]
end

function var0.setScore(arg0, arg1, arg2)
	arg0.scores[arg1] = arg2 and math.clamp(arg2, 0, 100) or nil
end

function var0.getAverage(arg0)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in pairs(arg0.scores) do
		var0 = var0 + 1
		var1 = var1 + iter1
	end

	return var0 > 0 and var1 / var0
end

function var0.isSubjectOpen(arg0, arg1, arg2)
	return arg1:getDayIndex() >= arg2 + 1
end

return var0
