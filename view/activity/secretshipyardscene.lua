local var0_0 = class("SecretShipyardScene", import("..base.BaseUI"))

var0_0.optionsPath = {
	"main/top/btn_home"
}
var0_0.ACT_ID = 5023
var0_0.GAME_ID = 59
var0_0.ANIMATIONS = {
	"Phase_00",
	"Phase_01",
	"Phase_02",
	"Phase_03",
	"Phase_04",
	"Phase_05",
	"Phase_06",
	"Phase_07"
}
var0_0.EFFECT_DELAY = 2
var0_0.ANIMATION_DELAY = 1
var0_0.STORY_DELAY = 3

function var0_0.getUIName(arg0_1)
	return "SecretShipyardUI"
end

function var0_0.init(arg0_2)
	arg0_2.activity = getProxy(ActivityProxy):getActivityById(var0_0.ACT_ID)
	arg0_2.count = 0
	arg0_2.bgId = 1
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = arg0_2.activity:getConfig("config_data")
	arg0_2.main = arg0_2:findTF("main")
	arg0_2.bottom = arg0_2:findTF("bottom", arg0_2.main)
	arg0_2.gameButton = arg0_2:findTF("btn_go_game", arg0_2.bottom)
	arg0_2.gameButtonLock = arg0_2:findTF("btn_go_game_lock", arg0_2.gameButton)
	arg0_2.items = arg0_2:findTF("items", arg0_2.bottom)
	arg0_2.item = arg0_2:findTF("item", arg0_2.bottom)
	arg0_2.dayText = arg0_2:findTF("day/nday", arg0_2.bottom)
	arg0_2.description = arg0_2:findTF("description/Text", arg0_2.bottom)
	arg0_2.top = arg0_2:findTF("top", arg0_2.main)
	arg0_2.buttonBack = arg0_2:findTF("btn_back", arg0_2.top)
	arg0_2.buttonHelp = arg0_2:findTF("btn_help", arg0_2.top)
	arg0_2.uilist = UIItemList.New(arg0_2.items, arg0_2.item)
	arg0_2.bg = arg0_2:findTF("bg")
	arg0_2.animator = arg0_2:findTF("anim", arg0_2.bg):GetComponent(typeof(Animator))
	arg0_2.effect = arg0_2:findTF("effect", arg0_2.bg)
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.buttonBack, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.buttonHelp, function()
		local var0_5 = i18n("shipyard_phase_1" or "shipyard_phase_2")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0_5
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.gameButton, function()
		arg0_3:emit(SecretShipyardMediator.GO_MINI_GAME, var0_0.GAME_ID)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.gameButtonLock, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg0_3:checkTaskFinish() and "shipyard_button_1" or "shipyard_button_2"))
	end, SFX_PANEL)
	arg0_3.uilist:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg0_3:UpdateTask(arg1_8, arg2_8)
		end
	end)
	setText(arg0_3.description, i18n("shipyard_introduce"))
	setActive(arg0_3.effect, false)
	setActive(arg0_3.buttonHelp, arg0_3:checkMinigame())

	arg0_3.count = arg0_3.activity.data3
	arg0_3.bgId = arg0_3:CheckBgId()

	arg0_3.animator:Play(var0_0.ANIMATIONS[arg0_3.bgId])
	arg0_3:OnUpdateFlush()

	local var0_3 = arg0_3.activity:getConfig("config_client").firstStory

	if var0_3 then
		playStory(var0_3)
	end

	arg0_3:PlayStory()
end

function var0_0.UpdateTask(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg1_9 + 1
	local var1_9 = arg0_9:findTF("item", arg2_9)
	local var2_9 = arg0_9.taskGroup[arg0_9.count][var0_9]
	local var3_9 = arg0_9.taskProxy:getTaskById(var2_9) or arg0_9.taskProxy:getFinishTaskById(var2_9)

	assert(var3_9, "without this task by id: " .. var2_9)

	local var4_9 = var3_9:getConfig("award_display")[1]
	local var5_9 = {
		type = var4_9[1],
		id = var4_9[2],
		count = var4_9[3]
	}

	updateDrop(var1_9, var5_9)
	onButton(arg0_9, var1_9, function()
		warning("click")
		arg0_9:emit(BaseUI.ON_DROP, var5_9)
	end, SFX_PANEL)

	local var6_9 = var3_9:getProgress()
	local var7_9 = var3_9:getConfig("target_num")

	setText(arg0_9:findTF("description", arg2_9), var3_9:getConfig("desc"))

	local var8_9 = var6_9
	local var9_9 = "/" .. var7_9

	setText(arg0_9:findTF("progress_text", arg2_9), var8_9 .. var9_9)
	setSlider(arg0_9:findTF("progress", arg2_9), 0, var7_9, var6_9)

	local var10_9 = arg0_9:findTF("go_btn", arg2_9)
	local var11_9 = arg0_9:findTF("get_btn", arg2_9)
	local var12_9 = arg0_9:findTF("got_btn", arg2_9)
	local var13_9 = var3_9:getTaskStatus()

	setActive(var10_9, var13_9 == 0)
	setActive(var11_9, var13_9 == 1)
	setActive(var12_9, var13_9 == 2)
	onButton(arg0_9, var10_9, function()
		arg0_9:emit(SecretShipyardMediator.TASK_GO, var3_9)
	end, SFX_PANEL)
	onButton(arg0_9, var11_9, function()
		arg0_9:emit(SecretShipyardMediator.SUBMIT_TASK, var3_9.id)
	end, SFX_PANEL)
	setActive(arg0_9:findTF("mask", arg2_9), arg0_9.taskProxy:getFinishTaskById(var2_9) ~= nil)
end

function var0_0.updateTaskLayers(arg0_13)
	updateActivityTaskStatus(arg0_13.activity)

	arg0_13.activity = getProxy(ActivityProxy):getActivityById(var0_0.ACT_ID)

	arg0_13:OnUpdateFlush()
end

function var0_0.CheckBgId(arg0_14)
	local var0_14 = arg0_14.activity.data3

	if arg0_14.taskProxy:getFinishTaskById(arg0_14.taskGroup[arg0_14.count][1]) ~= nil and arg0_14.taskProxy:getFinishTaskById(arg0_14.taskGroup[arg0_14.count][2]) ~= nil then
		var0_14 = var0_14 + 1
	end

	return var0_14
end

function var0_0.OnUpdateFlush(arg0_15)
	arg0_15.count = arg0_15.activity.data3

	if arg0_15.bgId ~= arg0_15:CheckBgId() then
		arg0_15.bgId = arg0_15:CheckBgId()

		arg0_15:ChangeBackground()
	end

	if arg0_15.dayText then
		setText(arg0_15.dayText, tostring(arg0_15.count))
	end

	setActive(arg0_15.gameButtonLock, not arg0_15:checkTaskFinish() or not arg0_15:checkMinigame())
	setActive(arg0_15.gameButton, arg0_15:checkTaskFinish() or arg0_15:checkMinigame())
	arg0_15.uilist:align(#arg0_15.taskGroup[arg0_15.count])
end

function var0_0.ChangeBackground(arg0_16)
	LeanTween.cancel(go(arg0_16._tf))
	setActive(arg0_16.effect, true)
	LeanTween.delayedCall(go(arg0_16._tf), var0_0.ANIMATION_DELAY, System.Action(function()
		arg0_16.animator:Play(var0_0.ANIMATIONS[arg0_16.bgId])
	end))
	LeanTween.delayedCall(go(arg0_16._tf), var0_0.EFFECT_DELAY, System.Action(function()
		setActive(arg0_16.effect, false)
	end))
	LeanTween.delayedCall(go(arg0_16._tf), var0_0.STORY_DELAY, System.Action(function()
		arg0_16:PlayStory()
	end))
end

function var0_0.PlayStory(arg0_20)
	local var0_20 = arg0_20.activity:getConfig("config_client").story

	if checkExist(var0_20, {
		arg0_20.bgId - 1
	}, {
		1
	}) then
		playStory(var0_20[arg0_20.bgId - 1][1])
	end
end

function var0_0.checkTaskFinish(arg0_21)
	if arg0_21.count < #arg0_21.taskGroup then
		return false
	end

	for iter0_21, iter1_21 in ipairs(arg0_21.taskGroup[arg0_21.count]) do
		if not arg0_21.taskProxy:getFinishTaskById(iter1_21) then
			return false
		end
	end

	return true
end

function var0_0.checkMinigame(arg0_22)
	local var0_22 = pg.mini_game[var0_0.GAME_ID].simple_config_data.show_time
	local var1_22 = pg.TimeMgr.GetInstance():inTime(var0_22)

	return pg.mini_game[var0_0.GAME_ID] ~= nil and var1_22
end

function var0_0.willExit(arg0_23)
	LeanTween.cancel(go(arg0_23._tf))
end

return var0_0
