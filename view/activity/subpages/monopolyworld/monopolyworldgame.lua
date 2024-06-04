local var0 = class("MonopolyWorldGame")
local var1 = 117
local var2 = 60
local var3 = {
	{
		0,
		4007,
		4008,
		4009,
		4010,
		0
	},
	{
		4005,
		4006,
		0,
		0,
		4011,
		4012
	},
	{
		4004,
		0,
		0,
		0,
		0,
		4013
	},
	{
		4003,
		4002,
		0,
		0,
		4015,
		4014
	},
	{
		0,
		4001,
		4018,
		4017,
		4016,
		0
	}
}
local var4 = "mengya"
local var5 = "monopoly_world_tip1"
local var6 = "monopoly_world_tip2"
local var7 = "monopoly_world_tip3"
local var8 = 0.6
local var9 = "dafuweng_gold"
local var10 = "dafuweng_oil"
local var11 = "dafuweng_event"
local var12 = "dafuweng_walk"
local var13 = "dafuweng_stand"
local var14 = "dafuweng_walk"
local var15 = "dafuweng_run"
local var16 = "dafuweng_touch"
local var17 = "cell gold"
local var18 = "cell move"
local var19 = "cell oil"
local var20 = "cell event"
local var21 = "cell item"
local var22 = {
	{
		path_length = 1,
		name = "gulitemengya_1",
		cell_type = var18
	},
	{
		path_length = 2,
		name = "gulitemengya_2",
		cell_type = var18
	},
	{
		path_length = 3,
		name = "gulitemengya_3",
		cell_type = var18
	},
	{
		name = "gulitemengya_daoju",
		cell_type = var21
	},
	{
		name = "gulitemengya_jinbi",
		cell_type = var17
	},
	{
		name = "gulitemengya_mingyun",
		cell_type = var20
	},
	{
		name = "gulitemengya_shiyou",
		cell_type = var19
	}
}
local var23 = {
	84180,
	84181,
	84183,
	84179,
	84182
}
local var24
local var25

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._binder = arg1
	arg0._tf = arg2
	arg0._event = arg3

	arg0:initData()
	arg0:initUI()
	arg0:initEvent()
end

function var0.initData(arg0)
	arg0.leftCount = 0
	arg0.inAnimatedFlag = false
	arg0.mapCells = {}
end

function var0.initUI(arg0)
	arg0.tplMapCell = findTF(arg0._tf, "tplMapCell")
	arg0.gameTipUI1 = findTF(arg0._tf, "btnStart/desc")

	setText(arg0.gameTipUI1, i18n(var5))

	arg0.gameTipUI2 = findTF(arg0._tf, "bg/desc")

	setText(arg0.gameTipUI2, "")

	arg0.mapContainer = findTF(arg0._tf, "mapContainer")
	arg0.char = findTF(arg0._tf, "mapContainer/char")

	setActive(arg0.char, false)

	arg0.btnStart = findTF(arg0._tf, "btnStart")
	arg0.effectStart = findTF(arg0.btnStart, "gulitemengya_pingmu")
	arg0.btnHelp = findTF(arg0._tf, "topRight/btnHelp")
	arg0.labelLeftCount = findTF(arg0.btnStart, "times")
	arg0.btnBack = findTF(arg0._tf, "leftTop/back")

	arg0:initMap()
	arg0:initChar()
	arg0:initFurn()
end

function var0.initFurn(arg0)
	local var0 = findTF(arg0._tf, "bg/mask/event"):GetComponent("HScrollSnap")

	arg0.bannerCanvas = GetComponent(findTF(arg0._tf, "bg/mask"), typeof(CanvasGroup))

	var0:Init()

	local var1 = findTF(var0, "content")
	local var2 = findTF(var0, "item")
	local var3 = findTF(arg0._tf, "bg/dots")
	local var4 = findTF(arg0._tf, "bg/dot")

	setActive(var2, false)
	setActive(var4, false)

	arg0.furnItems = {}

	for iter0 = 0, #var23 - 1 do
		cloneTplTo(var4, var3)

		local var5 = Instantiate(var2)

		var24 = pg.furniture_data_template[var23[iter0 + 1]]
		var25 = var24.icon

		GetImageSpriteFromAtlasAsync("ui/monopolyworldui_atlas", var25, findTF(var5, "img"), true)
		var0:AddChild(var5)
		setActive(var5, true)
		table.insert(arg0.furnItems, var5)
	end

	arg0.bannerSnap = var0
	arg0.bannerContent = var1
	arg0.bannerDots = var3
	arg0.furnNames = {}

	for iter1 = 1, #var23 do
		table.insert(arg0.furnNames, findTF(arg0._tf, "bg/furnName/img" .. iter1))
	end

	local function var6()
		for iter0 = 1, #var23 do
			if iter0 == arg0.bannerSnap:CurrentScreen() + 1 then
				if not isActive(arg0.furnNames[iter0]) then
					setActive(arg0.furnNames[iter0], true)
				end
			elseif isActive(arg0.furnNames[iter0]) then
				setActive(arg0.furnNames[iter0], false)
			end
		end
	end

	arg0.funrTimer = Timer.New(var6, 0.2, -1)

	arg0.funrTimer:Start()
	var6()
end

function var0.initEvent(arg0)
	onButton(arg0._binder, arg0.btnStart, function()
		if arg0.inAnimatedFlag then
			return
		end

		if arg0.leftCount and arg0.leftCount <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end

		arg0:changeAnimeState(true)
		setActive(arg0.btnStart, true)
		arg0._event:emit(MonopolyWorldScene.ON_START, arg0.activity.id, function(arg0)
			if arg0 and arg0 > 0 then
				arg0:showRollAnimated(arg0)
			end
		end)
	end, SFX_PANEL)
	onButton(arg0._binder, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_monopoly_world.tip
		})
	end, SFX_PANEL)
	onButton(arg0._binder, arg0.btnBack, function()
		if not arg0.inAnimatedFlag then
			arg0._event:emit(BaseUI.ON_BACK)
		end
	end, SFX_PANEL)
	onButton(arg0._binder, findTF(arg0.char, "click"), function()
		if not arg0.model or arg0.inAnimatedFlag then
			return
		end

		arg0:changeCharAction(var16, 1, function()
			arg0:changeCharAction(var13)
		end)
	end, SFX_PANEL)
end

function var0.showRollAnimated(arg0, arg1)
	seriesAsync({
		function(arg0)
			setActive(arg0.effectStart, true)
			GetComponent(findTF(arg0.btnStart, "anim"), typeof(Animator)):Play("start", -1, 0)
			LeanTween.delayedCall(1, System.Action(function()
				for iter0 = 1, 6 do
					local var0 = findTF(arg0.btnStart, "num/" .. iter0)

					if iter0 ~= arg1 then
						setActive(var0, false)
					else
						setActive(var0, true)
					end
				end
			end))
			LeanTween.delayedCall(2, System.Action(function()
				arg0()
			end))
		end
	}, function()
		arg0.useCount = arg0.useCount + 1
		arg0.leftCount = arg0.leftCount - 1
		arg0.step = arg1

		arg0:updataUI()
		arg0:checkCharActive()
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

function var0.changeAnimeState(arg0, arg1)
	if arg1 then
		arg0.btnStart:GetComponent(typeof(Image)).raycastTarget = false
		arg0.inAnimatedFlag = true

		arg0._event:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
	else
		arg0.inAnimatedFlag = false
		arg0.btnStart:GetComponent(typeof(Image)).raycastTarget = true

		arg0._event:emit(ActivityMainScene.LOCK_ACT_MAIN, false)
	end
end

function var0.initMap(arg0)
	local var0 = var3

	arg0.mapCells = {}

	for iter0 = 1, #var0 do
		local var1 = iter0 - 1
		local var2 = {
			x = -var1 * var1,
			y = -var1 * var2
		}
		local var3 = var0[iter0]

		for iter1 = 1, #var3 do
			local var4 = iter1 - 1
			local var5 = var3[iter1]

			if var5 > 0 then
				local var6 = cloneTplTo(arg0.tplMapCell, arg0.mapContainer, tostring(var5))
				local var7 = Vector2(var1 * var4 + var2.x, -var2 * var4 + var2.y)

				var6.localPosition = var7

				local var8 = pg.activity_event_monopoly_map[var5].icon
				local var9 = GetSpriteFromAtlas("ui/monopolyworldui_atlas", var8)

				findTF(var6, "image"):GetComponent(typeof(Image)).sprite = var9

				findTF(var6, "image"):GetComponent(typeof(Image)):SetNativeSize()

				local var10 = {
					col = var4,
					row = var1,
					mapId = var5,
					tf = var6,
					icon = var8,
					position = var7
				}

				table.insert(arg0.mapCells, var10)
			end
		end
	end

	table.sort(arg0.mapCells, function(arg0, arg1)
		return arg0.mapId < arg1.mapId
	end)
end

function var0.initChar(arg0)
	PoolMgr.GetInstance():GetSpineChar(var4, true, function(arg0)
		arg0.model = arg0
		arg0.model.transform.localScale = Vector3.one
		arg0.model.transform.localPosition = Vector3.zero

		arg0.model.transform:SetParent(arg0.char, false)

		arg0.anim = arg0.model:GetComponent(typeof(SpineAnimUI))

		arg0:changeCharAction(var13, 0, nil)
		arg0:checkCharActive()

		if arg0.pos then
			arg0:updataCharDirect(arg0.pos, false)
		end
	end)
end

function var0.updataCharDirect(arg0, arg1, arg2)
	if arg0.model then
		local var0 = arg0.mapCells[arg1].position
		local var1 = arg1 + 1 > #arg0.mapCells and 1 or arg1 + 1
		local var2 = arg0.mapCells[var1]
		local var3 = arg0:getMoveType(arg0.mapCells[arg1].mapId, arg0.mapCells[var1].mapId, arg2) or arg0.char.localScale.x

		arg0.char.localScale = Vector3(var3, arg0.char.localScale.y, arg0.char.localScale.z)
	end
end

function var0.getMoveType(arg0, arg1, arg2, arg3)
	local var0 = var3
	local var1 = {}
	local var2 = {}

	for iter0 = 1, #var0 do
		local var3 = var0[iter0]

		for iter1 = 1, #var3 do
			local var4 = var3[iter1]

			if var4 == arg1 then
				var1 = {
					x = iter1,
					y = iter0
				}
			end

			if var4 == arg2 then
				var2 = {
					x = iter1,
					y = iter0
				}
			end
		end
	end

	local var5

	if var2.y > var1.y then
		var5 = -var8
	elseif var2.y < var1.y then
		var5 = var8
	elseif var2.x > var1.x then
		var5 = var8
	elseif var2.x < var1.x then
		var5 = -var8
	end

	return var5
end

function var0.checkCharActive(arg0)
	if arg0.anim then
		if arg0.effectId and arg0.effectId > 0 then
			arg0:changeAnimeState(true)
			arg0:checkEffect(function()
				arg0:changeAnimeState(false)
				arg0:checkCharActive()
			end)
		elseif arg0.step and arg0.step > 0 then
			arg0:changeAnimeState(true)
			arg0:checkStep(function()
				arg0:changeAnimeState(false)
				arg0:checkCharActive()
			end)
		elseif arg0.activity then
			arg0.activity = getProxy(ActivityProxy):getActivityById(arg0.activity.id)

			arg0:updataActivity(arg0.activity)
		end
	end
end

function var0.firstUpdata(arg0, arg1)
	arg0:activityDataUpdata(arg1)
	arg0:updataUI()
	arg0:updataChar()
	arg0:checkCharActive()
end

function var0.updataActivity(arg0, arg1)
	arg0:activityDataUpdata(arg1)
	arg0:updataUI()
end

function var0.activityDataUpdata(arg0, arg1)
	arg0.activity = arg1

	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = arg0.activity.data1

	arg0.totalCnt = math.ceil((var0 - var1) / 86400) * arg0.activity:getDataConfig("daily_time") + arg0.activity.data1_list[1]
	arg0.useCount = arg0.activity.data1_list[2]
	arg0.leftCount = arg0.totalCnt - arg0.useCount

	if arg0.turnCnt and arg0.turnCnt ~= arg0.activity.data1_list[3] - 1 then
		arg0.autoShowScreen = nil
	end

	arg0.turnCnt = arg0.activity.data1_list[3] - 1
	arg0.leftDropShipCnt = 8 - arg0.turnCnt

	local var2 = arg0.activity.data2_list[2]

	arg0.advanceTotalCnt = #arg1:getDataConfig("reward")
	arg0.isAdvanceRp = arg0.advanceTotalCnt - var2 > 0

	local var3 = arg0.activity.data2_list[1]

	arg0.leftAwardCnt = var3 - var2
	arg0.advanceRpCount = math.max(0, math.min(var3, arg0.advanceTotalCnt) - var2)
	arg0.commonRpCount = math.max(0, var3 - arg0.advanceTotalCnt) - math.max(0, var2 - arg0.advanceTotalCnt)

	local var4 = arg1:getDataConfig("reward_time")

	arg0.nextredPacketStep = var4 - arg0.useCount % var4
	arg0.pos = arg0.activity.data2
	arg0.lastPos = arg0.pos
	arg0.step = arg0.activity.data3
	arg0.effectId = arg0.activity.data4
end

function var0.checkStep(arg0, arg1)
	if arg0.step > 0 then
		arg0._event:emit(MonopolyWorldScene.ON_MOVE, arg0.activity.id, function(arg0, arg1, arg2)
			arg0.step = arg0
			arg0.lastPos = arg0.pos
			arg0.pos = arg1[#arg1]
			arg0.effectId = arg2

			seriesAsync({
				function(arg0)
					local var0 = #arg1 > 3 and var15 or var14

					arg0:moveCharWithPaths(arg1, var0, arg0)
				end,
				function(arg0)
					if arg1 and #arg1 > 0 and arg0.pos == 1 then
						arg0.turnCnt = arg0.turnCnt + 1

						setText(findTF(arg0._tf, "topRight/times"), tostring(arg0.turnCnt))
						arg0:changeBg()
					end

					if isActive(arg0.effectStart) then
						setActive(arg0.effectStart, false)
						setActive(arg0.effectStart, true)
						LeanTween.delayedCall(1, System.Action(function()
							for iter0 = 1, 6 do
								local var0 = findTF(arg0.btnStart, "num/" .. iter0)

								setActive(var0, false)
							end
						end))
						LeanTween.delayedCall(2, System.Action(function()
							setActive(arg0.effectStart, false)
						end))
					end

					arg0:checkEffect(arg0)
				end
			}, function()
				if arg1 then
					arg1()
				end
			end)
		end)
	else
		if arg0.pos == 1 then
			arg0.turnCnt = arg0.turnCnt + 1

			arg0:changeBg()
		end

		if arg1 then
			arg1()
		end
	end
end

function var0.updataUI(arg0)
	setText(arg0.labelLeftCount, arg0.leftCount)

	local var0 = arg0.activity:getDataConfig("daily_time")

	var25 = var24.icon

	if arg0.turnCnt and arg0.turnCnt < #var23 then
		var24 = pg.furniture_data_template[var23[arg0.turnCnt + 1]]

		setText(arg0.gameTipUI2, i18n(var6, var0, 1))
	else
		setText(arg0.gameTipUI2, i18n(var7, var0))
	end

	if arg0.leftCount and arg0.leftCount > 0 then
		setActive(findTF(arg0.btnStart, "img3"), true)
		setActive(findTF(arg0.btnStart, "img4"), false)
	else
		setActive(findTF(arg0.btnStart, "img3"), false)
		setActive(findTF(arg0.btnStart, "img4"), true)
	end

	setText(findTF(arg0._tf, "topRight/times"), tostring(arg0.turnCnt))

	for iter0 = 1, #arg0.furnItems do
		if iter0 <= arg0.turnCnt then
			setActive(findTF(arg0.furnItems[iter0], "got"), true)
		else
			setActive(findTF(arg0.furnItems[iter0], "got"), false)
		end
	end

	if arg0.bannerSnap.StartingScreen == 0 and not arg0.bannerInit then
		if arg0.turnCnt < #var23 then
			arg0.bannerSnap.StartingScreen = arg0.turnCnt % 5 + 1
			arg0.bannerInit = true
		else
			arg0.bannerSnap.autoSnap = 5
		end
	elseif arg0.bannerSnap:CurrentScreen() ~= arg0.turnCnt and arg0.turnCnt < #var23 then
		local var1 = arg0.turnCnt % 5 - arg0.bannerSnap:CurrentScreen()

		for iter1 = 1, math.abs(var1) do
			if math.sign(var1) > 0 then
				arg0.bannerSnap:NextScreen(true)
			else
				arg0.bannerSnap:PreviousScreen(true)
			end
		end
	end

	if arg0.turnCnt >= #var23 then
		if arg0.bannerCanvas.blocksRaycasts ~= true then
			arg0.bannerCanvas.blocksRaycasts = true
		end

		if not isActive(findTF(arg0._tf, "bg/dots")) then
			arg0.bannerSnap:NextScreen(true)
			setActive(findTF(arg0._tf, "bg/dots"), true)
		end
	else
		if arg0.bannerCanvas.blocksRaycasts == true then
			arg0.bannerCanvas.blocksRaycasts = false
		end

		if isActive(findTF(arg0._tf, "bg/dots")) then
			setActive(findTF(arg0._tf, "bg/dots"), false)
		end
	end

	arg0:changeBg()
end

function var0.updataChar(arg0)
	local var0 = arg0.mapCells[arg0.pos]

	arg0.char.localPosition = var0.position

	if not isActive(arg0.char) then
		SetActive(arg0.char, true)
		arg0.char:SetAsLastSibling()
	end

	if arg0.model then
		arg0:updataCharDirect(arg0.pos, false)
	end
end

function var0.getEffectTf(arg0, arg1, arg2)
	for iter0 = 1, #var22 do
		local var0 = var22[iter0]

		if var0.cell_type == arg1 then
			local var1 = var0.name

			if not arg2 then
				return findTF(arg0._tf, "mapContainer/effect/" .. var1)
			elseif arg2 == var0.path_length then
				return findTF(arg0._tf, "mapContainer/effect/" .. var1)
			end
		end
	end

	return nil
end

function var0.checkEffect(arg0, arg1)
	if arg0.effectId > 0 then
		local var0 = arg0.mapCells[arg0.pos]
		local var1, var2 = arg0:getActionName(var0.icon)
		local var3 = pg.activity_event_monopoly_event[arg0.effectId].story

		seriesAsync({
			function(arg0)
				if var1 then
					arg0:changeCharAction(var1, 1, function()
						arg0:changeCharAction(var13, 0, nil)
						arg0()
					end)
				end

				if var2 then
					local var0 = arg0:getEffectTf(var2)

					if var0 then
						var0.anchoredPosition = Vector2(var0.position.x, var0.position.y)

						setActive(var0, false)
						setActive(var0, true)
					end
				end

				if not var1 and not var2 then
					arg0()
				elseif not var1 and var2 then
					LeanTween.delayedCall(1, System.Action(function()
						arg0()
					end))
				end
			end,
			function(arg0)
				if var3 and tonumber(var3) ~= 0 then
					pg.NewStoryMgr.GetInstance():Play(var3, arg0, true, true)
				else
					arg0()
				end
			end,
			function(arg0)
				arg0:triggerEfeect(arg0)
			end,
			function(arg0)
				arg0:checkCountStory(arg0)
			end,
			function(arg0)
				if arg0.pos == 1 then
					arg0:changeBg()
				end

				arg0()
			end
		}, arg1)
	elseif arg1 then
		arg1()
	end
end

function var0.triggerEfeect(arg0, arg1)
	arg0._event:emit(MonopolyWorldScene.ON_TRIGGER, arg0.activity.id, function(arg0, arg1)
		if arg0 and #arg0 >= 0 then
			arg0.effectId = arg1
			arg0.lastPos = arg0.pos
			arg0.pos = arg0[#arg0]

			if #arg0 > 0 then
				print()
			end

			local var0 = arg0:getEffectTf(var18, #arg0)

			seriesAsync({
				function(arg0)
					if var0 then
						setActive(var0, false)
						setActive(var0, true)

						var0.anchoredPosition = arg0.mapCells[arg0.lastPos].position

						LeanTween.delayedCall(1, System.Action(function()
							arg0()
						end))
					else
						arg0()
					end
				end,
				function(arg0)
					arg0:moveCharWithPaths(arg0, var12, arg0)
				end
			}, function()
				if var0 then
					-- block empty
				end

				arg1()
			end)
		end
	end)
end

function var0.changeBg(arg0)
	local var0 = arg0.turnCnt and arg0.turnCnt % 5 + 1 or 1

	for iter0 = 1, 5 do
		local var1 = findTF(arg0._tf, "bg/img" .. iter0)
		local var2 = GetComponent(var1, typeof(Image)).color.a

		if iter0 == var0 then
			if var2 ~= 1 then
				LeanTween.alpha(var1, 1, 0.5)
			end
		elseif var2 ~= 0 then
			LeanTween.alpha(var1, 0, 0.5)
		end
	end
end

function var0.toMoveCar(arg0)
	if not arg0.targetPosition then
		return
	end

	local var0 = math.abs(arg0.targetPosition.x - arg0.char.localPosition.x)
	local var1 = math.abs(arg0.targetPosition.y - arg0.char.localPosition.y)

	if var0 <= 6.5 and var1 <= 6.5 then
		arg0.targetPosition = nil

		if arg0.moveComplete then
			arg0:updataCharDirect(arg0.targetPosIndex, true)
			arg0.moveComplete()
		end
	end

	arg0.speedX = math.abs(arg0.speedX + arg0.baseASpeedX) > math.abs(arg0.baseSpeedX) and arg0.baseSpeedX or arg0.speedX + arg0.baseASpeedX
	arg0.speedY = math.abs(arg0.speedY + arg0.baseASpeedY) > math.abs(arg0.baseSpeedY) and arg0.baseSpeedY or arg0.speedY + arg0.baseASpeedY

	local var2 = arg0.char.localPosition

	arg0.char.localPosition = Vector3(var2.x + arg0.speedX, var2.y + arg0.speedY, 0)
end

function var0.checkPathTurn(arg0, arg1)
	local var0 = arg1 + 1 > #arg0.mapCells and 1 or arg1 + 1
	local var1 = arg1 - 1 < 1 and #arg0.mapCells or arg1 - 1

	if arg0.mapCells[var0].col == arg0.mapCells[var1].col or arg0.mapCells[var0].row == arg0.mapCells[var1].row then
		return false
	end

	return true
end

function var0.moveCharWithPaths(arg0, arg1, arg2, arg3)
	if not arg1 or #arg1 <= 0 then
		if arg3 then
			arg3()
		end

		return
	end

	local var0 = {}
	local var1 = arg1[1] - 1 < 1 and #arg0.mapCells or arg1[1] - 1

	for iter0 = 1, #arg1 do
		local var2 = arg0.mapCells[arg1[iter0]]

		table.insert(var0, function(arg0)
			arg0:changeCharAction(arg2, 0, nil)
			arg0:updataCharDirect(var1, true)

			var1 = arg1[iter0]

			local var0
			local var1 = arg2 == var12 and 0.9 or arg2 == var14 and 0.9 or 0.5

			LeanTween.moveLocal(go(arg0.char), var2.tf.localPosition, var1):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
				if arg2 == var14 then
					LeanTween.delayedCall(0.05, System.Action(function()
						arg0()
					end))
				else
					arg0()
				end
			end))
		end)

		if iter0 == #arg1 then
			table.insert(var0, function(arg0)
				arg0:changeCharAction(var13, 0, nil)
				arg0:updataCharDirect(arg1[iter0], false)
				arg0()
			end)
		end
	end

	seriesAsync(var0, arg3)
end

function var0.changeCharAction(arg0, arg1, arg2, arg3)
	if arg0.actionName == arg1 and arg0.actionName ~= var14 then
		return
	end

	arg0.actionName = arg1

	arg0.anim:SetActionCallBack(nil)
	arg0.anim:SetAction(arg1, 0)
	arg0.anim:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			if arg2 == 1 then
				arg0.anim:SetActionCallBack(nil)
				arg0.anim:SetAction(var13, 0)
			end

			if arg3 then
				arg3()
			end
		end
	end)

	if arg2 ~= 1 and arg3 then
		arg3()
	end
end

function var0.getActionName(arg0, arg1)
	if arg1 == "icon_1" then
		return var11, var21
	elseif arg1 == "icon_2" then
		return var9, var17
	elseif arg1 == "icon_3" then
		return var11, var20
	elseif arg1 == "icon_4" then
		return var11, var21
	elseif arg1 == "icon_5" then
		return var10, var19
	elseif arg1 == "icon_6" then
		return nil, nil
	end
end

function var0.dispose(arg0)
	if arg0.skinCardName and arg0.showModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.skinCardName, arg0.showModel)
	end

	if arg0.funrTimer then
		arg0.funrTimer:Stop()

		arg0.funrTimer = nil
	end

	for iter0 = 1, 5 do
		local var0 = findTF(arg0._tf, "bg/img" .. iter0)

		if LeanTween.isTweening(var0) then
			LeanTween.cancel(var0)
		end
	end
end

return var0
