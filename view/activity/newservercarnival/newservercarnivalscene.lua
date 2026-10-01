local var0_0 = class("NewServerCarnivalScene", import("...base.BaseUI"))

var0_0.TASK_PAGE = 1
var0_0.SHOP_PAGE = 2
var0_0.GIFT_PAGE = 3

function var0_0.getUIName(arg0_1)
	return "NewServerCarnivalUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/newservershopui_atlas",
		"ui/iconcolorful",
		"weaponframes",
		"chargeicon/1"
	}
	local var1_2 = {}

	local function var2_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var1_2, arg0_3) then
			table.insert(var1_2, arg0_3)
		end
	end

	local var3_2 = pg.newserver_shop_template

	if var3_2 then
		for iter0_2, iter1_2 in ipairs(var3_2.all or {}) do
			local var4_2 = var3_2[iter1_2]

			if var4_2 then
				var2_2(var4_2.goods_icon)

				if var4_2.resource_category and var4_2.resource_type then
					var2_2(Drop.New({
						type = var4_2.resource_category,
						id = var4_2.resource_type
					}):getIcon())
				end

				var2_2("chargeicon/" .. (var4_2.picture or ""))
			end
		end
	end

	for iter2_2, iter3_2 in ipairs(var1_2) do
		if not table.contains(var0_2, iter3_2) then
			table.insert(var0_2, iter3_2)
		end
	end

	table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))

	return var0_2
end

function var0_0.preload(arg0_4, arg1_4)
	local var0_4 = {}

	table.insert(var0_4, function(arg0_5)
		pg.m02:sendNotification(GAME.GET_NEW_SERVER_SHOP, {
			callback = function(arg0_6)
				arg0_4:SetNewServerShop(arg0_6)
				arg0_5()
			end
		})
	end)
	parallelAsync(var0_4, arg1_4)
end

function var0_0.SetNewServerShop(arg0_7, arg1_7)
	arg0_7.newServerShop = arg1_7
end

function var0_0.setData(arg0_8)
	local var0_8 = getProxy(ActivityProxy)
	local var1_8 = var0_8:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)
	local var2_8 = var0_8:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP)
	local var3_8 = var0_8:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_GIFT)

	if var1_8 and not var1_8:isEnd() then
		arg0_8.taskActivity = var1_8
	else
		arg0_8.taskActivity = nil
	end

	if var2_8 and not var2_8:isEnd() then
		arg0_8.shopActivity = var2_8
	else
		arg0_8.shopActivity = nil
	end

	if var3_8 and not var3_8:isEnd() then
		arg0_8.giftActivity = var3_8
	else
		arg0_8.giftActivity = nil
	end

	arg0_8.player = getProxy(PlayerProxy):getData()
end

function var0_0.init(arg0_9)
	arg0_9.blurPanel = arg0_9._tf:Find("blur_panel")
	arg0_9.top = arg0_9.blurPanel:Find("adapt/top")
	arg0_9.resPanel = arg0_9.top:Find("res")
	arg0_9.backBtn = arg0_9.top:Find("back_btn")
	arg0_9.helpBtn = arg0_9.top:Find("help_btn")
	arg0_9.leftPanel = arg0_9._tf:Find("left")
	arg0_9.timeTF = arg0_9.leftPanel:Find("time")
	arg0_9.toggles = {
		arg0_9.leftPanel:Find("frame/toggle_group/task"),
		arg0_9.leftPanel:Find("frame/toggle_group/shop"),
		arg0_9.leftPanel:Find("frame/toggle_group/gift")
	}
	arg0_9.main = arg0_9._tf:Find("main")
	arg0_9.pages = {
		arg0_9.main:Find("task_container"),
		arg0_9.main:Find("shop_container"),
		arg0_9.main:Find("gift_container")
	}
	arg0_9.newServerTaskPage = NewServerTaskPage.New(arg0_9.pages[var0_0.TASK_PAGE], arg0_9.event, arg0_9.contextData)
	arg0_9.newServerShopPage = NewServerShopPage.New(arg0_9.pages[var0_0.SHOP_PAGE], arg0_9.event, arg0_9.contextData)

	arg0_9.newServerShopPage:SetShop(arg0_9.newServerShop)

	arg0_9.newServerGiftPage = NewServerGiftPage.New(arg0_9.pages[var0_0.GIFT_PAGE], arg0_9.event, arg0_9.contextData)
	arg0_9.pageDic = {
		[var0_0.TASK_PAGE] = arg0_9.newServerTaskPage,
		[var0_0.SHOP_PAGE] = arg0_9.newServerShopPage,
		[var0_0.GIFT_PAGE] = arg0_9.newServerGiftPage
	}
end

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.newserver_activity_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.resPanel:Find("gem/add_btn"), function()
		local function var0_13()
			if not pg.m02:hasMediator(NewShopMainMediator.__cname) then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
					wrap = ChargeScene.TYPE_DIAMOND
				})
			else
				pg.m02:sendNotification(var0_0.GO_MALL)
			end
		end

		if PLATFORM_CODE == PLATFORM_JP then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				fontSize = 23,
				yesText = "text_buy",
				content = i18n("word_diamond_tip", arg0_10.player:getFreeGem(), arg0_10.player:getChargeGem(), arg0_10.player:getTotalGem()),
				onYes = var0_13,
				alignment = TextAnchor.UpperLeft
			})
		else
			var0_13()
		end
	end, SFX_PANEL)
	arg0_10:updateTime()
	setText(arg0_10.resPanel:Find("gem/gem_value"), arg0_10.player:getTotalGem())

	for iter0_10, iter1_10 in ipairs(arg0_10.toggles) do
		onToggle(arg0_10, iter1_10, function(arg0_15)
			arg0_10:updateLocalRedDotData(iter0_10)
			arg0_10:updatePages(iter0_10, arg0_15)
			setActive(arg0_10.resPanel, arg0_15 and iter0_10 == var0_0.GIFT_PAGE)
		end)
	end

	setActive(arg0_10.toggles[var0_0.TASK_PAGE], arg0_10.taskActivity)
	setActive(arg0_10.toggles[var0_0.SHOP_PAGE], arg0_10.shopActivity)
	setActive(arg0_10.toggles[var0_0.GIFT_PAGE], arg0_10.giftActivity)

	arg0_10.page = arg0_10.contextData.page or arg0_10.taskActivity and var0_0.TASK_PAGE or var0_0.SHOP_PAGE

	triggerToggle(arg0_10.toggles[arg0_10.page], true)
end

function var0_0.updateShopDedDot(arg0_16)
	setActive(arg0_16.toggles[var0_0.SHOP_PAGE]:Find("tip"), arg0_16.newServerShopPage:isTip())
end

function var0_0.updatePages(arg0_17, arg1_17, arg2_17)
	if arg0_17.pageDic[arg1_17]:isShowing() ~= arg2_17 then
		if arg2_17 then
			if arg1_17 == var0_0.SHOP_PAGE then
				arg0_17.pageDic[arg1_17]:ExecuteAction("Flush")
			else
				arg0_17.pageDic[arg1_17]:ExecuteAction("Show")
			end
		else
			arg0_17.pageDic[arg1_17]:ExecuteAction("Hide")
		end
	end
end

function var0_0.updateTips(arg0_18)
	if arg0_18.taskActivity then
		setActive(arg0_18.toggles[var0_0.TASK_PAGE]:Find("tip"), arg0_18.newServerTaskPage:isTip())
	end

	if arg0_18.shopActivity then
		setActive(arg0_18.toggles[var0_0.SHOP_PAGE]:Find("tip"), arg0_18.newServerShopPage:isTip())
	end

	if arg0_18.giftActivity then
		setActive(arg0_18.toggles[var0_0.GIFT_PAGE]:Find("tip"), arg0_18.newServerGiftPage:isTip())
	end
end

function var0_0.updateLocalRedDotData(arg0_19, arg1_19)
	if arg1_19 == var0_0.SHOP_PAGE then
		if arg0_19.newServerShopPage:isTip() and PlayerPrefs.GetInt("newserver_shop_first_" .. arg0_19.player.id) == 0 then
			PlayerPrefs.SetInt("newserver_shop_first_" .. arg0_19.player.id, 1)
		end
	elseif arg1_19 == var0_0.GIFT_PAGE and arg0_19.newServerGiftPage:isTip() then
		PlayerPrefs.SetInt("newserver_gift_first_" .. arg0_19.player.id, 1)
	end
end

function var0_0.updateTime(arg0_20)
	local var0_20 = pg.TimeMgr.GetInstance()
	local var1_20 = (arg0_20.taskActivity and arg0_20.taskActivity.stopTime or arg0_20.shopActivity.stopTime) - var0_20:GetServerTime()
	local var2_20 = math.floor(var1_20 / 86400)
	local var3_20 = math.floor((var1_20 - var2_20 * 86400) / 3600)

	setText(arg0_20.timeTF, i18n("newserver_time", var2_20, var3_20))
	setActive(arg0_20.timeTF:Find("title_activity"), arg0_20.taskActivity)
	setActive(arg0_20.timeTF:Find("title_shop"), not arg0_20.taskActivity)
end

function var0_0.onUpdateTask(arg0_21)
	arg0_21.newServerTaskPage:ActionInvoke("onUpdateTask")
	arg0_21.newServerShopPage:ActionInvoke("UpdateRes")
	arg0_21:updateTips()
end

function var0_0.onUpdatePlayer(arg0_22, arg1_22)
	arg0_22.player = arg1_22

	setText(arg0_22.resPanel:Find("gem/gem_value"), arg0_22.player:getTotalGem())
	arg0_22.newServerGiftPage:onUpdatePlayer(arg1_22)
end

function var0_0.onUpdateGift(arg0_23)
	arg0_23.newServerGiftPage:ActionInvoke("onUpdateGift")
	arg0_23:updateTips()
end

function var0_0.willExit(arg0_24)
	arg0_24.newServerTaskPage:Destroy()
	arg0_24.newServerShopPage:Destroy()
	arg0_24.newServerGiftPage:Destroy()
end

function var0_0.isShow()
	local var0_25 = getProxy(ActivityProxy)
	local var1_25 = var0_25:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)
	local var2_25 = var0_25:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP)
	local var3_25 = var0_25:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_GIFT)

	return var1_25 and not var1_25:isEnd() or var2_25 and not var2_25:isEnd() or var3_25 and not var3_25:isEnd()
end

function var0_0.isTip()
	return false
end

return var0_0
