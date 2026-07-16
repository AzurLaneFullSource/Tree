local var0_0 = class("GuideUIFloatCollector")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.root = arg1_1
	arg0_1.caches = {}
end

function var0_0.SetFloat(arg0_2, arg1_2)
	local var0_2 = arg1_2.parent

	setParent(arg1_2, arg0_2.root, true)

	arg1_2.localPosition = Vector3.New(arg1_2.localPosition.x, arg1_2.localPosition.y, 0)

	table.insert(arg0_2.caches, {
		parent = var0_2,
		tr = arg1_2
	})
end

function var0_0.Clear(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.caches) do
		local var0_3 = iter1_3.parent
		local var1_3 = iter1_3.tr

		setParent(var1_3, var0_3, true)

		var1_3.localPosition = Vector3.New(var1_3.localPosition.x, var1_3.localPosition.y, 0)
	end

	arg0_3.caches = {}
end

return var0_0
