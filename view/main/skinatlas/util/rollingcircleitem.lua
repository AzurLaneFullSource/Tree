local var0 = class("RollingCircleItem")
local var1 = 73

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.tr = arg1
	arg0._tr = arg1
	arg0.id = arg3

	arg0:SetIndex(arg2)
end

function var0.GetID(arg0)
	return arg0.id
end

function var0.GetIndex(arg0)
	return arg0.index
end

function var0.SetIndex(arg0, arg1)
	arg0.index = arg1
	arg0.tr.gameObject.name = arg1
end

function var0.IsCenter(arg0, arg1)
	return arg0.index == arg1
end

function var0.SetPrev(arg0, arg1)
	arg0.prev = arg1
end

function var0.SetNext(arg0, arg1)
	arg0.nex = arg1
end

function var0.Init(arg0)
	local var0 = arg0.prev

	if not var0 then
		return
	end

	local var1 = var0:GetLocalposition()
	local var2 = var0:GetSpace()

	arg0:UpdateLocalPosition(Vector3(var1.x, var1.y - var2, 0))
end

function var0.GetSpace(arg0)
	return var1
end

function var0.GetLocalposition(arg0)
	return arg0.tr.localPosition
end

function var0.UpdateLocalPosition(arg0, arg1)
	arg0.tr.localPosition = arg1
end

function var0.Record(arg0)
	arg0.lastIndex = arg0.index
	arg0.lastLocalPosition = arg0:GetLocalposition()
end

function var0.GetLastPositionAndIndex(arg0)
	return arg0.lastLocalPosition, arg0.lastIndex
end

function var0.GoForward(arg0)
	if arg0.nex then
		local var0, var1 = arg0.nex:GetLastPositionAndIndex()

		arg0:SetIndex(var1)
		arg0:UpdateLocalPosition(var0)
	end
end

function var0.GoBack(arg0)
	if arg0.prev then
		local var0, var1 = arg0.prev:GetLastPositionAndIndex()

		arg0:SetIndex(var1)
		arg0:UpdateLocalPosition(var0)
	end
end

function var0.Dispose(arg0)
	Object.Destroy(arg0.tr.gameObject)

	arg0.prev = nil
	arg0.nex = nil
end

return var0
