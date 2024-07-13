local var0_0 = class("MainBuffView4Mellow", import("...theme_classic.view.MainBuffView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.buffOffsetX = 6
	arg0_1.noTagStartPos = 130
	arg0_1.hasTagStartPos = 290
	arg0_1.tagPos = Vector3(-170, -2.5, 0)
end

function var0_0.GetDirection(arg0_2)
	return Vector2.zero
end

return var0_0
