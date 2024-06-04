local var0 = class("MapBuilderSSSS", import(".MapBuilderNormal"))
local var1 = "ssss_buttons"

function var0.preload(arg0, arg1)
	PoolMgr.GetInstance():GetUI(var1, true, function(arg0)
		arg0.buttons = arg0

		arg1()
	end)
end

function var0.GetType(arg0)
	return MapBuilder.TYPESSSS
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.mainLayer = arg0._parentTf:Find("main")
	arg0.rightChapter = arg0._parentTf:Find("main/right_chapter/event_btns/BottomList")
	arg0.leftChapter = arg0._parentTf:Find("main/left_chapter/buttons")
	arg0.challengeBtn = tf(arg0.buttons):Find("btn_challenge")
	arg0.missionBtn = tf(arg0.buttons):Find("btn_mission")

	onButton(arg0, arg0.challengeBtn, function()
		if arg0:isfrozen() then
			return
		end

		arg0:emit(LevelUIConst.SWITCH_CHALLENGE_MAP)
	end, SFX_PANEL)
	onButton(arg0, arg0.missionBtn, function()
		if arg0:isfrozen() then
			return
		end

		arg0:emit(LevelMediator2.ON_GO_TO_TASK_SCENE, {
			page = TaskScene.PAGE_TYPE_ACT
		})
	end, SFX_PANEL)
	setParent(arg0.buttons, arg0.mainLayer)
end

function var0.ShowButtons(arg0)
	var0.super.ShowButtons(arg0)
	setActive(arg0.buttons, true)
	setParent(arg0.challengeBtn, arg0.leftChapter)
	arg0.challengeBtn:SetSiblingIndex(5)
	setParent(arg0.missionBtn, arg0.rightChapter)
	arg0.missionBtn:SetSiblingIndex(0)
end

function var0.HideButtons(arg0)
	setParent(arg0.challengeBtn, arg0.buttons)
	setParent(arg0.missionBtn, arg0.buttons)
	setActive(arg0.buttons, false)
	var0.super.HideButtons(arg0)
end

local var2 = {
	18993,
	18994,
	18995,
	18996,
	18997
}

function var0.UpdateButtons(arg0)
	var0.super.UpdateButtons(arg0)

	local var0 = arg0.data:getConfig("type")

	setActive(arg0.sceneParent.actEliteBtn, false)
	setActive(arg0.challengeBtn, var0 ~= Map.ACTIVITY_HARD)
	setActive(arg0.missionBtn, var0 == Map.ACTIVITY_HARD)

	if var0 == Map.ACTIVITY_HARD then
		local var1 = _.any(var2, function(arg0)
			local var0 = getProxy(TaskProxy):getTaskById(arg0)

			return tobool(var0)
		end)

		setActive(arg0.missionBtn, var1)

		if var1 then
			setActive(arg0.missionBtn:Find("Tip"), _.any(var2, function(arg0)
				local var0 = getProxy(TaskProxy):getTaskById(arg0)

				return var0 and var0:isFinish()
			end))
		end
	end
end

function var0.OnDestroy(arg0)
	PoolMgr.GetInstance():ReturnUI(var1, arg0.buttons)
	var0.super.OnDestroy(arg0)
end

return var0
