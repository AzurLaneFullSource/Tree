local var0 = class("MonopolyPtScene", import("..base.BaseUI"))

var0.story = false

local var1 = 312011
local var2 = 312010
local var3 = "kaibaoxiang_boss"
local var4 = "kaibaoxiang_putong"
local var5 = "unknown3"

var0.battle = false

local var6 = {
	201211,
	401231,
	301051,
	101171
}
local var7 = {
	201217,
	431232,
	331055,
	131171
}
local var8 = 0.6
local var9 = 100
local var10 = "dafuweng_walk"
local var11 = "stand"
local var12 = "dafuweng_stand"
local var13 = "dafuweng_jump"
local var14 = "dafuweng_run"
local var15 = "dafuweng_touch"
local var16 = "maoxian_baoxiang"
local var17 = "maoxian_gold"
local var18 = "maoxian_item"
local var19 = "maoxian_oil"
local var20 = 35
local var21 = 1
local var22 = 2
local var23 = "back"
local var24 = "mid"
local var25 = "front"
local var26 = 2
local var27 = 1920
local var28 = 1080
local var29 = false
local var30 = 0
local var31 = {
	700,
	1400,
	2100,
	2800,
	3500,
	4200,
	4900,
	5600,
	6300,
	7000,
	9000,
	9650,
	10200,
	10900,
	11600,
	12300,
	13000,
	13800,
	14500,
	15430
}

function var0.getUIName(arg0)
	return "MonopolyPtUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:initEvent()
	arg0:activityDataUpdata()
	arg0:updataUI()
	arg0:initMap()
end

function var0.initMap(arg0)
	if arg0.useCount < 9 then
		arg0:createMap("ground_1")
	elseif arg0.useCount == 9 then
		arg0:createMap("ground_2")
		arg0:createMap("ground_3")
		arg0:createMap("ground_4")
	elseif arg0.useCount == 10 then
		arg0:createMap("ground_3")
		arg0:createMap("ground_4")
	elseif arg0.useCount > 9 and arg0.useCount < 19 then
		arg0:createMap("ground_4")
	elseif arg0.useCount == 19 then
		arg0:createMap("ground_5")

		if MonopolyPtScene.battle then
			LeanTween.delayedCall(go(arg0._tf), 1, System.Action(function()
				local var0 = arg0:getPtData()
				local var1, var2 = var0:GetResProgress()

				pg.m02:sendNotification(GAME.ACT_NEW_PT, {
					cmd = 1,
					activity_id = var0:GetId(),
					arg1 = var2
				})
			end))

			if arg0.baoxiangModel then
				local var0 = arg0.baoxiangModel:GetComponent(typeof(SpineAnimUI))

				arg0:setModelAnim(var0, "boss_kaiqi", 1, function()
					arg0:setModelAnim(var0, "boss_kai", 0, nil)
				end)
				arg0:changeCharAction(var16, 1, nil)
			else
				arg0.baoxiangKai = true
			end

			if arg0.anims then
				arg0:changeCharAction(var16, 1, nil)
			else
				arg0.charMaoxian = true
			end
		end
	elseif arg0.useCount >= 20 then
		arg0:createMap("ground_5")
	end

	if arg0.useCount > 0 then
		if MonopolyPtScene.battle and arg0.useCount >= 19 then
			arg0:updateMap(var31[#var31])
		else
			arg0:updateMap(var31[arg0.useCount])
		end

		for iter0 = 1, 20 do
			arg0.translate.anchoredPosition = Vector2(arg0.mid.anchoredPosition.x + arg0.distance, 0)

			if arg0.mapTf:InverseTransformPoint(arg0.translate.position).x <= var27 - 600 then
				arg0:createMap()
			end
		end
	end

	if arg0.useCount == 0 and not MonopolyPtScene.story then
		local var1 = arg0:getStoryData(0)

		setActive(arg0.btnStart, false)
		setActive(arg0.btnBack, false)
		setActive(arg0.btnMain, false)
		setActive(arg0.labelDropShip, false)
		pg.NewStoryMgr.GetInstance():Play(var1, function()
			MonopolyPtScene.story = true

			setActive(arg0.btnStart, true)
			setActive(arg0.btnBack, true)
			setActive(arg0.btnMain, true)
			setActive(arg0.labelDropShip, false)
			arg0:updataUI()
		end, true, true)
	end
end

local var32 = {
	1,
	1,
	1,
	2,
	3,
	4,
	4,
	4,
	5
}

function var0.createMap(arg0, arg1)
	if not arg0.mapIndexs then
		arg0.mapIndexs = Clone(var32)
	end

	if #arg0.mapIndexs == 0 then
		return
	end

	arg1 = "ground_" .. table.remove(arg0.mapIndexs, 1)

	if arg1 == "ground_2" or arg1 == "ground_3" or arg1 == "ground_5" then
		if not arg0.onceMap then
			arg0.onceMap = {}
		end

		if table.contains(arg0.onceMap, arg1) then
			return
		else
			table.insert(arg0.onceMap, arg1)
		end
	end

	local var0 = findTF(arg0.groundTf, arg1)
	local var1 = tf(Instantiate(var0))
	local var2 = findTF(var1, "back")

	SetParent(var2, arg0.back)
	setActive(var2, true)

	var2.anchoredPosition = Vector2(arg0.distance, 0)

	var2:SetAsFirstSibling()

	local var3 = findTF(var1, "mid")

	SetParent(var3, arg0.mid)
	setActive(var3, true)

	var3.anchoredPosition = Vector2(arg0.distance, 0)

	local var4 = findTF(var1, "front")

	SetParent(var4, arg0.front)
	setActive(var4, true)

	var4.anchoredPosition = Vector2(arg0.distance, 0)

	Destroy(var1)

	local var5 = var1.sizeDelta.x

	arg0.distance = arg0.distance + var5

	if arg0.cellPos then
		arg0.cellPos:SetAsLastSibling()
	end

	if arg0.char then
		arg0.char:SetAsLastSibling()
	end

	if arg1 == "ground_2" then
		arg0.housePosition = findTF(var3, "house/img").position
	elseif arg1 == "ground_5" then
		arg0.endPosition = findTF(var3, "house/img").position
	end

	if arg1 == "ground_2" then
		local var6 = Ship.New({
			configId = var1,
			skin_id = var2
		}):getPrefab()

		PoolMgr.GetInstance():GetSpineChar(var6, true, function(arg0)
			arg0.mingShimodel = arg0
			arg0.mingShimodel.transform.localScale = Vector3(0.4, 0.4, 0.4)
			arg0.mingShimodel.transform.localPosition = Vector3.zero

			arg0.mingShimodel.transform:SetParent(findTF(var3, "house/char"), false)

			local var0 = arg0.mingShimodel:GetComponent(typeof(SpineAnimUI))

			arg0:setModelAnim(var0, var11, 0, nil)
		end)
	elseif arg1 == "ground_5" then
		if arg0.useCount <= 19 and not MonopolyPtScene.battle then
			PoolMgr.GetInstance():GetSpineChar(var5, true, function(arg0)
				arg0.enemyModel = arg0
				arg0.enemyModel.transform.localScale = Vector3(0.4, 0.4, 0.4)
				arg0.enemyModel.transform.localPosition = Vector3.zero

				arg0.enemyModel.transform:SetParent(findTF(var3, "house/enemy"), false)

				local var0 = arg0.enemyModel:GetComponent(typeof(SpineAnimUI))

				arg0:setModelAnim(var0, "normal", 0, nil)
			end)
		else
			PoolMgr.GetInstance():GetSpineChar(var3, true, function(arg0)
				arg0.baoxiangModel = arg0
				arg0.baoxiangModel.transform.localScale = Vector3(0.3, 0.3, 0.3)
				arg0.baoxiangModel.transform.localPosition = Vector3.zero

				arg0.baoxiangModel.transform:SetParent(findTF(var3, "house/baoxiang"), false)

				local var0 = arg0.baoxiangModel:GetComponent(typeof(SpineAnimUI))

				if arg0.baoxiangKai then
					arg0.baoxiangKai = false

					local var1 = arg0.baoxiangModel:GetComponent(typeof(SpineAnimUI))

					arg0:setModelAnim(var1, "boss_kaiqi", 1, function()
						arg0:setModelAnim(var1, "boss_kai", 0, nil)
					end)
					arg0:changeCharAction(var16, 1, nil)
				elseif arg0.useCount >= 20 then
					arg0:setModelAnim(var0, "boss_kai", 0, nil)
				else
					arg0:setModelAnim(var0, "boss_guan", 0, nil)
					setActive(arg0.baoxiangModel, false)
				end
			end)
		end
	end
end

function var0.initData(arg0)
	arg0.distance = 0
	arg0.moveDistance = 0
	arg0.activityId = arg0.contextData.config_id
	arg0.leftCount = 0
	arg0.inAnimatedFlag = false
	arg0.lastBonusTimes = 0
	arg0.baoxiangCells = {}

	local var0 = pg.activity_template[arg0.activityId]

	arg0.storys = var0.config_client.story
	arg0.battles = var0.config_client.battle
	arg0.awardsTimer = Timer.New(function()
		if arg0.awardTfs and #arg0.awardTfs > 0 then
			for iter0 = #arg0.awardTfs, 1, -1 do
				local var0 = arg0.awardTfs[iter0]
				local var1 = var0.anchoredPosition

				var1.y = var1.y + 3

				if var1.y >= 150 then
					Destroy(table.remove(arg0.awardTfs, iter0))
				else
					var0.anchoredPosition = var1
				end
			end
		end
	end, 0.0333333333333333, -1)

	arg0.awardsTimer:Start()
end

function var0.initUI(arg0)
	arg0._ad = findTF(arg0._tf, "AD")
	arg0.char = findTF(arg0._ad, "map/mask/container/mid/char")
	arg0.btnStart = findTF(arg0._ad, "btnStart")
	arg0.btnBack = findTF(arg0._ad, "btnBack")
	arg0.labelCount = findTF(arg0._ad, "btnStart/txt")

	setActive(arg0.btnStart, true)

	arg0.btnMain = findTF(arg0._ad, "btnMain")
	arg0.labelDropShip = findTF(arg0._ad, "labelDropShip")
	arg0.mapTf = findTF(arg0._ad, "map")
	arg0.container = findTF(arg0._ad, "map/mask/container")
	arg0.back = findTF(arg0._ad, "map/mask/container/back")
	arg0.mid = findTF(arg0._ad, "map/mask/container/mid")
	arg0.front = findTF(arg0._ad, "map/mask/container/front")
	arg0.cellPos = findTF(arg0._ad, "map/mask/container/mid/posCell")
	arg0.tplCell = findTF(arg0._ad, "tplCell")
	arg0.mapCells = {}
	arg0.curCellIndex = nil
	arg0.translate = findTF(arg0.container, "translate")
	arg0.awardTf = findTF(arg0._ad, "awardTpl")
	arg0.awardParent = findTF(arg0.char, "award")
	arg0.groundTf = findTF(arg0._ad, "map/mask/container/ground")

	setActive(arg0.groundTf, false)

	arg0.models = {}
	arg0.anims = {}
	arg0.modelIds = {}
	arg0.clickModelTime = {}

	for iter0 = 1, #var6 do
		local var0 = iter0
		local var1 = var6[iter0]
		local var2 = var7[iter0]
		local var3 = {
			configId = var1,
			skin_id = var2
		}
		local var4 = Ship.New(var3):getPrefab()

		PoolMgr.GetInstance():GetSpineChar(var4, true, function(arg0)
			arg0.transform.localScale = Vector3.one
			arg0.transform.localPosition = Vector3(0, 0, 0)
			arg0.transform.anchorMin = Vector2(0.5, 0)
			arg0.transform.anchorMax = Vector2(0.5, 0)

			arg0.transform:SetParent(findTF(arg0.char, var0), false)

			local var0 = arg0:GetComponent(typeof(SpineAnimUI))

			table.insert(arg0.modelIds, var1)
			table.insert(arg0.models, arg0)
			table.insert(arg0.anims, var0)

			if #arg0.anims == #var6 then
				if arg0.charMaoxian then
					arg0.charMaoxian = false

					arg0:changeCharAction(var16, 0, nil)
				else
					arg0:changeCharAction(var11, 0, nil)
				end
			end

			table.insert(arg0.clickModelTime, 0)
			onButton(arg0._binder, findTF(arg0.char, var0).transform, function()
				if not var0 or not arg0 or arg0.inAnimatedFlag then
					return
				end

				if Time.time - arg0.clickModelTime[var0] < 3 then
					return
				end

				arg0.clickModelTime[var0] = Time.time

				if LeanTween.isTweening(go(arg0.cellPos)) then
					return
				end

				arg0:setModelAnim(var0, var15, 1, function()
					arg0:setModelAnim(var0, var11, 0, nil)
				end)
			end, SFX_PANEL)
		end)
	end
end

function var0.initEvent(arg0)
	onButton(arg0._binder, arg0.btnStart, function()
		if arg0.leftCount and arg0.leftCount <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end

		local var0 = {}
		local var1 = arg0:getPtData():GetAward()
		local var2 = getProxy(PlayerProxy):getRawData()
		local var3 = pg.gameset.urpt_chapter_max.description[1]
		local var4 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3)
		local var5, var6 = Task.StaticJudgeOverflow(var2.gold, var2.oil, var4, true, true, {
			{
				var1.type,
				var1.id,
				var1.count
			}
		})

		if var5 then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6,
					onYes = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			arg0:start()
		end)
	end, SFX_PANEL)
	onButton(arg0._binder, arg0.btnBack, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0._binder, arg0.btnMain, function()
		arg0:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
end

function var0.getPtData(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0.activityId)

	return (ActivityPtData.New(var0))
end

function var0.addAwards(arg0, arg1)
	if not arg0.awardTfs then
		arg0.awardTfs = {}
	end

	for iter0 = 1, #arg1 do
		local var0 = arg1[iter0]
		local var1 = tf(instantiate(go(arg0.awardTf)))

		setParent(var1, arg0.awardParent)
		updateDrop(var1, var0)

		var1.anchoredPosition = Vector2(0, 0)

		setActive(var1, true)
		table.insert(arg0.awardTfs, var1)
	end
end

function var0.start(arg0)
	if arg0.inAnimatedFlag then
		return
	end

	if arg0.leftCount and arg0.leftCount <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

		return
	end

	arg0:changeAnimeState(true)

	local var0 = var14

	arg0:move(var0, function()
		return
	end)
end

function var0.checkCountStory(arg0, arg1)
	local var0 = arg0.useCount
	local var1 = arg0.activity:getDataConfig("story") or {}
	local var2 = _.detect(var1, function(arg0)
		return arg0[1] == var0
	end)

	if var2 then
		pg.NewStoryMgr.GetInstance():Play(var2[2], arg1)
	else
		arg1()
	end
end

function var0.changeAnimeState(arg0, arg1, arg2)
	if arg1 then
		arg0.btnStart:GetComponent(typeof(Image)).raycastTarget = false
		arg0.inAnimatedFlag = true
	else
		arg0.inAnimatedFlag = false
		arg0.btnStart:GetComponent(typeof(Image)).raycastTarget = true
	end

	setActive(arg0.btnStart, not arg1)
end

function var0.updataActivity(arg0, arg1)
	arg0:activityDataUpdata()
	arg0:updataUI()

	if arg0.useCount == 9 then
		arg0:createMap("ground_2")
		arg0:createMap("ground_3")
	elseif arg0.useCount == 19 then
		arg0:createMap("ground_5")
	end
end

function var0.activityDataUpdata(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0.activityId)
	local var1 = ActivityPtData.New(var0)
	local var2, var3, var4 = var1:GetResProgress()
	local var5 = var1:GetLevel()
	local var6 = var1:CanGetAward()
	local var7 = var1:CanGetNextAward()
	local var8 = 20 - var5
	local var9 = math.floor(var2 / 500) - var5

	if var8 < var9 then
		var9 = var8
	end

	arg0.useCount = var5
	arg0.leftCount = var9

	if var29 then
		var30 = var30 + 1
		arg0.useCount = var30
		arg0.leftCount = 20 - var30
	end

	arg0.leftLastDrop = 20 - arg0.useCount
end

function var0.updataUI(arg0)
	if arg0.leftLastDrop then
		setText(findTF(arg0.labelDropShip, "text"), "" .. arg0.leftLastDrop)
		setActive(arg0.labelDropShip, arg0.leftLastDrop > 0)
	end

	setText(arg0.labelCount, arg0.leftCount)

	if arg0.useCount >= 20 then
		setActive(arg0.btnStart, false)
	end
end

function var0.updataChar(arg0)
	if not isActive(arg0.char) then
		SetActive(arg0.char, true)
		arg0.char:SetAsLastSibling()
	end
end

function var0.move(arg0, arg1, arg2)
	local var0 = {}

	table.insert(var0, function(arg0)
		if arg0.useCount >= #var31 then
			arg0.useCount = #var31 - 1
		end

		local var0 = var31[arg0.useCount + 1] - arg0.moveDistance

		if arg0.useCount == 9 and arg0.housePosition then
			-- block empty
		elseif arg0.useCount == 19 and arg0.endPosition then
			-- block empty
		elseif arg0.useCount == 10 then
			arg0:createCell(var0)
		else
			arg0:createCell(var0)
		end

		local var1 = var0 / 250
		local var2 = 0

		arg0:changeCharAction(arg1, 0, nil)

		local var3 = var0 / (var1 / 0.6)
		local var4 = 0

		if LeanTween.isTweening(go(arg0.cellPos)) then
			LeanTween.cancel(go(arg0.cellPos))
		end

		LeanTween.value(go(arg0.cellPos), 0, var0, var1):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0)
			arg0:updateMap(arg0 - var2)

			var2 = arg0
		end)):setOnComplete(System.Action(function()
			local var0

			if arg0.useCount > 1 then
				var0 = arg0:getStoryData(arg0.useCount + 1)
			end

			local var1 = arg0:getBattle(arg0.useCount + 1)
			local var2 = arg0.useCount + 1

			arg0:changeCharAction(var11, 0, nil)

			local function var3()
				local var0 = arg0:getPtAwardData(var2)

				assert(var0)

				if var0[1] == 1 and var0[2] == 1 then
					arg0:setModelAnim(arg0.anims[1], var17, 1, function()
						arg0:setModelAnim(arg0.anims[1], var11, 0)
					end)
				elseif var0[1] == 1 and var0[2] == 2 then
					arg0:setModelAnim(arg0.anims[1], var19, 1, function()
						arg0:setModelAnim(arg0.anims[1], var11, 0)
					end)
				elseif var0[1] == 2 and var0[2] == 54016 then
					arg0:setModelAnim(arg0.anims[1], var18, 1, function()
						arg0:setModelAnim(arg0.anims[1], var11, 0)
					end)
				else
					arg0:setModelAnim(arg0.anims[1], var16, 1, function()
						arg0:setModelAnim(arg0.anims[1], var11, 0)
					end)
				end

				for iter0 = 2, #arg0.anims do
					arg0:setModelAnim(arg0.anims[iter0], var16, 1, function()
						arg0:setModelAnim(arg0.anims[iter0], var11, 0)
					end)
				end
			end

			if arg0.putongModel then
				local var4 = arg0.putongModel:GetComponent(typeof(SpineAnimUI))

				arg0:setModelAnim(var4, "putong_kaiqi", 1, function()
					if var4 then
						arg0:setModelAnim(var4, "putong_kai", 0, nil)
					end
				end)

				arg0.putongModel = nil
			end

			if var0 and tonumber(var0) ~= 0 then
				pg.NewStoryMgr.GetInstance():Play(var0, function()
					if var3 then
						var3()
					end

					LeanTween.delayedCall(go(arg0._tf), 1, System.Action(function()
						arg0()
					end))
				end, true, true)
			elseif arg0.useCount == 19 and tonumber(var1) ~= 0 and not MonopolyPtScene.battle then
				MonopolyPtScene.battle = true

				pg.m02:sendNotification(GAME.BEGIN_STAGE, {
					system = SYSTEM_PERFORM,
					stageId = tonumber(var1)
				})
			else
				if var3 then
					var3()
				end

				LeanTween.delayedCall(go(arg0._tf), 1, System.Action(function()
					arg0()
				end))
			end
		end))
	end)
	table.insert(var0, function(arg0)
		local var0 = arg0:getPtData()
		local var1, var2 = var0:GetResProgress()

		pg.m02:sendNotification(GAME.ACT_NEW_PT, {
			cmd = 1,
			activity_id = var0:GetId(),
			arg1 = var2
		})
		arg0:changeAnimeState(false)
		arg0:updataActivity()
		arg0()
	end)
	seriesAsync(var0, arg2)
end

function var0.getBattle(arg0, arg1)
	for iter0 = 1, #arg0.battles do
		if arg0.battles[iter0][1] == arg1 then
			return arg0.battles[iter0][2]
		end
	end

	return nil
end

function var0.getStoryData(arg0, arg1)
	for iter0 = 1, #arg0.storys do
		if arg0.storys[iter0][1] == arg1 then
			return arg0.storys[iter0][2]
		end
	end

	return nil
end

function var0.createCell(arg0, arg1, arg2)
	local var0 = tf(instantiate(go(arg0.tplCell)))
	local var1 = arg0.cellPos:InverseTransformPoint(arg0.char.position)

	var0.localPosition = Vector3(var1.x + arg1 + 100, 0, 0)
	var0.localScale = Vector3(0.5, 0.5, 0.5)

	setActive(findTF(var0, "bg_gold"), false)
	setActive(findTF(var0, "bg_oil"), false)
	setActive(findTF(var0, "bg_item"), false)

	local var2 = arg0:getPtAwardData(arg0.useCount + 1)

	if var2 then
		if var2[1] == 1 and var2[2] == 1 then
			setActive(findTF(var0, "bg_gold"), true)
		elseif var2[1] == 1 and var2[2] == 2 then
			setActive(findTF(var0, "bg_oil"), true)
		elseif var2[1] == 2 and var2[2] == 54016 then
			setActive(findTF(var0, "bg_item"), true)
		else
			PoolMgr.GetInstance():GetSpineChar(var4, true, function(arg0)
				if var0 then
					arg0.transform.localScale = Vector3(0.5, 0.5, 0.5)
					arg0.transform.localPosition = Vector3.zero

					arg0.transform:SetParent(findTF(var0, "baoxiang"), false)

					local var0 = arg0:GetComponent(typeof(SpineAnimUI))

					arg0:setModelAnim(var0, "putong_guan", 0, nil)

					arg0.putongModel = arg0
				else
					table.insert(arg0.baoxiangCells, arg0)
					setActive(arg0, false)
				end
			end)
		end
	else
		setActive(findTF(var0, "bg_item"), true)
	end

	setActive(var0, true)
	setParent(var0, arg0.cellPos)
	table.insert(arg0.mapCells, var0)
end

function var0.getPtAwardData(arg0, arg1)
	if not arg0.ptDatas then
		arg0.ptDatas = pg.activity_event_pt[arg0.activityId].drop_client
	end

	if arg1 <= #arg0.ptDatas then
		return arg0.ptDatas[arg1]
	end

	return nil
end

function var0.insertMapTf(arg0, arg1, arg2, arg3)
	if arg2 == var23 then
		SetParent(arg1, findTF(arg0.container, "back"))
	elseif arg2 == var24 then
		SetParent(arg1, findTF(arg0.container, "mid"))
	elseif arg2 == var25 then
		SetParent(arg1, findTF(arg0.container, "front"))
	else
		print("没有配置层级，无法分配背景tf")
	end

	setActive(arg1, true)

	arg1.anchoredPosition = Vector2(arg3, 0)
end

function var0.sortMap(arg0, arg1)
	local var0 = {}

	for iter0 = 1, #arg0.mapGround do
		if arg0.mapGround[iter0].layer == arg1 then
			table.insert(var0, arg0.mapGround[iter0])
		end
	end

	table.sort(var0, function(arg0, arg1)
		if arg0.index > arg1.index then
			return false
		elseif arg0.index < arg1.index then
			return true
		end
	end)

	for iter1 = 1, #var0 do
		local var1 = var0[iter1].tfs

		for iter2, iter3 in ipairs(var1) do
			iter3:SetAsLastSibling()
		end
	end
end

function var0.getGround(arg0, arg1)
	for iter0 = 1, #arg0.mapGround do
		local var0 = arg0.mapGround[iter0]

		if var0.name == arg1 then
			return var0
		end
	end

	return nil
end

function var0.updateMap(arg0, arg1, arg2)
	if arg0.char then
		arg0.char.anchoredPosition = Vector2(arg0.char.anchoredPosition.x + arg1, arg0.char.anchoredPosition.y)
	end

	arg0.translate.anchoredPosition = Vector2(arg0.mid.anchoredPosition.x + arg0.distance - arg1, 0)

	if arg0.mapTf:InverseTransformPoint(arg0.translate.position).x <= var27 - 600 then
		if arg0.useCount < 9 then
			arg0:createMap("ground_1")
		elseif arg0.useCount < 20 then
			arg0:createMap("ground_4")
		end
	end

	arg0.moveDistance = arg0.moveDistance + arg1
	arg0.back.anchoredPosition = Vector2(arg0.back.anchoredPosition.x - arg1, 0)
	arg0.mid.anchoredPosition = Vector2(arg0.mid.anchoredPosition.x - arg1, 0)
	arg0.front.anchoredPosition = Vector2(arg0.front.anchoredPosition.x - arg1, 0)

	if #arg0.mapCells > 0 and arg0.mapTf:InverseTransformPoint(arg0.mapCells[1].position).x < -1500 then
		local var0 = table.remove(arg0.mapCells, 1)

		Destroy(var0)
	end
end

function var0.setModelAnim(arg0, arg1, arg2, arg3, arg4)
	arg1:SetActionCallBack(nil)
	arg1:SetAction(arg2, 0)
	arg1:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			if arg3 == 1 then
				arg1:SetActionCallBack(nil)
			end

			if arg4 then
				arg4()
			end
		end
	end)

	if arg3 ~= 1 and arg4 then
		arg4()
	end
end

function var0.changeCharAction(arg0, arg1, arg2, arg3)
	for iter0 = 1, #arg0.anims do
		local var0 = iter0
		local var1 = arg0.anims[iter0]

		var1:SetActionCallBack(nil)
		var1:SetAction(arg1, 0)
		var1:SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				if arg2 == 1 then
					var1:SetActionCallBack(nil)
					var1:SetAction(var11, 0)
				end

				if var0 == 1 and arg3 then
					arg3()
				end
			end
		end)

		if var0 == 1 and arg2 ~= 1 and arg3 then
			arg3()
		end
	end
end

function var0.onHide(arg0)
	return
end

function var0.willExit(arg0)
	if LeanTween.isTweening(go(arg0.cellPos)) then
		LeanTween.cancel(go(arg0.cellPos))
	end

	if LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end

	if #arg0.baoxiangCells > 0 then
		for iter0 = 1, #arg0.baoxiangCells do
			PoolMgr.GetInstance():ReturnSpineChar(var4, arg0.baoxiangCells[iter0])
		end

		arg0.baoxiangCells = {}
	end

	if arg0.enemyModel then
		PoolMgr.GetInstance():ReturnSpineChar(var5, arg0.enemyModel)
	end

	if arg0.baoxiangModel then
		PoolMgr.GetInstance():ReturnSpineChar(var3, arg0.baoxiangModel)
	end

	if arg0.mingShimodel then
		PoolMgr.GetInstance():ReturnSpineChar(var1, arg0.mingShimodel)
	end

	for iter1 = 1, #arg0.models do
		PoolMgr.GetInstance():ReturnSpineChar(arg0.modelIds[iter1], arg0.models[iter1])
	end

	for iter2 = #arg0.mapCells, 1, -1 do
		Destroy(arg0.mapCells[iter2])
	end

	arg0.mapCells = {}

	if arg0.awardsTimer then
		if arg0.awardsTimer.running then
			arg0.awardsTimer:Stop()
		end

		arg0.awardsTimer = nil
	end

	if arg0.awardTfs and #arg0.awardTfs > 0 then
		for iter3 = #arg0.awardTfs, 1, -1 do
			Destroy(table.remove(arg0.awardTfs, iter3))
		end
	end
end

return var0
