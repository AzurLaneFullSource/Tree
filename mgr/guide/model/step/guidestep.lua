local var0_0 = class("GuideStep")

var0_0.TYPE_DOFUNC = 0
var0_0.TYPE_DONOTHING = 1
var0_0.TYPE_FINDUI = 2
var0_0.TYPE_HIDEUI = 3
var0_0.TYPE_SENDNOTIFIES = 4
var0_0.TYPE_SHOWSIGN = 5
var0_0.TYPE_STORY = 6
var0_0.DIALOGUE_BLUE = 1
var0_0.DIALOGUE_WHITE = 2
var0_0.HIGH_TYPE_LINE = 1
var0_0.HIGH_TYPE_GAMEOBJECT = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.delay = arg1_1.delay
	arg0_1.waitScene = arg1_1.waitScene
	arg0_1.code = arg1_1.code
	arg0_1.alpha = arg1_1.alpha
	arg0_1.styleData = arg0_1:GenStyleData(arg1_1.style)
	arg0_1.highLightData = arg0_1:GenHighLightData(arg1_1.style)
	arg0_1.baseUI = arg0_1:GenSearchData(arg1_1.baseui)
	arg0_1.spriteUI = arg0_1:GenSpriteSearchData(arg1_1.spriteui)
	arg0_1.sceneName = arg1_1.style and arg1_1.style.scene
	arg0_1.otherTriggerTarget = arg1_1.style and arg1_1.style.trigger
	arg0_1.isWorld = defaultValue(arg1_1.isWorld, true)
end

function var0_0.UpdateIsWorld(arg0_2, arg1_2)
	arg0_2.isWorld = arg1_2
end

function var0_0.IsMatchWithCode(arg0_3, arg1_3)
	local var0_3 = arg0_3:GetMatchCode()

	if not var0_3 then
		return true
	end

	if type(var0_3) == "number" then
		return table.contains(arg1_3, var0_3)
	elseif type(var0_3) == "table" then
		return _.any(arg1_3, function(arg0_4)
			return table.contains(var0_3, arg0_4)
		end)
	end

	return false
end

function var0_0.GetMatchCode(arg0_5)
	return arg0_5.code
end

function var0_0.GetDelay(arg0_6)
	return arg0_6.delay or 0
end

function var0_0.GetAlpha(arg0_7)
	return arg0_7.alpha or 0.4
end

function var0_0.ShouldWaitScene(arg0_8)
	return arg0_8.waitScene and arg0_8.waitScene ~= ""
end

function var0_0.GetWaitScene(arg0_9)
	return arg0_9.waitScene
end

function var0_0.ShouldShowDialogue(arg0_10)
	return arg0_10.styleData ~= nil
end

function var0_0.GetDialogueType(arg0_11)
	return arg0_11.styleData.mode
end

local function var1_0(arg0_12, arg1_12)
	local var0_12 = "char"

	if arg1_12.char and arg1_12.char == 1 then
		var0_12 = arg0_12.isWorld and "char_world" or "char_world1"
	elseif arg1_12.char and arg1_12.char == "amazon" then
		var0_12 = "char_amazon"
	end

	return var0_12
end

local function var2_0(arg0_13, arg1_13)
	if arg1_13.charPos then
		return Vector2(arg1_13.charPos[1], arg1_13.charPos[2])
	elseif arg1_13.dir == 1 then
		return arg1_13.mode == var0_0.DIALOGUE_BLUE and Vector2(-400, -170) or Vector2(-350, 0)
	else
		return arg1_13.mode == var0_0.DIALOGUE_BLUE and Vector2(400, -170) or Vector2(350, 0)
	end
end

local function var3_0(arg0_14)
	local var0_14

	if arg0_14.charScale then
		var0_14 = Vector2(arg0_14.charScale[1], arg0_14.charScale[2])
	else
		var0_14 = Vector2(1, 1)
	end

	return arg0_14.dir == 1 and var0_14 or Vector3(-var0_14.x, var0_14.y, 1)
end

function var0_0.GenStyleData(arg0_15, arg1_15)
	if not arg1_15 then
		return nil
	end

	return {
		mode = arg1_15.mode,
		text = HXSet.hxLan(arg1_15.text or ""),
		counsellor = {
			name = var1_0(arg0_15, arg1_15),
			position = var2_0(arg0_15, arg1_15),
			scale = var3_0(arg1_15)
		},
		scale = arg1_15.dir == 1 and Vector3(1, 1, 1) or Vector3(-1, 1, 1),
		position = Vector2(arg1_15.posX or 0, arg1_15.posY or 0),
		handPosition = arg1_15.handPos and Vector3(arg1_15.handPos.x, arg1_15.handPos.y, 0) or Vector3(-267, -96, 0),
		handAngle = arg1_15.handPos and Vector3(0, 0, arg1_15.handPos.w or 0) or Vector3(0, 0, 0)
	}
end

function var0_0.GetStyleData(arg0_16)
	return arg0_16.styleData
end

function var0_0.GenHighLightData(arg0_17, arg1_17)
	local function var0_17(arg0_18)
		local var0_18 = arg0_17:GenSearchData(arg0_18)

		var0_18.type = arg0_18.lineMode or var0_0.HIGH_TYPE_GAMEOBJECT

		return var0_18
	end

	local var1_17 = {}

	if arg1_17 and arg1_17.ui then
		table.insert(var1_17, var0_17(arg1_17.ui))
	elseif arg1_17 and arg1_17.uiset then
		for iter0_17, iter1_17 in ipairs(arg1_17.uiset) do
			table.insert(var1_17, var0_17(iter1_17))
		end
	elseif arg1_17 and arg1_17.uiFunc then
		local var2_17 = arg1_17.uiFunc()

		for iter2_17, iter3_17 in ipairs(var2_17) do
			table.insert(var1_17, var0_17(iter3_17))
		end
	end

	return var1_17
end

function var0_0.ShouldHighLightTarget(arg0_19)
	return #arg0_19.highLightData > 0
end

function var0_0.GetHighLightTarget(arg0_20)
	return arg0_20.highLightData
end

function var0_0.ExistTrigger(arg0_21)
	local var0_21 = arg0_21:GetType()

	return var0_21 == var0_0.TYPE_FINDUI or var0_21 == var0_0.TYPE_STORY
end

function var0_0.ShouldGoScene(arg0_22)
	return arg0_22.sceneName and arg0_22.sceneName ~= ""
end

function var0_0.GetSceneName(arg0_23)
	return arg0_23.sceneName
end

function var0_0.ShouldTriggerOtherTarget(arg0_24)
	return arg0_24.otherTriggerTarget ~= nil
end

function var0_0.GetOtherTriggerTarget(arg0_25)
	local var0_25 = arg0_25.otherTriggerTarget

	return arg0_25:GenSearchData(var0_25)
end

function var0_0.GenSearchData(arg0_26, arg1_26)
	if not arg1_26 then
		return nil
	end

	local var0_26 = arg1_26.path

	if arg1_26.dynamicPath then
		var0_26 = arg1_26.dynamicPath()
	end

	return {
		path = var0_26,
		delay = arg1_26.delay,
		pathIndex = arg1_26.pathIndex,
		conditionData = arg1_26.conditionData
	}
end

function var0_0.GenSpriteSearchData(arg0_27, arg1_27)
	if not arg1_27 then
		return nil
	end

	local var0_27 = arg0_27:GenSearchData(arg1_27)

	var0_27.defaultName = arg1_27.defaultName
	var0_27.childPath = arg1_27.childPath

	return var0_27
end

function var0_0.ShouldCheckBaseUI(arg0_28)
	return arg0_28.baseUI ~= nil
end

function var0_0.GetBaseUI(arg0_29)
	return arg0_29.baseUI
end

function var0_0.ShouldCheckSpriteUI(arg0_30)
	return arg0_30.spriteUI ~= nil
end

function var0_0.GetSpriteUI(arg0_31)
	return arg0_31.spriteUI
end

function var0_0.GetType(arg0_32)
	assert(false, "overwrite me!!!")
end

return var0_0
