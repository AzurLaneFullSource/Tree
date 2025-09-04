local var0_0 = class("AgoraBaseTheme")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.name = arg1_1.name
	arg0_1.placedlist = {}
	arg0_1.floorData = {}
	arg0_1.tileData = {}
end

function var0_0.GetPlacedData(arg0_2)
	return arg0_2.placedlist
end

function var0_0.GetSeparatedPlacedData(arg0_3)
	local var0_3 = {}
	local var1_3
	local var2_3

	for iter0_3, iter1_3 in ipairs(arg0_3.placedlist) do
		if iter1_3:IsFoundationType() then
			var1_3 = iter1_3
		elseif iter1_3:IsBuildingType() then
			var2_3 = iter1_3
		else
			table.insert(var0_3, iter1_3)
		end
	end

	return var0_3, var1_3, var2_3
end

function var0_0.GetFloorData(arg0_4)
	return arg0_4.floorData
end

function var0_0.GetTileData(arg0_5)
	return arg0_5.tileData
end

return var0_0
