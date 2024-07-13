local var0_0 = class("LinerRoom", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id
	arg0_1.time2CharInfo = {}

	for iter0_1, iter1_1 in ipairs(arg0_1:getConfig("sd")) do
		for iter2_1, iter3_1 in ipairs(iter1_1[1]) do
			arg0_1.time2CharInfo[iter3_1] = {
				iter1_1[2],
				iter1_1[3]
			}
		end
	end
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_liner_room
end

function var0_0.GetName(arg0_3)
	return arg0_3:getConfig("name")
end

function var0_0.GetPic(arg0_4)
	return arg0_4:getConfig("pic")
end

function var0_0.GetDesc(arg0_5)
	return HXSet.hxLan(arg0_5:getConfig("desc"))
end

function var0_0.GetDescList(arg0_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in ipairs(arg0_6:getConfig("desc_display")) do
		local var1_6 = HXSet.hxLan(iter1_6[1])

		table.insert(var0_6, var1_6)
	end

	return var0_6
end

function var0_0.GetStory(arg0_7)
	return arg0_7:getConfig("memory_id")
end

function var0_0.GetSpineCharInfo(arg0_8, arg1_8)
	return arg0_8.time2CharInfo[arg1_8]
end

return var0_0
