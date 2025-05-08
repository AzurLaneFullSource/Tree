local var0_0 = class("Dialogue3DStep", import(".IslandBaseStep"))

var0_0.PLAY_MODE_DIALOGUE = 0
var0_0.PLAY_MODE_SCENE_TIMELINE = 1
var0_0.PLAY_MODE_TIMELINE = 2
var0_0.OPTION_TYPE_TEXT = 0
var0_0.OPTION_TYPE_PAGE = 1
var0_0.OPTION_TYPE_TASK = 2
var0_0.OPTION_TYPE_EXIT = 3

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.subName = arg1_1.subName or arg1_1.factiontag or ""
	arg0_1.timeline = arg1_1.timeline
	arg0_1.sceneTimeline = arg1_1.scene_timeline
	arg0_1.camera = arg1_1.camera
	arg0_1.cameraBlend = arg1_1.camera_blend
	arg0_1.cameraFade = arg1_1.camera_fade
	arg0_1.dialogShake = arg1_1.dialogShake
	arg0_1.cameraShake = arg1_1.camera_shake
	arg0_1.typewriter = arg1_1.typewriter
	arg0_1.branchCode = arg1_1.optionFlag
	arg0_1.optionList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.options or {}) do
		local var0_1 = arg0_1:GenOption(iter1_1)

		table.insert(arg0_1.optionList, var0_1)
	end
end

function var0_0.ShouldCameraShake(arg0_2)
	return arg0_2.cameraShake ~= nil
end

function var0_0.GetCameraShakeSrc(arg0_3)
	return arg0_3.cameraShake
end

function var0_0.ShouldShakeDailogue(arg0_4)
	return arg0_4.dialogShake ~= nil
end

function var0_0.GetShakeDailogueData(arg0_5)
	return arg0_5.dialogShake
end

function var0_0.GenOption(arg0_6, arg1_6)
	if arg1_6.mission then
		return {
			icon = "icon_task",
			content = arg1_6.content,
			type = var0_0.OPTION_TYPE_TASK,
			param = arg1_6.mission
		}
	elseif arg1_6.page then
		return {
			icon = "icon_shop",
			content = arg1_6.content,
			type = var0_0.OPTION_TYPE_PAGE,
			param = arg1_6.page
		}
	elseif arg1_6.exit then
		return {
			icon = "icon_exit",
			content = arg1_6.content,
			type = var0_0.OPTION_TYPE_EXIT
		}
	else
		return {
			icon = "icon_dialogue",
			content = arg1_6.content,
			type = var0_0.OPTION_TYPE_TEXT,
			param = arg1_6.flag
		}
	end
end

function var0_0.IsSameBranch(arg0_7, arg1_7)
	return not arg0_7.branchCode or arg0_7.branchCode == arg1_7
end

function var0_0.ExistOption(arg0_8)
	return #arg0_8.optionList > 0
end

function var0_0.GetOptionList(arg0_9)
	return arg0_9.optionList
end

function var0_0.GetTypewriter(arg0_10)
	return arg0_10.typewriter
end

function var0_0.GetName(arg0_11)
	return arg0_11:GetActorName()
end

function var0_0.GetSubName(arg0_12)
	if not arg0_12.subName or arg0_12.subName == "" then
		return ""
	end

	return "/" .. arg0_12.subName
end

function var0_0.GetPlayMode(arg0_13)
	if arg0_13.sceneTimeline and arg0_13.sceneTimeline ~= "" then
		return var0_0.PLAY_MODE_SCENE_TIMELINE
	elseif arg0_13.timeline and arg0_13.timeline ~= "" then
		return var0_0.PLAY_MODE_TIMELINE
	else
		return var0_0.PLAY_MODE_DIALOGUE
	end
end

function var0_0.GetTimelinePath(arg0_14)
	return arg0_14.timeline
end

function var0_0.GetActiveCamera(arg0_15)
	return arg0_15.camera
end

function var0_0.ShouldActiveCamera(arg0_16)
	return arg0_16.camera and arg0_16.camera ~= ""
end

function var0_0.GetSceneTimelineSceneName(arg0_17)
	local var0_17 = arg0_17.sceneTimeline[1]

	if type(var0_17) == "string" then
		return var0_17
	elseif type(var0_17) == "number" then
		return pg.island_map[var0_17].sceneName
	end
end

function var0_0.GetSceneTimelinePath(arg0_18)
	return arg0_18.sceneTimeline[2]
end

function var0_0.GetCameraBlendName(arg0_19)
	return arg0_19.cameraBlend
end

function var0_0.SholdBlendCamera(arg0_20)
	if not arg0_20.cameraBlend then
		return false
	end

	return true
end

function var0_0.ShouldFadeCamera(arg0_21)
	return arg0_21.cameraFade
end

return var0_0
