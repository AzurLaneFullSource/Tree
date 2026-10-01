local var0_0 = class("ActivitySingleScene", import("..base.BaseUI"))

var0_0.EXIT = "exit"

function var0_0.preload(arg0_1, arg1_1)
	arg1_1()
end

function var0_0.getResource(arg0_2)
	local var0_2 = var0_0.super.getResource(arg0_2)
	local var1_2 = arg0_2.contextData.activity

	if not var1_2 and arg0_2.contextData.id then
		var1_2 = getProxy(ActivityProxy):getActivityById(arg0_2.contextData.id)
	end

	if var1_2 and not var1_2:isEnd() then
		table.insertto(var0_2, var1_2:getPageABNames())
	end

	return var0_2
end

function var0_0.getUIName(arg0_3)
	return "ActivitySingleUI"
end

function var0_0.init(arg0_4)
	arg0_4.shareData = ActivityShareData.New()
	arg0_4.pageContainer = arg0_4._tf

	pg.UIMgr.GetInstance():OverlayPanel(arg0_4._tf)
end

function var0_0.didEnter(arg0_5)
	arg0_5:bind(var0_0.EXIT, function(arg0_6)
		arg0_5:emit(var0_0.ON_BACK)
	end)
end

function var0_0.setPlayer(arg0_7, arg1_7)
	arg0_7.shareData:SetPlayer(arg1_7)
end

function var0_0.setFlagShip(arg0_8, arg1_8)
	arg0_8.shareData:SetFlagShip(arg1_8)
end

function var0_0.updateTaskLayers(arg0_9)
	if not arg0_9.activity then
		return
	end

	arg0_9:updateActivity(arg0_9.activity)
end

function var0_0.selectActivity(arg0_10, arg1_10)
	arg0_10.activity = arg1_10

	local var0_10 = arg1_10:getConfig("page_info")

	if var0_10.class_name and not arg1_10:isEnd() then
		arg0_10.actPage = import("view.activity.subPages." .. var0_10.class_name).New(arg0_10.pageContainer, arg0_10.event, arg0_10.contextData)

		if arg0_10.actPage:UseSecondPage(arg1_10) then
			arg0_10.actPage:SetUIName(var0_10.ui_name2)
		else
			arg0_10.actPage:SetUIName(var0_10.ui_name)
		end

		arg0_10.actPage:SetShareData(arg0_10.shareData)
		arg0_10.actPage:Load()
		arg0_10.actPage:ActionInvoke("Flush", arg0_10.activity)
		arg0_10.actPage:ActionInvoke("ShowOrHide", true)
	end
end

function var0_0.updateActivity(arg0_11, arg1_11)
	if ActivityConst.PageIdLink[arg1_11.id] then
		arg1_11 = getProxy(ActivityProxy):getActivityById(ActivityConst.PageIdLink[arg1_11.id])
	end

	if arg1_11:isShow() and arg1_11:isCorePage(arg0_11.contextData.coreName or "") and not arg1_11:isEnd() and arg0_11.activity and arg0_11.activity.id == arg1_11.id then
		arg0_11.activity = arg1_11

		arg0_11.actPage:ActionInvoke("Flush", arg1_11)
	end
end

function var0_0.onBackPressed(arg0_12)
	arg0_12.actPage:ActionInvoke("onBackPressed")
	arg0_12:emit(var0_0.ON_BACK_PRESSED)
end

function var0_0.willExit(arg0_13)
	arg0_13.shareData = nil

	if arg0_13.actPage then
		arg0_13.actPage:Destroy()
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf)
end

return var0_0
