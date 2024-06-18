local var0_0 = class("RedDotNode")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	assert(not IsNil(arg1_1))

	arg0_1.gameObject = arg1_1
	arg0_1.types = arg2_1
end

function var0_0.GetName(arg0_2)
	return arg0_2.gameObject.transform.parent.gameObject.name
end

function var0_0.Init(arg0_3)
	return
end

function var0_0.RefreshSelf(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.types) do
		pg.RedDotMgr.GetInstance():NotifyAll(iter1_4)
	end
end

function var0_0.GetTypes(arg0_5)
	return arg0_5.types
end

function var0_0.SetData(arg0_6, arg1_6)
	if IsNil(arg0_6.gameObject) then
		return
	end

	setActive(arg0_6.gameObject, arg1_6)
end

function var0_0.Remove(arg0_7)
	return
end

return var0_0
