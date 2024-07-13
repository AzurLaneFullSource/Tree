local var0_0 = class("Context")

var0_0.TRANS_TYPE = {
	CROSS = 1,
	ONE_BY_ONE = 2
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg1_1 = arg1_1 or {}
	arg0_1.mediator = arg1_1.mediator
	arg0_1.viewComponent = arg1_1.viewComponent
	arg0_1.scene = arg1_1.scene
	arg0_1.onRemoved = arg1_1.onRemoved
	arg0_1.cleanStack = defaultValue(arg1_1.cleanStack, false)
	arg0_1.data = arg1_1.data or {}
	arg0_1.parent = arg1_1.parent
	arg0_1.children = {}
	arg0_1.transType = defaultValue(arg1_1.transType, var0_0.TRANS_TYPE.CROSS)
end

function var0_0.extendData(arg0_2, arg1_2)
	if arg1_2 == nil then
		return
	end

	assert(type(arg1_2) == "table", "data object should be a table")

	for iter0_2, iter1_2 in pairs(arg1_2) do
		arg0_2.data[iter0_2] = iter1_2
	end
end

function var0_0.addChild(arg0_3, arg1_3)
	assert(isa(arg1_3, Context), "should be an instance of Context")
	assert(arg1_3.parent == nil, "context already has parent")

	arg1_3.parent = arg0_3

	table.insert(arg0_3.children, arg1_3)
end

function var0_0.addChilds(arg0_4, arg1_4)
	_.each(arg1_4, function(arg0_5)
		arg0_4:addChild(arg0_5)
	end)
end

function var0_0.hasChild(arg0_6)
	return arg0_6.children and #arg0_6.children > 0
end

function var0_0.removeChild(arg0_7, arg1_7)
	assert(isa(arg1_7, Context), "should be an instance of Context")

	for iter0_7, iter1_7 in ipairs(arg0_7.children) do
		if iter1_7 == arg1_7 then
			return table.remove(arg0_7.children, iter0_7)
		end
	end

	return nil
end

function var0_0.retriveLastChild(arg0_8)
	for iter0_8 = #arg0_8.children, 1, -1 do
		if not arg0_8.children[iter0_8].data.isSubView then
			return arg0_8.children[iter0_8]:retriveLastChild()
		end
	end

	return arg0_8
end

function var0_0.GetHierarchy(arg0_9)
	local var0_9 = {
		arg0_9
	}
	local var1_9 = {}

	while #var0_9 > 0 do
		local var2_9 = table.remove(var0_9, 1)

		for iter0_9, iter1_9 in ipairs(var2_9.children) do
			table.insert(var0_9, iter1_9)
		end

		table.insert(var1_9, var2_9)
	end

	return var1_9
end

function var0_0.getContextByMediator(arg0_10, arg1_10)
	local function var0_10(arg0_11, arg1_11)
		if arg0_11.mediator == arg1_11 then
			return arg0_11
		end

		for iter0_11, iter1_11 in ipairs(arg0_11.children) do
			local var0_11 = var0_10(iter1_11, arg1_11)

			if var0_11 ~= nil then
				return var0_11
			end
		end

		return nil
	end

	return var0_10(arg0_10, arg1_10)
end

function var0_0.onContextRemoved(arg0_12)
	return arg0_12.onRemoved and arg0_12.onRemoved()
end

return var0_0
