local var0_0 = class("GuildDynamicFurniture")

var0_0.INTERACTION_MODE_SIT = 1

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1.go
	arg0_1._tf = GetOrAddComponent(arg1_1.go, typeof(RectTransform))
	arg0_1.size = arg1_1.size
	arg0_1.path = arg1_1.path
	arg0_1.offset = arg1_1.offset
	arg0_1.mode = arg1_1.mode
	arg0_1.interactionDir = arg1_1.interactionDir or 1
	arg0_1.interactionPosition = arg1_1.interactionPosition

	arg0_1:SetPosition(arg1_1.grid)

	arg0_1.islock = false
end

function var0_0.SetPosition(arg0_2, arg1_2)
	local var0_2 = arg1_2:GetLocalPosition()

	arg0_2._tf.localPosition = Vector3(var0_2.x + arg0_2.offset.x, var0_2.y + arg0_2.offset.y, 0)
	arg0_2.grid = arg1_2

	local var1_2 = arg0_2:GetOccupyGrid()

	for iter0_2, iter1_2 in ipairs(var1_2) do
		iter1_2:Lock()
	end
end

function var0_0.GetOccupyGrid(arg0_3)
	local var0_3 = {}
	local var1_3 = arg0_3.grid.position

	for iter0_3 = 0, arg0_3.size.x - 1 do
		for iter1_3 = 0, arg0_3.size.y - 1 do
			local var2_3 = var1_3.x
			local var3_3 = var1_3.y
			local var4_3 = arg0_3.path[var2_3 + iter0_3][var3_3 + iter1_3]

			table.insert(var0_3, var4_3)
		end
	end

	return var0_3
end

function var0_0.Lock(arg0_4)
	arg0_4.islock = true
end

function var0_0.Unlock(arg0_5)
	arg0_5.islock = false
end

function var0_0.BeLock(arg0_6)
	return arg0_6.islock == true
end

function var0_0.GetInterActionPos(arg0_7)
	return arg0_7.interactionPosition
end

function var0_0.GetInterActionMode(arg0_8)
	return arg0_8.mode
end

function var0_0.SetAsLastSibling(arg0_9)
	arg0_9._tf:SetAsLastSibling()
end

function var0_0.GetInteractionDir(arg0_10)
	return arg0_10.interactionDir
end

function var0_0.Dispose(arg0_11)
	return
end

return var0_0
