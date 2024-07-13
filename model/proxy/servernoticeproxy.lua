local var0_0 = class("ServerNoticeProxy", import(".NetProxy"))

var0_0.SERVER_NOTICES_UPDATE = "server notices update"
var0_0.KEY_NEWLY_ID = "server_notice.newly_id"
var0_0.KEY_STOP_REMIND = "server_notice.dont_remind"

function var0_0.register(arg0_1)
	arg0_1.data = {}

	arg0_1:on(11300, function(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2.notice_list) do
			local var0_2 = false

			for iter2_2 = 1, #arg0_1.data do
				if arg0_1.data[iter2_2].id == iter1_2.id then
					arg0_1.data[iter2_2] = ServerNotice.New(iter1_2)
					var0_2 = true

					break
				end
			end

			if not var0_2 then
				if #arg0_2.notice_list == 1 then
					table.insert(arg0_1.data, 1, ServerNotice.New(iter1_2))
				else
					table.insert(arg0_1.data, ServerNotice.New(iter1_2))
				end
			end
		end

		arg0_1:sendNotification(var0_0.SERVER_NOTICES_UPDATE)
	end)
end

function var0_0.testData(arg0_3, arg1_3)
	table.insert(arg1_3, ServerNotice.New({
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
	table.insert(arg1_3, ServerNotice.New({
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
	table.insert(arg1_3, ServerNotice.New({
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
	table.insert(arg1_3, ServerNotice.New({
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
	table.insert(arg1_3, ServerNotice.New({
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

function var0_0.getServerNotices(arg0_4, arg1_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.data) do
		if not arg1_4 or not iter1_4.isRead then
			table.insert(var0_4, iter1_4)
		end
	end

	return var0_4
end

function var0_0.needAutoOpen(arg0_5)
	local var0_5 = true

	if PlayerPrefs.HasKey(var0_0.KEY_STOP_REMIND) then
		local var1_5 = PlayerPrefs.GetInt(var0_0.KEY_STOP_REMIND)
		local var2_5 = pg.TimeMgr.GetInstance()

		if not arg0_5:hasNewNotice() and var2_5:IsSameDay(var1_5, var2_5:GetServerTime()) then
			var0_5 = false
		end
	elseif arg0_5.runtimeUniqueCode and arg0_5.runtimeUniqueCode == arg0_5:getUniqueCode() then
		var0_5 = false
	end

	arg0_5.runtimeUniqueCode = arg0_5:getUniqueCode()

	return var0_5
end

function var0_0.setStopRemind(arg0_6, arg1_6)
	if arg1_6 then
		PlayerPrefs.SetInt(var0_0.KEY_STOP_REMIND, pg.TimeMgr.GetInstance():GetServerTime())
	else
		PlayerPrefs.DeleteKey(var0_0.KEY_STOP_REMIND)
	end

	PlayerPrefs.Save()
end

function var0_0.getStopRemind(arg0_7)
	return PlayerPrefs.HasKey(var0_0.KEY_STOP_REMIND)
end

function var0_0.setStopNewTip(arg0_8)
	PlayerPrefs.SetInt(var0_0.KEY_NEWLY_ID, arg0_8:getUniqueCode())
	PlayerPrefs.Save()
	arg0_8:sendNotification(var0_0.SERVER_NOTICES_UPDATE)
end

function var0_0.hasNewNotice(arg0_9)
	if PlayerPrefs.HasKey(var0_0.KEY_NEWLY_ID) and PlayerPrefs.GetInt(var0_0.KEY_NEWLY_ID) == arg0_9:getUniqueCode() then
		return false
	end

	return true
end

function var0_0.getUniqueCode(arg0_10)
	return _.reduce(arg0_10.data, 0, function(arg0_11, arg1_11)
		return arg0_11 + arg1_11:getUniqueCode()
	end)
end

return var0_0
