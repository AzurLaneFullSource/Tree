local var0 = class("ServerNoticeProxy", import(".NetProxy"))

var0.SERVER_NOTICES_UPDATE = "server notices update"
var0.KEY_NEWLY_ID = "server_notice.newly_id"
var0.KEY_STOP_REMIND = "server_notice.dont_remind"

function var0.register(arg0)
	arg0.data = {}

	arg0:on(11300, function(arg0)
		for iter0, iter1 in ipairs(arg0.notice_list) do
			local var0 = false

			for iter2 = 1, #arg0.data do
				if arg0.data[iter2].id == iter1.id then
					arg0.data[iter2] = ServerNotice.New(iter1)
					var0 = true

					break
				end
			end

			if not var0 then
				if #arg0.notice_list == 1 then
					table.insert(arg0.data, 1, ServerNotice.New(iter1))
				else
					table.insert(arg0.data, ServerNotice.New(iter1))
				end
			end
		end

		arg0:sendNotification(var0.SERVER_NOTICES_UPDATE)
	end)
end

function var0.testData(arg0, arg1)
	table.insert(arg1, ServerNotice.New({
		btn_title = "DEWENJUN layer test",
		title_image = "<config type = 2 param = {'OTHERWORLD_MAP', {openTerminal = true,terminalPage = 2, testData = asddws}} />https://blhxusstatic.oss-us-east-1.aliyuncs.com/bulletinboard_test.png",
		id = 1301,
		icon = 4,
		time_des = "2018/08/23",
		title = "test",
		content = "",
		tag_type = 1,
		version = tostring(1)
	}))
	table.insert(arg1, ServerNotice.New({
		btn_title = "DEWENJUN test",
		title_image = "<config type = 2 param = {'OTHERWORLD_MAP'} />https://blhxusstatic.oss-us-east-1.aliyuncs.com/bulletinboard_test.png",
		id = 1302,
		icon = 4,
		time_des = "2018/08/23",
		title = "test",
		content = "",
		tag_type = 1,
		version = tostring(2)
	}))
	table.insert(arg1, ServerNotice.New({
		btn_title = "URL test",
		title_image = "<config type = 1 param = 'https://www.google.com' />https://blhxusstatic.oss-us-east-1.aliyuncs.com/bulletinboard_test.png",
		id = 1303,
		icon = 4,
		time_des = "2018/08/23",
		title = "test",
		content = "",
		tag_type = 1,
		version = tostring(3)
	}))
	table.insert(arg1, ServerNotice.New({
		btn_title = "URL test",
		title_image = "<config type = 2 param = {'scene court yard', {OpenShop = true}} />https://blhxusstatic.oss-us-east-1.aliyuncs.com/bulletinboard_test.png",
		id = 1304,
		icon = 4,
		time_des = "2018/08/23",
		title = "test",
		content = "",
		tag_type = 1,
		version = tostring(4)
	}))
	table.insert(arg1, ServerNotice.New({
		btn_title = "URL test",
		title_image = "<config type = 3 param = 5292 />https://blhxusstatic.oss-us-east-1.aliyuncs.com/bulletinboard_test.png",
		id = 1305,
		icon = 4,
		time_des = "2018/08/23",
		title = "test",
		content = "",
		tag_type = 1,
		version = tostring(4)
	}))
end

function var0.getServerNotices(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.data) do
		if not arg1 or not iter1.isRead then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.needAutoOpen(arg0)
	local var0 = true

	if PlayerPrefs.HasKey(var0.KEY_STOP_REMIND) then
		local var1 = PlayerPrefs.GetInt(var0.KEY_STOP_REMIND)
		local var2 = pg.TimeMgr.GetInstance()

		if not arg0:hasNewNotice() and var2:IsSameDay(var1, var2:GetServerTime()) then
			var0 = false
		end
	elseif arg0.runtimeUniqueCode and arg0.runtimeUniqueCode == arg0:getUniqueCode() then
		var0 = false
	end

	arg0.runtimeUniqueCode = arg0:getUniqueCode()

	return var0
end

function var0.setStopRemind(arg0, arg1)
	if arg1 then
		PlayerPrefs.SetInt(var0.KEY_STOP_REMIND, pg.TimeMgr.GetInstance():GetServerTime())
	else
		PlayerPrefs.DeleteKey(var0.KEY_STOP_REMIND)
	end

	PlayerPrefs.Save()
end

function var0.getStopRemind(arg0)
	return PlayerPrefs.HasKey(var0.KEY_STOP_REMIND)
end

function var0.setStopNewTip(arg0)
	PlayerPrefs.SetInt(var0.KEY_NEWLY_ID, arg0:getUniqueCode())
	PlayerPrefs.Save()
	arg0:sendNotification(var0.SERVER_NOTICES_UPDATE)
end

function var0.hasNewNotice(arg0)
	if PlayerPrefs.HasKey(var0.KEY_NEWLY_ID) and PlayerPrefs.GetInt(var0.KEY_NEWLY_ID) == arg0:getUniqueCode() then
		return false
	end

	return true
end

function var0.getUniqueCode(arg0)
	return _.reduce(arg0.data, 0, function(arg0, arg1)
		return arg0 + arg1:getUniqueCode()
	end)
end

return var0
