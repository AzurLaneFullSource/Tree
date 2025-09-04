local var0_0 = class("IslandUrgencyOrder", import(".IslandOrder"))

function var0_0.IsUrgency(arg0_1)
	return true
end

function var0_0.GetTitle(arg0_2)
	return i18n("island_order_type_2")
end

function var0_0.IsEmpty(arg0_3)
	return arg0_3.showFlag == IslandOrderSlot.SHOW_FLAG_TOMORROW or pg.TimeMgr.GetInstance():GetServerTime() >= arg0_3:GetDisappearTime()
end

function var0_0.Clear(arg0_4)
	arg0_4.showFlag = IslandOrderSlot.SHOW_FLAG_TOMORROW
end

function var0_0.IsLoading(arg0_5)
	return false
end

function var0_0.CanReplace(arg0_6)
	return false
end

function var0_0.GetTotalTime(arg0_7)
	return -1
end

function var0_0.GetDisappearTime(arg0_8)
	return arg0_8.submitTime
end

function var0_0.GetCanSubmitTime(arg0_9)
	return -1
end

return var0_0
