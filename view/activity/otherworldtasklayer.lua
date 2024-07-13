local var0_0 = class("OtherWorldTaskLayer", import("..base.BaseUI"))

var0_0.sub_item_warning = "sub_item_warning"

local var1_0 = "other_world_task_title"

function var0_0.getUIName(arg0_1)
	return "OtherWorldTaskUI"
end

function var0_0.init(arg0_2)
	arg0_2.activityId = ActivityConst.OTHER_WORLD_TASK_ID

	local var0_2 = findTF(arg0_2._tf, "ad")

	arg0_2.btnBack = findTF(var0_2, "btnBack")
	arg0_2.taskPage = OtherWorldTaskPage.New(findTF(var0_2, "pages/taskPage"), arg0_2.contextData, findTF(var0_2, "tpl"), arg0_2)

	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
	arg0_2.taskPage:setActive(true)
end

function var0_0.didEnter(arg0_3)
	setText(findTF(arg0_3._tf, "ad/title/text"), i18n(var1_0))
	onButton(arg0_3, arg0_3.btnBack, function()
		arg0_3:closeView()
	end, SOUND_BACK)
	onButton(arg0_3, findTF(arg0_3._tf, "ad/pages/taskPage/clickClose"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)
end

function var0_0.updateTask(arg0_6, arg1_6)
	arg0_6.taskPage:updateTask(arg1_6)
end

function var0_0.willExit(arg0_7)
	arg0_7.taskPage:dispose()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_7._tf)
end

return var0_0
