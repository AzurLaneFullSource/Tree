local var0_0 = class("CoreActivityPage", import("view.base.BaseSubView"))

function var0_0.SetShareData(arg0_1, arg1_1)
	arg0_1.shareData = arg1_1
end

function var0_0.SetCoreActivityUI(arg0_2, arg1_2)
	arg0_2.coreActivityUI = arg1_2
end

function var0_0.SetUIName(arg0_3, arg1_3)
	arg0_3._uiName = arg1_3
end

function var0_0.getUIName(arg0_4)
	return arg0_4._uiName
end

function var0_0.Flush(arg0_5, arg1_5)
	arg0_5.activity = arg1_5

	if arg0_5:OnDataSetting() then
		return
	end

	if defaultValue(arg0_5.isFirst, true) then
		arg0_5.isFirst = false

		arg0_5:BindPageLink()
		arg0_5:OnFirstFlush()
	end

	arg0_5:OnUpdateFlush()
end

function var0_0.ShowOrHide(arg0_6, arg1_6)
	SetActive(arg0_6._go, arg1_6)

	if arg1_6 then
		local var0_6 = {}

		arg0_6:emit(ActivityMainScene.GET_PAGE_BGM, arg0_6.__cname, var0_6)

		if var0_6.bgm then
			pg.BgmMgr.GetInstance():Push(ActivityMainScene.__cname, var0_6.bgm)
		end

		arg0_6:OnShowFlush()
	else
		arg0_6:OnHideFlush()
	end
end

function var0_0.BindPageLink(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7:GetPageLink()) do
		ActivityConst.PageIdLink[iter1_7] = arg0_7.activity.id
	end
end

function var0_0.OnInit(arg0_8)
	return
end

function var0_0.OnDataSetting(arg0_9)
	return
end

function var0_0.GetPageLink(arg0_10)
	return {}
end

function var0_0.OnFirstFlush(arg0_11)
	return
end

function var0_0.OnUpdateFlush(arg0_12)
	return
end

function var0_0.OnHideFlush(arg0_13)
	return
end

function var0_0.OnShowFlush(arg0_14)
	return
end

function var0_0.OnDestroy(arg0_15)
	return
end

function var0_0.OnLoadLayers(arg0_16)
	return
end

function var0_0.OnRemoveLayers(arg0_17)
	return
end

function var0_0.UseSecondPage(arg0_18, arg1_18)
	return false
end

function var0_0.IsShowingPopWindow(arg0_19)
	return false
end

function var0_0.ClosePopWindow(arg0_20)
	return
end

function var0_0.IsShowReminder(arg0_21)
	return nil
end

return var0_0
