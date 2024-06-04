local var0 = class("HoloLiveLinkLinkSelectScene", import("view.base.BaseUI"))

var0.HOLOLIVE_LINKGAME_HUB_ID = 3
var0.HOLOLIVE_LINKGAME_ID = 7

function var0.getUIName(arg0)
	return "HoloLiveLinkGameSelectUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:initUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:updateProgressBar()
	arg0:updateAwardPanel()
	arg0:updateEntranceList()
end

function var0.willExit(arg0)
	return
end

function var0.initData(arg0)
	arg0.lightPointTFList = {}
	arg0.lightLineTFList = {}
	arg0.entranceTFList = {}

	arg0:updateData()
end

function var0.findUI(arg0)
	arg0.forNotchPanel = arg0:findTF("ForNotchPanel")
	arg0.backBtn = arg0:findTF("BackBtn", arg0.forNotchPanel)
	arg0.helpBtn = arg0:findTF("HelpBtn", arg0.forNotchPanel)
	arg0.awardMask = arg0:findTF("AwardImg/Mask", arg0.forNotchPanel)
	arg0.progressText = arg0:findTF("AwardImg/ProgressText", arg0.forNotchPanel)
	arg0.getAwardBtn = arg0:findTF("AwardImg/GetBtn", arg0.forNotchPanel)
	arg0.gotAwardBtn = arg0:findTF("AwardImg/GotBtn", arg0.forNotchPanel)
	arg0.progressPanel = arg0:findTF("Progress", arg0.forNotchPanel)
	arg0.lightPointContainer = arg0:findTF("Light", arg0.progressPanel)
	arg0.lightLineContainer = arg0:findTF("LightLine", arg0.progressPanel)
	arg0.entranceContainer = arg0:findTF("EntranceContainer")
end

function var0.initUI(arg0)
	setActive(arg0.getAwardBtn, false)
	setActive(arg0.gotAwardBtn, false)
	eachChild(arg0.lightPointContainer, function(arg0)
		table.insert(arg0.lightPointTFList, 1, arg0)

		local var0 = arg0:findTF("Point", arg0)

		setActive(arg0, false)
		setActive(var0, false)
	end)
	eachChild(arg0.lightLineContainer, function(arg0)
		table.insert(arg0.lightLineTFList, 1, arg0)
		setActive(arg0, false)
	end)

	for iter0 = 0, 7 do
		local var0 = arg0.entranceContainer:GetChild(iter0)

		table.insert(arg0.entranceTFList, var0)

		local var1 = arg0:findTF("Mask", var0)
		local var2 = arg0:findTF("GotImg", var0)
		local var3 = arg0:findTF("LockText", var0)

		setActive(var1, true)
		setActive(var2, false)
		setActive(var3, true)
	end
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hololive_lianliankan.tip
		})
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.entranceTFList) do
		local var0 = arg0:findTF("EntranceBtn", iter1)

		onButton(arg0, var0, function()
			arg0.linkGameData:SetRuntimeData("curLinkGameID", iter0)
			pg.m02:sendNotification(GAME.GO_MINI_GAME, var0.HOLOLIVE_LINKGAME_ID)
		end, SFX_PANEL)
	end
end

function var0.updateProgressBar(arg0)
	local var0 = arg0.linkGameHub.usedtime
	local var1 = math.min(var0, 7)

	if var1 > 0 then
		for iter0 = 1, var1 do
			local var2 = arg0.lightPointTFList[iter0]

			setActive(var2, true)
		end

		local var3 = arg0.lightPointTFList[var1]
		local var4 = arg0:findTF("Point", var3)

		setActive(var4, true)
	end

	if var1 > 1 then
		local var5 = var1 - 1

		for iter1 = 1, var5 do
			local var6 = arg0.lightLineTFList[iter1]

			setActive(var6, true)
		end
	end
end

function var0.updateAwardPanel(arg0)
	local var0 = arg0.linkGameHub.usedtime

	setText(arg0.progressText, var0 > 7 and 7 or var0)

	if arg0.linkGameHub.ultimate > 0 then
		setActive(arg0.getAwardBtn, false)
		setActive(arg0.gotAwardBtn, true)
		setActive(arg0.awardMask, true)
	elseif var0 >= arg0.linkGameHub:getConfig("reward_need") then
		setActive(arg0.getAwardBtn, true)
		setActive(arg0.gotAwardBtn, false)
		setActive(arg0.awardMask, true)
		onButton(arg0, arg0.getAwardBtn, function()
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = arg0.linkGameHub.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end, SFX_PANEL)
	else
		setActive(arg0.getAwardBtn, false)
		setActive(arg0.gotAwardBtn, false)
		setActive(arg0.awardMask, false)
	end
end

function var0.updateEntranceList(arg0)
	local var0 = arg0.linkGameHub.usedtime

	for iter0 = 1, 8 do
		local var1 = arg0.entranceTFList[iter0]
		local var2 = arg0:findTF("Mask", var1)
		local var3 = arg0:findTF("GotImg", var1)
		local var4 = arg0:findTF("LockText", var1)
		local var5 = arg0.linkGameData:GetConfigCsvLine(iter0).unlock_txt

		setText(var4, var5)

		if iter0 <= var0 then
			setActive(var2, false)
			setActive(var3, true)
			setActive(var4, false)
		elseif iter0 == var0 + 1 then
			local var6 = arg0.linkGameHub.count

			if var6 == 0 then
				setActive(var2, true)
				setActive(var3, false)
				setActive(var4, true)
			elseif var6 > 0 then
				setActive(var2, false)
				setActive(var3, false)
				setActive(var4, false)
			end
		elseif iter0 > var0 + 1 then
			setActive(var2, true)
			setActive(var3, false)
			setActive(var4, true)
		end
	end
end

function var0.updateData(arg0)
	arg0.miniGameProxy = getProxy(MiniGameProxy)
	arg0.linkGameHub = arg0.miniGameProxy:GetHubByHubId(var0.HOLOLIVE_LINKGAME_HUB_ID)
	arg0.linkGameData = arg0.miniGameProxy:GetMiniGameData(var0.HOLOLIVE_LINKGAME_ID)
end

function var0.updateUI(arg0)
	arg0:updateProgressBar()
	arg0:updateAwardPanel()
	arg0:updateEntranceList()
end

function var0.isTip()
	local var0 = getProxy(MiniGameProxy):GetHubByHubId(var0.HOLOLIVE_LINKGAME_HUB_ID)

	if var0.ultimate == 0 and var0.usedtime >= 7 then
		return true
	elseif var0.count > 0 then
		return true
	end
end

return var0
