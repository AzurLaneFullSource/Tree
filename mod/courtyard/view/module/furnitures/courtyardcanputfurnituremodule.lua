local var0_0 = class("CourtYardCanPutFurnitureModule", import(".CourtYardFurnitureModule"))
local var1_0 = false

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.childModules = {}
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)

	if var1_0 then
		arg0_2.mapDebug = CourtYardMapDebug.New(arg0_2.data.placeableArea, Color.New(1, 0, 0))
		GetOrAddComponent(arg0_2:GetParentTF(), typeof(CanvasGroup)).alpha = 0.3
	end

	arg0_2:RefreshDepth()
end

function var0_0.AddChild(arg0_3, arg1_3)
	arg0_3:CancelPuddingAnim()
	arg1_3:CancelPuddingAnim()

	local var0_3 = arg1_3.data:GetDeathType() .. arg1_3.data.id

	arg0_3.childModules[var0_3] = arg1_3

	arg1_3._tf:SetParent(arg0_3.childsTF)
end

function var0_0.RemoveChild(arg0_4, arg1_4)
	local var0_4 = arg1_4.data:GetDeathType() .. arg1_4.data.id

	arg0_4.childModules[var0_4] = nil

	arg1_4._tf:SetParent(arg0_4:GetParentTF())
end

function var0_0.AddListeners(arg0_5)
	var0_0.super.AddListeners(arg0_5)
	arg0_5:AddAreaListener(CourtYardEvent.REMOVE_ITEM, arg0_5.OnRemoveItem)
	arg0_5:AddAreaListener(CourtYardEvent.ADD_ITEM, arg0_5.OnAddItem)
end

function var0_0.RemoveListeners(arg0_6)
	var0_0.super.RemoveListeners(arg0_6)
	arg0_6:RemoveAreaListener(CourtYardEvent.REMOVE_ITEM, arg0_6.OnRemoveItem)
	arg0_6:RemoveAreaListener(CourtYardEvent.ADD_ITEM, arg0_6.OnAddItem)
end

function var0_0.AddAreaListener(arg0_7, arg1_7, arg2_7)
	local function var0_7(arg0_8, arg1_8, ...)
		arg2_7(arg0_7, ...)
	end

	arg0_7.callbacks[arg2_7] = var0_7

	arg0_7.data.placeableArea:AddListener(arg1_7, var0_7)
end

function var0_0.RemoveAreaListener(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.callbacks[arg2_9]

	if var0_9 then
		arg0_9.data.placeableArea:RemoveListener(arg1_9, var0_9)

		arg0_9.callbacks[var0_9] = nil
	end
end

function var0_0.OnRemoveItem(arg0_10, arg1_10)
	local var0_10 = arg1_10:GetDeathType() .. arg1_10.id

	arg0_10.childModules[var0_10]._tf:SetParent(arg0_10:GetParentTF())

	if var1_0 then
		arg0_10.mapDebug:Flush()
	end
end

function var0_0.OnAddItem(arg0_11, arg1_11)
	local var0_11 = arg1_11:GetDeathType() .. arg1_11.id
	local var1_11 = arg0_11.childModules[var0_11]

	var1_11._tf:SetParent(arg0_11.childsTF)

	local var2_11 = arg1_11:GetOffset()

	var1_11._tf.localPosition = var1_11._tf.localPosition + var2_11

	arg0_11:RefreshDepth()

	if var1_0 then
		arg0_11.mapDebug:Flush()
	end
end

function var0_0.RefreshDepth(arg0_12)
	for iter0_12, iter1_12 in ipairs(arg0_12.data.placeableArea:GetItems()) do
		local var0_12 = iter1_12:GetDeathType() .. iter1_12.id

		arg0_12.childModules[var0_12]:SetSiblingIndex(iter0_12 - 1)
	end
end

function var0_0.BlocksRaycasts(arg0_13, arg1_13)
	local var0_13 = arg0_13.data:CanClickWhenExitEditMode()
	local var1_13 = #arg0_13.data:GetUsingSlots() > 0 or table.getCount(arg0_13.childModules) > 0

	if (var0_13 or var1_13) and arg1_13 == false then
		return
	end

	arg0_13.cg.blocksRaycasts = arg1_13
end

function var0_0.Dispose(arg0_14)
	var0_0.super.Dispose(arg0_14)

	if var1_0 then
		arg0_14.mapDebug:Dispose()

		GetOrAddComponent(arg0_14:GetParentTF(), typeof(CanvasGroup)).alpha = 1
	end
end

return var0_0
