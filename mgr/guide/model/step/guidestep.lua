local var0 = class("GuideStep")

var0.TYPE_DOFUNC = 0
var0.TYPE_DONOTHING = 1
var0.TYPE_FINDUI = 2
var0.TYPE_HIDEUI = 3
var0.TYPE_SENDNOTIFIES = 4
var0.TYPE_SHOWSIGN = 5
var0.TYPE_STORY = 6
var0.DIALOGUE_BLUE = 1
var0.DIALOGUE_WHITE = 2
var0.HIGH_TYPE_LINE = 1
var0.HIGH_TYPE_GAMEOBJECT = 2

function var0.Ctor(arg0, arg1)
	arg0.delay = arg1.delay
	arg0.waitScene = arg1.waitScene
	arg0.code = arg1.code
	arg0.alpha = arg1.alpha
	arg0.styleData = arg0:GenStyleData(arg1.style)
	arg0.highLightData = arg0:GenHighLightData(arg1.style)
	arg0.baseUI = arg0:GenSearchData(arg1.baseui)
	arg0.spriteUI = arg0:GenSpriteSearchData(arg1.spriteui)
	arg0.sceneName = arg1.style and arg1.style.scene
	arg0.otherTriggerTarget = arg1.style and arg1.style.trigger
	arg0.isWorld = defaultValue(arg1.isWorld, true)
end

function var0.UpdateIsWorld(arg0, arg1)
	arg0.isWorld = arg1
end

function var0.IsMatchWithCode(arg0, arg1)
	local var0 = arg0:GetMatchCode()

	if not var0 then
		return true
	end

	if type(var0) == "number" then
		return table.contains(arg1, var0)
	elseif type(var0) == "table" then
		return _.any(arg1, function(arg0)
			return table.contains(var0, arg0)
		end)
	end

	return false
end

function var0.GetMatchCode(arg0)
	return arg0.code
end

function var0.GetDelay(arg0)
	return arg0.delay or 0
end

function var0.GetAlpha(arg0)
	return arg0.alpha or 0.4
end

function var0.ShouldWaitScene(arg0)
	return arg0.waitScene and arg0.waitScene ~= ""
end

function var0.GetWaitScene(arg0)
	return arg0.waitScene
end

function var0.ShouldShowDialogue(arg0)
	return arg0.styleData ~= nil
end

function var0.GetDialogueType(arg0)
	return arg0.styleData.mode
end

local function var1(arg0, arg1)
	local var0 = "char"

	if arg1.char and arg1.char == 1 then
		var0 = arg0.isWorld and "char_world" or "char_world1"
	elseif arg1.char and arg1.char == "amazon" then
		var0 = "char_amazon"
	end

	return var0
end

local function var2(arg0, arg1)
	if arg1.charPos then
		return Vector2(arg1.charPos[1], arg1.charPos[2])
	elseif arg1.dir == 1 then
		return arg1.mode == var0.DIALOGUE_BLUE and Vector2(-400, -170) or Vector2(-350, 0)
	else
		return arg1.mode == var0.DIALOGUE_BLUE and Vector2(400, -170) or Vector2(350, 0)
	end
end

local function var3(arg0)
	local var0

	if arg0.charScale then
		var0 = Vector2(arg0.charScale[1], arg0.charScale[2])
	else
		var0 = Vector2(1, 1)
	end

	return arg0.dir == 1 and var0 or Vector3(-var0.x, var0.y, 1)
end

function var0.GenStyleData(arg0, arg1)
	if not arg1 then
		return nil
	end

	return {
		mode = arg1.mode,
		text = HXSet.hxLan(arg1.text or ""),
		counsellor = {
			name = var1(arg0, arg1),
			position = var2(arg0, arg1),
			scale = var3(arg1)
		},
		scale = arg1.dir == 1 and Vector3(1, 1, 1) or Vector3(-1, 1, 1),
		position = Vector2(arg1.posX or 0, arg1.posY or 0),
		handPosition = arg1.handPos and Vector3(arg1.handPos.x, arg1.handPos.y, 0) or Vector3(-267, -96, 0),
		handAngle = arg1.handPos and Vector3(0, 0, arg1.handPos.w or 0) or Vector3(0, 0, 0)
	}
end

function var0.GetStyleData(arg0)
	return arg0.styleData
end

function var0.GenHighLightData(arg0, arg1)
	local var0 = function(arg0)
		local var0 = arg0:GenSearchData(arg0)

		var0.type = arg0.lineMode or var0.HIGH_TYPE_GAMEOBJECT

		return var0
	end
	local var1 = {}

	if arg1 and arg1.ui then
		table.insert(var1, var0(arg1.ui))
	elseif arg1 and arg1.uiset then
		for iter0, iter1 in ipairs(arg1.uiset) do
			table.insert(var1, var0(iter1))
		end
	elseif arg1 and arg1.uiFunc then
		local var2 = arg1.uiFunc()

		for iter2, iter3 in ipairs(var2) do
			table.insert(var1, var0(iter3))
		end
	end

	return var1
end

function var0.ShouldHighLightTarget(arg0)
	return #arg0.highLightData > 0
end

function var0.GetHighLightTarget(arg0)
	return arg0.highLightData
end

function var0.ExistTrigger(arg0)
	local var0 = arg0:GetType()

	return var0 == var0.TYPE_FINDUI or var0 == var0.TYPE_STORY
end

function var0.ShouldGoScene(arg0)
	return arg0.sceneName and arg0.sceneName ~= ""
end

function var0.GetSceneName(arg0)
	return arg0.sceneName
end

function var0.ShouldTriggerOtherTarget(arg0)
	return arg0.otherTriggerTarget ~= nil
end

function var0.GetOtherTriggerTarget(arg0)
	local var0 = arg0.otherTriggerTarget

	return arg0:GenSearchData(var0)
end

function var0.GenSearchData(arg0, arg1)
	if not arg1 then
		return nil
	end

	local var0 = arg1.path

	if arg1.dynamicPath then
		var0 = arg1.dynamicPath()
	end

	return {
		path = var0,
		delay = arg1.delay,
		pathIndex = arg1.pathIndex,
		conditionData = arg1.conditionData
	}
end

function var0.GenSpriteSearchData(arg0, arg1)
	if not arg1 then
		return nil
	end

	local var0 = arg0:GenSearchData(arg1)

	var0.defaultName = arg1.defaultName
	var0.childPath = arg1.childPath

	return var0
end

function var0.ShouldCheckBaseUI(arg0)
	return arg0.baseUI ~= nil
end

function var0.GetBaseUI(arg0)
	return arg0.baseUI
end

function var0.ShouldCheckSpriteUI(arg0)
	return arg0.spriteUI ~= nil
end

function var0.GetSpriteUI(arg0)
	return arg0.spriteUI
end

function var0.GetType(arg0)
	assert(false, "overwrite me!!!")
end

return var0
