ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleResourceManager

var0.Battle.BattleCharacterFXContainersPool = singletonClass("BattleCharacterFXContainersPool")
var0.Battle.BattleCharacterFXContainersPool.__name = "BattleCharacterFXContainersPool"

local var2 = var0.Battle.BattleCharacterFXContainersPool

function var2.Ctor(arg0)
	return
end

function var2.Init(arg0)
	arg0._pool = {}
	arg0._templateContainer = GameObject("characterFXContainerPoolParent")
	arg0._templateContainerTf = arg0._templateContainer.transform
	arg0._templateContainerTf.position = Vector3(-10000, -10000, 0)
end

function var2.Pop(arg0, arg1, arg2)
	local var0 = arg1.localEulerAngles

	arg2 = arg2 or {
		{
			0,
			0,
			0
		},
		{
			0,
			0,
			0
		},
		{
			0,
			0,
			0
		},
		{
			0,
			0,
			0
		}
	}

	local var1

	if #arg0._pool == 0 then
		var1 = {}

		for iter0, iter1 in ipairs(var0.Battle.BattleConst.FXContainerIndex) do
			local var2 = GameObject()
			local var3 = var2.transform
			local var4 = arg2[iter0]

			var3:SetParent(arg1, false)

			var3.localPosition = Vector3(var4[1], var4[2], var4[3])
			var3.localEulerAngles = Vector3(var0.x * -1, var0.y, var0.z)
			var2.name = "fxContainer_" .. iter1
			var1[iter0] = var2
		end
	else
		var1 = arg0._pool[#arg0._pool]
		arg0._pool[#arg0._pool] = nil

		for iter2, iter3 in ipairs(var1) do
			local var5 = arg2[iter2]
			local var6 = iter3.transform

			var6:SetParent(arg1, false)

			var6.localPosition = Vector3(var5[1], var5[2], var5[3])
			var6.localEulerAngles = Vector3(var0.x * -1, var0.y, var0.z)
		end
	end

	return var1
end

function var2.Push(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = iter1.transform

		var0:SetParent(arg0._templateContainerTf, false)

		for iter2 = var0.childCount - 1, 0, -1 do
			var1.GetInstance():DestroyOb(var0:GetChild(iter2).gameObject)
		end
	end

	arg0._pool[#arg0._pool + 1] = arg1
end

function var2.Clear(arg0)
	for iter0, iter1 in ipairs(arg0._pool) do
		for iter2, iter3 in ipairs(iter1) do
			Object.Destroy(iter3)
		end
	end

	arg0._pool = nil

	Object.Destroy(arg0._templateContainer)

	arg0._templateContainer = nil
	arg0._templateContainerTf = nil
end
