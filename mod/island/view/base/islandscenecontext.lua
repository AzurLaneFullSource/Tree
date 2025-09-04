local var0_0 = class("IslandSceneContext")

function var0_0.Ctor(arg0_1, arg1_1, ...)
	arg0_1.class = arg1_1
	arg0_1.args = packEx(...)
	arg0_1.subpages = {}
	arg0_1.__visible = true
end

function var0_0.AddSubPage(arg0_2, arg1_2, ...)
	local var0_2 = _.detect(arg0_2.subpages, function(arg0_3)
		return arg1_2.__cname == arg0_3.class.__cname
	end)

	if var0_2 then
		var0_2.__visible = true

		return
	end

	local var1_2 = IslandSceneContext.New(arg1_2, ...)

	table.insert(arg0_2.subpages, var1_2)
end

function var0_0.GetSubPages(arg0_4)
	return arg0_4.subpages
end

function var0_0.GetData(arg0_5)
	return arg0_5.args
end

return var0_0
