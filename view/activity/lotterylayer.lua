local var0_0 = class("LotteryLayer", import("..base.BaseUI"))
local var1_0 = pg.activity_random_award_template
local var2_0 = true

function var0_0.getUIName(arg0_1)
	if var2_0 then
		return "LotteryForCHTUI"
	else
		return "LotteryUI"
	end
end

function var0_0.setPlayerVO(arg0_2, arg1_2)
	arg0_2.playerVO = arg1_2

	arg0_2:updateResource()
end

function var0_0.updateResource(arg0_3)
	arg0_3.resCount = arg0_3.playerVO[id2res(arg0_3.resId)]

	setText(arg0_3.resource:Find("Text"), arg0_3.resCount)
end

function var0_0.setActivity(arg0_4, arg1_4)
	arg0_4.activityVO = arg1_4
	arg0_4.resId = arg0_4.activityVO:getConfig("config_client").resId
	arg0_4.awardInfos = arg1_4:getAwardInfos()

	arg0_4:initActivityPools()
end

function var0_0.initActivityPools(arg0_5)
	arg0_5.activityPools = {}

	local var0_5 = arg0_5.activityVO:getConfig("config_data")
	local var1_5 = _.select(var1_0.all, function(arg0_6)
		return table.contains(var0_5, arg0_6)
	end)
	local var2_5

	for iter0_5, iter1_5 in ipairs(var1_5) do
		local var3_5 = ActivityItemPool.New({
			id = iter1_5,
			awards = arg0_5.awardInfos[iter1_5],
			prevId = var2_5,
			index = iter0_5
		})

		var2_5 = iter1_5
		arg0_5.activityPools[var3_5.id] = var3_5
	end

	local var4_5 = arg0_5.activityVO.data1 or var0_5[1]

	arg0_5.activityPool = arg0_5.activityPools[var4_5]
end

function var0_0.init(arg0_7)
	arg0_7.lotteryPoolContainer = arg0_7:findTF("left_panel/pool_list/content")
	arg0_7.attrs = arg0_7:findTF("left_panel/pool_list/arrs")
	arg0_7.mainItenContainer = arg0_7:findTF("right_panel/main_item_list/content")
	arg0_7.mainItenTpl = arg0_7:findTF("equipmenttpl", arg0_7.mainItenContainer)
	arg0_7.resource = arg0_7:findTF("left_panel/resource")
	arg0_7.launchOneBtn = arg0_7:findTF("left_panel/launch_one_btn")
	arg0_7.launchOneBtnTxt = arg0_7:findTF("res/Text", arg0_7.launchOneBtn):GetComponent(typeof(Text))
	arg0_7.launchTenBtn = arg0_7:findTF("left_panel/launch_ten_btn")
	arg0_7.launchTenBtnTxt = arg0_7:findTF("res/Text", arg0_7.launchTenBtn):GetComponent(typeof(Text))
	arg0_7.launchMaxBtn = arg0_7:findTF("left_panel/launch_max_btn")
	arg0_7.launchMaxBtnTxt = arg0_7:findTF("res/Text", arg0_7.launchMaxBtn):GetComponent(typeof(Text))
	arg0_7.awardsCounttxt = arg0_7:findTF("right_panel/count_container/Text"):GetComponent(typeof(Text))
	arg0_7.bgTF = arg0_7:findTF("right_panel"):GetComponent(typeof(Image))
	arg0_7.descBtn = arg0_7:findTF("right_panel/desc_btn")
	arg0_7.bonusWindow = arg0_7:findTF("Msgbox")

	setActive(arg0_7.bonusWindow, false)

	arg0_7.topPanel = arg0_7:findTF("top")
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8:findTF("top/back_btn"), function()
		arg0_8:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)

	local var0_8 = {
		arg0_8.launchOneBtn,
		arg0_8.launchTenBtn,
		arg0_8.launchMaxBtn
	}
	local var1_8 = {
		1,
		10,
		"max"
	}

	for iter0_8, iter1_8 in ipairs(var0_8) do
		GetImageSpriteFromAtlasAsync(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = arg0_8.resId
		}):getIcon(), "", iter1_8:Find("res/icon"), true)
		onButton(arg0_8, iter1_8, function()
			if not arg0_8.activityPool then
				return
			end

			if arg0_8.activityPool ~= arg0_8.showActivityPool then
				pg.TipsMgr.GetInstance():ShowTips(i18n("amercian_notice_5"))

				return
			end

			local var0_10 = arg0_8.activityPool:getleftItemCount()

			if var0_10 == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("activity_pool_awards_empty"))

				return
			end

			local var1_10 = arg0_8.activityPool:getComsume()

			if var1_8[iter0_8] == "max" then
				var0_10 = math.min(var0_10, math.max(math.floor(arg0_8.resCount / var1_10.count), 1))
			else
				var0_10 = math.min(var0_10, var1_8[iter0_8])
			end

			if not arg0_8.activityPool:enoughResForUsage(var0_10) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end

			local function var2_10()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("amercian_notice_1", var0_10 * var1_10.count, var0_10),
					onYes = function()
						arg0_8:emit(LotteryMediator.ON_LAUNCH, arg0_8.activityVO.id, arg0_8.activityPool.id, var0_10, var1_8[iter0_8] == "max")
					end
				})
			end

			if arg0_8.playerVO:OilMax(1) or arg0_8.playerVO:GoldMax(1) then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("amercian_notice_6"),
					onYes = function()
						var2_10()
					end
				})
			else
				var2_10()
			end
		end, SFX_PANEL)
	end

	onButton(arg0_8, arg0_8.descBtn, function()
		if not arg0_8.showActivityPool then
			return
		end

		local var0_14, var1_14 = arg0_8.showActivityPool:getItems()

		arg0_8:showBonus(var0_14, var1_14)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8:findTF("window/top/btnBack", arg0_8.bonusWindow), function()
		setActive(arg0_8.bonusWindow, false)
	end)
	onButton(arg0_8, arg0_8:findTF("window/button", arg0_8.bonusWindow), function()
		setActive(arg0_8.bonusWindow, false)
	end)
	onButton(arg0_8, arg0_8.bonusWindow, function()
		setActive(arg0_8.bonusWindow, false)
	end)

	arg0_8.bgs = {}
	arg0_8.attrTFs = {}

	for iter2_8 = 1, table.getCount(arg0_8.activityPools) do
		local var2_8 = arg0_8.attrs:Find("arr_" .. iter2_8)

		if not IsNil(var2_8) then
			table.insert(arg0_8.attrTFs, var2_8)
		end
	end

	arg0_8:updateResource()
	arg0_8:initPoolTFs()
	arg0_8:updateActivityPoolState()
	triggerToggle(arg0_8.activityPoolTFs[arg0_8.activityPool.id], true)
end

function var0_0.onActivityUpdated(arg0_18, arg1_18)
	arg0_18:setActivity(arg1_18)
	arg0_18:updateActivityPoolState()
	arg0_18:switchToPool(arg1_18.data1)
end

function var0_0.initPoolTFs(arg0_19)
	arg0_19.activityPoolTFs = {}

	for iter0_19, iter1_19 in pairs(arg0_19.activityPools) do
		local var0_19 = arg0_19.lotteryPoolContainer:GetChild(iter1_19.index - 1)

		arg0_19.activityPoolTFs[iter1_19.id] = var0_19

		onToggle(arg0_19, var0_19, function(arg0_20)
			if arg0_20 then
				if not iter1_19.prevId or arg0_19.activityPools[iter1_19.prevId]:canOpenNext() then
					arg0_19:emit(LotteryMediator.ON_SWITCH, arg0_19.activityVO.id, iter1_19.id)
				else
					arg0_19:switchToPool(iter1_19.id)
				end
			end
		end)
	end
end

function var0_0.updateActivityPoolState(arg0_21)
	for iter0_21, iter1_21 in pairs(arg0_21.activityPools) do
		local var0_21 = arg0_21.activityPoolTFs[iter0_21]
		local var1_21 = not iter1_21.prevId or arg0_21.activityPools[iter1_21.prevId]:canOpenNext()

		setActive(var0_21:Find("bg/unlock"), var1_21)
		setActive(var0_21:Find("bg/lock"), not var1_21)
		setActive(var0_21:Find("selected/unlock"), var1_21)
		setActive(var0_21:Find("selected/lock"), not var1_21)

		if var2_0 then
			setActive(var0_21:Find("icon"), var1_21)
			setActive(var0_21:Find("icon_g"), not var1_21)
		end

		local var2_21 = iter1_21:getleftItemCount()

		setActive(var0_21:Find("finish"), var2_21 == 0)

		if arg0_21.attrTFs[iter1_21.index - 1] then
			triggerToggle(arg0_21.attrTFs[iter1_21.index - 1], var1_21)
		end
	end
end

function var0_0.switchToPool(arg0_22, arg1_22)
	local var0_22 = arg0_22.activityPools[arg1_22]
	local var1_22 = arg0_22.activityPoolTFs[arg1_22]

	arg0_22:updateMainItems(var0_22)
	arg0_22:updateAwardsFetchedCount(var0_22)

	local var2_22 = arg0_22.bgs[arg1_22]

	if not var2_22 then
		if var2_0 then
			var2_22 = LoadSprite("lotterybg/cht_" .. var0_22.index)
		else
			var2_22 = LoadSprite("lotterybg/kr_re_" .. var0_22.index)
		end

		arg0_22.bgs[arg1_22] = var2_22
	end

	arg0_22.bgTF.sprite = var2_22

	local var3_22 = var0_22:getComsume()
	local var4_22 = math.min(var0_22:getleftItemCount(), 10)
	local var5_22 = math.min(var0_22:getleftItemCount(), math.max(math.floor(arg0_22.resCount / var3_22.count), 1))

	arg0_22.launchOneBtnTxt.text = var3_22.count
	arg0_22.launchTenBtnTxt.text = var3_22.count * var4_22
	arg0_22.launchMaxBtnTxt.text = var3_22.count * var5_22
	arg0_22.showActivityPool = arg0_22.activityPools[var0_22.id]
end

function var0_0.updateAwardsFetchedCount(arg0_23, arg1_23)
	if arg0_23.awardsCounttxt then
		local var0_23 = arg1_23:getFetchCount()
		local var1_23 = arg1_23:getItemCount()

		arg0_23.awardsCounttxt.text = setColorStr(var1_23 - var0_23, var0_23 < var1_23 and COLOR_GREEN or COLOR_RED) .. "/" .. var1_23
	end
end

function var0_0.updateMainItems(arg0_24, arg1_24)
	local var0_24 = arg1_24:getMainItems()

	for iter0_24 = arg0_24.mainItenContainer.childCount, #var0_24 do
		cloneTplTo(arg0_24.mainItenTpl, arg0_24.mainItenContainer)
	end

	local var1_24 = arg0_24.mainItenContainer.childCount

	for iter1_24 = 1, var1_24 do
		local var2_24 = arg0_24.mainItenContainer:GetChild(iter1_24 - 1)
		local var3_24 = iter1_24 <= #var0_24

		setActive(var2_24, var3_24)

		if var3_24 then
			local var4_24 = var0_24[iter1_24]

			updateDrop(var2_24, var4_24)
			setActive(var2_24:Find("mask"), var4_24.surplus <= 0)
			setText(var2_24:Find("icon_bg/surplus"), "X" .. (var4_24.surplus or ""))
			onButton(arg0_24, var2_24, function()
				arg0_24:emit(var0_0.ON_DROP, var4_24)
			end, SFX_PANEL)
		end
	end
end

function var0_0.showBonus(arg0_26, arg1_26, arg2_26)
	setActive(arg0_26.bonusWindow, true)

	arg0_26.awardMain = arg1_26
	arg0_26.awardNormal = arg2_26
	arg0_26.trDropTpl = arg0_26:findTF("Msgbox/window/items/scrollview/item")
	arg0_26.trDrops = arg0_26:findTF("Msgbox/window/items/scrollview/list/list_main")
	arg0_26.dropList = UIItemList.New(arg0_26.trDrops, arg0_26.trDropTpl)

	arg0_26.dropList:make(function(arg0_27, arg1_27, arg2_27)
		arg0_26:updateDrop(arg0_27, arg1_27, arg2_27, arg0_26.awardMain)
	end)
	arg0_26.dropList:align(#arg0_26.awardMain)

	arg0_26.trDropsN = arg0_26:findTF("Msgbox/window/items/scrollview/list/list_normal")
	arg0_26.dropListN = UIItemList.New(arg0_26.trDropsN, arg0_26.trDropTpl)

	arg0_26.dropListN:make(function(arg0_28, arg1_28, arg2_28)
		arg0_26:updateDrop(arg0_28, arg1_28, arg2_28, arg0_26.awardNormal)
	end)
	arg0_26.dropListN:align(#arg0_26.awardNormal)
end

function var0_0.updateDrop(arg0_29, arg1_29, arg2_29, arg3_29, arg4_29)
	if arg1_29 == UIItemList.EventUpdate then
		local var0_29 = arg4_29[arg2_29 + 1]

		updateDrop(arg3_29, var0_29)
		setText(arg3_29:Find("count"), var0_29.surplus .. "/" .. var0_29.total)
		setActive(arg3_29:Find("mask"), var0_29.surplus <= 0)
		setScrollText(findTF(arg3_29, "name_mask/name"), var0_29.name or var0_29:getConfig("name"))
	end
end

function var0_0.willExit(arg0_30)
	arg0_30.bgs = nil
end

return var0_0
