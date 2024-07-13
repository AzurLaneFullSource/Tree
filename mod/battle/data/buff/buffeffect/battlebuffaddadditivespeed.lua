ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = class("BattleBuffAddAdditiveSpeed", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffAddAdditiveSpeed = var2_0
var2_0.__name = "BattleBuffAddAdditiveSpeed"

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)
end

function var2_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._singularity = arg0_2._tempData.arg_list.singularity or {
		x = 0,
		z = 0
	}
	arg0_2._casterGravity = arg0_2._tempData.arg_list.gravitationalCaster
	arg0_2._force = arg0_2._tempData.arg_list.force
	arg0_2._forceScalteRate = arg0_2._tempData.arg_list.scale_rate

	if not arg0_2._casterGravity then
		arg0_2._staticSingularity = Vector3.New(arg0_2._singularity.x, 0, arg0_2._singularity.z)
	else
		local var0_2 = arg2_2:GetCaster():GetIFF()

		arg0_2._singularityOffset = Vector3.New(arg0_2._singularity.x * var0_2, 0, arg0_2._singularity.z)
	end
end

function var2_0.onUpdate(arg0_3, arg1_3, arg2_3)
	local var0_3

	if arg0_3._casterGravity then
		var0_3 = arg2_3:GetCaster():GetPosition() + arg0_3._singularityOffset
	else
		var0_3 = arg0_3._staticSingularity
	end

	local var1_3 = pg.Tool.FilterY(var0_3 - arg1_3:GetPosition())
	local var2_3 = var1_3.normalized
	local var3_3 = arg0_3._force
	local var4_3 = var1_3.magnitude

	if var4_3 < 2 then
		var3_3 = 1e-08
	elseif arg0_3._forceScalteRate then
		var3_3 = math.min(var4_3, 1 / var4_3 * var3_3)
	end

	local var5_3 = var2_3 * var3_3

	arg1_3:SetAdditiveSpeed(var5_3)
end

function var2_0.onRemove(arg0_4, arg1_4, arg2_4)
	arg1_4:RemoveAdditiveSpeed()
end
