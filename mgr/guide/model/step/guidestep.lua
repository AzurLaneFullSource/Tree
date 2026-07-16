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
var0_0.HIGH_TYPE_FLOAT = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.delay = arg1_1.delay
	arg0_1.waitScene = arg1_1.waitScene
	arg0_1.code = arg1_1.code
	arg0_1.alpha = arg1_1.alpha
	arg0_1.mask = defaultValue(arg1_1.mask, false)
	arg0_1.isWorld = defaultValue(arg1_1.isWorld, true)
	arg0_1.styleData = arg0_1:GenStyleData(arg1_1.style)
	arg0_1.highLightData = arg0_1:GenHighLightData(arg1_1.style)
	arg0_1.baseUI = arg0_1:GenSearchData(arg1_1.baseui)
	arg0_1.spriteUI = arg0_1:GenSpriteSearchData(arg1_1.spriteui)
	arg0_1.sceneName = arg1_1.style and arg1_1.style.scene
	arg0_1.otherTriggerTarget = arg1_1.style and arg1_1.style.trigger
end

function var0_0.CanClick(arg0_2)
	return not arg0_2.mask
end

function var0_0.UpdateIsWorld(arg0_3, arg1_3)
	arg0_3.isWorld = arg1_3
end

function var0_0.IsMatchWithCode(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetMatchCode()

	if not var0_4 then
		return true
	end

	if type(var0_4) == "number" then
		return table.contains(arg1_4, var0_4)
	elseif type(var0_4) == "table" then
		return _.any(arg1_4, function(arg0_5)
			return table.contains(var0_4, arg0_5)
		end)
	end

	return false
end

function var0_0.GetMatchCode(arg0_6)
	return arg0_6.code
end

function var0_0.GetDelay(arg0_7)
	return arg0_7.delay or 0
end

function var0_0.GetAlpha(arg0_8)
	return arg0_8.alpha or 0.4
end

function var0_0.ShouldWaitScene(arg0_9)
	return arg0_9.waitScene and arg0_9.waitScene ~= ""
end

function var0_0.GetWaitScene(arg0_10)
	return arg0_10.waitScene
end

function var0_0.ShouldShowDialogue(arg0_11)
	return arg0_11.styleData ~= nil
end

function var0_0.GetDialogueType(arg0_12)
	return arg0_12.styleData.mode
end

local function var1_0(arg0_13, arg1_13)
	local var0_13 = "char"

	if arg1_13.char and arg1_13.char == 1 then
		var0_13 = arg0_13.isWorld and "char_world" or "char_world1"
	elseif arg1_13.char and arg1_13.char == "amazon" then
		var0_13 = "char_amazon"
	end

	return var0_13
end

local function var2_0(arg0_14, arg1_14)
	if arg1_14.charPos then
		return Vector2(arg1_14.charPos[1], arg1_14.charPos[2])
	elseif arg1_14.dir == 1 then
		return arg1_14.mode == var0_0.DIALOGUE_BLUE and Vector2(-400, -170) or Vector2(-350, 0)
	else
		return arg1_14.mode == var0_0.DIALOGUE_BLUE and Vector2(400, -170) or Vector2(350, 0)
	end
end

local function var3_0(arg0_15)
	local var0_15

	if arg0_15.charScale then
		var0_15 = Vector2(arg0_15.charScale[1], arg0_15.charScale[2])
	else
		var0_15 = Vector2(1, 1)
	end

	return arg0_15.dir == 1 and var0_15 or Vector3(-var0_15.x, var0_15.y, 1)
end

function var0_0.GenStyleData(arg0_16, arg1_16)
	if not arg1_16 then
		return nil
	end

	local var0_16

	if arg1_16.mode == var0_0.DIALOGUE_DORM then
		var0_16 = nil
		arg1_16.dir = 1
	else
		var0_16 = {
			name = var1_0(arg0_16, arg1_16),
			position = var2_0(arg0_16, arg1_16),
			scale = var3_0(arg1_16)
		}
	end

	return {
		mode = arg1_16.mode,
		text = HXSet.hxLan(arg1_16.text or ""),
		counsellor = var0_16,
		scale = arg1_16.dir == 1 and Vector3(1, 1, 1) or Vector3(-1, 1, 1),
		position = Vector2(arg1_16.posX or 0, arg1_16.posY or 0),
		handPosition = arg1_16.handPos and Vector3(arg1_16.handPos.x, arg1_16.handPos.y, 0) or Vector3(-267, -96, 0),
		handAngle = arg1_16.handPos and Vector3(0, 0, arg1_16.handPos.w or 0) or Vector3(0, 0, 0)
	}
end

function var0_0.GetHighlightName(arg0_17)
	if arg0_17:GetDialogueType() == var0_0.DIALOGUE_DORM then
		return "wShowArea4"
	elseif arg0_17.isWorld then
		return "wShowArea"
	else
		return "wShowArea1"
	end
end

function var0_0.GetHighlightLength(arg0_18)
	if arg0_18:GetDialogueType() == var0_0.DIALOGUE_DORM then
		return 50
	elseif arg0_18.isWorld then
		return 15
	else
		return 55
	end
end

function var0_0.GetStyleData(arg0_19)
	return arg0_19.styleData
end

function var0_0.GenHighLightData(arg0_20, arg1_20)
	local function var0_20(arg0_21)
		local var0_21 = arg0_20:GenSearchData(arg0_21)

		var0_21.type = arg0_21.lineMode or var0_0.HIGH_TYPE_GAMEOBJECT

		return var0_21
	end

	local var1_20 = {}

	if arg1_20 and arg1_20.ui then
		table.insert(var1_20, var0_20(arg1_20.ui))
	elseif arg1_20 and arg1_20.uiset then
		for iter0_20, iter1_20 in ipairs(arg1_20.uiset) do
			table.insert(var1_20, var0_20(iter1_20))
		end
	elseif arg1_20 and arg1_20.uiFunc then
		local var2_20 = arg1_20.uiFunc()

		for iter2_20, iter3_20 in ipairs(var2_20) do
			table.insert(var1_20, var0_20(iter3_20))
		end
	end

	return var1_20
end

function var0_0.ShouldHighLightTarget(arg0_22)
	return #arg0_22.highLightData > 0
end

function var0_0.GetHighLightTarget(arg0_23)
	return arg0_23.highLightData
end

function var0_0.ExistTrigger(arg0_24)
	local var0_24 = arg0_24:GetType()

	return var0_24 == var0_0.TYPE_FINDUI or var0_24 == var0_0.TYPE_STORY
end

function var0_0.ShouldGoScene(arg0_25)
	return arg0_25.sceneName and arg0_25.sceneName ~= ""
end

function var0_0.GetSceneName(arg0_26)
	return arg0_26.sceneName
end

function var0_0.ShouldTriggerOtherTarget(arg0_27)
	return arg0_27.otherTriggerTarget ~= nil
end

function var0_0.GetOtherTriggerTarget(arg0_28)
	local var0_28 = arg0_28.otherTriggerTarget

	return arg0_28:GenSearchData(var0_28)
end

function var0_0.GenSearchData(arg0_29, arg1_29)
	if not arg1_29 then
		return nil
	end

	local var0_29 = arg1_29.path

	if arg1_29.dynamicPath then
		var0_29 = arg1_29.dynamicPath()
	end

	return {
		path = var0_29,
		delay = arg1_29.delay,
		pathIndex = arg1_29.pathIndex,
		conditionData = arg1_29.conditionData
	}
end

function var0_0.GenSpriteSearchData(arg0_30, arg1_30)
	if not arg1_30 then
		return nil
	end

	local var0_30 = arg0_30:GenSearchData(arg1_30)

	var0_30.defaultName = arg1_30.defaultName
	var0_30.childPath = arg1_30.childPath

	return var0_30
end

function var0_0.ShouldCheckBaseUI(arg0_31)
	return arg0_31.baseUI ~= nil
end

function var0_0.GetBaseUI(arg0_32)
	return arg0_32.baseUI
end

function var0_0.ShouldCheckSpriteUI(arg0_33)
	return arg0_33.spriteUI ~= nil
end

function var0_0.GetSpriteUI(arg0_34)
	return arg0_34.spriteUI
end

function var0_0.GetType(arg0_35)
	assert(false, "overwrite me!!!")
end

return var0_0
