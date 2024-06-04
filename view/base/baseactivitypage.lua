local var0 = class("BaseActivityPage", import(".BaseSubView"))

function var0.SetShareData(arg0, arg1)
	arg0.shareData = arg1
end

function var0.SetUIName(arg0, arg1)
	arg0._uiName = arg1
end

function var0.getUIName(arg0)
	return arg0._uiName
end

function var0.Flush(arg0, arg1)
	arg0.activity = arg1

	if arg0:OnDataSetting() then
		return
	end

	if defaultValue(arg0.isFirst, true) then
		arg0.isFirst = false

		arg0:BindPageLink()
		arg0:OnFirstFlush()
	end

	arg0:OnUpdateFlush()
end

function var0.ShowOrHide(arg0, arg1)
	SetActive(arg0._go, arg1)

	if arg1 then
		local var0 = {}

		arg0:emit(ActivityMainScene.GET_PAGE_BGM, arg0.__cname, var0)

		if var0.bgm then
			pg.BgmMgr.GetInstance():Push(ActivityMainScene.__cname, var0.bgm)
		end

		arg0:OnShowFlush()
	else
		arg0:OnHideFlush()
	end
end

function var0.BindPageLink(arg0)
	for iter0, iter1 in ipairs(arg0:GetPageLink()) do
		ActivityConst.PageIdLink[iter1] = arg0.activity.id
	end
end

function var0.OnInit(arg0)
	return
end

function var0.OnDataSetting(arg0)
	return
end

function var0.GetPageLink(arg0)
	return {}
end

function var0.OnFirstFlush(arg0)
	return
end

function var0.OnUpdateFlush(arg0)
	return
end

function var0.OnHideFlush(arg0)
	return
end

function var0.OnShowFlush(arg0)
	return
end

function var0.OnDestroy(arg0)
	return
end

function var0.OnLoadLayers(arg0)
	return
end

function var0.OnRemoveLayers(arg0)
	return
end

function var0.UseSecondPage(arg0, arg1)
	return false
end

return var0
