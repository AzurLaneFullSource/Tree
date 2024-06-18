local var0_0 = class("FireworkPanel2024Layer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "FireworkPanelUI"
end

function var0_0.init(arg0_2)
	arg0_2.leftPanel = arg0_2:findTF("main/left_panel")
	arg0_2.rightPanel = arg0_2:findTF("main/right_panel")
	arg0_2.fireBtn = arg0_2:findTF("fire_btn", arg0_2.rightPanel)

	setText(arg0_2:findTF("tip", arg0_2.rightPanel), i18n("activity_yanhua_tip7"))

	arg0_2.leftItem = arg0_2:findTF("scrollrect/content/item_tpl", arg0_2.leftPanel)
	arg0_2.leftItems = arg0_2:findTF("scrollrect/content", arg0_2.leftPanel)
	arg0_2.leftUIList = UIItemList.New(arg0_2.leftItems, arg0_2.leftItem)
	arg0_2.rightItem = arg0_2:findTF("content/item_tpl", arg0_2.rightPanel)
	arg0_2.rightItems = arg0_2:findTF("content", arg0_2.rightPanel)
	arg0_2.rightUIList = UIItemList.New(arg0_2.rightItems, arg0_2.rightItem)
	arg0_2.arrowsTF = arg0_2:findTF("arrows", arg0_2.rightPanel)

	arg0_2:initData()
end

function var0_0.initData(arg0_3)
	local var0_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FIREWORK)

	assert(var0_3 and not var0_3:isEnd(), "烟花活动(type92)已结束")

	arg0_3.unlockCount = var0_3:getData1()
	arg0_3.unlockIds = var0_3:getData1List()
	arg0_3.allIds = pg.activity_template[var0_3.id].config_data[3]
	arg0_3.actId = var0_3.id
	arg0_3.playerId = getProxy(PlayerProxy):getData().id
	arg0_3.orderIds = arg0_3:getLocalData()
end

function var0_0.getLocalData(arg0_4)
	local var0_4 = {}

	for iter0_4 = 1, #arg0_4.allIds do
		local var1_4 = PlayerPrefs.GetInt("fireworks_" .. arg0_4.actId .. "_" .. arg0_4.playerId .. "_pos_" .. iter0_4)

		if var1_4 ~= 0 then
			table.insert(var0_4, var1_4)
		end
	end

	return var0_4
end

function var0_0.setLocalData(arg0_5)
	for iter0_5 = 1, #arg0_5.allIds do
		local var0_5 = arg0_5.orderIds[iter0_5] or 0

		PlayerPrefs.SetInt("fireworks_" .. arg0_5.actId .. "_" .. arg0_5.playerId .. "_pos_" .. iter0_5, var0_5)
	end
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6:findTF("main/mask"), function()
		arg0_6:emit(var0_0.ON_CLOSE)
	end)
	onButton(arg0_6, arg0_6:findTF("close_btn", arg0_6.rightPanel), function()
		arg0_6:emit(var0_0.ON_CLOSE)
	end)
	onButton(arg0_6, arg0_6.fireBtn, function()
		arg0_6:emit(var0_0.ON_CLOSE)
	end)
	arg0_6:initLeft()
	arg0_6:initRight()
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
end

function var0_0.initLeft(arg0_10)
	setActive(arg0_10:findTF("empty", arg0_10.leftPanel), #arg0_10.unlockIds == 0)
	setActive(arg0_10:findTF("scrollrect", arg0_10.leftPanel), #arg0_10.unlockIds > 0)
	arg0_10.leftUIList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = arg1_11 + 1
			local var1_11 = "lock"

			if var0_11 <= #arg0_10.unlockIds then
				var1_11 = tostring(arg0_10.unlockIds[var0_11])
			end

			arg2_11.name = var1_11

			if var1_11 == "lock" then
				setActive(arg0_10:findTF("firework", arg2_11), false)
			else
				local var2_11 = tonumber(arg2_11.name)
				local var3_11 = arg0_10:findTF("firework/icon", arg2_11)
				local var4_11 = arg0_10:findTF("firework/selected", arg2_11)

				setActive(arg0_10:findTF("firework", arg2_11), true)

				local var5_11 = table.contains(arg0_10.orderIds, var2_11)

				setActive(var4_11, var5_11)
				GetImageSpriteFromAtlasAsync(Item.getConfigData(var2_11).icon, "", var3_11)
				onButton(arg0_10, arg2_11, function()
					arg0_10:onLeftClick(var2_11, var5_11)
				end, SFX_PANEL)
			end
		end
	end)
	arg0_10.leftUIList:align(#arg0_10.allIds)
end

function var0_0.initRight(arg0_13)
	for iter0_13 = 1, #arg0_13.allIds - 2 do
		cloneTplTo(arg0_13:findTF("tpl", arg0_13.arrowsTF), arg0_13.arrowsTF)
	end

	arg0_13.rightUIList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg1_14 + 1
			local var1_14 = "null"

			if var0_14 <= #arg0_13.orderIds then
				var1_14 = tostring(arg0_13.orderIds[var0_14])
			end

			arg2_14.name = var1_14

			local var2_14 = arg0_13:findTF("icon", arg2_14)

			setActive(arg0_13:findTF("add", arg2_14), var1_14 == "null")

			if var1_14 == "null" then
				setActive(var2_14, false)
			else
				local var3_14 = tonumber(arg2_14.name)

				setActive(var2_14, true)
				GetImageSpriteFromAtlasAsync(Item.getConfigData(var3_14).icon, "", var2_14)
				onButton(arg0_13, var2_14, function()
					arg0_13:onRightClick(var3_14)
				end, SFX_PANEL)
			end
		end
	end)
	arg0_13.rightUIList:align(#arg0_13.allIds)
end

function var0_0.onLeftClick(arg0_16, arg1_16, arg2_16)
	if arg2_16 then
		table.removebyvalue(arg0_16.orderIds, arg1_16)
	else
		table.insert(arg0_16.orderIds, arg1_16)
	end

	arg0_16:setLocalData()
	arg0_16.leftUIList:align(#arg0_16.allIds)
	arg0_16.rightUIList:align(#arg0_16.allIds)
end

function var0_0.onRightClick(arg0_17, arg1_17)
	table.removebyvalue(arg0_17.orderIds, arg1_17)
	arg0_17:setLocalData()
	arg0_17.leftUIList:align(#arg0_17.allIds)
	arg0_17.rightUIList:align(#arg0_17.allIds)
end

function var0_0.willExit(arg0_18)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_18._tf)

	if arg0_18.contextData.onExit then
		arg0_18.contextData.onExit()
	end
end

return var0_0
