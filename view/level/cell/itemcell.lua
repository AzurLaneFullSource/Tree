local var0 = class("ItemCell", import("view.level.cell.LevelCellView"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0)

	arg0.go = arg1
	arg0.tf = arg0.go.transform
	arg0.line = {
		row = arg2,
		column = arg3
	}
	arg0.assetName = nil

	arg0:OverrideCanvas()
	arg0:ResetCanvasOrder()
end

function var0.Init(arg0, arg1)
	if not arg1 then
		return
	end

	arg0.info = CreateShell(arg1)
end

function var0.GetInfo(arg0)
	return arg0.info
end

function var0.GetOriginalInfo(arg0)
	local var0 = arg0.info and getmetatable(arg0.info)

	return var0 and var0.__index
end

function var0.Update(arg0)
	local var0 = arg0.info

	arg0.loader:GetPrefabBYStopLoading("chapter/" .. var0.item, var0.item, function(arg0)
		local var0 = arg0.transform

		var0.name = var0.item

		var0:SetParent(arg0.go, false)

		var0.anchoredPosition3D = var0.itemOffset

		arg0:RecordCanvasOrder(var0)
		arg0:AddCanvasOrder(var0, arg0:GetCurrentOrder())
	end, "ChapterItem" .. arg0.line.row .. "_" .. arg0.line.column)
end

function var0.UpdateAsset(arg0, arg1)
	if not arg0.info or not arg1 or arg1 == rawget(arg0.info, "item") then
		return
	end

	arg0.info.item = arg1

	arg0:Update()
end

function var0.ClearLoader(arg0)
	return
end

function var0.Clear(arg0)
	arg0.loader:ClearRequest("ChapterItem" .. arg0.line.row .. "_" .. arg0.line.column)
	var0.super.Clear(arg0)
end

function var0.TransformItemAsset(arg0, arg1)
	if type(arg1) ~= "string" then
		return
	end

	local var0 = arg0:getConfig("ItemTransformPattern")

	if type(var0) ~= "table" then
		return arg1
	end

	_.each(arg0:getExtraFlags(), function(arg0)
		if var0[arg0] and (function()
			local var0 = var0[arg0][3]

			if not var0 then
				return true
			end

			return var0 >= math.random()
		end)() then
			arg1 = string.gsub(arg1, var0[arg0][1], var0[arg0][2])
		end
	end)

	return arg1
end

return var0
