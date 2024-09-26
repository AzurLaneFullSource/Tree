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
var0_0.DIALOGUE_WORLD = 3
var0_0.DIALOGUE_DORM = 4
var0_0.HIGH_TYPE_LINE = 1
var0_0.HIGH_TYPE_GAMEOBJECT = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.delay = arg1_1.delay
	arg0_1.waitScene = arg1_1.waitScene
	arg0_1.code = arg1_1.code
	arg0_1.alpha = arg1_1.alpha
	arg0_1.isWorld = defaultValue(arg1_1.isWorld, true)
	arg0_1.styleData = arg0_1:GenStyleData(arg1_1.style)
	arg0_1.highLightData = arg0_1:GenHighLightData(arg1_1.style)
	arg0_1.baseUI = arg0_1:GenSearchData(arg1_1.baseui)
	arg0_1.spriteUI = arg0_1:GenSpriteSearchData(arg1_1.spriteui)
	arg0_1.sceneName = arg1_1.style and arg1_1.style.scene
	arg0_1.otherTriggerTarget = arg1_1.style and arg1_1.style.trigger
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

	local var0_15

	if arg1_15.mode == var0_0.DIALOGUE_DORM then
		var0_15 = nil
		arg1_15.dir = 1
	else
		var0_15 = {
			name = var1_0(arg0_15, arg1_15),
			position = var2_0(arg0_15, arg1_15),
			scale = var3_0(arg1_15)
		}
	end

	return {
		mode = arg1_15.mode,
		text = HXSet.hxLan(arg1_15.text or ""),
		counsellor = var0_15,
		scale = arg1_15.dir == 1 and Vector3(1, 1, 1) or Vector3(-1, 1, 1),
		position = Vector2(arg1_15.posX or 0, arg1_15.posY or 0),
		handPosition = arg1_15.handPos and Vector3(arg1_15.handPos.x, arg1_15.handPos.y, 0) or Vector3(-267, -96, 0),
		handAngle = arg1_15.handPos and Vector3(0, 0, arg1_15.handPos.w or 0) or Vector3(0, 0, 0)
	}
end

function var0_0.GetHighlightName(arg0_16)
	if arg0_16:GetDialogueType() == var0_0.DIALOGUE_DORM then
		return "wShowArea4"
	elseif arg0_16.isWorld then
		return "wShowArea"
	else
		return "wShowArea1"
	end
end

function var0_0.GetHighlightLength(arg0_17)
	if arg0_17:GetDialogueType() == var0_0.DIALOGUE_DORM then
		return 50
	elseif arg0_17.isWorld then
		return 15
	else
		return 55
	end
end

function var0_0.GetStyleData(arg0_18)
	return arg0_18.styleData
end

function var0_0.GenHighLightData(arg0_19, arg1_19)
	local function var0_19(arg0_20)
		local var0_20 = arg0_19:GenSearchData(arg0_20)

		var0_20.type = arg0_20.lineMode or var0_0.HIGH_TYPE_GAMEOBJECT

		return var0_20
	end

	local var1_19 = {}

	if arg1_19 and arg1_19.ui then
		table.insert(var1_19, var0_19(arg1_19.ui))
	elseif arg1_19 and arg1_19.uiset then
		for iter0_19, iter1_19 in ipairs(arg1_19.uiset) do
			table.insert(var1_19, var0_19(iter1_19))
		end
	elseif arg1_19 and arg1_19.uiFunc then
		local var2_19 = arg1_19.uiFunc()

		for iter2_19, iter3_19 in ipairs(var2_19) do
			table.insert(var1_19, var0_19(iter3_19))
		end
	end

	return var1_19
end

function var0_0.ShouldHighLightTarget(arg0_21)
	return #arg0_21.highLightData > 0
end

function var0_0.GetHighLightTarget(arg0_22)
	return arg0_22.highLightData
end

function var0_0.ExistTrigger(arg0_23)
	local var0_23 = arg0_23:GetType()

	return var0_23 == var0_0.TYPE_FINDUI or var0_23 == var0_0.TYPE_STORY
end

function var0_0.ShouldGoScene(arg0_24)
	return arg0_24.sceneName and arg0_24.sceneName ~= ""
end

function var0_0.GetSceneName(arg0_25)
	return arg0_25.sceneName
end

function var0_0.ShouldTriggerOtherTarget(arg0_26)
	return arg0_26.otherTriggerTarget ~= nil
end

function var0_0.GetOtherTriggerTarget(arg0_27)
	local var0_27 = arg0_27.otherTriggerTarget

	return arg0_27:GenSearchData(var0_27)
end

function var0_0.GenSearchData(arg0_28, arg1_28)
	if not arg1_28 then
		return nil
	end

	local var0_28 = arg1_28.path

	if arg1_28.dynamicPath then
		var0_28 = arg1_28.dynamicPath()
	end

	return {
		path = var0_28,
		delay = arg1_28.delay,
		pathIndex = arg1_28.pathIndex,
		conditionData = arg1_28.conditionData
	}
end

function var0_0.GenSpriteSearchData(arg0_29, arg1_29)
	if not arg1_29 then
		return nil
	end

	local var0_29 = arg0_29:GenSearchData(arg1_29)

	var0_29.defaultName = arg1_29.defaultName
	var0_29.childPath = arg1_29.childPath

	return var0_29
end

function var0_0.ShouldCheckBaseUI(arg0_30)
	return arg0_30.baseUI ~= nil
end

function var0_0.GetBaseUI(arg0_31)
	return arg0_31.baseUI
end

function var0_0.ShouldCheckSpriteUI(arg0_32)
	return arg0_32.spriteUI ~= nil
end

function var0_0.GetSpriteUI(arg0_33)
	return arg0_33.spriteUI
end

function var0_0.GetType(arg0_34)
	assert(false, "overwrite me!!!")
end

return var0_0
