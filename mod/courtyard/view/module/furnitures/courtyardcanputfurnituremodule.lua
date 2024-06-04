local var0 = class("CourtYardCanPutFurnitureModule", import(".CourtYardFurnitureModule"))
local var1 = false

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.childModules = {}
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	if var1 then
		arg0.mapDebug = CourtYardMapDebug.New(arg0.data.placeableArea, Color.New(1, 0, 0))
		GetOrAddComponent(arg0:GetParentTF(), typeof(CanvasGroup)).alpha = 0.3
	end

	arg0:RefreshDepth()
end

function var0.AddChild(arg0, arg1)
	arg0:CancelPuddingAnim()
	arg1:CancelPuddingAnim()

	local var0 = arg1.data:GetDeathType() .. arg1.data.id

	arg0.childModules[var0] = arg1

	arg1._tf:SetParent(arg0.childsTF)
end

function var0.RemoveChild(arg0, arg1)
	local var0 = arg1.data:GetDeathType() .. arg1.data.id

	arg0.childModules[var0] = nil

	arg1._tf:SetParent(arg0:GetParentTF())
end

function var0.AddListeners(arg0)
	var0.super.AddListeners(arg0)
	arg0:AddAreaListener(CourtYardEvent.REMOVE_ITEM, arg0.OnRemoveItem)
	arg0:AddAreaListener(CourtYardEvent.ADD_ITEM, arg0.OnAddItem)
end

function var0.RemoveListeners(arg0)
	var0.super.RemoveListeners(arg0)
	arg0:RemoveAreaListener(CourtYardEvent.REMOVE_ITEM, arg0.OnRemoveItem)
	arg0:RemoveAreaListener(CourtYardEvent.ADD_ITEM, arg0.OnAddItem)
end

function var0.AddAreaListener(arg0, arg1, arg2)
	local function var0(arg0, arg1, ...)
		arg2(arg0, ...)
	end

	arg0.callbacks[arg2] = var0

	arg0.data.placeableArea:AddListener(arg1, var0)
end

function var0.RemoveAreaListener(arg0, arg1, arg2)
	local var0 = arg0.callbacks[arg2]

	if var0 then
		arg0.data.placeableArea:RemoveListener(arg1, var0)

		arg0.callbacks[var0] = nil
	end
end

function var0.OnRemoveItem(arg0, arg1)
	local var0 = arg1:GetDeathType() .. arg1.id

	arg0.childModules[var0]._tf:SetParent(arg0:GetParentTF())

	if var1 then
		arg0.mapDebug:Flush()
	end
end

function var0.OnAddItem(arg0, arg1)
	local var0 = arg1:GetDeathType() .. arg1.id
	local var1 = arg0.childModules[var0]

	var1._tf:SetParent(arg0.childsTF)

	local var2 = arg1:GetOffset()

	var1._tf.localPosition = var1._tf.localPosition + var2

	arg0:RefreshDepth()

	if var1 then
		arg0.mapDebug:Flush()
	end
end

function var0.RefreshDepth(arg0)
	for iter0, iter1 in ipairs(arg0.data.placeableArea:GetItems()) do
		local var0 = iter1:GetDeathType() .. iter1.id

		arg0.childModules[var0]:SetSiblingIndex(iter0 - 1)
	end
end

function var0.BlocksRaycasts(arg0, arg1)
	local var0 = arg0.data:CanClickWhenExitEditMode()
	local var1 = #arg0.data:GetUsingSlots() > 0 or table.getCount(arg0.childModules) > 0

	if (var0 or var1) and arg1 == false then
		return
	end

	arg0.cg.blocksRaycasts = arg1
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)

	if var1 then
		arg0.mapDebug:Dispose()

		GetOrAddComponent(arg0:GetParentTF(), typeof(CanvasGroup)).alpha = 1
	end
end

return var0
