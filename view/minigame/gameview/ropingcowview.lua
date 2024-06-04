local var0 = class("IdolMasterView", import("..BaseMiniGameView"))
local var1 = "backyard"
local var2 = "event:/ui/ddldaoshu2"
local var3 = "event:/ui/sou"
local var4 = "event:/ui/xueqiu"
local var5 = 60
local var6 = 100
local var7 = 10
local var8 = {
	{
		20,
		3
	},
	{
		40,
		4
	},
	{
		60,
		5
	},
	{
		10000,
		5
	}
}
local var9 = {
	{
		10700031,
		10700030
	},
	{
		10700041,
		10700040
	},
	{
		10700051,
		10700050
	},
	{
		10700061,
		10700060
	},
	{
		10700071,
		10700070
	}
}
local var10 = {
	{
		10700011,
		10700010
	},
	{
		10700021,
		10700020
	}
}
local var11 = "EVENT_SEND_GIFT"
local var12 = "EVENT_FANS_ACTION"
local var13 = {
	1,
	2,
	3,
	4,
	5,
	6
}
local var14 = {
	1,
	2
}
local var15 = {
	3,
	4,
	5,
	6
}
local var16 = 3
local var17 = "dafuweng_event"
local var18 = "stand2"
local var19 = "normal"
local var20 = "work"
local var21 = "wrong"
local var22 = "end1"
local var23 = "end2"
local var24 = "gift"
local var25 = "normal"
local var26 = "walk"
local var27 = 3
local var28 = "type_fans_fail"
local var29 = "type_fans_success"
local var30 = 4
local var31 = {
	Vector3(160, 160),
	Vector3(160, -30),
	Vector3(160, -210),
	Vector3(160, -400)
}
local var32 = 350

local function var33(arg0, arg1, arg2)
	local var0 = {
		Ctor = function(arg0)
			arg0._giftTf = arg0
			arg0._event = arg2
			arg0._workerTf = arg1

			local var0 = "jiu-work"

			PoolMgr.GetInstance():GetSpineChar(var0, true, function(arg0)
				arg0.transform.localScale = Vector3.one
				arg0.transform.localPosition = Vector3.zero

				arg0.transform:SetParent(arg0._workerTf, false)

				local var0 = arg0:GetComponent(typeof(SpineAnimUI))

				arg0.wokerSpine = {
					model = arg0.model,
					anim = var0,
					name = var0
				}

				arg0:changeWorkerAction(var19, 0, nil)
			end)

			arg0.selectedGifts = {}
			arg0.gifts = {}
			arg0.delegateGifts = {}

			for iter0 = 1, #var13 do
				local var1 = iter0
				local var2 = findTF(arg0._giftTf, var13[iter0])

				table.insert(arg0.gifts, {
					tf = var2,
					index = iter0
				})

				local var3 = GetOrAddComponent(var2, "EventTriggerListener")

				var3:AddPointDownFunc(function(arg0, arg1)
					arg0:selectGift(var1)
				end)
				table.insert(arg0.delegateGifts, var3)
			end

			arg0:updateSelected()
		end,
		changeWorkerAction = function(arg0, arg1, arg2, arg3)
			arg0.wokerSpine.anim:SetActionCallBack(nil)
			arg0.wokerSpine.anim:SetAction(arg1, 0)
			arg0.wokerSpine.anim:SetActionCallBack(function(arg0)
				if arg0 == "finish" then
					if arg2 == 1 then
						arg0.wokerSpine.anim:SetActionCallBack(nil)
						arg0.wokerSpine.anim:SetAction(var19, 0)
					end

					if arg3 then
						arg3()
					end
				end
			end)

			if arg2 ~= 1 and arg3 then
				arg3()
			end
		end,
		selectGift = function(arg0, arg1)
			if table.contains(var14, arg1) then
				for iter0 = #arg0.selectedGifts, 1, -1 do
					local var0 = arg0.selectedGifts[iter0]

					if table.contains(var14, var0) and var0 ~= arg1 then
						table.remove(arg0.selectedGifts, iter0)
					end
				end
			elseif #arg0.selectedGifts == 2 and not table.contains(arg0.selectedGifts, arg1) then
				local var1 = false

				for iter1 = 1, #arg0.selectedGifts do
					if table.contains(var14, arg0.selectedGifts[iter1]) then
						var1 = true

						break
					end
				end

				if not var1 then
					table.remove(arg0.selectedGifts, 1)
				end
			end

			local var2 = 0

			for iter2 = 1, #arg0.selectedGifts do
				if arg0.selectedGifts[iter2] == arg1 then
					var2 = iter2
				end
			end

			if var2 == 0 then
				table.insert(arg0.selectedGifts, arg1)
				arg0:moveJiujiu(arg1)
				arg0:changeWorkerAction(var20, 1)
			else
				table.remove(arg0.selectedGifts, var2)
			end

			if #arg0.selectedGifts >= var16 then
				arg0._event:emit(var11, Clone(arg0.selectedGifts), function(arg0)
					if not arg0 then
						arg0:changeWorkerAction(var21, 1)
					end
				end)

				arg0.selectedGifts = {}

				arg0:moveJiujiu(-1)
			end

			arg0:updateSelected()
		end,
		start = function(arg0)
			arg0.selectedGifts = {}

			arg0:updateSelected()
		end,
		updateSelected = function(arg0)
			for iter0 = 1, #arg0.gifts do
				local var0 = arg0.gifts[iter0].index

				if table.contains(arg0.selectedGifts, var0) then
					setActive(findTF(arg0.gifts[iter0].tf, "selected"), true)
				else
					setActive(findTF(arg0.gifts[iter0].tf, "selected"), false)
				end
			end
		end,
		moveJiujiu = function(arg0, arg1)
			if arg1 == -1 then
				arg0._workerTf.anchoredPosition = Vector3.New(-290, 30, 0)
				arg0._workerTf.localScale = Vector3.New(-1, 1, 1)
			else
				local var0 = arg0.gifts[arg1].tf
				local var1 = arg0._workerTf.parent:InverseTransformPoint(var0.position)

				var1.x = var1.x + 150
				var1.y = var1.y - 50
				arg0._workerTf.anchoredPosition = var1
				arg0._workerTf.localScale = Vector3.New(1, 1, 1)
			end
		end,
		destroy = function(arg0)
			if arg0.delegateGifts and #arg0.delegateGifts > 0 then
				for iter0 = 1, #arg0.delegateGifts do
					ClearEventTrigger(arg0.delegateGifts[iter0])
				end

				arg0.delegateGifts = {}
			end

			PoolMgr.GetInstance():ReturnSpineChar(arg0.wokerSpine.name, arg0.wokerSpine.model)
		end
	}

	var0:Ctor()

	return var0
end

local function var34(arg0, arg1, arg2, arg3)
	local var0 = {
		Ctor = function(arg0)
			arg0._groupTf = arg1
			arg0._groupIndex = arg2
			arg0._groupTf.anchoredPosition = var31[arg2]
			arg0._event = arg3
			arg0.modelData = {}

			SetActive(arg0._groupTf, true)
			arg0:createIdol(arg0[1], arg0[2])

			arg0.fans = {}
			arg0.wantedData = {}
		end,
		createIdol = function(arg0, arg1, arg2)
			local var0 = Ship.New({
				configId = arg1,
				skin_id = arg2
			}):getPrefab()

			PoolMgr.GetInstance():GetSpineChar(var0, true, function(arg0)
				arg0.transform.localScale = Vector3.one
				arg0.transform.localPosition = Vector3.zero

				arg0.transform:SetParent(findTF(arg0._groupTf, "idolPos"), false)

				local var0 = arg0:GetComponent(typeof(SpineAnimUI))

				arg0.modelData = {
					model = arg0.model,
					id = arg1,
					skinId = arg2,
					anim = var0
				}

				arg0:changeCharAction(var18, 0, nil)
			end)
		end,
		changeCharAction = function(arg0, arg1, arg2, arg3)
			if arg0.modelData.actionName == arg1 then
				return
			end

			arg0.modelData.actionName = arg1

			arg0.modelData.anim:SetActionCallBack(nil)
			arg0.modelData.anim:SetAction(arg1, 0)
			arg0.modelData.anim:SetActionCallBack(function(arg0)
				if arg0 == "finish" then
					if arg2 == 1 then
						arg0.modelData.anim:SetActionCallBack(nil)
						arg0.modelData.anim:SetAction(var18, 0)
					end

					if arg3 then
						arg3()
					end
				end
			end)

			if arg2 ~= 1 and arg3 then
				arg3()
			end
		end,
		createFans = function(arg0, arg1)
			SetActive(arg1, true)
			SetParent(arg1, findTF(arg0._groupTf, "fansPos"))

			if #arg0.fans > 0 then
				local var0 = arg0.fans[#arg0.fans].tf.anchoredPosition

				var0.x = var0.x + var32 + math.random() * 200 + 150
				arg1.anchoredPosition = Vector3.New(var0.x, var0.y, var0.z)
			else
				arg1.anchoredPosition = Vector3.New((#arg0.fans + 1) * var32 + 200, 0, 0)
			end

			table.insert(arg0.fans, {
				tf = arg1,
				speed = math.random() + 2.5
			})

			local var1 = arg0.fans[#arg0.fans]
			local var2 = "jiu-fan" .. math.random(1, 4)

			PoolMgr.GetInstance():GetSpineChar(var2, true, function(arg0)
				arg0.transform.localScale = Vector3.one
				arg0.transform.localPosition = Vector3.zero

				arg0.transform:SetParent(findTF(var1.tf, "spinePos"), false)

				local var0 = arg0:GetComponent(typeof(SpineAnimUI))

				var1.modelData = {
					model = arg0,
					anim = var0,
					modelName = var2
				}
			end)
		end,
		changeFansAction = function(arg0, arg1, arg2, arg3, arg4)
			if not arg1.modelData or arg1.modelData.actionName == arg2 then
				return
			end

			arg1.modelData.actionName = arg2

			arg1.modelData.anim:SetActionCallBack(nil)
			arg1.modelData.anim:SetAction(arg2, 0)
			arg1.modelData.anim:SetActionCallBack(function(arg0)
				if arg0 == "finish" then
					if arg3 == 1 then
						arg1.modelData.anim:SetActionCallBack(nil)
						arg1.modelData.anim:SetAction(var25, 0)
					end

					if arg4 then
						arg4()
					end
				end
			end)

			if arg3 ~= 1 and arg4 then
				arg4()
			end
		end,
		getWantedGifts = function(arg0)
			if #arg0.fans > 0 and arg0.fans[1].gifts and not arg0.fans[1].leave then
				return arg0.fans[1].gifts
			end

			return nil
		end,
		clearFans = function(arg0)
			for iter0 = 1, #arg0.fans do
				PoolMgr.GetInstance():ReturnSpineChar(arg0.fans[iter0].modelData.modelName, arg0.fans[iter0].modelData.model)
				Destroy(arg0.fans[iter0].tf)
			end

			arg0.fans = {}
		end,
		start = function(arg0)
			return
		end,
		step = function(arg0, arg1)
			arg0.stepTime = arg1

			for iter0 = #arg0.fans, 1, -1 do
				local var0 = arg0.fans[iter0]
				local var1 = var0.tf
				local var2 = var0.tf.anchoredPosition

				if var2.x > (iter0 - 1) * var32 then
					var2.x = var2.x - var0.speed
					var0.tf.anchoredPosition = var2

					arg0:changeFansAction(var0, var26, 0, nil)
				elseif iter0 == 1 and not var0.leave then
					if var0.gifts == nil then
						var0.gifts = arg0:createWantedGifts()
						var0.time = arg1 + var7

						local var3 = LoadSprite("ui/minigameui/idolmasterui_atlas", "pack" .. var0.gifts[1])

						setImageSprite(findTF(var0.tf, "score/pack"), var3)
						arg0:changeFansAction(var0, var24, 0, nil)
					end
				elseif not var0.leave then
					arg0:changeFansAction(var0, var25, 0, nil)
				end
			end

			if #arg0.fans > 0 then
				local var4 = arg0.fans[1]

				if var4.time and arg1 > var4.time and not var4.leave then
					var4.leave = true

					arg0:fanLeave(var4, var28, function()
						table.remove(arg0.fans, 1)
					end)
				else
					arg0:showFansWanted(var4)
				end

				var4.tf:SetSiblingIndex(#arg0.fans - 1)
			end
		end,
		showFansWanted = function(arg0, arg1)
			if arg1.leave then
				return
			end

			local var0 = arg1.time

			if not var0 then
				return
			end

			local var1 = math.ceil(var0 - arg0.stepTime) < 0 and 0 or var0 - arg0.stepTime
			local var2 = arg1.gifts
			local var3 = var1 <= 5

			setActive(findTF(arg1.tf, "wanted"), true)
			setActive(findTF(arg1.tf, "wanted/bg1"), not var3)
			setActive(findTF(arg1.tf, "wanted/bgTime1"), not var3)
			setActive(findTF(arg1.tf, "wanted/time1"), not var3)
			setActive(findTF(arg1.tf, "wanted/bg2"), var3)
			setActive(findTF(arg1.tf, "wanted/bgTime2"), var3)
			setActive(findTF(arg1.tf, "wanted/time1"), var3)

			if var1 < 0 then
				var1 = 0
			end

			setText(findTF(arg1.tf, "wanted/time1"), math.abs(math.ceil(var1)) .. "S")
			setText(findTF(arg1.tf, "wanted/time2"), math.abs(math.ceil(var1)) .. "S")

			for iter0 = 1, #var2 do
				local var4 = LoadSprite("ui/minigameui/idolmasterui_atlas", "wantItem" .. var2[iter0])

				setImageSprite(findTF(arg1.tf, "wanted/item" .. iter0), var4)
			end
		end,
		checkGifts = function(arg0, arg1)
			local var0 = arg0:getWantedGifts()

			if var0 then
				for iter0 = 1, #arg1 do
					if not table.contains(var0, arg1[iter0]) then
						return false
					end
				end

				local var1 = arg0.fans[1]

				var1.leave = true

				arg0:fanLeave(var1, var29, function()
					table.remove(arg0.fans, 1)
				end)

				return true
			end

			return false
		end,
		createWantedGifts = function(arg0)
			local var0 = Clone(var15)
			local var1 = {}

			table.insert(var1, var14[math.random(1, #var14)])

			for iter0 = 1, 2 do
				local var2 = table.remove(var0, math.random(1, #var0))

				table.insert(var1, var2)
			end

			return var1
		end,
		fanLeave = function(arg0, arg1, arg2, arg3)
			setActive(findTF(arg1.tf, "wanted"), false)

			local var0

			if var28 == arg2 then
				var0 = var23
			elseif var29 then
				var0 = var22

				setText(findTF(arg1.tf, "score"), "+" .. var6)
				setActive(findTF(arg1.tf, "score"), true)
			end

			arg0:changeFansAction(arg1, var0, 1, function()
				PoolMgr.GetInstance():ReturnSpineChar(arg1.modelData.modelName, arg1.modelData.model)
				arg0._event:emit(var12, arg2)
				Destroy(arg1.tf)
				arg3()
			end)
		end,
		reset = function(arg0)
			arg0:clearFans()

			arg0.wantedData = {}
		end,
		destroy = function(arg0)
			if arg0.modelData then
				PoolMgr.GetInstance():ReturnSpineChar(arg0.modelData.id, arg0.modelData.model)
			end
		end
	}

	var0:Ctor()

	return var0
end

local function var35(arg0, arg1, arg2, arg3, arg4)
	local var0 = {
		Ctor = function(arg0)
			arg0._containerTf = arg0
			arg0._tplGroup = arg1
			arg0._tplIdol = arg2
			arg0._tplFans = arg3
			arg0._event = arg4
			arg0.groups = {}

			local var0 = arg0:getRandomIdols()

			for iter0 = 1, var30 do
				local var1 = tf(Instantiate(arg0._tplGroup))

				SetParent(var1, arg0._containerTf)

				local var2 = var34(var0[iter0], var1, iter0, arg0._event)

				table.insert(arg0.groups, var2)
			end
		end,
		receiveGift = function(arg0, arg1, arg2)
			local var0 = false

			for iter0 = 1, #arg0.groups do
				if arg0.groups[iter0]:checkGifts(arg1) then
					var0 = true

					break
				end
			end

			if arg2 then
				arg2(var0)
			end
		end,
		getRandomIdols = function(arg0)
			local var0 = {}
			local var1 = Clone(var9)

			for iter0 = 1, var30 do
				local var2 = false

				if iter0 == var30 then
					var2 = true

					for iter1, iter2 in ipairs(var10) do
						if table.contains(var0, iter2) then
							var2 = false
						end
					end
				end

				if var2 then
					table.insert(var0, var10[math.random(1, #var10)])
				else
					table.insert(var0, table.remove(var1, math.random(1, #var1)))
				end
			end

			return var0
		end,
		getApearTime = function(arg0)
			if arg0.runTime and arg0.runTime > 0 then
				for iter0 = 1, #var8 do
					if arg0.runTime < var8[iter0][1] then
						return var8[iter0][2]
					end
				end
			end

			return var8[#var8][2]
		end,
		start = function(arg0)
			arg0:reset()

			arg0.createFansTime = nil
			arg0.lastTime = var5

			for iter0 = 1, 3 do
				local var0 = math.random(1, #arg0.groups)

				arg0.groups[var0]:createFans(tf(instantiate(arg0._tplFans)))
			end

			for iter1 = 1, #arg0.groups do
				arg0.groups[iter1]:start()
			end
		end,
		step = function(arg0, arg1)
			arg0.lastTime = arg0.lastTime - Time.deltaTime

			local var0 = arg0:getApearTime()

			if not arg0.createFansTime then
				arg0.createFansTime = arg1 + var0 + math.random() * 1
			elseif arg1 > arg0.createFansTime then
				local var1 = math.random(1, #arg0.groups)

				arg0.groups[var1]:createFans(tf(instantiate(arg0._tplFans)))

				arg0.createFansTime = arg1 + var0 + math.random() * 1
			end

			for iter0 = 1, #arg0.groups do
				arg0.groups[iter0]:step(arg1)
			end
		end,
		reset = function(arg0)
			for iter0 = 1, #arg0.groups do
				arg0.groups[iter0]:reset()
			end
		end,
		destroy = function(arg0)
			for iter0 = 1, #arg0.groups do
				arg0.groups[iter0]:destroy()
			end
		end
	}

	var0:Ctor()

	return var0
end

function var0.getUIName(arg0)
	return "IdolMasterGameUI"
end

function var0.getBGM(arg0)
	return var1
end

function var0.didEnter(arg0)
	arg0:initEvent()
	arg0:initData()
	arg0:initUI()
	arg0:initGameUI()
	arg0:updateMenuUI()
	arg0:openMenuUI()
end

function var0.initEvent(arg0)
	arg0:bind(var11, function(arg0, arg1, arg2)
		if arg0.idolGroupUI then
			arg0.idolGroupUI:receiveGift(arg1, arg2)
		end
	end)
	arg0:bind(var12, function(arg0, arg1, arg2)
		if arg0.gameStartFlag then
			if arg1 == var28 then
				arg0:loseHeart()
			elseif arg1 == var29 then
				arg0:addScore(100)
			end
		end
	end)
end

function var0.initData(arg0)
	local var0 = Application.targetFrameRate or 60

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 1 / var0, -1)
end

function var0.initUI(arg0)
	arg0.sceneTf = findTF(arg0._tf, "scene")
	arg0.clickMask = findTF(arg0._tf, "clickMask")
	arg0.countUI = findTF(arg0._tf, "pop/CountUI")
	arg0.countAnimator = GetComponent(findTF(arg0.countUI, "count"), typeof(Animator))
	arg0.countDft = GetComponent(findTF(arg0.countUI, "count"), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		setActive(arg0.countUI, false)
		arg0:gameStart()
	end)

	arg0.leaveUI = findTF(arg0._tf, "pop/LeaveUI")

	onButton(arg0, findTF(arg0.leaveUI, "ad/btnOk"), function()
		arg0:resumeGame()
		arg0:onGameOver()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.leaveUI, "ad/btnCancel"), function()
		arg0:resumeGame()
	end, SFX_CANCEL)

	arg0.pauseUI = findTF(arg0._tf, "pop/pauseUI")

	onButton(arg0, findTF(arg0.pauseUI, "ad/btnOk"), function()
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()
	end, SFX_CANCEL)

	arg0.settlementUI = findTF(arg0._tf, "pop/SettleMentUI")

	onButton(arg0, findTF(arg0.settlementUI, "ad/btnOver"), function()
		setActive(arg0.settlementUI, false)
		arg0:openMenuUI()
	end, SFX_CANCEL)

	arg0.menuUI = findTF(arg0._tf, "pop/menuUI")
	arg0.battleScrollRect = GetComponent(findTF(arg0.menuUI, "battList"), typeof(ScrollRect))
	arg0.totalTimes = arg0:getGameTotalTime()

	local var0 = arg0:getGameUsedTimes() - 4 < 0 and 0 or arg0:getGameUsedTimes() - 4

	scrollTo(arg0.battleScrollRect, 0, 1 - var0 / (arg0.totalTimes - 4))
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowUp"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y + 1 / (arg0.totalTimes - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "rightPanelBg/arrowDown"), function()
		local var0 = arg0.battleScrollRect.normalizedPosition.y - 1 / (arg0.totalTimes - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.battleScrollRect, 0, var0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnBack"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.cowboy_tips.tip
		})
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.menuUI, "btnStart"), function()
		setActive(arg0.menuUI, false)
		arg0:readyStart()
	end, SFX_CANCEL)

	local var1 = findTF(arg0.menuUI, "tplBattleItem")

	arg0.battleItems = {}

	for iter0 = 1, arg0.totalTimes do
		local var2 = tf(instantiate(var1))

		var2.name = "battleItem_" .. iter0

		setParent(var2, findTF(arg0.menuUI, "battList/Viewport/Content"))

		local var3 = iter0

		GetSpriteFromAtlasAsync("ui/minigameui/idolmasterui_atlas", "tx_" .. var3, function(arg0)
			setImageSprite(findTF(var2, "state_open/icon"), arg0, true)
			setImageSprite(findTF(var2, "state_clear/icon"), arg0, true)
			setImageSprite(findTF(var2, "state_current/icon"), arg0, true)
		end)
		GetSpriteFromAtlasAsync("ui/minigameui/idolmasterui_atlas", "battleDesc" .. var3, function(arg0)
			setImageSprite(findTF(var2, "state_open/buttomDesc"), arg0, true)
			setImageSprite(findTF(var2, "state_clear/buttomDesc"), arg0, true)
			setImageSprite(findTF(var2, "state_current/buttomDesc"), arg0, true)
			setImageSprite(findTF(var2, "state_closed/buttomDesc"), arg0, true)
		end)
		setActive(var2, true)
		table.insert(arg0.battleItems, var2)
	end

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.initGameUI(arg0)
	arg0.gameUI = findTF(arg0._tf, "ui/gameUI")
	arg0.textScore = findTF(arg0.gameUI, "top/score")

	onButton(arg0, findTF(arg0.gameUI, "topRight/btnStop"), function()
		arg0:stopGame()
		setActive(arg0.pauseUI, true)
	end)
	onButton(arg0, findTF(arg0.gameUI, "btnLeave"), function()
		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end)

	arg0.gameTimeM = findTF(arg0.gameUI, "topRight/time/m")
	arg0.gameTimeS = findTF(arg0.gameUI, "topRight/time/s")
	arg0.heartTfs = {}

	for iter0 = 1, var27 do
		table.insert(arg0.heartTfs, findTF(arg0.gameUI, "top/heart" .. iter0 .. "/full"))
	end

	arg0.scoreTf = findTF(arg0.gameUI, "top/score")
	arg0.giftUI = var33(findTF(arg0._tf, "scene/gift"), findTF(arg0._tf, "scene/jiujiuWorker"), arg0)

	local var0 = findTF(arg0._tf, "scene/group")
	local var1 = findTF(arg0._tf, "scene/IdolContainer")
	local var2 = findTF(arg0._tf, "scene/Idol")
	local var3 = findTF(arg0._tf, "scene/fans")

	arg0.idolGroupUI = var35(var1, var0, var2, var3, arg0)
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0.updateMenuUI(arg0)
	local var0 = arg0:getGameUsedTimes()
	local var1 = arg0:getGameTimes()

	for iter0 = 1, #arg0.battleItems do
		setActive(findTF(arg0.battleItems[iter0], "state_open"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_closed"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_clear"), false)
		setActive(findTF(arg0.battleItems[iter0], "state_current"), false)

		if iter0 <= var0 then
			setActive(findTF(arg0.battleItems[iter0], "state_clear"), true)
		elseif iter0 == var0 + 1 and var1 >= 1 then
			setActive(findTF(arg0.battleItems[iter0], "state_current"), true)
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			setActive(findTF(arg0.battleItems[iter0], "state_open"), true)
		else
			setActive(findTF(arg0.battleItems[iter0], "state_closed"), true)
		end
	end

	arg0.totalTimes = arg0:getGameTotalTime()

	local var2 = 1 - (arg0:getGameUsedTimes() - 3 < 0 and 0 or arg0:getGameUsedTimes() - 3) / (arg0.totalTimes - 4)

	if var2 > 1 then
		var2 = 1
	end

	scrollTo(arg0.battleScrollRect, 0, var2)
	setActive(findTF(arg0.menuUI, "btnStart/tip"), var1 > 0)
	arg0:CheckGet()
end

function var0.CheckGet(arg0)
	setActive(findTF(arg0.menuUI, "got"), false)

	if arg0:getUltimate() and arg0:getUltimate() ~= 0 then
		setActive(findTF(arg0.menuUI, "got"), true)
	end

	if arg0:getUltimate() == 0 then
		if arg0:getGameTotalTime() > arg0:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(arg0.menuUI, "got"), true)
	end
end

function var0.openMenuUI(arg0)
	setActive(findTF(arg0._tf, "scene_front"), false)
	setActive(findTF(arg0._tf, "scene_background"), false)
	setActive(findTF(arg0._tf, "scene"), false)
	setActive(arg0.gameUI, false)
	setActive(arg0.menuUI, true)
	arg0:updateMenuUI()
end

function var0.clearUI(arg0)
	setActive(arg0.sceneTf, false)
	setActive(arg0.settlementUI, false)
	setActive(arg0.countUI, false)
	setActive(arg0.menuUI, false)
	setActive(arg0.gameUI, false)
end

function var0.readyStart(arg0)
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2)
end

function var0.gameStart(arg0)
	setActive(findTF(arg0._tf, "scene_front"), true)
	setActive(findTF(arg0._tf, "scene_background"), true)
	setActive(findTF(arg0._tf, "scene"), true)
	setActive(arg0.gameUI, true)

	arg0.gameStartFlag = true
	arg0.scoreNum = 0
	arg0.playerPosIndex = 2
	arg0.gameStepTime = 0
	arg0.heart = var27
	arg0.gameTime = var5

	arg0.idolGroupUI:start()
	arg0.giftUI:start()
	arg0:updateGameUI()
	arg0:timerStart()
end

function var0.getGameTimes(arg0)
	return arg0:GetMGHubData().count
end

function var0.getGameUsedTimes(arg0)
	return arg0:GetMGHubData().usedtime
end

function var0.getUltimate(arg0)
	return arg0:GetMGHubData().ultimate
end

function var0.getGameTotalTime(arg0)
	return (arg0:GetMGHubData():getConfig("reward_need"))
end

function var0.changeSpeed(arg0, arg1)
	return
end

function var0.onTimer(arg0)
	arg0:gameStep()
end

function var0.gameStep(arg0)
	arg0.gameTime = arg0.gameTime - Time.deltaTime

	if arg0.gameTime < 0 then
		arg0.gameTime = 0
	end

	arg0.gameStepTime = arg0.gameStepTime + Time.deltaTime

	if arg0.idolGroupUI then
		arg0.idolGroupUI:step(arg0.gameStepTime)
	end

	arg0:updateGameUI()

	if arg0.gameTime <= 0 then
		arg0:onGameOver()

		return
	end
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.updateGameUI(arg0)
	setText(arg0.textScore, arg0.scoreNum)

	local var0 = math.floor(math.ceil(arg0.gameTime) / 60)

	if var0 < 10 then
		var0 = "0" .. var0
	end

	local var1 = math.floor(math.ceil(arg0.gameTime) % 60)

	if var1 < 10 then
		var1 = "0" .. var1
	end

	for iter0 = 1, #arg0.heartTfs do
		if iter0 <= arg0.heart then
			setActive(arg0.heartTfs[iter0], true)
		else
			setActive(arg0.heartTfs[iter0], false)
		end
	end

	setText(arg0.scoreTf, arg0.scoreNum)
	setText(arg0.gameTimeM, var0)
	setText(arg0.gameTimeS, var1)
end

function var0.loseHeart(arg0)
	if arg0.heart <= 0 then
		return
	end

	arg0.heart = arg0.heart - 1

	arg0:updateGameUI()

	if arg0.heart <= 0 then
		arg0.heart = 0

		arg0:onGameOver()
	end
end

function var0.addScore(arg0, arg1)
	arg0.scoreNum = arg0.scoreNum + arg1

	if arg0.scoreNum < 0 then
		arg0.scoreNum = 0
	end
end

function var0.onGameOver(arg0)
	if arg0.settlementFlag then
		return
	end

	arg0:timerStop()

	arg0.settlementFlag = true

	setActive(arg0.clickMask, true)
	LeanTween.delayedCall(go(arg0._tf), 2, System.Action(function()
		arg0.settlementFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
		arg0:showSettlement()
	end))
end

function var0.showSettlement(arg0)
	setActive(arg0.settlementUI, true)
	GetComponent(findTF(arg0.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = arg0.scoreNum
	local var2 = var0 and #var0 > 0 and var0[1] or 0

	setActive(findTF(arg0.settlementUI, "ad/new"), var2 < var1)

	if var2 <= var1 then
		var2 = var1

		arg0:StoreDataToServer({
			var2
		})
	end

	local var3 = findTF(arg0.settlementUI, "ad/highText")
	local var4 = findTF(arg0.settlementUI, "ad/currentText")

	setText(var3, var2)
	setText(var4, var1)

	if arg0:getGameTimes() and arg0:getGameTimes() > 0 then
		arg0.sendSuccessFlag = true

		arg0:SendSuccess(0)
	end
end

function var0.resumeGame(arg0)
	arg0.gameStop = false

	setActive(arg0.leaveUI, false)
	arg0:changeSpeed(1)
	arg0:timerStart()
end

function var0.stopGame(arg0)
	arg0.gameStop = true

	arg0:timerStop()
	arg0:changeSpeed(0)
end

function var0.onBackPressed(arg0)
	if not arg0.gameStartFlag then
		arg0:emit(var0.ON_BACK_PRESSED)
	else
		if arg0.settlementFlag then
			return
		end

		if isActive(arg0.pauseUI) then
			setActive(arg0.pauseUI, false)
		end

		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	if arg0._tf and LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	Time.timeScale = 1
	arg0.timer = nil
end

return var0
