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
	arg0_7.blurPanel = arg0_7:findTF("blur_panel")
	arg0_7.top = arg0_7:findTF("adapt/top", arg0_7.blurPanel)
	arg0_7.resPanel = arg0_7:findTF("res", arg0_7.top)
	arg0_7.backBtn = arg0_7:findTF("back_btn", arg0_7.top)
	arg0_7.helpBtn = arg0_7:findTF("help_btn", arg0_7.top)
	arg0_7.leftPanel = arg0_7:findTF("left")
	arg0_7.timeTF = arg0_7:findTF("time", arg0_7.leftPanel)
	arg0_7.toggles = {
		arg0_7:findTF("frame/toggle_group/task", arg0_7.leftPanel),
		arg0_7:findTF("frame/toggle_group/shop", arg0_7.leftPanel),
		arg0_7:findTF("frame/toggle_group/gift", arg0_7.leftPanel)
	}
	arg0_7.main = arg0_7:findTF("main")
	arg0_7.pages = {
		arg0_7:findTF("task_container", arg0_7.main),
		arg0_7:findTF("shop_container", arg0_7.main),
		arg0_7:findTF("gift_container", arg0_7.main)
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
	onButton(arg0_8, arg0_8:findTF("gem/add_btn", arg0_8.resPanel), function()
		local function var0_11()
			if not pg.m02:hasMediator(ChargeMediator.__cname) then
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
				alignment = TextAnchor.UpperLeft,
				weight = LayerWeightConst.TOP_LAYER
			})
		else
			var0_11()
		end
	end, SFX_PANEL)
	arg0_8:updatePages()
	arg0_8:updateTime()
	setText(arg0_8:findTF("gem/gem_value", arg0_8.resPanel), arg0_8.player:getTotalGem())

	for iter0_8, iter1_8 in ipairs(arg0_8.toggles) do
		onToggle(arg0_8, iter1_8, function(arg0_13)
			setActive(arg0_8.pages[iter0_8], arg0_13)
			arg0_8:updateLocalRedDotData(iter0_8)
			arg0_8:updatePages()
			setActive(arg0_8.resPanel, arg0_13 and iter0_8 == var0_0.GIFT_PAGE)
		end)
	end

	setActive(arg0_8.toggles[var0_0.TASK_PAGE], arg0_8.taskActivity)
	setActive(arg0_8.toggles[var0_0.SHOP_PAGE], arg0_8.shopActivity)
	setActive(arg0_8.toggles[var0_0.GIFT_PAGE], arg0_8.giftActivity)

	arg0_8.page = arg0_8.taskActivity and var0_0.TASK_PAGE or var0_0.SHOP_PAGE
	arg0_8.page = arg0_8.contextData.page and arg0_8.contextData.page or arg0_8.page

	triggerToggle(arg0_8.toggles[arg0_8.page], true)
end

function var0_0.updateShopDedDot(arg0_14)
	setActive(arg0_14:findTF("tip", arg0_14.toggles[var0_0.SHOP_PAGE]), arg0_14.newServerShopPage:isTip())
end

function var0_0.updatePages(arg0_15)
	if arg0_15.taskActivity then
		if not arg0_15.newServerTaskPage then
			arg0_15.newServerTaskPage = NewServerTaskPage.New(arg0_15.pages[var0_0.TASK_PAGE], arg0_15.event, arg0_15.contextData)

			arg0_15.newServerTaskPage:Reset()
			arg0_15.newServerTaskPage:Load()
		end

		setActive(arg0_15:findTF("tip", arg0_15.toggles[var0_0.TASK_PAGE]), arg0_15.newServerTaskPage:isTip())
	end

	if arg0_15.shopActivity then
		if not arg0_15.newServerShopPage then
			arg0_15.newServerShopPage = NewServerShopPage.New(arg0_15.pages[var0_0.SHOP_PAGE], arg0_15.event, arg0_15.contextData)

			arg0_15.newServerShopPage:Reset()
			arg0_15.newServerShopPage:SetShop(arg0_15.newServerShop)
			arg0_15.newServerShopPage:Load()
		end

		setActive(arg0_15:findTF("tip", arg0_15.toggles[var0_0.SHOP_PAGE]), arg0_15.newServerShopPage:isTip())
	end

	if arg0_15.giftActivity then
		if not arg0_15.newServerGiftPage then
			arg0_15.newServerGiftPage = NewServerGiftPage.New(arg0_15.pages[var0_0.GIFT_PAGE], arg0_15.event, arg0_15.contextData)

			arg0_15.newServerGiftPage:Reset()
			arg0_15.newServerGiftPage:Load()
		end

		setActive(arg0_15:findTF("tip", arg0_15.toggles[var0_0.GIFT_PAGE]), arg0_15.newServerGiftPage:isTip())
	end
end

function var0_0.updateLocalRedDotData(arg0_16, arg1_16)
	if arg1_16 == var0_0.SHOP_PAGE then
		if arg0_16.newServerShopPage:isTip() and PlayerPrefs.GetInt("newserver_shop_first_" .. arg0_16.player.id) == 0 then
			PlayerPrefs.SetInt("newserver_shop_first_" .. arg0_16.player.id, 1)
		end
	elseif arg1_16 == var0_0.GIFT_PAGE and arg0_16.newServerGiftPage:isTip() then
		PlayerPrefs.SetInt("newserver_gift_first_" .. arg0_16.player.id, 1)
	end
end

function var0_0.updateTime(arg0_17)
	local var0_17 = pg.TimeMgr.GetInstance()
	local var1_17 = (arg0_17.taskActivity and arg0_17.taskActivity.stopTime or arg0_17.shopActivity.stopTime) - var0_17:GetServerTime()
	local var2_17 = math.floor(var1_17 / 86400)
	local var3_17 = math.floor((var1_17 - var2_17 * 86400) / 3600)

	setText(arg0_17.timeTF, i18n("newserver_time", var2_17, var3_17))
	setActive(arg0_17:findTF("title_activity", arg0_17.timeTF), arg0_17.taskActivity)
	setActive(arg0_17:findTF("title_shop", arg0_17.timeTF), not arg0_17.taskActivity)
end

function var0_0.onUpdateTask(arg0_18)
	if arg0_18.newServerTaskPage then
		arg0_18.newServerTaskPage:onUpdateTask()
	end

	if arg0_18.newServerShopPage then
		arg0_18.newServerShopPage:UpdateRes()
	end

	arg0_18:updatePages()
end

function var0_0.onUpdatePlayer(arg0_19, arg1_19)
	arg0_19.player = arg1_19

	setText(arg0_19:findTF("gem/gem_value", arg0_19.resPanel), arg0_19.player:getTotalGem())

	if arg0_19.newServerGiftPage then
		arg0_19.newServerGiftPage:onUpdatePlayer(arg1_19)
	end
end

function var0_0.onUpdateGift(arg0_20)
	if arg0_20.newServerGiftPage then
		arg0_20.newServerGiftPage:onUpdateGift()
	end

	arg0_20:updatePages()
end

function var0_0.willExit(arg0_21)
	return
end

function var0_0.isShow()
	local var0_22 = getProxy(ActivityProxy)
	local var1_22 = var0_22:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)
	local var2_22 = var0_22:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP)
	local var3_22 = var0_22:getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_GIFT)

	return var1_22 and not var1_22:isEnd() or var2_22 and not var2_22:isEnd() or var3_22 and not var3_22:isEnd()
end

function var0_0.isTip()
	local var0_23 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)

	if var0_23 and not var0_23:isEnd() then
		local var1_23 = getProxy(TaskProxy)
		local var2_23 = var0_23:getConfig("config_data")

		for iter0_23, iter1_23 in ipairs(var2_23) do
			for iter2_23, iter3_23 in ipairs(iter1_23) do
				assert(var1_23:getTaskVO(iter3_23), "without this task:" .. iter3_23)

				if var1_23:getTaskVO(iter3_23):getTaskStatus() == 1 then
					return true
				end
			end
		end
	end

	return false
end

return var0_0
