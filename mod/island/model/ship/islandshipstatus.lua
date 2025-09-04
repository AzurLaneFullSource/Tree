local var0_0 = class("IslandShipStatus", import("model.vo.BaseVO"))

var0_0.COLOR_NULL = 0
var0_0.COLOR_RED = 1
var0_0.COLOR_BLUE = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.id
	arg0_1.startTime = arg1_1.start_time or 0
	arg0_1.isSkill = arg1_1.isSkill
	arg0_1.time = 0

	arg0_1:InitEndTime()
end

function var0_0.InitEndTime(arg0_2)
	local var0_2 = arg0_2:GetDuration()

	if var0_2 == 0 then
		arg0_2.time = 0
	else
		arg0_2.time = arg0_2.startTime + var0_2
	end
end

function var0_0.GetEndTime(arg0_3)
	return arg0_3.time
end

function var0_0.GetStartTime(arg0_4)
	return arg0_4.startTime
end

function var0_0.IsSkillBuff(arg0_5)
	return arg0_5.isSkill
end

function var0_0.GetGroup(arg0_6)
	return arg0_6:getConfig("buff_group")
end

function var0_0.GetLevel(arg0_7)
	return arg0_7:getConfig("buff_level")
end

function var0_0.GetDuelTypeList(arg0_8)
	return arg0_8:getConfig("type_duel")
end

function var0_0.GetDuelIdList(arg0_9)
	return arg0_9:getConfig("buff_duel")
end

function var0_0.GetDuration(arg0_10)
	return arg0_10:getConfig("buff_time")
end

function var0_0.GetBuffType(arg0_11)
	return arg0_11:getConfig("buff_type")
end

function var0_0.GetBuffEffect(arg0_12)
	return arg0_12:getConfig("type_use")
end

function var0_0.bindConfigTable(arg0_13)
	return pg.island_buff_template
end

function var0_0.AddTime(arg0_14, arg1_14)
	local var0_14 = pg.TimeMgr.GetInstance():GetServerTime()

	arg0_14.time = math.max(arg0_14.time, var0_14) + arg1_14
end

function var0_0.IsExpiration(arg0_15)
	if arg0_15.time == 0 then
		return false
	end

	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_15.time
end

function var0_0.GetDesc(arg0_16)
	return arg0_16:getConfig("buff_desc")
end

function var0_0.GetName(arg0_17)
	return arg0_17:getConfig("name")
end

function var0_0.IsRed(arg0_18)
	return arg0_18:getConfig("buff_color") == var0_0.COLOR_RED
end

function var0_0.IsBlue(arg0_19)
	return arg0_19:getConfig("buff_color") == var0_0.COLOR_BLUE
end

function var0_0.CanDisplay(arg0_20)
	return arg0_20:getConfig("buff_color") ~= var0_0.COLOR_NULL
end

return var0_0
