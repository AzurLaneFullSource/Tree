local var0_0 = class("SpineAnimUtil")

function var0_0.GetCharAnimDirect(arg0_1, arg1_1, arg2_1)
	if not arg2_1 or not arg0_1 or not arg1_1 then
		return arg2_1
	end

	local var0_1 = arg1_1 == 1 and "_R" or "_L"
	local var1_1 = arg2_1 .. var0_1

	if arg0_1.skeleton.Data:FindAnimation(var1_1) then
		return var1_1, true
	end

	return arg2_1, false
end

function var0_0.GetCharAnimationDirect(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2 == 1 and "_R" or "_L"
	local var1_2 = arg2_2 .. var0_2

	if arg0_2.SkeletonData:FindAnimation(var1_2) then
		return var1_2, true
	end

	return arg2_2, false
end

return var0_0
