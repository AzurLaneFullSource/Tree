local var0_0 = class("Server", import(".BaseVO"))

var0_0.STATUS = {
	REGISTER_FULL = 3,
	VINDICATE = 1,
	NORMAL = 0,
	FULL = 2
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.status = arg1_1.status or var0_0.STATUS.NORMAL
	arg0_1.name = arg1_1.name

	local var0_1 = arg1_1.tag_state or 0

	arg0_1.isHot = var0_1 == 1
	arg0_1.isNew = var0_1 == 2
	arg0_1.isLogined = false
	arg0_1.sortIndex = arg1_1.sort or arg0_1.id
	arg0_1.host = arg1_1.host
	arg0_1.port = arg1_1.port
	arg0_1.proxyHost = arg1_1.proxy_host
	arg0_1.proxyPort = arg1_1.proxy_port
end

function var0_0.getHost(arg0_2)
	if VersionMgr.Inst:OnProxyUsing() and arg0_2.proxyHost ~= nil and arg0_2.proxyHost ~= "" then
		return arg0_2.proxyHost
	end

	return arg0_2.host
end

function var0_0.getPort(arg0_3)
	if VersionMgr.Inst:OnProxyUsing() and arg0_3.proxyPort ~= nil and arg0_3.proxyPort ~= 0 then
		return arg0_3.proxyPort
	end

	return arg0_3.port
end

return var0_0
