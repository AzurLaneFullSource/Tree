local var0_0 = class("IslandSceneMgr")
local var1_0 = false
local var2_0 = 1
local var3_0 = 2

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
		arg0_2:ClosePrevScenePage(function()
			arg0_2:Record(IslandSceneContext.New(arg2_2, unpackEx(var0_2)), true)
			arg0_2:StartPage(var1_2, var0_2)
		end)

		return var1_2
	else
		local var2_2 = arg0_2:CreateSubPage(arg1_2, arg2_2)
		local var3_2 = arg0_2:GetContext(arg1_2)

		assert(var3_2, arg1_2.__cname)
		var3_2:AddSubPage(arg2_2, ...)
		arg0_2:StartPage(var2_2, var0_2)

		return var2_2
	end
end

function var0_0.GetContext(arg0_4, arg1_4)
	return (_.detect(arg0_4.stack, function(arg0_5)
		return arg0_5.class.__cname == arg1_4.__cname or #arg0_5:GetSubPages() > 0 and _.any(arg0_5:GetSubPages(), function(arg0_6)
			return arg0_6.class.__cname == arg1_4.__cname
		end)
	end))
end

function var0_0.GetPage(arg0_7, arg1_7)
	return _.detect(arg0_7.pages, function(arg0_8)
		return arg0_8.__cname == arg1_7.__cname
	end) or _.detect(arg0_7.noStatePages, function(arg0_9)
		return arg0_9.__cname == arg1_7.__cname
	end)
end

function var0_0.GetSubPage(arg0_10, arg1_10)
	return (_.detect(arg0_10.subPages, function(arg0_11)
		return arg0_11.__cname == arg1_10.__cname
	end))
end

function var0_0.StartPage(arg0_12, arg1_12, arg2_12)
	seriesAsync({
		function(arg0_13)
			arg1_12:Preload(arg0_13, unpackEx(arg2_12))
		end
	}, function()
		arg1_12:ExecuteAction("Show", unpackEx(arg2_12))
	end)
end

function var0_0.CreateScenePage(arg0_15, arg1_15)
	local var0_15 = _.detect(arg0_15.pages, function(arg0_16)
		return arg0_16.__cname == arg1_15.__cname
	end)

	if var0_15 then
		table.removebyvalue(arg0_15.pages, var0_15)
	end

	local var1_15 = var0_15 or arg1_15.New(arg0_15.scene, arg0_15.scene.uiContainer)
	local var2_15 = var1_15:NeedCache() and arg0_15.pages or arg0_15.noStatePages

	table.insert(var2_15, var1_15)

	return var1_15
end

function var0_0.CreateSubPage(arg0_17, arg1_17, arg2_17)
	local var0_17 = _.detect(arg0_17.subPages, function(arg0_18)
		return arg0_18.__cname == arg2_17.__cname
	end)

	if var0_17 then
		table.removebyvalue(arg0_17.subPages, var0_17)
	end

	local var1_17 = var0_17 or arg2_17.New(arg0_17.scene, arg0_17.scene.pageContainer)

	table.insert(arg0_17.subPages, var1_17)

	return var1_17
end

function var0_0.ClosePrevScenePage(arg0_19, arg1_19)
	local var0_19 = arg0_19.stack[#arg0_19.stack]

	if var0_19 then
		local var1_19 = arg0_19:GetPage(var0_19.class)

		if var1_19 and var1_19:GetLoaded() and var1_19:isShowing() then
			var1_19:Disable(arg1_19)

			for iter0_19, iter1_19 in ipairs(var0_19:GetSubPages()) do
				local var2_19 = arg0_19:GetSubPage(iter1_19.class)

				if var2_19:GetLoaded() then
					var2_19:Disable()
				end
			end
		else
			arg1_19()
		end
	else
		arg1_19()
	end
end

function var0_0.CheckOverflowAndDestory(arg0_20, arg1_20)
	if #arg0_20.pages > arg0_20.capacity then
		local var0_20 = arg0_20:GetLongestNoUsePage(arg1_20)
		local var1_20 = arg0_20:GetContext(var0_20.class)

		if var1_20 then
			var1_20:DisabelDelRecordWhenClose()
		end

		arg0_20:DestroyPage(var0_20, nil, true)

		arg0_20.gcCnt = arg0_20.gcCnt + 1

		if arg0_20.gcCnt % 5 == 0 then
			gcAll(false)

			arg0_20.gcCnt = 0
		end
	end
end

function var0_0.GetLongestNoUsePage(arg0_21, arg1_21)
	local function var0_21(arg0_22)
		return arg0_21:GetContext(arg0_22.class) ~= nil
	end

	local var1_21 = 0

	for iter0_21, iter1_21 in ipairs(arg0_21.pages) do
		if arg1_21 ~= iter1_21 and not var0_21(iter1_21) then
			var1_21 = iter0_21

			break
		end
	end

	local var2_21 = math.max(var1_21, 1)

	return arg0_21.pages[var2_21]
end

function var0_0.ClosePage(arg0_23, arg1_23)
	if not (arg0_23:CheckAndCloseSubPage(arg1_23) or arg0_23:CheckAndCloseNoStatePage(arg1_23)) then
		arg0_23:CheckAndCloseScenePage(arg1_23)
	end

	arg0_23:Debug()
end

function var0_0.CheckAndCloseScenePage(arg0_24, arg1_24)
	local var0_24 = arg0_24:GetContext(arg1_24)

	if var0_24 then
		local var1_24 = arg0_24:GetPage(var0_24.class)

		if var1_24 and var1_24:GetLoaded() and var1_24:isShowing() then
			local var2_24 = var0_24:GetOpenPrevWhenClose()

			if var0_24:GetDelRecordWhenClose() then
				arg0_24:DelRecord(var0_24)
			end

			var1_24:Disable()

			for iter0_24, iter1_24 in ipairs(var0_24:GetSubPages()) do
				local var3_24 = arg0_24:GetSubPage(iter1_24.class)

				if var3_24:GetLoaded() then
					var3_24:Destroy()
					table.removebyvalue(arg0_24.subPages, var3_24)
				end
			end

			if var2_24 then
				arg0_24:OpenPrevScenePage()
			end
		end

		return var1_24 ~= nil
	end

	return false
end

function var0_0.OpenPrevScenePage(arg0_25)
	if arg0_25:IsDestroyed() then
		return
	end

	local var0_25 = arg0_25.stack[#arg0_25.stack]

	if var0_25 then
		local var1_25 = arg0_25:GetPage(var0_25.class)

		if var1_25 and var1_25:GetLoaded() and var1_25:isShowing() then
			arg0_25:Record(var0_25)
			var1_25:Enable()

			for iter0_25, iter1_25 in ipairs(var0_25:GetSubPages()) do
				if iter1_25.__visible then
					local var2_25 = arg0_25:GetSubPage(iter1_25.class)

					if var2_25:GetLoaded() then
						var2_25:Disable()
					end
				end
			end
		else
			arg0_25:DelRecord(var0_25)

			local var3_25 = arg0_25:OpenPage(arg0_25.scene, var0_25.class, unpackEx(var0_25:GetData()))

			for iter2_25, iter3_25 in ipairs(var0_25:GetSubPages()) do
				if iter3_25.__visible then
					arg0_25:OpenPage(var3_25, iter3_25.class, unpackEx(iter3_25:GetData()))
				end
			end
		end
	end
end

function var0_0.CheckAndCloseSubPage(arg0_26, arg1_26)
	local var0_26 = arg0_26:GetContext(arg1_26)

	if var0_26 then
		for iter0_26, iter1_26 in ipairs(var0_26:GetSubPages()) do
			if iter1_26.class.__cname == arg1_26.__cname then
				local var1_26 = arg0_26:GetSubPage(iter1_26.class)

				if var1_26:GetLoaded() then
					iter1_26.__visible = false

					var1_26:Disable()
				end

				return true
			end
		end
	end

	return false
end

function var0_0.CheckAndCloseNoStatePage(arg0_27, arg1_27)
	local var0_27 = arg0_27:GetContext(arg1_27)
	local var1_27 = false

	if var0_27 then
		local var2_27 = _.detect(arg0_27.noStatePages, function(arg0_28)
			return arg0_28.__cname == arg1_27.__cname
		end)

		if var2_27 then
			arg0_27:DelRecord(var0_27)
			arg0_27:DestroyPage(var2_27, var0_27)
			arg0_27:OpenPrevScenePage()

			var1_27 = true
		end
	end

	return var1_27
end

function var0_0.DestroyPage(arg0_29, arg1_29, arg2_29, arg3_29)
	arg2_29 = arg2_29 or arg0_29:GetContext(arg1_29.class)

	if arg2_29 then
		arg2_29:DisabelOpenPrevWhenClose()

		for iter0_29, iter1_29 in ipairs(arg2_29:GetSubPages()) do
			local var0_29 = arg0_29:GetSubPage(iter1_29.class)

			if var0_29:GetLoaded() then
				var0_29:Destroy()
				table.removebyvalue(arg0_29.subPages, arg1_29)
			end
		end
	end

	if arg1_29:GetLoaded() then
		arg1_29:Destroy(arg3_29)

		if arg1_29:NeedCache() then
			table.removebyvalue(arg0_29.pages, arg1_29)
		else
			table.removebyvalue(arg0_29.noStatePages, arg1_29)
		end
	end
end

function var0_0.Record(arg0_30, arg1_30, arg2_30)
	if arg0_30:IsDestroyed() then
		return
	end

	local var0_30 = _.detect(arg0_30.stack, function(arg0_31)
		return arg0_31.class == arg1_30.class
	end)

	if var0_30 then
		table.removebyvalue(arg0_30.stack, var0_30)
		table.insert(arg0_30.stack, arg1_30)

		return
	end

	table.insert(arg0_30.stack, arg1_30)

	if #arg0_30.stack == 1 then
		arg0_30:OnAnyPageOpen(arg1_30.class)
	end
end

function var0_0.DelRecord(arg0_32, arg1_32)
	if arg0_32:IsDestroyed() then
		return
	end

	table.removebyvalue(arg0_32.stack, arg1_32)

	if #arg0_32.stack == 0 then
		arg0_32:OnAllPageClose()
	end
end

function var0_0.OnAnyPageOpen(arg0_33, arg1_33)
	arg0_33.scene:emitCore(ISLAND_EVT.ANY_PAGE_OPENED, arg1_33)
	arg0_33.scene:TryDisVisible()
end

function var0_0.OnAllPageClose(arg0_34)
	arg0_34.scene:emitCore(ISLAND_EVT.ALL_PAGE_CLOSED)
	arg0_34.scene:TryVisible()
end

function var0_0.IsAllPageClose(arg0_35)
	return #arg0_35.stack == 0
end

function var0_0.IsSceneType(arg0_36, arg1_36)
	return arg1_36.__cname == arg0_36.scene.__cname
end

function var0_0.OnBackPressed(arg0_37)
	local var0_37 = arg0_37.stack[#arg0_37.stack]

	if var0_37 then
		local var1_37 = arg0_37:GetPage(var0_37.class)

		if var1_37 and var1_37:CanEsc() then
			var1_37:Hide()
		end

		return true
	end

	return false
end

function var0_0.IsDestroyed(arg0_38)
	return arg0_38.state == var3_0
end

function var0_0.Dispose(arg0_39)
	arg0_39.state = var3_0

	for iter0_39 = #arg0_39.pages, 1, -1 do
		local var0_39 = arg0_39.pages[iter0_39]

		var0_39:ActiveOrDisactive(false)
		arg0_39:DestroyPage(var0_39)
	end

	for iter1_39 = #arg0_39.noStatePages, 1, -1 do
		local var1_39 = arg0_39.noStatePages[iter1_39]

		var1_39:ActiveOrDisactive(false)
		arg0_39:DestroyPage(var1_39)
	end

	arg0_39.stack = nil
	arg0_39.noStatePages = nil
	arg0_39.pages = nil
	arg0_39.subPages = nil
end

function var0_0.Debug(arg0_40)
	if not var1_0 then
		return
	end

	local function var0_40(arg0_41)
		local var0_41 = _.map(arg0_41:GetSubPages(), function(arg0_42)
			return arg0_42.class.__cname
		end)

		return table.concat(var0_41, ",")
	end

	local var1_40 = _.map(arg0_40.stack, function(arg0_43)
		return arg0_43.class.__cname .. ":[" .. var0_40(arg0_43) .. "]"
	end)
	local var2_40 = table.concat(var1_40, "\n")

	print("\n" .. var2_40)
end

return var0_0
