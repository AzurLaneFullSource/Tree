local var0_0 = class("Dorm3dInsPhone", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg1_1
	arg0_1.isLock = true
end

function var0_0.ExtendsData(arg0_2, arg1_2)
	arg0_2.time = arg1_2.time
	arg0_2.isRead = arg1_2.read_flag == 1
	arg0_2.isLock = false
end

function var0_0.Unlock(arg0_3, arg1_3)
	arg0_3.time = arg1_3
	arg0_3.isRead = false
	arg0_3.isLock = false
end

function var0_0.bindConfigTable(arg0_4)
	return pg.dorm3d_ins_telephone_group
end

function var0_0.ShouldTip(arg0_5)
	return not arg0_5.isLock and not arg0_5.isRead
end

function var0_0.IsLock(arg0_6)
	return arg0_6.isLock
end

function var0_0.GetName(arg0_7)
	return arg0_7:getConfig("name")
end

function var0_0.GetDesc(arg0_8)
	return arg0_8:getConfig("unlock_desc")
end

function var0_0.GetContent(arg0_9)
	return arg0_9:getConfig("content")
end

function var0_0.GetDay(arg0_10)
	local var0_10 = math.floor((pg.TimeMgr.GetInstance():GetServerTime() - arg0_10.time) / 86400)

	return var0_10 == 0 and i18n("dorm3d_privatechat_visit_time_now") or i18n("dorm3d_privatechat_visit_time", var0_10)
end

return var0_0
