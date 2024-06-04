local var0 = class("ServerProxy", import(".NetProxy"))

var0.SERVERS_UPDATED = "ServerProxy:SERVERS_UPDATED"

function var0.setServers(arg0, arg1, arg2)
	arg0.data = {}
	arg0.lastServer = nil
	arg0.firstServer = nil

	local var0 = {}
	local var1 = arg0:getLoginedServer(arg2)

	for iter0, iter1 in ipairs(arg1) do
		assert(isa(iter1, Server), "should be an instance of Server")

		if table.contains(var1, tostring(iter1.id)) then
			iter1.isLogined = true
		end

		arg0.data[iter1.id] = iter1

		if iter0 == #arg1 then
			arg0.lastServer = iter1
		end

		if iter1.sortIndex == 0 then
			table.insert(var0, iter1)
		end
	end

	if #var0 > 0 then
		arg0.firstServer = var0[math.random(1, #var0)]
	end

	arg0.facade:sendNotification(var0.SERVERS_UPDATED, arg0:getData())
end

function var0.setLastServer(arg0, arg1, arg2)
	PlayerPrefs.SetInt("server.id" .. arg2, arg1)
end

function var0.getLastServer(arg0, arg1)
	local var0 = PlayerPrefs.GetInt("server.id" .. arg1)

	return arg0.data[var0] or arg0.firstServer or arg0.lastServer
end

function var0.recordLoginedServer(arg0, arg1, arg2)
	local var0 = arg0:getLoginedServer(arg1)

	if not table.contains(var0, tostring(arg2)) then
		arg0.data[arg2].isLogined = true

		table.insert(var0, tostring(arg2))

		local var1 = table.concat(var0, ":")

		PlayerPrefs.SetString("loginedServer_" .. arg1, var1)
		PlayerPrefs.Save()
	end
end

function var0.getLoginedServer(arg0, arg1)
	if not arg0.loginedServerIds or arg0.recordUid and arg0.recordUid ~= arg1 then
		arg0.recordUid = arg1

		local var0 = PlayerPrefs.GetString("loginedServer_" .. arg1)

		arg0.loginedServerIds = string.split(var0, ":")
	end

	return arg0.loginedServerIds
end

return var0
