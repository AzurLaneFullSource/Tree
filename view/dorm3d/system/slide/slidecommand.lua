local var0_0 = class("SlideCommand", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	local var0_1 = pg.dorm3d_slide_command[arg1_1]

	var0_0.super.Ctor(arg0_1, var0_1)

	arg0_1.id = arg1_1
	arg0_1.type = var0_1.type
	arg0_1.target = var0_1.target
	arg0_1.anim = var0_1.anim
	arg0_1.time = var0_1.time
	arg0_1.fade_in_time = var0_1.fade_in_time
	arg0_1.effect = var0_1.effect
	arg0_1.wet = var0_1.wet

	if arg0_1.target and arg0_1.target ~= "" then
		arg0_1.target = arg2_1:Find(arg0_1.target)
	end
end

function var0_0.GetFadeInTime(arg0_2)
	if arg0_2.fade_in_time and arg0_2.fade_in_time ~= 0 then
		return arg0_2.fade_in_time
	else
		return DormConst.DEFAULT_ANIM_FADE_IN_TIME
	end
end

function var0_0.HasEffect(arg0_3)
	return arg0_3.effect and arg0_3.effect ~= ""
end

function var0_0.HasWet(arg0_4)
	return arg0_4.wet and arg0_4.wet ~= ""
end

function var0_0.GetEffect(arg0_5)
	if arg0_5:HasEffect() then
		return arg0_5.effect[1], arg0_5.effect[2]
	end
end

function var0_0.GetWet(arg0_6)
	if arg0_6:HasWet() then
		return arg0_6.wet[1], arg0_6.wet[2]
	end
end

return var0_0
