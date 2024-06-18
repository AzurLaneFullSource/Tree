local var0_0 = class("ColorGroup", import(".BaseVO"))

var0_0.StateLock = 0
var0_0.StateColoring = 1
var0_0.StateFinish = 2
var0_0.StateAchieved = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id
	arg0_1.drops = {}
	arg0_1.fills = {}
	arg0_1.cells = {}

	_.each(arg0_1:getConfig("cells"), function(arg0_2)
		arg0_1:setCell(arg0_2[1], arg0_2[2], arg0_2[3])
	end)

	arg0_1.colors = _.map(arg0_1:getConfig("colors"), function(arg0_3)
		return Color.New(arg0_3[1], arg0_3[2], arg0_3[3], arg0_3[4])
	end)
end

function var0_0.bindConfigTable(arg0_4)
	return pg.activity_coloring_template
end

function var0_0.getState(arg0_5)
	return arg0_5.state
end

function var0_0.setState(arg0_6, arg1_6)
	arg0_6.state = arg1_6
end

function var0_0.getHasAward(arg0_7)
	return arg0_7.hasAward
end

function var0_0.setHasAward(arg0_8, arg1_8)
	arg0_8.hasAward = arg1_8
end

function var0_0.getDrops(arg0_9)
	return arg0_9.drops
end

function var0_0.setDrops(arg0_10, arg1_10)
	arg0_10.drops = arg1_10
end

function var0_0.getFill(arg0_11, arg1_11, arg2_11)
	return arg0_11.fills[arg1_11 .. "_" .. arg2_11]
end

function var0_0.setFill(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = arg1_12 .. "_" .. arg2_12

	if arg3_12 == 0 then
		arg0_12.fills[var0_12] = nil
	else
		arg0_12.fills[var0_12] = ColorCell.New(arg1_12, arg2_12, arg3_12)
	end
end

function var0_0.hasFill(arg0_13, arg1_13, arg2_13)
	return arg0_13:getFill(arg1_13, arg2_13) ~= nil
end

function var0_0.clearFill(arg0_14)
	arg0_14.fills = {}
end

function var0_0.isAllFill(arg0_15, arg1_15)
	if arg0_15:canBeCustomised() then
		return false
	end

	for iter0_15, iter1_15 in pairs(arg0_15.cells) do
		if not arg0_15.fills[iter0_15] and (not arg1_15 or iter1_15.type == arg1_15) then
			return false
		end
	end

	return true
end

function var0_0.getCell(arg0_16, arg1_16, arg2_16)
	return arg0_16.cells[arg1_16 .. "_" .. arg2_16]
end

function var0_0.setCell(arg0_17, arg1_17, arg2_17, arg3_17)
	arg0_17.cells[arg1_17 .. "_" .. arg2_17] = ColorCell.New(arg1_17, arg2_17, arg3_17)
end

function var0_0.hasCell(arg0_18, arg1_18, arg2_18)
	return arg0_18:getCell(arg1_18, arg2_18) ~= nil
end

function var0_0.canBeCustomised(arg0_19)
	return arg0_19:getConfig("blank") == 1
end

function var0_0.GetAABB(arg0_20)
	local var0_20 = 1000
	local var1_20 = 1000
	local var2_20 = 0
	local var3_20 = 0

	assert(next(arg0_20.cells), "Get AABB from empty List")

	for iter0_20, iter1_20 in pairs(arg0_20.cells) do
		var0_20 = math.min(var0_20, iter1_20.column)
		var1_20 = math.min(var1_20, iter1_20.row)
		var2_20 = math.max(var2_20, iter1_20.column)
		var3_20 = math.max(var3_20, iter1_20.row)
	end

	return Vector2(var0_20, var1_20), Vector2(var2_20, var3_20)
end

function var0_0.HasItem2Fill(arg0_21, arg1_21)
	local var0_21 = _.map(arg0_21:getConfig("color_id_list"), function(arg0_22)
		return arg1_21[arg0_22] or 0
	end)
	local var1_21, var2_21 = arg0_21:GetAABB()
	local var3_21 = var2_21.x - var1_21.x
	local var4_21 = var2_21.y - var1_21.y

	for iter0_21 = 0, var3_21 do
		for iter1_21 = 0, var4_21 do
			local var5_21 = iter0_21 + var1_21.x
			local var6_21 = iter1_21 + var1_21.y
			local var7_21 = arg0_21:getCell(var5_21, var6_21)

			if var7_21 and not arg0_21:getFill(var5_21, var6_21) then
				return (var0_21[var7_21.type] or 0) > 0
			end
		end
	end

	return false
end

function var0_0.HasEnoughItem2FillAll(arg0_23, arg1_23)
	local var0_23 = _.map(arg0_23:getConfig("color_id_list"), function(arg0_24)
		return arg1_23[arg0_24] or 0
	end)
	local var1_23 = {}

	_.each(arg0_23:getConfig("cells"), function(arg0_25)
		local var0_25 = arg0_25[1]
		local var1_25 = arg0_25[2]
		local var2_25 = arg0_25[3]

		if not arg0_23:getFill(var0_25, var1_25) then
			local var3_25 = var1_23[var2_25] or 0

			var1_23[var2_25] = var3_25 + 1
		end
	end)

	local var2_23 = true

	for iter0_23, iter1_23 in pairs(var1_23) do
		if iter1_23 > (var0_23[iter0_23] or 0) then
			var2_23 = false

			break
		end
	end

	return var2_23
end

return var0_0
