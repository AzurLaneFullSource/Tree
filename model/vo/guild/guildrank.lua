local var0 = class("GuildRank")

function var0.Ctor(arg0, arg1)
	arg0.id = arg1
	arg0.weekScore = 0
	arg0.monthScore = 0
	arg0.totalScore = 0
end

function var0.GetName(arg0)
	return arg0.name
end

function var0.SetName(arg0, arg1)
	arg0.name = arg1
end

function var0.SetWeekScore(arg0, arg1)
	arg0.weekScore = arg1
end

function var0.SetMonthScore(arg0, arg1)
	arg0.monthScore = arg1
end

function var0.SetTotalScore(arg0, arg1)
	arg0.totalScore = arg1
end

function var0.SetScore(arg0, arg1, arg2)
	if arg1 == 1 then
		arg0:SetWeekScore(arg2)
	elseif arg1 == 2 then
		arg0:SetMonthScore(arg2)
	elseif arg1 == 3 then
		arg0:SetTotalScore(arg2)
	end
end

function var0.GetWeekScore(arg0)
	return arg0.weekScore
end

function var0.GetMonthScore(arg0)
	return arg0.monthScore
end

function var0.GetTotalScore(arg0)
	return arg0.totalScore
end

function var0.GetScore(arg0, arg1)
	if arg1 == 0 then
		return arg0:GetWeekScore()
	elseif arg1 == 1 then
		return arg0:GetMonthScore()
	elseif arg1 == 2 then
		return arg0:GetTotalScore()
	end
end

return var0
