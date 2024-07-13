local var0_0 = class("GuildRank")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.weekScore = 0
	arg0_1.monthScore = 0
	arg0_1.totalScore = 0
end

function var0_0.GetName(arg0_2)
	return arg0_2.name
end

function var0_0.SetName(arg0_3, arg1_3)
	arg0_3.name = arg1_3
end

function var0_0.SetWeekScore(arg0_4, arg1_4)
	arg0_4.weekScore = arg1_4
end

function var0_0.SetMonthScore(arg0_5, arg1_5)
	arg0_5.monthScore = arg1_5
end

function var0_0.SetTotalScore(arg0_6, arg1_6)
	arg0_6.totalScore = arg1_6
end

function var0_0.SetScore(arg0_7, arg1_7, arg2_7)
	if arg1_7 == 1 then
		arg0_7:SetWeekScore(arg2_7)
	elseif arg1_7 == 2 then
		arg0_7:SetMonthScore(arg2_7)
	elseif arg1_7 == 3 then
		arg0_7:SetTotalScore(arg2_7)
	end
end

function var0_0.GetWeekScore(arg0_8)
	return arg0_8.weekScore
end

function var0_0.GetMonthScore(arg0_9)
	return arg0_9.monthScore
end

function var0_0.GetTotalScore(arg0_10)
	return arg0_10.totalScore
end

function var0_0.GetScore(arg0_11, arg1_11)
	if arg1_11 == 0 then
		return arg0_11:GetWeekScore()
	elseif arg1_11 == 1 then
		return arg0_11:GetMonthScore()
	elseif arg1_11 == 2 then
		return arg0_11:GetTotalScore()
	end
end

return var0_0
