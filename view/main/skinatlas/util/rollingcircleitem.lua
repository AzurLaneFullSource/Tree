local var0_0 = class("RollingCircleItem")
local var1_0 = 73

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.tr = arg1_1
	arg0_1._tr = arg1_1
	arg0_1.id = arg3_1

	arg0_1:SetIndex(arg2_1)
end

function var0_0.GetID(arg0_2)
	return arg0_2.id
end

function var0_0.GetIndex(arg0_3)
	return arg0_3.index
end

function var0_0.SetIndex(arg0_4, arg1_4)
	arg0_4.index = arg1_4
	arg0_4.tr.gameObject.name = arg1_4
end

function var0_0.IsCenter(arg0_5, arg1_5)
	return arg0_5.index == arg1_5
end

function var0_0.SetPrev(arg0_6, arg1_6)
	arg0_6.prev = arg1_6
end

function var0_0.SetNext(arg0_7, arg1_7)
	arg0_7.nex = arg1_7
end

function var0_0.Init(arg0_8)
	local var0_8 = arg0_8.prev

	if not var0_8 then
		return
	end

	local var1_8 = var0_8:GetLocalposition()
	local var2_8 = var0_8:GetSpace()

	arg0_8:UpdateLocalPosition(Vector3(var1_8.x, var1_8.y - var2_8, 0))
end

function var0_0.GetSpace(arg0_9)
	return var1_0
end

function var0_0.GetLocalposition(arg0_10)
	return arg0_10.tr.localPosition
end

function var0_0.UpdateLocalPosition(arg0_11, arg1_11)
	arg0_11.tr.localPosition = arg1_11
end

function var0_0.Record(arg0_12)
	arg0_12.lastIndex = arg0_12.index
	arg0_12.lastLocalPosition = arg0_12:GetLocalposition()
end

function var0_0.GetLastPositionAndIndex(arg0_13)
	return arg0_13.lastLocalPosition, arg0_13.lastIndex
end

function var0_0.GoForward(arg0_14)
	if arg0_14.nex then
		local var0_14, var1_14 = arg0_14.nex:GetLastPositionAndIndex()

		arg0_14:SetIndex(var1_14)
		arg0_14:UpdateLocalPosition(var0_14)
	end
end

function var0_0.GoBack(arg0_15)
	if arg0_15.prev then
		local var0_15, var1_15 = arg0_15.prev:GetLastPositionAndIndex()

		arg0_15:SetIndex(var1_15)
		arg0_15:UpdateLocalPosition(var0_15)
	end
end

function var0_0.Dispose(arg0_16)
	Object.Destroy(arg0_16.tr.gameObject)

	arg0_16.prev = nil
	arg0_16.nex = nil
end

return var0_0
