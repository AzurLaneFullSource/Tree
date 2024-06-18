local var0_0 = class("GatewayNoticeProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.data = {}
end

function var0_0.getGatewayNotices(arg0_2, arg1_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.data) do
		if not arg1_2 or not iter1_2.isRead then
			table.insert(var0_2, iter1_2)
		end
	end

	return var0_2
end

function var0_0.setGatewayNotices(arg0_3, arg1_3)
	arg0_3.data = {}

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		table.insert(arg0_3.data, GatewayNotice.New(iter1_3))
	end
end

return var0_0
