local var0_0 = class("ReversePacmanConst")

var0_0.TIME_INTERVAL = 0.0166666666666667
var0_0.GRID_SIZE = {
	x = 35,
	y = 35
}
var0_0.GRID_SIZE_2 = {
	x = 22,
	y = 22
}
var0_0.GRID = {
	ROAD = "road",
	BLOCK = "block",
	DEPLOY = "deploy",
	SPAWN = "spawn"
}
var0_0.TAG = {
	CORNER = "corner",
	CORRIDOR = "corridor",
	JUNCTION = "junction",
	DEAD_END = "deadEnd",
	ISOLATED = "isolated"
}
var0_0.DIR = {
	RIGHT = 2,
	UP = 1,
	LEFT = 4,
	DOWN = 3
}
var0_0.DIR_VECTORS = {
	[var0_0.DIR.UP] = {
		x = 0,
		y = -1
	},
	[var0_0.DIR.RIGHT] = {
		x = 1,
		y = 0
	},
	[var0_0.DIR.DOWN] = {
		x = 0,
		y = 1
	},
	[var0_0.DIR.LEFT] = {
		x = -1,
		y = 0
	}
}
var0_0.ROLE = {
	SHIP = "ship",
	MONSTER = "monster"
}
var0_0.BUFF = {
	BLOCK = 2,
	GIANT = 3,
	SPEED = 1
}
var0_0.BUFF_EDU = 4
var0_0.STATE = {
	SETTLEMENT = "settlement",
	RUNNING = "running",
	INIT = "init",
	PREPARE = "prepare",
	CAPTURE = "capture",
	EXIT = "exit"
}
var0_0.EVENT = {
	CAST = "cast",
	GRAPH_CHANGED = "graphChanged",
	PICK = "pick",
	SHIP_PERFORMANCE = "shipPerformance",
	CAPTURE = "capture"
}
var0_0.SHIP_PERFORMANCE_TYPE = {
	FAR = 3,
	CAPTURE = 2,
	NEAR = 1
}
var0_0.SHIP_PERFORMANCE_RANGE = {
	[var0_0.SHIP_PERFORMANCE_TYPE.NEAR] = var0_0.GRID_SIZE.x * 3,
	[var0_0.SHIP_PERFORMANCE_TYPE.FAR] = var0_0.GRID_SIZE.x * 8
}
var0_0.SHIP_PERFORMANCE_COOLDOWN = 3
var0_0.SHIP_PERFORMANCE_GLOBAL_COOLDOWN = 2
var0_0.GAMEPLAY_TIME_SCALE = {
	FAST_TRIGGER_REMAIN_TIME = 30,
	NORMAL = 1,
	FAST = 2
}

function var0_0.GetGameplayTimeScale(arg0_1)
	if arg0_1 ~= nil and arg0_1 < var0_0.GAMEPLAY_TIME_SCALE.FAST_TRIGGER_REMAIN_TIME then
		return var0_0.GAMEPLAY_TIME_SCALE.FAST
	end

	return var0_0.GAMEPLAY_TIME_SCALE.NORMAL
end

var0_0.TAG_SPEED_FACTOR = {
	[var0_0.TAG.ISOLATED] = 1,
	[var0_0.TAG.DEAD_END] = 1,
	[var0_0.TAG.CORRIDOR] = 1.1,
	[var0_0.TAG.CORNER] = 0.9,
	[var0_0.TAG.JUNCTION] = 0.8
}
var0_0.ROLE_RADIUS = {
	[var0_0.ROLE.SHIP] = 25,
	[var0_0.ROLE.MONSTER] = 30
}
var0_0.GRADE = {
	C = "C",
	A = "A",
	S = "S",
	B = "B"
}
var0_0.RESULT_TYPE = {
	SUCCESS = 1,
	FAIL = 2
}
var0_0.MONSTER_TRAP_MIN_COMPONENT_NODES = 12
var0_0.MONSTER_TRAP_COMPONENT_RATIO = 0.1

function var0_0.GetGrade(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2 > 0 and calcFloor(arg0_2 / arg1_2 * 100) or 0
	local var1_2 = arg2_2[1] or 80
	local var2_2 = arg2_2[2] or 50
	local var3_2 = arg2_2[3] or 30

	if var1_2 <= var0_2 then
		return var0_0.GRADE.S
	end

	if var2_2 <= var0_2 then
		return var0_0.GRADE.A
	end

	if var3_2 <= var0_2 then
		return var0_0.GRADE.B
	end

	return var0_0.GRADE.C
end

return var0_0
