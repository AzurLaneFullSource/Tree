local var0 = class("ActivityBossBuff", import("model.vo.BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.worldboss_bufflist
end

function var0.GetConfigID(arg0)
	return arg0.configId
end

function var0.GetIcon(arg0)
	return arg0:getConfig("buff_icon")
end

function var0.GetIconPath(arg0)
	return "activitybossbuff/" .. arg0:getConfig("buff_icon")
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetDesc(arg0)
	return arg0:getConfig("desc")
end

function var0.CastOnEnemy(arg0)
	return arg0:getConfig("buff_target") == 1
end

function var0.GetBuffID(arg0)
	return arg0:getConfig("lua_id")
end

function var0.GetBonus(arg0)
	return tonumber(arg0:getConfig("bonus"))
end

function var0.GetBonusText(arg0)
	return math.floor(arg0:GetBonus() * 100) .. "%"
end

return var0
