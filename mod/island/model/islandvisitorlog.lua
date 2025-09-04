local var0_0 = class("IslandVisitorLog")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id or ""
	arg0_1.name = arg1_1.name or ""
	arg0_1.time = arg1_1.time or 0
	arg0_1.cmd = arg1_1.cmd or 1
end

function var0_0.IsSelf(arg0_2)
	return arg0_2.id == getProxy(PlayerProxy):getRawData().id
end

function var0_0.IsCmdEnterOrExit(arg0_3)
	return arg0_3.cmd == IslandConst.VISITOR_LOG_CMD_ENTER or arg0_3.cmd == IslandConst.VISITOR_LOG_CMD_EXIT
end

function var0_0.GetTime(arg0_4)
	return (pg.TimeMgr.GetInstance():STimeDescS(arg0_4.time, "%m.%d %H:%M"))
end

function var0_0.GetTimeWithoutHAndM(arg0_5)
	return (pg.TimeMgr.GetInstance():STimeDescS(arg0_5.time, "- %m.%d -"))
end

function var0_0.GetName(arg0_6)
	return arg0_6.name
end

function var0_0.GetOpDesc(arg0_7)
	if arg0_7.cmd == IslandConst.VISITOR_LOG_CMD_ENTER then
		return i18n("island_log_visit")
	elseif arg0_7.cmd == IslandConst.VISITOR_LOG_CMD_EXIT then
		return i18n("island_log_exit")
	elseif arg0_7.cmd == IslandConst.VISITOR_LOG_CMD_GIFT then
		return i18n("island_log_gift")
	end

	return ""
end

function var0_0._Build(arg0_8, arg1_8)
	local var0_8 = ""

	if arg0_8.cmd == IslandConst.VISITOR_LOG_CMD_ENTER then
		var0_8 = arg1_8 .. " " .. arg0_8.name .. i18n("island_log_visit")
	elseif arg0_8.cmd == IslandConst.VISITOR_LOG_CMD_EXIT then
		var0_8 = arg1_8 .. " " .. arg0_8.name .. i18n("island_log_exit")
	elseif arg0_8.cmd == IslandConst.VISITOR_LOG_CMD_GIFT then
		var0_8 = arg1_8 .. " " .. arg0_8.name .. i18n("island_log_gift")
	end

	return var0_8
end

function var0_0.Build(arg0_9)
	local var0_9 = pg.TimeMgr.GetInstance():STimeDescS(arg0_9.time, "%Y/%m/%d %H:%M")

	return arg0_9:_Build(var0_9)
end

function var0_0.BuildWhitoutTime(arg0_10)
	return arg0_10:_Build("")
end

return var0_0
