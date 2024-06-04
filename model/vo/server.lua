local var0 = class("Server", import(".BaseVO"))

var0.STATUS = {
	REGISTER_FULL = 3,
	VINDICATE = 1,
	NORMAL = 0,
	FULL = 2
}

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.status = arg1.status or var0.STATUS.NORMAL
	arg0.name = arg1.name

	local var0 = arg1.tag_state or 0

	arg0.isHot = var0 == 1
	arg0.isNew = var0 == 2
	arg0.isLogined = false
	arg0.sortIndex = arg1.sort or arg0.id
	arg0.host = arg1.host
	arg0.port = arg1.port
	arg0.proxyHost = arg1.proxy_host
	arg0.proxyPort = arg1.proxy_port
end

function var0.getHost(arg0)
	if VersionMgr.Inst:OnProxyUsing() and arg0.proxyHost ~= nil and arg0.proxyHost ~= "" then
		return arg0.proxyHost
	end

	return arg0.host
end

function var0.getPort(arg0)
	if VersionMgr.Inst:OnProxyUsing() and arg0.proxyPort ~= nil and arg0.proxyPort ~= 0 then
		return arg0.proxyPort
	end

	return arg0.port
end

return var0
