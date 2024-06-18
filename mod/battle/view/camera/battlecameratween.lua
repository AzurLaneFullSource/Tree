ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleVariable

var0_0.Battle.BattleCameraTween = class("BattleCameraTween")
var0_0.Battle.BattleCameraTween.__name = "BattleCameraTween"

local var3_0 = var0_0.Battle.BattleCameraTween

function var3_0.Ctor(arg0_1)
	arg0_1._point = Vector3.zero
end

function var3_0.SetFromTo(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2, arg6_2, arg7_2)
	arg0_2._point:Set(arg2_2.x, arg2_2.y, arg2_2.z)

	local var0_2 = LeanTween.value(go(arg1_2), arg2_2, arg3_2, arg4_2):setOnUpdateVector3(System.Action_UnityEngine_Vector3(function(arg0_3)
		arg0_2._point:Set(arg0_3.x, arg0_3.y, arg0_3.z)
	end))

	if arg5_2 and arg5_2 ~= 0 then
		var0_2:setDelay(arg5_2)
	end

	if arg6_2 then
		var0_2:setEase(LeanTweenType.easeOutExpo)
	end

	if arg7_2 then
		var0_2:setOnComplete(System.Action(function()
			arg7_2()
		end))
	end
end

function var3_0.GetCameraPos(arg0_5)
	return arg0_5._point
end

function var3_0.Dispose(arg0_6)
	arg0_6._point = nil
end
