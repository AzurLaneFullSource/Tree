local var0_0 = class("AgoraDataComparator")

var0_0.CHANGE_TYPE_PLACED = 2
var0_0.CHANGE_TYPE_FLOOR = 4
var0_0.CHANGE_TYPE_TILE = 8

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.agora = arg1_1
	arg0_1.isTake = false
	arg0_1.allCode = IndexConst.BitAll({
		var0_0.CHANGE_TYPE_PLACED,
		var0_0.CHANGE_TYPE_FLOOR,
		var0_0.CHANGE_TYPE_TILE
	})
end

function var0_0.TakeSample(arg0_2)
	arg0_2.placedData = Clone(arg0_2.agora:GetPlacedlist())
	arg0_2.floorData = Clone(arg0_2.agora:GetFloorLayer())
	arg0_2.tileData = Clone(arg0_2.agora:GetTileLayer())
	arg0_2.isTake = true
end

function var0_0.GetSample(arg0_3)
	return arg0_3.placedData, arg0_3.floorData, arg0_3.tileData
end

function var0_0.AnyChanged(arg0_4)
	if not arg0_4.isTake then
		return false
	end

	local var0_4 = arg0_4.agora:GetPlacedlist()
	local var1_4 = arg0_4.agora:GetFloorLayer()
	local var2_4 = arg0_4.agora:GetTileLayer()
	local var3_4 = 0

	if arg0_4:ComparePlacedData(var0_4, arg0_4.placedData) then
		var3_4 = bit.bor(var3_4, var0_0.CHANGE_TYPE_PLACED)
	end

	if arg0_4:CompareLayer(var1_4, arg0_4.floorData) then
		var3_4 = bit.bor(var3_4, var0_0.CHANGE_TYPE_FLOOR)
	end

	if arg0_4:CompareLayer(var2_4, arg0_4.tileData) then
		var3_4 = bit.bor(var3_4, var0_0.CHANGE_TYPE_TILE)
	end

	return bit.band(var3_4, arg0_4.allCode) > 0, var3_4
end

function var0_0.ComparePlacedData(arg0_5, arg1_5, arg2_5)
	if table.getCount(arg1_5) ~= table.getCount(arg2_5) then
		return true
	end

	for iter0_5, iter1_5 in pairs(arg2_5) do
		local var0_5 = arg1_5[iter0_5]

		if not var0_5 or not var0_5:IsSame(iter1_5) then
			return true
		end
	end

	for iter2_5, iter3_5 in pairs(arg1_5) do
		local var1_5 = arg2_5[iter2_5]

		if not var1_5 or not var1_5:IsSame(iter3_5) then
			return true
		end
	end

	return false
end

function var0_0.CompareLayer(arg0_6, arg1_6, arg2_6)
	for iter0_6, iter1_6 in pairs(arg1_6) do
		for iter2_6, iter3_6 in pairs(iter1_6) do
			local var0_6 = arg2_6[iter0_6][iter2_6]

			if not var0_6 or not var0_6:IsSame(iter3_6) then
				return true
			end
		end
	end

	return false
end

function var0_0.Abort(arg0_7)
	arg0_7.placedData = nil
	arg0_7.floorData = nil
	arg0_7.tileData = nil
	arg0_7.isTake = false
end

function var0_0.Dispose(arg0_8)
	arg0_8:Abort()
end

return var0_0
