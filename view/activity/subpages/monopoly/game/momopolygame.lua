local var0 = class("MonopolyGame")
local var1 = pg.activity_event_monopoly_map
local var2 = pg.activity_event_monopoly_event
local var3 = 501041
local var4 = 501041
local var5 = 6
local var6 = 5
local var7 = {}

var7.stateGold = "dafuweng_gold"
var7.stateOil = "dafuweng_oil"
var7.stateEvent = "dafuweng_event"
var7.stateWalk = "dafuweng_walk"
var7.stateStand = "dafuweng_stand"
var7.stateJump = "dafuweng_jump"
var7.stateRun = "dafuweng_run"
var7.stateTouch = "dafuweng_touch"

local var8

local function var9()
	local var0 = {
		onActionUpdated = function(arg0, arg1)
			return
		end
	}

	var0.currState = nil

	function var0.ChangeState(arg0, arg1, arg2)
		arg2 = arg2 or function()
			return
		end

		if arg0.currState == arg1 then
			arg2()
		end

		arg0.currState = arg1

		arg0.onActionUpdated(arg1, arg2)
	end

	function var0.IsStandState(arg0)
		return arg0.currState == var7.stateStand
	end

	return var0
end

local function var10(arg0)
	return {
		onMove = function(arg0, arg1)
			return
		end,
		onJump = function(arg0, arg1)
			return
		end,
		onUpdatePos = function(arg0)
			return
		end,
		ship = Ship.New({
			configId = arg0,
			skin_id = var4
		}),
		state = var9(),
		Move = function(arg0, arg1, arg2, arg3)
			arg2 = arg2 or function()
				return
			end

			if #arg1 == 0 then
				arg2()

				return
			end

			local function var0(arg0)
				if arg0 then
					arg0.state:ChangeState(var7.stateWalk)
				else
					arg0.state:ChangeState(var7.stateRun)
				end

				arg0.onMove(arg1, function()
					local var0 = arg0:GetAction(arg1[#arg1])

					if var0 then
						arg0.state:ChangeState(var0, function()
							arg0.state:ChangeState(var7.stateStand)
							arg2()
						end)
					else
						arg0.state:ChangeState(var7.stateStand)
						arg2()
					end
				end)
			end

			if #arg1 <= 3 and not arg3 then
				arg0:Jump(arg1, arg2)
			else
				var0(arg3)
			end
		end,
		Jump = function(arg0, arg1, arg2)
			arg2 = arg2 or function()
				return
			end

			if #arg1 == 0 then
				arg2()

				return
			end

			local var0 = {}

			for iter0, iter1 in pairs(arg1) do
				table.insert(var0, function(arg0)
					arg0.state:ChangeState(var7.stateJump)
					arg0.onJump(iter1, function()
						arg0.state:ChangeState(var7.stateStand)
						arg0()
					end)
				end)
			end

			seriesAsync(var0, function()
				local var0 = arg0:GetAction(arg1[#arg1])

				if var0 then
					arg0.state:ChangeState(var0, function()
						arg0.state:ChangeState(var7.stateStand)
						arg2()
					end)
				else
					arg0.state:ChangeState(var7.stateStand)
					arg2()
				end
			end)
		end,
		Touch = function(arg0)
			if arg0.state:IsStandState() then
				arg0.state:ChangeState(var7.stateTouch, function()
					arg0.state:ChangeState(var7.stateStand)
				end)
			end
		end,
		GetAction = function(arg0, arg1)
			local var0 = arg1.config.icon

			if var0 == "icon_1" then
				return var7.stateEvent
			elseif var0 == "icon_2" then
				return var7.stateGold
			elseif var0 == "icon_3" then
				-- block empty
			elseif var0 == "icon_4" then
				return var7.stateEvent
			elseif var0 == "icon_5" then
				return var7.stateOil
			elseif var0 == "icon_6" then
				return var7.stateEvent
			end
		end,
		InitPos = function(arg0, arg1)
			arg0:ChangePos(arg1)
			arg0.state:ChangeState(var7.stateStand)
		end,
		ChangePos = function(arg0, arg1)
			assert(arg1)
			arg0.onUpdatePos(arg1)
		end,
		Dispose = function(arg0)
			arg0.onMove = nil
			arg0.onUpdatePos = nil
		end
	}
end

local function var11(arg0)
	return {
		id = arg0,
		config = var2[arg0],
		ExistStory = function(arg0)
			return arg0.config.story and arg0.config.story ~= "0"
		end,
		isEmpty = function(arg0)
			return arg0.config.story == "0" and arg0.config.drop == 0 and #arg0.config.effect == 0
		end,
		Dispose = function(arg0)
			arg0.config = nil
		end
	}
end

local function var12(arg0)
	local var0 = {}

	var0.row, var0.column = arg0.pos[1], arg0.pos[2]
	var0.index = arg0.index
	var0.id = arg0.id
	var0.flag = arg0.flag

	assert(var0.id)

	var0.config = var1[var0.id]
	var0.events = {}

	for iter0, iter1 in ipairs(var2.all) do
		if not table.contains(var0.events, iter1) then
			table.insert(var0.events, var11(iter1))
		end
	end

	function var0.GetEvent(arg0, arg1)
		for iter0, iter1 in ipairs(arg0.events) do
			if iter1.id == arg1 then
				return iter1
			end
		end
	end

	function var0.SetNext(arg0, arg1)
		arg0.next = arg1
	end

	function var0.Dispose(arg0)
		for iter0, iter1 in ipairs(arg0.events) do
			iter1:Dispose()
		end
	end

	return var0
end

local function var13(arg0, arg1)
	local var0 = {
		ROW = var5,
		COLUMN = var6 - 2,
		cellIds = arg0,
		path = {}
	}

	var0.char = nil
	var0.index = arg1

	function var0.onCreateCell(arg0)
		return
	end

	function var0.onCreateChar(arg0)
		return
	end

	function var0.Init(arg0)
		local var0 = 0

		for iter0 = 0, var0.ROW - 1 do
			var0:CeateCell({
				var0,
				iter0
			}, 0)
		end

		local var1 = var0.ROW - 1

		for iter1 = 1, var0.COLUMN do
			var0:CeateCell({
				iter1,
				var1
			}, #arg0.path)
		end

		local var2 = var0.COLUMN + 1

		for iter2 = var0.ROW - 1, 0, -1 do
			var0:CeateCell({
				var2,
				iter2
			}, #arg0.path)
		end

		local var3 = 0
		local var4 = #arg0.path - 1

		for iter3 = var0.COLUMN, 1, -1 do
			var0:CeateCell({
				iter3,
				var3
			}, var4)
		end

		arg0:CreateChar(var3)
	end

	function var0.CreateChar(arg0, arg1)
		arg0.char = var10(arg1)

		arg0.onCreateChar(arg0.char)

		local var0 = arg0:GetCell(arg0.index)

		arg0.char:InitPos(var0)
	end

	function var0.CeateCell(arg0, arg1, arg2)
		local var0 = #arg0.path
		local var1 = var12({
			pos = arg1,
			index = var0 + 1,
			id = arg0.cellIds[var0 + 1],
			flag = arg2
		})

		if var0 == 0 then
			var1:SetNext(var1)
		else
			local var2 = arg0.path[var0]
			local var3 = arg0.path[1]

			var2:SetNext(var1)
			var1:SetNext(var3)
		end

		table.insert(arg0.path, var1)
		arg0.onCreateCell(var1)
	end

	function var0.GetPath(arg0)
		return arg0.path
	end

	function var0.GetChar(arg0)
		return arg0.char
	end

	function var0.GetPathCell(arg0, arg1)
		return _.map(arg1, function(arg0)
			return arg0.path[arg0]
		end)
	end

	function var0.UpdateCharPos(arg0, arg1, arg2, arg3)
		local var0 = arg0:GetPathCell(arg1)

		arg0.char:Move(var0, arg2, arg3)

		arg0.index = arg1[#arg1]
	end

	function var0.GetCell(arg0, arg1)
		return arg0.path[arg1]
	end

	function var0.GetPos(arg0)
		return arg0.index
	end

	function var0.Dispose(arg0)
		for iter0, iter1 in ipairs(arg0.path) do
			iter1:Dispose()
		end

		arg0.char:Dispose()

		arg0.onCreateCell = nil
		arg0.onCreateChar = nil
	end

	return var0
end

local function var14(arg0, arg1)
	local var0 = {
		_tf = arg0,
		_img = arg0:GetComponent(typeof(Image)),
		cell = arg1,
		interval = Vector2(0, 0),
		startPos = Vector2(0, 0),
		offset = Vector2(arg0.rect.width * 0.5 + 2.5, arg0.rect.height * 0.5 - 2),
		GetGenPos = function(arg0)
			local var0 = arg0.cell.column
			local var1 = arg0.cell.row
			local var2 = arg0.startPos.x + var0 * arg0.offset.x + var1 * arg0.offset.x
			local var3 = arg0.startPos.y + var0 * arg0.offset.y + var1 * -arg0.offset.y

			return Vector3(var2, var3, 0)
		end,
		UpdateStyle = function(arg0)
			local var0 = arg0.cell
			local var1 = GetSpriteFromAtlas("ui/activityuipage/monopolycar_atlas", var0.config.icon)

			arg0._img.sprite = var1

			arg0._img:SetNativeSize()
		end,
		Dispose = function(arg0)
			return
		end
	}

	setAnchoredPosition(arg0, var0:GetGenPos())
	var0._tf:SetSiblingIndex(arg1.flag)

	return var0
end

local function var15(arg0, arg1)
	local var0 = {
		_tf = arg0
	}

	var0.WalkSpeed = 1
	var0.RunSpeed = 0.5
	var0.jumpSpeed = 0.5
	var0.char = arg1

	local var1 = arg0:GetChild(0)

	tf(var1).localScale = Vector3(0.5, 0.5, 0.5)
	var0.SpineAnimUI = var1:GetComponent("SpineAnimUI")

	local var2 = GameObject("mouseChild")

	tf(var2):SetParent(tf(var1))

	tf(var2).localPosition = Vector3.zero

	setParent(var2, var1)

	GetOrAddComponent(var2, "Image").color = Color.New(0, 0, 0, 0)

	local var3 = var2:GetComponent(typeof(RectTransform))

	var3.sizeDelta = Vector2(3, 3)
	var3.pivot = Vector2(0.5, 0)
	var3.anchoredPosition = Vector2(0, 0)

	onButton(nil, var2, function()
		var0.char:Touch()
	end)

	function var0.Action(arg0, arg1, arg2, arg3)
		local var0 = {}

		_.each(arg1, function(arg0)
			table.insert(var0, function(arg0)
				arg0:UpdateScale(arg0)

				local var0 = arg0:GetGenPos()

				if arg0._tf.localPosition == var0 then
					arg0()
				else
					LeanTween.moveLocal(go(arg0._tf), var0, arg3):setOnComplete(System.Action(function()
						arg0.preCellTF = arg0

						arg0()
					end))
				end
			end)
		end)
		seriesAsync(var0, function()
			if arg2 then
				arg2()
			end
		end)
	end

	function var0.Move(arg0, arg1, arg2)
		if #arg1 > 3 then
			arg0:Action(arg1, arg2, arg0.RunSpeed)
		else
			arg0:Action(arg1, arg2, arg0.WalkSpeed)
		end
	end

	function var0.Jump(arg0, arg1, arg2)
		arg0:Action({
			arg1
		}, function()
			arg2()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_STEP_MONOPOLY)
		end, arg0.jumpSpeed)
	end

	function var0.UpdatePos(arg0, arg1)
		arg0.preCellTF = arg1

		local var0 = arg1:GetGenPos()

		arg0._tf.localPosition = var0
	end

	function var0.UpdateScale(arg0, arg1)
		local var0 = 1

		arg0.preCellTF = arg0.preCellTF or arg1

		if arg1.cell.row > arg0.preCellTF.cell.row or arg1.cell.column > arg0.preCellTF.cell.column then
			var0 = 1
		elseif arg1.cell.row < arg0.preCellTF.cell.row or arg1.cell.column < arg0.preCellTF.cell.column then
			var0 = -1
		end

		arg0._tf.localScale = Vector3(var0, 1, 1)
	end

	function var0.ChangeAction(arg0, arg1, arg2)
		arg0.SpineAnimUI:SetActionCallBack(nil)
		arg0.SpineAnimUI:SetAction(arg1, 0)
		arg0.SpineAnimUI:SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				arg0.SpineAnimUI:SetActionCallBack(nil)
				arg2()
			end
		end)
	end

	function var0.Dispose(arg0)
		arg0.SpineAnimUI:SetActionCallBack(nil)

		arg0.char.onMove = nil

		if arg0.timer then
			arg0.timer:Stop()

			arg0.timer = nil
		end
	end

	return var0
end

function var0.SetUp(arg0, arg1, arg2)
	arg0.viewComponent = arg1

	local var0 = arg0.viewComponent._tf

	pg.DelegateInfo.New(arg0)

	arg0._tf = var0
	arg0._go = go(var0)
	arg0.models = {}

	parallelAsync({
		function(arg0)
			local var0 = Ship.New({
				configId = var3,
				skin_id = var4
			})
			local var1 = var0:getPrefab()

			PoolMgr.GetInstance():GetSpineChar(var1, true, function(arg0)
				arg0.models[var0.configId] = arg0

				arg0()
			end)
		end,
		function(arg0)
			onNextTick(arg0)
		end
	}, function()
		arg0:setActivity(arg2)
		arg0:init()
		arg0:didEnter()
	end)
end

function var0.setActivity(arg0, arg1)
	arg0.activity = arg1

	local var0 = arg0.activity.data1
	local var1 = arg0.activity.data1_list[1]

	arg0.useCount = arg0.activity.data1_list[2]

	local var2 = arg0.activity.data1_list[3] - 1
	local var3 = arg0.activity.data2_list[1]
	local var4 = arg0.activity.data2_list[2]
	local var5 = pg.TimeMgr.GetInstance():GetServerTime()
	local var6 = math.ceil((var5 - var0) / 86400) * arg0.activity:getDataConfig("daily_time")

	arg0.pos = arg0.activity.data2
	arg0.step = arg0.activity.data3
	arg0.effectId = arg0.activity.data4
	arg0.totalCnt = var6 + var1
	arg0.leftCount = arg0.totalCnt - arg0.useCount

	local var7 = arg1:getDataConfig("reward_time")

	arg0.nextredPacketStep = var7 - arg0.useCount % var7
	arg0.advanceTotalCnt = #arg1:getDataConfig("reward")
	arg0.isAdvanceRp = arg0.advanceTotalCnt - var4 > 0
	arg0.leftAwardCnt = var3 - var4
	arg0.advanceRpCount = math.max(0, math.min(var3, arg0.advanceTotalCnt) - var4)
	arg0.commonRpCount = math.max(0, var3 - arg0.advanceTotalCnt) - math.max(0, var4 - arg0.advanceTotalCnt)
	arg0.leftDropShipCnt = 10 - var2
end

function var0.NetActivity(arg0, arg1)
	arg0:setActivity(arg1)
	arg0:updateLeftCount()
	arg0:updateNextRedPacketStep()
end

function var0.init(arg0)
	arg0:blockAllEvent(false)

	arg0.bg = arg0:findTF("AD")
	arg0.mapCellTpl = arg0:getTpl("mapCell", arg0.bg)
	arg0.mapContainer = arg0:findTF("mapContainer", arg0.bg)
	arg0.charTpl = arg0:getTpl("char", arg0.bg)
	arg0.startBtn = arg0:findTF("start", arg0.bg)
	arg0.valueImg = arg0:findTF("value", arg0.bg):GetComponent(typeof(Image))
	arg0.leftcountLabel = arg0:findTF("leftcount", arg0.bg):GetComponent(typeof(Text))
	arg0.leftCountTF = arg0:findTF("leftcount/Text", arg0.bg):GetComponent(typeof(Text))
	arg0.nextRedPacketStepTF = arg0:findTF("nextRpStep/Text", arg0.bg):GetComponent(typeof(Text))
	arg0.commonRp = arg0:findTF("rp", arg0.bg)
	arg0.commonAnim = arg0.commonRp:GetComponent(typeof(Animator))
	arg0.commonRpCnt = arg0:findTF("rp_text/Text", arg0.bg):GetComponent(typeof(Text))
	arg0.dropShipTxt = arg0:findTF("AD/drop_ship_text"):GetComponent(typeof(Text))
	arg0.helpBtn = arg0:findTF("AD/help")
	arg0.anim = arg0:findTF("AD/anim")

	setActive(arg0.anim, false)

	arg0.leftcountLabel.text = i18n("monopoly_left_count")
	arg0.advanceTag = arg0:findTF("AD/rp/sp")
	arg0.advanceLabel = arg0:findTF("AD/rp_text/sp")
	arg0.advancecLabel = arg0:findTF("AD/rp_text/label")
	arg0.advanceImage = arg0:findTF("AD/rp_text/sp_img")
	arg0.advanceTxt = arg0:findTF("AD/rp_text/sp_img/Text"):GetComponent(typeof(Text))
end

function var0.updateNextRedPacketStep(arg0)
	arg0.nextRedPacketStepTF.text = arg0.nextredPacketStep
end

function var0.updateLeftCount(arg0)
	arg0.leftCountTF.text = arg0.leftCount

	arg0.commonAnim:SetInteger("count", arg0.leftAwardCnt)

	arg0.commonRpCnt.text = arg0.commonRpCount
end

function var0.updateValue(arg0, arg1)
	if arg1 ~= 0 then
		arg0.valueImg.sprite = GetSpriteFromAtlas("ui/activityuipage/monopoly_atlas", arg1)

		arg0.valueImg:SetNativeSize()
	end

	setActive(go(arg0.valueImg), arg1 ~= 0)
end

function var0.didEnter(arg0)
	setActive(arg0.startBtn, arg0.leftCount > 0)
	arg0:updateLeftCount()
	arg0:updateValue(0)
	arg0:updateNextRedPacketStep()

	local var0 = arg0.activity:getDataConfig("map")

	arg0.mapVO = var13(var0, arg0.pos)

	arg0:createMap(arg0.mapVO)
	arg0.mapVO:Init()
	arg0:checkState()
	onButton(arg0, arg0.startBtn, function()
		if arg0.block then
			return
		end

		if arg0.leftCount <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end

		arg0:startAction()
	end, SFX_PANEL)
	onButton(arg0, arg0.commonRp, function()
		if arg0.leftAwardCnt > 0 then
			arg0:emit(MonopolyPage.ON_AWARD)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_chunjie_monopoly.tip
		})
	end, SFX_PANEL)
end

function var0.blockAllEvent(arg0, arg1)
	arg0:emit(ActivityMainScene.LOCK_ACT_MAIN, arg1)

	arg0.block = arg1
end

function var0.triggerEvent(arg0, arg1, arg2, arg3)
	local var0 = arg0.mapVO:GetCell(arg1):GetEvent(arg2)

	local function var1(arg0, arg1)
		if arg0 and arg0:ExistStory() then
			pg.NewStoryMgr.GetInstance():Play(arg0.config.story, arg1, true, true)
		else
			arg1()
		end
	end

	local var2 = {
		function(arg0)
			var1(var0, arg0)
		end,
		function(arg0)
			local var0

			local function var1()
				if not var0 or var0:isEmpty() then
					arg0()

					return
				end

				arg0:emit(MonopolyPage.ON_TRIGGER, arg0.activity.id, function(arg0, arg1)
					if not arg0 or #arg0 == 0 then
						arg0()

						return
					end

					arg0.mapVO:UpdateCharPos(arg0, function()
						local var0 = arg0[#arg0]

						var0 = arg0.mapVO:GetCell(var0):GetEvent(arg1)

						var1(var0, var1)
					end, true)
				end)
			end

			var1()
		end
	}

	seriesAsync(var2, arg3)
end

function var0.checkState(arg0)
	local var0 = {}

	arg0:blockAllEvent(true)

	local var1 = arg0:getStrory()

	if var1 then
		table.insert(var0, function(arg0)
			pg.NewStoryMgr.GetInstance():Play(var1, arg0)
		end)
	end

	if arg0.effectId ~= 0 then
		table.insert(var0, function(arg0)
			local var0 = arg0.mapVO:GetPos()

			arg0:triggerEvent(var0, arg0.effectId, arg0)
		end)
	end

	if arg0.step ~= 0 then
		table.insert(var0, function(arg0)
			arg0:emit(MonopolyPage.ON_MOVE, arg0.activity.id, function(arg0, arg1, arg2)
				if not arg1 or #arg1 == 0 then
					arg0()

					return
				end

				arg0.mapVO:UpdateCharPos(arg1, function()
					local var0 = arg1[#arg1]

					arg0:triggerEvent(var0, arg2, arg0)
				end)
			end)
		end)
	end

	seriesAsync(var0, function()
		arg0:blockAllEvent(false)
	end)
end

function var0.startAction(arg0)
	local var0 = arg0.activity.id
	local var1 = 0

	local function var2(arg0)
		if var1 == 0 then
			arg0()

			return
		end

		arg0:emit(MonopolyPage.ON_MOVE, var0, function(arg0, arg1, arg2)
			if not arg1 or #arg1 == 0 then
				arg0()

				return
			end

			var1 = arg0

			arg0.mapVO:UpdateCharPos(arg1, function()
				local var0 = arg1[#arg1]

				arg0:triggerEvent(var0, arg2, arg0)
			end)
		end)
	end

	seriesAsync({
		function(arg0)
			setActive(arg0.startBtn, false)
			arg0:blockAllEvent(true)
			arg0:playerAnim(arg0)
		end,
		function(arg0)
			arg0:emit(MonopolyPage.ON_START, var0, function(arg0)
				var1 = arg0

				arg0:updateValue(arg0)
				arg0()
			end)
		end,
		function(arg0)
			var2(arg0)
		end,
		function(arg0)
			var2(arg0)
		end,
		function(arg0)
			local var0 = arg0:getStrory()

			if not var0 then
				arg0()

				return
			end

			pg.NewStoryMgr.GetInstance():Play(var0, arg0)
		end
	}, function()
		arg0:updateValue(0)
		arg0:blockAllEvent(false)
		setActive(arg0.startBtn, arg0.leftCount > 0)
	end)
end

function var0.getStrory(arg0)
	local var0 = arg0.useCount
	local var1 = arg0.activity:getDataConfig("story") or {}
	local var2 = _.detect(var1, function(arg0)
		return arg0[1] == var0
	end)

	if var2 then
		return var2[2]
	end

	return nil
end

function var0.createMap(arg0, arg1)
	arg0.cellTFs, arg0.charCard = {}

	function arg1.onCreateCell(arg0)
		local var0 = cloneTplTo(arg0.mapCellTpl, arg0.mapContainer)
		local var1 = var14(var0, arg0)

		var1:UpdateStyle()

		arg0.cellTFs[arg0.index] = var1
	end

	function arg1.onCreateChar(arg0)
		local var0 = cloneTplTo(arg0.charTpl, arg0.mapContainer)
		local var1 = arg0.models[arg0.ship.configId]

		setParent(var1, var0)

		arg0.charCard = var15(var0, arg0)

		function arg0.onMove(arg0, arg1)
			local var0 = _.map(arg0, function(arg0)
				return arg0.cellTFs[arg0.index]
			end)

			arg0.charCard:Move(var0, arg1)
		end

		function arg0.onUpdatePos(arg0)
			local var0 = arg0.cellTFs[arg0.index]

			arg0.charCard:UpdatePos(var0)
		end

		function arg0.state.onActionUpdated(arg0, arg1)
			arg0.charCard:ChangeAction(arg0, arg1)
		end

		function arg0.onJump(arg0, arg1)
			local var0 = arg0.cellTFs[arg0.index]

			arg0.charCard:Jump(var0, arg1)
		end
	end
end

function var0.playerAnim(arg0, arg1)
	setActive(arg0.anim, true)

	if arg0.timer then
		arg0.timer:Stop()
	end

	arg0.timer = Timer.New(function()
		arg1()
		setActive(arg0.anim, false)
	end, 1.5, 1)

	arg0.timer:Start()
end

function var0.findTF(arg0, arg1, arg2)
	assert(arg0._tf, "transform should exist")

	return findTF(arg2 or arg0._tf, arg1)
end

function var0.getTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF(arg1, arg2)

	var0:SetParent(arg0._tf, false)
	SetActive(var0, false)

	return var0
end

function var0.Destroy(arg0)
	for iter0, iter1 in pairs(arg0.cellTFs) do
		iter1:Dispose()
	end

	arg0.charCard:Dispose()
	arg0.mapVO:Dispose()

	arg0.cellTFs = nil
	arg0.charCard = nil
	arg0.mapVO = nil

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	pg.DelegateInfo.Dispose(arg0)
end

function var0.emit(arg0, arg1, arg2, arg3)
	arg0.viewComponent:emit(arg1, arg2, arg3)
end

return var0
