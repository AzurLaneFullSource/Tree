local var0_0 = class("IslandSceneMgr")
local var1_0 = false
local var2_0 = 1
local var3_0 = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.scene = arg1_1
	arg0_1.capacity = 3
	arg0_1.stack = {}
	arg0_1.noStatePages = {}
	arg0_1.pages = {}
	arg0_1.subPages = {}
	arg0_1.state = var2_0
	arg0_1.gcCnt = 0
end

function var0_0.OpenPage(arg0_2, arg1_2, arg2_2, ...)
	local var0_2

	if arg0_2:IsSceneType(arg1_2) then
		arg0_2:ClosePrevScenePage()

		var0_2 = arg0_2:CreateScenePage(arg2_2)

		arg0_2:CheckOverflowAndDestory()
		arg0_2:Record(IslandSceneContext.New(arg2_2, ...), true)
	else
		var0_2 = arg0_2:CreateSubPage(arg1_2, arg2_2)

		local var1_2 = arg0_2:GetContext(arg1_2)

		assert(var1_2, arg1_2.__cname)
		var1_2:AddSubPage(arg2_2, ...)
	end

	arg0_2:StartPage(var0_2, ...)
	arg0_2:Debug()

	return var0_2
end

function var0_0.GetContext(arg0_3, arg1_3)
	return (_.detect(arg0_3.stack, function(arg0_4)
		return arg0_4.class.__cname == arg1_3.__cname or #arg0_4:GetSubPages() > 0 and _.any(arg0_4:GetSubPages(), function(arg0_5)
			return arg0_5.class.__cname == arg1_3.__cname
		end)
	end))
end

function var0_0.GetPage(arg0_6, arg1_6)
	return _.detect(arg0_6.pages, function(arg0_7)
		return arg0_7.__cname == arg1_6.__cname
	end) or _.detect(arg0_6.noStatePages, function(arg0_8)
		return arg0_8.__cname == arg1_6.__cname
	end)
end

function var0_0.GetSubPage(arg0_9, arg1_9)
	return (_.detect(arg0_9.subPages, function(arg0_10)
		return arg0_10.__cname == arg1_9.__cname
	end))
end

function var0_0.StartPage(arg0_11, arg1_11, ...)
	local var0_11 = packEx(...)

	seriesAsync({
		function(arg0_12)
			arg1_11:Preload(arg0_12, unpackEx(var0_11))
		end
	}, function()
		arg1_11:ExecuteAction("Show", unpackEx(var0_11))
	end)
end

function var0_0.CreateScenePage(arg0_14, arg1_14)
	local var0_14 = _.detect(arg0_14.pages, function(arg0_15)
		return arg0_15.__cname == arg1_14.__cname
	end)

	if var0_14 then
		table.removebyvalue(arg0_14.pages, var0_14)
	end

	local var1_14 = var0_14 or arg1_14.New(arg0_14.scene, arg0_14.scene.uiContainer)
	local var2_14 = var1_14:NeedCache() and arg0_14.pages or arg0_14.noStatePages

	table.insert(var2_14, var1_14)

	return var1_14
end

function var0_0.CreateSubPage(arg0_16, arg1_16, arg2_16)
	local var0_16 = _.detect(arg0_16.subPages, function(arg0_17)
		return arg0_17.__cname == arg2_16.__cname
	end)

	if var0_16 then
		table.removebyvalue(arg0_16.subPages, var0_16)
	end

	local var1_16 = var0_16 or arg2_16.New(arg0_16.scene, arg0_16.scene.pageContainer)

	table.insert(arg0_16.subPages, var1_16)

	return var1_16
end

function var0_0.ClosePrevScenePage(arg0_18)
	local var0_18 = arg0_18.stack[#arg0_18.stack]

	if var0_18 then
		local var1_18 = arg0_18:GetPage(var0_18.class)

		if var1_18 and var1_18:GetLoaded() and var1_18:isShowing() then
			var1_18:Disable()

			for iter0_18, iter1_18 in ipairs(var0_18:GetSubPages()) do
				local var2_18 = arg0_18:GetSubPage(iter1_18.class)

				if var2_18:GetLoaded() then
					var2_18:Disable()
				end
			end
		end
	end
end

function var0_0.CheckOverflowAndDestory(arg0_19)
	if #arg0_19.pages > arg0_19.capacity then
		local var0_19 = arg0_19.pages[1]

		arg0_19:DestroyPage(var0_19)

		arg0_19.gcCnt = arg0_19.gcCnt + 1

		if arg0_19.gcCnt % 3 == 0 then
			gcAll(false)

			arg0_19.gcCnt = 0
		end
	end
end

function var0_0.ClosePage(arg0_20, arg1_20)
	if not (arg0_20:CheckAndCloseSubPage(arg1_20) or arg0_20:CheckAndCloseNoStatePage(arg1_20)) then
		arg0_20:CheckAndCloseScenePage(arg1_20)
	end

	arg0_20:Debug()
end

function var0_0.CheckAndCloseScenePage(arg0_21, arg1_21)
	local var0_21 = arg0_21:GetContext(arg1_21)

	if var0_21 then
		local var1_21 = arg0_21:GetPage(var0_21.class)

		if var1_21 and var1_21:GetLoaded() and var1_21:isShowing() then
			arg0_21:DelRecord(var0_21)
			var1_21:Disable()

			for iter0_21, iter1_21 in ipairs(var0_21:GetSubPages()) do
				local var2_21 = arg0_21:GetSubPage(iter1_21.class)

				if var2_21:GetLoaded() then
					var2_21:Destroy()
					table.removebyvalue(arg0_21.subPages, var2_21)
				end
			end

			arg0_21:OpenPrevScenePage()
		end

		return var1_21 ~= nil
	end

	return false
end

function var0_0.OpenPrevScenePage(arg0_22)
	if arg0_22:IsDestroyed() then
		return
	end

	local var0_22 = arg0_22.stack[#arg0_22.stack]

	if var0_22 then
		local var1_22 = arg0_22:GetPage(var0_22.class)

		if var1_22 and var1_22:GetLoaded() and var1_22:isShowing() then
			var1_22:Enable()

			for iter0_22, iter1_22 in ipairs(var0_22:GetSubPages()) do
				if iter1_22.__visible then
					local var2_22 = arg0_22:GetSubPage(iter1_22.class)

					if var2_22:GetLoaded() then
						var2_22:Disable()
					end
				end
			end
		else
			arg0_22:DelRecord(var0_22)

			local var3_22 = arg0_22:OpenPage(arg0_22.scene, var0_22.class, unpackEx(var0_22:GetData()))

			for iter2_22, iter3_22 in ipairs(var0_22:GetSubPages()) do
				if iter3_22.__visible then
					arg0_22:OpenPage(var3_22, iter3_22.class, unpackEx(iter3_22:GetData()))
				end
			end
		end
	end
end

function var0_0.CheckAndCloseSubPage(arg0_23, arg1_23)
	local var0_23 = arg0_23:GetContext(arg1_23)

	if var0_23 then
		for iter0_23, iter1_23 in ipairs(var0_23:GetSubPages()) do
			if iter1_23.class.__cname == arg1_23.__cname then
				local var1_23 = arg0_23:GetSubPage(iter1_23.class)

				if var1_23:GetLoaded() then
					iter1_23.__visible = false

					var1_23:Disable()
				end

				return true
			end
		end
	end

	return false
end

function var0_0.CheckAndCloseNoStatePage(arg0_24, arg1_24)
	local var0_24 = arg0_24:GetContext(arg1_24)
	local var1_24 = false

	if var0_24 then
		local var2_24 = _.detect(arg0_24.noStatePages, function(arg0_25)
			return arg0_25.__cname == arg1_24.__cname
		end)

		if var2_24 then
			arg0_24:DelRecord(var0_24)
			arg0_24:DestroyPage(var2_24, var0_24)
			arg0_24:OpenPrevScenePage()

			var1_24 = true
		end
	end

	return var1_24
end

function var0_0.DestroyPage(arg0_26, arg1_26, arg2_26)
	arg2_26 = arg2_26 or arg0_26:GetContext(arg1_26.class)

	if arg2_26 then
		for iter0_26, iter1_26 in ipairs(arg2_26:GetSubPages()) do
			local var0_26 = arg0_26:GetSubPage(iter1_26.class)

			if var0_26:GetLoaded() then
				var0_26:Destroy()
				table.removebyvalue(arg0_26.subPages, arg1_26)
			end
		end
	end

	if arg1_26:GetLoaded() then
		arg1_26:Destroy()

		if arg1_26:NeedCache() then
			table.removebyvalue(arg0_26.pages, arg1_26)
		else
			table.removebyvalue(arg0_26.noStatePages, arg1_26)
		end
	end
end

function var0_0.Record(arg0_27, arg1_27, arg2_27)
	if arg0_27:IsDestroyed() then
		return
	end

	if _.any(arg0_27.stack, function(arg0_28)
		return arg0_28.class == arg1_27.class
	end) then
		return
	end

	table.insert(arg0_27.stack, arg1_27)

	if #arg0_27.stack == 1 then
		arg0_27:OnAnyPageOpen(arg1_27.class)
	end
end

function var0_0.DelRecord(arg0_29, arg1_29)
	if arg0_29:IsDestroyed() then
		return
	end

	table.removebyvalue(arg0_29.stack, arg1_29)

	if #arg0_29.stack == 0 then
		arg0_29:OnAllPageClose()
	end
end

function var0_0.OnAnyPageOpen(arg0_30, arg1_30)
	arg0_30.scene:emitCore(ISLAND_EVT.ANY_PAGE_OPENED, arg1_30)
	arg0_30.scene:TryDisVisible()
end

function var0_0.OnAllPageClose(arg0_31)
	arg0_31.scene:emitCore(ISLAND_EVT.ALL_PAGE_CLOSED)
	arg0_31.scene:TryVisible()
end

function var0_0.IsSceneType(arg0_32, arg1_32)
	return arg1_32.__cname == arg0_32.scene.__cname
end

function var0_0.OnBackPressed(arg0_33)
	for iter0_33 = #arg0_33.noStatePages, 1, -1 do
		local var0_33 = arg0_33.noStatePages[iter0_33]

		arg0_33:ClosePage(var0_33.class)

		return true
	end

	for iter1_33 = #arg0_33.pages, 1, -1 do
		local var1_33 = arg0_33.pages[iter1_33]

		arg0_33:ClosePage(var1_33.class)

		return true
	end

	return false
end

function var0_0.IsDestroyed(arg0_34)
	return arg0_34.state == var3_0
end

function var0_0.Dispose(arg0_35)
	arg0_35.state = var3_0

	for iter0_35 = #arg0_35.pages, 1, -1 do
		local var0_35 = arg0_35.pages[iter0_35]

		arg0_35:DestroyPage(var0_35)
	end

	for iter1_35 = #arg0_35.noStatePages, 1, -1 do
		local var1_35 = arg0_35.noStatePages[iter1_35]

		arg0_35:DestroyPage(var1_35)
	end

	arg0_35.stack = nil
	arg0_35.noStatePages = nil
	arg0_35.pages = nil
	arg0_35.subPages = nil
end

function var0_0.Debug(arg0_36)
	if not var1_0 then
		return
	end

	local function var0_36(arg0_37)
		local var0_37 = _.map(arg0_37:GetSubPages(), function(arg0_38)
			return arg0_38.class.__cname
		end)

		return table.concat(var0_37, ",")
	end

	local var1_36 = _.map(arg0_36.stack, function(arg0_39)
		return arg0_39.class.__cname .. ":[" .. var0_36(arg0_39) .. "]"
	end)
	local var2_36 = table.concat(var1_36, "\n")

	print("\n" .. var2_36)
end

return var0_0
