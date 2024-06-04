ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffStory = class("BattleBuffStory", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffStory.__name = "BattleBuffStory"

local var1 = var0.Battle.BattleBuffStory

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list

	arg0._storyID = var0.story_id
	arg0._countType = var0.countType
end

function var1.doOnHPRatioUpdate(arg0, arg1, arg2, arg3)
	pg.NewStoryMgr.GetInstance():Play(arg0._storyID)
end
