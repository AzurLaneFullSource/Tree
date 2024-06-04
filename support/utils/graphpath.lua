local var0 = class("GraphPath")

GraphPath = var0

function var0.Ctor(arg0, arg1)
	arg0.points = {}
	arg0.edges = {}

	for iter0, iter1 in pairs(arg1.Points) do
		local var0 = {
			id = iter0,
			nexts = {}
		}

		table.merge(var0, iter1)

		arg0.points[iter0] = setmetatable(var0, Vector2)
	end

	for iter2, iter3 in pairs(arg1.Edges) do
		local var1 = arg0.points[iter3.p1]
		local var2 = arg0.points[iter3.p2]

		if var1 and var2 and var1 ~= var2 then
			table.insert(var1.nexts, iter3.p2)
			table.insert(var2.nexts, iter3.p1)

			arg0.edges[var1] = arg0.edges[var1] or {}
			arg0.edges[var1][var2] = iter3
			arg0.edges[var2] = arg0.edges[var2] or {}
			arg0.edges[var2][var1] = iter3
		end
	end
end

function var0.getRandomPoint(arg0)
	local var0 = _.values(arg0.points)

	return var0[math.random(1, #var0)]
end

function var0.getPoint(arg0, arg1)
	return arg0.points[arg1]
end

function var0.getEdge(arg0, arg1, arg2)
	return arg0.edges[arg1] and arg0.edges[arg1][arg2]
end
