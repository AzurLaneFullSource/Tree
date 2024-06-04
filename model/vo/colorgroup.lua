local var0 = class("ColorGroup", import(".BaseVO"))

var0.StateLock = 0
var0.StateColoring = 1
var0.StateFinish = 2
var0.StateAchieved = 3

function var0.Ctor(arg0, arg1)
	arg0.id = arg1
	arg0.configId = arg0.id
	arg0.drops = {}
	arg0.fills = {}
	arg0.cells = {}

	_.each(arg0:getConfig("cells"), function(arg0)
		arg0:setCell(arg0[1], arg0[2], arg0[3])
	end)

	arg0.colors = _.map(arg0:getConfig("colors"), function(arg0)
		return Color.New(arg0[1], arg0[2], arg0[3], arg0[4])
	end)
end

function var0.bindConfigTable(arg0)
	return pg.activity_coloring_template
end

function var0.getState(arg0)
	return arg0.state
end

function var0.setState(arg0, arg1)
	arg0.state = arg1
end

function var0.getHasAward(arg0)
	return arg0.hasAward
end

function var0.setHasAward(arg0, arg1)
	arg0.hasAward = arg1
end

function var0.getDrops(arg0)
	return arg0.drops
end

function var0.setDrops(arg0, arg1)
	arg0.drops = arg1
end

function var0.getFill(arg0, arg1, arg2)
	return arg0.fills[arg1 .. "_" .. arg2]
end

function var0.setFill(arg0, arg1, arg2, arg3)
	local var0 = arg1 .. "_" .. arg2

	if arg3 == 0 then
		arg0.fills[var0] = nil
	else
		arg0.fills[var0] = ColorCell.New(arg1, arg2, arg3)
	end
end

function var0.hasFill(arg0, arg1, arg2)
	return arg0:getFill(arg1, arg2) ~= nil
end

function var0.clearFill(arg0)
	arg0.fills = {}
end

function var0.isAllFill(arg0, arg1)
	if arg0:canBeCustomised() then
		return false
	end

	for iter0, iter1 in pairs(arg0.cells) do
		if not arg0.fills[iter0] and (not arg1 or iter1.type == arg1) then
			return false
		end
	end

	return true
end

function var0.getCell(arg0, arg1, arg2)
	return arg0.cells[arg1 .. "_" .. arg2]
end

function var0.setCell(arg0, arg1, arg2, arg3)
	arg0.cells[arg1 .. "_" .. arg2] = ColorCell.New(arg1, arg2, arg3)
end

function var0.hasCell(arg0, arg1, arg2)
	return arg0:getCell(arg1, arg2) ~= nil
end

function var0.canBeCustomised(arg0)
	return arg0:getConfig("blank") == 1
end

function var0.GetAABB(arg0)
	local var0 = 1000
	local var1 = 1000
	local var2 = 0
	local var3 = 0

	assert(next(arg0.cells), "Get AABB from empty List")

	for iter0, iter1 in pairs(arg0.cells) do
		var0 = math.min(var0, iter1.column)
		var1 = math.min(var1, iter1.row)
		var2 = math.max(var2, iter1.column)
		var3 = math.max(var3, iter1.row)
	end

	return Vector2(var0, var1), Vector2(var2, var3)
end

function var0.HasItem2Fill(arg0, arg1)
	local var0 = _.map(arg0:getConfig("color_id_list"), function(arg0)
		return arg1[arg0] or 0
	end)
	local var1, var2 = arg0:GetAABB()
	local var3 = var2.x - var1.x
	local var4 = var2.y - var1.y

	for iter0 = 0, var3 do
		for iter1 = 0, var4 do
			local var5 = iter0 + var1.x
			local var6 = iter1 + var1.y
			local var7 = arg0:getCell(var5, var6)

			if var7 and not arg0:getFill(var5, var6) then
				return (var0[var7.type] or 0) > 0
			end
		end
	end

	return false
end

function var0.HasEnoughItem2FillAll(arg0, arg1)
	local var0 = _.map(arg0:getConfig("color_id_list"), function(arg0)
		return arg1[arg0] or 0
	end)
	local var1 = {}

	_.each(arg0:getConfig("cells"), function(arg0)
		local var0 = arg0[1]
		local var1 = arg0[2]
		local var2 = arg0[3]

		if not arg0:getFill(var0, var1) then
			local var3 = var1[var2] or 0

			var1[var2] = var3 + 1
		end
	end)

	local var2 = true

	for iter0, iter1 in pairs(var1) do
		if iter1 > (var0[iter0] or 0) then
			var2 = false

			break
		end
	end

	return var2
end

return var0
