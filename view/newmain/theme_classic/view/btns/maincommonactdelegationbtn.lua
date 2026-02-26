local var0_0 = class("MainCommonActDelegationBtn", import(".MainBaseSpcailActBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_old_act"
end

function var0_0.GetContainer(arg0_2)
	return arg0_2.root.parent:Find("eventPanel")
end

function var0_0.GetLinkConfig(arg0_3)
	local var0_3 = arg0_3:GetEventName()
	local var1_3 = pg.activity_link_button
	local var2_3 = var1_3.get_id_list_by_name[var0_3] or {}
	local var3_3 = _.select(var2_3, function(arg0_4)
		local var0_4 = var1_3[arg0_4].time

		if type(var0_4) == "table" and var0_4[1] and var0_4[1] == "default" then
			return arg0_3:InActTime(var0_4[2])
		else
			return pg.TimeMgr.GetInstance():inTime(var0_4)
		end
	end)

	if #var3_3 > 0 then
		table.sort(var3_3, CompareFuncs({
			function(arg0_5)
				return var1_3[arg0_5].order
			end
		}))

		return var1_3[var3_3[1]]
	end
end

function var0_0.InActTime(arg0_6, arg1_6)
	local var0_6 = arg1_6 or arg0_6:GetActivityID()

	if var0_6 then
		local var1_6 = getProxy(ActivityProxy):getActivityById(var0_6)

		return var1_6 and not var1_6:isEnd()
	end

	return false
end

function var0_0.InShowTime(arg0_7)
	local var0_7 = arg0_7:GetLinkConfig()

	if var0_7 ~= nil then
		arg0_7.config = var0_7

		return true
	else
		return false
	end
end

function var0_0.GetUIName(arg0_8)
	return "MainCommonActDelegationBtn"
end

function var0_0.OnClick(arg0_9)
	MainBaseActivityBtn.Skip(arg0_9, arg0_9.config)
end

function var0_0.OnInit(arg0_10)
	arg0_10.tipTr = arg0_10._tf:Find("tip")

	setActive(arg0_10.tipTr, arg0_10:IsShowTip())
end

function var0_0.GetActivity(arg0_11)
	if arg0_11.config and arg0_11.config.time and arg0_11.config.time[1] == "default" then
		local var0_11 = arg0_11.config.time[2]
		local var1_11 = getProxy(ActivityProxy):getActivityById(var0_11)

		if var1_11 and not var1_11:isEnd() then
			return var1_11
		end
	end

	return nil
end

function var0_0.IsShowTip(arg0_12)
	local var0_12 = arg0_12:GetActivity()
	local var1_12 = var0_12:getConfig("type")

	return switch(var1_12, {
		[ActivityConst.ACTIVITY_TYPE_TOWN2] = function()
			return LiquorFloorMapScene.ShouldShowTaskTip()
		end
	}, function()
		return var0_12:readyToAchieve()
	end)
end

function var0_0.emit(arg0_15, ...)
	arg0_15.event:emit(...)
end

function var0_0.OnRegister(arg0_16)
	return
end

function var0_0.OnClear(arg0_17)
	return
end

return var0_0
