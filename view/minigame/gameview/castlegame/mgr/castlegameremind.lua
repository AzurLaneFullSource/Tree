local var0_0 = class("CastleGameRemind")

var0_0.remind_type_1 = "remind_type_1"
var0_0.remind_type_2 = "remind_type_2"
var0_0.remind_type_3 = "remind_type_3"
var0_0.remind_type_4 = "remind_type_4"

local var1_0 = {
	{
		tpl = "remind_1",
		type = var0_0.remind_type_1
	},
	{
		tpl = "remind_2",
		type = var0_0.remind_type_2
	},
	{
		tpl = "remind_3",
		type = var0_0.remind_type_3
	},
	{
		tpl = "remind_4",
		type = var0_0.remind_type_4
	}
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tplContent = arg1_1
	arg0_1._event = arg2_1
	arg0_1.remindPool = {}
	arg0_1.reminds = {}
end

function var0_0.setContent(arg0_2, arg1_2)
	if not arg1_2 then
		print("地板的容器不能为nil")

		return
	end

	arg0_2._content = arg1_2
end

function var0_0.start(arg0_3)
	for iter0_3 = #arg0_3.reminds, 1, -1 do
		local var0_3 = table.remove(arg0_3.reminds, iter0_3)

		arg0_3:returnRemind(var0_3)
	end
end

function var0_0.step(arg0_4)
	for iter0_4 = #arg0_4.reminds, 1, -1 do
		local var0_4 = arg0_4.reminds[iter0_4]

		if var0_4.removeTime and var0_4.removeTime > 0 then
			var0_4.removeTime = var0_4.removeTime - CastleGameVo.deltaTime

			if var0_4.removeTime <= 0 then
				var0_4.removeTime = nil

				local var1_4 = table.remove(arg0_4.reminds, iter0_4)

				arg0_4:returnRemind(var1_4)
			end
		end
	end
end

function var0_0.addRemind(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg0_5:getRemindByType(arg3_5)

	var0_5.removeTime = CastleGameVo.item_ready_time

	local var1_5 = CastleGameVo.GetRotationPosByWH(arg1_5, arg2_5)

	setActive(var0_5.tf, false)
	setActive(var0_5.tf, true)

	var0_5.tf.anchoredPosition = var1_5

	table.insert(arg0_5.reminds, var0_5)
end

function var0_0.getRemindByType(arg0_6, arg1_6)
	local var0_6

	for iter0_6 = 1, #arg0_6.remindPool do
		if arg0_6.remindPool[iter0_6].type == arg1_6 then
			var0_6 = table.remove(arg0_6.remindPool, iter0_6)

			return var0_6
		end
	end

	if not var0_6 then
		for iter1_6 = 1, #var1_0 do
			if arg1_6 == var1_0[iter1_6].type then
				local var1_6 = tf(instantiate(findTF(arg0_6._tplContent, var1_0[iter1_6].tpl)))

				setParent(var1_6, arg0_6._content)

				local var2_6 = GetComponent(findTF(var1_6, "zPos"), typeof(DftAniEvent))

				return {
					tf = var1_6,
					dft = var2_6,
					type = arg1_6
				}
			end
		end
	end
end

function var0_0.returnRemind(arg0_7, arg1_7)
	setActive(arg1_7.tf, false)

	arg1_7.removeTime = nil

	table.insert(arg0_7.remindPool, arg1_7)
end

function var0_0.clear(arg0_8)
	return
end

return var0_0
