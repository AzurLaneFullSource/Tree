local var0 = class("Context")

var0.TRANS_TYPE = {
	CROSS = 1,
	ONE_BY_ONE = 2
}

function var0.Ctor(arg0, arg1)
	arg1 = arg1 or {}
	arg0.mediator = arg1.mediator
	arg0.viewComponent = arg1.viewComponent
	arg0.scene = arg1.scene
	arg0.onRemoved = arg1.onRemoved
	arg0.cleanStack = defaultValue(arg1.cleanStack, false)
	arg0.data = arg1.data or {}
	arg0.parent = arg1.parent
	arg0.children = {}
	arg0.transType = defaultValue(arg1.transType, var0.TRANS_TYPE.CROSS)
end

function var0.extendData(arg0, arg1)
	if arg1 == nil then
		return
	end

	assert(type(arg1) == "table", "data object should be a table")

	for iter0, iter1 in pairs(arg1) do
		arg0.data[iter0] = iter1
	end
end

function var0.addChild(arg0, arg1)
	assert(isa(arg1, Context), "should be an instance of Context")
	assert(arg1.parent == nil, "context already has parent")

	arg1.parent = arg0

	table.insert(arg0.children, arg1)
end

function var0.addChilds(arg0, arg1)
	_.each(arg1, function(arg0)
		arg0:addChild(arg0)
	end)
end

function var0.hasChild(arg0)
	return arg0.children and #arg0.children > 0
end

function var0.removeChild(arg0, arg1)
	assert(isa(arg1, Context), "should be an instance of Context")

	for iter0, iter1 in ipairs(arg0.children) do
		if iter1 == arg1 then
			return table.remove(arg0.children, iter0)
		end
	end

	return nil
end

function var0.retriveLastChild(arg0)
	for iter0 = #arg0.children, 1, -1 do
		if not arg0.children[iter0].data.isSubView then
			return arg0.children[iter0]:retriveLastChild()
		end
	end

	return arg0
end

function var0.GetHierarchy(arg0)
	local var0 = {
		arg0
	}
	local var1 = {}

	while #var0 > 0 do
		local var2 = table.remove(var0, 1)

		for iter0, iter1 in ipairs(var2.children) do
			table.insert(var0, iter1)
		end

		table.insert(var1, var2)
	end

	return var1
end

function var0.getContextByMediator(arg0, arg1)
	local function var0(arg0, arg1)
		if arg0.mediator == arg1 then
			return arg0
		end

		for iter0, iter1 in ipairs(arg0.children) do
			local var0 = var0(iter1, arg1)

			if var0 ~= nil then
				return var0
			end
		end

		return nil
	end

	return var0(arg0, arg1)
end

function var0.onContextRemoved(arg0)
	return arg0.onRemoved and arg0.onRemoved()
end

return var0
