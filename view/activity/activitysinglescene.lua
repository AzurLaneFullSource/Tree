local var0 = class("ActivitySingleScene", import("..base.BaseUI"))

var0.EXIT = "exit"

function var0.preload(arg0, arg1)
	arg1()
end

function var0.getUIName(arg0)
	return "ActivitySingleUI"
end

function var0.init(arg0)
	arg0.shareData = ActivityShareData.New()
	arg0.pageContainer = arg0._tf

	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
end

function var0.didEnter(arg0)
	arg0:bind(var0.EXIT, function(arg0)
		arg0:emit(var0.ON_BACK)
	end)
end

function var0.setPlayer(arg0, arg1)
	arg0.shareData:SetPlayer(arg1)
end

function var0.setFlagShip(arg0, arg1)
	arg0.shareData:SetFlagShip(arg1)
end

function var0.updateTaskLayers(arg0)
	if not arg0.activity then
		return
	end

	arg0:updateActivity(arg0.activity)
end

function var0.selectActivity(arg0, arg1)
	arg0.activity = arg1

	local var0 = arg1:getConfig("page_info")

	if var0.class_name and not arg1:isEnd() then
		arg0.actPage = import("view.activity.subPages." .. var0.class_name).New(arg0.pageContainer, arg0.event, arg0.contextData)

		if arg0.actPage:UseSecondPage(arg1) then
			arg0.actPage:SetUIName(var0.ui_name2)
		else
			arg0.actPage:SetUIName(var0.ui_name)
		end

		arg0.actPage:SetShareData(arg0.shareData)
		arg0.actPage:Load()
		arg0.actPage:ActionInvoke("Flush", arg0.activity)
		arg0.actPage:ActionInvoke("ShowOrHide", true)
	end
end

function var0.updateActivity(arg0, arg1)
	if ActivityConst.PageIdLink[arg1.id] then
		arg1 = getProxy(ActivityProxy):getActivityById(ActivityConst.PageIdLink[arg1.id])
	end

	if arg1:isShow() and not arg1:isEnd() and arg0.activity and arg0.activity.id == arg1.id then
		arg0.activity = arg1

		arg0.actPage:ActionInvoke("Flush", arg1)
	end
end

function var0.onBackPressed(arg0)
	arg0.actPage:ActionInvoke("onBackPressed")
	arg0:emit(var0.ON_BACK_PRESSED)
end

function var0.willExit(arg0)
	arg0.shareData = nil

	if arg0.actPage then
		arg0.actPage:Destroy()
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
