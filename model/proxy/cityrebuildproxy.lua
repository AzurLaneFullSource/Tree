local var0_0 = class("CityRebuildProxy", import(".NetProxy"))

var0_0.GET_DATA = 1
var0_0.REBUILD_OR_START_RECRUIT = 2
var0_0.END_RECRUIT = 3
var0_0.UPGRADE_BUFF = 4
var0_0.RESULT = 5
var0_0.CHOOSE_LEVEL = 6
var0_0.INIT_TIME = 7

local var1_0 = pg.activity_ninja_building

function var0_0.register(arg0_1)
	arg0_1.cityRebuildDataDic = {}
end

function var0_0.SetData(arg0_2, arg1_2, arg2_2)
	arg0_2.cityRebuildDataDic[arg1_2] = CityRebuildData.New(arg2_2)
end

function var0_0.GetData(arg0_3, arg1_3)
	return arg0_3.cityRebuildDataDic[arg1_3]
end

function var0_0.Adjust(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4.cityRebuildDataDic[arg1_4]

	if not var0_4 then
		return
	end

	var0_4:Adjust(arg2_4)
end

function var0_0.RebuildOrStartRecruit(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5.cityRebuildDataDic[arg1_5]

	if not var0_5 then
		return
	end

	if var1_0[arg2_5].type == 1 then
		var0_5:RebuildDone(arg2_5)
	else
		var0_5:StartRecruit(arg2_5)
	end
end

function var0_0.RecruitDone(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.cityRebuildDataDic[arg1_6]

	if not var0_6 then
		return
	end

	var0_6:RecruitDone(arg2_6)
end

function var0_0.UpgradeBuff(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg0_7.cityRebuildDataDic[arg1_7]

	if not var0_7 then
		return
	end

	var0_7:UpgradeBuff(arg2_7, arg3_7)
end

function var0_0.Result(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.cityRebuildDataDic[arg1_8]

	if not var0_8 then
		return
	end

	var0_8:Result(arg2_8)
end

function var0_0.UpdateChooseLevel(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.cityRebuildDataDic[arg1_9]

	if not var0_9 then
		return
	end

	var0_9:UpdateChooseLevel(arg2_9)
end

function var0_0.ComsumePt(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.cityRebuildDataDic[arg1_10]

	if not var0_10 then
		return
	end

	var0_10:ConsumePt(arg2_10)
end

function var0_0.AddPt(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.cityRebuildDataDic[arg1_11]

	if not var0_11 then
		return
	end

	var0_11:AddPt(arg2_11)
end

return var0_0
