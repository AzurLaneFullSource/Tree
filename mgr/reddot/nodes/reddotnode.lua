local var0 = class("RedDotNode")

function var0.Ctor(arg0, arg1, arg2)
	assert(not IsNil(arg1))

	arg0.gameObject = arg1
	arg0.types = arg2
end

function var0.GetName(arg0)
	return arg0.gameObject.transform.parent.gameObject.name
end

function var0.Init(arg0)
	return
end

function var0.RefreshSelf(arg0)
	for iter0, iter1 in ipairs(arg0.types) do
		pg.RedDotMgr.GetInstance():NotifyAll(iter1)
	end
end

function var0.GetTypes(arg0)
	return arg0.types
end

function var0.SetData(arg0, arg1)
	if IsNil(arg0.gameObject) then
		return
	end

	setActive(arg0.gameObject, arg1)
end

function var0.Remove(arg0)
	return
end

return var0
