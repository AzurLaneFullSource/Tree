local var0_0 = class("ItemCell", import("view.level.cell.LevelCellView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.go = arg1_1
	arg0_1.tf = arg0_1.go.transform
	arg0_1.line = {
		row = arg2_1,
		column = arg3_1
	}
	arg0_1.assetName = nil

	arg0_1:OverrideCanvas()
	arg0_1:ResetCanvasOrder()
end

function var0_0.Init(arg0_2, arg1_2)
	if not arg1_2 then
		return
	end

	arg0_2.info = CreateShell(arg1_2)
end

function var0_0.GetInfo(arg0_3)
	return arg0_3.info
end

function var0_0.GetOriginalInfo(arg0_4)
	local var0_4 = arg0_4.info and getmetatable(arg0_4.info)

	return var0_4 and var0_4.__index
end

function var0_0.Update(arg0_5)
	local var0_5 = arg0_5.info

	arg0_5.loader:GetPrefabBYStopLoading("chapter/" .. var0_5.item, var0_5.item, function(arg0_6)
		local var0_6 = arg0_6.transform

		var0_6.name = var0_5.item

		var0_6:SetParent(arg0_5.go, false)

		var0_6.anchoredPosition3D = var0_5.itemOffset

		arg0_5:RecordCanvasOrder(var0_6)
		arg0_5:AddCanvasOrder(var0_6, arg0_5:GetCurrentOrder())
	end, "ChapterItem" .. arg0_5.line.row .. "_" .. arg0_5.line.column)
end

function var0_0.UpdateAsset(arg0_7, arg1_7)
	if not arg0_7.info or not arg1_7 or arg1_7 == rawget(arg0_7.info, "item") then
		return
	end

	arg0_7.info.item = arg1_7

	arg0_7:Update()
end

function var0_0.ClearLoader(arg0_8)
	return
end

function var0_0.Clear(arg0_9)
	arg0_9.loader:ClearRequest("ChapterItem" .. arg0_9.line.row .. "_" .. arg0_9.line.column)
	var0_0.super.Clear(arg0_9)
end

function var0_0.TransformItemAsset(arg0_10, arg1_10)
	if type(arg1_10) ~= "string" then
		return
	end

	local var0_10 = arg0_10:getConfig("ItemTransformPattern")

	if type(var0_10) ~= "table" then
		return arg1_10
	end

	_.each(arg0_10:getExtraFlags(), function(arg0_11)
		if var0_10[arg0_11] and (function()
			local var0_12 = var0_10[arg0_11][3]

			if not var0_12 then
				return true
			end

			return var0_12 >= math.random()
		end)() then
			arg1_10 = string.gsub(arg1_10, var0_10[arg0_11][1], var0_10[arg0_11][2])
		end
	end)

	return arg1_10
end

return var0_0
