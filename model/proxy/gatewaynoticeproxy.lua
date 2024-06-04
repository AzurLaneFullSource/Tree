local var0 = class("GatewayNoticeProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0.data = {}
end

function var0.getGatewayNotices(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.data) do
		if not arg1 or not iter1.isRead then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.setGatewayNotices(arg0, arg1)
	arg0.data = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(arg0.data, GatewayNotice.New(iter1))
	end
end

return var0
