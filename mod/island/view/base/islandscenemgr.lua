local var0_0 = class("IslandSceneMgr")
local var1_0 = false
local var2_0 = 1
local var3_0 = 2

var0_0.NEED_LONDING_PAGE_LIST = {
	"IslandCheaterTavernPrepareMainPage"
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.scene = arg1_1
	arg0_1.capacity = 2
	arg0_1.stack = {}
	arg0_1.noStatePages = {}
	arg0_1.pages = {}
	arg0_1.subPages = {}
	arg0_1.state = var2_0
	arg0_1.gcCnt = 0
end

function var0_0.OpenPage(arg0_2, arg1_2, arg2_2, ...)
	local var0_2 = packEx(...)

	if arg0_2:IsSceneType(arg1_2) then
		local var1_2 = arg0_2:CreateScenePage(arg2_2)

		arg0_2:CheckOverflowAndDestory(var1_2)

		if arg0_2:IsNeedLoadingPage(arg2_2) then
			pg.SceneAnimMgr.GetInstance():CommonSceneChange("Dorm3DLoading", function(arg0_3)
				arg0_2:ClosePrevScenePage(function()
					arg0_2:Record(IslandSceneContext.New(arg2_2, unpackEx(var0_2)), true)
					arg0_2:StartPage(var1_2, var0_2)
					arg0_3()
				end)
			end)
		else
			arg0_2:ClosePrevScenePage(function()
				arg0_2:Record(IslandSceneContext.New(arg2_2, unpackEx(var0_2)), true)
				arg0_2:StartPage(var1_2, var0_2)
			end)
		end

		return var1_2
	else
		local var2_2 = arg0_2:CreateSubPage(arg1_2, arg2_2)
		local var3_2, var4_2 = arg0_2:GetContext(arg1_2)

		assert(var3_2, arg1_2.__cname)
		var3_2:AddSubPage(arg2_2, var4_2, arg1_2.__cname, ...)
		arg0_2:StartPage(var2_2, var0_2)
		arg0_2.scene:emit(ISLAND_EVT.SUB_PAGE_OPEN, arg2_2.__cname)

		return var2_2
	end
end

function var0_0.IsNeedLoadingPage(arg0_6, arg1_6)
	return table.keyof(var0_0.NEED_LONDING_PAGE_LIST, arg1_6.__cname)
end

function var0_0.GetContext(arg0_7, arg1_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.stack) do
		if iter1_7.class.__cname == arg1_7.__cname then
			return iter1_7, #iter1_7:GetSubPages()
		end
	end

	for iter2_7, iter3_7 in ipairs(arg0_7.stack) do
		local var0_7 = _.detect(iter3_7:GetSubPages(), function(arg0_8)
			return arg0_8.class.__cname == arg1_7.__cname
		end)

		if var0_7 then
			return iter3_7, var0_7:GetLevel()
		end
	end

	return nil
end

function var0_0.GetPage(arg0_9, arg1_9)
	return _.detect(arg0_9.pages, function(arg0_10)
		return arg0_10.__cname == arg1_9.__cname
	end) or _.detect(arg0_9.noStatePages, function(arg0_11)
		return arg0_11.__cname == arg1_9.__cname
	end)
end

function var0_0.GetSubPage(arg0_12, arg1_12)
	return (_.detect(arg0_12.subPages, function(arg0_13)
		return arg0_13.__cname == arg1_12.__cname
	end))
end

function var0_0.StartPage(arg0_14, arg1_14, arg2_14)
	seriesAsync({
		function(arg0_15)
			arg1_14:Preload(arg0_15, unpackEx(arg2_14))
		end
	}, function()
		arg1_14:ExecuteAction("Show", unpackEx(arg2_14))
	end)
end

function var0_0.CreateScenePage(arg0_17, arg1_17)
	local var0_17 = _.detect(arg0_17.pages, function(arg0_18)
		return arg0_18.__cname == arg1_17.__cname
	end)

	if var0_17 then
		table.removebyvalue(arg0_17.pages, var0_17)
	end

	local var1_17 = var0_17 or arg1_17.New(arg0_17.scene, arg0_17.scene.uiContainer)
	local var2_17 = var1_17:NeedCache() and arg0_17.pages or arg0_17.noStatePages

	table.insert(var2_17, var1_17)

	return var1_17
end

function var0_0.CreateSubPage(arg0_19, arg1_19, arg2_19)
	local var0_19 = _.detect(arg0_19.subPages, function(arg0_20)
		return arg0_20.__cname == arg2_19.__cname
	end)

	if var0_19 then
		table.removebyvalue(arg0_19.subPages, var0_19)
	end

	local var1_19 = var0_19 or arg2_19.New(arg0_19.scene, arg0_19.scene.pageContainer)

	table.insert(arg0_19.subPages, var1_19)

	return var1_19
end

function var0_0.ClosePrevScenePage(arg0_21, arg1_21)
	local var0_21 = arg0_21.stack[#arg0_21.stack]

	if var0_21 then
		local var1_21 = arg0_21:GetPage(var0_21.class)

		if var1_21 and var1_21:GetLoaded() and var1_21:isShowing() then
			var1_21:Disable(arg1_21)

			for iter0_21, iter1_21 in ipairs(var0_21:GetSubPages()) do
				local var2_21 = arg0_21:GetSubPage(iter1_21.class)

				if var2_21 and var2_21:GetLoaded() then
					var2_21:Disable()
				end
			end
		else
			arg1_21()
		end
	else
		arg1_21()
	end
end

function var0_0.CheckOverflowAndDestory(arg0_22, arg1_22)
	if #arg0_22.pages > arg0_22.capacity then
		local var0_22 = arg0_22:GetLongestNoUsePage(arg1_22)
		local var1_22 = arg0_22:GetContext(var0_22.class)

		if var1_22 then
			var1_22:DisabelDelRecordWhenClose()
		end

		arg0_22:DestroyPage(var0_22, nil, true)

		arg0_22.gcCnt = arg0_22.gcCnt + 1

		if arg0_22.gcCnt % 5 == 0 then
			gcAll(false)

			arg0_22.gcCnt = 0
		end
	end
end

function var0_0.GetLongestNoUsePage(arg0_23, arg1_23)
	local function var0_23(arg0_24)
		return arg0_23:GetContext(arg0_24.class) ~= nil
	end

	local var1_23 = 0

	for iter0_23, iter1_23 in ipairs(arg0_23.pages) do
		if arg1_23 ~= iter1_23 and not var0_23(iter1_23) then
			var1_23 = iter0_23

			break
		end
	end

	local var2_23 = math.max(var1_23, 1)

	return arg0_23.pages[var2_23]
end

function var0_0.ClosePage(arg0_25, arg1_25)
	if not (arg0_25:CheckAndCloseSubPage(arg1_25) or arg0_25:CheckAndCloseNoStatePage(arg1_25)) then
		arg0_25:CheckAndCloseScenePage(arg1_25)
	end

	arg0_25:Debug()
end

function var0_0.DestorySubPage(arg0_26, arg1_26)
	local var0_26 = arg0_26:GetContext(arg1_26)

	if not var0_26 then
		return
	end

	for iter0_26, iter1_26 in ipairs(var0_26:GetSubPages()) do
		local var1_26 = arg0_26:GetSubPage(iter1_26.class)

		if var1_26 and var1_26:GetLoaded() then
			iter1_26.__visible = false

			table.removebyvalue(arg0_26.subPages, var1_26)
			var1_26:Destroy()
		end
	end
end

function var0_0.CheckAndCloseScenePage(arg0_27, arg1_27)
	local var0_27 = arg0_27:GetContext(arg1_27)

	if var0_27 then
		local var1_27 = arg0_27:GetPage(var0_27.class)

		if var1_27 and var1_27:GetLoaded() and var1_27:isShowing() then
			local var2_27 = var0_27:GetOpenPrevWhenClose()

			if var0_27:GetDelRecordWhenClose() then
				arg0_27:DelRecord(var0_27)
			end

			var1_27:Disable()

			for iter0_27, iter1_27 in ipairs(var0_27:GetSubPages()) do
				local var3_27 = arg0_27:GetSubPage(iter1_27.class)

				if var3_27 and var3_27:GetLoaded() then
					var3_27:Destroy()
					table.removebyvalue(arg0_27.subPages, var3_27)
				end
			end

			if var2_27 then
				arg0_27:OpenPrevScenePage()
			end
		end

		return var1_27 ~= nil
	end

	return false
end

function var0_0.OpenPrevScenePage(arg0_28)
	if arg0_28:IsDestroyed() then
		return
	end

	local var0_28 = arg0_28.stack[#arg0_28.stack]

	if var0_28 then
		local var1_28 = arg0_28:GetPage(var0_28.class)

		if var1_28 and var1_28:GetLoaded() and var1_28:isShowing() then
			arg0_28:Record(var0_28)
			var1_28:Enable()

			for iter0_28, iter1_28 in ipairs(var0_28:GetSubPages()) do
				if iter1_28.__visible then
					local var2_28 = arg0_28:GetSubPage(iter1_28.class)

					if var2_28:GetLoaded() then
						var2_28:Disable()
					end
				end
			end
		else
			arg0_28:DelRecord(var0_28)

			local var3_28 = arg0_28:OpenPage(arg0_28.scene, var0_28.class, unpackEx(var0_28:GetData()))

			for iter2_28, iter3_28 in ipairs(var0_28:GetSubPages()) do
				if iter3_28.__visible then
					arg0_28:OpenPage(var3_28, iter3_28.class, unpackEx(iter3_28:GetData()))
				end
			end
		end
	end
end

function var0_0.CheckAndCloseSubPage(arg0_29, arg1_29)
	local var0_29 = arg0_29:GetContext(arg1_29)

	if var0_29 then
		local var1_29 = -1

		for iter0_29, iter1_29 in ipairs(var0_29:GetSubPages()) do
			if iter1_29.class.__cname == arg1_29.__cname then
				var1_29 = iter1_29:GetLevel()

				break
			end
		end

		if var1_29 >= 0 then
			for iter2_29, iter3_29 in ipairs(var0_29:GetSubPages()) do
				if var1_29 == iter3_29:GetLevel() and (iter3_29:GetSubPageParentName() == arg1_29.__cname or iter3_29.class.__cname == arg1_29.__cname) then
					local var2_29 = arg0_29:GetSubPage(iter3_29.class)

					if var2_29 and var2_29:GetLoaded() then
						iter3_29.__visible = false

						arg0_29.scene:emit(ISLAND_EVT.SUB_PAGE_CLOSE, var2_29.class.__cname)
						var2_29:Disable()
					end
				end
			end

			return true
		end
	end

	return false
end

function var0_0.CheckAndCloseNoStatePage(arg0_30, arg1_30)
	local var0_30 = arg0_30:GetContext(arg1_30)
	local var1_30 = false

	if var0_30 then
		local var2_30 = _.detect(arg0_30.noStatePages, function(arg0_31)
			return arg0_31.__cname == arg1_30.__cname
		end)

		if var2_30 then
			arg0_30:DelRecord(var0_30)
			arg0_30:DestroyPage(var2_30, var0_30)
			arg0_30:OpenPrevScenePage()

			var1_30 = true
		end
	end

	return var1_30
end

function var0_0.DestroyPage(arg0_32, arg1_32, arg2_32, arg3_32)
	arg2_32 = arg2_32 or arg0_32:GetContext(arg1_32.class)

	if arg2_32 then
		arg2_32:DisabelOpenPrevWhenClose()

		for iter0_32, iter1_32 in ipairs(arg2_32:GetSubPages()) do
			local var0_32 = arg0_32:GetSubPage(iter1_32.class)

			if var0_32 and var0_32:GetLoaded() then
				var0_32:Destroy()
				table.removebyvalue(arg0_32.subPages, arg1_32)
			end
		end
	end

	if arg1_32:GetLoaded() then
		arg1_32:Destroy(arg3_32)

		if arg1_32:NeedCache() then
			table.removebyvalue(arg0_32.pages, arg1_32)
		else
			table.removebyvalue(arg0_32.noStatePages, arg1_32)
		end
	end
end

function var0_0.Record(arg0_33, arg1_33, arg2_33)
	if arg0_33:IsDestroyed() then
		return
	end

	local var0_33 = _.detect(arg0_33.stack, function(arg0_34)
		return arg0_34.class == arg1_33.class
	end)

	if var0_33 then
		table.removebyvalue(arg0_33.stack, var0_33)
		table.insert(arg0_33.stack, arg1_33)

		return
	end

	table.insert(arg0_33.stack, arg1_33)

	if #arg0_33.stack == 1 then
		arg0_33:OnAnyPageOpen(arg1_33.class)
	end
end

function var0_0.DelRecord(arg0_35, arg1_35)
	if arg0_35:IsDestroyed() then
		return
	end

	table.removebyvalue(arg0_35.stack, arg1_35)

	if #arg0_35.stack == 0 then
		arg0_35:OnAllPageClose()
	end
end

function var0_0.OnAnyPageOpen(arg0_36, arg1_36)
	arg0_36.scene:emitCore(ISLAND_EVT.ANY_PAGE_OPENED, arg1_36)
	arg0_36.scene:TryDisVisible()
end

function var0_0.OnAllPageClose(arg0_37)
	arg0_37.scene:emitCore(ISLAND_EVT.ALL_PAGE_CLOSED)
	arg0_37.scene:TryVisible()
end

function var0_0.IsAllPageClose(arg0_38)
	return #arg0_38.stack == 0
end

function var0_0.IsSceneType(arg0_39, arg1_39)
	return arg1_39.__cname == arg0_39.scene.__cname
end

function var0_0.OnBackPressed(arg0_40)
	local var0_40 = arg0_40.stack[#arg0_40.stack]

	if var0_40 then
		local var1_40 = arg0_40:GetPage(var0_40.class)

		if var1_40 and var1_40:CanEsc() then
			var1_40:Hide()
		end

		return true
	end

	return false
end

function var0_0.IsDestroyed(arg0_41)
	return arg0_41.state == var3_0
end

function var0_0.Dispose(arg0_42)
	arg0_42.state = var3_0

	for iter0_42 = #arg0_42.pages, 1, -1 do
		local var0_42 = arg0_42.pages[iter0_42]

		var0_42:ActiveOrDisactive(false)
		arg0_42:DestroyPage(var0_42)
	end

	for iter1_42 = #arg0_42.noStatePages, 1, -1 do
		local var1_42 = arg0_42.noStatePages[iter1_42]

		var1_42:ActiveOrDisactive(false)
		arg0_42:DestroyPage(var1_42)
	end

	arg0_42.stack = nil
	arg0_42.noStatePages = nil
	arg0_42.pages = nil
	arg0_42.subPages = nil
end

function var0_0.Debug(arg0_43)
	if not var1_0 then
		return
	end

	local function var0_43(arg0_44)
		local var0_44 = _.map(arg0_44:GetSubPages(), function(arg0_45)
			return arg0_45.class.__cname
		end)

		return table.concat(var0_44, ",")
	end

	local var1_43 = _.map(arg0_43.stack, function(arg0_46)
		return arg0_46.class.__cname .. ":[" .. var0_43(arg0_46) .. "]"
	end)
	local var2_43 = table.concat(var1_43, "\n")

	print("\n" .. var2_43)
end

return var0_0
