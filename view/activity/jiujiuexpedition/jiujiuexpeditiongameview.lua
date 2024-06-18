local var0_0 = class("JiuJiuExpeditionGameView", import("...base.BaseUI"))
local var1_0 = 50
local var2_0 = 153
local var3_0 = 175
local var4_0 = 16

function var0_0.getUIName(arg0_1)
	return "JiuJiuExpeditionGameView"
end

function var0_0.init(arg0_2)
	arg0_2.isTweening = 0
end

function var0_0.onBackPressed(arg0_3)
	if arg0_3.isTweening > 0 then
		return
	end

	arg0_3:emit(var0_0.ON_BACK_PRESSED)
end

function var0_0.didEnter(arg0_4)
	arg0_4.activityId = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXPEDITION).id

	print(arg0_4.activityId)

	if not arg0_4.activityId then
		arg0_4:closeView()

		return
	end

	local var0_4 = pg.activity_template[arg0_4.activityId].config_data

	arg0_4.stgDatas = var0_4
	arg0_4.stgAmount = #var0_4
	arg0_4.uiAtlasName = arg0_4:getUIName()

	local var1_4 = findTF(arg0_4._tf, "ad")

	onButton(arg0_4, findTF(var1_4, "back"), function()
		if arg0_4.isTweening > 0 then
			return
		end

		arg0_4:closeView()
	end, SFX_CONFIRM)

	arg0_4.tplStgTag = findTF(var1_4, "posStgTag/tplStgTag")
	arg0_4.bookUnLock = findTF(var1_4, "leftUI/bookUnLock")

	setActive(arg0_4.bookUnLock, false)

	arg0_4.amountText = findTF(var1_4, "rightUI/amount/text")

	setText(arg0_4.amountText, "")

	arg0_4.stgText = findTF(var1_4, "upUI/labelStg")
	arg0_4.posCharactor = findTF(var1_4, "map/posChar")
	arg0_4.charactor = findTF(var1_4, "map/posChar/charactor")
	arg0_4.tplBaoxiang = findTF(var1_4, "map/posChar/tplBaoxiang")

	setActive(arg0_4.tplBaoxiang, false)

	arg0_4.baoxiangList = {}
	arg0_4.poolBaoxiangList = {}
	arg0_4.stgProgress = findTF(var1_4, "upUI/labelStgProgress")

	setText(arg0_4.stgProgress, "0%")

	arg0_4.posStgTag = findTF(var1_4, "posStgTag")
	arg0_4.stgTags = {}

	for iter0_4 = 1, arg0_4.stgAmount do
		local var2_4 = tf(instantiate(arg0_4.tplStgTag))

		setImageSprite(findTF(var2_4, "open/desc"), GetSpriteFromAtlas("ui/" .. arg0_4.uiAtlasName .. "_atlas", "stg" .. iter0_4), true)
		setParent(var2_4, arg0_4.posStgTag)
		setActive(var2_4, true)
		table.insert(arg0_4.stgTags, var2_4)

		local var3_4 = iter0_4

		onButton(arg0_4, var2_4, function()
			if arg0_4.level < var3_4 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("jiujiu_expedition_stg_tip"))
			else
				arg0_4:changeSelectTag(var3_4)
			end
		end, SFX_CONFIRM)
	end

	arg0_4.mapCloseBg = findTF(var1_4, "map/closeBg")
	arg0_4.mapOpenBg = findTF(var1_4, "map/openBg/bg")
	arg0_4.mapClearBg = findTF(var1_4, "map/openBg/clear")
	arg0_4.enterBossUI = findTF(arg0_4._tf, "pop/enterBossUI")
	arg0_4.posMask = findTF(var1_4, "map/openBg/posMask")
	arg0_4.tplBgMask = findTF(var1_4, "map/openBg/posMask/tplMask")
	arg0_4.poolMasks = {}
	arg0_4.posBottom = findTF(var1_4, "map/posBottom")
	arg0_4.tplBottomGrid = findTF(var1_4, "map/posBottom/tplBottomGrid")
	arg0_4.poolBottomGrids = {}
	arg0_4.posUp = findTF(var1_4, "map/posUp")
	arg0_4.tplUpGrid = findTF(var1_4, "map/posUp/tplUpGrid")
	arg0_4.poolUpGrids = {}
	arg0_4.mapDic = {}

	onButton(arg0_4, findTF(arg0_4.enterBossUI, "sure"), function()
		arg0_4:enterBattle()
	end, SFX_CONFIRM)
	onButton(arg0_4, findTF(arg0_4.enterBossUI, "cancel"), function()
		arg0_4:hideEnterBossUI()
	end, SFX_CONFIRM)
	onButton(arg0_4, findTF(var1_4, "help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_jiujiu_expedition_game.tip
		})
	end, SFX_CONFIRM)
	pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 0,
		activity_id = arg0_4.activityId
	})
	arg0_4:SwitchToDefaultBGM()
end

function var0_0.activityUpdate(arg0_10)
	local var0_10 = getProxy(ActivityProxy):getActivityById(arg0_10.activityId)

	arg0_10.level = var0_10.data1 == 0 and arg0_10.stgAmount + 1 or var0_10.data1
	arg0_10.complete = var0_10.data1 == 0
	arg0_10.charPos = var0_10.data2
	arg0_10.tickets = var0_10.data3
	arg0_10.gridTypes = var0_10.data1_list

	if PLATFORM_CODE == PLATFORM_JP then
		local var1_10, var2_10, var3_10, var4_10 = JiuJiuExpeditionCollectionMediator.GetCollectionData()

		if arg0_10.getRewardIndex ~= var3_10 then
			arg0_10.getRewardIndex = var3_10

			if var4_10 < var3_10 then
				arg0_10:showBookUnLock()
			else
				setActive(arg0_10.bookUnLock, false)
			end
		end
	end

	arg0_10.completeBossId = var0_10.data4
	arg0_10.inMessage = false

	if #arg0_10.gridTypes == 0 then
		arg0_10.curSelectLevel = arg0_10.stgAmount
		arg0_10.chequerConfig = pg.activity_event_chequer[arg0_10.stgDatas[arg0_10.curSelectLevel]]
		arg0_10.chequerMap = Clone(arg0_10.chequerConfig.chequer_map)

		for iter0_10 = 1, arg0_10.chequerMap[1] * arg0_10.chequerMap[2] do
			table.insert(arg0_10.gridTypes, ActivityConst.EXPEDITION_TYPE_GOT)
		end
	end

	arg0_10:changeSelectTag(arg0_10.level <= arg0_10.stgAmount and arg0_10.level or arg0_10.stgAmount)
end

function var0_0.showBookUnLock(arg0_11)
	setImageAlpha(arg0_11.bookUnLock, 1)
	setActive(arg0_11.bookUnLock, true)

	if LeanTween.isTweening(go(arg0_11.bookUnLock)) then
		LeanTween.cancel(go(arg0_11.bookUnLock))
	end

	LeanTween.delayedCall(go(arg0_11.bookUnLock), 3, System.Action(function()
		LeanTween.alpha(rtf(arg0_11.bookUnLock), 0, 2)
	end))
end

function var0_0.showBaoxiang(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	arg0_13.isTweening = arg0_13.isTweening + 1

	LeanTween.delayedCall(go(arg4_13), 0.5, System.Action(function()
		local var0_14, var1_14 = arg0_13:getPosition(arg1_13, arg2_13)

		arg4_13.localPosition = Vector3(var0_14, var1_14 + 50, -1)

		setActive(arg4_13, true)
		setActive(findTF(arg4_13, "baoxiang_guan"), true)
		LeanTween.moveLocal(go(arg4_13), Vector3(var0_14, var1_14, -1), 0.2)

		arg0_13.isTweening = arg0_13.isTweening - 1

		onButton(arg0_13, arg4_13, function()
			if not arg0_13.isMoveChar and not arg0_13.isOpenBaoxiang then
				arg0_13.isOpenBaoxiang = true

				arg0_13:openBaoxiang(arg4_13, arg3_13)
			end
		end)
	end))
end

function var0_0.openBaoxiang(arg0_16, arg1_16, arg2_16)
	setActive(findTF(arg1_16, "baoxiang_guan"), false)
	setActive(findTF(arg1_16, "baoxiang_kai"), true)

	arg0_16.isTweening = arg0_16.isTweening + 1

	LeanTween.delayedCall(go(arg1_16), 1, System.Action(function()
		arg0_16.isTweening = arg0_16.isTweening - 1

		arg0_16:getGridReward(arg2_16)

		for iter0_17 = #arg0_16.baoxiangList, 1, -1 do
			if arg0_16.baoxiangList[iter0_17].tf == arg1_16 then
				table.remove(arg0_16.baoxiangList, iter0_17)
			end
		end

		arg0_16:returnBaoxiang(arg1_16)

		arg0_16.isOpenBaoxiang = false
	end))
end

function var0_0.changeSelectTag(arg0_18, arg1_18)
	local var0_18 = arg1_18 ~= arg0_18.curSelectLevel

	arg0_18.curSelectLevel = arg1_18

	arg0_18:selectTagChange(var0_18)
end

function var0_0.selectTagChange(arg0_19, arg1_19)
	if arg0_19.curSelectLevel > arg0_19.level then
		arg0_19:changeSelectTag(arg0_19.level)

		return
	end

	arg0_19:clear(arg1_19)
	arg0_19:updateConfig()
	arg0_19:updateTag()
	arg0_19:updateMap()
	arg0_19:updateGridDatas()
	arg0_19:updateCharactor()
	arg0_19:updateUI()
end

function var0_0.updateCharactor(arg0_20)
	if not arg0_20.complete and arg0_20.curSelectLevel == arg0_20.level and arg0_20.charPos > 0 then
		if arg0_20.charPos ~= arg0_20.curCharPos then
			arg0_20.curCharPos = arg0_20.charPos

			local var0_20 = arg0_20:getMapByIndex(arg0_20.charPos)

			if var0_20 then
				arg0_20.isMoveChar = true

				local var1_20, var2_20 = arg0_20:getPosition(var0_20.v, var0_20.h)

				arg0_20:moveChar(var1_20, var2_20, function()
					arg0_20.isMoveChar = false

					arg0_20:checkExpeditionMap()
				end)
			end
		else
			arg0_20:checkExpeditionMap()
		end
	else
		arg0_20.curCharPos = nil

		arg0_20:hideChar()
	end
end

function var0_0.checkExpeditionMap(arg0_22)
	if not arg0_22.expeditionMap or bit.band(arg0_22.expeditionMap.type, ActivityConst.EXPEDITION_TYPE_BAOXIANG) ~= 0 then
		-- block empty
	elseif bit.band(arg0_22.expeditionMap.type, ActivityConst.EXPEDITION_TYPE_OPEN) ~= 0 then
		arg0_22:getGridReward(arg0_22.expeditionMap.mapIndex)
	elseif bit.band(arg0_22.expeditionMap.type, ActivityConst.EXPEDITION_TYPE_BOSS) ~= 0 then
		if arg0_22.expeditionMap.mapIndex == arg0_22.charPos or arg0_22.expeditionMap.mapIndex == arg0_22.completeBossId then
			arg0_22:onClickGrid(arg0_22.expeditionMap)
		end
	else
		arg0_22:onClickGrid(arg0_22.expeditionMap)
	end
end

function var0_0.updateUI(arg0_23)
	setText(arg0_23.amountText, "x" .. arg0_23.tickets)

	local var0_23 = i18n("jiujiu_expedition_game_stg_desc", arg0_23.curSelectLevel or 1)

	setText(arg0_23.stgText, var0_23)

	if arg0_23.level > arg0_23.curSelectLevel then
		setText(arg0_23.stgProgress, "100%")
	else
		local var1_23 = 0

		for iter0_23 = 1, #arg0_23.gridTypes do
			if bit.band(arg0_23.gridTypes[iter0_23], ActivityConst.EXPEDITION_TYPE_GOT) ~= 0 then
				var1_23 = var1_23 + 1
			end
		end

		local var2_23 = math.floor(var1_23 / arg0_23.totalNums * 100)

		setText(arg0_23.stgProgress, var2_23 .. "%")
	end
end

function var0_0.updateGridDatas(arg0_24)
	if arg0_24.curSelectLevel == arg0_24.level then
		for iter0_24 = 1, #arg0_24.gridTypes do
			local var0_24 = arg0_24:getMapActivityType(arg0_24.gridTypes[iter0_24])

			if var0_24 == ActivityConst.EXPEDITION_TYPE_OPEN then
				arg0_24.expeditionMap = arg0_24:getMapByPosNum(iter0_24)
			elseif var0_24 == ActivityConst.EXPEDITION_TYPE_BOSS and (arg0_24.completeBossId == iter0_24 or arg0_24.charPos == iter0_24) then
				arg0_24.expeditionMap = arg0_24:getMapByPosNum(iter0_24)
			end
		end
	end

	for iter1_24 = 1, #arg0_24.mapDic do
		local var1_24 = arg0_24.mapDic[iter1_24]

		if arg0_24.curSelectLevel < arg0_24.level then
			arg0_24:setMapGridType(var1_24, ActivityConst.EXPEDITION_TYPE_GOT)
		else
			local var2_24 = var1_24.mapIndex
			local var3_24 = arg0_24.gridTypes[var2_24]
			local var4_24 = arg0_24:getMapActivityType(var3_24)
			local var5_24 = bit.rshift(var3_24, 4)

			if (arg0_24.charPos <= 0 or not arg0_24.charPos) and arg0_24.tickets > 0 then
				arg0_24:setMapGridType(var1_24, var4_0)
			elseif var4_24 == ActivityConst.EXPEDITION_TYPE_LOCK and arg0_24:getGridSideOpen(var1_24) and arg0_24.tickets > 0 then
				arg0_24:setMapGridType(var1_24, var4_0)
			else
				arg0_24:setMapGridType(var1_24, var4_24, var5_24)
			end
		end
	end
end

function var0_0.getMapActivityType(arg0_25, arg1_25)
	if bit.band(arg1_25, ActivityConst.EXPEDITION_TYPE_GOT) == ActivityConst.EXPEDITION_TYPE_GOT then
		return ActivityConst.EXPEDITION_TYPE_GOT
	elseif bit.band(arg1_25, ActivityConst.EXPEDITION_TYPE_BOSS) == ActivityConst.EXPEDITION_TYPE_BOSS then
		return ActivityConst.EXPEDITION_TYPE_BOSS
	elseif bit.band(arg1_25, ActivityConst.EXPEDITION_TYPE_BAOXIANG) == ActivityConst.EXPEDITION_TYPE_BAOXIANG then
		return ActivityConst.EXPEDITION_TYPE_BAOXIANG
	elseif bit.band(arg1_25, ActivityConst.EXPEDITION_TYPE_OPEN) == ActivityConst.EXPEDITION_TYPE_OPEN then
		return ActivityConst.EXPEDITION_TYPE_OPEN
	end

	return ActivityConst.EXPEDITION_TYPE_LOCK
end

function var0_0.updateConfig(arg0_26)
	arg0_26.chequerConfig = pg.activity_event_chequer[arg0_26.stgDatas[arg0_26.curSelectLevel]]
	arg0_26.chequerMap = Clone(arg0_26.chequerConfig.chequer_map)

	local var0_26 = Clone(arg0_26.chequerConfig.empty_grid)

	arg0_26.emptyPosNums = {}

	for iter0_26 = 1, #var0_26 do
		local var1_26 = arg0_26:getPosNum(var0_26[iter0_26][1], var0_26[iter0_26][2])

		table.insert(arg0_26.emptyPosNums, var1_26)
	end

	arg0_26.totalNums = arg0_26.chequerMap[1] * arg0_26.chequerMap[2] - #arg0_26.emptyPosNums
end

function var0_0.getGridSideOpen(arg0_27, arg1_27)
	local var0_27 = arg1_27.posNum
	local var1_27

	if arg1_27.h % 2 == 1 then
		var1_27 = {
			var0_27 - 1,
			var0_27 + 1,
			var0_27 - arg0_27.chequerMap[2],
			var0_27 + arg0_27.chequerMap[2],
			var0_27 + arg0_27.chequerMap[2] - 1,
			var0_27 + arg0_27.chequerMap[2] + 1
		}
	else
		var1_27 = {
			var0_27 - 1,
			var0_27 + 1,
			var0_27 - arg0_27.chequerMap[2],
			var0_27 + arg0_27.chequerMap[2],
			var0_27 - arg0_27.chequerMap[2] - 1,
			var0_27 - arg0_27.chequerMap[2] + 1
		}
	end

	local var2_27 = arg1_27.v
	local var3_27 = arg1_27.h

	for iter0_27 = #var1_27, 1, -1 do
		local var4_27 = var1_27[iter0_27]
		local var5_27 = math.ceil(var4_27 / arg0_27.chequerMap[2])
		local var6_27 = (var4_27 - 1) % arg0_27.chequerMap[2] + 1

		if math.abs(var5_27 - var2_27) > 1 or math.abs(var6_27 - var3_27) > 1 then
			table.remove(var1_27, iter0_27)
		end
	end

	local var7_27

	for iter1_27 = 1, #var1_27 do
		local var8_27 = arg0_27:getMapByPosNum(var1_27[iter1_27])

		if var8_27 and arg0_27:getMapIndexType(var8_27.mapIndex) == ActivityConst.EXPEDITION_TYPE_GOT then
			return true
		end
	end

	return false
end

function var0_0.getMapByPosNum(arg0_28, arg1_28)
	if arg1_28 <= 0 then
		return nil
	end

	if arg1_28 > arg0_28.chequerMap[2] * arg0_28.chequerMap[1] then
		return nil
	end

	for iter0_28 = 1, #arg0_28.mapDic do
		if arg0_28.mapDic[iter0_28].posNum == arg1_28 then
			return arg0_28.mapDic[iter0_28]
		end
	end

	return nil
end

function var0_0.getMapByIndex(arg0_29, arg1_29)
	for iter0_29 = 1, #arg0_29.mapDic do
		if arg0_29.mapDic[iter0_29].mapIndex == arg1_29 then
			return arg0_29.mapDic[iter0_29]
		end
	end

	return nil
end

function var0_0.getMapIndexType(arg0_30, arg1_30)
	local var0_30 = arg0_30.gridTypes[arg1_30]

	return arg0_30:getMapActivityType(var0_30)
end

function var0_0.updateMap(arg0_31)
	local var0_31 = arg0_31.chequerConfig.difficult

	setImageSprite(arg0_31.mapCloseBg, GetSpriteFromAtlas("ui/" .. arg0_31.uiAtlasName .. "_atlas", "map_close_" .. var0_31), true)
	setImageSprite(arg0_31.mapOpenBg, GetSpriteFromAtlas("ui/" .. arg0_31.uiAtlasName .. "_atlas", "map_open_" .. var0_31), true)
	setImageSprite(arg0_31.mapClearBg, GetSpriteFromAtlas("ui/" .. arg0_31.uiAtlasName .. "_atlas", "map_open_" .. var0_31), true)

	local var1_31 = arg0_31.chequerMap[1]
	local var2_31 = arg0_31.chequerMap[2]

	arg0_31.mapDic = {}

	local var3_31 = 0

	for iter0_31 = 1, var1_31 do
		for iter1_31 = 1, var2_31 do
			local var4_31 = arg0_31:getPosNum(iter0_31, iter1_31)

			var3_31 = var3_31 + 1

			if not table.contains(arg0_31.emptyPosNums, var4_31) then
				local var5_31 = arg0_31:getMask()
				local var6_31 = arg0_31:getBottomGrid()
				local var7_31 = arg0_31:getUpGrid()

				arg0_31:setMapTfPosition(var5_31, iter0_31, iter1_31)
				arg0_31:setMapTfPosition(var6_31, iter0_31, iter1_31)
				arg0_31:setMapTfPosition(var7_31, iter0_31, iter1_31)

				local var8_31 = {
					mask = var5_31,
					bottomGrid = var6_31,
					upGrid = var7_31,
					v = iter0_31,
					h = iter1_31,
					posNum = var4_31,
					mapIndex = var3_31
				}

				onButton(arg0_31, var7_31, function()
					arg0_31:onClickGrid(var8_31)
				end, SFX_CONFIRM)
				table.insert(arg0_31.mapDic, var8_31)
			end
		end
	end
end

function var0_0.setMapGridType(arg0_33, arg1_33, arg2_33, arg3_33)
	arg1_33.type = arg2_33
	arg1_33.params = arg3_33

	local var0_33 = arg1_33.mask
	local var1_33 = arg1_33.bottomGrid

	setActive(var1_33, true)

	local var2_33 = arg1_33.upGrid
	local var3_33 = findTF(var2_33, "select")
	local var4_33 = findTF(var2_33, "boss")
	local var5_33 = findTF(var2_33, "bottomLight")
	local var6_33 = findTF(var2_33, "outLine")

	setActive(var0_33, false)
	setActive(var3_33, false)
	setActive(var6_33, false)
	setActive(var4_33, false)
	setActive(var5_33, false)

	if arg2_33 == ActivityConst.EXPEDITION_TYPE_OPEN or arg2_33 == ActivityConst.EXPEDITION_TYPE_GOT then
		setActive(var3_33, true)
		var2_33:SetAsLastSibling()
	elseif arg2_33 == ActivityConst.EXPEDITION_TYPE_LOCK then
		setActive(var0_33, true)
		setActive(var6_33, true)
	elseif arg2_33 == ActivityConst.EXPEDITION_TYPE_BAOXIANG then
		setActive(var3_33, true)
		arg0_33:addBaoXiang(arg1_33)
		var2_33:SetAsLastSibling()
	elseif arg2_33 == ActivityConst.EXPEDITION_TYPE_BOSS then
		setActive(var3_33, true)
		setActive(var4_33, true)
		var2_33:SetAsLastSibling()
	elseif arg2_33 == var4_0 then
		setActive(var0_33, true)
		setActive(var3_33, true)
		setActive(var5_33, true)
		var2_33:SetAsLastSibling()
	end
end

function var0_0.addBaoXiang(arg0_34, arg1_34)
	for iter0_34 = 1, #arg0_34.baoxiangList do
		if arg0_34.baoxiangList[iter0_34].mapIndex == arg1_34.mapIndex then
			return
		end
	end

	local var0_34 = arg0_34:getBaoxiang()

	arg0_34:showBaoxiang(arg1_34.v, arg1_34.h, arg1_34.mapIndex, var0_34)
	table.insert(arg0_34.baoxiangList, {
		tf = var0_34,
		mapIndex = arg1_34.mapIndex
	})
end

function var0_0.setMapTfPosition(arg0_35, arg1_35, arg2_35, arg3_35)
	local var0_35, var1_35 = arg0_35:getPosition(arg2_35, arg3_35)

	arg1_35.localPosition = Vector3(var0_35, var1_35, 0)
end

function var0_0.updateTag(arg0_36)
	for iter0_36 = 1, #arg0_36.stgTags do
		local var0_36 = arg0_36.stgTags[iter0_36]

		if iter0_36 <= arg0_36.level then
			setActive(findTF(var0_36, "open"), true)
			setActive(findTF(var0_36, "close"), false)
		else
			setActive(findTF(var0_36, "open"), false)
			setActive(findTF(var0_36, "close"), true)
		end

		if iter0_36 == arg0_36.curSelectLevel then
			setActive(findTF(var0_36, "open/on"), true)
			setActive(findTF(var0_36, "open/off"), false)
		else
			setActive(findTF(var0_36, "open/on"), false)
			setActive(findTF(var0_36, "open/off"), true)
		end
	end
end

function var0_0.onClickGrid(arg0_37, arg1_37)
	local var0_37 = arg1_37.type
	local var1_37 = arg1_37.mapIndex
	local var2_37 = arg1_37.v
	local var3_37 = arg1_37.h

	if var0_37 == var4_0 then
		if not arg0_37.isMoveChar then
			arg0_37:openGrid(arg1_37.mapIndex)
		end
	elseif var0_37 == ActivityConst.EXPEDITION_TYPE_BOSS then
		arg0_37.bossId = arg1_37.params

		if arg0_37.completeBossId == arg1_37.mapIndex then
			arg0_37:getGridReward(arg0_37.completeBossId)

			if PLATFORM_CODE == PLATFORM_JP then
				arg0_37:showBookUnLock()
			end
		elseif not arg0_37.isMoveChar and arg0_37.isTweening == 0 and not arg0_37.isOpenBaoxiang then
			arg0_37:showEnterBossUI()
		end
	elseif var0_37 == ActivityConst.EXPEDITION_TYPE_LOCK and arg0_37.tickets <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("jiujiu_expedition_amount_tip"))
	end
end

function var0_0.moveChar(arg0_38, arg1_38, arg2_38, arg3_38)
	if LeanTween.isTweening(go(arg0_38.charactor)) then
		LeanTween.cancel(go(arg0_38.charactor))
	end

	if isActive(arg0_38.charactor) then
		arg0_38:hideChar(function()
			arg0_38:showChar(arg1_38, arg2_38, arg3_38)
		end)
	else
		arg0_38:showChar(arg1_38, arg2_38, arg3_38)
	end
end

function var0_0.showChar(arg0_40, arg1_40, arg2_40, arg3_40)
	arg0_40.charactor.localPosition = Vector3(arg1_40, arg2_40 + var1_0)

	setActive(arg0_40.charactor, true)
	LeanTween.value(go(arg0_40.charactor), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_41)
		GetComponent(arg0_40.charactor, typeof(CanvasGroup)).alpha = arg0_41
	end))
	LeanTween.moveLocal(go(arg0_40.charactor), Vector3(arg1_40, arg2_40, 0), 0.2):setOnComplete(System.Action(function()
		if arg3_40 then
			arg3_40()
		end
	end))
end

function var0_0.hideChar(arg0_43, arg1_43)
	LeanTween.value(go(arg0_43.charactor), 1, 0, 0.2):setOnUpdate(System.Action_float(function(arg0_44)
		GetComponent(arg0_43.charactor, typeof(CanvasGroup)).alpha = arg0_44
	end))

	local var0_43 = arg0_43.charactor.localPosition

	LeanTween.moveLocal(go(arg0_43.charactor), Vector3(var0_43.x, var0_43.y + var1_0, 0), 0.2):setOnComplete(System.Action(function()
		setActive(arg0_43.charactor, false)

		if arg1_43 then
			arg1_43()
		end
	end))
end

function var0_0.enterBattle(arg0_46)
	arg0_46:hideEnterBossUI()
	pg.m02:sendNotification(GAME.BEGIN_STAGE, {
		system = SYSTEM_REWARD_PERFORM,
		stageId = arg0_46.bossId
	})

	arg0_46.bossId = nil
end

function var0_0.openGrid(arg0_47, arg1_47)
	if arg0_47.inMessage then
		return
	end

	arg0_47.inMessage = true

	pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 1,
		activity_id = arg0_47.activityId,
		arg1 = arg1_47
	})
end

function var0_0.getGridReward(arg0_48, arg1_48)
	if arg0_48.inMessage then
		return
	end

	arg0_48.inMessage = true

	pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 2,
		activity_id = arg0_48.activityId,
		arg1 = arg1_48
	})
end

function var0_0.showEnterBossUI(arg0_49)
	pg.UIMgr.GetInstance():BlurPanel(arg0_49.enterBossUI)
	setActive(arg0_49.enterBossUI, true)
end

function var0_0.hideEnterBossUI(arg0_50)
	setActive(arg0_50.enterBossUI, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_50.enterBossUI)
end

function var0_0.getPosNum(arg0_51, arg1_51, arg2_51)
	return (arg1_51 - 1) * arg0_51.chequerMap[2] + arg2_51
end

function var0_0.clear(arg0_52, arg1_52)
	for iter0_52 = 1, #arg0_52.mapDic do
		local var0_52 = arg0_52.mapDic[iter0_52]

		arg0_52:returnBottomGrid(var0_52.bottomGrid)
		arg0_52:returnMask(var0_52.mask)
		arg0_52:returnUpGrid(var0_52.upGrid)
	end

	arg0_52.mapDic = {}

	if arg1_52 then
		for iter1_52 = 1, #arg0_52.baoxiangList do
			if LeanTween.isTweening(go(arg0_52.baoxiangList[iter1_52].tf)) then
				LeanTween.cancel(go(arg0_52.baoxiangList[iter1_52].tf))
			end

			arg0_52:returnBaoxiang(arg0_52.baoxiangList[iter1_52].tf)
		end

		arg0_52.baoxiangList = {}
	end

	arg0_52.expeditionMap = nil
end

function var0_0.getBaoxiang(arg0_53)
	local var0_53

	if #arg0_53.poolBaoxiangList > 0 then
		var0_53 = table.remove(arg0_53.poolBaoxiangList, #arg0_53.poolBaoxiangList)
	else
		var0_53 = tf(instantiate(arg0_53.tplBaoxiang))

		setParent(var0_53, arg0_53.posCharactor)
	end

	setActive(findTF(var0_53, "baoxiang_guan"), true)
	setActive(findTF(var0_53, "baoxiang_kai"), false)

	return var0_53
end

function var0_0.returnBaoxiang(arg0_54, arg1_54)
	setActive(arg1_54, false)
	table.insert(arg0_54.poolBaoxiangList, arg1_54)
end

function var0_0.getMask(arg0_55)
	local var0_55

	if #arg0_55.poolMasks > 0 then
		var0_55 = table.remove(arg0_55.poolMasks, #arg0_55.poolMasks)
	else
		var0_55 = tf(instantiate(arg0_55.tplBgMask))

		setParent(var0_55, arg0_55.posMask)
	end

	setActive(var0_55, true)

	return var0_55
end

function var0_0.returnMask(arg0_56, arg1_56)
	setActive(arg1_56, false)
	table.insert(arg0_56.poolMasks, arg1_56)
end

function var0_0.getBottomGrid(arg0_57)
	local var0_57

	if #arg0_57.poolBottomGrids > 0 then
		var0_57 = table.remove(arg0_57.poolBottomGrids, #arg0_57.poolBottomGrids)
	else
		var0_57 = tf(instantiate(arg0_57.tplBottomGrid))

		setParent(var0_57, arg0_57.posBottom)
	end

	setActive(var0_57, true)

	return var0_57
end

function var0_0.returnBottomGrid(arg0_58, arg1_58)
	setActive(arg1_58, false)
	table.insert(arg0_58.poolBottomGrids, arg1_58)
end

function var0_0.getUpGrid(arg0_59)
	local var0_59

	if #arg0_59.poolUpGrids > 0 then
		var0_59 = table.remove(arg0_59.poolUpGrids, #arg0_59.poolUpGrids)
	else
		var0_59 = tf(instantiate(arg0_59.tplUpGrid))

		setParent(var0_59, arg0_59.posUp)
	end

	setActive(var0_59, true)

	return var0_59
end

function var0_0.returnUpGrid(arg0_60, arg1_60)
	setActive(arg1_60, false)
	table.insert(arg0_60.poolUpGrids, arg1_60)
end

function var0_0.getPosition(arg0_61, arg1_61, arg2_61)
	local var0_61 = (arg2_61 - 1) * var2_0
	local var1_61 = -(arg1_61 - 1) * var3_0

	if arg2_61 % 2 == 0 then
		var1_61 = var1_61 + var3_0 / 2
	end

	return var0_61, var1_61
end

function var0_0.willExit(arg0_62)
	if LeanTween.isTweening(go(arg0_62.charactor)) then
		LeanTween.cancel(go(arg0_62.charactor))
	end

	for iter0_62 = 1, #arg0_62.baoxiangList do
		if LeanTween.isTweening(go(arg0_62.baoxiangList[iter0_62].tf)) then
			LeanTween.cancel(go(arg0_62.baoxiangList[iter0_62].tf))
		end
	end

	if LeanTween.isTweening(go(arg0_62.bookUnLock)) then
		LeanTween.cancel(go(arg0_62.bookUnLock))
	end
end

return var0_0
