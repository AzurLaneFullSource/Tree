local var0 = class("JiuJiuExpeditionGameView", import("...base.BaseUI"))
local var1 = 50
local var2 = 153
local var3 = 175
local var4 = 16

function var0.getUIName(arg0)
	return "JiuJiuExpeditionGameView"
end

function var0.init(arg0)
	arg0.isTweening = 0
end

function var0.onBackPressed(arg0)
	if arg0.isTweening > 0 then
		return
	end

	arg0:emit(var0.ON_BACK_PRESSED)
end

function var0.didEnter(arg0)
	arg0.activityId = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXPEDITION).id

	print(arg0.activityId)

	if not arg0.activityId then
		arg0:closeView()

		return
	end

	local var0 = pg.activity_template[arg0.activityId].config_data

	arg0.stgDatas = var0
	arg0.stgAmount = #var0
	arg0.uiAtlasName = arg0:getUIName()

	local var1 = findTF(arg0._tf, "ad")

	onButton(arg0, findTF(var1, "back"), function()
		if arg0.isTweening > 0 then
			return
		end

		arg0:closeView()
	end, SFX_CONFIRM)

	arg0.tplStgTag = findTF(var1, "posStgTag/tplStgTag")
	arg0.bookUnLock = findTF(var1, "leftUI/bookUnLock")

	setActive(arg0.bookUnLock, false)

	arg0.amountText = findTF(var1, "rightUI/amount/text")

	setText(arg0.amountText, "")

	arg0.stgText = findTF(var1, "upUI/labelStg")
	arg0.posCharactor = findTF(var1, "map/posChar")
	arg0.charactor = findTF(var1, "map/posChar/charactor")
	arg0.tplBaoxiang = findTF(var1, "map/posChar/tplBaoxiang")

	setActive(arg0.tplBaoxiang, false)

	arg0.baoxiangList = {}
	arg0.poolBaoxiangList = {}
	arg0.stgProgress = findTF(var1, "upUI/labelStgProgress")

	setText(arg0.stgProgress, "0%")

	arg0.posStgTag = findTF(var1, "posStgTag")
	arg0.stgTags = {}

	for iter0 = 1, arg0.stgAmount do
		local var2 = tf(instantiate(arg0.tplStgTag))

		setImageSprite(findTF(var2, "open/desc"), GetSpriteFromAtlas("ui/" .. arg0.uiAtlasName .. "_atlas", "stg" .. iter0), true)
		setParent(var2, arg0.posStgTag)
		setActive(var2, true)
		table.insert(arg0.stgTags, var2)

		local var3 = iter0

		onButton(arg0, var2, function()
			if arg0.level < var3 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("jiujiu_expedition_stg_tip"))
			else
				arg0:changeSelectTag(var3)
			end
		end, SFX_CONFIRM)
	end

	arg0.mapCloseBg = findTF(var1, "map/closeBg")
	arg0.mapOpenBg = findTF(var1, "map/openBg/bg")
	arg0.mapClearBg = findTF(var1, "map/openBg/clear")
	arg0.enterBossUI = findTF(arg0._tf, "pop/enterBossUI")
	arg0.posMask = findTF(var1, "map/openBg/posMask")
	arg0.tplBgMask = findTF(var1, "map/openBg/posMask/tplMask")
	arg0.poolMasks = {}
	arg0.posBottom = findTF(var1, "map/posBottom")
	arg0.tplBottomGrid = findTF(var1, "map/posBottom/tplBottomGrid")
	arg0.poolBottomGrids = {}
	arg0.posUp = findTF(var1, "map/posUp")
	arg0.tplUpGrid = findTF(var1, "map/posUp/tplUpGrid")
	arg0.poolUpGrids = {}
	arg0.mapDic = {}

	onButton(arg0, findTF(arg0.enterBossUI, "sure"), function()
		arg0:enterBattle()
	end, SFX_CONFIRM)
	onButton(arg0, findTF(arg0.enterBossUI, "cancel"), function()
		arg0:hideEnterBossUI()
	end, SFX_CONFIRM)
	onButton(arg0, findTF(var1, "help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_jiujiu_expedition_game.tip
		})
	end, SFX_CONFIRM)
	pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 0,
		activity_id = arg0.activityId
	})
	arg0:SwitchToDefaultBGM()
end

function var0.activityUpdate(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0.activityId)

	arg0.level = var0.data1 == 0 and arg0.stgAmount + 1 or var0.data1
	arg0.complete = var0.data1 == 0
	arg0.charPos = var0.data2
	arg0.tickets = var0.data3
	arg0.gridTypes = var0.data1_list

	if PLATFORM_CODE == PLATFORM_JP then
		local var1, var2, var3, var4 = JiuJiuExpeditionCollectionMediator.GetCollectionData()

		if arg0.getRewardIndex ~= var3 then
			arg0.getRewardIndex = var3

			if var4 < var3 then
				arg0:showBookUnLock()
			else
				setActive(arg0.bookUnLock, false)
			end
		end
	end

	arg0.completeBossId = var0.data4
	arg0.inMessage = false

	if #arg0.gridTypes == 0 then
		arg0.curSelectLevel = arg0.stgAmount
		arg0.chequerConfig = pg.activity_event_chequer[arg0.stgDatas[arg0.curSelectLevel]]
		arg0.chequerMap = Clone(arg0.chequerConfig.chequer_map)

		for iter0 = 1, arg0.chequerMap[1] * arg0.chequerMap[2] do
			table.insert(arg0.gridTypes, ActivityConst.EXPEDITION_TYPE_GOT)
		end
	end

	arg0:changeSelectTag(arg0.level <= arg0.stgAmount and arg0.level or arg0.stgAmount)
end

function var0.showBookUnLock(arg0)
	setImageAlpha(arg0.bookUnLock, 1)
	setActive(arg0.bookUnLock, true)

	if LeanTween.isTweening(go(arg0.bookUnLock)) then
		LeanTween.cancel(go(arg0.bookUnLock))
	end

	LeanTween.delayedCall(go(arg0.bookUnLock), 3, System.Action(function()
		LeanTween.alpha(rtf(arg0.bookUnLock), 0, 2)
	end))
end

function var0.showBaoxiang(arg0, arg1, arg2, arg3, arg4)
	arg0.isTweening = arg0.isTweening + 1

	LeanTween.delayedCall(go(arg4), 0.5, System.Action(function()
		local var0, var1 = arg0:getPosition(arg1, arg2)

		arg4.localPosition = Vector3(var0, var1 + 50, -1)

		setActive(arg4, true)
		setActive(findTF(arg4, "baoxiang_guan"), true)
		LeanTween.moveLocal(go(arg4), Vector3(var0, var1, -1), 0.2)

		arg0.isTweening = arg0.isTweening - 1

		onButton(arg0, arg4, function()
			if not arg0.isMoveChar and not arg0.isOpenBaoxiang then
				arg0.isOpenBaoxiang = true

				arg0:openBaoxiang(arg4, arg3)
			end
		end)
	end))
end

function var0.openBaoxiang(arg0, arg1, arg2)
	setActive(findTF(arg1, "baoxiang_guan"), false)
	setActive(findTF(arg1, "baoxiang_kai"), true)

	arg0.isTweening = arg0.isTweening + 1

	LeanTween.delayedCall(go(arg1), 1, System.Action(function()
		arg0.isTweening = arg0.isTweening - 1

		arg0:getGridReward(arg2)

		for iter0 = #arg0.baoxiangList, 1, -1 do
			if arg0.baoxiangList[iter0].tf == arg1 then
				table.remove(arg0.baoxiangList, iter0)
			end
		end

		arg0:returnBaoxiang(arg1)

		arg0.isOpenBaoxiang = false
	end))
end

function var0.changeSelectTag(arg0, arg1)
	local var0 = arg1 ~= arg0.curSelectLevel

	arg0.curSelectLevel = arg1

	arg0:selectTagChange(var0)
end

function var0.selectTagChange(arg0, arg1)
	if arg0.curSelectLevel > arg0.level then
		arg0:changeSelectTag(arg0.level)

		return
	end

	arg0:clear(arg1)
	arg0:updateConfig()
	arg0:updateTag()
	arg0:updateMap()
	arg0:updateGridDatas()
	arg0:updateCharactor()
	arg0:updateUI()
end

function var0.updateCharactor(arg0)
	if not arg0.complete and arg0.curSelectLevel == arg0.level and arg0.charPos > 0 then
		if arg0.charPos ~= arg0.curCharPos then
			arg0.curCharPos = arg0.charPos

			local var0 = arg0:getMapByIndex(arg0.charPos)

			if var0 then
				arg0.isMoveChar = true

				local var1, var2 = arg0:getPosition(var0.v, var0.h)

				arg0:moveChar(var1, var2, function()
					arg0.isMoveChar = false

					arg0:checkExpeditionMap()
				end)
			end
		else
			arg0:checkExpeditionMap()
		end
	else
		arg0.curCharPos = nil

		arg0:hideChar()
	end
end

function var0.checkExpeditionMap(arg0)
	if not arg0.expeditionMap or bit.band(arg0.expeditionMap.type, ActivityConst.EXPEDITION_TYPE_BAOXIANG) ~= 0 then
		-- block empty
	elseif bit.band(arg0.expeditionMap.type, ActivityConst.EXPEDITION_TYPE_OPEN) ~= 0 then
		arg0:getGridReward(arg0.expeditionMap.mapIndex)
	elseif bit.band(arg0.expeditionMap.type, ActivityConst.EXPEDITION_TYPE_BOSS) ~= 0 then
		if arg0.expeditionMap.mapIndex == arg0.charPos or arg0.expeditionMap.mapIndex == arg0.completeBossId then
			arg0:onClickGrid(arg0.expeditionMap)
		end
	else
		arg0:onClickGrid(arg0.expeditionMap)
	end
end

function var0.updateUI(arg0)
	setText(arg0.amountText, "x" .. arg0.tickets)

	local var0 = i18n("jiujiu_expedition_game_stg_desc", arg0.curSelectLevel or 1)

	setText(arg0.stgText, var0)

	if arg0.level > arg0.curSelectLevel then
		setText(arg0.stgProgress, "100%")
	else
		local var1 = 0

		for iter0 = 1, #arg0.gridTypes do
			if bit.band(arg0.gridTypes[iter0], ActivityConst.EXPEDITION_TYPE_GOT) ~= 0 then
				var1 = var1 + 1
			end
		end

		local var2 = math.floor(var1 / arg0.totalNums * 100)

		setText(arg0.stgProgress, var2 .. "%")
	end
end

function var0.updateGridDatas(arg0)
	if arg0.curSelectLevel == arg0.level then
		for iter0 = 1, #arg0.gridTypes do
			local var0 = arg0:getMapActivityType(arg0.gridTypes[iter0])

			if var0 == ActivityConst.EXPEDITION_TYPE_OPEN then
				arg0.expeditionMap = arg0:getMapByPosNum(iter0)
			elseif var0 == ActivityConst.EXPEDITION_TYPE_BOSS and (arg0.completeBossId == iter0 or arg0.charPos == iter0) then
				arg0.expeditionMap = arg0:getMapByPosNum(iter0)
			end
		end
	end

	for iter1 = 1, #arg0.mapDic do
		local var1 = arg0.mapDic[iter1]

		if arg0.curSelectLevel < arg0.level then
			arg0:setMapGridType(var1, ActivityConst.EXPEDITION_TYPE_GOT)
		else
			local var2 = var1.mapIndex
			local var3 = arg0.gridTypes[var2]
			local var4 = arg0:getMapActivityType(var3)
			local var5 = bit.rshift(var3, 4)

			if (arg0.charPos <= 0 or not arg0.charPos) and arg0.tickets > 0 then
				arg0:setMapGridType(var1, var4)
			elseif var4 == ActivityConst.EXPEDITION_TYPE_LOCK and arg0:getGridSideOpen(var1) and arg0.tickets > 0 then
				arg0:setMapGridType(var1, var4)
			else
				arg0:setMapGridType(var1, var4, var5)
			end
		end
	end
end

function var0.getMapActivityType(arg0, arg1)
	if bit.band(arg1, ActivityConst.EXPEDITION_TYPE_GOT) == ActivityConst.EXPEDITION_TYPE_GOT then
		return ActivityConst.EXPEDITION_TYPE_GOT
	elseif bit.band(arg1, ActivityConst.EXPEDITION_TYPE_BOSS) == ActivityConst.EXPEDITION_TYPE_BOSS then
		return ActivityConst.EXPEDITION_TYPE_BOSS
	elseif bit.band(arg1, ActivityConst.EXPEDITION_TYPE_BAOXIANG) == ActivityConst.EXPEDITION_TYPE_BAOXIANG then
		return ActivityConst.EXPEDITION_TYPE_BAOXIANG
	elseif bit.band(arg1, ActivityConst.EXPEDITION_TYPE_OPEN) == ActivityConst.EXPEDITION_TYPE_OPEN then
		return ActivityConst.EXPEDITION_TYPE_OPEN
	end

	return ActivityConst.EXPEDITION_TYPE_LOCK
end

function var0.updateConfig(arg0)
	arg0.chequerConfig = pg.activity_event_chequer[arg0.stgDatas[arg0.curSelectLevel]]
	arg0.chequerMap = Clone(arg0.chequerConfig.chequer_map)

	local var0 = Clone(arg0.chequerConfig.empty_grid)

	arg0.emptyPosNums = {}

	for iter0 = 1, #var0 do
		local var1 = arg0:getPosNum(var0[iter0][1], var0[iter0][2])

		table.insert(arg0.emptyPosNums, var1)
	end

	arg0.totalNums = arg0.chequerMap[1] * arg0.chequerMap[2] - #arg0.emptyPosNums
end

function var0.getGridSideOpen(arg0, arg1)
	local var0 = arg1.posNum
	local var1

	if arg1.h % 2 == 1 then
		var1 = {
			var0 - 1,
			var0 + 1,
			var0 - arg0.chequerMap[2],
			var0 + arg0.chequerMap[2],
			var0 + arg0.chequerMap[2] - 1,
			var0 + arg0.chequerMap[2] + 1
		}
	else
		var1 = {
			var0 - 1,
			var0 + 1,
			var0 - arg0.chequerMap[2],
			var0 + arg0.chequerMap[2],
			var0 - arg0.chequerMap[2] - 1,
			var0 - arg0.chequerMap[2] + 1
		}
	end

	local var2 = arg1.v
	local var3 = arg1.h

	for iter0 = #var1, 1, -1 do
		local var4 = var1[iter0]
		local var5 = math.ceil(var4 / arg0.chequerMap[2])
		local var6 = (var4 - 1) % arg0.chequerMap[2] + 1

		if math.abs(var5 - var2) > 1 or math.abs(var6 - var3) > 1 then
			table.remove(var1, iter0)
		end
	end

	local var7

	for iter1 = 1, #var1 do
		local var8 = arg0:getMapByPosNum(var1[iter1])

		if var8 and arg0:getMapIndexType(var8.mapIndex) == ActivityConst.EXPEDITION_TYPE_GOT then
			return true
		end
	end

	return false
end

function var0.getMapByPosNum(arg0, arg1)
	if arg1 <= 0 then
		return nil
	end

	if arg1 > arg0.chequerMap[2] * arg0.chequerMap[1] then
		return nil
	end

	for iter0 = 1, #arg0.mapDic do
		if arg0.mapDic[iter0].posNum == arg1 then
			return arg0.mapDic[iter0]
		end
	end

	return nil
end

function var0.getMapByIndex(arg0, arg1)
	for iter0 = 1, #arg0.mapDic do
		if arg0.mapDic[iter0].mapIndex == arg1 then
			return arg0.mapDic[iter0]
		end
	end

	return nil
end

function var0.getMapIndexType(arg0, arg1)
	local var0 = arg0.gridTypes[arg1]

	return arg0:getMapActivityType(var0)
end

function var0.updateMap(arg0)
	local var0 = arg0.chequerConfig.difficult

	setImageSprite(arg0.mapCloseBg, GetSpriteFromAtlas("ui/" .. arg0.uiAtlasName .. "_atlas", "map_close_" .. var0), true)
	setImageSprite(arg0.mapOpenBg, GetSpriteFromAtlas("ui/" .. arg0.uiAtlasName .. "_atlas", "map_open_" .. var0), true)
	setImageSprite(arg0.mapClearBg, GetSpriteFromAtlas("ui/" .. arg0.uiAtlasName .. "_atlas", "map_open_" .. var0), true)

	local var1 = arg0.chequerMap[1]
	local var2 = arg0.chequerMap[2]

	arg0.mapDic = {}

	local var3 = 0

	for iter0 = 1, var1 do
		for iter1 = 1, var2 do
			local var4 = arg0:getPosNum(iter0, iter1)

			var3 = var3 + 1

			if not table.contains(arg0.emptyPosNums, var4) then
				local var5 = arg0:getMask()
				local var6 = arg0:getBottomGrid()
				local var7 = arg0:getUpGrid()

				arg0:setMapTfPosition(var5, iter0, iter1)
				arg0:setMapTfPosition(var6, iter0, iter1)
				arg0:setMapTfPosition(var7, iter0, iter1)

				local var8 = {
					mask = var5,
					bottomGrid = var6,
					upGrid = var7,
					v = iter0,
					h = iter1,
					posNum = var4,
					mapIndex = var3
				}

				onButton(arg0, var7, function()
					arg0:onClickGrid(var8)
				end, SFX_CONFIRM)
				table.insert(arg0.mapDic, var8)
			end
		end
	end
end

function var0.setMapGridType(arg0, arg1, arg2, arg3)
	arg1.type = arg2
	arg1.params = arg3

	local var0 = arg1.mask
	local var1 = arg1.bottomGrid

	setActive(var1, true)

	local var2 = arg1.upGrid
	local var3 = findTF(var2, "select")
	local var4 = findTF(var2, "boss")
	local var5 = findTF(var2, "bottomLight")
	local var6 = findTF(var2, "outLine")

	setActive(var0, false)
	setActive(var3, false)
	setActive(var6, false)
	setActive(var4, false)
	setActive(var5, false)

	if arg2 == ActivityConst.EXPEDITION_TYPE_OPEN or arg2 == ActivityConst.EXPEDITION_TYPE_GOT then
		setActive(var3, true)
		var2:SetAsLastSibling()
	elseif arg2 == ActivityConst.EXPEDITION_TYPE_LOCK then
		setActive(var0, true)
		setActive(var6, true)
	elseif arg2 == ActivityConst.EXPEDITION_TYPE_BAOXIANG then
		setActive(var3, true)
		arg0:addBaoXiang(arg1)
		var2:SetAsLastSibling()
	elseif arg2 == ActivityConst.EXPEDITION_TYPE_BOSS then
		setActive(var3, true)
		setActive(var4, true)
		var2:SetAsLastSibling()
	elseif arg2 == var4 then
		setActive(var0, true)
		setActive(var3, true)
		setActive(var5, true)
		var2:SetAsLastSibling()
	end
end

function var0.addBaoXiang(arg0, arg1)
	for iter0 = 1, #arg0.baoxiangList do
		if arg0.baoxiangList[iter0].mapIndex == arg1.mapIndex then
			return
		end
	end

	local var0 = arg0:getBaoxiang()

	arg0:showBaoxiang(arg1.v, arg1.h, arg1.mapIndex, var0)
	table.insert(arg0.baoxiangList, {
		tf = var0,
		mapIndex = arg1.mapIndex
	})
end

function var0.setMapTfPosition(arg0, arg1, arg2, arg3)
	local var0, var1 = arg0:getPosition(arg2, arg3)

	arg1.localPosition = Vector3(var0, var1, 0)
end

function var0.updateTag(arg0)
	for iter0 = 1, #arg0.stgTags do
		local var0 = arg0.stgTags[iter0]

		if iter0 <= arg0.level then
			setActive(findTF(var0, "open"), true)
			setActive(findTF(var0, "close"), false)
		else
			setActive(findTF(var0, "open"), false)
			setActive(findTF(var0, "close"), true)
		end

		if iter0 == arg0.curSelectLevel then
			setActive(findTF(var0, "open/on"), true)
			setActive(findTF(var0, "open/off"), false)
		else
			setActive(findTF(var0, "open/on"), false)
			setActive(findTF(var0, "open/off"), true)
		end
	end
end

function var0.onClickGrid(arg0, arg1)
	local var0 = arg1.type
	local var1 = arg1.mapIndex
	local var2 = arg1.v
	local var3 = arg1.h

	if var0 == var4 then
		if not arg0.isMoveChar then
			arg0:openGrid(arg1.mapIndex)
		end
	elseif var0 == ActivityConst.EXPEDITION_TYPE_BOSS then
		arg0.bossId = arg1.params

		if arg0.completeBossId == arg1.mapIndex then
			arg0:getGridReward(arg0.completeBossId)

			if PLATFORM_CODE == PLATFORM_JP then
				arg0:showBookUnLock()
			end
		elseif not arg0.isMoveChar and arg0.isTweening == 0 and not arg0.isOpenBaoxiang then
			arg0:showEnterBossUI()
		end
	elseif var0 == ActivityConst.EXPEDITION_TYPE_LOCK and arg0.tickets <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("jiujiu_expedition_amount_tip"))
	end
end

function var0.moveChar(arg0, arg1, arg2, arg3)
	if LeanTween.isTweening(go(arg0.charactor)) then
		LeanTween.cancel(go(arg0.charactor))
	end

	if isActive(arg0.charactor) then
		arg0:hideChar(function()
			arg0:showChar(arg1, arg2, arg3)
		end)
	else
		arg0:showChar(arg1, arg2, arg3)
	end
end

function var0.showChar(arg0, arg1, arg2, arg3)
	arg0.charactor.localPosition = Vector3(arg1, arg2 + var1)

	setActive(arg0.charactor, true)
	LeanTween.value(go(arg0.charactor), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0)
		GetComponent(arg0.charactor, typeof(CanvasGroup)).alpha = arg0
	end))
	LeanTween.moveLocal(go(arg0.charactor), Vector3(arg1, arg2, 0), 0.2):setOnComplete(System.Action(function()
		if arg3 then
			arg3()
		end
	end))
end

function var0.hideChar(arg0, arg1)
	LeanTween.value(go(arg0.charactor), 1, 0, 0.2):setOnUpdate(System.Action_float(function(arg0)
		GetComponent(arg0.charactor, typeof(CanvasGroup)).alpha = arg0
	end))

	local var0 = arg0.charactor.localPosition

	LeanTween.moveLocal(go(arg0.charactor), Vector3(var0.x, var0.y + var1, 0), 0.2):setOnComplete(System.Action(function()
		setActive(arg0.charactor, false)

		if arg1 then
			arg1()
		end
	end))
end

function var0.enterBattle(arg0)
	arg0:hideEnterBossUI()
	pg.m02:sendNotification(GAME.BEGIN_STAGE, {
		system = SYSTEM_REWARD_PERFORM,
		stageId = arg0.bossId
	})

	arg0.bossId = nil
end

function var0.openGrid(arg0, arg1)
	if arg0.inMessage then
		return
	end

	arg0.inMessage = true

	pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 1,
		activity_id = arg0.activityId,
		arg1 = arg1
	})
end

function var0.getGridReward(arg0, arg1)
	if arg0.inMessage then
		return
	end

	arg0.inMessage = true

	pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 2,
		activity_id = arg0.activityId,
		arg1 = arg1
	})
end

function var0.showEnterBossUI(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0.enterBossUI)
	setActive(arg0.enterBossUI, true)
end

function var0.hideEnterBossUI(arg0)
	setActive(arg0.enterBossUI, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.enterBossUI)
end

function var0.getPosNum(arg0, arg1, arg2)
	return (arg1 - 1) * arg0.chequerMap[2] + arg2
end

function var0.clear(arg0, arg1)
	for iter0 = 1, #arg0.mapDic do
		local var0 = arg0.mapDic[iter0]

		arg0:returnBottomGrid(var0.bottomGrid)
		arg0:returnMask(var0.mask)
		arg0:returnUpGrid(var0.upGrid)
	end

	arg0.mapDic = {}

	if arg1 then
		for iter1 = 1, #arg0.baoxiangList do
			if LeanTween.isTweening(go(arg0.baoxiangList[iter1].tf)) then
				LeanTween.cancel(go(arg0.baoxiangList[iter1].tf))
			end

			arg0:returnBaoxiang(arg0.baoxiangList[iter1].tf)
		end

		arg0.baoxiangList = {}
	end

	arg0.expeditionMap = nil
end

function var0.getBaoxiang(arg0)
	local var0

	if #arg0.poolBaoxiangList > 0 then
		var0 = table.remove(arg0.poolBaoxiangList, #arg0.poolBaoxiangList)
	else
		var0 = tf(instantiate(arg0.tplBaoxiang))

		setParent(var0, arg0.posCharactor)
	end

	setActive(findTF(var0, "baoxiang_guan"), true)
	setActive(findTF(var0, "baoxiang_kai"), false)

	return var0
end

function var0.returnBaoxiang(arg0, arg1)
	setActive(arg1, false)
	table.insert(arg0.poolBaoxiangList, arg1)
end

function var0.getMask(arg0)
	local var0

	if #arg0.poolMasks > 0 then
		var0 = table.remove(arg0.poolMasks, #arg0.poolMasks)
	else
		var0 = tf(instantiate(arg0.tplBgMask))

		setParent(var0, arg0.posMask)
	end

	setActive(var0, true)

	return var0
end

function var0.returnMask(arg0, arg1)
	setActive(arg1, false)
	table.insert(arg0.poolMasks, arg1)
end

function var0.getBottomGrid(arg0)
	local var0

	if #arg0.poolBottomGrids > 0 then
		var0 = table.remove(arg0.poolBottomGrids, #arg0.poolBottomGrids)
	else
		var0 = tf(instantiate(arg0.tplBottomGrid))

		setParent(var0, arg0.posBottom)
	end

	setActive(var0, true)

	return var0
end

function var0.returnBottomGrid(arg0, arg1)
	setActive(arg1, false)
	table.insert(arg0.poolBottomGrids, arg1)
end

function var0.getUpGrid(arg0)
	local var0

	if #arg0.poolUpGrids > 0 then
		var0 = table.remove(arg0.poolUpGrids, #arg0.poolUpGrids)
	else
		var0 = tf(instantiate(arg0.tplUpGrid))

		setParent(var0, arg0.posUp)
	end

	setActive(var0, true)

	return var0
end

function var0.returnUpGrid(arg0, arg1)
	setActive(arg1, false)
	table.insert(arg0.poolUpGrids, arg1)
end

function var0.getPosition(arg0, arg1, arg2)
	local var0 = (arg2 - 1) * var2
	local var1 = -(arg1 - 1) * var3

	if arg2 % 2 == 0 then
		var1 = var1 + var3 / 2
	end

	return var0, var1
end

function var0.willExit(arg0)
	if LeanTween.isTweening(go(arg0.charactor)) then
		LeanTween.cancel(go(arg0.charactor))
	end

	for iter0 = 1, #arg0.baoxiangList do
		if LeanTween.isTweening(go(arg0.baoxiangList[iter0].tf)) then
			LeanTween.cancel(go(arg0.baoxiangList[iter0].tf))
		end
	end

	if LeanTween.isTweening(go(arg0.bookUnLock)) then
		LeanTween.cancel(go(arg0.bookUnLock))
	end
end

return var0
