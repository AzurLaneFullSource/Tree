local var0_0 = class("GraphPath")

GraphPath = var0_0

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.points = {}
	arg0_1.edges = {}

	for iter0_1, iter1_1 in pairs(arg1_1.Points) do
		local var0_1 = {
			id = iter0_1,
			nexts = {}
		}

		table.merge(var0_1, iter1_1)

		arg0_1.points[iter0_1] = setmetatable(var0_1, Vector2)
	end

	for iter2_1, iter3_1 in pairs(arg1_1.Edges) do
		local var1_1 = arg0_1.points[iter3_1.p1]
		local var2_1 = arg0_1.points[iter3_1.p2]

		if var1_1 and var2_1 and var1_1 ~= var2_1 then
			table.insert(var1_1.nexts, iter3_1.p2)
			table.insert(var2_1.nexts, iter3_1.p1)

			arg0_1.edges[var1_1] = arg0_1.edges[var1_1] or {}
			arg0_1.edges[var1_1][var2_1] = iter3_1
			arg0_1.edges[var2_1] = arg0_1.edges[var2_1] or {}
			arg0_1.edges[var2_1][var1_1] = iter3_1
		end
	end
end

function var0_0.getRandomPoint(arg0_2)
	local var0_2 = _.values(arg0_2.points)

	return var0_2[math.random(1, #var0_2)]
end

function var0_0.getPoint(arg0_3, arg1_3)
	return arg0_3.points[arg1_3]
end

function var0_0.getEdge(arg0_4, arg1_4, arg2_4)
	return arg0_4.edges[arg1_4] and arg0_4.edges[arg1_4][arg2_4]
end
