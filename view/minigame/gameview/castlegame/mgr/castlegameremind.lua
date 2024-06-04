local var0 = class("CastleGameRemind")

var0.remind_type_1 = "remind_type_1"
var0.remind_type_2 = "remind_type_2"
var0.remind_type_3 = "remind_type_3"
var0.remind_type_4 = "remind_type_4"

local var1 = {
	{
		tpl = "remind_1",
		type = var0.remind_type_1
	},
	{
		tpl = "remind_2",
		type = var0.remind_type_2
	},
	{
		tpl = "remind_3",
		type = var0.remind_type_3
	},
	{
		tpl = "remind_4",
		type = var0.remind_type_4
	}
}

function var0.Ctor(arg0, arg1, arg2)
	arg0._tplContent = arg1
	arg0._event = arg2
	arg0.remindPool = {}
	arg0.reminds = {}
end

function var0.setContent(arg0, arg1)
	if not arg1 then
		print("地板的容器不能为nil")

		return
	end

	arg0._content = arg1
end

function var0.start(arg0)
	for iter0 = #arg0.reminds, 1, -1 do
		local var0 = table.remove(arg0.reminds, iter0)

		arg0:returnRemind(var0)
	end
end

function var0.step(arg0)
	for iter0 = #arg0.reminds, 1, -1 do
		local var0 = arg0.reminds[iter0]

		if var0.removeTime and var0.removeTime > 0 then
			var0.removeTime = var0.removeTime - CastleGameVo.deltaTime

			if var0.removeTime <= 0 then
				var0.removeTime = nil

				local var1 = table.remove(arg0.reminds, iter0)

				arg0:returnRemind(var1)
			end
		end
	end
end

function var0.addRemind(arg0, arg1, arg2, arg3)
	local var0 = arg0:getRemindByType(arg3)

	var0.removeTime = CastleGameVo.item_ready_time

	local var1 = CastleGameVo.GetRotationPosByWH(arg1, arg2)

	setActive(var0.tf, false)
	setActive(var0.tf, true)

	var0.tf.anchoredPosition = var1

	table.insert(arg0.reminds, var0)
end

function var0.getRemindByType(arg0, arg1)
	local var0

	for iter0 = 1, #arg0.remindPool do
		if arg0.remindPool[iter0].type == arg1 then
			var0 = table.remove(arg0.remindPool, iter0)

			return var0
		end
	end

	if not var0 then
		for iter1 = 1, #var1 do
			if arg1 == var1[iter1].type then
				local var1 = tf(instantiate(findTF(arg0._tplContent, var1[iter1].tpl)))

				setParent(var1, arg0._content)

				local var2 = GetComponent(findTF(var1, "zPos"), typeof(DftAniEvent))

				return {
					tf = var1,
					dft = var2,
					type = arg1
				}
			end
		end
	end
end

function var0.returnRemind(arg0, arg1)
	setActive(arg1.tf, false)

	arg1.removeTime = nil

	table.insert(arg0.remindPool, arg1)
end

function var0.clear(arg0)
	return
end

return var0
