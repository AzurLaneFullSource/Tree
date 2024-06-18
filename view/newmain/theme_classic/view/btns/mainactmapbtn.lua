local var0_0 = class("MainActMapBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_map"
end

function var0_0.GetActivity(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)

	return (_.detect(var0_2, function(arg0_3)
		return not arg0_3:isEnd()
	end))
end

function var0_0.GetActivityID(arg0_4)
	local var0_4 = arg0_4:GetActivity()

	return var0_4 and var0_4.id
end

function var0_0.OnInit(arg0_5)
	local var0_5 = getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()

	setActive(arg0_5.tipTr.gameObject, var0_5)
end

function var0_0.CustomOnClick(arg0_6)
	local var0_6 = arg0_6:GetActivity()

	if var0_6 then
		arg0_6:emit(NewMainMediator.SKIP_ACTIVITY_MAP, var0_6.id)
	end
end

return var0_0
