local var0_0 = class("ActivitySingleScene", import("..base.BaseUI"))

var0_0.EXIT = "exit"

function var0_0.preload(arg0_1, arg1_1)
	arg1_1()
end

function var0_0.getUIName(arg0_2)
	return "ActivitySingleUI"
end

function var0_0.init(arg0_3)
	arg0_3.shareData = ActivityShareData.New()
	arg0_3.pageContainer = arg0_3._tf

	pg.UIMgr.GetInstance():OverlayPanel(arg0_3._tf)
end

function var0_0.didEnter(arg0_4)
	arg0_4:bind(var0_0.EXIT, function(arg0_5)
		arg0_4:emit(var0_0.ON_BACK)
	end)
end

function var0_0.setPlayer(arg0_6, arg1_6)
	arg0_6.shareData:SetPlayer(arg1_6)
end

function var0_0.setFlagShip(arg0_7, arg1_7)
	arg0_7.shareData:SetFlagShip(arg1_7)
end

function var0_0.updateTaskLayers(arg0_8)
	if not arg0_8.activity then
		return
	end

	arg0_8:updateActivity(arg0_8.activity)
end

function var0_0.selectActivity(arg0_9, arg1_9)
	arg0_9.activity = arg1_9

	local var0_9 = arg1_9:getConfig("page_info")

	if var0_9.class_name and not arg1_9:isEnd() then
		arg0_9.actPage = import("view.activity.subPages." .. var0_9.class_name).New(arg0_9.pageContainer, arg0_9.event, arg0_9.contextData)

		if arg0_9.actPage:UseSecondPage(arg1_9) then
			arg0_9.actPage:SetUIName(var0_9.ui_name2)
		else
			arg0_9.actPage:SetUIName(var0_9.ui_name)
		end

		arg0_9.actPage:SetShareData(arg0_9.shareData)
		arg0_9.actPage:Load()
		arg0_9.actPage:ActionInvoke("Flush", arg0_9.activity)
		arg0_9.actPage:ActionInvoke("ShowOrHide", true)
	end
end

function var0_0.updateActivity(arg0_10, arg1_10)
	if ActivityConst.PageIdLink[arg1_10.id] then
		arg1_10 = getProxy(ActivityProxy):getActivityById(ActivityConst.PageIdLink[arg1_10.id])
	end

	if arg1_10:isShow() and not arg1_10:isEnd() and arg0_10.activity and arg0_10.activity.id == arg1_10.id then
		arg0_10.activity = arg1_10

		arg0_10.actPage:ActionInvoke("Flush", arg1_10)
	end
end

function var0_0.onBackPressed(arg0_11)
	arg0_11.actPage:ActionInvoke("onBackPressed")
	arg0_11:emit(var0_0.ON_BACK_PRESSED)
end

function var0_0.willExit(arg0_12)
	arg0_12.shareData = nil

	if arg0_12.actPage then
		arg0_12.actPage:Destroy()
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12._tf)
end

return var0_0
