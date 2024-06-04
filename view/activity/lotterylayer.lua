local var0 = class("LotteryLayer", import("..base.BaseUI"))
local var1 = pg.activity_random_award_template
local var2 = true

function var0.getUIName(arg0)
	if var2 then
		return "LotteryForCHTUI"
	else
		return "LotteryUI"
	end
end

function var0.setPlayerVO(arg0, arg1)
	arg0.playerVO = arg1

	arg0:updateResource()
end

function var0.updateResource(arg0)
	arg0.resCount = arg0.playerVO[id2res(arg0.resId)]

	setText(arg0.resource:Find("Text"), arg0.resCount)
end

function var0.setActivity(arg0, arg1)
	arg0.activityVO = arg1
	arg0.resId = arg0.activityVO:getConfig("config_client").resId
	arg0.awardInfos = arg1:getAwardInfos()

	arg0:initActivityPools()
end

function var0.initActivityPools(arg0)
	arg0.activityPools = {}

	local var0 = arg0.activityVO:getConfig("config_data")
	local var1 = _.select(var1.all, function(arg0)
		return table.contains(var0, arg0)
	end)
	local var2

	for iter0, iter1 in ipairs(var1) do
		local var3 = ActivityItemPool.New({
			id = iter1,
			awards = arg0.awardInfos[iter1],
			prevId = var2,
			index = iter0
		})

		var2 = iter1
		arg0.activityPools[var3.id] = var3
	end

	local var4 = arg0.activityVO.data1 or var0[1]

	arg0.activityPool = arg0.activityPools[var4]
end

function var0.init(arg0)
	arg0.lotteryPoolContainer = arg0:findTF("left_panel/pool_list/content")
	arg0.attrs = arg0:findTF("left_panel/pool_list/arrs")
	arg0.mainItenContainer = arg0:findTF("right_panel/main_item_list/content")
	arg0.mainItenTpl = arg0:findTF("equipmenttpl", arg0.mainItenContainer)
	arg0.resource = arg0:findTF("left_panel/resource")
	arg0.launchOneBtn = arg0:findTF("left_panel/launch_one_btn")
	arg0.launchOneBtnTxt = arg0:findTF("res/Text", arg0.launchOneBtn):GetComponent(typeof(Text))
	arg0.launchTenBtn = arg0:findTF("left_panel/launch_ten_btn")
	arg0.launchTenBtnTxt = arg0:findTF("res/Text", arg0.launchTenBtn):GetComponent(typeof(Text))
	arg0.launchMaxBtn = arg0:findTF("left_panel/launch_max_btn")
	arg0.launchMaxBtnTxt = arg0:findTF("res/Text", arg0.launchMaxBtn):GetComponent(typeof(Text))
	arg0.awardsCounttxt = arg0:findTF("right_panel/count_container/Text"):GetComponent(typeof(Text))
	arg0.bgTF = arg0:findTF("right_panel"):GetComponent(typeof(Image))
	arg0.descBtn = arg0:findTF("right_panel/desc_btn")
	arg0.bonusWindow = arg0:findTF("Msgbox")

	setActive(arg0.bonusWindow, false)

	arg0.topPanel = arg0:findTF("top")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("top/back_btn"), function()
		arg0:emit(var0.ON_CLOSE)
	end, SOUND_BACK)

	local var0 = {
		arg0.launchOneBtn,
		arg0.launchTenBtn,
		arg0.launchMaxBtn
	}
	local var1 = {
		1,
		10,
		"max"
	}

	for iter0, iter1 in ipairs(var0) do
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = arg0.resId
		}):getIcon(), "", iter1:Find("res/icon"), true)
		onButton(arg0, iter1, function()
			if not arg0.activityPool then
				return
			end

			if arg0.activityPool ~= arg0.showActivityPool then
				pg.TipsMgr.GetInstance():ShowTips(i18n("amercian_notice_5"))

				return
			end

			local var0 = arg0.activityPool:getleftItemCount()

			if var0 == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("activity_pool_awards_empty"))

				return
			end

			local var1 = arg0.activityPool:getComsume()

			if var1[iter0] == "max" then
				var0 = math.min(var0, math.max(math.floor(arg0.resCount / var1.count), 1))
			else
				var0 = math.min(var0, var1[iter0])
			end

			if not arg0.activityPool:enoughResForUsage(var0) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end

			local function var2()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("amercian_notice_1", var0 * var1.count, var0),
					onYes = function()
						arg0:emit(LotteryMediator.ON_LAUNCH, arg0.activityVO.id, arg0.activityPool.id, var0, var1[iter0] == "max")
					end
				})
			end

			if arg0.playerVO:OilMax(1) or arg0.playerVO:GoldMax(1) then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("amercian_notice_6"),
					onYes = function()
						var2()
					end
				})
			else
				var2()
			end
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.descBtn, function()
		if not arg0.showActivityPool then
			return
		end

		local var0, var1 = arg0.showActivityPool:getItems()

		arg0:showBonus(var0, var1)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("window/top/btnBack", arg0.bonusWindow), function()
		setActive(arg0.bonusWindow, false)
	end)
	onButton(arg0, arg0:findTF("window/button", arg0.bonusWindow), function()
		setActive(arg0.bonusWindow, false)
	end)
	onButton(arg0, arg0.bonusWindow, function()
		setActive(arg0.bonusWindow, false)
	end)

	arg0.bgs = {}
	arg0.attrTFs = {}

	for iter2 = 1, table.getCount(arg0.activityPools) do
		local var2 = arg0.attrs:Find("arr_" .. iter2)

		if not IsNil(var2) then
			table.insert(arg0.attrTFs, var2)
		end
	end

	arg0:updateResource()
	arg0:initPoolTFs()
	arg0:updateActivityPoolState()
	triggerToggle(arg0.activityPoolTFs[arg0.activityPool.id], true)
end

function var0.onActivityUpdated(arg0, arg1)
	arg0:setActivity(arg1)
	arg0:updateActivityPoolState()
	arg0:switchToPool(arg1.data1)
end

function var0.initPoolTFs(arg0)
	arg0.activityPoolTFs = {}

	for iter0, iter1 in pairs(arg0.activityPools) do
		local var0 = arg0.lotteryPoolContainer:GetChild(iter1.index - 1)

		arg0.activityPoolTFs[iter1.id] = var0

		onToggle(arg0, var0, function(arg0)
			if arg0 then
				if not iter1.prevId or arg0.activityPools[iter1.prevId]:canOpenNext() then
					arg0:emit(LotteryMediator.ON_SWITCH, arg0.activityVO.id, iter1.id)
				else
					arg0:switchToPool(iter1.id)
				end
			end
		end)
	end
end

function var0.updateActivityPoolState(arg0)
	for iter0, iter1 in pairs(arg0.activityPools) do
		local var0 = arg0.activityPoolTFs[iter0]
		local var1 = not iter1.prevId or arg0.activityPools[iter1.prevId]:canOpenNext()

		setActive(var0:Find("bg/unlock"), var1)
		setActive(var0:Find("bg/lock"), not var1)
		setActive(var0:Find("selected/unlock"), var1)
		setActive(var0:Find("selected/lock"), not var1)

		if var2 then
			setActive(var0:Find("icon"), var1)
			setActive(var0:Find("icon_g"), not var1)
		end

		local var2 = iter1:getleftItemCount()

		setActive(var0:Find("finish"), var2 == 0)

		if arg0.attrTFs[iter1.index - 1] then
			triggerToggle(arg0.attrTFs[iter1.index - 1], var1)
		end
	end
end

function var0.switchToPool(arg0, arg1)
	local var0 = arg0.activityPools[arg1]
	local var1 = arg0.activityPoolTFs[arg1]

	arg0:updateMainItems(var0)
	arg0:updateAwardsFetchedCount(var0)

	local var2 = arg0.bgs[arg1]

	if not var2 then
		if var2 then
			var2 = LoadSprite("lotterybg/cht_" .. var0.index)
		else
			var2 = LoadSprite("lotterybg/kr_re_" .. var0.index)
		end

		arg0.bgs[arg1] = var2
	end

	arg0.bgTF.sprite = var2

	local var3 = var0:getComsume()
	local var4 = math.min(var0:getleftItemCount(), 10)
	local var5 = math.min(var0:getleftItemCount(), math.max(math.floor(arg0.resCount / var3.count), 1))

	arg0.launchOneBtnTxt.text = var3.count
	arg0.launchTenBtnTxt.text = var3.count * var4
	arg0.launchMaxBtnTxt.text = var3.count * var5
	arg0.showActivityPool = arg0.activityPools[var0.id]
end

function var0.updateAwardsFetchedCount(arg0, arg1)
	if arg0.awardsCounttxt then
		local var0 = arg1:getFetchCount()
		local var1 = arg1:getItemCount()

		arg0.awardsCounttxt.text = setColorStr(var1 - var0, var0 < var1 and COLOR_GREEN or COLOR_RED) .. "/" .. var1
	end
end

function var0.updateMainItems(arg0, arg1)
	local var0 = arg1:getMainItems()

	for iter0 = arg0.mainItenContainer.childCount, #var0 do
		cloneTplTo(arg0.mainItenTpl, arg0.mainItenContainer)
	end

	local var1 = arg0.mainItenContainer.childCount

	for iter1 = 1, var1 do
		local var2 = arg0.mainItenContainer:GetChild(iter1 - 1)
		local var3 = iter1 <= #var0

		setActive(var2, var3)

		if var3 then
			local var4 = var0[iter1]

			updateDrop(var2, var4)
			setActive(var2:Find("mask"), var4.surplus <= 0)
			setText(var2:Find("icon_bg/surplus"), "X" .. (var4.surplus or ""))
			onButton(arg0, var2, function()
				arg0:emit(var0.ON_DROP, var4)
			end, SFX_PANEL)
		end
	end
end

function var0.showBonus(arg0, arg1, arg2)
	setActive(arg0.bonusWindow, true)

	arg0.awardMain = arg1
	arg0.awardNormal = arg2
	arg0.trDropTpl = arg0:findTF("Msgbox/window/items/scrollview/item")
	arg0.trDrops = arg0:findTF("Msgbox/window/items/scrollview/list/list_main")
	arg0.dropList = UIItemList.New(arg0.trDrops, arg0.trDropTpl)

	arg0.dropList:make(function(arg0, arg1, arg2)
		arg0:updateDrop(arg0, arg1, arg2, arg0.awardMain)
	end)
	arg0.dropList:align(#arg0.awardMain)

	arg0.trDropsN = arg0:findTF("Msgbox/window/items/scrollview/list/list_normal")
	arg0.dropListN = UIItemList.New(arg0.trDropsN, arg0.trDropTpl)

	arg0.dropListN:make(function(arg0, arg1, arg2)
		arg0:updateDrop(arg0, arg1, arg2, arg0.awardNormal)
	end)
	arg0.dropListN:align(#arg0.awardNormal)
end

function var0.updateDrop(arg0, arg1, arg2, arg3, arg4)
	if arg1 == UIItemList.EventUpdate then
		local var0 = arg4[arg2 + 1]

		updateDrop(arg3, var0)
		setText(arg3:Find("count"), var0.surplus .. "/" .. var0.total)
		setActive(arg3:Find("mask"), var0.surplus <= 0)
		setScrollText(findTF(arg3, "name_mask/name"), var0.name or var0:getConfig("name"))
	end
end

function var0.willExit(arg0)
	arg0.bgs = nil
end

return var0
