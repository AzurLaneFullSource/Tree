local var0_0 = class("LivingAreaCover", import(".BaseVO"))

var0_0.TYPE_DAY = "day"
var0_0.TYPE_NIGHT = "night"

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.unlock = arg1_1.unlock
	arg0_1.isNew = arg1_1.isNew
end

function var0_0.bindConfigTable(arg0_2)
	return pg.livingarea_cover
end

function var0_0.SetUnlock(arg0_3, arg1_3)
	arg0_3.unlock = arg1_3
end

function var0_0.IsUnlock(arg0_4)
	return arg0_4.unlock
end

function var0_0.ClearNew(arg0_5)
	arg0_5.isNew = false
end

function var0_0.IsNew(arg0_6)
	return arg0_6.isNew
end

function var0_0.GetDropType(arg0_7)
	return DROP_TYPE_LIVINGAREA_COVER
end

function var0_0.GetUnlockText(arg0_8)
	return arg0_8:getConfig("unlock_text")
end

function var0_0.GetIcon(arg0_9)
	return "livingareacover/" .. arg0_9:getConfig("icon_res")
end

function var0_0.GetBg(arg0_10, arg1_10)
	return "livingareaCover/" .. arg0_10:getConfig(arg1_10 .. "time_res")
end

return var0_0
