local var0_0 = class("MapBuilderSSSS", import(".MapBuilderNormal"))
local var1_0 = "ssss_buttons"

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPESSSS
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	PoolMgr.GetInstance():GetUI(var1_0, false, function(arg0_3)
		arg0_2.buttons = arg0_3
	end)

	arg0_2.mainLayer = arg0_2._parentTf:Find("main")
	arg0_2.rightChapter = arg0_2._parentTf:Find("main/right_chapter/event_btns/BottomList")
	arg0_2.leftChapter = arg0_2._parentTf:Find("main/left_chapter/buttons")
	arg0_2.challengeBtn = tf(arg0_2.buttons):Find("btn_challenge")
	arg0_2.missionBtn = tf(arg0_2.buttons):Find("btn_mission")

	onButton(arg0_2, arg0_2.challengeBtn, function()
		if arg0_2:isfrozen() then
			return
		end

		arg0_2:emit(LevelUIConst.SWITCH_ACT_MAP, Map.ACTIVITY_HARD)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.missionBtn, function()
		if arg0_2:isfrozen() then
			return
		end

		arg0_2:emit(LevelMediator2.ON_GO_TO_TASK_SCENE, {
			page = TaskScene.PAGE_TYPE_ACT
		})
	end, SFX_PANEL)
	setParent(arg0_2.buttons, arg0_2.mainLayer)
end

function var0_0.OnHide(arg0_6)
	setParent(arg0_6.challengeBtn, arg0_6.buttons)
	setParent(arg0_6.missionBtn, arg0_6.buttons)
	setActive(arg0_6.buttons, false)
	var0_0.super.OnHide(arg0_6)
end

function var0_0.OnShow(arg0_7)
	var0_0.super.OnShow(arg0_7)
	setActive(arg0_7.buttons, true)
	setParent(arg0_7.challengeBtn, arg0_7.leftChapter)
	arg0_7.challengeBtn:SetSiblingIndex(5)
	setParent(arg0_7.missionBtn, arg0_7.rightChapter)
	arg0_7.missionBtn:SetSiblingIndex(0)
end

local var2_0 = {
	18993,
	18994,
	18995,
	18996,
	18997
}

function var0_0.UpdateButtons(arg0_8)
	var0_0.super.UpdateButtons(arg0_8)

	local var0_8 = arg0_8.data:getConfig("type")

	setActive(arg0_8.sceneParent.actEliteBtn, false)
	setActive(arg0_8.challengeBtn, var0_8 ~= Map.ACTIVITY_HARD)
	setActive(arg0_8.missionBtn, var0_8 == Map.ACTIVITY_HARD)

	if var0_8 == Map.ACTIVITY_HARD then
		local var1_8 = _.any(var2_0, function(arg0_9)
			local var0_9 = getProxy(TaskProxy):getTaskById(arg0_9)

			return tobool(var0_9)
		end)

		setActive(arg0_8.missionBtn, var1_8)

		if var1_8 then
			setActive(arg0_8.missionBtn:Find("Tip"), _.any(var2_0, function(arg0_10)
				local var0_10 = getProxy(TaskProxy):getTaskById(arg0_10)

				return var0_10 and var0_10:isFinish()
			end))
		end
	end
end

function var0_0.OnDestroy(arg0_11)
	PoolMgr.GetInstance():ReturnUI(var1_0, arg0_11.buttons)
	var0_0.super.OnDestroy(arg0_11)
end

return var0_0
