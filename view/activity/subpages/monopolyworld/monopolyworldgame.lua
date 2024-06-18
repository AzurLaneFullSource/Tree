local var0_0 = class("MonopolyWorldGame")
local var1_0 = 117
local var2_0 = 60
local var3_0 = {
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
local var4_0 = "mengya"
local var5_0 = "monopoly_world_tip1"
local var6_0 = "monopoly_world_tip2"
local var7_0 = "monopoly_world_tip3"
local var8_0 = 0.6
local var9_0 = "dafuweng_gold"
local var10_0 = "dafuweng_oil"
local var11_0 = "dafuweng_event"
local var12_0 = "dafuweng_walk"
local var13_0 = "dafuweng_stand"
local var14_0 = "dafuweng_walk"
local var15_0 = "dafuweng_run"
local var16_0 = "dafuweng_touch"
local var17_0 = "cell gold"
local var18_0 = "cell move"
local var19_0 = "cell oil"
local var20_0 = "cell event"
local var21_0 = "cell item"
local var22_0 = {
	{
		path_length = 1,
		name = "gulitemengya_1",
		cell_type = var18_0
	},
	{
		path_length = 2,
		name = "gulitemengya_2",
		cell_type = var18_0
	},
	{
		path_length = 3,
		name = "gulitemengya_3",
		cell_type = var18_0
	},
	{
		name = "gulitemengya_daoju",
		cell_type = var21_0
	},
	{
		name = "gulitemengya_jinbi",
		cell_type = var17_0
	},
	{
		name = "gulitemengya_mingyun",
		cell_type = var20_0
	},
	{
		name = "gulitemengya_shiyou",
		cell_type = var19_0
	}
}
local var23_0 = {
	84180,
	84181,
	84183,
	84179,
	84182
}
local var24_0
local var25_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1._event = arg3_1

	arg0_1:initData()
	arg0_1:initUI()
	arg0_1:initEvent()
end

function var0_0.initData(arg0_2)
	arg0_2.leftCount = 0
	arg0_2.inAnimatedFlag = false
	arg0_2.mapCells = {}
end

function var0_0.initUI(arg0_3)
	arg0_3.tplMapCell = findTF(arg0_3._tf, "tplMapCell")
	arg0_3.gameTipUI1 = findTF(arg0_3._tf, "btnStart/desc")

	setText(arg0_3.gameTipUI1, i18n(var5_0))

	arg0_3.gameTipUI2 = findTF(arg0_3._tf, "bg/desc")

	setText(arg0_3.gameTipUI2, "")

	arg0_3.mapContainer = findTF(arg0_3._tf, "mapContainer")
	arg0_3.char = findTF(arg0_3._tf, "mapContainer/char")

	setActive(arg0_3.char, false)

	arg0_3.btnStart = findTF(arg0_3._tf, "btnStart")
	arg0_3.effectStart = findTF(arg0_3.btnStart, "gulitemengya_pingmu")
	arg0_3.btnHelp = findTF(arg0_3._tf, "topRight/btnHelp")
	arg0_3.labelLeftCount = findTF(arg0_3.btnStart, "times")
	arg0_3.btnBack = findTF(arg0_3._tf, "leftTop/back")

	arg0_3:initMap()
	arg0_3:initChar()
	arg0_3:initFurn()
end

function var0_0.initFurn(arg0_4)
	local var0_4 = findTF(arg0_4._tf, "bg/mask/event"):GetComponent("HScrollSnap")

	arg0_4.bannerCanvas = GetComponent(findTF(arg0_4._tf, "bg/mask"), typeof(CanvasGroup))

	var0_4:Init()

	local var1_4 = findTF(var0_4, "content")
	local var2_4 = findTF(var0_4, "item")
	local var3_4 = findTF(arg0_4._tf, "bg/dots")
	local var4_4 = findTF(arg0_4._tf, "bg/dot")

	setActive(var2_4, false)
	setActive(var4_4, false)

	arg0_4.furnItems = {}

	for iter0_4 = 0, #var23_0 - 1 do
		cloneTplTo(var4_4, var3_4)

		local var5_4 = Instantiate(var2_4)

		var24_0 = pg.furniture_data_template[var23_0[iter0_4 + 1]]
		var25_0 = var24_0.icon

		GetImageSpriteFromAtlasAsync("ui/monopolyworldui_atlas", var25_0, findTF(var5_4, "img"), true)
		var0_4:AddChild(var5_4)
		setActive(var5_4, true)
		table.insert(arg0_4.furnItems, var5_4)
	end

	arg0_4.bannerSnap = var0_4
	arg0_4.bannerContent = var1_4
	arg0_4.bannerDots = var3_4
	arg0_4.furnNames = {}

	for iter1_4 = 1, #var23_0 do
		table.insert(arg0_4.furnNames, findTF(arg0_4._tf, "bg/furnName/img" .. iter1_4))
	end

	local function var6_4()
		for iter0_5 = 1, #var23_0 do
			if iter0_5 == arg0_4.bannerSnap:CurrentScreen() + 1 then
				if not isActive(arg0_4.furnNames[iter0_5]) then
					setActive(arg0_4.furnNames[iter0_5], true)
				end
			elseif isActive(arg0_4.furnNames[iter0_5]) then
				setActive(arg0_4.furnNames[iter0_5], false)
			end
		end
	end

	arg0_4.funrTimer = Timer.New(var6_4, 0.2, -1)

	arg0_4.funrTimer:Start()
	var6_4()
end

function var0_0.initEvent(arg0_6)
	onButton(arg0_6._binder, arg0_6.btnStart, function()
		if arg0_6.inAnimatedFlag then
			return
		end

		if arg0_6.leftCount and arg0_6.leftCount <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end

		arg0_6:changeAnimeState(true)
		setActive(arg0_6.btnStart, true)
		arg0_6._event:emit(MonopolyWorldScene.ON_START, arg0_6.activity.id, function(arg0_8)
			if arg0_8 and arg0_8 > 0 then
				arg0_6:showRollAnimated(arg0_8)
			end
		end)
	end, SFX_PANEL)
	onButton(arg0_6._binder, arg0_6.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_monopoly_world.tip
		})
	end, SFX_PANEL)
	onButton(arg0_6._binder, arg0_6.btnBack, function()
		if not arg0_6.inAnimatedFlag then
			arg0_6._event:emit(BaseUI.ON_BACK)
		end
	end, SFX_PANEL)
	onButton(arg0_6._binder, findTF(arg0_6.char, "click"), function()
		if not arg0_6.model or arg0_6.inAnimatedFlag then
			return
		end

		arg0_6:changeCharAction(var16_0, 1, function()
			arg0_6:changeCharAction(var13_0)
		end)
	end, SFX_PANEL)
end

function var0_0.showRollAnimated(arg0_13, arg1_13)
	seriesAsync({
		function(arg0_14)
			setActive(arg0_13.effectStart, true)
			GetComponent(findTF(arg0_13.btnStart, "anim"), typeof(Animator)):Play("start", -1, 0)
			LeanTween.delayedCall(1, System.Action(function()
				for iter0_15 = 1, 6 do
					local var0_15 = findTF(arg0_13.btnStart, "num/" .. iter0_15)

					if iter0_15 ~= arg1_13 then
						setActive(var0_15, false)
					else
						setActive(var0_15, true)
					end
				end
			end))
			LeanTween.delayedCall(2, System.Action(function()
				arg0_14()
			end))
		end
	}, function()
		arg0_13.useCount = arg0_13.useCount + 1
		arg0_13.leftCount = arg0_13.leftCount - 1
		arg0_13.step = arg1_13

		arg0_13:updataUI()
		arg0_13:checkCharActive()
	end)
end

function var0_0.checkCountStory(arg0_18, arg1_18)
	local var0_18 = arg0_18.useCount
	local var1_18 = arg0_18.activity:getDataConfig("story") or {}
	local var2_18 = _.detect(var1_18, function(arg0_19)
		return arg0_19[1] == var0_18
	end)

	if var2_18 then
		pg.NewStoryMgr.GetInstance():Play(var2_18[2], arg1_18)
	else
		arg1_18()
	end
end

function var0_0.changeAnimeState(arg0_20, arg1_20)
	if arg1_20 then
		arg0_20.btnStart:GetComponent(typeof(Image)).raycastTarget = false
		arg0_20.inAnimatedFlag = true

		arg0_20._event:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
	else
		arg0_20.inAnimatedFlag = false
		arg0_20.btnStart:GetComponent(typeof(Image)).raycastTarget = true

		arg0_20._event:emit(ActivityMainScene.LOCK_ACT_MAIN, false)
	end
end

function var0_0.initMap(arg0_21)
	local var0_21 = var3_0

	arg0_21.mapCells = {}

	for iter0_21 = 1, #var0_21 do
		local var1_21 = iter0_21 - 1
		local var2_21 = {
			x = -var1_21 * var1_0,
			y = -var1_21 * var2_0
		}
		local var3_21 = var0_21[iter0_21]

		for iter1_21 = 1, #var3_21 do
			local var4_21 = iter1_21 - 1
			local var5_21 = var3_21[iter1_21]

			if var5_21 > 0 then
				local var6_21 = cloneTplTo(arg0_21.tplMapCell, arg0_21.mapContainer, tostring(var5_21))
				local var7_21 = Vector2(var1_0 * var4_21 + var2_21.x, -var2_0 * var4_21 + var2_21.y)

				var6_21.localPosition = var7_21

				local var8_21 = pg.activity_event_monopoly_map[var5_21].icon
				local var9_21 = GetSpriteFromAtlas("ui/monopolyworldui_atlas", var8_21)

				findTF(var6_21, "image"):GetComponent(typeof(Image)).sprite = var9_21

				findTF(var6_21, "image"):GetComponent(typeof(Image)):SetNativeSize()

				local var10_21 = {
					col = var4_21,
					row = var1_21,
					mapId = var5_21,
					tf = var6_21,
					icon = var8_21,
					position = var7_21
				}

				table.insert(arg0_21.mapCells, var10_21)
			end
		end
	end

	table.sort(arg0_21.mapCells, function(arg0_22, arg1_22)
		return arg0_22.mapId < arg1_22.mapId
	end)
end

function var0_0.initChar(arg0_23)
	PoolMgr.GetInstance():GetSpineChar(var4_0, true, function(arg0_24)
		arg0_23.model = arg0_24
		arg0_23.model.transform.localScale = Vector3.one
		arg0_23.model.transform.localPosition = Vector3.zero

		arg0_23.model.transform:SetParent(arg0_23.char, false)

		arg0_23.anim = arg0_23.model:GetComponent(typeof(SpineAnimUI))

		arg0_23:changeCharAction(var13_0, 0, nil)
		arg0_23:checkCharActive()

		if arg0_23.pos then
			arg0_23:updataCharDirect(arg0_23.pos, false)
		end
	end)
end

function var0_0.updataCharDirect(arg0_25, arg1_25, arg2_25)
	if arg0_25.model then
		local var0_25 = arg0_25.mapCells[arg1_25].position
		local var1_25 = arg1_25 + 1 > #arg0_25.mapCells and 1 or arg1_25 + 1
		local var2_25 = arg0_25.mapCells[var1_25]
		local var3_25 = arg0_25:getMoveType(arg0_25.mapCells[arg1_25].mapId, arg0_25.mapCells[var1_25].mapId, arg2_25) or arg0_25.char.localScale.x

		arg0_25.char.localScale = Vector3(var3_25, arg0_25.char.localScale.y, arg0_25.char.localScale.z)
	end
end

function var0_0.getMoveType(arg0_26, arg1_26, arg2_26, arg3_26)
	local var0_26 = var3_0
	local var1_26 = {}
	local var2_26 = {}

	for iter0_26 = 1, #var0_26 do
		local var3_26 = var0_26[iter0_26]

		for iter1_26 = 1, #var3_26 do
			local var4_26 = var3_26[iter1_26]

			if var4_26 == arg1_26 then
				var1_26 = {
					x = iter1_26,
					y = iter0_26
				}
			end

			if var4_26 == arg2_26 then
				var2_26 = {
					x = iter1_26,
					y = iter0_26
				}
			end
		end
	end

	local var5_26

	if var2_26.y > var1_26.y then
		var5_26 = -var8_0
	elseif var2_26.y < var1_26.y then
		var5_26 = var8_0
	elseif var2_26.x > var1_26.x then
		var5_26 = var8_0
	elseif var2_26.x < var1_26.x then
		var5_26 = -var8_0
	end

	return var5_26
end

function var0_0.checkCharActive(arg0_27)
	if arg0_27.anim then
		if arg0_27.effectId and arg0_27.effectId > 0 then
			arg0_27:changeAnimeState(true)
			arg0_27:checkEffect(function()
				arg0_27:changeAnimeState(false)
				arg0_27:checkCharActive()
			end)
		elseif arg0_27.step and arg0_27.step > 0 then
			arg0_27:changeAnimeState(true)
			arg0_27:checkStep(function()
				arg0_27:changeAnimeState(false)
				arg0_27:checkCharActive()
			end)
		elseif arg0_27.activity then
			arg0_27.activity = getProxy(ActivityProxy):getActivityById(arg0_27.activity.id)

			arg0_27:updataActivity(arg0_27.activity)
		end
	end
end

function var0_0.firstUpdata(arg0_30, arg1_30)
	arg0_30:activityDataUpdata(arg1_30)
	arg0_30:updataUI()
	arg0_30:updataChar()
	arg0_30:checkCharActive()
end

function var0_0.updataActivity(arg0_31, arg1_31)
	arg0_31:activityDataUpdata(arg1_31)
	arg0_31:updataUI()
end

function var0_0.activityDataUpdata(arg0_32, arg1_32)
	arg0_32.activity = arg1_32

	local var0_32 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_32 = arg0_32.activity.data1

	arg0_32.totalCnt = math.ceil((var0_32 - var1_32) / 86400) * arg0_32.activity:getDataConfig("daily_time") + arg0_32.activity.data1_list[1]
	arg0_32.useCount = arg0_32.activity.data1_list[2]
	arg0_32.leftCount = arg0_32.totalCnt - arg0_32.useCount

	if arg0_32.turnCnt and arg0_32.turnCnt ~= arg0_32.activity.data1_list[3] - 1 then
		arg0_32.autoShowScreen = nil
	end

	arg0_32.turnCnt = arg0_32.activity.data1_list[3] - 1
	arg0_32.leftDropShipCnt = 8 - arg0_32.turnCnt

	local var2_32 = arg0_32.activity.data2_list[2]

	arg0_32.advanceTotalCnt = #arg1_32:getDataConfig("reward")
	arg0_32.isAdvanceRp = arg0_32.advanceTotalCnt - var2_32 > 0

	local var3_32 = arg0_32.activity.data2_list[1]

	arg0_32.leftAwardCnt = var3_32 - var2_32
	arg0_32.advanceRpCount = math.max(0, math.min(var3_32, arg0_32.advanceTotalCnt) - var2_32)
	arg0_32.commonRpCount = math.max(0, var3_32 - arg0_32.advanceTotalCnt) - math.max(0, var2_32 - arg0_32.advanceTotalCnt)

	local var4_32 = arg1_32:getDataConfig("reward_time")

	arg0_32.nextredPacketStep = var4_32 - arg0_32.useCount % var4_32
	arg0_32.pos = arg0_32.activity.data2
	arg0_32.lastPos = arg0_32.pos
	arg0_32.step = arg0_32.activity.data3
	arg0_32.effectId = arg0_32.activity.data4
end

function var0_0.checkStep(arg0_33, arg1_33)
	if arg0_33.step > 0 then
		arg0_33._event:emit(MonopolyWorldScene.ON_MOVE, arg0_33.activity.id, function(arg0_34, arg1_34, arg2_34)
			arg0_33.step = arg0_34
			arg0_33.lastPos = arg0_33.pos
			arg0_33.pos = arg1_34[#arg1_34]
			arg0_33.effectId = arg2_34

			seriesAsync({
				function(arg0_35)
					local var0_35 = #arg1_34 > 3 and var15_0 or var14_0

					arg0_33:moveCharWithPaths(arg1_34, var0_35, arg0_35)
				end,
				function(arg0_36)
					if arg1_34 and #arg1_34 > 0 and arg0_33.pos == 1 then
						arg0_33.turnCnt = arg0_33.turnCnt + 1

						setText(findTF(arg0_33._tf, "topRight/times"), tostring(arg0_33.turnCnt))
						arg0_33:changeBg()
					end

					if isActive(arg0_33.effectStart) then
						setActive(arg0_33.effectStart, false)
						setActive(arg0_33.effectStart, true)
						LeanTween.delayedCall(1, System.Action(function()
							for iter0_37 = 1, 6 do
								local var0_37 = findTF(arg0_33.btnStart, "num/" .. iter0_37)

								setActive(var0_37, false)
							end
						end))
						LeanTween.delayedCall(2, System.Action(function()
							setActive(arg0_33.effectStart, false)
						end))
					end

					arg0_33:checkEffect(arg0_36)
				end
			}, function()
				if arg1_33 then
					arg1_33()
				end
			end)
		end)
	else
		if arg0_33.pos == 1 then
			arg0_33.turnCnt = arg0_33.turnCnt + 1

			arg0_33:changeBg()
		end

		if arg1_33 then
			arg1_33()
		end
	end
end

function var0_0.updataUI(arg0_40)
	setText(arg0_40.labelLeftCount, arg0_40.leftCount)

	local var0_40 = arg0_40.activity:getDataConfig("daily_time")

	var25_0 = var24_0.icon

	if arg0_40.turnCnt and arg0_40.turnCnt < #var23_0 then
		var24_0 = pg.furniture_data_template[var23_0[arg0_40.turnCnt + 1]]

		setText(arg0_40.gameTipUI2, i18n(var6_0, var0_40, 1))
	else
		setText(arg0_40.gameTipUI2, i18n(var7_0, var0_40))
	end

	if arg0_40.leftCount and arg0_40.leftCount > 0 then
		setActive(findTF(arg0_40.btnStart, "img3"), true)
		setActive(findTF(arg0_40.btnStart, "img4"), false)
	else
		setActive(findTF(arg0_40.btnStart, "img3"), false)
		setActive(findTF(arg0_40.btnStart, "img4"), true)
	end

	setText(findTF(arg0_40._tf, "topRight/times"), tostring(arg0_40.turnCnt))

	for iter0_40 = 1, #arg0_40.furnItems do
		if iter0_40 <= arg0_40.turnCnt then
			setActive(findTF(arg0_40.furnItems[iter0_40], "got"), true)
		else
			setActive(findTF(arg0_40.furnItems[iter0_40], "got"), false)
		end
	end

	if arg0_40.bannerSnap.StartingScreen == 0 and not arg0_40.bannerInit then
		if arg0_40.turnCnt < #var23_0 then
			arg0_40.bannerSnap.StartingScreen = arg0_40.turnCnt % 5 + 1
			arg0_40.bannerInit = true
		else
			arg0_40.bannerSnap.autoSnap = 5
		end
	elseif arg0_40.bannerSnap:CurrentScreen() ~= arg0_40.turnCnt and arg0_40.turnCnt < #var23_0 then
		local var1_40 = arg0_40.turnCnt % 5 - arg0_40.bannerSnap:CurrentScreen()

		for iter1_40 = 1, math.abs(var1_40) do
			if math.sign(var1_40) > 0 then
				arg0_40.bannerSnap:NextScreen(true)
			else
				arg0_40.bannerSnap:PreviousScreen(true)
			end
		end
	end

	if arg0_40.turnCnt >= #var23_0 then
		if arg0_40.bannerCanvas.blocksRaycasts ~= true then
			arg0_40.bannerCanvas.blocksRaycasts = true
		end

		if not isActive(findTF(arg0_40._tf, "bg/dots")) then
			arg0_40.bannerSnap:NextScreen(true)
			setActive(findTF(arg0_40._tf, "bg/dots"), true)
		end
	else
		if arg0_40.bannerCanvas.blocksRaycasts == true then
			arg0_40.bannerCanvas.blocksRaycasts = false
		end

		if isActive(findTF(arg0_40._tf, "bg/dots")) then
			setActive(findTF(arg0_40._tf, "bg/dots"), false)
		end
	end

	arg0_40:changeBg()
end

function var0_0.updataChar(arg0_41)
	local var0_41 = arg0_41.mapCells[arg0_41.pos]

	arg0_41.char.localPosition = var0_41.position

	if not isActive(arg0_41.char) then
		SetActive(arg0_41.char, true)
		arg0_41.char:SetAsLastSibling()
	end

	if arg0_41.model then
		arg0_41:updataCharDirect(arg0_41.pos, false)
	end
end

function var0_0.getEffectTf(arg0_42, arg1_42, arg2_42)
	for iter0_42 = 1, #var22_0 do
		local var0_42 = var22_0[iter0_42]

		if var0_42.cell_type == arg1_42 then
			local var1_42 = var0_42.name

			if not arg2_42 then
				return findTF(arg0_42._tf, "mapContainer/effect/" .. var1_42)
			elseif arg2_42 == var0_42.path_length then
				return findTF(arg0_42._tf, "mapContainer/effect/" .. var1_42)
			end
		end
	end

	return nil
end

function var0_0.checkEffect(arg0_43, arg1_43)
	if arg0_43.effectId > 0 then
		local var0_43 = arg0_43.mapCells[arg0_43.pos]
		local var1_43, var2_43 = arg0_43:getActionName(var0_43.icon)
		local var3_43 = pg.activity_event_monopoly_event[arg0_43.effectId].story

		seriesAsync({
			function(arg0_44)
				if var1_43 then
					arg0_43:changeCharAction(var1_43, 1, function()
						arg0_43:changeCharAction(var13_0, 0, nil)
						arg0_44()
					end)
				end

				if var2_43 then
					local var0_44 = arg0_43:getEffectTf(var2_43)

					if var0_44 then
						var0_44.anchoredPosition = Vector2(var0_43.position.x, var0_43.position.y)

						setActive(var0_44, false)
						setActive(var0_44, true)
					end
				end

				if not var1_43 and not var2_43 then
					arg0_44()
				elseif not var1_43 and var2_43 then
					LeanTween.delayedCall(1, System.Action(function()
						arg0_44()
					end))
				end
			end,
			function(arg0_47)
				if var3_43 and tonumber(var3_43) ~= 0 then
					pg.NewStoryMgr.GetInstance():Play(var3_43, arg0_47, true, true)
				else
					arg0_47()
				end
			end,
			function(arg0_48)
				arg0_43:triggerEfeect(arg0_48)
			end,
			function(arg0_49)
				arg0_43:checkCountStory(arg0_49)
			end,
			function(arg0_50)
				if arg0_43.pos == 1 then
					arg0_43:changeBg()
				end

				arg0_50()
			end
		}, arg1_43)
	elseif arg1_43 then
		arg1_43()
	end
end

function var0_0.triggerEfeect(arg0_51, arg1_51)
	arg0_51._event:emit(MonopolyWorldScene.ON_TRIGGER, arg0_51.activity.id, function(arg0_52, arg1_52)
		if arg0_52 and #arg0_52 >= 0 then
			arg0_51.effectId = arg1_52
			arg0_51.lastPos = arg0_51.pos
			arg0_51.pos = arg0_52[#arg0_52]

			if #arg0_52 > 0 then
				print()
			end

			local var0_52 = arg0_51:getEffectTf(var18_0, #arg0_52)

			seriesAsync({
				function(arg0_53)
					if var0_52 then
						setActive(var0_52, false)
						setActive(var0_52, true)

						var0_52.anchoredPosition = arg0_51.mapCells[arg0_51.lastPos].position

						LeanTween.delayedCall(1, System.Action(function()
							arg0_53()
						end))
					else
						arg0_53()
					end
				end,
				function(arg0_55)
					arg0_51:moveCharWithPaths(arg0_52, var12_0, arg0_55)
				end
			}, function()
				if var0_52 then
					-- block empty
				end

				arg1_51()
			end)
		end
	end)
end

function var0_0.changeBg(arg0_57)
	local var0_57 = arg0_57.turnCnt and arg0_57.turnCnt % 5 + 1 or 1

	for iter0_57 = 1, 5 do
		local var1_57 = findTF(arg0_57._tf, "bg/img" .. iter0_57)
		local var2_57 = GetComponent(var1_57, typeof(Image)).color.a

		if iter0_57 == var0_57 then
			if var2_57 ~= 1 then
				LeanTween.alpha(var1_57, 1, 0.5)
			end
		elseif var2_57 ~= 0 then
			LeanTween.alpha(var1_57, 0, 0.5)
		end
	end
end

function var0_0.toMoveCar(arg0_58)
	if not arg0_58.targetPosition then
		return
	end

	local var0_58 = math.abs(arg0_58.targetPosition.x - arg0_58.char.localPosition.x)
	local var1_58 = math.abs(arg0_58.targetPosition.y - arg0_58.char.localPosition.y)

	if var0_58 <= 6.5 and var1_58 <= 6.5 then
		arg0_58.targetPosition = nil

		if arg0_58.moveComplete then
			arg0_58:updataCharDirect(arg0_58.targetPosIndex, true)
			arg0_58.moveComplete()
		end
	end

	arg0_58.speedX = math.abs(arg0_58.speedX + arg0_58.baseASpeedX) > math.abs(arg0_58.baseSpeedX) and arg0_58.baseSpeedX or arg0_58.speedX + arg0_58.baseASpeedX
	arg0_58.speedY = math.abs(arg0_58.speedY + arg0_58.baseASpeedY) > math.abs(arg0_58.baseSpeedY) and arg0_58.baseSpeedY or arg0_58.speedY + arg0_58.baseASpeedY

	local var2_58 = arg0_58.char.localPosition

	arg0_58.char.localPosition = Vector3(var2_58.x + arg0_58.speedX, var2_58.y + arg0_58.speedY, 0)
end

function var0_0.checkPathTurn(arg0_59, arg1_59)
	local var0_59 = arg1_59 + 1 > #arg0_59.mapCells and 1 or arg1_59 + 1
	local var1_59 = arg1_59 - 1 < 1 and #arg0_59.mapCells or arg1_59 - 1

	if arg0_59.mapCells[var0_59].col == arg0_59.mapCells[var1_59].col or arg0_59.mapCells[var0_59].row == arg0_59.mapCells[var1_59].row then
		return false
	end

	return true
end

function var0_0.moveCharWithPaths(arg0_60, arg1_60, arg2_60, arg3_60)
	if not arg1_60 or #arg1_60 <= 0 then
		if arg3_60 then
			arg3_60()
		end

		return
	end

	local var0_60 = {}
	local var1_60 = arg1_60[1] - 1 < 1 and #arg0_60.mapCells or arg1_60[1] - 1

	for iter0_60 = 1, #arg1_60 do
		local var2_60 = arg0_60.mapCells[arg1_60[iter0_60]]

		table.insert(var0_60, function(arg0_61)
			arg0_60:changeCharAction(arg2_60, 0, nil)
			arg0_60:updataCharDirect(var1_60, true)

			var1_60 = arg1_60[iter0_60]

			local var0_61
			local var1_61 = arg2_60 == var12_0 and 0.9 or arg2_60 == var14_0 and 0.9 or 0.5

			LeanTween.moveLocal(go(arg0_60.char), var2_60.tf.localPosition, var1_61):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
				if arg2_60 == var14_0 then
					LeanTween.delayedCall(0.05, System.Action(function()
						arg0_61()
					end))
				else
					arg0_61()
				end
			end))
		end)

		if iter0_60 == #arg1_60 then
			table.insert(var0_60, function(arg0_64)
				arg0_60:changeCharAction(var13_0, 0, nil)
				arg0_60:updataCharDirect(arg1_60[iter0_60], false)
				arg0_64()
			end)
		end
	end

	seriesAsync(var0_60, arg3_60)
end

function var0_0.changeCharAction(arg0_65, arg1_65, arg2_65, arg3_65)
	if arg0_65.actionName == arg1_65 and arg0_65.actionName ~= var14_0 then
		return
	end

	arg0_65.actionName = arg1_65

	arg0_65.anim:SetActionCallBack(nil)
	arg0_65.anim:SetAction(arg1_65, 0)
	arg0_65.anim:SetActionCallBack(function(arg0_66)
		if arg0_66 == "finish" then
			if arg2_65 == 1 then
				arg0_65.anim:SetActionCallBack(nil)
				arg0_65.anim:SetAction(var13_0, 0)
			end

			if arg3_65 then
				arg3_65()
			end
		end
	end)

	if arg2_65 ~= 1 and arg3_65 then
		arg3_65()
	end
end

function var0_0.getActionName(arg0_67, arg1_67)
	if arg1_67 == "icon_1" then
		return var11_0, var21_0
	elseif arg1_67 == "icon_2" then
		return var9_0, var17_0
	elseif arg1_67 == "icon_3" then
		return var11_0, var20_0
	elseif arg1_67 == "icon_4" then
		return var11_0, var21_0
	elseif arg1_67 == "icon_5" then
		return var10_0, var19_0
	elseif arg1_67 == "icon_6" then
		return nil, nil
	end
end

function var0_0.dispose(arg0_68)
	if arg0_68.skinCardName and arg0_68.showModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_68.skinCardName, arg0_68.showModel)
	end

	if arg0_68.funrTimer then
		arg0_68.funrTimer:Stop()

		arg0_68.funrTimer = nil
	end

	for iter0_68 = 1, 5 do
		local var0_68 = findTF(arg0_68._tf, "bg/img" .. iter0_68)

		if LeanTween.isTweening(var0_68) then
			LeanTween.cancel(var0_68)
		end
	end
end

return var0_0
