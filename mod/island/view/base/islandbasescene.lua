local var0_0 = class("IslandBaseScene", import("view.base.BaseUI"))
local var1_0 = false

var0_0.CLOSE_PAGE = "IslandBaseScene:CLOSE_PAGE"

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.capacity = 3
	arg0_1.balance = 0
	arg0_1.pages = {}
	arg0_1.subPages = {}
	arg0_1.__callbacks__ = {}
end

function var0_0.preload(arg0_2, arg1_2)
	AssetBundleHelper.StoreAssetBundle("ui/islandcommonui_atlas", true, false, function(arg0_3)
		arg1_2()
	end)
end

function var0_0.emit(arg0_4, ...)
	if unpack({
		...
	}) == BaseUI.ON_HOME then
		arg0_4:ExitIsland()
	else
		var0_0.super.emit(arg0_4, ...)
	end
end

function var0_0.ExitIsland(arg0_5)
	local var0_5 = arg0_5.contextData.id

	seriesAsync({
		function(arg0_6)
			pg.m02:sendNotification(GAME.ISLAND_EXIT, {
				id = var0_5,
				callback = arg0_6
			})
		end
	}, function()
		var0_0.super.emit(arg0_5, BaseUI.ON_HOME)
	end)
end

function var0_0.GetIsland(arg0_8)
	assert(false, "overwrite me !!!!")
end

function var0_0.onUILoaded(arg0_9, arg1_9)
	var0_0.super.onUILoaded(arg0_9, arg1_9)

	arg0_9.subViews = {
		IslandMsgBox.New(pg.UIMgr.GetInstance().OverlayMain, arg0_9.event),
		IslandToast.New(pg.UIMgr.GetInstance().OverlayToast, arg0_9.event),
		IslandStoryMgr.New(pg.UIMgr.GetInstance().OverlayToast, arg0_9.event),
		IslandAwardDisplayPage.New(pg.UIMgr.GetInstance().OverlayToast, arg0_9.event)
	}
	arg0_9.monitors = {
		IslandPlayerDataMonitor.New(arg0_9:GetIsland()),
		IslandSyncDataMonitor.New(arg0_9:GetIsland())
	}

	arg0_9:AddListeners()
end

function var0_0.GetSubView(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.subViews) do
		if isa(iter1_10, arg1_10) then
			return iter1_10
		end
	end

	return nil
end

function var0_0.StartCore(arg0_11)
	arg0_11:emit(IslandBaseMediator.SET_UP)
end

function var0_0.DoOpenPage(arg0_12, arg1_12, arg2_12, ...)
	local var0_12

	if arg1_12.__cname == arg0_12.__cname then
		var0_12 = arg0_12:InstancePage(arg2_12)

		arg0_12:HideOtherPages(arg0_12.balance)
		table.insert(arg0_12.pages, var0_12)

		if #arg0_12.pages > arg0_12.capacity then
			local var1_12 = table.remove(arg0_12.pages, 1)

			arg0_12:DestroyPage(var1_12)
		end

		if arg0_12.balance == 0 then
			arg0_12:OnAnyPageOpen(arg2_12)
		end

		arg0_12.balance = arg0_12.balance + 1
	else
		var0_12 = arg0_12:InstanceSubPage(arg1_12, arg2_12)

		if not arg0_12.subPages[arg1_12.__cname] then
			arg0_12.subPages[arg1_12.__cname] = {}
		end

		table.insert(arg0_12.subPages[arg1_12.__cname], var0_12)
	end

	var0_12:ExecuteAction("Show", ...)
	arg0_12:Debug()

	return var0_12
end

function var0_0.HideOtherPages(arg0_13, arg1_13)
	local var0_13 = #arg0_13.pages
	local var1_13 = math.max(0, var0_13 - arg1_13 + 1)

	for iter0_13 = var0_13, var1_13, -1 do
		local var2_13 = arg0_13.pages[iter0_13]

		if var2_13 then
			var2_13:Disable()
		end
	end
end

function var0_0.DoClosePage(arg0_14, arg1_14)
	local var0_14 = false

	for iter0_14, iter1_14 in ipairs(arg0_14.pages) do
		if iter1_14.__cname == arg1_14.__cname then
			arg0_14:CloseSelfAndSub(iter1_14)

			var0_14 = true

			break
		end
	end

	if not var0_14 then
		for iter2_14, iter3_14 in pairs(arg0_14.subPages) do
			for iter4_14, iter5_14 in ipairs(iter3_14) do
				if iter5_14.__cname == arg1_14.__cname then
					if iter5_14:GetLoaded() and iter5_14:isShowing() then
						iter5_14:Disable()
					end

					var0_14 = true

					break
				end
			end
		end
	end

	if var0_14 then
		arg0_14:emit(var0_0.CLOSE_PAGE, arg1_14)
	end

	arg0_14:Debug()
end

function var0_0.InstancePage(arg0_15, arg1_15)
	local var0_15 = 0

	for iter0_15, iter1_15 in ipairs(arg0_15.pages) do
		if iter1_15.__cname == arg1_15.__cname then
			var0_15 = iter0_15

			break
		end
	end

	if var0_15 > 0 then
		return (table.remove(arg0_15.pages, var0_15))
	else
		return arg1_15.New(arg0_15)
	end
end

function var0_0.InstanceSubPage(arg0_16, arg1_16, arg2_16)
	for iter0_16, iter1_16 in ipairs(arg0_16.subPages[arg1_16.__cname] or {}) do
		if iter1_16.__cname == arg2_16.__cname then
			table.remove(arg0_16.subPages[arg1_16.__cname], iter0_16)

			return iter1_16
		end
	end

	return arg2_16.New(arg0_16)
end

function var0_0.GetInstancePage(arg0_17, arg1_17)
	for iter0_17, iter1_17 in pairs(arg0_17.pages) do
		if isa(iter1_17, arg1_17) then
			return iter1_17
		end
	end

	for iter2_17, iter3_17 in pairs(arg0_17.subPages) do
		if isa(iter3_17, arg1_17) then
			return iter3_17
		end
	end
end

function var0_0.CloseSelfAndSub(arg0_18, arg1_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.subPages[arg1_18.__cname] or {}) do
		if iter1_18:GetLoaded() and iter1_18:isShowing() then
			iter1_18:Disable()
		end
	end

	if arg1_18:GetLoaded() and arg1_18:isShowing() then
		arg1_18:Disable()

		arg0_18.balance = arg0_18.balance - 1

		arg0_18:ShowOtherPage(arg0_18.balance)

		if arg0_18.balance == 0 then
			arg0_18:OnAllPageClose()
		end

		for iter2_18, iter3_18 in ipairs(arg0_18.subPages[arg1_18.__cname] or {}) do
			iter3_18:Destroy()
		end

		arg0_18.subPages[arg1_18.__cname] = {}
	end
end

function var0_0.OnAnyPageOpen(arg0_19, arg1_19)
	arg0_19:setVisible(false)

	if _IslandCore then
		_IslandCore:Link(ISLAND_EVT.ANY_PAGE_OPENED, arg1_19)
	end
end

function var0_0.OnAllPageClose(arg0_20)
	arg0_20:setVisible(true)

	if _IslandCore then
		_IslandCore:Link(ISLAND_EVT.ALL_PAGE_CLOSED)
	end
end

function var0_0.setVisible(arg0_21, arg1_21)
	arg0_21:ShowOrHideResUI(arg1_21)

	if arg1_21 then
		arg0_21:OnVisible()
	else
		arg0_21:OnDisVisible()
	end

	setActive(arg0_21._tf, arg1_21)
end

function var0_0.ShowOtherPage(arg0_22, arg1_22)
	local var0_22 = math.max(0, #arg0_22.pages - arg1_22)

	for iter0_22 = math.max(#arg0_22.pages - 1, 0), var0_22, -1 do
		local var1_22 = arg0_22.pages[iter0_22]

		if var1_22 then
			var1_22:Enable()
		end
	end
end

function var0_0.StepCloseSelfAndSub(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.subPages[arg1_23.__cname] or {}) do
		if iter1_23:GetLoaded() and iter1_23:isShowing() then
			iter1_23:Hide()

			return
		end
	end

	if arg1_23:GetLoaded() and arg1_23:isShowing() then
		arg1_23:Hide()
	end
end

function var0_0.DestroyPage(arg0_24, arg1_24)
	if arg1_24:GetLoaded() then
		arg1_24:Destroy()
	end

	for iter0_24, iter1_24 in ipairs(arg0_24.subPages[arg1_24.__cname] or {}) do
		if iter1_24:GetLoaded() then
			iter1_24:Destroy()
		end
	end

	arg0_24.subPages[arg1_24.__cname] = {}
end

function var0_0.OpenPage(arg0_25, arg1_25, ...)
	return arg0_25:DoOpenPage(arg0_25, arg1_25, ...)
end

function var0_0.ClosePage(arg0_26, arg1_26)
	arg0_26:DoClosePage(arg1_26)
end

function var0_0.ShowMsgbox(arg0_27, arg1_27)
	arg0_27:GetSubView(IslandMsgBox):ExecuteAction("Show", arg1_27)
end

function var0_0.ShowToast(arg0_28, arg1_28)
	arg0_28:GetSubView(IslandToast):ExecuteAction("Show", arg1_28)
end

function var0_0.DisplayAward(arg0_29, arg1_29)
	arg0_29:GetSubView(IslandAwardDisplayPage):ExecuteAction("Show", arg1_29)
end

function var0_0.PlayStory(arg0_30, arg1_30)
	arg0_30:setVisible(false)
	arg0_30:GetSubView(IslandStoryMgr):ExecuteAction("Play", arg1_30.name, function()
		arg0_30:setVisible(true)

		if arg1_30.callback then
			arg1_30.callback()
		end
	end)
end

function var0_0.AddListener(arg0_32, arg1_32, arg2_32)
	local function var0_32(arg0_33, ...)
		arg2_32(arg0_32, ...)
	end

	local var1_32 = arg0_32:bind(arg1_32, var0_32)

	arg0_32.__callbacks__[arg1_32] = var1_32

	arg0_32:GetIsland():AddListener(arg1_32, var0_32)
end

function var0_0.RemoveListener(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.__callbacks__[arg1_34]

	if var0_34 then
		local var1_34 = arg0_34.eventStore[var0_34]

		arg0_34:GetIsland():RemoveListener(arg1_34, var1_34.callback)
		arg0_34:disconnect(var0_34)

		arg0_34.__callbacks__[arg1_34] = nil
	end
end

function var0_0.onBackPressed(arg0_35)
	for iter0_35, iter1_35 in ipairs(arg0_35.subViews) do
		if iter1_35:GetLoaded() and iter1_35:isShowing() then
			iter1_35:Hide()

			return
		end
	end

	for iter2_35, iter3_35 in ipairs(arg0_35.pages) do
		if iter3_35:GetLoaded() and iter3_35:isShowing() then
			arg0_35:StepCloseSelfAndSub(iter3_35)

			return
		end
	end

	var0_0.super.onBackPressed(arg0_35)
end

function var0_0.exit(arg0_36)
	arg0_36:RemoveListeners()
	AssetBundleHelper.UnstoreAssetBundle("ui/islandcommonui_atlas", true)

	for iter0_36, iter1_36 in ipairs(arg0_36.subViews) do
		if iter1_36:GetLoaded() then
			iter1_36:Destroy()
		end
	end

	arg0_36.subViews = nil

	for iter2_36, iter3_36 in ipairs(arg0_36.monitors) do
		iter3_36:Dispose()
	end

	arg0_36.monitors = nil

	arg0_36:GetIsland():ClearListeners()

	for iter4_36, iter5_36 in ipairs(arg0_36.pages) do
		arg0_36:DestroyPage(iter5_36)
	end

	arg0_36.pages = nil
	arg0_36.subPages = nil

	var0_0.super.exit(arg0_36)
end

function var0_0.AddListeners(arg0_37)
	return
end

function var0_0.RemoveListeners(arg0_38)
	return
end

function var0_0.OnUnloadScene(arg0_39)
	return
end

function var0_0.Debug(arg0_40)
	if not var1_0 then
		return
	end

	local function var0_40(arg0_41)
		local var0_41 = arg0_40.subPages[arg0_41.__cname] or {}
		local var1_41 = _.map(var0_41, function(arg0_42)
			return arg0_42.__cname
		end)

		return table.concat(var1_41, ",")
	end

	local var1_40 = _.map(arg0_40.pages, function(arg0_43)
		return arg0_43.__cname .. ":" .. var0_40(arg0_43)
	end)
	local var2_40 = table.concat(var1_40, "\n")

	print("\n" .. var2_40)
end

return var0_0
