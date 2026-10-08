local var0_0 = class("PTBuffActivity", import("model.vo.Activity"))

function var0_0.GetPTDrop(arg0_1)
	local var0_1 = switch(arg0_1:getDataConfig("type"), {
		function()
			return DROP_TYPE_RESOURCE
		end,
		function()
			return DROP_TYPE_RESOURCE
		end,
		[8] = function()
			return DROP_TYPE_VITEM
		end,
		[9] = function()
			return DROP_TYPE_VITEM
		end
	})

	return var0_1 and Drop.New({
		count = 0,
		type = var0_1,
		id = arg0_1:getDataConfig("pt")
	}) or nil
end

function var0_0.GetTotalPtCount(arg0_6)
	assert(arg0_6:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_BUFF_MARK2)

	return arg0_6.data1
end

return var0_0
