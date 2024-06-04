local var0 = class("GuildDynamicFurniture")

var0.INTERACTION_MODE_SIT = 1

function var0.Ctor(arg0, arg1)
	arg0._go = arg1.go
	arg0._tf = GetOrAddComponent(arg1.go, typeof(RectTransform))
	arg0.size = arg1.size
	arg0.path = arg1.path
	arg0.offset = arg1.offset
	arg0.mode = arg1.mode
	arg0.interactionDir = arg1.interactionDir or 1
	arg0.interactionPosition = arg1.interactionPosition

	arg0:SetPosition(arg1.grid)

	arg0.islock = false
end

function var0.SetPosition(arg0, arg1)
	local var0 = arg1:GetLocalPosition()

	arg0._tf.localPosition = Vector3(var0.x + arg0.offset.x, var0.y + arg0.offset.y, 0)
	arg0.grid = arg1

	local var1 = arg0:GetOccupyGrid()

	for iter0, iter1 in ipairs(var1) do
		iter1:Lock()
	end
end

function var0.GetOccupyGrid(arg0)
	local var0 = {}
	local var1 = arg0.grid.position

	for iter0 = 0, arg0.size.x - 1 do
		for iter1 = 0, arg0.size.y - 1 do
			local var2 = var1.x
			local var3 = var1.y
			local var4 = arg0.path[var2 + iter0][var3 + iter1]

			table.insert(var0, var4)
		end
	end

	return var0
end

function var0.Lock(arg0)
	arg0.islock = true
end

function var0.Unlock(arg0)
	arg0.islock = false
end

function var0.BeLock(arg0)
	return arg0.islock == true
end

function var0.GetInterActionPos(arg0)
	return arg0.interactionPosition
end

function var0.GetInterActionMode(arg0)
	return arg0.mode
end

function var0.SetAsLastSibling(arg0)
	arg0._tf:SetAsLastSibling()
end

function var0.GetInteractionDir(arg0)
	return arg0.interactionDir
end

function var0.Dispose(arg0)
	return
end

return var0
