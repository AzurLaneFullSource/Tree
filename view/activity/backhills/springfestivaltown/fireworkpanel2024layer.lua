local var0 = class("FireworkPanel2024Layer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "FireworkPanelUI"
end

function var0.init(arg0)
	arg0.leftPanel = arg0:findTF("main/left_panel")
	arg0.rightPanel = arg0:findTF("main/right_panel")
	arg0.fireBtn = arg0:findTF("fire_btn", arg0.rightPanel)

	setText(arg0:findTF("tip", arg0.rightPanel), i18n("activity_yanhua_tip7"))

	arg0.leftItem = arg0:findTF("scrollrect/content/item_tpl", arg0.leftPanel)
	arg0.leftItems = arg0:findTF("scrollrect/content", arg0.leftPanel)
	arg0.leftUIList = UIItemList.New(arg0.leftItems, arg0.leftItem)
	arg0.rightItem = arg0:findTF("content/item_tpl", arg0.rightPanel)
	arg0.rightItems = arg0:findTF("content", arg0.rightPanel)
	arg0.rightUIList = UIItemList.New(arg0.rightItems, arg0.rightItem)
	arg0.arrowsTF = arg0:findTF("arrows", arg0.rightPanel)

	arg0:initData()
end

function var0.initData(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

	assert(var0 and not var0:isEnd(), "烟花活动(type92)已结束")

	arg0.unlockCount = var0:getData1()
	arg0.unlockIds = var0:getData1List()
	arg0.allIds = pg.activity_template[var0.id].config_data[3]
	arg0.actId = var0.id
	arg0.playerId = getProxy(PlayerProxy):getData().id
	arg0.orderIds = arg0:getLocalData()
end

function var0.getLocalData(arg0)
	local var0 = {}

	for iter0 = 1, #arg0.allIds do
		local var1 = PlayerPrefs.GetInt("fireworks_" .. arg0.actId .. "_" .. arg0.playerId .. "_pos_" .. iter0)

		if var1 ~= 0 then
			table.insert(var0, var1)
		end
	end

	return var0
end

function var0.setLocalData(arg0)
	for iter0 = 1, #arg0.allIds do
		local var0 = arg0.orderIds[iter0] or 0

		PlayerPrefs.SetInt("fireworks_" .. arg0.actId .. "_" .. arg0.playerId .. "_pos_" .. iter0, var0)
	end
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("main/mask"), function()
		arg0:emit(var0.ON_CLOSE)
	end)
	onButton(arg0, arg0:findTF("close_btn", arg0.rightPanel), function()
		arg0:emit(var0.ON_CLOSE)
	end)
	onButton(arg0, arg0.fireBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end)
	arg0:initLeft()
	arg0:initRight()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.initLeft(arg0)
	setActive(arg0:findTF("empty", arg0.leftPanel), #arg0.unlockIds == 0)
	setActive(arg0:findTF("scrollrect", arg0.leftPanel), #arg0.unlockIds > 0)
	arg0.leftUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = "lock"

			if var0 <= #arg0.unlockIds then
				var1 = tostring(arg0.unlockIds[var0])
			end

			arg2.name = var1

			if var1 == "lock" then
				setActive(arg0:findTF("firework", arg2), false)
			else
				local var2 = tonumber(arg2.name)
				local var3 = arg0:findTF("firework/icon", arg2)
				local var4 = arg0:findTF("firework/selected", arg2)

				setActive(arg0:findTF("firework", arg2), true)

				local var5 = table.contains(arg0.orderIds, var2)

				setActive(var4, var5)
				GetImageSpriteFromAtlasAsync(Item.getConfigData(var2).icon, "", var3)
				onButton(arg0, arg2, function()
					arg0:onLeftClick(var2, var5)
				end, SFX_PANEL)
			end
		end
	end)
	arg0.leftUIList:align(#arg0.allIds)
end

function var0.initRight(arg0)
	for iter0 = 1, #arg0.allIds - 2 do
		cloneTplTo(arg0:findTF("tpl", arg0.arrowsTF), arg0.arrowsTF)
	end

	arg0.rightUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = "null"

			if var0 <= #arg0.orderIds then
				var1 = tostring(arg0.orderIds[var0])
			end

			arg2.name = var1

			local var2 = arg0:findTF("icon", arg2)

			setActive(arg0:findTF("add", arg2), var1 == "null")

			if var1 == "null" then
				setActive(var2, false)
			else
				local var3 = tonumber(arg2.name)

				setActive(var2, true)
				GetImageSpriteFromAtlasAsync(Item.getConfigData(var3).icon, "", var2)
				onButton(arg0, var2, function()
					arg0:onRightClick(var3)
				end, SFX_PANEL)
			end
		end
	end)
	arg0.rightUIList:align(#arg0.allIds)
end

function var0.onLeftClick(arg0, arg1, arg2)
	if arg2 then
		table.removebyvalue(arg0.orderIds, arg1)
	else
		table.insert(arg0.orderIds, arg1)
	end

	arg0:setLocalData()
	arg0.leftUIList:align(#arg0.allIds)
	arg0.rightUIList:align(#arg0.allIds)
end

function var0.onRightClick(arg0, arg1)
	table.removebyvalue(arg0.orderIds, arg1)
	arg0:setLocalData()
	arg0.leftUIList:align(#arg0.allIds)
	arg0.rightUIList:align(#arg0.allIds)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.contextData.onExit then
		arg0.contextData.onExit()
	end
end

return var0
