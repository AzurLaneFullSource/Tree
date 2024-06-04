ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = class("BattleBuffAddAdditiveSpeed", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffAddAdditiveSpeed = var2
var2.__name = "BattleBuffAddAdditiveSpeed"

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)
end

function var2.SetArgs(arg0, arg1, arg2)
	arg0._singularity = arg0._tempData.arg_list.singularity or {
		x = 0,
		z = 0
	}
	arg0._casterGravity = arg0._tempData.arg_list.gravitationalCaster
	arg0._force = arg0._tempData.arg_list.force
	arg0._forceScalteRate = arg0._tempData.arg_list.scale_rate

	if not arg0._casterGravity then
		arg0._staticSingularity = Vector3.New(arg0._singularity.x, 0, arg0._singularity.z)
	else
		local var0 = arg2:GetCaster():GetIFF()

		arg0._singularityOffset = Vector3.New(arg0._singularity.x * var0, 0, arg0._singularity.z)
	end
end

function var2.onUpdate(arg0, arg1, arg2)
	local var0

	if arg0._casterGravity then
		var0 = arg2:GetCaster():GetPosition() + arg0._singularityOffset
	else
		var0 = arg0._staticSingularity
	end

	local var1 = pg.Tool.FilterY(var0 - arg1:GetPosition())
	local var2 = var1.normalized
	local var3 = arg0._force
	local var4 = var1.magnitude

	if var4 < 2 then
		var3 = 1e-08
	elseif arg0._forceScalteRate then
		var3 = math.min(var4, 1 / var4 * var3)
	end

	local var5 = var2 * var3

	arg1:SetAdditiveSpeed(var5)
end

function var2.onRemove(arg0, arg1, arg2)
	arg1:RemoveAdditiveSpeed()
end
