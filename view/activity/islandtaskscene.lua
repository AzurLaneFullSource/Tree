local var0 = class("IslandTaskScene", import("..base.BaseUI"))

var0.OPEN_SUBMIT = "open submit"
var0.ryza_task_tag_explore = "ryza_task_tag_explore"
var0.ryza_task_tag_battle = "ryza_task_tag_battle"
var0.ryza_task_tag_dalegate = "ryza_task_tag_dalegate"
var0.ryza_task_tag_develop = "ryza_task_tag_develop"
var0.ryza_task_tag_adventure = "ryza_task_tag_adventure"
var0.ryza_task_tag_build = "ryza_task_tag_build"
var0.ryza_task_tag_create = "ryza_task_tag_create"
var0.ryza_task_tag_daily = "ryza_task_tag_daily"
var0.add_tages = {
	var0.ryza_task_tag_explore,
	var0.ryza_task_tag_battle,
	var0.ryza_task_tag_dalegate,
	var0.ryza_task_tag_develop,
	var0.ryza_task_tag_adventure,
	var0.ryza_task_tag_build,
	var0.ryza_task_tag_create,
	var0.ryza_task_tag_daily
}
var0.ryza_task_detail_content = "ryza_task_detail_content"
var0.ryza_task_detail_award = "ryza_task_detail_award"
var0.ryza_task_confirm = "ryza_task_confirm"
var0.ryza_task_cancel = "ryza_task_cancel"
var0.sub_item_warning = "sub_item_warning"
var0.island_build_desc = "island_build_desc"
var0.island_history_desc = "island_history_desc"
var0.island_build_level = "island_build_level"
var0.icon_atlas = "ui/islandtaskicon_atlas"
var0.ui_atlas = "ui/islandtaskui_atlas"
var0.task_level_num = 5
var0.task_add_num = 4

local var1 = 1
local var2 = 2
local var3 = 3

function var0.getUIName(arg0)
	return "IslandTaskUI"
end

function var0.init(arg0)
	arg0.activityId = ActivityConst.ISLAND_TASK_ID

	local var0 = findTF(arg0._tf, "ad")

	arg0.btnBack = findTF(var0, "btnBack")
	arg0.btnBuild = findTF(var0, "leftBtns/btnBuild")
	arg0.btnTask = findTF(var0, "leftBtns/btnTask")
	arg0.btnHistory = findTF(var0, "leftBtns/btnHistory")
	arg0.taskPage = IslandTaskPage.New(findTF(var0, "pages/taskPage"), arg0.contextData, findTF(var0, "tpl"), arg0)
	arg0.buildPage = IslandBuildPage.New(findTF(var0, "pages/buildPage"), arg0)
	arg0.historyPage = IslandHistoryPage.New(findTF(var0, "pages/historyPage"), arg0)

	arg0.taskPage:setActive(false)
	arg0.buildPage:setActive(false)
	arg0.historyPage:setActive(false)

	local var1 = findTF(arg0._tf, "pop")

	arg0.submitPanel = findTF(var1, "submitPanel")

	setActive(arg0.submitPanel, false)

	arg0.submitDisplayContent = findTF(arg0.submitPanel, "itemDisplay/viewport/content")
	arg0.submitConfirm = findTF(arg0.submitPanel, "btnComfirm")
	arg0.submitCancel = findTF(arg0.submitPanel, "btnCancel")
	arg0.subimtItem = findTF(arg0.submitPanel, "itemDisplay/viewport/content/item")
	arg0.submitItemDesc = findTF(arg0.submitPanel, "itemDesc")
	arg0.btnCancel = findTF(arg0.submitPanel, "btnCancel")

	setText(findTF(arg0.submitPanel, "btnComfirm/text"), i18n(var0.ryza_task_confirm))
	setText(findTF(arg0.submitPanel, "btnCancel/text"), i18n(var0.ryza_task_cancel))
	setText(findTF(arg0.submitPanel, "bg/text"), i18n(var0.sub_item_warning))
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SOUND_BACK)
	onToggle(arg0, arg0.btnBuild, function(arg0)
		arg0:clearTagBtn()
		setActive(findTF(arg0.btnBuild, "bg"), not arg0)
		setActive(findTF(arg0.btnBuild, "bg_selected"), arg0)

		if arg0 then
			arg0:showPage(var3)
		end
	end, SFX_CONFIRM)
	onToggle(arg0, arg0.btnTask, function(arg0)
		arg0:clearTagBtn()
		setActive(findTF(arg0.btnTask, "bg"), not arg0)
		setActive(findTF(arg0.btnTask, "bg_selected"), arg0)

		if arg0 then
			arg0:showPage(var1)
		end
	end, SFX_CONFIRM)
	onToggle(arg0, arg0.btnHistory, function(arg0)
		arg0:clearTagBtn()
		setActive(findTF(arg0.btnHistory, "bg"), not arg0)
		setActive(findTF(arg0.btnHistory, "bg_selected"), arg0)

		if arg0 then
			arg0:showPage(var2)
		end
	end, SFX_CONFIRM)
	onButton(arg0, arg0.submitConfirm, function()
		arg0:emit(IslandTaskMediator.SUBMIT_TASK, {
			activityId = arg0.activityId,
			id = arg0.selectTask.id
		})
		setActive(arg0.submitPanel, false)
	end, SOUND_BACK)
	onButton(arg0, arg0.submitCancel, function()
		setActive(arg0.submitPanel, false)
	end, SOUND_BACK)
	arg0:bind(IslandTaskScene.OPEN_SUBMIT, function(arg0, arg1, arg2)
		arg0:openSubmitPanel(arg1)
	end)
	triggerToggle(arg0.btnTask, true)
end

function var0.clearTagBtn(arg0)
	setActive(findTF(arg0.btnBuild, "bg"), true)
	setActive(findTF(arg0.btnBuild, "bg_selected"), false)
	setActive(findTF(arg0.btnTask, "bg"), true)
	setActive(findTF(arg0.btnTask, "bg_selected"), false)
	setActive(findTF(arg0.btnHistory, "bg"), true)
	setActive(findTF(arg0.btnHistory, "bg_selected"), false)
end

function var0.showPage(arg0, arg1)
	arg0.taskPage:setActive(arg1 == var1)
	arg0.buildPage:setActive(arg1 == var3)
	arg0.historyPage:setActive(arg1 == var2)
end

function var0.openSubmitPanel(arg0, arg1)
	setActive(arg0.submitPanel, true)

	local var0 = tonumber(arg1:getConfig("target_id_2"))
	local var1 = pg.activity_ryza_item[var0].name

	updateDrop(arg0.subimtItem, {
		type = DROP_TYPE_RYZA_DROP,
		id = tonumber(var0),
		count = arg1:getConfig("target_num")
	})
	setText(arg0.submitItemDesc, var1)
end

function var0.updateTask(arg0, arg1)
	arg0.taskPage:updateTask(arg1)
end

function var0.willExit(arg0)
	arg0.taskPage:dispose()
	arg0.historyPage:dispose()
	arg0.buildPage:dispose()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
