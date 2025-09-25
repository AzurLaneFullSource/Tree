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

		arg0_2:CheckOverflowAndDestory()
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

function var0_0.CheckOverflowAndDestory(arg0_20)
	if #arg0_20.pages > arg0_20.capacity then
		local var0_20 = arg0_20.pages[1]
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

function var0_0.ClosePage(arg0_21, arg1_21)
	if not (arg0_21:CheckAndCloseSubPage(arg1_21) or arg0_21:CheckAndCloseNoStatePage(arg1_21)) then
		arg0_21:CheckAndCloseScenePage(arg1_21)
	end

	arg0_21:Debug()
end

function var0_0.CheckAndCloseScenePage(arg0_22, arg1_22)
	local var0_22 = arg0_22:GetContext(arg1_22)

	if var0_22 then
		local var1_22 = arg0_22:GetPage(var0_22.class)

		if var1_22 and var1_22:GetLoaded() and var1_22:isShowing() then
			local var2_22 = var0_22:GetOpenPrevWhenClose()

			if var0_22:GetDelRecordWhenClose() then
				arg0_22:DelRecord(var0_22)
			end

			var1_22:Disable()

			for iter0_22, iter1_22 in ipairs(var0_22:GetSubPages()) do
				local var3_22 = arg0_22:GetSubPage(iter1_22.class)

				if var3_22:GetLoaded() then
					var3_22:Destroy()
					table.removebyvalue(arg0_22.subPages, var3_22)
				end
			end

			if var2_22 then
				arg0_22:OpenPrevScenePage()
			end
		end

		return var1_22 ~= nil
	end

	return false
end

function var0_0.OpenPrevScenePage(arg0_23)
	if arg0_23:IsDestroyed() then
		return
	end

	local var0_23 = arg0_23.stack[#arg0_23.stack]

	if var0_23 then
		local var1_23 = arg0_23:GetPage(var0_23.class)

		if var1_23 and var1_23:GetLoaded() and var1_23:isShowing() then
			var1_23:Enable()

			for iter0_23, iter1_23 in ipairs(var0_23:GetSubPages()) do
				if iter1_23.__visible then
					local var2_23 = arg0_23:GetSubPage(iter1_23.class)

					if var2_23:GetLoaded() then
						var2_23:Disable()
					end
				end
			end
		else
			arg0_23:DelRecord(var0_23)

			local var3_23 = arg0_23:OpenPage(arg0_23.scene, var0_23.class, unpackEx(var0_23:GetData()))

			for iter2_23, iter3_23 in ipairs(var0_23:GetSubPages()) do
				if iter3_23.__visible then
					arg0_23:OpenPage(var3_23, iter3_23.class, unpackEx(iter3_23:GetData()))
				end
			end
		end
	end
end

function var0_0.CheckAndCloseSubPage(arg0_24, arg1_24)
	local var0_24 = arg0_24:GetContext(arg1_24)

	if var0_24 then
		for iter0_24, iter1_24 in ipairs(var0_24:GetSubPages()) do
			if iter1_24.class.__cname == arg1_24.__cname then
				local var1_24 = arg0_24:GetSubPage(iter1_24.class)

				if var1_24:GetLoaded() then
					iter1_24.__visible = false

					var1_24:Disable()
				end

				return true
			end
		end
	end

	return false
end

function var0_0.CheckAndCloseNoStatePage(arg0_25, arg1_25)
	local var0_25 = arg0_25:GetContext(arg1_25)
	local var1_25 = false

	if var0_25 then
		local var2_25 = _.detect(arg0_25.noStatePages, function(arg0_26)
			return arg0_26.__cname == arg1_25.__cname
		end)

		if var2_25 then
			arg0_25:DelRecord(var0_25)
			arg0_25:DestroyPage(var2_25, var0_25)
			arg0_25:OpenPrevScenePage()

			var1_25 = true
		end
	end

	return var1_25
end

function var0_0.DestroyPage(arg0_27, arg1_27, arg2_27, arg3_27)
	arg2_27 = arg2_27 or arg0_27:GetContext(arg1_27.class)

	if arg2_27 then
		arg2_27:DisabelOpenPrevWhenClose()

		for iter0_27, iter1_27 in ipairs(arg2_27:GetSubPages()) do
			local var0_27 = arg0_27:GetSubPage(iter1_27.class)

			if var0_27:GetLoaded() then
				var0_27:Destroy()
				table.removebyvalue(arg0_27.subPages, arg1_27)
			end
		end
	end

	if arg1_27:GetLoaded() then
		arg1_27:Destroy(arg3_27)

		if arg1_27:NeedCache() then
			table.removebyvalue(arg0_27.pages, arg1_27)
		else
			table.removebyvalue(arg0_27.noStatePages, arg1_27)
		end
	end
end

function var0_0.Record(arg0_28, arg1_28, arg2_28)
	if arg0_28:IsDestroyed() then
		return
	end

	if _.any(arg0_28.stack, function(arg0_29)
		return arg0_29.class == arg1_28.class
	end) then
		return
	end

	table.insert(arg0_28.stack, arg1_28)

	if #arg0_28.stack == 1 then
		arg0_28:OnAnyPageOpen(arg1_28.class)
	end
end

function var0_0.DelRecord(arg0_30, arg1_30)
	if arg0_30:IsDestroyed() then
		return
	end

	table.removebyvalue(arg0_30.stack, arg1_30)

	if #arg0_30.stack == 0 then
		arg0_30:OnAllPageClose()
	end
end

function var0_0.OnAnyPageOpen(arg0_31, arg1_31)
	arg0_31.scene:emitCore(ISLAND_EVT.ANY_PAGE_OPENED, arg1_31)
	arg0_31.scene:TryDisVisible()
end

function var0_0.OnAllPageClose(arg0_32)
	arg0_32.scene:emitCore(ISLAND_EVT.ALL_PAGE_CLOSED)
	arg0_32.scene:TryVisible()
end

function var0_0.IsSceneType(arg0_33, arg1_33)
	return arg1_33.__cname == arg0_33.scene.__cname
end

function var0_0.OnBackPressed(arg0_34)
	for iter0_34 = #arg0_34.noStatePages, 1, -1 do
		local var0_34 = arg0_34.noStatePages[iter0_34]

		arg0_34:ClosePage(var0_34.class)

		return true
	end

	for iter1_34 = #arg0_34.pages, 1, -1 do
		local var1_34 = arg0_34.pages[iter1_34]

		arg0_34:ClosePage(var1_34.class)

		return true
	end

	return false
end

function var0_0.IsDestroyed(arg0_35)
	return arg0_35.state == var3_0
end

function var0_0.Dispose(arg0_36)
	arg0_36.state = var3_0

	for iter0_36 = #arg0_36.pages, 1, -1 do
		local var0_36 = arg0_36.pages[iter0_36]

		arg0_36:DestroyPage(var0_36)
	end

	for iter1_36 = #arg0_36.noStatePages, 1, -1 do
		local var1_36 = arg0_36.noStatePages[iter1_36]

		arg0_36:DestroyPage(var1_36)
	end

	arg0_36.stack = nil
	arg0_36.noStatePages = nil
	arg0_36.pages = nil
	arg0_36.subPages = nil
end

function var0_0.Debug(arg0_37)
	if not var1_0 then
		return
	end

	local function var0_37(arg0_38)
		local var0_38 = _.map(arg0_38:GetSubPages(), function(arg0_39)
			return arg0_39.class.__cname
		end)

		return table.concat(var0_38, ",")
	end

	local var1_37 = _.map(arg0_37.stack, function(arg0_40)
		return arg0_40.class.__cname .. ":[" .. var0_37(arg0_40) .. "]"
	end)
	local var2_37 = table.concat(var1_37, "\n")

	print("\n" .. var2_37)
end

return var0_0
