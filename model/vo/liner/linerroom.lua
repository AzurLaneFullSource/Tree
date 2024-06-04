local var0 = class("LinerRoom", import("model.vo.BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1
	arg0.configId = arg0.id
	arg0.time2CharInfo = {}

	for iter0, iter1 in ipairs(arg0:getConfig("sd")) do
		for iter2, iter3 in ipairs(iter1[1]) do
			arg0.time2CharInfo[iter3] = {
				iter1[2],
				iter1[3]
			}
		end
	end
end

function var0.bindConfigTable(arg0)
	return pg.activity_liner_room
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetPic(arg0)
	return arg0:getConfig("pic")
end

function var0.GetDesc(arg0)
	return HXSet.hxLan(arg0:getConfig("desc"))
end

function var0.GetDescList(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0:getConfig("desc_display")) do
		local var1 = HXSet.hxLan(iter1[1])

		table.insert(var0, var1)
	end

	return var0
end

function var0.GetStory(arg0)
	return arg0:getConfig("memory_id")
end

function var0.GetSpineCharInfo(arg0, arg1)
	return arg0.time2CharInfo[arg1]
end

return var0
