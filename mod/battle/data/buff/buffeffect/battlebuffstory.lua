ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffStory = class("BattleBuffStory", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffStory.__name = "BattleBuffStory"

local var1_0 = var0_0.Battle.BattleBuffStory

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._storyID = var0_2.story_id
	arg0_2._countType = var0_2.countType
end

function var1_0.doOnHPRatioUpdate(arg0_3, arg1_3, arg2_3, arg3_3)
	pg.NewStoryMgr.GetInstance():Play(arg0_3._storyID)
end
