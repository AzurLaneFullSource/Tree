local var0 = class("WorldBuff", import("...BaseEntity"))

var0.Fields = {
	config = "table",
	floor = "number",
	time = "number",
	id = "number",
	round = "number",
	step = "number"
}
var0.TrapCompassInterference = 1
var0.TrapVortex = 2
var0.TrapFire = 3
var0.TrapDisturbance = 4
var0.TrapCripple = 5
var0.TrapFrozen = 6

function var0.GetTemplate(arg0)
	assert(pg.world_SLGbuff_data[arg0], "without this buff " .. arg0)

	return pg.world_SLGbuff_data[arg0]
end

function var0.Setup(arg0, arg1)
	arg0.id = arg1.id
	arg0.config = var0.GetTemplate(arg0.id)

	assert(arg0.config, "world_SLGbuff_data not exist: " .. arg0.id)

	arg0.floor = math.min(arg1.floor, arg0:GetMaxFloor())
	arg0.time = arg1.time ~= 0 and arg1.time or nil
	arg0.round = arg1.round ~= 0 and arg1.round or nil
	arg0.step = arg1.step ~= 0 and arg1.step or nil
end

function var0.IsValid(arg0)
	return not arg0.time or arg0.time > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.CheckValid(arg0)
	if not arg0:IsValid() then
		arg0.floor = 0
	end
end

function var0.GetMaxFloor(arg0)
	return arg0.config.buff_maxfloor
end

function var0.GetTrapType(arg0)
	return arg0.config.trap_type
end

function var0.GetTrapParams(arg0)
	return arg0.config.trap_parameter
end

function var0.GetLost(arg0)
	if arg0.step and arg0.round then
		return math.min(arg0.step, arg0.round)
	else
		return arg0.step or arg0.round
	end
end

function var0.AddFloor(arg0, arg1)
	arg0:CheckValid()

	arg0.floor = math.clamp(arg0.floor + arg1, 0, 999)
end

function var0.GetFloor(arg0)
	arg0:CheckValid()

	return math.min(arg0.floor, arg0:GetMaxFloor())
end

return var0
