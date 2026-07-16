local var0_0 = class("AuctionGameCoreActivityUI", import("view.activity.CorePage.CoreActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "AuctionGameCoreActivityUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = {}

	table.insert(var0_2, function(arg0_3)
		pg.m02:sendNotification(GAME.AUCTION_GAME_INIT, {
			callback = arg0_3
		})
	end)
	seriesAsync(var0_2, arg1_2)
end

var0_0.optionsPath = {
	"adapt/TopPage/top/btn_home"
}

function var0_0.init(arg0_4, ...)
	var0_0.super.init(arg0_4, ...)

	arg0_4.btnBack = arg0_4._tf:Find("adapt/TopPage/top/btn_back")
	arg0_4.topPage = arg0_4._tf:Find("adapt/TopPage")

	setText(arg0_4._tf:Find("adapt/TopPage/top/deco/Text"), i18n("HelenaCoreActivity_title"))
	setText(arg0_4._tf:Find("adapt/TopPage/top/deco/Text/Text_1"), i18n("HelenaCoreActivity_title2"))
	setText(arg0_4._tf:Find("adapt/taskBtn/Text"), i18n("auction_signin_task"))
	setText(arg0_4._tf:Find("adapt/auctionGameBtn/Text"), i18n("auction_signin_goto"))

	arg0_4.uiTaskTipGo = findTF(arg0_4._tf, "adapt/taskBtn/tip")
	arg0_4.uiAuctionTipGo = findTF(arg0_4._tf, "adapt/auctionGameBtn/tip")

	onButton(arg0_4, findTF(arg0_4._tf, "adapt/auctionGameBtn"), function()
		local var0_5 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME)

		if var0_5 == nil or var0_5 and var0_5:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_activity_closed_tip"))

			return
		end

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.AUCTION_GAME_ENTRANCE)
	end, SFX_PANEL)
	onButton(arg0_4, findTF(arg0_4._tf, "adapt/taskBtn"), function()
		local var0_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME)

		if var0_6 == nil or var0_6 and var0_6:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auction_activity_closed_tip"))

			return
		end

		arg0_4:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameTaskScene,
			mediator = AuctionGameTaskMediator,
			data = {}
		}))
	end, SFX_PANEL)

	local var0_4

	arg0_4.tabsList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = underscore.detect(arg0_4.activities, function(arg0_8)
				return tostring(arg0_8:getConfig("is_show")) == arg2_7.name
			end)

			if not var0_7 or var0_7:isEnd() then
				setActive(arg2_7, false)
			elseif not arg0_4.pageDic[var0_7.id] then
				warning(string.format("without page in act:", var0_7.id))
			else
				arg0_4:OnToggleName(arg2_7, var0_7)

				if arg0_4.pageDic[var0_7.id] ~= nil then
					setActive(arg2_7:Find("tip"), var0_7:readyToAchieve())
					onToggle(arg0_4, arg2_7, function(arg0_9)
						local var0_9 = arg2_7:Find("off")

						if arg0_9 then
							if var0_4 ~= var0_7.id then
								arg0_4:selectActivity(var0_7)
							end

							var0_4 = var0_7.id
						end

						setActive(var0_9, not arg0_9)
					end, SFX_PANEL)
				end
			end
		end
	end)
end

function var0_0.didEnter(arg0_10)
	var0_0.super.didEnter(arg0_10)
	pg.NewStoryMgr.GetInstance():Play("TEBIEJINGPAISHIKE1")
	arg0_10:RefreshTip()
end

function var0_0.updateActivity(arg0_11, arg1_11)
	var0_0.super.updateActivity(arg0_11, arg1_11)
	arg0_11:RefreshTip()
end

function var0_0.RefreshTip(arg0_12)
	local var0_12 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME)

	if var0_12 == nil then
		setActive(arg0_12.uiTaskTipGo, false)
		setActive(arg0_12.uiAuctionTipGo, false)
	else
		setActive(arg0_12.uiTaskTipGo, var0_12:GetTaskTip())
		setActive(arg0_12.uiAuctionTipGo, var0_12:readyToAchieve())
	end
end

function var0_0.verifyTabs(arg0_13, arg1_13)
	local var0_13 = arg0_13.activities[arg0_13:getActivityIndex(arg1_13) or arg0_13:getActivityIndex(arg0_13:GetActiveActivity()) or 1]

	if var0_13 == nil then
		return
	end

	local var1_13 = var0_13:getConfig("is_show")
	local var2_13 = arg0_13.tabs:Find(tostring(var1_13))

	if #arg0_13.activities == 1 then
		setActive(arg0_13._tf:Find("adapt/tabs"), false)
	else
		setActive(arg0_13._tf:Find("adapt/tabs"), true)
	end

	triggerToggle(var2_13, true)
end

function var0_0.OnToggleName(arg0_14, arg1_14, arg2_14)
	setText(arg1_14:Find("on/name"), i18n(arg2_14:getConfig("title_res_tag")))
	setText(arg1_14:Find("off/name"), i18n(arg2_14:getConfig("title_res_tag")))
end

function var0_0.willExit(arg0_15)
	var0_0.super.willExit(arg0_15)
end

return var0_0
