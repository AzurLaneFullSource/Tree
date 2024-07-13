local var0_0 = class("MonopolyGame")
local var1_0 = pg.activity_event_monopoly_map
local var2_0 = pg.activity_event_monopoly_event
local var3_0 = 501041
local var4_0 = 501041
local var5_0 = 6
local var6_0 = 5
local var7_0 = {}

var7_0.stateGold = "dafuweng_gold"
var7_0.stateOil = "dafuweng_oil"
var7_0.stateEvent = "dafuweng_event"
var7_0.stateWalk = "dafuweng_walk"
var7_0.stateStand = "dafuweng_stand"
var7_0.stateJump = "dafuweng_jump"
var7_0.stateRun = "dafuweng_run"
var7_0.stateTouch = "dafuweng_touch"

local var8_0

local function var9_0()
	local var0_1 = {
		onActionUpdated = function(arg0_2, arg1_2)
			return
		end
	}

	var0_1.currState = nil

	function var0_1.ChangeState(arg0_3, arg1_3, arg2_3)
		arg2_3 = arg2_3 or function()
			return
		end

		if arg0_3.currState == arg1_3 then
			arg2_3()
		end

		arg0_3.currState = arg1_3

		arg0_3.onActionUpdated(arg1_3, arg2_3)
	end

	function var0_1.IsStandState(arg0_5)
		return arg0_5.currState == var7_0.stateStand
	end

	return var0_1
end

local function var10_0(arg0_6)
	return {
		onMove = function(arg0_7, arg1_7)
			return
		end,
		onJump = function(arg0_8, arg1_8)
			return
		end,
		onUpdatePos = function(arg0_9)
			return
		end,
		ship = Ship.New({
			configId = arg0_6,
			skin_id = var4_0
		}),
		state = var9_0(),
		Move = function(arg0_10, arg1_10, arg2_10, arg3_10)
			arg2_10 = arg2_10 or function()
				return
			end

			if #arg1_10 == 0 then
				arg2_10()

				return
			end

			local function var0_10(arg0_12)
				if arg0_12 then
					arg0_10.state:ChangeState(var7_0.stateWalk)
				else
					arg0_10.state:ChangeState(var7_0.stateRun)
				end

				arg0_10.onMove(arg1_10, function()
					local var0_13 = arg0_10:GetAction(arg1_10[#arg1_10])

					if var0_13 then
						arg0_10.state:ChangeState(var0_13, function()
							arg0_10.state:ChangeState(var7_0.stateStand)
							arg2_10()
						end)
					else
						arg0_10.state:ChangeState(var7_0.stateStand)
						arg2_10()
					end
				end)
			end

			if #arg1_10 <= 3 and not arg3_10 then
				arg0_10:Jump(arg1_10, arg2_10)
			else
				var0_10(arg3_10)
			end
		end,
		Jump = function(arg0_15, arg1_15, arg2_15)
			arg2_15 = arg2_15 or function()
				return
			end

			if #arg1_15 == 0 then
				arg2_15()

				return
			end

			local var0_15 = {}

			for iter0_15, iter1_15 in pairs(arg1_15) do
				table.insert(var0_15, function(arg0_17)
					arg0_15.state:ChangeState(var7_0.stateJump)
					arg0_15.onJump(iter1_15, function()
						arg0_15.state:ChangeState(var7_0.stateStand)
						arg0_17()
					end)
				end)
			end

			seriesAsync(var0_15, function()
				local var0_19 = arg0_15:GetAction(arg1_15[#arg1_15])

				if var0_19 then
					arg0_15.state:ChangeState(var0_19, function()
						arg0_15.state:ChangeState(var7_0.stateStand)
						arg2_15()
					end)
				else
					arg0_15.state:ChangeState(var7_0.stateStand)
					arg2_15()
				end
			end)
		end,
		Touch = function(arg0_21)
			if arg0_21.state:IsStandState() then
				arg0_21.state:ChangeState(var7_0.stateTouch, function()
					arg0_21.state:ChangeState(var7_0.stateStand)
				end)
			end
		end,
		GetAction = function(arg0_23, arg1_23)
			local var0_23 = arg1_23.config.icon

			if var0_23 == "icon_1" then
				return var7_0.stateEvent
			elseif var0_23 == "icon_2" then
				return var7_0.stateGold
			elseif var0_23 == "icon_3" then
				-- block empty
			elseif var0_23 == "icon_4" then
				return var7_0.stateEvent
			elseif var0_23 == "icon_5" then
				return var7_0.stateOil
			elseif var0_23 == "icon_6" then
				return var7_0.stateEvent
			end
		end,
		InitPos = function(arg0_24, arg1_24)
			arg0_24:ChangePos(arg1_24)
			arg0_24.state:ChangeState(var7_0.stateStand)
		end,
		ChangePos = function(arg0_25, arg1_25)
			assert(arg1_25)
			arg0_25.onUpdatePos(arg1_25)
		end,
		Dispose = function(arg0_26)
			arg0_26.onMove = nil
			arg0_26.onUpdatePos = nil
		end
	}
end

local function var11_0(arg0_27)
	return {
		id = arg0_27,
		config = var2_0[arg0_27],
		ExistStory = function(arg0_28)
			return arg0_28.config.story and arg0_28.config.story ~= "0"
		end,
		isEmpty = function(arg0_29)
			return arg0_29.config.story == "0" and arg0_29.config.drop == 0 and #arg0_29.config.effect == 0
		end,
		Dispose = function(arg0_30)
			arg0_30.config = nil
		end
	}
end

local function var12_0(arg0_31)
	local var0_31 = {}

	var0_31.row, var0_31.column = arg0_31.pos[1], arg0_31.pos[2]
	var0_31.index = arg0_31.index
	var0_31.id = arg0_31.id
	var0_31.flag = arg0_31.flag

	assert(var0_31.id)

	var0_31.config = var1_0[var0_31.id]
	var0_31.events = {}

	for iter0_31, iter1_31 in ipairs(var2_0.all) do
		if not table.contains(var0_31.events, iter1_31) then
			table.insert(var0_31.events, var11_0(iter1_31))
		end
	end

	function var0_31.GetEvent(arg0_32, arg1_32)
		for iter0_32, iter1_32 in ipairs(arg0_32.events) do
			if iter1_32.id == arg1_32 then
				return iter1_32
			end
		end
	end

	function var0_31.SetNext(arg0_33, arg1_33)
		arg0_33.next = arg1_33
	end

	function var0_31.Dispose(arg0_34)
		for iter0_34, iter1_34 in ipairs(arg0_34.events) do
			iter1_34:Dispose()
		end
	end

	return var0_31
end

local function var13_0(arg0_35, arg1_35)
	local var0_35 = {
		ROW = var5_0,
		COLUMN = var6_0 - 2,
		cellIds = arg0_35,
		path = {}
	}

	var0_35.char = nil
	var0_35.index = arg1_35

	function var0_35.onCreateCell(arg0_36)
		return
	end

	function var0_35.onCreateChar(arg0_37)
		return
	end

	function var0_35.Init(arg0_38)
		local var0_38 = 0

		for iter0_38 = 0, var0_35.ROW - 1 do
			var0_35:CeateCell({
				var0_38,
				iter0_38
			}, 0)
		end

		local var1_38 = var0_35.ROW - 1

		for iter1_38 = 1, var0_35.COLUMN do
			var0_35:CeateCell({
				iter1_38,
				var1_38
			}, #arg0_38.path)
		end

		local var2_38 = var0_35.COLUMN + 1

		for iter2_38 = var0_35.ROW - 1, 0, -1 do
			var0_35:CeateCell({
				var2_38,
				iter2_38
			}, #arg0_38.path)
		end

		local var3_38 = 0
		local var4_38 = #arg0_38.path - 1

		for iter3_38 = var0_35.COLUMN, 1, -1 do
			var0_35:CeateCell({
				iter3_38,
				var3_38
			}, var4_38)
		end

		arg0_38:CreateChar(var3_0)
	end

	function var0_35.CreateChar(arg0_39, arg1_39)
		arg0_39.char = var10_0(arg1_39)

		arg0_39.onCreateChar(arg0_39.char)

		local var0_39 = arg0_39:GetCell(arg0_39.index)

		arg0_39.char:InitPos(var0_39)
	end

	function var0_35.CeateCell(arg0_40, arg1_40, arg2_40)
		local var0_40 = #arg0_40.path
		local var1_40 = var12_0({
			pos = arg1_40,
			index = var0_40 + 1,
			id = arg0_40.cellIds[var0_40 + 1],
			flag = arg2_40
		})

		if var0_40 == 0 then
			var1_40:SetNext(var1_40)
		else
			local var2_40 = arg0_40.path[var0_40]
			local var3_40 = arg0_40.path[1]

			var2_40:SetNext(var1_40)
			var1_40:SetNext(var3_40)
		end

		table.insert(arg0_40.path, var1_40)
		arg0_40.onCreateCell(var1_40)
	end

	function var0_35.GetPath(arg0_41)
		return arg0_41.path
	end

	function var0_35.GetChar(arg0_42)
		return arg0_42.char
	end

	function var0_35.GetPathCell(arg0_43, arg1_43)
		return _.map(arg1_43, function(arg0_44)
			return arg0_43.path[arg0_44]
		end)
	end

	function var0_35.UpdateCharPos(arg0_45, arg1_45, arg2_45, arg3_45)
		local var0_45 = arg0_45:GetPathCell(arg1_45)

		arg0_45.char:Move(var0_45, arg2_45, arg3_45)

		arg0_45.index = arg1_45[#arg1_45]
	end

	function var0_35.GetCell(arg0_46, arg1_46)
		return arg0_46.path[arg1_46]
	end

	function var0_35.GetPos(arg0_47)
		return arg0_47.index
	end

	function var0_35.Dispose(arg0_48)
		for iter0_48, iter1_48 in ipairs(arg0_48.path) do
			iter1_48:Dispose()
		end

		arg0_48.char:Dispose()

		arg0_48.onCreateCell = nil
		arg0_48.onCreateChar = nil
	end

	return var0_35
end

local function var14_0(arg0_49, arg1_49)
	local var0_49 = {
		_tf = arg0_49,
		_img = arg0_49:GetComponent(typeof(Image)),
		cell = arg1_49,
		interval = Vector2(0, 0),
		startPos = Vector2(0, 0),
		offset = Vector2(arg0_49.rect.width * 0.5 + 2.5, arg0_49.rect.height * 0.5 - 2),
		GetGenPos = function(arg0_50)
			local var0_50 = arg0_50.cell.column
			local var1_50 = arg0_50.cell.row
			local var2_50 = arg0_50.startPos.x + var0_50 * arg0_50.offset.x + var1_50 * arg0_50.offset.x
			local var3_50 = arg0_50.startPos.y + var0_50 * arg0_50.offset.y + var1_50 * -arg0_50.offset.y

			return Vector3(var2_50, var3_50, 0)
		end,
		UpdateStyle = function(arg0_51)
			local var0_51 = arg0_51.cell
			local var1_51 = GetSpriteFromAtlas("ui/activityuipage/monopolycar_atlas", var0_51.config.icon)

			arg0_51._img.sprite = var1_51

			arg0_51._img:SetNativeSize()
		end,
		Dispose = function(arg0_52)
			return
		end
	}

	setAnchoredPosition(arg0_49, var0_49:GetGenPos())
	var0_49._tf:SetSiblingIndex(arg1_49.flag)

	return var0_49
end

local function var15_0(arg0_53, arg1_53)
	local var0_53 = {
		_tf = arg0_53
	}

	var0_53.WalkSpeed = 1
	var0_53.RunSpeed = 0.5
	var0_53.jumpSpeed = 0.5
	var0_53.char = arg1_53

	local var1_53 = arg0_53:GetChild(0)

	tf(var1_53).localScale = Vector3(0.5, 0.5, 0.5)
	var0_53.SpineAnimUI = var1_53:GetComponent("SpineAnimUI")

	local var2_53 = GameObject("mouseChild")

	tf(var2_53):SetParent(tf(var1_53))

	tf(var2_53).localPosition = Vector3.zero

	setParent(var2_53, var1_53)

	GetOrAddComponent(var2_53, "Image").color = Color.New(0, 0, 0, 0)

	local var3_53 = var2_53:GetComponent(typeof(RectTransform))

	var3_53.sizeDelta = Vector2(3, 3)
	var3_53.pivot = Vector2(0.5, 0)
	var3_53.anchoredPosition = Vector2(0, 0)

	onButton(nil, var2_53, function()
		var0_53.char:Touch()
	end)

	function var0_53.Action(arg0_55, arg1_55, arg2_55, arg3_55)
		local var0_55 = {}

		_.each(arg1_55, function(arg0_56)
			table.insert(var0_55, function(arg0_57)
				arg0_55:UpdateScale(arg0_56)

				local var0_57 = arg0_56:GetGenPos()

				if arg0_55._tf.localPosition == var0_57 then
					arg0_57()
				else
					LeanTween.moveLocal(go(arg0_55._tf), var0_57, arg3_55):setOnComplete(System.Action(function()
						arg0_55.preCellTF = arg0_56

						arg0_57()
					end))
				end
			end)
		end)
		seriesAsync(var0_55, function()
			if arg2_55 then
				arg2_55()
			end
		end)
	end

	function var0_53.Move(arg0_60, arg1_60, arg2_60)
		if #arg1_60 > 3 then
			arg0_60:Action(arg1_60, arg2_60, arg0_60.RunSpeed)
		else
			arg0_60:Action(arg1_60, arg2_60, arg0_60.WalkSpeed)
		end
	end

	function var0_53.Jump(arg0_61, arg1_61, arg2_61)
		arg0_61:Action({
			arg1_61
		}, function()
			arg2_61()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_STEP_MONOPOLY)
		end, arg0_61.jumpSpeed)
	end

	function var0_53.UpdatePos(arg0_63, arg1_63)
		arg0_63.preCellTF = arg1_63

		local var0_63 = arg1_63:GetGenPos()

		arg0_63._tf.localPosition = var0_63
	end

	function var0_53.UpdateScale(arg0_64, arg1_64)
		local var0_64 = 1

		arg0_64.preCellTF = arg0_64.preCellTF or arg1_64

		if arg1_64.cell.row > arg0_64.preCellTF.cell.row or arg1_64.cell.column > arg0_64.preCellTF.cell.column then
			var0_64 = 1
		elseif arg1_64.cell.row < arg0_64.preCellTF.cell.row or arg1_64.cell.column < arg0_64.preCellTF.cell.column then
			var0_64 = -1
		end

		arg0_64._tf.localScale = Vector3(var0_64, 1, 1)
	end

	function var0_53.ChangeAction(arg0_65, arg1_65, arg2_65)
		arg0_65.SpineAnimUI:SetActionCallBack(nil)
		arg0_65.SpineAnimUI:SetAction(arg1_65, 0)
		arg0_65.SpineAnimUI:SetActionCallBack(function(arg0_66)
			if arg0_66 == "finish" then
				arg0_65.SpineAnimUI:SetActionCallBack(nil)
				arg2_65()
			end
		end)
	end

	function var0_53.Dispose(arg0_67)
		arg0_67.SpineAnimUI:SetActionCallBack(nil)

		arg0_67.char.onMove = nil

		if arg0_67.timer then
			arg0_67.timer:Stop()

			arg0_67.timer = nil
		end
	end

	return var0_53
end

function var0_0.SetUp(arg0_68, arg1_68, arg2_68)
	arg0_68.viewComponent = arg1_68

	local var0_68 = arg0_68.viewComponent._tf

	pg.DelegateInfo.New(arg0_68)

	arg0_68._tf = var0_68
	arg0_68._go = go(var0_68)
	arg0_68.models = {}

	parallelAsync({
		function(arg0_69)
			local var0_69 = Ship.New({
				configId = var3_0,
				skin_id = var4_0
			})
			local var1_69 = var0_69:getPrefab()

			PoolMgr.GetInstance():GetSpineChar(var1_69, true, function(arg0_70)
				arg0_68.models[var0_69.configId] = arg0_70

				arg0_69()
			end)
		end,
		function(arg0_71)
			onNextTick(arg0_71)
		end
	}, function()
		arg0_68:setActivity(arg2_68)
		arg0_68:init()
		arg0_68:didEnter()
	end)
end

function var0_0.setActivity(arg0_73, arg1_73)
	arg0_73.activity = arg1_73

	local var0_73 = arg0_73.activity.data1
	local var1_73 = arg0_73.activity.data1_list[1]

	arg0_73.useCount = arg0_73.activity.data1_list[2]

	local var2_73 = arg0_73.activity.data1_list[3] - 1
	local var3_73 = arg0_73.activity.data2_list[1]
	local var4_73 = arg0_73.activity.data2_list[2]
	local var5_73 = pg.TimeMgr.GetInstance():GetServerTime()
	local var6_73 = math.ceil((var5_73 - var0_73) / 86400) * arg0_73.activity:getDataConfig("daily_time")

	arg0_73.pos = arg0_73.activity.data2
	arg0_73.step = arg0_73.activity.data3
	arg0_73.effectId = arg0_73.activity.data4
	arg0_73.totalCnt = var6_73 + var1_73
	arg0_73.leftCount = arg0_73.totalCnt - arg0_73.useCount

	local var7_73 = arg1_73:getDataConfig("reward_time")

	arg0_73.nextredPacketStep = var7_73 - arg0_73.useCount % var7_73
	arg0_73.advanceTotalCnt = #arg1_73:getDataConfig("reward")
	arg0_73.isAdvanceRp = arg0_73.advanceTotalCnt - var4_73 > 0
	arg0_73.leftAwardCnt = var3_73 - var4_73
	arg0_73.advanceRpCount = math.max(0, math.min(var3_73, arg0_73.advanceTotalCnt) - var4_73)
	arg0_73.commonRpCount = math.max(0, var3_73 - arg0_73.advanceTotalCnt) - math.max(0, var4_73 - arg0_73.advanceTotalCnt)
	arg0_73.leftDropShipCnt = 10 - var2_73
end

function var0_0.NetActivity(arg0_74, arg1_74)
	arg0_74:setActivity(arg1_74)
	arg0_74:updateLeftCount()
	arg0_74:updateNextRedPacketStep()
end

function var0_0.init(arg0_75)
	arg0_75:blockAllEvent(false)

	arg0_75.bg = arg0_75:findTF("AD")
	arg0_75.mapCellTpl = arg0_75:getTpl("mapCell", arg0_75.bg)
	arg0_75.mapContainer = arg0_75:findTF("mapContainer", arg0_75.bg)
	arg0_75.charTpl = arg0_75:getTpl("char", arg0_75.bg)
	arg0_75.startBtn = arg0_75:findTF("start", arg0_75.bg)
	arg0_75.valueImg = arg0_75:findTF("value", arg0_75.bg):GetComponent(typeof(Image))
	arg0_75.leftcountLabel = arg0_75:findTF("leftcount", arg0_75.bg):GetComponent(typeof(Text))
	arg0_75.leftCountTF = arg0_75:findTF("leftcount/Text", arg0_75.bg):GetComponent(typeof(Text))
	arg0_75.nextRedPacketStepTF = arg0_75:findTF("nextRpStep/Text", arg0_75.bg):GetComponent(typeof(Text))
	arg0_75.commonRp = arg0_75:findTF("rp", arg0_75.bg)
	arg0_75.commonAnim = arg0_75.commonRp:GetComponent(typeof(Animator))
	arg0_75.commonRpCnt = arg0_75:findTF("rp_text/Text", arg0_75.bg):GetComponent(typeof(Text))
	arg0_75.dropShipTxt = arg0_75:findTF("AD/drop_ship_text"):GetComponent(typeof(Text))
	arg0_75.helpBtn = arg0_75:findTF("AD/help")
	arg0_75.anim = arg0_75:findTF("AD/anim")

	setActive(arg0_75.anim, false)

	arg0_75.leftcountLabel.text = i18n("monopoly_left_count")
	arg0_75.advanceTag = arg0_75:findTF("AD/rp/sp")
	arg0_75.advanceLabel = arg0_75:findTF("AD/rp_text/sp")
	arg0_75.advancecLabel = arg0_75:findTF("AD/rp_text/label")
	arg0_75.advanceImage = arg0_75:findTF("AD/rp_text/sp_img")
	arg0_75.advanceTxt = arg0_75:findTF("AD/rp_text/sp_img/Text"):GetComponent(typeof(Text))
end

function var0_0.updateNextRedPacketStep(arg0_76)
	arg0_76.nextRedPacketStepTF.text = arg0_76.nextredPacketStep
end

function var0_0.updateLeftCount(arg0_77)
	arg0_77.leftCountTF.text = arg0_77.leftCount

	arg0_77.commonAnim:SetInteger("count", arg0_77.leftAwardCnt)

	arg0_77.commonRpCnt.text = arg0_77.commonRpCount
end

function var0_0.updateValue(arg0_78, arg1_78)
	if arg1_78 ~= 0 then
		arg0_78.valueImg.sprite = GetSpriteFromAtlas("ui/activityuipage/monopoly_atlas", arg1_78)

		arg0_78.valueImg:SetNativeSize()
	end

	setActive(go(arg0_78.valueImg), arg1_78 ~= 0)
end

function var0_0.didEnter(arg0_79)
	setActive(arg0_79.startBtn, arg0_79.leftCount > 0)
	arg0_79:updateLeftCount()
	arg0_79:updateValue(0)
	arg0_79:updateNextRedPacketStep()

	local var0_79 = arg0_79.activity:getDataConfig("map")

	arg0_79.mapVO = var13_0(var0_79, arg0_79.pos)

	arg0_79:createMap(arg0_79.mapVO)
	arg0_79.mapVO:Init()
	arg0_79:checkState()
	onButton(arg0_79, arg0_79.startBtn, function()
		if arg0_79.block then
			return
		end

		if arg0_79.leftCount <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end

		arg0_79:startAction()
	end, SFX_PANEL)
	onButton(arg0_79, arg0_79.commonRp, function()
		if arg0_79.leftAwardCnt > 0 then
			arg0_79:emit(MonopolyPage.ON_AWARD)
		end
	end, SFX_PANEL)
	onButton(arg0_79, arg0_79.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie_monopoly.tip
		})
	end, SFX_PANEL)
end

function var0_0.blockAllEvent(arg0_83, arg1_83)
	arg0_83:emit(ActivityMainScene.LOCK_ACT_MAIN, arg1_83)

	arg0_83.block = arg1_83
end

function var0_0.triggerEvent(arg0_84, arg1_84, arg2_84, arg3_84)
	local var0_84 = arg0_84.mapVO:GetCell(arg1_84):GetEvent(arg2_84)

	local function var1_84(arg0_85, arg1_85)
		if arg0_85 and arg0_85:ExistStory() then
			pg.NewStoryMgr.GetInstance():Play(arg0_85.config.story, arg1_85, true, true)
		else
			arg1_85()
		end
	end

	local var2_84 = {
		function(arg0_86)
			var1_84(var0_84, arg0_86)
		end,
		function(arg0_87)
			local var0_87

			local function var1_87()
				if not var0_84 or var0_84:isEmpty() then
					arg0_87()

					return
				end

				arg0_84:emit(MonopolyPage.ON_TRIGGER, arg0_84.activity.id, function(arg0_89, arg1_89)
					if not arg0_89 or #arg0_89 == 0 then
						arg0_87()

						return
					end

					arg0_84.mapVO:UpdateCharPos(arg0_89, function()
						local var0_90 = arg0_89[#arg0_89]

						var0_84 = arg0_84.mapVO:GetCell(var0_90):GetEvent(arg1_89)

						var1_84(var0_84, var1_87)
					end, true)
				end)
			end

			var1_87()
		end
	}

	seriesAsync(var2_84, arg3_84)
end

function var0_0.checkState(arg0_91)
	local var0_91 = {}

	arg0_91:blockAllEvent(true)

	local var1_91 = arg0_91:getStrory()

	if var1_91 then
		table.insert(var0_91, function(arg0_92)
			pg.NewStoryMgr.GetInstance():Play(var1_91, arg0_92)
		end)
	end

	if arg0_91.effectId ~= 0 then
		table.insert(var0_91, function(arg0_93)
			local var0_93 = arg0_91.mapVO:GetPos()

			arg0_91:triggerEvent(var0_93, arg0_91.effectId, arg0_93)
		end)
	end

	if arg0_91.step ~= 0 then
		table.insert(var0_91, function(arg0_94)
			arg0_91:emit(MonopolyPage.ON_MOVE, arg0_91.activity.id, function(arg0_95, arg1_95, arg2_95)
				if not arg1_95 or #arg1_95 == 0 then
					arg0_94()

					return
				end

				arg0_91.mapVO:UpdateCharPos(arg1_95, function()
					local var0_96 = arg1_95[#arg1_95]

					arg0_91:triggerEvent(var0_96, arg2_95, arg0_94)
				end)
			end)
		end)
	end

	seriesAsync(var0_91, function()
		arg0_91:blockAllEvent(false)
	end)
end

function var0_0.startAction(arg0_98)
	local var0_98 = arg0_98.activity.id
	local var1_98 = 0

	local function var2_98(arg0_99)
		if var1_98 == 0 then
			arg0_99()

			return
		end

		arg0_98:emit(MonopolyPage.ON_MOVE, var0_98, function(arg0_100, arg1_100, arg2_100)
			if not arg1_100 or #arg1_100 == 0 then
				arg0_99()

				return
			end

			var1_98 = arg0_100

			arg0_98.mapVO:UpdateCharPos(arg1_100, function()
				local var0_101 = arg1_100[#arg1_100]

				arg0_98:triggerEvent(var0_101, arg2_100, arg0_99)
			end)
		end)
	end

	seriesAsync({
		function(arg0_102)
			setActive(arg0_98.startBtn, false)
			arg0_98:blockAllEvent(true)
			arg0_98:playerAnim(arg0_102)
		end,
		function(arg0_103)
			arg0_98:emit(MonopolyPage.ON_START, var0_98, function(arg0_104)
				var1_98 = arg0_104

				arg0_98:updateValue(arg0_104)
				arg0_103()
			end)
		end,
		function(arg0_105)
			var2_98(arg0_105)
		end,
		function(arg0_106)
			var2_98(arg0_106)
		end,
		function(arg0_107)
			local var0_107 = arg0_98:getStrory()

			if not var0_107 then
				arg0_107()

				return
			end

			pg.NewStoryMgr.GetInstance():Play(var0_107, arg0_107)
		end
	}, function()
		arg0_98:updateValue(0)
		arg0_98:blockAllEvent(false)
		setActive(arg0_98.startBtn, arg0_98.leftCount > 0)
	end)
end

function var0_0.getStrory(arg0_109)
	local var0_109 = arg0_109.useCount
	local var1_109 = arg0_109.activity:getDataConfig("story") or {}
	local var2_109 = _.detect(var1_109, function(arg0_110)
		return arg0_110[1] == var0_109
	end)

	if var2_109 then
		return var2_109[2]
	end

	return nil
end

function var0_0.createMap(arg0_111, arg1_111)
	arg0_111.cellTFs, arg0_111.charCard = {}

	function arg1_111.onCreateCell(arg0_112)
		local var0_112 = cloneTplTo(arg0_111.mapCellTpl, arg0_111.mapContainer)
		local var1_112 = var14_0(var0_112, arg0_112)

		var1_112:UpdateStyle()

		arg0_111.cellTFs[arg0_112.index] = var1_112
	end

	function arg1_111.onCreateChar(arg0_113)
		local var0_113 = cloneTplTo(arg0_111.charTpl, arg0_111.mapContainer)
		local var1_113 = arg0_111.models[arg0_113.ship.configId]

		setParent(var1_113, var0_113)

		arg0_111.charCard = var15_0(var0_113, arg0_113)

		function arg0_113.onMove(arg0_114, arg1_114)
			local var0_114 = _.map(arg0_114, function(arg0_115)
				return arg0_111.cellTFs[arg0_115.index]
			end)

			arg0_111.charCard:Move(var0_114, arg1_114)
		end

		function arg0_113.onUpdatePos(arg0_116)
			local var0_116 = arg0_111.cellTFs[arg0_116.index]

			arg0_111.charCard:UpdatePos(var0_116)
		end

		function arg0_113.state.onActionUpdated(arg0_117, arg1_117)
			arg0_111.charCard:ChangeAction(arg0_117, arg1_117)
		end

		function arg0_113.onJump(arg0_118, arg1_118)
			local var0_118 = arg0_111.cellTFs[arg0_118.index]

			arg0_111.charCard:Jump(var0_118, arg1_118)
		end
	end
end

function var0_0.playerAnim(arg0_119, arg1_119)
	setActive(arg0_119.anim, true)

	if arg0_119.timer then
		arg0_119.timer:Stop()
	end

	arg0_119.timer = Timer.New(function()
		arg1_119()
		setActive(arg0_119.anim, false)
	end, 1.5, 1)

	arg0_119.timer:Start()
end

function var0_0.findTF(arg0_121, arg1_121, arg2_121)
	assert(arg0_121._tf, "transform should exist")

	return findTF(arg2_121 or arg0_121._tf, arg1_121)
end

function var0_0.getTpl(arg0_122, arg1_122, arg2_122)
	local var0_122 = arg0_122:findTF(arg1_122, arg2_122)

	var0_122:SetParent(arg0_122._tf, false)
	SetActive(var0_122, false)

	return var0_122
end

function var0_0.Destroy(arg0_123)
	for iter0_123, iter1_123 in pairs(arg0_123.cellTFs) do
		iter1_123:Dispose()
	end

	arg0_123.charCard:Dispose()
	arg0_123.mapVO:Dispose()

	arg0_123.cellTFs = nil
	arg0_123.charCard = nil
	arg0_123.mapVO = nil

	if arg0_123.timer then
		arg0_123.timer:Stop()

		arg0_123.timer = nil
	end

	pg.DelegateInfo.Dispose(arg0_123)
end

function var0_0.emit(arg0_124, arg1_124, arg2_124, arg3_124)
	arg0_124.viewComponent:emit(arg1_124, arg2_124, arg3_124)
end

return var0_0
