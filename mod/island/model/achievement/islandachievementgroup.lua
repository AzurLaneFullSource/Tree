local var0_0 = class("IslandAchievementGroup")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.groupId = arg1_1
	arg0_1.achvDic = {}

	for iter0_1, iter1_1 in ipairs(arg2_1) do
		arg0_1.achvDic[iter1_1] = IslandAchievement.New(iter1_1)
	end
end

function var0_0.GetSortAchvList(arg0_2)
	local var0_2 = underscore.values(arg0_2.achvDic)

	table.sort(var0_2, CompareFuncs({
		function(arg0_3)
			return arg0_3:GetStage()
		end
	}))

	return var0_2
end

function var0_0.GetAchvById(arg0_4, arg1_4)
	return arg0_4.achvDic[arg1_4]
end

function var0_0.SetGotTagById(arg0_5, arg1_5)
	arg0_5.achvDic[arg1_5]:SetStatus(IslandAchievement.STATUS.GOT)
end

return var0_0
