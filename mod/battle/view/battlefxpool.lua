ys = ys or {}

local var0_0 = ys
local var1_0 = pg.effect_offset
local var2_0 = singletonClass("BattleFXPool")

var0_0.Battle.BattleFXPool = var2_0
var2_0.__name = "BattleFXPool"

function var2_0.Ctor(arg0_1)
	return
end

function var2_0.Init(arg0_2)
	arg0_2._fxContainer = GameObject("fxContainer")
	arg0_2._fxContainerTf = arg0_2._fxContainer.transform

	local var0_2 = GameObject()

	var0_2.transform:SetParent(arg0_2._fxContainerTf, false)

	var0_2.name = "characterFXAttachPoint"
	arg0_2._charAttachPointPool = pg.Pool.New(arg0_2._fxContainerTf, var0_2, 10, 20, false, true):InitSize()
end

function var2_0.Clear(arg0_3)
	arg0_3._charAttachPointPool:Dispose()

	arg0_3._charAttachPointPool = nil

	Object.Destroy(arg0_3._fxContainer)

	arg0_3._fxContainer = nil
	arg0_3._fxContainerTf = nil
end

function var2_0.GetFX(arg0_4, arg1_4, arg2_4)
	local var0_4 = var0_0.Battle.BattleResourceManager.GetInstance():InstFX(arg1_4, true)

	LuaHelper.SetGOParentTF(var0_4, arg2_4 or arg0_4._fxContainerTf, false)

	local var1_4
	local var2_4 = var1_0[arg1_4]

	if var2_4 ~= nil then
		local var3_4 = var2_4.offset

		var1_4 = Vector3(var3_4[1], var3_4[2], var3_4[3])
	else
		var1_4 = Vector3.zero
	end

	return var0_4, var1_4
end

function var2_0.GetCharacterFX(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5)
	if arg2_5 == nil then
		return arg0_5:GetFX(arg1_5)
	end

	local var0_5 = var0_0.Battle.BattleResourceManager.GetInstance():InstFX(arg1_5, true)
	local var1_5
	local var2_5
	local var3_5 = var1_0[arg1_5]

	if var3_5 ~= nil then
		local var4_5 = var3_5.container_index
		local var5_5 = var3_5.offset

		var2_5 = Vector3(var5_5[1], var5_5[2], var5_5[3] + 0.02)

		if var4_5 == -1 then
			LuaHelper.SetGOParentGO(var0_5, arg2_5:GetGO(), true)
		else
			var2_5 = var2_5 + arg2_5:GetFXOffsets(var4_5)

			LuaHelper.SetGOParentGO(var0_5, arg2_5:GetAttachPoint(), true)
		end

		if var3_5.mirror and var0_5.transform.parent.transform.lossyScale.x < 0 then
			local var6_5 = var0_5.transform.localScale

			var0_5.transform.localScale = Vector3(-1 * var6_5.x, var6_5.y, var6_5.z)
		end
	else
		var2_5 = Vector3(0, 0, 0.02)

		LuaHelper.SetGOParentGO(var0_5, arg2_5:GetGO(), true)
	end

	local var7_5 = arg2_5:GetSpecificFXScale()

	if var7_5[arg1_5] then
		local var8_5 = var7_5[arg1_5]
		local var9_5 = var0_5.transform.localScale

		var0_5.transform.localScale = Vector3(var9_5.x * var8_5, var9_5.y * var8_5, var9_5.z * var8_5)
	end

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0_5, var2_5, arg3_5, arg4_5, arg5_5)

	return var0_5
end

function var2_0.PopCharacterAttachPoint(arg0_6)
	return arg0_6._charAttachPointPool:GetObject()
end

function var2_0.PushCharacterAttachPoint(arg0_7, arg1_7)
	arg0_7._charAttachPointPool:Recycle(arg1_7)
end
