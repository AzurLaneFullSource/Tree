local var0_0 = class("BaseActivityPage", import(".BaseSubView"))

function var0_0.SetShareData(arg0_1, arg1_1)
	arg0_1.shareData = arg1_1
end

function var0_0.SetUIName(arg0_2, arg1_2)
	arg0_2._uiName = arg1_2
end

function var0_0.getUIName(arg0_3)
	return arg0_3._uiName
end

function var0_0.Flush(arg0_4, arg1_4)
	arg0_4.activity = arg1_4

	if arg0_4:OnDataSetting() then
		return
	end

	if defaultValue(arg0_4.isFirst, true) then
		arg0_4.isFirst = false

		arg0_4:BindPageLink()
		arg0_4:OnFirstFlush()
	end

	arg0_4:OnUpdateFlush()
end

function var0_0.ShowOrHide(arg0_5, arg1_5)
	SetActive(arg0_5._go, arg1_5)

	if arg1_5 then
		local var0_5 = {}

		arg0_5:emit(ActivityMainScene.GET_PAGE_BGM, arg0_5.__cname, var0_5)

		if var0_5.bgm then
			pg.BgmMgr.GetInstance():Push(ActivityMainScene.__cname, var0_5.bgm)
		end

		arg0_5:OnShowFlush()
	else
		arg0_5:OnHideFlush()
	end
end

function var0_0.BindPageLink(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6:GetPageLink()) do
		ActivityConst.PageIdLink[iter1_6] = arg0_6.activity.id
	end
end

function var0_0.OnInit(arg0_7)
	return
end

function var0_0.OnDataSetting(arg0_8)
	return
end

function var0_0.GetPageLink(arg0_9)
	return {}
end

function var0_0.OnFirstFlush(arg0_10)
	return
end

function var0_0.OnUpdateFlush(arg0_11)
	return
end

function var0_0.OnHideFlush(arg0_12)
	return
end

function var0_0.OnShowFlush(arg0_13)
	return
end

function var0_0.OnDestroy(arg0_14)
	return
end

function var0_0.OnLoadLayers(arg0_15)
	return
end

function var0_0.OnRemoveLayers(arg0_16)
	return
end

function var0_0.UseSecondPage(arg0_17, arg1_17)
	return false
end

return var0_0
