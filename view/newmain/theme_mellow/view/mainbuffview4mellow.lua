local var0 = class("MainBuffView4Mellow", import("...theme_classic.view.MainBuffView"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.buffOffsetX = 6
	arg0.noTagStartPos = 130
	arg0.hasTagStartPos = 290
	arg0.tagPos = Vector3(-170, -2.5, 0)
end

function var0.GetDirection(arg0)
	return Vector2.zero
end

return var0
