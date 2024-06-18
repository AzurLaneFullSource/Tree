local var0_0 = class("IslandTaskScene", import("..base.BaseUI"))

var0_0.OPEN_SUBMIT = "open submit"
var0_0.ryza_task_tag_explore = "ryza_task_tag_explore"
var0_0.ryza_task_tag_battle = "ryza_task_tag_battle"
var0_0.ryza_task_tag_dalegate = "ryza_task_tag_dalegate"
var0_0.ryza_task_tag_develop = "ryza_task_tag_develop"
var0_0.ryza_task_tag_adventure = "ryza_task_tag_adventure"
var0_0.ryza_task_tag_build = "ryza_task_tag_build"
var0_0.ryza_task_tag_create = "ryza_task_tag_create"
var0_0.ryza_task_tag_daily = "ryza_task_tag_daily"
var0_0.add_tages = {
	var0_0.ryza_task_tag_explore,
	var0_0.ryza_task_tag_battle,
	var0_0.ryza_task_tag_dalegate,
	var0_0.ryza_task_tag_develop,
	var0_0.ryza_task_tag_adventure,
	var0_0.ryza_task_tag_build,
	var0_0.ryza_task_tag_create,
	var0_0.ryza_task_tag_daily
}
var0_0.ryza_task_detail_content = "ryza_task_detail_content"
var0_0.ryza_task_detail_award = "ryza_task_detail_award"
var0_0.ryza_task_confirm = "ryza_task_confirm"
var0_0.ryza_task_cancel = "ryza_task_cancel"
var0_0.sub_item_warning = "sub_item_warning"
var0_0.island_build_desc = "island_build_desc"
var0_0.island_history_desc = "island_history_desc"
var0_0.island_build_level = "island_build_level"
var0_0.icon_atlas = "ui/islandtaskicon_atlas"
var0_0.ui_atlas = "ui/islandtaskui_atlas"
var0_0.task_level_num = 5
var0_0.task_add_num = 4

local var1_0 = 1
local var2_0 = 2
local var3_0 = 3

function var0_0.getUIName(arg0_1)
	return "IslandTaskUI"
end

function var0_0.init(arg0_2)
	arg0_2.activityId = ActivityConst.ISLAND_TASK_ID

	local var0_2 = findTF(arg0_2._tf, "ad")

	arg0_2.btnBack = findTF(var0_2, "btnBack")
	arg0_2.btnBuild = findTF(var0_2, "leftBtns/btnBuild")
	arg0_2.btnTask = findTF(var0_2, "leftBtns/btnTask")
	arg0_2.btnHistory = findTF(var0_2, "leftBtns/btnHistory")
	arg0_2.taskPage = IslandTaskPage.New(findTF(var0_2, "pages/taskPage"), arg0_2.contextData, findTF(var0_2, "tpl"), arg0_2)
	arg0_2.buildPage = IslandBuildPage.New(findTF(var0_2, "pages/buildPage"), arg0_2)
	arg0_2.historyPage = IslandHistoryPage.New(findTF(var0_2, "pages/historyPage"), arg0_2)

	arg0_2.taskPage:setActive(false)
	arg0_2.buildPage:setActive(false)
	arg0_2.historyPage:setActive(false)

	local var1_2 = findTF(arg0_2._tf, "pop")

	arg0_2.submitPanel = findTF(var1_2, "submitPanel")

	setActive(arg0_2.submitPanel, false)

	arg0_2.submitDisplayContent = findTF(arg0_2.submitPanel, "itemDisplay/viewport/content")
	arg0_2.submitConfirm = findTF(arg0_2.submitPanel, "btnComfirm")
	arg0_2.submitCancel = findTF(arg0_2.submitPanel, "btnCancel")
	arg0_2.subimtItem = findTF(arg0_2.submitPanel, "itemDisplay/viewport/content/item")
	arg0_2.submitItemDesc = findTF(arg0_2.submitPanel, "itemDesc")
	arg0_2.btnCancel = findTF(arg0_2.submitPanel, "btnCancel")

	setText(findTF(arg0_2.submitPanel, "btnComfirm/text"), i18n(var0_0.ryza_task_confirm))
	setText(findTF(arg0_2.submitPanel, "btnCancel/text"), i18n(var0_0.ryza_task_cancel))
	setText(findTF(arg0_2.submitPanel, "bg/text"), i18n(var0_0.sub_item_warning))
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.btnBack, function()
		arg0_3:closeView()
	end, SOUND_BACK)
	onToggle(arg0_3, arg0_3.btnBuild, function(arg0_5)
		arg0_3:clearTagBtn()
		setActive(findTF(arg0_3.btnBuild, "bg"), not arg0_5)
		setActive(findTF(arg0_3.btnBuild, "bg_selected"), arg0_5)

		if arg0_5 then
			arg0_3:showPage(var3_0)
		end
	end, SFX_CONFIRM)
	onToggle(arg0_3, arg0_3.btnTask, function(arg0_6)
		arg0_3:clearTagBtn()
		setActive(findTF(arg0_3.btnTask, "bg"), not arg0_6)
		setActive(findTF(arg0_3.btnTask, "bg_selected"), arg0_6)

		if arg0_6 then
			arg0_3:showPage(var1_0)
		end
	end, SFX_CONFIRM)
	onToggle(arg0_3, arg0_3.btnHistory, function(arg0_7)
		arg0_3:clearTagBtn()
		setActive(findTF(arg0_3.btnHistory, "bg"), not arg0_7)
		setActive(findTF(arg0_3.btnHistory, "bg_selected"), arg0_7)

		if arg0_7 then
			arg0_3:showPage(var2_0)
		end
	end, SFX_CONFIRM)
	onButton(arg0_3, arg0_3.submitConfirm, function()
		arg0_3:emit(IslandTaskMediator.SUBMIT_TASK, {
			activityId = arg0_3.activityId,
			id = arg0_3.selectTask.id
		})
		setActive(arg0_3.submitPanel, false)
	end, SOUND_BACK)
	onButton(arg0_3, arg0_3.submitCancel, function()
		setActive(arg0_3.submitPanel, false)
	end, SOUND_BACK)
	arg0_3:bind(IslandTaskScene.OPEN_SUBMIT, function(arg0_10, arg1_10, arg2_10)
		arg0_3:openSubmitPanel(arg1_10)
	end)
	triggerToggle(arg0_3.btnTask, true)
end

function var0_0.clearTagBtn(arg0_11)
	setActive(findTF(arg0_11.btnBuild, "bg"), true)
	setActive(findTF(arg0_11.btnBuild, "bg_selected"), false)
	setActive(findTF(arg0_11.btnTask, "bg"), true)
	setActive(findTF(arg0_11.btnTask, "bg_selected"), false)
	setActive(findTF(arg0_11.btnHistory, "bg"), true)
	setActive(findTF(arg0_11.btnHistory, "bg_selected"), false)
end

function var0_0.showPage(arg0_12, arg1_12)
	arg0_12.taskPage:setActive(arg1_12 == var1_0)
	arg0_12.buildPage:setActive(arg1_12 == var3_0)
	arg0_12.historyPage:setActive(arg1_12 == var2_0)
end

function var0_0.openSubmitPanel(arg0_13, arg1_13)
	setActive(arg0_13.submitPanel, true)

	local var0_13 = tonumber(arg1_13:getConfig("target_id_2"))
	local var1_13 = pg.activity_ryza_item[var0_13].name

	updateDrop(arg0_13.subimtItem, {
		type = DROP_TYPE_RYZA_DROP,
		id = tonumber(var0_13),
		count = arg1_13:getConfig("target_num")
	})
	setText(arg0_13.submitItemDesc, var1_13)
end

function var0_0.updateTask(arg0_14, arg1_14)
	arg0_14.taskPage:updateTask(arg1_14)
end

function var0_0.willExit(arg0_15)
	arg0_15.taskPage:dispose()
	arg0_15.historyPage:dispose()
	arg0_15.buildPage:dispose()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_15._tf)
end

return var0_0
