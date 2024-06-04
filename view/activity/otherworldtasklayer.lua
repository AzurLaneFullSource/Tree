local var0 = class("OtherWorldTaskLayer", import("..base.BaseUI"))

var0.sub_item_warning = "sub_item_warning"

local var1 = "other_world_task_title"

function var0.getUIName(arg0)
	return "OtherWorldTaskUI"
end

function var0.init(arg0)
	arg0.activityId = ActivityConst.OTHER_WORLD_TASK_ID

	local var0 = findTF(arg0._tf, "ad")

	arg0.btnBack = findTF(var0, "btnBack")
	arg0.taskPage = OtherWorldTaskPage.New(findTF(var0, "pages/taskPage"), arg0.contextData, findTF(var0, "tpl"), arg0)

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0.taskPage:setActive(true)
end

function var0.didEnter(arg0)
	setText(findTF(arg0._tf, "ad/title/text"), i18n(var1))
	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SOUND_BACK)
	onButton(arg0, findTF(arg0._tf, "ad/pages/taskPage/clickClose"), function()
		arg0:closeView()
	end, SFX_CANCEL)
end

function var0.updateTask(arg0, arg1)
	arg0.taskPage:updateTask(arg1)
end

function var0.willExit(arg0)
	arg0.taskPage:dispose()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
