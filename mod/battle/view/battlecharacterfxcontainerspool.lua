ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleResourceManager

var0_0.Battle.BattleCharacterFXContainersPool = singletonClass("BattleCharacterFXContainersPool")
var0_0.Battle.BattleCharacterFXContainersPool.__name = "BattleCharacterFXContainersPool"

local var2_0 = var0_0.Battle.BattleCharacterFXContainersPool

function var2_0.Ctor(arg0_1)
	return
end

function var2_0.Init(arg0_2)
	arg0_2._pool = {}
	arg0_2._templateContainer = GameObject("characterFXContainerPoolParent")
	arg0_2._templateContainerTf = arg0_2._templateContainer.transform
	arg0_2._templateContainerTf.position = Vector3(-10000, -10000, 0)
end

function var2_0.Pop(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg1_3.localEulerAngles

	arg2_3 = arg2_3 or {
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

	local var1_3

	if #arg0_3._pool == 0 then
		var1_3 = {}

		for iter0_3, iter1_3 in ipairs(var0_0.Battle.BattleConst.FXContainerIndex) do
			local var2_3 = GameObject()
			local var3_3 = var2_3.transform
			local var4_3 = arg2_3[iter0_3]

			var3_3:SetParent(arg1_3, false)

			var3_3.localPosition = Vector3(var4_3[1], var4_3[2], var4_3[3])
			var3_3.localEulerAngles = Vector3(var0_3.x * -1, var0_3.y, var0_3.z)
			var2_3.name = "fxContainer_" .. iter1_3
			var1_3[iter0_3] = var2_3
		end
	else
		var1_3 = arg0_3._pool[#arg0_3._pool]
		arg0_3._pool[#arg0_3._pool] = nil

		for iter2_3, iter3_3 in ipairs(var1_3) do
			local var5_3 = arg2_3[iter2_3]
			local var6_3 = iter3_3.transform

			var6_3:SetParent(arg1_3, false)

			var6_3.localPosition = Vector3(var5_3[1], var5_3[2], var5_3[3])
			var6_3.localEulerAngles = Vector3(var0_3.x * -1, var0_3.y, var0_3.z)
		end
	end

	return var1_3
end

function var2_0.Push(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg1_4) do
		local var0_4 = iter1_4.transform

		var0_4:SetParent(arg0_4._templateContainerTf, false)

		for iter2_4 = var0_4.childCount - 1, 0, -1 do
			var1_0.GetInstance():DestroyOb(var0_4:GetChild(iter2_4).gameObject)
		end
	end

	arg0_4._pool[#arg0_4._pool + 1] = arg1_4
end

function var2_0.Clear(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5._pool) do
		for iter2_5, iter3_5 in ipairs(iter1_5) do
			Object.Destroy(iter3_5)
		end
	end

	arg0_5._pool = nil

	Object.Destroy(arg0_5._templateContainer)

	arg0_5._templateContainer = nil
	arg0_5._templateContainerTf = nil
end
