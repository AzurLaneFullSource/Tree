ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleVariable

var0.Battle.BattleCameraTween = class("BattleCameraTween")
var0.Battle.BattleCameraTween.__name = "BattleCameraTween"

local var3 = var0.Battle.BattleCameraTween

function var3.Ctor(arg0)
	arg0._point = Vector3.zero
end

function var3.SetFromTo(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	arg0._point:Set(arg2.x, arg2.y, arg2.z)

	local var0 = LeanTween.value(go(arg1), arg2, arg3, arg4):setOnUpdateVector3(System.Action_UnityEngine_Vector3(function(arg0)
		arg0._point:Set(arg0.x, arg0.y, arg0.z)
	end))

	if arg5 and arg5 ~= 0 then
		var0:setDelay(arg5)
	end

	if arg6 then
		var0:setEase(LeanTweenType.easeOutExpo)
	end

	if arg7 then
		var0:setOnComplete(System.Action(function()
			arg7()
		end))
	end
end

function var3.GetCameraPos(arg0)
	return arg0._point
end

function var3.Dispose(arg0)
	arg0._point = nil
end
