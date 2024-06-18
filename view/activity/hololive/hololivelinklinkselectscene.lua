local var0_0 = class("HoloLiveLinkLinkSelectScene", import("view.base.BaseUI"))

var0_0.HOLOLIVE_LINKGAME_HUB_ID = 3
var0_0.HOLOLIVE_LINKGAME_ID = 7

function var0_0.getUIName(arg0_1)
	return "HoloLiveLinkGameSelectUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:initUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:updateProgressBar()
	arg0_3:updateAwardPanel()
	arg0_3:updateEntranceList()
end

function var0_0.willExit(arg0_4)
	return
end

function var0_0.initData(arg0_5)
	arg0_5.lightPointTFList = {}
	arg0_5.lightLineTFList = {}
	arg0_5.entranceTFList = {}

	arg0_5:updateData()
end

function var0_0.findUI(arg0_6)
	arg0_6.forNotchPanel = arg0_6:findTF("ForNotchPanel")
	arg0_6.backBtn = arg0_6:findTF("BackBtn", arg0_6.forNotchPanel)
	arg0_6.helpBtn = arg0_6:findTF("HelpBtn", arg0_6.forNotchPanel)
	arg0_6.awardMask = arg0_6:findTF("AwardImg/Mask", arg0_6.forNotchPanel)
	arg0_6.progressText = arg0_6:findTF("AwardImg/ProgressText", arg0_6.forNotchPanel)
	arg0_6.getAwardBtn = arg0_6:findTF("AwardImg/GetBtn", arg0_6.forNotchPanel)
	arg0_6.gotAwardBtn = arg0_6:findTF("AwardImg/GotBtn", arg0_6.forNotchPanel)
	arg0_6.progressPanel = arg0_6:findTF("Progress", arg0_6.forNotchPanel)
	arg0_6.lightPointContainer = arg0_6:findTF("Light", arg0_6.progressPanel)
	arg0_6.lightLineContainer = arg0_6:findTF("LightLine", arg0_6.progressPanel)
	arg0_6.entranceContainer = arg0_6:findTF("EntranceContainer")
end

function var0_0.initUI(arg0_7)
	setActive(arg0_7.getAwardBtn, false)
	setActive(arg0_7.gotAwardBtn, false)
	eachChild(arg0_7.lightPointContainer, function(arg0_8)
		table.insert(arg0_7.lightPointTFList, 1, arg0_8)

		local var0_8 = arg0_7:findTF("Point", arg0_8)

		setActive(arg0_8, false)
		setActive(var0_8, false)
	end)
	eachChild(arg0_7.lightLineContainer, function(arg0_9)
		table.insert(arg0_7.lightLineTFList, 1, arg0_9)
		setActive(arg0_9, false)
	end)

	for iter0_7 = 0, 7 do
		local var0_7 = arg0_7.entranceContainer:GetChild(iter0_7)

		table.insert(arg0_7.entranceTFList, var0_7)

		local var1_7 = arg0_7:findTF("Mask", var0_7)
		local var2_7 = arg0_7:findTF("GotImg", var0_7)
		local var3_7 = arg0_7:findTF("LockText", var0_7)

		setActive(var1_7, true)
		setActive(var2_7, false)
		setActive(var3_7, true)
	end
end

function var0_0.addListener(arg0_10)
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:closeView()
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hololive_lianliankan.tip
		})
	end, SFX_PANEL)

	for iter0_10, iter1_10 in ipairs(arg0_10.entranceTFList) do
		local var0_10 = arg0_10:findTF("EntranceBtn", iter1_10)

		onButton(arg0_10, var0_10, function()
			arg0_10.linkGameData:SetRuntimeData("curLinkGameID", iter0_10)
			pg.m02:sendNotification(GAME.GO_MINI_GAME, var0_0.HOLOLIVE_LINKGAME_ID)
		end, SFX_PANEL)
	end
end

function var0_0.updateProgressBar(arg0_14)
	local var0_14 = arg0_14.linkGameHub.usedtime
	local var1_14 = math.min(var0_14, 7)

	if var1_14 > 0 then
		for iter0_14 = 1, var1_14 do
			local var2_14 = arg0_14.lightPointTFList[iter0_14]

			setActive(var2_14, true)
		end

		local var3_14 = arg0_14.lightPointTFList[var1_14]
		local var4_14 = arg0_14:findTF("Point", var3_14)

		setActive(var4_14, true)
	end

	if var1_14 > 1 then
		local var5_14 = var1_14 - 1

		for iter1_14 = 1, var5_14 do
			local var6_14 = arg0_14.lightLineTFList[iter1_14]

			setActive(var6_14, true)
		end
	end
end

function var0_0.updateAwardPanel(arg0_15)
	local var0_15 = arg0_15.linkGameHub.usedtime

	setText(arg0_15.progressText, var0_15 > 7 and 7 or var0_15)

	if arg0_15.linkGameHub.ultimate > 0 then
		setActive(arg0_15.getAwardBtn, false)
		setActive(arg0_15.gotAwardBtn, true)
		setActive(arg0_15.awardMask, true)
	elseif var0_15 >= arg0_15.linkGameHub:getConfig("reward_need") then
		setActive(arg0_15.getAwardBtn, true)
		setActive(arg0_15.gotAwardBtn, false)
		setActive(arg0_15.awardMask, true)
		onButton(arg0_15, arg0_15.getAwardBtn, function()
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = arg0_15.linkGameHub.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end, SFX_PANEL)
	else
		setActive(arg0_15.getAwardBtn, false)
		setActive(arg0_15.gotAwardBtn, false)
		setActive(arg0_15.awardMask, false)
	end
end

function var0_0.updateEntranceList(arg0_17)
	local var0_17 = arg0_17.linkGameHub.usedtime

	for iter0_17 = 1, 8 do
		local var1_17 = arg0_17.entranceTFList[iter0_17]
		local var2_17 = arg0_17:findTF("Mask", var1_17)
		local var3_17 = arg0_17:findTF("GotImg", var1_17)
		local var4_17 = arg0_17:findTF("LockText", var1_17)
		local var5_17 = arg0_17.linkGameData:GetConfigCsvLine(iter0_17).unlock_txt

		setText(var4_17, var5_17)

		if iter0_17 <= var0_17 then
			setActive(var2_17, false)
			setActive(var3_17, true)
			setActive(var4_17, false)
		elseif iter0_17 == var0_17 + 1 then
			local var6_17 = arg0_17.linkGameHub.count

			if var6_17 == 0 then
				setActive(var2_17, true)
				setActive(var3_17, false)
				setActive(var4_17, true)
			elseif var6_17 > 0 then
				setActive(var2_17, false)
				setActive(var3_17, false)
				setActive(var4_17, false)
			end
		elseif iter0_17 > var0_17 + 1 then
			setActive(var2_17, true)
			setActive(var3_17, false)
			setActive(var4_17, true)
		end
	end
end

function var0_0.updateData(arg0_18)
	arg0_18.miniGameProxy = getProxy(MiniGameProxy)
	arg0_18.linkGameHub = arg0_18.miniGameProxy:GetHubByHubId(var0_0.HOLOLIVE_LINKGAME_HUB_ID)
	arg0_18.linkGameData = arg0_18.miniGameProxy:GetMiniGameData(var0_0.HOLOLIVE_LINKGAME_ID)
end

function var0_0.updateUI(arg0_19)
	arg0_19:updateProgressBar()
	arg0_19:updateAwardPanel()
	arg0_19:updateEntranceList()
end

function var0_0.isTip()
	local var0_20 = getProxy(MiniGameProxy):GetHubByHubId(var0_0.HOLOLIVE_LINKGAME_HUB_ID)

	if var0_20.ultimate == 0 and var0_20.usedtime >= 7 then
		return true
	elseif var0_20.count > 0 then
		return true
	end
end

return var0_0
