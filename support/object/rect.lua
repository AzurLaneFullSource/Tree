pg = pg or {}

local var0_0 = pg

var0_0.Rect = class("Rect")

function var0_0.Rect.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1, arg6_1)
	arg0_1._right = arg1_1
	arg0_1._bottom = arg2_1
	arg0_1._width = arg3_1
	arg0_1._height = arg4_1
	arg0_1._left = arg1_1 + arg3_1
	arg0_1._top = arg2_1 + arg4_1
	arg0_1._type = arg5_1
	arg0_1._obj = arg6_1
end

function var0_0.Rect.CheckPreCollider(arg0_2, arg1_2, arg2_2, arg3_2)
	if arg1_2._left < arg0_2._right then
		return 0
	end

	if arg1_2._right > arg0_2._left or arg1_2._top < arg0_2._bottom or arg1_2._bottom > arg0_2._top then
		return 1
	end

	local var0_2 = 0
	local var1_2 = 0

	if arg3_2 > 0 then
		if arg2_2 == 0 then
			return 2
		end

		if (arg0_2._left - arg1_2._right) / arg2_2 >= (arg0_2._bottom - arg1_2._top) / arg3_2 then
			return 4
		end

		return 2
	elseif arg3_2 < 0 then
		if arg2_2 == 0 then
			return 3
		end

		if (arg0_2._left - arg1_2._right) / arg2_2 >= (arg0_2._top - arg1_2._bottom) / arg3_2 then
			return 4
		end

		return 3
	else
		return 4
	end
end

function var0_0.Rect.CheckStillCollider(arg0_3, arg1_3)
	if arg1_3._right > arg0_3._left or arg1_3._left < arg0_3._right or arg1_3._top < arg0_3._bottom or arg1_3._bottom > arg0_3._top then
		return false
	end

	return true
end
