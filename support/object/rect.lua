pg = pg or {}

local var0 = pg

var0.Rect = class("Rect")

function var0.Rect.Ctor(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	arg0._right = arg1
	arg0._bottom = arg2
	arg0._width = arg3
	arg0._height = arg4
	arg0._left = arg1 + arg3
	arg0._top = arg2 + arg4
	arg0._type = arg5
	arg0._obj = arg6
end

function var0.Rect.CheckPreCollider(arg0, arg1, arg2, arg3)
	if arg1._left < arg0._right then
		return 0
	end

	if arg1._right > arg0._left or arg1._top < arg0._bottom or arg1._bottom > arg0._top then
		return 1
	end

	local var0 = 0
	local var1 = 0

	if arg3 > 0 then
		if arg2 == 0 then
			return 2
		end

		if (arg0._left - arg1._right) / arg2 >= (arg0._bottom - arg1._top) / arg3 then
			return 4
		end

		return 2
	elseif arg3 < 0 then
		if arg2 == 0 then
			return 3
		end

		if (arg0._left - arg1._right) / arg2 >= (arg0._top - arg1._bottom) / arg3 then
			return 4
		end

		return 3
	else
		return 4
	end
end

function var0.Rect.CheckStillCollider(arg0, arg1)
	if arg1._right > arg0._left or arg1._left < arg0._right or arg1._top < arg0._bottom or arg1._bottom > arg0._top then
		return false
	end

	return true
end
