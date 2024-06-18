local var0_0 = class("WorldBuff", import("...BaseEntity"))

var0_0.Fields = {
	config = "table",
	floor = "number",
	time = "number",
	id = "number",
	round = "number",
	step = "number"
}
var0_0.TrapCompassInterference = 1
var0_0.TrapVortex = 2
var0_0.TrapFire = 3
var0_0.TrapDisturbance = 4
var0_0.TrapCripple = 5
var0_0.TrapFrozen = 6

function var0_0.GetTemplate(arg0_1)
	assert(pg.world_SLGbuff_data[arg0_1], "without this buff " .. arg0_1)

	return pg.world_SLGbuff_data[arg0_1]
end

function var0_0.Setup(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.config = var0_0.GetTemplate(arg0_2.id)

	assert(arg0_2.config, "world_SLGbuff_data not exist: " .. arg0_2.id)

	arg0_2.floor = math.min(arg1_2.floor, arg0_2:GetMaxFloor())
	arg0_2.time = arg1_2.time ~= 0 and arg1_2.time or nil
	arg0_2.round = arg1_2.round ~= 0 and arg1_2.round or nil
	arg0_2.step = arg1_2.step ~= 0 and arg1_2.step or nil
end

function var0_0.IsValid(arg0_3)
	return not arg0_3.time or arg0_3.time > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.CheckValid(arg0_4)
	if not arg0_4:IsValid() then
		arg0_4.floor = 0
	end
end

function var0_0.GetMaxFloor(arg0_5)
	return arg0_5.config.buff_maxfloor
end

function var0_0.GetTrapType(arg0_6)
	return arg0_6.config.trap_type
end

function var0_0.GetTrapParams(arg0_7)
	return arg0_7.config.trap_parameter
end

function var0_0.GetLost(arg0_8)
	if arg0_8.step and arg0_8.round then
		return math.min(arg0_8.step, arg0_8.round)
	else
		return arg0_8.step or arg0_8.round
	end
end

function var0_0.AddFloor(arg0_9, arg1_9)
	arg0_9:CheckValid()

	arg0_9.floor = math.clamp(arg0_9.floor + arg1_9, 0, 999)
end

function var0_0.GetFloor(arg0_10)
	arg0_10:CheckValid()

	return math.min(arg0_10.floor, arg0_10:GetMaxFloor())
end

return var0_0
