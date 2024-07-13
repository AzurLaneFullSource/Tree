local var0_0 = class("MonopolyPtScene", import("..base.BaseUI"))

var0_0.story = false

local var1_0 = 312011
local var2_0 = 312010
local var3_0 = "kaibaoxiang_boss"
local var4_0 = "kaibaoxiang_putong"
local var5_0 = "unknown3"

var0_0.battle = false

local var6_0 = {
	201211,
	401231,
	301051,
	101171
}
local var7_0 = {
	201217,
	431232,
	331055,
	131171
}
local var8_0 = 0.6
local var9_0 = 100
local var10_0 = "dafuweng_walk"
local var11_0 = "stand"
local var12_0 = "dafuweng_stand"
local var13_0 = "dafuweng_jump"
local var14_0 = "dafuweng_run"
local var15_0 = "dafuweng_touch"
local var16_0 = "maoxian_baoxiang"
local var17_0 = "maoxian_gold"
local var18_0 = "maoxian_item"
local var19_0 = "maoxian_oil"
local var20_0 = 35
local var21_0 = 1
local var22_0 = 2
local var23_0 = "back"
local var24_0 = "mid"
local var25_0 = "front"
local var26_0 = 2
local var27_0 = 1920
local var28_0 = 1080
local var29_0 = false
local var30_0 = 0
local var31_0 = {
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

function var0_0.getUIName(arg0_1)
	return "MonopolyPtUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:initEvent()
	arg0_2:activityDataUpdata()
	arg0_2:updataUI()
	arg0_2:initMap()
end

function var0_0.initMap(arg0_3)
	if arg0_3.useCount < 9 then
		arg0_3:createMap("ground_1")
	elseif arg0_3.useCount == 9 then
		arg0_3:createMap("ground_2")
		arg0_3:createMap("ground_3")
		arg0_3:createMap("ground_4")
	elseif arg0_3.useCount == 10 then
		arg0_3:createMap("ground_3")
		arg0_3:createMap("ground_4")
	elseif arg0_3.useCount > 9 and arg0_3.useCount < 19 then
		arg0_3:createMap("ground_4")
	elseif arg0_3.useCount == 19 then
		arg0_3:createMap("ground_5")

		if MonopolyPtScene.battle then
			LeanTween.delayedCall(go(arg0_3._tf), 1, System.Action(function()
				local var0_4 = arg0_3:getPtData()
				local var1_4, var2_4 = var0_4:GetResProgress()

				pg.m02:sendNotification(GAME.ACT_NEW_PT, {
					cmd = 1,
					activity_id = var0_4:GetId(),
					arg1 = var2_4
				})
			end))

			if arg0_3.baoxiangModel then
				local var0_3 = arg0_3.baoxiangModel:GetComponent(typeof(SpineAnimUI))

				arg0_3:setModelAnim(var0_3, "boss_kaiqi", 1, function()
					arg0_3:setModelAnim(var0_3, "boss_kai", 0, nil)
				end)
				arg0_3:changeCharAction(var16_0, 1, nil)
			else
				arg0_3.baoxiangKai = true
			end

			if arg0_3.anims then
				arg0_3:changeCharAction(var16_0, 1, nil)
			else
				arg0_3.charMaoxian = true
			end
		end
	elseif arg0_3.useCount >= 20 then
		arg0_3:createMap("ground_5")
	end

	if arg0_3.useCount > 0 then
		if MonopolyPtScene.battle and arg0_3.useCount >= 19 then
			arg0_3:updateMap(var31_0[#var31_0])
		else
			arg0_3:updateMap(var31_0[arg0_3.useCount])
		end

		for iter0_3 = 1, 20 do
			arg0_3.translate.anchoredPosition = Vector2(arg0_3.mid.anchoredPosition.x + arg0_3.distance, 0)

			if arg0_3.mapTf:InverseTransformPoint(arg0_3.translate.position).x <= var27_0 - 600 then
				arg0_3:createMap()
			end
		end
	end

	if arg0_3.useCount == 0 and not MonopolyPtScene.story then
		local var1_3 = arg0_3:getStoryData(0)

		setActive(arg0_3.btnStart, false)
		setActive(arg0_3.btnBack, false)
		setActive(arg0_3.btnMain, false)
		setActive(arg0_3.labelDropShip, false)
		pg.NewStoryMgr.GetInstance():Play(var1_3, function()
			MonopolyPtScene.story = true

			setActive(arg0_3.btnStart, true)
			setActive(arg0_3.btnBack, true)
			setActive(arg0_3.btnMain, true)
			setActive(arg0_3.labelDropShip, false)
			arg0_3:updataUI()
		end, true, true)
	end
end

local var32_0 = {
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

function var0_0.createMap(arg0_7, arg1_7)
	if not arg0_7.mapIndexs then
		arg0_7.mapIndexs = Clone(var32_0)
	end

	if #arg0_7.mapIndexs == 0 then
		return
	end

	arg1_7 = "ground_" .. table.remove(arg0_7.mapIndexs, 1)

	if arg1_7 == "ground_2" or arg1_7 == "ground_3" or arg1_7 == "ground_5" then
		if not arg0_7.onceMap then
			arg0_7.onceMap = {}
		end

		if table.contains(arg0_7.onceMap, arg1_7) then
			return
		else
			table.insert(arg0_7.onceMap, arg1_7)
		end
	end

	local var0_7 = findTF(arg0_7.groundTf, arg1_7)
	local var1_7 = tf(Instantiate(var0_7))
	local var2_7 = findTF(var1_7, "back")

	SetParent(var2_7, arg0_7.back)
	setActive(var2_7, true)

	var2_7.anchoredPosition = Vector2(arg0_7.distance, 0)

	var2_7:SetAsFirstSibling()

	local var3_7 = findTF(var1_7, "mid")

	SetParent(var3_7, arg0_7.mid)
	setActive(var3_7, true)

	var3_7.anchoredPosition = Vector2(arg0_7.distance, 0)

	local var4_7 = findTF(var1_7, "front")

	SetParent(var4_7, arg0_7.front)
	setActive(var4_7, true)

	var4_7.anchoredPosition = Vector2(arg0_7.distance, 0)

	Destroy(var1_7)

	local var5_7 = var1_7.sizeDelta.x

	arg0_7.distance = arg0_7.distance + var5_7

	if arg0_7.cellPos then
		arg0_7.cellPos:SetAsLastSibling()
	end

	if arg0_7.char then
		arg0_7.char:SetAsLastSibling()
	end

	if arg1_7 == "ground_2" then
		arg0_7.housePosition = findTF(var3_7, "house/img").position
	elseif arg1_7 == "ground_5" then
		arg0_7.endPosition = findTF(var3_7, "house/img").position
	end

	if arg1_7 == "ground_2" then
		local var6_7 = Ship.New({
			configId = var1_0,
			skin_id = var2_0
		}):getPrefab()

		PoolMgr.GetInstance():GetSpineChar(var6_7, true, function(arg0_8)
			arg0_7.mingShimodel = arg0_8
			arg0_7.mingShimodel.transform.localScale = Vector3(0.4, 0.4, 0.4)
			arg0_7.mingShimodel.transform.localPosition = Vector3.zero

			arg0_7.mingShimodel.transform:SetParent(findTF(var3_7, "house/char"), false)

			local var0_8 = arg0_7.mingShimodel:GetComponent(typeof(SpineAnimUI))

			arg0_7:setModelAnim(var0_8, var11_0, 0, nil)
		end)
	elseif arg1_7 == "ground_5" then
		if arg0_7.useCount <= 19 and not MonopolyPtScene.battle then
			PoolMgr.GetInstance():GetSpineChar(var5_0, true, function(arg0_9)
				arg0_7.enemyModel = arg0_9
				arg0_7.enemyModel.transform.localScale = Vector3(0.4, 0.4, 0.4)
				arg0_7.enemyModel.transform.localPosition = Vector3.zero

				arg0_7.enemyModel.transform:SetParent(findTF(var3_7, "house/enemy"), false)

				local var0_9 = arg0_7.enemyModel:GetComponent(typeof(SpineAnimUI))

				arg0_7:setModelAnim(var0_9, "normal", 0, nil)
			end)
		else
			PoolMgr.GetInstance():GetSpineChar(var3_0, true, function(arg0_10)
				arg0_7.baoxiangModel = arg0_10
				arg0_7.baoxiangModel.transform.localScale = Vector3(0.3, 0.3, 0.3)
				arg0_7.baoxiangModel.transform.localPosition = Vector3.zero

				arg0_7.baoxiangModel.transform:SetParent(findTF(var3_7, "house/baoxiang"), false)

				local var0_10 = arg0_7.baoxiangModel:GetComponent(typeof(SpineAnimUI))

				if arg0_7.baoxiangKai then
					arg0_7.baoxiangKai = false

					local var1_10 = arg0_7.baoxiangModel:GetComponent(typeof(SpineAnimUI))

					arg0_7:setModelAnim(var1_10, "boss_kaiqi", 1, function()
						arg0_7:setModelAnim(var1_10, "boss_kai", 0, nil)
					end)
					arg0_7:changeCharAction(var16_0, 1, nil)
				elseif arg0_7.useCount >= 20 then
					arg0_7:setModelAnim(var0_10, "boss_kai", 0, nil)
				else
					arg0_7:setModelAnim(var0_10, "boss_guan", 0, nil)
					setActive(arg0_7.baoxiangModel, false)
				end
			end)
		end
	end
end

function var0_0.initData(arg0_12)
	arg0_12.distance = 0
	arg0_12.moveDistance = 0
	arg0_12.activityId = arg0_12.contextData.config_id
	arg0_12.leftCount = 0
	arg0_12.inAnimatedFlag = false
	arg0_12.lastBonusTimes = 0
	arg0_12.baoxiangCells = {}

	local var0_12 = pg.activity_template[arg0_12.activityId]

	arg0_12.storys = var0_12.config_client.story
	arg0_12.battles = var0_12.config_client.battle
	arg0_12.awardsTimer = Timer.New(function()
		if arg0_12.awardTfs and #arg0_12.awardTfs > 0 then
			for iter0_13 = #arg0_12.awardTfs, 1, -1 do
				local var0_13 = arg0_12.awardTfs[iter0_13]
				local var1_13 = var0_13.anchoredPosition

				var1_13.y = var1_13.y + 3

				if var1_13.y >= 150 then
					Destroy(table.remove(arg0_12.awardTfs, iter0_13))
				else
					var0_13.anchoredPosition = var1_13
				end
			end
		end
	end, 0.0333333333333333, -1)

	arg0_12.awardsTimer:Start()
end

function var0_0.initUI(arg0_14)
	arg0_14._ad = findTF(arg0_14._tf, "AD")
	arg0_14.char = findTF(arg0_14._ad, "map/mask/container/mid/char")
	arg0_14.btnStart = findTF(arg0_14._ad, "btnStart")
	arg0_14.btnBack = findTF(arg0_14._ad, "btnBack")
	arg0_14.labelCount = findTF(arg0_14._ad, "btnStart/txt")

	setActive(arg0_14.btnStart, true)

	arg0_14.btnMain = findTF(arg0_14._ad, "btnMain")
	arg0_14.labelDropShip = findTF(arg0_14._ad, "labelDropShip")
	arg0_14.mapTf = findTF(arg0_14._ad, "map")
	arg0_14.container = findTF(arg0_14._ad, "map/mask/container")
	arg0_14.back = findTF(arg0_14._ad, "map/mask/container/back")
	arg0_14.mid = findTF(arg0_14._ad, "map/mask/container/mid")
	arg0_14.front = findTF(arg0_14._ad, "map/mask/container/front")
	arg0_14.cellPos = findTF(arg0_14._ad, "map/mask/container/mid/posCell")
	arg0_14.tplCell = findTF(arg0_14._ad, "tplCell")
	arg0_14.mapCells = {}
	arg0_14.curCellIndex = nil
	arg0_14.translate = findTF(arg0_14.container, "translate")
	arg0_14.awardTf = findTF(arg0_14._ad, "awardTpl")
	arg0_14.awardParent = findTF(arg0_14.char, "award")
	arg0_14.groundTf = findTF(arg0_14._ad, "map/mask/container/ground")

	setActive(arg0_14.groundTf, false)

	arg0_14.models = {}
	arg0_14.anims = {}
	arg0_14.modelIds = {}
	arg0_14.clickModelTime = {}

	for iter0_14 = 1, #var6_0 do
		local var0_14 = iter0_14
		local var1_14 = var6_0[iter0_14]
		local var2_14 = var7_0[iter0_14]
		local var3_14 = {
			configId = var1_14,
			skin_id = var2_14
		}
		local var4_14 = Ship.New(var3_14):getPrefab()

		PoolMgr.GetInstance():GetSpineChar(var4_14, true, function(arg0_15)
			arg0_15.transform.localScale = Vector3.one
			arg0_15.transform.localPosition = Vector3(0, 0, 0)
			arg0_15.transform.anchorMin = Vector2(0.5, 0)
			arg0_15.transform.anchorMax = Vector2(0.5, 0)

			arg0_15.transform:SetParent(findTF(arg0_14.char, var0_14), false)

			local var0_15 = arg0_15:GetComponent(typeof(SpineAnimUI))

			table.insert(arg0_14.modelIds, var1_14)
			table.insert(arg0_14.models, arg0_15)
			table.insert(arg0_14.anims, var0_15)

			if #arg0_14.anims == #var6_0 then
				if arg0_14.charMaoxian then
					arg0_14.charMaoxian = false

					arg0_14:changeCharAction(var16_0, 0, nil)
				else
					arg0_14:changeCharAction(var11_0, 0, nil)
				end
			end

			table.insert(arg0_14.clickModelTime, 0)
			onButton(arg0_14._binder, findTF(arg0_14.char, var0_14).transform, function()
				if not var0_15 or not arg0_15 or arg0_14.inAnimatedFlag then
					return
				end

				if Time.time - arg0_14.clickModelTime[var0_14] < 3 then
					return
				end

				arg0_14.clickModelTime[var0_14] = Time.time

				if LeanTween.isTweening(go(arg0_14.cellPos)) then
					return
				end

				arg0_14:setModelAnim(var0_15, var15_0, 1, function()
					arg0_14:setModelAnim(var0_15, var11_0, 0, nil)
				end)
			end, SFX_PANEL)
		end)
	end
end

function var0_0.initEvent(arg0_18)
	onButton(arg0_18._binder, arg0_18.btnStart, function()
		if arg0_18.leftCount and arg0_18.leftCount <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end

		local var0_19 = {}
		local var1_19 = arg0_18:getPtData():GetAward()
		local var2_19 = getProxy(PlayerProxy):getRawData()
		local var3_19 = pg.gameset.urpt_chapter_max.description[1]
		local var4_19 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_19)
		local var5_19, var6_19 = Task.StaticJudgeOverflow(var2_19.gold, var2_19.oil, var4_19, true, true, {
			{
				var1_19.type,
				var1_19.id,
				var1_19.count
			}
		})

		if var5_19 then
			table.insert(var0_19, function(arg0_20)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_19,
					onYes = arg0_20
				})
			end)
		end

		seriesAsync(var0_19, function()
			arg0_18:start()
		end)
	end, SFX_PANEL)
	onButton(arg0_18._binder, arg0_18.btnBack, function()
		arg0_18:closeView()
	end, SFX_PANEL)
	onButton(arg0_18._binder, arg0_18.btnMain, function()
		arg0_18:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
end

function var0_0.getPtData(arg0_24)
	local var0_24 = getProxy(ActivityProxy):getActivityById(arg0_24.activityId)

	return (ActivityPtData.New(var0_24))
end

function var0_0.addAwards(arg0_25, arg1_25)
	if not arg0_25.awardTfs then
		arg0_25.awardTfs = {}
	end

	for iter0_25 = 1, #arg1_25 do
		local var0_25 = arg1_25[iter0_25]
		local var1_25 = tf(instantiate(go(arg0_25.awardTf)))

		setParent(var1_25, arg0_25.awardParent)
		updateDrop(var1_25, var0_25)

		var1_25.anchoredPosition = Vector2(0, 0)

		setActive(var1_25, true)
		table.insert(arg0_25.awardTfs, var1_25)
	end
end

function var0_0.start(arg0_26)
	if arg0_26.inAnimatedFlag then
		return
	end

	if arg0_26.leftCount and arg0_26.leftCount <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

		return
	end

	arg0_26:changeAnimeState(true)

	local var0_26 = var14_0

	arg0_26:move(var0_26, function()
		return
	end)
end

function var0_0.checkCountStory(arg0_28, arg1_28)
	local var0_28 = arg0_28.useCount
	local var1_28 = arg0_28.activity:getDataConfig("story") or {}
	local var2_28 = _.detect(var1_28, function(arg0_29)
		return arg0_29[1] == var0_28
	end)

	if var2_28 then
		pg.NewStoryMgr.GetInstance():Play(var2_28[2], arg1_28)
	else
		arg1_28()
	end
end

function var0_0.changeAnimeState(arg0_30, arg1_30, arg2_30)
	if arg1_30 then
		arg0_30.btnStart:GetComponent(typeof(Image)).raycastTarget = false
		arg0_30.inAnimatedFlag = true
	else
		arg0_30.inAnimatedFlag = false
		arg0_30.btnStart:GetComponent(typeof(Image)).raycastTarget = true
	end

	setActive(arg0_30.btnStart, not arg1_30)
end

function var0_0.updataActivity(arg0_31, arg1_31)
	arg0_31:activityDataUpdata()
	arg0_31:updataUI()

	if arg0_31.useCount == 9 then
		arg0_31:createMap("ground_2")
		arg0_31:createMap("ground_3")
	elseif arg0_31.useCount == 19 then
		arg0_31:createMap("ground_5")
	end
end

function var0_0.activityDataUpdata(arg0_32)
	local var0_32 = getProxy(ActivityProxy):getActivityById(arg0_32.activityId)
	local var1_32 = ActivityPtData.New(var0_32)
	local var2_32, var3_32, var4_32 = var1_32:GetResProgress()
	local var5_32 = var1_32:GetLevel()
	local var6_32 = var1_32:CanGetAward()
	local var7_32 = var1_32:CanGetNextAward()
	local var8_32 = 20 - var5_32
	local var9_32 = math.floor(var2_32 / 500) - var5_32

	if var8_32 < var9_32 then
		var9_32 = var8_32
	end

	arg0_32.useCount = var5_32
	arg0_32.leftCount = var9_32

	if var29_0 then
		var30_0 = var30_0 + 1
		arg0_32.useCount = var30_0
		arg0_32.leftCount = 20 - var30_0
	end

	arg0_32.leftLastDrop = 20 - arg0_32.useCount
end

function var0_0.updataUI(arg0_33)
	if arg0_33.leftLastDrop then
		setText(findTF(arg0_33.labelDropShip, "text"), "" .. arg0_33.leftLastDrop)
		setActive(arg0_33.labelDropShip, arg0_33.leftLastDrop > 0)
	end

	setText(arg0_33.labelCount, arg0_33.leftCount)

	if arg0_33.useCount >= 20 then
		setActive(arg0_33.btnStart, false)
	end
end

function var0_0.updataChar(arg0_34)
	if not isActive(arg0_34.char) then
		SetActive(arg0_34.char, true)
		arg0_34.char:SetAsLastSibling()
	end
end

function var0_0.move(arg0_35, arg1_35, arg2_35)
	local var0_35 = {}

	table.insert(var0_35, function(arg0_36)
		if arg0_35.useCount >= #var31_0 then
			arg0_35.useCount = #var31_0 - 1
		end

		local var0_36 = var31_0[arg0_35.useCount + 1] - arg0_35.moveDistance

		if arg0_35.useCount == 9 and arg0_35.housePosition then
			-- block empty
		elseif arg0_35.useCount == 19 and arg0_35.endPosition then
			-- block empty
		elseif arg0_35.useCount == 10 then
			arg0_35:createCell(var0_36)
		else
			arg0_35:createCell(var0_36)
		end

		local var1_36 = var0_36 / 250
		local var2_36 = 0

		arg0_35:changeCharAction(arg1_35, 0, nil)

		local var3_36 = var0_36 / (var1_36 / 0.6)
		local var4_36 = 0

		if LeanTween.isTweening(go(arg0_35.cellPos)) then
			LeanTween.cancel(go(arg0_35.cellPos))
		end

		LeanTween.value(go(arg0_35.cellPos), 0, var0_36, var1_36):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0_37)
			arg0_35:updateMap(arg0_37 - var2_36)

			var2_36 = arg0_37
		end)):setOnComplete(System.Action(function()
			local var0_38

			if arg0_35.useCount > 1 then
				var0_38 = arg0_35:getStoryData(arg0_35.useCount + 1)
			end

			local var1_38 = arg0_35:getBattle(arg0_35.useCount + 1)
			local var2_38 = arg0_35.useCount + 1

			arg0_35:changeCharAction(var11_0, 0, nil)

			local function var3_38()
				local var0_39 = arg0_35:getPtAwardData(var2_38)

				assert(var0_39)

				if var0_39[1] == 1 and var0_39[2] == 1 then
					arg0_35:setModelAnim(arg0_35.anims[1], var17_0, 1, function()
						arg0_35:setModelAnim(arg0_35.anims[1], var11_0, 0)
					end)
				elseif var0_39[1] == 1 and var0_39[2] == 2 then
					arg0_35:setModelAnim(arg0_35.anims[1], var19_0, 1, function()
						arg0_35:setModelAnim(arg0_35.anims[1], var11_0, 0)
					end)
				elseif var0_39[1] == 2 and var0_39[2] == 54016 then
					arg0_35:setModelAnim(arg0_35.anims[1], var18_0, 1, function()
						arg0_35:setModelAnim(arg0_35.anims[1], var11_0, 0)
					end)
				else
					arg0_35:setModelAnim(arg0_35.anims[1], var16_0, 1, function()
						arg0_35:setModelAnim(arg0_35.anims[1], var11_0, 0)
					end)
				end

				for iter0_39 = 2, #arg0_35.anims do
					arg0_35:setModelAnim(arg0_35.anims[iter0_39], var16_0, 1, function()
						arg0_35:setModelAnim(arg0_35.anims[iter0_39], var11_0, 0)
					end)
				end
			end

			if arg0_35.putongModel then
				local var4_38 = arg0_35.putongModel:GetComponent(typeof(SpineAnimUI))

				arg0_35:setModelAnim(var4_38, "putong_kaiqi", 1, function()
					if var4_38 then
						arg0_35:setModelAnim(var4_38, "putong_kai", 0, nil)
					end
				end)

				arg0_35.putongModel = nil
			end

			if var0_38 and tonumber(var0_38) ~= 0 then
				pg.NewStoryMgr.GetInstance():Play(var0_38, function()
					if var3_38 then
						var3_38()
					end

					LeanTween.delayedCall(go(arg0_35._tf), 1, System.Action(function()
						arg0_36()
					end))
				end, true, true)
			elseif arg0_35.useCount == 19 and tonumber(var1_38) ~= 0 and not MonopolyPtScene.battle then
				MonopolyPtScene.battle = true

				pg.m02:sendNotification(GAME.BEGIN_STAGE, {
					system = SYSTEM_PERFORM,
					stageId = tonumber(var1_38)
				})
			else
				if var3_38 then
					var3_38()
				end

				LeanTween.delayedCall(go(arg0_35._tf), 1, System.Action(function()
					arg0_36()
				end))
			end
		end))
	end)
	table.insert(var0_35, function(arg0_49)
		local var0_49 = arg0_35:getPtData()
		local var1_49, var2_49 = var0_49:GetResProgress()

		pg.m02:sendNotification(GAME.ACT_NEW_PT, {
			cmd = 1,
			activity_id = var0_49:GetId(),
			arg1 = var2_49
		})
		arg0_35:changeAnimeState(false)
		arg0_35:updataActivity()
		arg0_49()
	end)
	seriesAsync(var0_35, arg2_35)
end

function var0_0.getBattle(arg0_50, arg1_50)
	for iter0_50 = 1, #arg0_50.battles do
		if arg0_50.battles[iter0_50][1] == arg1_50 then
			return arg0_50.battles[iter0_50][2]
		end
	end

	return nil
end

function var0_0.getStoryData(arg0_51, arg1_51)
	for iter0_51 = 1, #arg0_51.storys do
		if arg0_51.storys[iter0_51][1] == arg1_51 then
			return arg0_51.storys[iter0_51][2]
		end
	end

	return nil
end

function var0_0.createCell(arg0_52, arg1_52, arg2_52)
	local var0_52 = tf(instantiate(go(arg0_52.tplCell)))
	local var1_52 = arg0_52.cellPos:InverseTransformPoint(arg0_52.char.position)

	var0_52.localPosition = Vector3(var1_52.x + arg1_52 + 100, 0, 0)
	var0_52.localScale = Vector3(0.5, 0.5, 0.5)

	setActive(findTF(var0_52, "bg_gold"), false)
	setActive(findTF(var0_52, "bg_oil"), false)
	setActive(findTF(var0_52, "bg_item"), false)

	local var2_52 = arg0_52:getPtAwardData(arg0_52.useCount + 1)

	if var2_52 then
		if var2_52[1] == 1 and var2_52[2] == 1 then
			setActive(findTF(var0_52, "bg_gold"), true)
		elseif var2_52[1] == 1 and var2_52[2] == 2 then
			setActive(findTF(var0_52, "bg_oil"), true)
		elseif var2_52[1] == 2 and var2_52[2] == 54016 then
			setActive(findTF(var0_52, "bg_item"), true)
		else
			PoolMgr.GetInstance():GetSpineChar(var4_0, true, function(arg0_53)
				if var0_52 then
					arg0_53.transform.localScale = Vector3(0.5, 0.5, 0.5)
					arg0_53.transform.localPosition = Vector3.zero

					arg0_53.transform:SetParent(findTF(var0_52, "baoxiang"), false)

					local var0_53 = arg0_53:GetComponent(typeof(SpineAnimUI))

					arg0_52:setModelAnim(var0_53, "putong_guan", 0, nil)

					arg0_52.putongModel = arg0_53
				else
					table.insert(arg0_52.baoxiangCells, arg0_53)
					setActive(arg0_53, false)
				end
			end)
		end
	else
		setActive(findTF(var0_52, "bg_item"), true)
	end

	setActive(var0_52, true)
	setParent(var0_52, arg0_52.cellPos)
	table.insert(arg0_52.mapCells, var0_52)
end

function var0_0.getPtAwardData(arg0_54, arg1_54)
	if not arg0_54.ptDatas then
		arg0_54.ptDatas = pg.activity_event_pt[arg0_54.activityId].drop_client
	end

	if arg1_54 <= #arg0_54.ptDatas then
		return arg0_54.ptDatas[arg1_54]
	end

	return nil
end

function var0_0.insertMapTf(arg0_55, arg1_55, arg2_55, arg3_55)
	if arg2_55 == var23_0 then
		SetParent(arg1_55, findTF(arg0_55.container, "back"))
	elseif arg2_55 == var24_0 then
		SetParent(arg1_55, findTF(arg0_55.container, "mid"))
	elseif arg2_55 == var25_0 then
		SetParent(arg1_55, findTF(arg0_55.container, "front"))
	else
		print("没有配置层级，无法分配背景tf")
	end

	setActive(arg1_55, true)

	arg1_55.anchoredPosition = Vector2(arg3_55, 0)
end

function var0_0.sortMap(arg0_56, arg1_56)
	local var0_56 = {}

	for iter0_56 = 1, #arg0_56.mapGround do
		if arg0_56.mapGround[iter0_56].layer == arg1_56 then
			table.insert(var0_56, arg0_56.mapGround[iter0_56])
		end
	end

	table.sort(var0_56, function(arg0_57, arg1_57)
		if arg0_57.index > arg1_57.index then
			return false
		elseif arg0_57.index < arg1_57.index then
			return true
		end
	end)

	for iter1_56 = 1, #var0_56 do
		local var1_56 = var0_56[iter1_56].tfs

		for iter2_56, iter3_56 in ipairs(var1_56) do
			iter3_56:SetAsLastSibling()
		end
	end
end

function var0_0.getGround(arg0_58, arg1_58)
	for iter0_58 = 1, #arg0_58.mapGround do
		local var0_58 = arg0_58.mapGround[iter0_58]

		if var0_58.name == arg1_58 then
			return var0_58
		end
	end

	return nil
end

function var0_0.updateMap(arg0_59, arg1_59, arg2_59)
	if arg0_59.char then
		arg0_59.char.anchoredPosition = Vector2(arg0_59.char.anchoredPosition.x + arg1_59, arg0_59.char.anchoredPosition.y)
	end

	arg0_59.translate.anchoredPosition = Vector2(arg0_59.mid.anchoredPosition.x + arg0_59.distance - arg1_59, 0)

	if arg0_59.mapTf:InverseTransformPoint(arg0_59.translate.position).x <= var27_0 - 600 then
		if arg0_59.useCount < 9 then
			arg0_59:createMap("ground_1")
		elseif arg0_59.useCount < 20 then
			arg0_59:createMap("ground_4")
		end
	end

	arg0_59.moveDistance = arg0_59.moveDistance + arg1_59
	arg0_59.back.anchoredPosition = Vector2(arg0_59.back.anchoredPosition.x - arg1_59, 0)
	arg0_59.mid.anchoredPosition = Vector2(arg0_59.mid.anchoredPosition.x - arg1_59, 0)
	arg0_59.front.anchoredPosition = Vector2(arg0_59.front.anchoredPosition.x - arg1_59, 0)

	if #arg0_59.mapCells > 0 and arg0_59.mapTf:InverseTransformPoint(arg0_59.mapCells[1].position).x < -1500 then
		local var0_59 = table.remove(arg0_59.mapCells, 1)

		Destroy(var0_59)
	end
end

function var0_0.setModelAnim(arg0_60, arg1_60, arg2_60, arg3_60, arg4_60)
	arg1_60:SetActionCallBack(nil)
	arg1_60:SetAction(arg2_60, 0)
	arg1_60:SetActionCallBack(function(arg0_61)
		if arg0_61 == "finish" then
			if arg3_60 == 1 then
				arg1_60:SetActionCallBack(nil)
			end

			if arg4_60 then
				arg4_60()
			end
		end
	end)

	if arg3_60 ~= 1 and arg4_60 then
		arg4_60()
	end
end

function var0_0.changeCharAction(arg0_62, arg1_62, arg2_62, arg3_62)
	for iter0_62 = 1, #arg0_62.anims do
		local var0_62 = iter0_62
		local var1_62 = arg0_62.anims[iter0_62]

		var1_62:SetActionCallBack(nil)
		var1_62:SetAction(arg1_62, 0)
		var1_62:SetActionCallBack(function(arg0_63)
			if arg0_63 == "finish" then
				if arg2_62 == 1 then
					var1_62:SetActionCallBack(nil)
					var1_62:SetAction(var11_0, 0)
				end

				if var0_62 == 1 and arg3_62 then
					arg3_62()
				end
			end
		end)

		if var0_62 == 1 and arg2_62 ~= 1 and arg3_62 then
			arg3_62()
		end
	end
end

function var0_0.onHide(arg0_64)
	return
end

function var0_0.willExit(arg0_65)
	if LeanTween.isTweening(go(arg0_65.cellPos)) then
		LeanTween.cancel(go(arg0_65.cellPos))
	end

	if LeanTween.isTweening(go(arg0_65._tf)) then
		LeanTween.cancel(go(arg0_65._tf))
	end

	if #arg0_65.baoxiangCells > 0 then
		for iter0_65 = 1, #arg0_65.baoxiangCells do
			PoolMgr.GetInstance():ReturnSpineChar(var4_0, arg0_65.baoxiangCells[iter0_65])
		end

		arg0_65.baoxiangCells = {}
	end

	if arg0_65.enemyModel then
		PoolMgr.GetInstance():ReturnSpineChar(var5_0, arg0_65.enemyModel)
	end

	if arg0_65.baoxiangModel then
		PoolMgr.GetInstance():ReturnSpineChar(var3_0, arg0_65.baoxiangModel)
	end

	if arg0_65.mingShimodel then
		PoolMgr.GetInstance():ReturnSpineChar(var1_0, arg0_65.mingShimodel)
	end

	for iter1_65 = 1, #arg0_65.models do
		PoolMgr.GetInstance():ReturnSpineChar(arg0_65.modelIds[iter1_65], arg0_65.models[iter1_65])
	end

	for iter2_65 = #arg0_65.mapCells, 1, -1 do
		Destroy(arg0_65.mapCells[iter2_65])
	end

	arg0_65.mapCells = {}

	if arg0_65.awardsTimer then
		if arg0_65.awardsTimer.running then
			arg0_65.awardsTimer:Stop()
		end

		arg0_65.awardsTimer = nil
	end

	if arg0_65.awardTfs and #arg0_65.awardTfs > 0 then
		for iter3_65 = #arg0_65.awardTfs, 1, -1 do
			Destroy(table.remove(arg0_65.awardTfs, iter3_65))
		end
	end
end

return var0_0
