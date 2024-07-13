local var0_0 = class("OtherWorldTempleScene", import("..base.BaseUI"))
local var1_0 = 3
local var2_0 = "other_world_temple_toggle_1"
local var3_0 = "other_world_temple_toggle_2"
local var4_0 = "other_world_temple_toggle_3"
local var5_0 = "other_world_temple_char"
local var6_0 = "other_world_temple_award"
local var7_0 = "other_world_temple_got"
local var8_0 = "other_world_temple_progress"
local var9_0 = "other_world_temple_char_title"
local var10_0 = "other_world_temple_lottery_all"
local var11_0 = "other_world_temple_award_desc"
local var12_0 = "other_world_temple_pay"
local var13_0 = "temple_consume_not_enough"
local var14_0 = 30

function var0_0.getUIName(arg0_1)
	return "OtherWorldTempleUI"
end

function var0_0.init(arg0_2)
	arg0_2.templeIds = pg.activity_template[ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID].config_data
	arg0_2.shopDatas = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.templeIds) do
		local var0_2 = pg.activity_random_award_template[iter1_2]
		local var1_2 = {}

		for iter2_2, iter3_2 in ipairs(var0_2.item_list) do
			table.insert(var1_2, {
				id = iter3_2[1],
				count = iter3_2[2]
			})
		end

		table.insert(arg0_2.shopDatas, var1_2)
	end

	arg0_2.charIds = {}

	for iter4_2, iter5_2 in ipairs(pg.guardian_template.all) do
		local var2_2 = pg.guardian_template[iter5_2]

		if table.contains(arg0_2.templeIds, var2_2.guardian_gain_pool) then
			table.insert(arg0_2.charIds, iter5_2)
		end
	end
end

function var0_0.didEnter(arg0_3)
	local var0_3 = findTF(arg0_3._tf, "ad")
	local var1_3 = findTF(arg0_3._tf, "pop")

	arg0_3.picTf = findTF(var0_3, "pic")

	onButton(arg0_3, findTF(var0_3, "btnBack"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, findTF(var0_3, "btnHelp"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.other_world_temple_tip.tip
		})
	end, SFX_CONFIRM)

	arg0_3.pageToggles = {}

	for iter0_3 = 1, var1_0 do
		local var2_3 = findTF(var0_3, "pageToggle/bg/" .. iter0_3)

		table.insert(arg0_3.pageToggles, var2_3)
		onButton(arg0_3, var2_3, function()
			local var0_6 = iter0_3

			arg0_3:selectPage(var0_6)
			arg0_3:updateUI()
		end, SFX_CONFIRM)
	end

	onButton(arg0_3, findTF(var0_3, "btnDetail"), function()
		arg0_3:emit(OtherWorldTempleMediator.OPEN_TERMINAL)
	end, SFX_CONFIRM)
	onButton(arg0_3, findTF(var0_3, "btnAward"), function()
		arg0_3._awardPage:updateSelect(arg0_3._selectIndex)
		arg0_3._awardPage:setActive(true)
	end, SFX_CONFIRM)
	onButton(arg0_3, findTF(var0_3, "btnPay"), function()
		local var0_9 = arg0_3.activityPools[arg0_3.templeIds[arg0_3._selectIndex]]:getleftItemCount()
		local var1_9 = arg0_3.lotteryCount

		if var0_9 < var1_9 then
			var1_9 = var0_9
		end

		local var2_9 = arg0_3:getResCount()
		local var3_9 = arg0_3:getConsume() * var1_9

		if var1_9 > 0 and var3_9 <= var2_9 then
			if arg0_3.activity.data1 ~= arg0_3.templeIds[arg0_3._selectIndex] then
				pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
					cmd = 2,
					activity_id = ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID,
					arg1 = arg0_3.templeIds[arg0_3._selectIndex]
				})

				function arg0_3._payToLotterCallback()
					arg0_3:payToLottery(var1_9)
				end
			else
				arg0_3:payToLottery(var1_9)
			end
		elseif var2_9 < var3_9 then
			pg.TipsMgr.GetInstance():ShowTips(i18n(var13_0))
		end
	end, SFX_CONFIRM)
	onButton(arg0_3, findTF(var0_3, "btnChars"), function()
		arg0_3._charPage:updateSelect()
		arg0_3._charPage:setActive(true)
	end, SFX_CONFIRM)
	onButton(arg0_3, findTF(var0_3, "btnMain"), function()
		arg0_3:emit(BaseUI.ON_HOME)
	end, SFX_CONFIRM)

	arg0_3._coinText = findTF(var0_3, "coin/text")
	arg0_3._charPage = OtherWorldTempleChars.New(findTF(arg0_3._tf, "pop/charPage"), arg0_3)

	arg0_3._charPage:setData(arg0_3.charIds)

	arg0_3._awardPage = OtherWorldTempleAward.New(findTF(arg0_3._tf, "pop/awardPage"), arg0_3)

	arg0_3._awardPage:setData(arg0_3.templeIds, arg0_3.shopDatas)
	arg0_3._charPage:setActive(false)
	arg0_3._awardPage:setActive(false)
	setText(findTF(var0_3, "pageToggle/bg/1/unSelect/text"), i18n(var2_0))
	setText(findTF(var0_3, "pageToggle/bg/2/unSelect/text"), i18n(var3_0))
	setText(findTF(var0_3, "pageToggle/bg/3/unSelect/text"), i18n(var4_0))
	setText(findTF(var0_3, "btnChars/img/text"), i18n(var5_0))
	setText(findTF(var0_3, "btnAward/img/text"), i18n(var6_0))
	setText(findTF(var0_3, "desc/text"), i18n(var11_0))
	setText(findTF(var0_3, "btnComplete/img/text"), i18n(var10_0))
	arg0_3:selectPage(1)
	arg0_3:updateActivity()
end

function var0_0.payToLottery(arg0_13, arg1_13)
	if arg0_13.waitActivityUpdate == true then
		return
	end

	arg0_13.checkCharAward = true
	arg0_13.waitActivityUpdate = true
	arg0_13.poolFetchCount = arg0_13.activityPools[arg0_13.templeIds[arg0_13._selectIndex]]:getFetchCount()

	pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 1,
		activity_id = ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID,
		arg1 = arg1_13,
		arg2 = arg0_13.templeIds[arg0_13._selectIndex]
	})
end

function var0_0.selectPage(arg0_14, arg1_14)
	arg0_14._lastSelectIndex = arg0_14._selectIndex
	arg0_14._selectIndex = arg1_14

	for iter0_14 = 1, var1_0 do
		local var0_14 = arg0_14.pageToggles[iter0_14]

		setActive(findTF(var0_14, "select"), iter0_14 == arg0_14._selectIndex)
		setActive(findTF(var0_14, "unSelect"), iter0_14 ~= arg0_14._selectIndex)

		if not arg0_14._lastSelectIndex then
			local var1_14 = iter0_14 == arg0_14._selectIndex and "alphaOn" or "alphaOff"

			GetComponent(findTF(arg0_14.picTf, "img/" .. iter0_14), typeof(Animator)):SetTrigger(var1_14)
		elseif arg0_14._selectIndex ~= arg0_14._lastSelectIndex then
			if arg0_14._lastSelectIndex < arg0_14._selectIndex then
				GetComponent(findTF(arg0_14.picTf, "img/" .. arg0_14._lastSelectIndex), typeof(Animator)):SetTrigger("leftOut")
				GetComponent(findTF(arg0_14.picTf, "img/" .. arg0_14._selectIndex), typeof(Animator)):SetTrigger("rightIn")
			else
				GetComponent(findTF(arg0_14.picTf, "img/" .. arg0_14._lastSelectIndex), typeof(Animator)):SetTrigger("rightOut")
				GetComponent(findTF(arg0_14.picTf, "img/" .. arg0_14._selectIndex), typeof(Animator)):SetTrigger("leftIn")
			end
		end
	end

	local var2_14 = arg0_14:getResIconPath()

	LoadImageSpriteAsync(var2_14, findTF(arg0_14._tf, "ad/pt/img/icon"), false)
	LoadImageSpriteAsync(var2_14, findTF(arg0_14._tf, "ad/btnPay/img/icon"), false)
end

function var0_0.updateUI(arg0_15)
	local var0_15 = arg0_15:getConsume()
	local var1_15 = arg0_15:getResCount()
	local var2_15 = arg0_15.activityPools[arg0_15.templeIds[arg0_15._selectIndex]]:getleftItemCount()
	local var3_15 = math.min(var2_15, var14_0)
	local var4_15 = math.floor(var1_15 / var0_15)

	arg0_15.lotteryCount = math.min(var3_15, var4_15)

	if arg0_15.lotteryCount <= 0 then
		arg0_15.lotteryCount = 1
	end

	local var5_15 = arg0_15:getConsume() * arg0_15.lotteryCount

	setText(findTF(arg0_15._tf, "ad/btnPay/img/text"), var5_15)
	setText(findTF(arg0_15._tf, "ad/btnPay/img/desc"), i18n(var12_0, arg0_15.lotteryCount))
	setText(findTF(arg0_15._tf, "ad/pt/img/text"), var1_15)
	setActive(findTF(arg0_15._tf, "ad/btnPay"), var2_15 > 0)
	setActive(findTF(arg0_15._tf, "ad/btnComplete"), var2_15 <= 0)

	arg0_15.grayComponent = GetComponent(findTF(arg0_15._tf, "ad/btnComplete/img/bg"), typeof("UIGrayScale"))
	arg0_15.grayComponent.enabled = false

	onNextTick(function()
		if arg0_15.grayComponent then
			arg0_15.grayComponent.enabled = true
		end
	end)
end

function var0_0.getResCount(arg0_17)
	local var0_17 = getProxy(PlayerProxy):getData()
	local var1_17 = pg.activity_random_award_template[arg0_17.templeIds[arg0_17._selectIndex]].resource_type

	return var0_17:getResById(var1_17) or 0
end

function var0_0.getConsume(arg0_18)
	return pg.activity_random_award_template[arg0_18.templeIds[arg0_18._selectIndex]].resource_num
end

function var0_0.getResIconPath(arg0_19)
	return Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = pg.activity_random_award_template[arg0_19.templeIds[arg0_19._selectIndex]].resource_type
	}):getIcon()
end

function var0_0.updateActivity(arg0_20)
	arg0_20.activity = getProxy(ActivityProxy):getActivityById(ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID)
	arg0_20.awardInfos = arg0_20.activity:getAwardInfos()
	arg0_20.activityPools = {}

	for iter0_20, iter1_20 in ipairs(arg0_20.templeIds) do
		local var0_20 = ActivityItemPool.New({
			id = iter1_20,
			awards = arg0_20.awardInfos[iter1_20],
			index = iter0_20
		})

		arg0_20.activityPools[var0_20.id] = var0_20
	end

	if arg0_20._payToLotterCallback then
		print("活动数据更新,当前奖池" .. arg0_20.activity.data1)
		arg0_20._payToLotterCallback()

		arg0_20._payToLotterCallback = nil
	else
		arg0_20:updateUI()
		arg0_20._awardPage:updateActivityPool(arg0_20.activityPools)
		arg0_20._charPage:updateActivityPool(arg0_20.activityPools)
	end

	arg0_20.waitActivityUpdate = false
end

function var0_0.displayTempleCharAward(arg0_21)
	if arg0_21.checkCharAward then
		local var0_21 = arg0_21.activityPools[arg0_21.templeIds[arg0_21._selectIndex]]

		if var0_21:getFetchCount() == arg0_21.poolFetchCount then
			return
		end

		arg0_21.checkCharAward = false

		local var1_21 = var0_21:getTempleNewChar(arg0_21.poolFetchCount)

		if var1_21 and #var1_21 > 0 then
			local var2_21 = {}

			for iter0_21, iter1_21 in ipairs(var1_21) do
				local var3_21 = pg.guardian_template[iter1_21].drop

				for iter2_21, iter3_21 in ipairs(var3_21) do
					table.insert(var2_21, Drop.New({
						type = iter3_21[1],
						id = iter3_21[2],
						count = iter3_21[3]
					}))
				end
			end

			arg0_21:emit(OtherWorldTempleMediator.SHOW_CHAR_AWARDS, var2_21)
		end
	end
end

return var0_0
