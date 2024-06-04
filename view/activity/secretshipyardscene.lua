local var0 = class("SecretShipyardScene", import("..base.BaseUI"))

var0.optionsPath = {
	"main/top/btn_home"
}
var0.ACT_ID = 5023
var0.GAME_ID = 59
var0.ANIMATIONS = {
	"Phase_00",
	"Phase_01",
	"Phase_02",
	"Phase_03",
	"Phase_04",
	"Phase_05",
	"Phase_06",
	"Phase_07"
}
var0.EFFECT_DELAY = 2
var0.ANIMATION_DELAY = 1
var0.STORY_DELAY = 3

function var0.getUIName(arg0)
	return "SecretShipyardUI"
end

function var0.init(arg0)
	arg0.activity = getProxy(ActivityProxy):getActivityById(var0.ACT_ID)
	arg0.count = 0
	arg0.bgId = 1
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskGroup = arg0.activity:getConfig("config_data")
	arg0.main = arg0:findTF("main")
	arg0.bottom = arg0:findTF("bottom", arg0.main)
	arg0.gameButton = arg0:findTF("btn_go_game", arg0.bottom)
	arg0.gameButtonLock = arg0:findTF("btn_go_game_lock", arg0.gameButton)
	arg0.items = arg0:findTF("items", arg0.bottom)
	arg0.item = arg0:findTF("item", arg0.bottom)
	arg0.dayText = arg0:findTF("day/nday", arg0.bottom)
	arg0.description = arg0:findTF("description/Text", arg0.bottom)
	arg0.top = arg0:findTF("top", arg0.main)
	arg0.buttonBack = arg0:findTF("btn_back", arg0.top)
	arg0.buttonHelp = arg0:findTF("btn_help", arg0.top)
	arg0.uilist = UIItemList.New(arg0.items, arg0.item)
	arg0.bg = arg0:findTF("bg")
	arg0.animator = arg0:findTF("anim", arg0.bg):GetComponent(typeof(Animator))
	arg0.effect = arg0:findTF("effect", arg0.bg)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.buttonBack, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.buttonHelp, function()
		local var0 = i18n("shipyard_phase_1" or "shipyard_phase_2")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.gameButton, function()
		arg0:emit(SecretShipyardMediator.GO_MINI_GAME, var0.GAME_ID)
	end, SFX_PANEL)
	onButton(arg0, arg0.gameButtonLock, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg0:checkTaskFinish() and "shipyard_button_1" or "shipyard_button_2"))
	end, SFX_PANEL)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateTask(arg1, arg2)
		end
	end)
	setText(arg0.description, i18n("shipyard_introduce"))
	setActive(arg0.effect, false)
	setActive(arg0.buttonHelp, arg0:checkMinigame())

	arg0.count = arg0.activity.data3
	arg0.bgId = arg0:CheckBgId()

	arg0.animator:Play(var0.ANIMATIONS[arg0.bgId])
	arg0:OnUpdateFlush()

	local var0 = arg0.activity:getConfig("config_client").firstStory

	if var0 then
		playStory(var0)
	end

	arg0:PlayStory()
end

function var0.UpdateTask(arg0, arg1, arg2)
	local var0 = arg1 + 1
	local var1 = arg0:findTF("item", arg2)
	local var2 = arg0.taskGroup[arg0.count][var0]
	local var3 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)

	assert(var3, "without this task by id: " .. var2)

	local var4 = var3:getConfig("award_display")[1]
	local var5 = {
		type = var4[1],
		id = var4[2],
		count = var4[3]
	}

	updateDrop(var1, var5)
	onButton(arg0, var1, function()
		warning("click")
		arg0:emit(BaseUI.ON_DROP, var5)
	end, SFX_PANEL)

	local var6 = var3:getProgress()
	local var7 = var3:getConfig("target_num")

	setText(arg0:findTF("description", arg2), var3:getConfig("desc"))

	local var8 = var6
	local var9 = "/" .. var7

	setText(arg0:findTF("progress_text", arg2), var8 .. var9)
	setSlider(arg0:findTF("progress", arg2), 0, var7, var6)

	local var10 = arg0:findTF("go_btn", arg2)
	local var11 = arg0:findTF("get_btn", arg2)
	local var12 = arg0:findTF("got_btn", arg2)
	local var13 = var3:getTaskStatus()

	setActive(var10, var13 == 0)
	setActive(var11, var13 == 1)
	setActive(var12, var13 == 2)
	onButton(arg0, var10, function()
		arg0:emit(SecretShipyardMediator.TASK_GO, var3)
	end, SFX_PANEL)
	onButton(arg0, var11, function()
		arg0:emit(SecretShipyardMediator.SUBMIT_TASK, var3.id)
	end, SFX_PANEL)
	setActive(arg0:findTF("mask", arg2), arg0.taskProxy:getFinishTaskById(var2) ~= nil)
end

function var0.updateTaskLayers(arg0)
	updateActivityTaskStatus(arg0.activity)

	arg0.activity = getProxy(ActivityProxy):getActivityById(var0.ACT_ID)

	arg0:OnUpdateFlush()
end

function var0.CheckBgId(arg0)
	local var0 = arg0.activity.data3

	if arg0.taskProxy:getFinishTaskById(arg0.taskGroup[arg0.count][1]) ~= nil and arg0.taskProxy:getFinishTaskById(arg0.taskGroup[arg0.count][2]) ~= nil then
		var0 = var0 + 1
	end

	return var0
end

function var0.OnUpdateFlush(arg0)
	arg0.count = arg0.activity.data3

	if arg0.bgId ~= arg0:CheckBgId() then
		arg0.bgId = arg0:CheckBgId()

		arg0:ChangeBackground()
	end

	if arg0.dayText then
		setText(arg0.dayText, tostring(arg0.count))
	end

	setActive(arg0.gameButtonLock, not arg0:checkTaskFinish() or not arg0:checkMinigame())
	setActive(arg0.gameButton, arg0:checkTaskFinish() or arg0:checkMinigame())
	arg0.uilist:align(#arg0.taskGroup[arg0.count])
end

function var0.ChangeBackground(arg0)
	LeanTween.cancel(go(arg0._tf))
	setActive(arg0.effect, true)
	LeanTween.delayedCall(go(arg0._tf), var0.ANIMATION_DELAY, System.Action(function()
		arg0.animator:Play(var0.ANIMATIONS[arg0.bgId])
	end))
	LeanTween.delayedCall(go(arg0._tf), var0.EFFECT_DELAY, System.Action(function()
		setActive(arg0.effect, false)
	end))
	LeanTween.delayedCall(go(arg0._tf), var0.STORY_DELAY, System.Action(function()
		arg0:PlayStory()
	end))
end

function var0.PlayStory(arg0)
	local var0 = arg0.activity:getConfig("config_client").story

	if checkExist(var0, {
		arg0.bgId - 1
	}, {
		1
	}) then
		playStory(var0[arg0.bgId - 1][1])
	end
end

function var0.checkTaskFinish(arg0)
	if arg0.count < #arg0.taskGroup then
		return false
	end

	for iter0, iter1 in ipairs(arg0.taskGroup[arg0.count]) do
		if not arg0.taskProxy:getFinishTaskById(iter1) then
			return false
		end
	end

	return true
end

function var0.checkMinigame(arg0)
	return pg.mini_game[var0.GAME_ID] ~= nil
end

function var0.willExit(arg0)
	LeanTween.cancel(go(arg0._tf))
end

return var0
