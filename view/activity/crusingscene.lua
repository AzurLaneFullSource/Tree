local var0 = class("CrusingScene", import("view.base.BaseUI"))

var0.optionsPath = {
	"top/home"
}
var0.FrameSpeed = 10
var0.PlaySpeed = 1.5

function var0.getUIName(arg0)
	return "CrusingUI"
end

function var0.preload(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)
	local var1 = PoolMgr.GetInstance()
	local var2 = {}

	table.insert(var2, function(arg0)
		local var0 = CrusingMapInfo.VersionInfo[var0:getConfig("config_client").map_name]

		var1:GetPrefab("crusingmap/" .. var0, "", true, function(arg0)
			arg0.rtMap = tf(arg0)
			arg0.PhaseFrame, arg0.AllFrameCount = CrusingMapInfo.GetPhaseFrame(var0)

			arg0()
		end)
	end)
	table.insert(var2, function(arg0)
		var1:GetSpineChar(var0:getConfig("config_client").spine_name, true, function(arg0)
			arg0.rtModel = tf(arg0)

			arg0()
		end)
	end)
	parallelAsync(var2, function()
		setParent(arg0.rtModel, arg0.rtMap:Find("icon/model"))

		arg0.rtModel.localScale = Vector3.one

		arg1()
	end)
end

function var0.init(arg0)
	arg0.rtBg = arg0._tf:Find("bg")
	arg0.scrollMap = arg0.rtBg:Find("map_scroll")
	arg0.btnTask = arg0.rtBg:Find("task_btn")
	arg0.textTip = arg0.rtBg:Find("tip")
	arg0.rtAward = arg0._tf:Find("award_panel")
	arg0.textPhase = arg0.rtAward:Find("phase/Text")
	arg0.sliderPt = arg0.rtAward:Find("Slider")
	arg0.comScroll = GetComponent(arg0.rtAward:Find("view/content"), "LScrollRect")

	function arg0.comScroll.onUpdateItem(arg0, arg1)
		arg0:updateAwardInfo(tf(arg1), arg0.awardList[arg0 + 1])
	end

	arg0.rtNextAward = arg0.rtAward:Find("next")
	arg0.btnAll = arg0.rtAward:Find("btn_all")
	arg0.btnPay = arg0.rtAward:Find("btn_pay")
	arg0.btnAfter = arg0.rtAward:Find("btn_after")
	arg0.btnFinish = arg0.rtAward:Find("btn_finish")
	arg0.rtTop = arg0._tf:Find("top")
	arg0.btnBack = arg0.rtTop:Find("back")
	arg0.btnHelp = arg0.rtTop:Find("help")
	arg0.textDay = arg0.rtTop:Find("day/Text")
	arg0.chargeTipWindow = ChargeTipWindow.New(arg0._tf, arg0.event)
	arg0.LTDic = {}
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnTask, function()
		if arg0.phase < #arg0.awardList then
			arg0:emit(CrusingMediator.EVENT_OPEN_TASK)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("battlepass_complete"))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.btnAll, function()
		local var0 = arg0.activity:GetCrusingUnreceiveAward()

		if #var0 > 0 then
			local var1 = {}

			if arg0:checkLimitMax(var0) then
				table.insert(var1, function(arg0)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("player_expResource_mail_fullBag"),
						onYes = arg0
					})
				end)
			end

			seriesAsync(var1, function()
				arg0:emit(CrusingMediator.EVENT_GET_AWARD_ALL)
			end)
		end
	end, SFX_CONFIRM)
	onButton(arg0, arg0.btnPay, function()
		arg0:openBuyPanel()
	end, SFX_CONFIRM)
	onButton(arg0, arg0.btnAfter, function()
		local var0 = arg0.activity:GetCrusingUnreceiveAward()

		if #var0 > 0 then
			local var1 = {}

			if arg0:checkLimitMax(var0) then
				table.insert(var1, function(arg0)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("player_expResource_mail_fullBag"),
						onYes = arg0
					})
				end)
			end

			seriesAsync(var1, function()
				arg0:emit(CrusingMediator.EVENT_GET_AWARD_ALL)
			end)
		end
	end, SFX_CONFIRM)
	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n(arg0.activity:getConfig("config_client").tips[2])
		})
	end, SFX_PANEL)

	local function var0(arg0)
		local var0 = {
			_tf = arg0,
			rtLine = arg0:Find("line"),
			rtIcon = arg0:Find("icon"),
			rtSimple = arg0:Find("simple")
		}

		setParent(arg0, arg0.scrollMap)
		SetCompomentEnabled(arg0, typeof(Image), false)

		arg0.name = "map_tpl"

		SetAction(var0.rtIcon:Find("model"):GetChild(0), "normal")

		return var0
	end

	arg0.maps = {
		var0(arg0.rtMap)
	}

	while #arg0.maps < 3 do
		table.insert(arg0.maps, var0(tf(Instantiate(arg0.rtMap))))
	end

	Canvas.ForceUpdateCanvases()

	for iter0, iter1 in ipairs(arg0.maps) do
		setParent(iter1.rtLine, arg0.scrollMap:Find("bg"), true)
	end

	GetComponent(arg0.textTip, "RichText"):AddSprite("pt", GetSpriteFromAtlas(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg0.ptId
	}):getIcon(), ""))
	setText(arg0.textTip, i18n(arg0.activity:getConfig("config_client").tips[1]))

	local var1 = arg0.activity.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

	setText(arg0.textDay, i18n("battlepass_main_time", math.floor(var1 / 86400), math.floor(var1 % 86400 / 3600)))

	local var2 = GetComponent(arg0.scrollMap, typeof(ScrollRect))
	local var3 = var2.content.rect.width
	local var4 = var2.viewport.rect.width
	local var5 = var3 / 3 / (var3 - var4)

	onScroll(arg0, arg0.scrollMap, function(arg0)
		if arg0.x < 0.1 then
			local var0 = var2.velocity
			local var1 = var2.normalizedPosition

			var1.x = arg0.x + var5
			var2.normalizedPosition = var1
			var2.velocity = var0
		elseif arg0.x > 0.9 then
			local var2 = var2.velocity
			local var3 = var2.normalizedPosition

			var3.x = arg0.x - var5
			var2.normalizedPosition = var3
			var2.velocity = var2
		end
	end)
	arg0:onScroll(arg0.comScroll, function(arg0)
		arg0:updateNextAward(arg0.y)
	end)
	arg0:updateAwardPanel()
	arg0:buildPhaseAwardScrollPos()

	if arg0.phase == 0 then
		arg0.comScroll:ScrollTo(0)
	elseif arg0.phase == #arg0.awardList then
		arg0.comScroll:ScrollTo(1)
	else
		arg0.comScroll:ScrollTo(math.clamp(arg0.phasePos[arg0.phase], 0, 1))
	end

	arg0:updateMapStatus()
	LoadImageSpriteAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg0.ptId
	}):getIcon(), "", arg0.sliderPt:Find("Text/icon"), true)
	arg0:updateMapWay()
end

function var0.willExit(arg0)
	for iter0, iter1 in pairs(arg0.LTDic) do
		if iter1 then
			LeanTween.cancel(iter0)
		end
	end

	local var0 = PoolMgr.GetInstance()
	local var1 = CrusingMapInfo.VersionInfo[arg0.activity:getConfig("config_client").map_name]
	local var2 = arg0.activity:getConfig("config_client").spine_name

	for iter2, iter3 in ipairs(arg0.maps) do
		setParent(iter3.rtLine, iter3._tf, true)
		var0:ReturnSpineChar(var2, go(iter3.rtIcon:Find("model"):GetChild(0)))
		var0:ReturnPrefab("crusingmap/" .. var1, "", go(iter3._tf))
	end

	if arg0.chargeTipWindow then
		arg0.chargeTipWindow:Destroy()

		arg0.chargeTipWindow = nil
	end
end

function var0.setActivity(arg0, arg1)
	arg0.activity = arg1

	for iter0, iter1 in pairs(arg1:GetCrusingInfo()) do
		arg0[iter0] = iter1
	end
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.updateAwardInfo(arg0, arg1, arg2)
	local var0 = arg2.pt <= arg0.pt

	if arg1:Find("mask") then
		setActive(arg1:Find("mask"), not var0)
	end

	setText(arg1:Find("Text"), arg2.id)

	local var1 = Drop.Create(arg2.award)

	updateDrop(arg1:Find("award"), var1)
	setActive(arg1:Find("award/get"), var0 and not arg0.awardDic[arg2.pt])
	setActive(arg1:Find("award/got"), arg0.awardDic[arg2.pt])
	setActive(arg1:Find("award/mask"), arg0.awardDic[arg2.pt])
	onButton(arg0, arg1:Find("award"), function()
		arg0:emit(var0.ON_DROP, var1)
	end, SFX_CONFIRM)

	local var2 = Drop.Create(arg2.award_pay)

	updateDrop(arg1:Find("award_pay"), var2)
	setActive(arg1:Find("award_pay/lock"), not arg0.isPay)
	setActive(arg1:Find("award_pay/get"), arg0.isPay and var0 and not arg0.awardPayDic[arg2.pt])
	setActive(arg1:Find("award_pay/got"), arg0.awardPayDic[arg2.pt])
	setActive(arg1:Find("award_pay/mask"), not arg0.isPay or arg0.awardPayDic[arg2.pt])
	onButton(arg0, arg1:Find("award_pay"), function()
		arg0:emit(var0.ON_DROP, var2)
	end, SFX_CONFIRM)
end

function var0.updateAwardPanel(arg0)
	setText(arg0.textPhase, arg0.phase)

	if arg0.phase < #arg0.awardList then
		local var0 = arg0.phase == 0 and 0 or arg0.awardList[arg0.phase].pt
		local var1 = arg0.pt - var0
		local var2 = arg0.awardList[arg0.phase + 1].pt - var0

		setSlider(arg0.sliderPt, 0, var2, var1)
		setText(arg0.sliderPt:Find("Text"), var1 .. "/" .. var2)
	else
		setSlider(arg0.sliderPt, 0, 1, 1)
		setText(arg0.sliderPt:Find("Text"), "MAX")
	end

	arg0.nextAward = nil

	arg0.comScroll:SetTotalCount(#arg0.awardList - 1)
	arg0:updateNextAward(arg0.comScroll.value)

	local var3 = #arg0.activity:GetCrusingUnreceiveAward() > 0

	setActive(arg0.btnAll, not arg0.isPay and var3)
	setActive(arg0.btnPay, not arg0.isPay)
	setActive(arg0.rtAward:Find("text_image_3"), not arg0.isPay)
	setActive(arg0.btnFinish, arg0.isPay and arg0.phase == #arg0.awardList and not var3)
	setActive(arg0.btnAfter, arg0.isPay and not isActive(arg0.btnFinish))
	setButtonEnabled(arg0.btnAfter, var3)
end

function var0.updateMapStatus(arg0)
	for iter0, iter1 in ipairs(arg0.maps) do
		local var0
		local var1 = {}

		eachChild(iter1.rtLine, function(arg0)
			local var0 = tonumber(arg0.name)

			if var0 > arg0.phase then
				if not var0 then
					var0 = var0

					table.insert(var1, arg0)
					setActive(arg0, true)
				elseif var0 < var0 then
					while #var1 > 0 do
						setActive(table.remove(var1), false)
					end

					var0 = var0

					table.insert(var1, arg0)
					setActive(arg0, true)
				elseif var0 == var0 then
					table.insert(var1, arg0)
					setActive(arg0, true)
				else
					setActive(arg0, false)
				end
			else
				setActive(arg0, true)
			end

			local var1 = var0 > arg0.phase

			setGray(arg0, not var1, false)
			setImageAlpha(arg0, var1 and 1 or 0.9)

			if isActive(arg0) then
				local var2

				local function var3(arg0, arg1)
					local var0 = getImageSprite(arg0)

					if var0 then
						setImageSprite(arg1, var0)
					end

					eachChild(arg0, function(arg0)
						var3(arg0, arg1:Find(arg0.name))
					end)
				end

				local var4 = iter1.rtSimple:Find(var1 and "active" or "gray")

				eachChild(arg0, function(arg0)
					var3(var4:Find(arg0.name), arg0)
				end)
			end
		end)
	end
end

function var0.updateMapWay(arg0)
	if arg0.exited or arg0.contextData.frozenMapUpdate then
		return
	end

	local var0 = PlayerPrefs.GetInt(string.format("crusing_%d_phase_display", arg0.activity.id), 0)

	PlayerPrefs.SetInt(string.format("crusing_%d_phase_display", arg0.activity.id), arg0.phase)

	for iter0, iter1 in ipairs(arg0.maps) do
		local var1 = GetComponent(iter1.rtIcon, typeof(Animator))

		if var0 < arg0.phase then
			local var2 = arg0.PhaseFrame[var0]
			local var3 = arg0.PhaseFrame[arg0.phase]

			var1.speed = var0.PlaySpeed

			var1:Play("empty")
			var1:Play("mix", 0, var2 / arg0.AllFrameCount)

			if iter1.rtIcon:Find("model").childCount > 0 then
				SetAction(iter1.rtIcon:Find("model"):GetChild(0), "move")
			end

			local var4

			var4 = LeanTween.delayedCall((var3 - var2) / var0.FrameSpeed / var0.PlaySpeed, System.Action(function()
				var1.speed = 0

				var1:Play("empty")
				var1:Play("mix", 0, var3 / arg0.AllFrameCount)

				arg0.LTDic[var4] = false

				if iter1.rtIcon:Find("model").childCount > 0 then
					SetAction(iter1.rtIcon:Find("model"):GetChild(0), "normal")
				end
			end)).uniqueId
			arg0.LTDic[var4] = true
		else
			var1.speed = 0

			var1:Play("empty")
			var1:Play("mix", 0, arg0.PhaseFrame[arg0.phase] / arg0.AllFrameCount)
		end
	end
end

function var0.buildPhaseAwardScrollPos(arg0)
	arg0.phasePos = {}

	for iter0 = 1, #arg0.awardList - 1 do
		table.insert(arg0.phasePos, arg0.comScroll:HeadIndexToValue(iter0 - 1))
	end
end

function var0.onScroll(arg0, arg1, arg2)
	local var0 = arg1.onValueChanged

	assert(arg2, "callback should exist")
	var0:RemoveAllListeners()
	pg.DelegateInfo.Add(arg0, var0)
	var0:AddListener(arg2)
end

function var0.updateNextAward(arg0, arg1)
	if not arg0.phasePos then
		return
	end

	local var0 = arg0.phasePos[#arg0.phasePos] - 1
	local var1 = #arg0.awardList

	for iter0 = var1 - 1, 1, -1 do
		local var2 = arg0.awardList[iter0]

		if arg0.phasePos[iter0] < arg1 + var0 or var2.pt <= arg0.pt then
			break
		elseif var2.isImportent then
			var1 = iter0
		end
	end

	if arg0.nextAward ~= var1 then
		arg0.nextAward = var1

		arg0:updateAwardInfo(arg0.rtNextAward, arg0.awardList[var1])
	end
end

function var0.checkLimitMax(arg0, arg1)
	local var0 = arg0.player

	for iter0, iter1 in ipairs(arg1) do
		if iter1.type == DROP_TYPE_RESOURCE then
			if iter1.id == 1 then
				if var0:GoldMax(iter1.count) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))

					return true
				end
			elseif iter1.id == 2 and var0:OilMax(iter1.count) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title"))

				return true
			end
		elseif iter1.type == DROP_TYPE_ITEM then
			local var1 = Item.getConfigData(iter1.id)

			if var1.type == Item.EXP_BOOK_TYPE and getProxy(BagProxy):getItemCountById(iter1.id) + iter1.count > var1.max_num then
				return true
			end
		end
	end

	return false
end

function var0.openBuyPanel(arg0)
	local var0 = arg0:getPassID()
	local var1 = Goods.Create({
		shop_id = var0
	}, Goods.TYPE_CHARGE)
	local var2 = var1:getConfig("tag")
	local var3 = underscore.map(var1:getConfig("extra_service_item"), function(arg0)
		return Drop.Create(arg0)
	end)
	local var4
	local var5 = var1:getConfig("sub_display")
	local var6 = var5[1]
	local var7 = pg.battlepass_event_pt[var6].pt
	local var8 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = pg.battlepass_event_pt[var6].pt,
		count = var5[2]
	})
	local var9 = PlayerConst.MergePassItemDrop(underscore.map(pg.battlepass_event_pt[var6].drop_client_pay, function(arg0)
		return Drop.Create(arg0)
	end))
	local var10 = var1:getConfig("gem") + var1:getConfig("extra_gem")
	local var11

	if var10 > 0 then
		table.insert(var9, Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResDiamond,
			count = var10
		}))
	end

	local var12
	local var13
	local var14 = i18n("battlepass_pay_tip")
	local var15 = {
		isChargeType = true,
		icon = "chargeicon/" .. var1:getConfig("picture"),
		name = var1:getConfig("name_display"),
		tipExtra = var14,
		extraItems = var9,
		price = var1:getConfig("money"),
		isLocalPrice = var1:IsLocalPrice(),
		tagType = var2,
		isMonthCard = var1:isMonthCard(),
		tipBonus = var13,
		bonusItem = var11,
		extraDrop = var8,
		descExtra = var1:getConfig("descrip_extra"),
		onYes = function()
			if ChargeConst.isNeedSetBirth() then
				arg0:emit(ChargeMediator.OPEN_CHARGE_BIRTHDAY)
			else
				pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
					shopId = var1.id
				})
			end
		end
	}

	arg0:emit(CrusingMediator.EVENT_GO_CHARGE, var15)
end

function var0.getPassID(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0 and not var0:isEnd() then
		for iter0, iter1 in ipairs(pg.pay_data_display.all) do
			local var1 = pg.pay_data_display[iter1]

			if var1.sub_display and type(var1.sub_display) == "table" and var1.sub_display[1] == var0.id then
				return iter1
			end
		end
	end
end

function var0.OnChargeSuccess(arg0, arg1)
	arg0.chargeTipWindow:ExecuteAction("Show", arg1)
end

return var0
