ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig

var0.Battle.BattleGridmanSkillFloatView = class("BattleGridmanSkillFloatView")
var0.Battle.BattleGridmanSkillFloatView.__name = "BattleGridmanSkillFloatView"

local var2 = var0.Battle.BattleGridmanSkillFloatView

function var2.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)

	arg0:init()
end

function var2.init(arg0)
	arg0._fusion = {}
	arg0._fusion[var1.FRIENDLY_CODE] = arg0._tf:Find("fusion_1")
	arg0._fusion[var1.FOE_CODE] = arg0._tf:Find("fusion_-1")
	arg0._skillList = {}

	local function var0(arg0)
		arg0._skillList[arg0] = {}

		for iter0 = 1, 3 do
			local var0 = iter0 * arg0
			local var1 = arg0._tf:Find("skill_" .. var0)

			table.insert(arg0._skillList[arg0], {
				idle = true,
				tf = var1
			})
		end
	end

	var0(var1.FRIENDLY_CODE)
	var0(var1.FOE_CODE)

	arg0._resource = arg0._tf:Find("res")
end

function var2.DoSkillFloat(arg0, arg1, arg2)
	local var0
	local var1 = arg0._skillList[arg2]

	for iter0 = 1, 3 do
		if var1[iter0].idle then
			var0 = var1[iter0]

			break
		end
	end

	if not var0 then
		return
	end

	var0.idle = false

	local var2 = var0.tf
	local var3 = var2:Find("anima")
	local var4 = arg0._resource:Find(arg1):GetComponent(typeof(Image)).sprite

	setImageSprite(var3, var4, true)
	setActive(var2, true)
	var3:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		var0.idle = true

		setActive(var2, false)
	end)
end

function var2.DoFusionFloat(arg0, arg1)
	local var0 = arg0._fusion[arg1]

	setActive(var0, true)
	var0:Find("anima"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		setActive(var0, false)
	end)
end

function var2.Dispose(arg0)
	return
end
