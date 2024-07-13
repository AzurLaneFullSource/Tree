ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleGridmanSkillFloatView = class("BattleGridmanSkillFloatView")
var0_0.Battle.BattleGridmanSkillFloatView.__name = "BattleGridmanSkillFloatView"

local var2_0 = var0_0.Battle.BattleGridmanSkillFloatView

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)

	arg0_1:init()
end

function var2_0.init(arg0_2)
	arg0_2._fusion = {}
	arg0_2._fusion[var1_0.FRIENDLY_CODE] = arg0_2._tf:Find("fusion_1")
	arg0_2._fusion[var1_0.FOE_CODE] = arg0_2._tf:Find("fusion_-1")
	arg0_2._skillList = {}

	local function var0_2(arg0_3)
		arg0_2._skillList[arg0_3] = {}

		for iter0_3 = 1, 3 do
			local var0_3 = iter0_3 * arg0_3
			local var1_3 = arg0_2._tf:Find("skill_" .. var0_3)

			table.insert(arg0_2._skillList[arg0_3], {
				idle = true,
				tf = var1_3
			})
		end
	end

	var0_2(var1_0.FRIENDLY_CODE)
	var0_2(var1_0.FOE_CODE)

	arg0_2._resource = arg0_2._tf:Find("res")
end

function var2_0.DoSkillFloat(arg0_4, arg1_4, arg2_4)
	local var0_4
	local var1_4 = arg0_4._skillList[arg2_4]

	for iter0_4 = 1, 3 do
		if var1_4[iter0_4].idle then
			var0_4 = var1_4[iter0_4]

			break
		end
	end

	if not var0_4 then
		return
	end

	var0_4.idle = false

	local var2_4 = var0_4.tf
	local var3_4 = var2_4:Find("anima")
	local var4_4 = arg0_4._resource:Find(arg1_4):GetComponent(typeof(Image)).sprite

	setImageSprite(var3_4, var4_4, true)
	setActive(var2_4, true)
	var3_4:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_5)
		var0_4.idle = true

		setActive(var2_4, false)
	end)
end

function var2_0.DoFusionFloat(arg0_6, arg1_6)
	local var0_6 = arg0_6._fusion[arg1_6]

	setActive(var0_6, true)
	var0_6:Find("anima"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_7)
		setActive(var0_6, false)
	end)
end

function var2_0.Dispose(arg0_8)
	return
end
