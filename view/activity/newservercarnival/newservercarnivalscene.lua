local var0 = class("NewServerCarnivalScene", import("...base.BaseUI"))

var0.TASK_PAGE = 1
var0.SHOP_PAGE = 2
var0.GIFT_PAGE = 3

function var0.getUIName(arg0)
	return "NewServerCarnivalUI"
end

function var0.preload(arg0, arg1)
	local var0 = {}

	table.insert(var0, function(arg0)
		pg.m02:sendNotification(GAME.GET_NEW_SERVER_SHOP, {
			callback = function(arg0)
				arg0:SetNewServerShop(arg0)
				arg0()
			end
		})
	end)
	parallelAsync(var0, arg1)
end

function var0.SetNewServerShop(arg0, arg1)
	arg0.newServerShop = arg1
end

function var0.setData(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)
	local var2 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP)
	local var3 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_GIFT)

	if var1 and not var1:isEnd() then
		arg0.taskActivity = var1
	else
		arg0.taskActivity = nil
	end

	if var2 and not var2:isEnd() then
		arg0.shopActivity = var2
	else
		arg0.shopActivity = nil
	end

	if var3 and not var3:isEnd() then
		arg0.giftActivity = var3
	else
		arg0.giftActivity = nil
	end

	arg0.player = getProxy(PlayerProxy):getData()
end

function var0.init(arg0)
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.top = arg0:findTF("adapt/top", arg0.blurPanel)
	arg0.resPanel = arg0:findTF("res", arg0.top)
	arg0.backBtn = arg0:findTF("back_btn", arg0.top)
	arg0.helpBtn = arg0:findTF("help_btn", arg0.top)
	arg0.leftPanel = arg0:findTF("left")
	arg0.timeTF = arg0:findTF("time", arg0.leftPanel)
	arg0.toggles = {
		arg0:findTF("frame/toggle_group/task", arg0.leftPanel),
		arg0:findTF("frame/toggle_group/shop", arg0.leftPanel),
		arg0:findTF("frame/toggle_group/gift", arg0.leftPanel)
	}
	arg0.main = arg0:findTF("main")
	arg0.pages = {
		arg0:findTF("task_container", arg0.main),
		arg0:findTF("shop_container", arg0.main),
		arg0:findTF("gift_container", arg0.main)
	}
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.newserver_activity_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("gem/add_btn", arg0.resPanel), function()
		local var0 = function()
			if not pg.m02:hasMediator(ChargeMediator.__cname) then
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
					wrap = ChargeScene.TYPE_DIAMOND
				})
			else
				pg.m02:sendNotification(var0.GO_MALL)
			end
		end

		if PLATFORM_CODE == PLATFORM_JP then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				fontSize = 23,
				yesText = "text_buy",
				content = i18n("word_diamond_tip", arg0.player:getFreeGem(), arg0.player:getChargeGem(), arg0.player:getTotalGem()),
				onYes = var0,
				alignment = TextAnchor.UpperLeft,
				weight = LayerWeightConst.TOP_LAYER
			})
		else
			var0()
		end
	end, SFX_PANEL)
	arg0:updatePages()
	arg0:updateTime()
	setText(arg0:findTF("gem/gem_value", arg0.resPanel), arg0.player:getTotalGem())

	for iter0, iter1 in ipairs(arg0.toggles) do
		onToggle(arg0, iter1, function(arg0)
			setActive(arg0.pages[iter0], arg0)
			arg0:updateLocalRedDotData(iter0)
			arg0:updatePages()
			setActive(arg0.resPanel, arg0 and iter0 == var0.GIFT_PAGE)
		end)
	end

	setActive(arg0.toggles[var0.TASK_PAGE], arg0.taskActivity)
	setActive(arg0.toggles[var0.SHOP_PAGE], arg0.shopActivity)
	setActive(arg0.toggles[var0.GIFT_PAGE], arg0.giftActivity)

	arg0.page = arg0.taskActivity and var0.TASK_PAGE or var0.SHOP_PAGE
	arg0.page = arg0.contextData.page and arg0.contextData.page or arg0.page

	triggerToggle(arg0.toggles[arg0.page], true)
end

function var0.updateShopDedDot(arg0)
	setActive(arg0:findTF("tip", arg0.toggles[var0.SHOP_PAGE]), arg0.newServerShopPage:isTip())
end

function var0.updatePages(arg0)
	if arg0.taskActivity then
		if not arg0.newServerTaskPage then
			arg0.newServerTaskPage = NewServerTaskPage.New(arg0.pages[var0.TASK_PAGE], arg0.event, arg0.contextData)

			arg0.newServerTaskPage:Reset()
			arg0.newServerTaskPage:Load()
		end

		setActive(arg0:findTF("tip", arg0.toggles[var0.TASK_PAGE]), arg0.newServerTaskPage:isTip())
	end

	if arg0.shopActivity then
		if not arg0.newServerShopPage then
			arg0.newServerShopPage = NewServerShopPage.New(arg0.pages[var0.SHOP_PAGE], arg0.event, arg0.contextData)

			arg0.newServerShopPage:Reset()
			arg0.newServerShopPage:SetShop(arg0.newServerShop)
			arg0.newServerShopPage:Load()
		end

		setActive(arg0:findTF("tip", arg0.toggles[var0.SHOP_PAGE]), arg0.newServerShopPage:isTip())
	end

	if arg0.giftActivity then
		if not arg0.newServerGiftPage then
			arg0.newServerGiftPage = NewServerGiftPage.New(arg0.pages[var0.GIFT_PAGE], arg0.event, arg0.contextData)

			arg0.newServerGiftPage:Reset()
			arg0.newServerGiftPage:Load()
		end

		setActive(arg0:findTF("tip", arg0.toggles[var0.GIFT_PAGE]), arg0.newServerGiftPage:isTip())
	end
end

function var0.updateLocalRedDotData(arg0, arg1)
	if arg1 == var0.SHOP_PAGE then
		if arg0.newServerShopPage:isTip() and PlayerPrefs.GetInt("newserver_shop_first_" .. arg0.player.id) == 0 then
			PlayerPrefs.SetInt("newserver_shop_first_" .. arg0.player.id, 1)
		end
	elseif arg1 == var0.GIFT_PAGE and arg0.newServerGiftPage:isTip() then
		PlayerPrefs.SetInt("newserver_gift_first_" .. arg0.player.id, 1)
	end
end

function var0.updateTime(arg0)
	local var0 = pg.TimeMgr.GetInstance()
	local var1 = (arg0.taskActivity and arg0.taskActivity.stopTime or arg0.shopActivity.stopTime) - var0:GetServerTime()
	local var2 = math.floor(var1 / 86400)
	local var3 = math.floor((var1 - var2 * 86400) / 3600)

	setText(arg0.timeTF, i18n("newserver_time", var2, var3))
	setActive(arg0:findTF("title_activity", arg0.timeTF), arg0.taskActivity)
	setActive(arg0:findTF("title_shop", arg0.timeTF), not arg0.taskActivity)
end

function var0.onUpdateTask(arg0)
	if arg0.newServerTaskPage then
		arg0.newServerTaskPage:onUpdateTask()
	end

	if arg0.newServerShopPage then
		arg0.newServerShopPage:UpdateRes()
	end

	arg0:updatePages()
end

function var0.onUpdatePlayer(arg0, arg1)
	arg0.player = arg1

	setText(arg0:findTF("gem/gem_value", arg0.resPanel), arg0.player:getTotalGem())

	if arg0.newServerGiftPage then
		arg0.newServerGiftPage:onUpdatePlayer(arg1)
	end
end

function var0.onUpdateGift(arg0)
	if arg0.newServerGiftPage then
		arg0.newServerGiftPage:onUpdateGift()
	end

	arg0:updatePages()
end

function var0.willExit(arg0)
	return
end

function var0.isShow()
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)
	local var2 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP)
	local var3 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_GIFT)

	return var1 and not var1:isEnd() or var2 and not var2:isEnd() or var3 and not var3:isEnd()
end

function var0.isTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)

	if var0 and not var0:isEnd() then
		local var1 = getProxy(TaskProxy)
		local var2 = var0:getConfig("config_data")

		for iter0, iter1 in ipairs(var2) do
			for iter2, iter3 in ipairs(iter1) do
				assert(var1:getTaskVO(iter3), "without this task:" .. iter3)

				if var1:getTaskVO(iter3):getTaskStatus() == 1 then
					return true
				end
			end
		end
	end

	return false
end

return var0
