pg = pg or {}

local var0_0 = singletonClass("NodeMgr")

pg.NodeMgr = var0_0

function var0_0.Ctor(arg0_1)
	return
end

var0_0.NodeBase = {}

function var0_0.RigisterNode(arg0_2, arg1_2)
	var0_0.NodeBase[arg0_2] = arg1_2
end

function var0_0.Ctor(arg0_3)
	return
end

local function var1_0(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = arg0_4.NodeBase[arg2_4[1]]

	if var0_4 == nil then
		assert(false, "配置的节点不存在，检查“没配置串并”、“拼写错误”或“没补include”~ ：" .. arg2_4[1])

		return
	end

	local var1_4 = var0_4.New(arg1_4, arg2_4)

	arg3_4:Add(var1_4)
end

local function var2_0(arg0_5, arg1_5, arg2_5, arg3_5)
	assert(type(arg2_5) == "table", "节点信息解析错误:" .. tostring(arg2_5))

	local var0_5 = arg2_5._parallel

	if var0_5 == nil then
		var1_0(arg0_5, arg1_5, arg2_5, arg3_5)

		return
	end

	if var0_5 == true then
		local var1_5 = var0_0.NodeBase.Guide.New(arg1_5)

		arg3_5:Add(var1_5)

		for iter0_5, iter1_5 in ipairs(arg2_5) do
			local var2_5 = arg3_5.Center:NewSeq(iter0_5)

			arg1_5:AddSeq(var2_5)

			local var3_5 = ys.Battle.NodeData.New(arg1_5:GetUnit(), {}, var2_5)

			var1_5:AddFollow(var2_5, var3_5)
			var2_0(arg0_5, var3_5, iter1_5, var2_5)
		end
	else
		for iter2_5, iter3_5 in ipairs(arg2_5) do
			var2_0(arg0_5, arg1_5, iter3_5, arg3_5)
		end
	end
end

function var0_0.GenNode(arg0_6, arg1_6, arg2_6, arg3_6)
	var2_0(arg0_6, arg1_6, arg2_6, arg3_6)

	for iter0_6, iter1_6 in ipairs(arg1_6:GetAllSeq()) do
		iter1_6:Update()
	end
end
