local var0 = class("OtherWorldTempleScene", import("..base.BaseUI"))
local var1 = 3
local var2 = "other_world_temple_toggle_1"
local var3 = "other_world_temple_toggle_2"
local var4 = "other_world_temple_toggle_3"
local var5 = "other_world_temple_char"
local var6 = "other_world_temple_award"
local var7 = "other_world_temple_got"
local var8 = "other_world_temple_progress"
local var9 = "other_world_temple_char_title"
local var10 = "other_world_temple_lottery_all"
local var11 = "other_world_temple_award_desc"
local var12 = "other_world_temple_pay"
local var13 = "temple_consume_not_enough"
local var14 = 30

function var0.getUIName(arg0)
	return "OtherWorldTempleUI"
end

function var0.init(arg0)
	arg0.templeIds = pg.activity_template[ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID].config_data
	arg0.shopDatas = {}

	for iter0, iter1 in ipairs(arg0.templeIds) do
		local var0 = pg.activity_random_award_template[iter1]
		local var1 = {}

		for iter2, iter3 in ipairs(var0.item_list) do
			table.insert(var1, {
				id = iter3[1],
				count = iter3[2]
			})
		end

		table.insert(arg0.shopDatas, var1)
	end

	arg0.charIds = {}

	for iter4, iter5 in ipairs(pg.guardian_template.all) do
		local var2 = pg.guardian_template[iter5]

		if table.contains(arg0.templeIds, var2.guardian_gain_pool) then
			table.insert(arg0.charIds, iter5)
		end
	end
end

function var0.didEnter(arg0)
	local var0 = findTF(arg0._tf, "ad")
	local var1 = findTF(arg0._tf, "pop")

	arg0.picTf = findTF(var0, "pic")

	onButton(arg0, findTF(var0, "btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, findTF(var0, "btnHelp"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.other_world_temple_tip.tip
		})
	end, SFX_CONFIRM)

	arg0.pageToggles = {}

	for iter0 = 1, var1 do
		local var2 = findTF(var0, "pageToggle/bg/" .. iter0)

		table.insert(arg0.pageToggles, var2)
		onButton(arg0, var2, function()
			local var0 = iter0

			arg0:selectPage(var0)
			arg0:updateUI()
		end, SFX_CONFIRM)
	end

	onButton(arg0, findTF(var0, "btnDetail"), function()
		arg0:emit(OtherWorldTempleMediator.OPEN_TERMINAL)
	end, SFX_CONFIRM)
	onButton(arg0, findTF(var0, "btnAward"), function()
		arg0._awardPage:updateSelect(arg0._selectIndex)
		arg0._awardPage:setActive(true)
	end, SFX_CONFIRM)
	onButton(arg0, findTF(var0, "btnPay"), function()
		local var0 = arg0.activityPools[arg0.templeIds[arg0._selectIndex]]:getleftItemCount()
		local var1 = arg0.lotteryCount

		if var0 < var1 then
			var1 = var0
		end

		local var2 = arg0:getResCount()
		local var3 = arg0:getConsume() * var1

		if var1 > 0 and var3 <= var2 then
			if arg0.activity.data1 ~= arg0.templeIds[arg0._selectIndex] then
				pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
					cmd = 2,
					activity_id = ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID,
					arg1 = arg0.templeIds[arg0._selectIndex]
				})

				function arg0._payToLotterCallback()
					arg0:payToLottery(var1)
				end
			else
				arg0:payToLottery(var1)
			end
		elseif var2 < var3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var13))
		end
	end, SFX_CONFIRM)
	onButton(arg0, findTF(var0, "btnChars"), function()
		arg0._charPage:updateSelect()
		arg0._charPage:setActive(true)
	end, SFX_CONFIRM)
	onButton(arg0, findTF(var0, "btnMain"), function()
		arg0:emit(BaseUI.ON_HOME)
	end, SFX_CONFIRM)

	arg0._coinText = findTF(var0, "coin/text")
	arg0._charPage = OtherWorldTempleChars.New(findTF(arg0._tf, "pop/charPage"), arg0)

	arg0._charPage:setData(arg0.charIds)

	arg0._awardPage = OtherWorldTempleAward.New(findTF(arg0._tf, "pop/awardPage"), arg0)

	arg0._awardPage:setData(arg0.templeIds, arg0.shopDatas)
	arg0._charPage:setActive(false)
	arg0._awardPage:setActive(false)
	setText(findTF(var0, "pageToggle/bg/1/unSelect/text"), i18n(var2))
	setText(findTF(var0, "pageToggle/bg/2/unSelect/text"), i18n(var3))
	setText(findTF(var0, "pageToggle/bg/3/unSelect/text"), i18n(var4))
	setText(findTF(var0, "btnChars/img/text"), i18n(var5))
	setText(findTF(var0, "btnAward/img/text"), i18n(var6))
	setText(findTF(var0, "desc/text"), i18n(var11))
	setText(findTF(var0, "btnComplete/img/text"), i18n(var10))
	arg0:selectPage(1)
	arg0:updateActivity()
end

function var0.payToLottery(arg0, arg1)
	if arg0.waitActivityUpdate == true then
		return
	end

	arg0.checkCharAward = true
	arg0.waitActivityUpdate = true
	arg0.poolFetchCount = arg0.activityPools[arg0.templeIds[arg0._selectIndex]]:getFetchCount()

	pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 1,
		activity_id = ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID,
		arg1 = arg1,
		arg2 = arg0.templeIds[arg0._selectIndex]
	})
end

function var0.selectPage(arg0, arg1)
	arg0._lastSelectIndex = arg0._selectIndex
	arg0._selectIndex = arg1

	for iter0 = 1, var1 do
		local var0 = arg0.pageToggles[iter0]

		setActive(findTF(var0, "select"), iter0 == arg0._selectIndex)
		setActive(findTF(var0, "unSelect"), iter0 ~= arg0._selectIndex)

		if not arg0._lastSelectIndex then
			local var1 = iter0 == arg0._selectIndex and "alphaOn" or "alphaOff"

			GetComponent(findTF(arg0.picTf, "img/" .. iter0), typeof(Animator)):SetTrigger(var1)
		elseif arg0._selectIndex ~= arg0._lastSelectIndex then
			if arg0._lastSelectIndex < arg0._selectIndex then
				GetComponent(findTF(arg0.picTf, "img/" .. arg0._lastSelectIndex), typeof(Animator)):SetTrigger("leftOut")
				GetComponent(findTF(arg0.picTf, "img/" .. arg0._selectIndex), typeof(Animator)):SetTrigger("rightIn")
			else
				GetComponent(findTF(arg0.picTf, "img/" .. arg0._lastSelectIndex), typeof(Animator)):SetTrigger("rightOut")
				GetComponent(findTF(arg0.picTf, "img/" .. arg0._selectIndex), typeof(Animator)):SetTrigger("leftIn")
			end
		end
	end

	local var2 = arg0:getResIconPath()

	LoadImageSpriteAsync(var2, findTF(arg0._tf, "ad/pt/img/icon"), false)
	LoadImageSpriteAsync(var2, findTF(arg0._tf, "ad/btnPay/img/icon"), false)
end

function var0.updateUI(arg0)
	local var0 = arg0:getConsume()
	local var1 = arg0:getResCount()
	local var2 = arg0.activityPools[arg0.templeIds[arg0._selectIndex]]:getleftItemCount()
	local var3 = math.min(var2, var14)
	local var4 = math.floor(var1 / var0)

	arg0.lotteryCount = math.min(var3, var4)

	if arg0.lotteryCount <= 0 then
		arg0.lotteryCount = 1
	end

	local var5 = arg0:getConsume() * arg0.lotteryCount

	setText(findTF(arg0._tf, "ad/btnPay/img/text"), var5)
	setText(findTF(arg0._tf, "ad/btnPay/img/desc"), i18n(var12, arg0.lotteryCount))
	setText(findTF(arg0._tf, "ad/pt/img/text"), var1)
	setActive(findTF(arg0._tf, "ad/btnPay"), var2 > 0)
	setActive(findTF(arg0._tf, "ad/btnComplete"), var2 <= 0)

	arg0.grayComponent = GetComponent(findTF(arg0._tf, "ad/btnComplete/img/bg"), typeof("UIGrayScale"))
	arg0.grayComponent.enabled = false

	onNextTick(function()
		if arg0.grayComponent then
			arg0.grayComponent.enabled = true
		end
	end)
end

function var0.getResCount(arg0)
	local var0 = getProxy(PlayerProxy):getData()
	local var1 = pg.activity_random_award_template[arg0.templeIds[arg0._selectIndex]].resource_type

	return var0:getResById(var1) or 0
end

function var0.getConsume(arg0)
	return pg.activity_random_award_template[arg0.templeIds[arg0._selectIndex]].resource_num
end

function var0.getResIconPath(arg0)
	return Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = pg.activity_random_award_template[arg0.templeIds[arg0._selectIndex]].resource_type
	}):getIcon()
end

function var0.updateActivity(arg0)
	arg0.activity = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID)
	arg0.awardInfos = arg0.activity:getAwardInfos()
	arg0.activityPools = {}

	for iter0, iter1 in ipairs(arg0.templeIds) do
		local var0 = ActivityItemPool.New({
			id = iter1,
			awards = arg0.awardInfos[iter1],
			index = iter0
		})

		arg0.activityPools[var0.id] = var0
	end

	if arg0._payToLotterCallback then
		print("活动数据更新,当前奖池" .. arg0.activity.data1)
		arg0._payToLotterCallback()

		arg0._payToLotterCallback = nil
	else
		arg0:updateUI()
		arg0._awardPage:updateActivityPool(arg0.activityPools)
		arg0._charPage:updateActivityPool(arg0.activityPools)
	end

	arg0.waitActivityUpdate = false
end

function var0.displayTempleCharAward(arg0)
	if arg0.checkCharAward then
		local var0 = arg0.activityPools[arg0.templeIds[arg0._selectIndex]]

		if var0:getFetchCount() == arg0.poolFetchCount then
			return
		end

		arg0.checkCharAward = false

		local var1 = var0:getTempleNewChar(arg0.poolFetchCount)

		if var1 and #var1 > 0 then
			local var2 = {}

			for iter0, iter1 in ipairs(var1) do
				local var3 = pg.guardian_template[iter1].drop

				for iter2, iter3 in ipairs(var3) do
					table.insert(var2, Drop.New({
						type = iter3[1],
						id = iter3[2],
						count = iter3[3]
					}))
				end
			end

			arg0:emit(OtherWorldTempleMediator.SHOW_CHAR_AWARDS, var2)
		end
	end
end

return var0
