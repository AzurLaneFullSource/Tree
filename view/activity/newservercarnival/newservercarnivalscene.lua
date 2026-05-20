local var0_0 = class("NewServerCarnivalScene", import("...base.BaseUI"))

var0_0.TASK_PAGE = 1
var0_0.SHOP_PAGE = 2
var0_0.GIFT_PAGE = 3

function var0_0.getUIName(arg0_1)
	return "NewServerCarnivalUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = {}

	table.insert(var0_2, function(arg0_3)
		pg.m02:sendNotification(GAME.GET_NEW_SERVER_SHOP, {
			callback = function(arg0_4)
				arg0_2:SetNewServerShop(arg0_4)
				arg0_3()
			end
		})
	end)
	parallelAsync(var0_2, arg1_2)
end

function var0_0.SetNewServerShop(arg0_5, arg1_5)
	arg0_5.newServerShop = arg1_5
end

function var0_0.setData(arg0_6)
	local var0_6 = getProxy(ActivityProxy)
	local var1_6 = var0_6:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)
	local var2_6 = var0_6:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP)
	local var3_6 = var0_6:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_GIFT)

	if var1_6 and not var1_6:isEnd() then
		arg0_6.taskActivity = var1_6
	else
		arg0_6.taskActivity = nil
	end

	if var2_6 and not var2_6:isEnd() then
		arg0_6.shopActivity = var2_6
	else
		arg0_6.shopActivity = nil
	end

	if var3_6 and not var3_6:isEnd() then
		arg0_6.giftActivity = var3_6
	else
		arg0_6.giftActivity = nil
	end

	arg0_6.player = getProxy(PlayerProxy):getData()
end

function var0_0.init(arg0_7)
	arg0_7.blurPanel = arg0_7._tf:Find("blur_panel")
	arg0_7.top = arg0_7.blurPanel:Find("adapt/top")
	arg0_7.resPanel = arg0_7.top:Find("res")
	arg0_7.backBtn = arg0_7.top:Find("back_btn")
	arg0_7.helpBtn = arg0_7.top:Find("help_btn")
	arg0_7.leftPanel = arg0_7._tf:Find("left")
	arg0_7.timeTF = arg0_7.leftPanel:Find("time")
	arg0_7.toggles = {
		arg0_7.leftPanel:Find("frame/toggle_group/task"),
		arg0_7.leftPanel:Find("frame/toggle_group/shop"),
		arg0_7.leftPanel:Find("frame/toggle_group/gift")
	}
	arg0_7.main = arg0_7._tf:Find("main")
	arg0_7.pages = {
		arg0_7.main:Find("task_container"),
		arg0_7.main:Find("shop_container"),
		arg0_7.main:Find("gift_container")
	}
	arg0_7.newServerTaskPage = NewServerTaskPage.New(arg0_7.pages[var0_0.TASK_PAGE], arg0_7.event, arg0_7.contextData)
	arg0_7.newServerShopPage = NewServerShopPage.New(arg0_7.pages[var0_0.SHOP_PAGE], arg0_7.event, arg0_7.contextData)

	arg0_7.newServerShopPage:SetShop(arg0_7.newServerShop)

	arg0_7.newServerGiftPage = NewServerGiftPage.New(arg0_7.pages[var0_0.GIFT_PAGE], arg0_7.event, arg0_7.contextData)
	arg0_7.pageDic = {
		[var0_0.TASK_PAGE] = arg0_7.newServerTaskPage,
		[var0_0.SHOP_PAGE] = arg0_7.newServerShopPage,
		[var0_0.GIFT_PAGE] = arg0_7.newServerGiftPage
	}
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8.backBtn, function()
		arg0_8:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.newserver_activity_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.resPanel:Find("gem/add_btn"), function()
		local function var0_11()
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
				content = i18n("word_diamond_tip", arg0_8.player:getFreeGem(), arg0_8.player:getChargeGem(), arg0_8.player:getTotalGem()),
				onYes = var0_11,
				alignment = TextAnchor.UpperLeft
			})
		else
			var0_11()
		end
	end, SFX_PANEL)
	arg0_8:updateTime()
	setText(arg0_8.resPanel:Find("gem/gem_value"), arg0_8.player:getTotalGem())

	for iter0_8, iter1_8 in ipairs(arg0_8.toggles) do
		onToggle(arg0_8, iter1_8, function(arg0_13)
			arg0_8:updateLocalRedDotData(iter0_8)
			arg0_8:updatePages(iter0_8, arg0_13)
			setActive(arg0_8.resPanel, arg0_13 and iter0_8 == var0_0.GIFT_PAGE)
		end)
	end

	setActive(arg0_8.toggles[var0_0.TASK_PAGE], arg0_8.taskActivity)
	setActive(arg0_8.toggles[var0_0.SHOP_PAGE], arg0_8.shopActivity)
	setActive(arg0_8.toggles[var0_0.GIFT_PAGE], arg0_8.giftActivity)

	arg0_8.page = arg0_8.contextData.page or arg0_8.taskActivity and var0_0.TASK_PAGE or var0_0.SHOP_PAGE

	triggerToggle(arg0_8.toggles[arg0_8.page], true)
end

function var0_0.updateShopDedDot(arg0_14)
	setActive(arg0_14.toggles[var0_0.SHOP_PAGE]:Find("tip"), arg0_14.newServerShopPage:isTip())
end

function var0_0.updatePages(arg0_15, arg1_15, arg2_15)
	if arg0_15.pageDic[arg1_15]:isShowing() ~= arg2_15 then
		if arg2_15 then
			if arg1_15 == var0_0.SHOP_PAGE then
				arg0_15.pageDic[arg1_15]:ExecuteAction("Flush")
			else
				arg0_15.pageDic[arg1_15]:ExecuteAction("Show")
			end
		else
			arg0_15.pageDic[arg1_15]:ExecuteAction("Hide")
		end
	end
end

function var0_0.updateTips(arg0_16)
	if arg0_16.taskActivity then
		setActive(arg0_16.toggles[var0_0.TASK_PAGE]:Find("tip"), arg0_16.newServerTaskPage:isTip())
	end

	if arg0_16.shopActivity then
		setActive(arg0_16.toggles[var0_0.SHOP_PAGE]:Find("tip"), arg0_16.newServerShopPage:isTip())
	end

	if arg0_16.giftActivity then
		setActive(arg0_16.toggles[var0_0.GIFT_PAGE]:Find("tip"), arg0_16.newServerGiftPage:isTip())
	end
end

function var0_0.updateLocalRedDotData(arg0_17, arg1_17)
	if arg1_17 == var0_0.SHOP_PAGE then
		if arg0_17.newServerShopPage:isTip() and PlayerPrefs.GetInt("newserver_shop_first_" .. arg0_17.player.id) == 0 then
			PlayerPrefs.SetInt("newserver_shop_first_" .. arg0_17.player.id, 1)
		end
	elseif arg1_17 == var0_0.GIFT_PAGE and arg0_17.newServerGiftPage:isTip() then
		PlayerPrefs.SetInt("newserver_gift_first_" .. arg0_17.player.id, 1)
	end
end

function var0_0.updateTime(arg0_18)
	local var0_18 = pg.TimeMgr.GetInstance()
	local var1_18 = (arg0_18.taskActivity and arg0_18.taskActivity.stopTime or arg0_18.shopActivity.stopTime) - var0_18:GetServerTime()
	local var2_18 = math.floor(var1_18 / 86400)
	local var3_18 = math.floor((var1_18 - var2_18 * 86400) / 3600)

	setText(arg0_18.timeTF, i18n("newserver_time", var2_18, var3_18))
	setActive(arg0_18.timeTF:Find("title_activity"), arg0_18.taskActivity)
	setActive(arg0_18.timeTF:Find("title_shop"), not arg0_18.taskActivity)
end

function var0_0.onUpdateTask(arg0_19)
	arg0_19.newServerTaskPage:ActionInvoke("onUpdateTask")
	arg0_19.newServerShopPage:ActionInvoke("UpdateRes")
	arg0_19:updateTips()
end

function var0_0.onUpdatePlayer(arg0_20, arg1_20)
	arg0_20.player = arg1_20

	setText(arg0_20.resPanel:Find("gem/gem_value"), arg0_20.player:getTotalGem())
	arg0_20.newServerGiftPage:onUpdatePlayer(arg1_20)
end

function var0_0.onUpdateGift(arg0_21)
	arg0_21.newServerGiftPage:ActionInvoke("onUpdateGift")
	arg0_21:updateTips()
end

function var0_0.willExit(arg0_22)
	arg0_22.newServerTaskPage:Destroy()
	arg0_22.newServerShopPage:Destroy()
	arg0_22.newServerGiftPage:Destroy()
end

function var0_0.isShow()
	local var0_23 = getProxy(ActivityProxy)
	local var1_23 = var0_23:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)
	local var2_23 = var0_23:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP)
	local var3_23 = var0_23:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_GIFT)

	return var1_23 and not var1_23:isEnd() or var2_23 and not var2_23:isEnd() or var3_23 and not var3_23:isEnd()
end

function var0_0.isTip()
	return false
end

return var0_0
