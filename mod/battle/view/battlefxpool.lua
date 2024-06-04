ys = ys or {}

local var0 = ys
local var1 = pg.effect_offset
local var2 = singletonClass("BattleFXPool")

var0.Battle.BattleFXPool = var2
var2.__name = "BattleFXPool"

function var2.Ctor(arg0)
	return
end

function var2.Init(arg0)
	arg0._fxContainer = GameObject("fxContainer")
	arg0._fxContainerTf = arg0._fxContainer.transform

	local var0 = GameObject()

	var0.transform:SetParent(arg0._fxContainerTf, false)

	var0.name = "characterFXAttachPoint"
	arg0._charAttachPointPool = pg.Pool.New(arg0._fxContainerTf, var0, 10, 20, false, true):InitSize()
end

function var2.Clear(arg0)
	arg0._charAttachPointPool:Dispose()

	arg0._charAttachPointPool = nil

	Object.Destroy(arg0._fxContainer)

	arg0._fxContainer = nil
	arg0._fxContainerTf = nil
end

function var2.GetFX(arg0, arg1, arg2)
	local var0 = var0.Battle.BattleResourceManager.GetInstance():InstFX(arg1, true)

	LuaHelper.SetGOParentTF(var0, arg2 or arg0._fxContainerTf, false)

	local var1
	local var2 = var1[arg1]

	if var2 ~= nil then
		local var3 = var2.offset

		var1 = Vector3(var3[1], var3[2], var3[3])
	else
		var1 = Vector3.zero
	end

	return var0, var1
end

function var2.GetCharacterFX(arg0, arg1, arg2, arg3, arg4, arg5)
	if arg2 == nil then
		return arg0:GetFX(arg1)
	end

	local var0 = var0.Battle.BattleResourceManager.GetInstance():InstFX(arg1, true)
	local var1
	local var2
	local var3 = var1[arg1]

	if var3 ~= nil then
		local var4 = var3.container_index
		local var5 = var3.offset

		var2 = Vector3(var5[1], var5[2], var5[3] + 0.02)

		if var4 == -1 then
			LuaHelper.SetGOParentGO(var0, arg2:GetGO(), true)
		else
			var2 = var2 + arg2:GetFXOffsets(var4)

			LuaHelper.SetGOParentGO(var0, arg2:GetAttachPoint(), true)
		end

		if var3.mirror and var0.transform.parent.transform.lossyScale.x < 0 then
			local var6 = var0.transform.localScale

			var0.transform.localScale = Vector3(-1 * var6.x, var6.y, var6.z)
		end
	else
		var2 = Vector3(0, 0, 0.02)

		LuaHelper.SetGOParentGO(var0, arg2:GetGO(), true)
	end

	local var7 = arg2:GetSpecificFXScale()

	if var7[arg1] then
		local var8 = var7[arg1]
		local var9 = var0.transform.localScale

		var0.transform.localScale = Vector3(var9.x * var8, var9.y * var8, var9.z * var8)
	end

	pg.EffectMgr.GetInstance():PlayBattleEffect(var0, var2, arg3, arg4, arg5)

	return var0
end

function var2.PopCharacterAttachPoint(arg0)
	return arg0._charAttachPointPool:GetObject()
end

function var2.PushCharacterAttachPoint(arg0, arg1)
	arg0._charAttachPointPool:Recycle(arg1)
end
