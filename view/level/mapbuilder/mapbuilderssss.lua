local var0_0 = class("MapBuilderSSSS", import(".MapBuilderNormal"))
local var1_0 = "ssss_buttons"

function var0_0.preload(arg0_1, arg1_1)
	PoolMgr.GetInstance():GetUI(var1_0, true, function(arg0_2)
		arg0_1.buttons = arg0_2

		arg1_1()
	end)
end

function var0_0.GetType(arg0_3)
	return MapBuilder.TYPESSSS
end

function var0_0.OnInit(arg0_4)
	var0_0.super.OnInit(arg0_4)

	arg0_4.mainLayer = arg0_4._parentTf:Find("main")
	arg0_4.rightChapter = arg0_4._parentTf:Find("main/right_chapter/event_btns/BottomList")
	arg0_4.leftChapter = arg0_4._parentTf:Find("main/left_chapter/buttons")
	arg0_4.challengeBtn = tf(arg0_4.buttons):Find("btn_challenge")
	arg0_4.missionBtn = tf(arg0_4.buttons):Find("btn_mission")

	onButton(arg0_4, arg0_4.challengeBtn, function()
		if arg0_4:isfrozen() then
			return
		end

		arg0_4:emit(LevelUIConst.SWITCH_CHALLENGE_MAP)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.missionBtn, function()
		if arg0_4:isfrozen() then
			return
		end

		arg0_4:emit(LevelMediator2.ON_GO_TO_TASK_SCENE, {
			page = TaskScene.PAGE_TYPE_ACT
		})
	end, SFX_PANEL)
	setParent(arg0_4.buttons, arg0_4.mainLayer)
end

function var0_0.ShowButtons(arg0_7)
	var0_0.super.ShowButtons(arg0_7)
	setActive(arg0_7.buttons, true)
	setParent(arg0_7.challengeBtn, arg0_7.leftChapter)
	arg0_7.challengeBtn:SetSiblingIndex(5)
	setParent(arg0_7.missionBtn, arg0_7.rightChapter)
	arg0_7.missionBtn:SetSiblingIndex(0)
end

function var0_0.HideButtons(arg0_8)
	setParent(arg0_8.challengeBtn, arg0_8.buttons)
	setParent(arg0_8.missionBtn, arg0_8.buttons)
	setActive(arg0_8.buttons, false)
	var0_0.super.HideButtons(arg0_8)
end

local var2_0 = {
	18993,
	18994,
	18995,
	18996,
	18997
}

function var0_0.UpdateButtons(arg0_9)
	var0_0.super.UpdateButtons(arg0_9)

	local var0_9 = arg0_9.data:getConfig("type")

	setActive(arg0_9.sceneParent.actEliteBtn, false)
	setActive(arg0_9.challengeBtn, var0_9 ~= Map.ACTIVITY_HARD)
	setActive(arg0_9.missionBtn, var0_9 == Map.ACTIVITY_HARD)

	if var0_9 == Map.ACTIVITY_HARD then
		local var1_9 = _.any(var2_0, function(arg0_10)
			local var0_10 = getProxy(TaskProxy):getTaskById(arg0_10)

			return tobool(var0_10)
		end)

		setActive(arg0_9.missionBtn, var1_9)

		if var1_9 then
			setActive(arg0_9.missionBtn:Find("Tip"), _.any(var2_0, function(arg0_11)
				local var0_11 = getProxy(TaskProxy):getTaskById(arg0_11)

				return var0_11 and var0_11:isFinish()
			end))
		end
	end
end

function var0_0.OnDestroy(arg0_12)
	PoolMgr.GetInstance():ReturnUI(var1_0, arg0_12.buttons)
	var0_0.super.OnDestroy(arg0_12)
end

return var0_0
