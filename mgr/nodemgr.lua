pg = pg or {}

local var0 = singletonClass("NodeMgr")

pg.NodeMgr = var0

function var0.Ctor(arg0)
	return
end

var0.NodeBase = {}

function var0.RigisterNode(arg0, arg1)
	var0.NodeBase[arg0] = arg1
end

function var0.Ctor(arg0)
	return
end

local function var1(arg0, arg1, arg2, arg3)
	local var0 = arg0.NodeBase[arg2[1]]

	if var0 == nil then
		assert(false, "配置的节点不存在，检查“没配置串并”、“拼写错误”或“没补include”~ ：" .. arg2[1])

		return
	end

	local var1 = var0.New(arg1, arg2)

	arg3:Add(var1)
end

local function var2(arg0, arg1, arg2, arg3)
	assert(type(arg2) == "table", "节点信息解析错误:" .. tostring(arg2))

	local var0 = arg2._parallel

	if var0 == nil then
		var1(arg0, arg1, arg2, arg3)

		return
	end

	if var0 == true then
		local var1 = var0.NodeBase.Guide.New(arg1)

		arg3:Add(var1)

		for iter0, iter1 in ipairs(arg2) do
			local var2 = arg3.Center:NewSeq(iter0)

			arg1:AddSeq(var2)

			local var3 = ys.Battle.NodeData.New(arg1:GetUnit(), {}, var2)

			var1:AddFollow(var2, var3)
			var2(arg0, var3, iter1, var2)
		end
	else
		for iter2, iter3 in ipairs(arg2) do
			var2(arg0, arg1, iter3, arg3)
		end
	end
end

function var0.GenNode(arg0, arg1, arg2, arg3)
	var2(arg0, arg1, arg2, arg3)

	for iter0, iter1 in ipairs(arg1:GetAllSeq()) do
		iter1:Update()
	end
end
