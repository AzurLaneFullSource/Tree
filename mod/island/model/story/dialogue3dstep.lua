local var0_0 = class("Dialogue3DStep", import(".IslandBaseStep"))

var0_0.PLAY_MODE_DIALOGUE = 0
var0_0.PLAY_MODE_SCENE_TIMELINE = 1
var0_0.PLAY_MODE_TIMELINE = 2
var0_0.OPTION_TYPE_TEXT = 0
var0_0.OPTION_TYPE_PAGE = 1
var0_0.OPTION_TYPE_TASK = 2
var0_0.OPTION_TYPE_EXIT = 3
var0_0.STYLE_DIALOGUE = 1
var0_0.STYLE_ASIDE = 2
var0_0.STYLE_EXIT_GROUP = 3
var0_0.STYLE_JOIN_GROUP = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.subName = arg1_1.subName or arg1_1.factiontag or ""
	arg0_1.timeline = arg1_1.timeline
	arg0_1.sceneTimeline = arg1_1.scene_timeline
	arg0_1.camera = arg1_1.camera
	arg0_1.cameraBlend = arg1_1.camera_blend
	arg0_1.cameraFade = arg1_1.camera_fade
	arg0_1.dialogShake = arg1_1.dialogShake
	arg0_1.cameraShake = arg1_1.camera_shake
	arg0_1.face2Face = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.face2Face or {}) do
		local var0_1 = iter1_1[1]
		local var1_1 = iter1_1[2] or 0

		assert(var0_1 ~= var1_1, "face2Face配置错误，两个角色id不能相同")

		local var2_1 = arg0_1.script:GetUnitIdFromCharaId(var0_1)
		local var3_1 = arg0_1.script:GetUnitIdFromCharaId(var1_1)
		local var4_1 = arg0_1:GenUnitData(var2_1, IslandConst.UNIT_LIST_OBJ)
		local var5_1 = arg0_1:GenUnitData(var3_1, IslandConst.UNIT_LIST_OBJ)

		table.insert(arg0_1.face2Face, {
			var4_1,
			var5_1
		})
	end

	arg0_1.turntoList = {}

	for iter2_1, iter3_1 in ipairs(arg1_1.turnto or {}) do
		local var6_1 = iter3_1[1]
		local var7_1 = iter3_1[2] or 0

		assert(var6_1 ~= var7_1, "turnto配置错误，两个角色id不能相同")

		local var8_1 = arg0_1.script:GetUnitIdFromCharaId(var6_1)
		local var9_1 = arg0_1.script:GetUnitIdFromCharaId(var7_1)
		local var10_1 = arg0_1:GenUnitData(var8_1, IslandConst.UNIT_LIST_OBJ)
		local var11_1 = arg0_1:GenUnitData(var9_1, IslandConst.UNIT_LIST_OBJ)

		table.insert(arg0_1.turntoList, {
			var10_1,
			var11_1
		})
	end

	arg0_1.typewriter = arg1_1.typewriter
	arg0_1.branchCode = arg1_1.optionFlag
	arg0_1.optionList = {}

	for iter4_1, iter5_1 in ipairs(arg1_1.options or {}) do
		local var12_1 = arg0_1:GenOption(iter5_1)

		table.insert(arg0_1.optionList, var12_1)
	end

	arg0_1.style = arg1_1.style or var0_0.STYLE_DIALOGUE
	arg0_1.sequences = arg1_1.sequence
	arg0_1.navData = arg1_1
end

function var0_0.GetNavData(arg0_2)
	if arg0_2.style == var0_0.STYLE_EXIT_GROUP or arg0_2.style == var0_0.STYLE_JOIN_GROUP then
		return {
			object = arg0_2.script:GetUnitIdFromCharaId(arg0_2.navData.characterId),
			position = arg0_2.navData.position,
			speed = arg0_2.navData.speed,
			delay = arg0_2.navData.delay,
			hide = arg0_2.navData.hide,
			waitUntilDone = arg0_2.navData.wait_until_done,
			index = arg0_2.navData.index
		}
	end

	return nil
end

function var0_0.GetNavObject(arg0_3)
	if arg0_3.style == var0_0.STYLE_EXIT_GROUP or arg0_3.style == var0_0.STYLE_JOIN_GROUP then
		local var0_3 = arg0_3.script:GetUnitIdFromCharaId(arg0_3.navData.characterId)

		return (arg0_3.script:GetRole({
			id = var0_3,
			type = IslandConst.UNIT_LIST_OBJ
		}))
	end

	return nil
end

function var0_0.GetAsideSequences(arg0_4)
	if arg0_4.style == var0_0.STYLE_ASIDE then
		local var0_4 = {}

		for iter0_4, iter1_4 in ipairs(arg0_4.sequences or {}) do
			table.insert(var0_4, {
				text = iter1_4[1],
				delay = iter1_4[2]
			})
		end

		return var0_4
	end

	return nil
end

function var0_0.GetStyle(arg0_5)
	return arg0_5.style
end

function var0_0.IsTimeline(arg0_6)
	local var0_6 = arg0_6:GetPlayMode()

	return var0_6 == Dialogue3DStep.PLAY_MODE_SCENE_TIMELINE or var0_6 == Dialogue3DStep.PLAY_MODE_TIMELINE
end

function var0_0.ShouldCameraShake(arg0_7)
	return arg0_7.cameraShake ~= nil
end

function var0_0.GetCameraShakeSrc(arg0_8)
	return arg0_8.cameraShake
end

function var0_0.ShouldShakeDailogue(arg0_9)
	return arg0_9.dialogShake ~= nil
end

function var0_0.GetShakeDailogueData(arg0_10)
	return arg0_10.dialogShake
end

function var0_0.GenOption(arg0_11, arg1_11)
	if arg1_11.mission then
		return {
			icon = "icon_task",
			content = arg1_11.content,
			type = var0_0.OPTION_TYPE_TASK,
			param = arg1_11.mission
		}
	elseif arg1_11.page then
		return {
			icon = "icon_shop",
			content = arg1_11.content,
			type = var0_0.OPTION_TYPE_PAGE,
			param = arg1_11.page
		}
	elseif arg1_11.exit then
		return {
			icon = "icon_exit",
			content = arg1_11.content,
			type = var0_0.OPTION_TYPE_EXIT
		}
	else
		return {
			icon = "icon_dialogue",
			content = arg1_11.content,
			type = var0_0.OPTION_TYPE_TEXT,
			param = arg1_11.flag
		}
	end
end

function var0_0.GetFace2FaceList(arg0_12)
	return arg0_12.face2Face
end

function var0_0.GetTurntoList(arg0_13)
	return arg0_13.turntoList
end

function var0_0.IsSameBranch(arg0_14, arg1_14)
	return not arg0_14.branchCode or arg0_14.branchCode == arg1_14
end

function var0_0.ExistOption(arg0_15)
	return #arg0_15.optionList > 0
end

function var0_0.GetOptionList(arg0_16)
	return arg0_16.optionList
end

function var0_0.CanSkip(arg0_17)
	if arg0_17:ExistOption() or arg0_17.style == var0_0.STYLE_EXIT_GROUP or arg0_17.style == var0_0.STYLE_JOIN_GROUP then
		return false
	end

	return true
end

function var0_0.GetTypewriter(arg0_18)
	return arg0_18.typewriter
end

function var0_0.GetName(arg0_19)
	return arg0_19:GetActorName()
end

function var0_0.GetSubName(arg0_20)
	if not arg0_20.subName or arg0_20.subName == "" then
		return ""
	end

	return "/" .. arg0_20.subName
end

function var0_0.GetPlayMode(arg0_21)
	if arg0_21.sceneTimeline and arg0_21.sceneTimeline ~= "" then
		return var0_0.PLAY_MODE_SCENE_TIMELINE
	elseif arg0_21.timeline and arg0_21.timeline ~= "" then
		return var0_0.PLAY_MODE_TIMELINE
	else
		return var0_0.PLAY_MODE_DIALOGUE
	end
end

function var0_0.GetTimelinePath(arg0_22)
	return arg0_22.timeline
end

function var0_0.GetActiveCamera(arg0_23)
	return arg0_23.camera
end

function var0_0.ShouldActiveCamera(arg0_24)
	return arg0_24.camera and arg0_24.camera ~= ""
end

function var0_0.GetSceneTimelinePath(arg0_25)
	return arg0_25.sceneTimeline
end

function var0_0.GetCameraBlendName(arg0_26)
	return arg0_26.cameraBlend
end

function var0_0.SholdBlendCamera(arg0_27)
	if not arg0_27.cameraBlend then
		return false
	end

	return true
end

function var0_0.ShouldFadeCamera(arg0_28)
	return arg0_28.cameraFade
end

return var0_0
