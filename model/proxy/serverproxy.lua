local var0_0 = class("ServerProxy", import(".NetProxy"))

var0_0.SERVERS_UPDATED = "ServerProxy:SERVERS_UPDATED"

function var0_0.setServers(arg0_1, arg1_1, arg2_1)
	arg0_1.data = {}
	arg0_1.lastServer = nil
	arg0_1.firstServer = nil

	local var0_1 = {}
	local var1_1 = arg0_1:getLoginedServer(arg2_1)

	for iter0_1, iter1_1 in ipairs(arg1_1) do
		assert(isa(iter1_1, Server), "should be an instance of Server")

		if table.contains(var1_1, tostring(iter1_1.id)) then
			iter1_1.isLogined = true
		end

		arg0_1.data[iter1_1.id] = iter1_1

		if iter0_1 == #arg1_1 then
			arg0_1.lastServer = iter1_1
		end

		if iter1_1.sortIndex == 0 then
			table.insert(var0_1, iter1_1)
		end
	end

	if #var0_1 > 0 then
		arg0_1.firstServer = var0_1[math.random(1, #var0_1)]
	end

	arg0_1.facade:sendNotification(var0_0.SERVERS_UPDATED, arg0_1:getData())
end

function var0_0.setLastServer(arg0_2, arg1_2, arg2_2)
	PlayerPrefs.SetInt("server.id" .. arg2_2, arg1_2)
end

function var0_0.getLastServer(arg0_3, arg1_3)
	local var0_3 = PlayerPrefs.GetInt("server.id" .. arg1_3)

	return arg0_3.data[var0_3] or arg0_3.firstServer or arg0_3.lastServer
end

function var0_0.recordLoginedServer(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4:getLoginedServer(arg1_4)

	if not table.contains(var0_4, tostring(arg2_4)) then
		arg0_4.data[arg2_4].isLogined = true

		table.insert(var0_4, tostring(arg2_4))

		local var1_4 = table.concat(var0_4, ":")

		PlayerPrefs.SetString("loginedServer_" .. arg1_4, var1_4)
		PlayerPrefs.Save()
	end
end

function var0_0.getLoginedServer(arg0_5, arg1_5)
	if not arg0_5.loginedServerIds or arg0_5.recordUid and arg0_5.recordUid ~= arg1_5 then
		arg0_5.recordUid = arg1_5

		local var0_5 = PlayerPrefs.GetString("loginedServer_" .. arg1_5)

		arg0_5.loginedServerIds = string.split(var0_5, ":")
	end

	return arg0_5.loginedServerIds
end

return var0_0
