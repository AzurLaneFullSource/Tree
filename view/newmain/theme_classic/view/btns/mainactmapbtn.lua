local var0 = class("MainActMapBtn", import(".MainBaseActivityBtn"))

function var0.GetEventName(arg0)
	return "event_map"
end

function var0.GetActivity(arg0)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT)

	return (_.detect(var0, function(arg0)
		return not arg0:isEnd()
	end))
end

function var0.GetActivityID(arg0)
	local var0 = arg0:GetActivity()

	return var0 and var0.id
end

function var0.OnInit(arg0)
	local var0 = getProxy(ChapterProxy):IsActivitySPChapterActive() and SettingsProxy.IsShowActivityMapSPTip()

	setActive(arg0.tipTr.gameObject, var0)
end

function var0.CustomOnClick(arg0)
	local var0 = arg0:GetActivity()

	if var0 then
		arg0:emit(NewMainMediator.SKIP_ACTIVITY_MAP, var0.id)
	end
end

return var0
