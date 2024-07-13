local var0_0 = class("ActivityBossBuff", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.worldboss_bufflist
end

function var0_0.GetConfigID(arg0_2)
	return arg0_2.configId
end

function var0_0.GetIcon(arg0_3)
	return arg0_3:getConfig("buff_icon")
end

function var0_0.GetIconPath(arg0_4)
	return "activitybossbuff/" .. arg0_4:getConfig("buff_icon")
end

function var0_0.GetName(arg0_5)
	return arg0_5:getConfig("name")
end

function var0_0.GetDesc(arg0_6)
	return arg0_6:getConfig("desc")
end

function var0_0.CastOnEnemy(arg0_7)
	return arg0_7:getConfig("buff_target") == 1
end

function var0_0.GetBuffID(arg0_8)
	return arg0_8:getConfig("lua_id")
end

function var0_0.GetBonus(arg0_9)
	return tonumber(arg0_9:getConfig("bonus"))
end

function var0_0.GetBonusText(arg0_10)
	return math.floor(arg0_10:GetBonus() * 100) .. "%"
end

return var0_0
