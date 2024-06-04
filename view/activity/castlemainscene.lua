local var0 = class("CastleMainScene", import("..base.BaseUI"))

var0.optionsPath = {
	"main/top/btn_home"
}

local var1 = "name"
local var2 = "default_value"
local var3 = "random_value"

var0.ACT_ID = ActivityConst.CASTLE_ACT_ID
var0.AWARD_ACT_ID = ActivityConst.CASTLE_AWARD_ID
var0.SKILL_COLOR = {
	"#546190",
	"#835490",
	"#A57D55",
	"#C15348"
}
var0.BAD_FILL_COLOR = Color(0.658823529411765, 0.501960784313725, 0.482352941176471, 0.5)
var0.NORMAL_FILL_COLOR = Color(1, 1, 1, 0.5)
var0.TRANSPARENT_COLOR = Color(1, 1, 1, 0)
var0.MARK_CURRENT = "1"
var0.MARK_UNEXPLORED = "2"
var0.MARK_BAD = "3"
var0.MARK_EXPLORABLE = "4"
var0.MAP_POS = {
	1,
	2,
	3,
	3,
	4,
	5,
	5,
	6,
	7,
	7,
	8,
	9,
	9,
	10,
	11,
	11,
	12,
	13,
	13,
	14,
	15,
	15,
	17,
	16
}
var0.ROOM_NUM = 17
var0.WALK_SE = "event:/ui/castle_walk"
var0.ROLL_SE = "event:/ui/caslte_roll"
var0.CARD_SE = "event:/ui/huihua1"

function var0.getUIName(arg0)
	return "CastleMainUI"
end

function var0.init(arg0)
	arg0:InitData()
	arg0:InitTF()
	arg0:InitAward()
	arg0:InitCharacter()
	arg0:InitDice()
	arg0:InitVX()
end

function var0.InitTF(arg0)
	arg0.main = arg0:findTF("main")
	arg0.map = arg0:findTF("map", arg0.main)
	arg0.floors = {
		arg0:findTF("floor1", arg0.map),
		arg0:findTF("floor2", arg0.map)
	}
	arg0.rooms = {
		arg0:findTF("rooms", arg0.floors[1]),
		arg0:findTF("rooms", arg0.floors[2])
	}
	arg0.top = arg0:findTF("top", arg0.main)
	arg0.buttonBack = arg0:findTF("btn_back", arg0.top)
	arg0.buttonHelp = arg0:findTF("btn_help", arg0.top)
	arg0.buttonAward = arg0:findTF("btn_award", arg0.top)
	arg0.buttonCharacter = arg0:findTF("btn_character", arg0.top)
	arg0.buttonDice = arg0:findTF("btn_dice", arg0.top)
	arg0.diceRes = arg0:findTF("dice_res", arg0.buttonDice)
	arg0.button1F = arg0:findTF("btn_1F", arg0.top)
	arg0.button2F = arg0:findTF("btn_2F", arg0.top)
	arg0.window = arg0:findTF("window")
end

function var0.InitData(arg0)
	arg0.storyMgr = pg.NewStoryMgr.GetInstance()
	arg0.activity = getProxy(ActivityProxy):getActivityById(var0.ACT_ID)
	arg0.story2Map = {}
	arg0.map2Story = {}
	arg0.storyGroup = {}

	for iter0, iter1 in ipairs(arg0.activity:getConfig("config_data")[3]) do
		table.insert(arg0.storyGroup, iter1[1][1])
		table.insert(arg0.storyGroup, iter1[2][2])
		table.insert(arg0.storyGroup, iter1[2][1])
	end

	for iter2 = 1, var0.ROOM_NUM do
		table.insert(arg0.map2Story, {})
	end

	for iter3 = 1, #arg0.storyGroup do
		table.insert(arg0.story2Map, arg0.storyGroup[iter3], var0.MAP_POS[iter3])
		table.insert(arg0.map2Story[var0.MAP_POS[iter3]], arg0.storyGroup[iter3])
	end

	arg0.explorableStories = {}
	arg0.exploredStories = {}

	if arg0.activity.data1 ~= nil and arg0.activity.data1 ~= 0 then
		for iter4 = 1, #arg0.storyGroup do
			table.insert(arg0:IsPlayed(arg0.storyGroup[iter4]) and arg0.exploredStories or arg0.explorableStories, arg0.storyGroup[iter4])

			if arg0.storyGroup[iter4] == arg0.activity.data1 then
				break
			end
		end
	end

	arg0.explorablePos = arg0.activity.data1
	arg0.currentPos = #arg0.exploredStories == 0 and 0 or arg0.exploredStories[#arg0.exploredStories]
end

function var0.InitAward(arg0)
	arg0.awardWindow = arg0:findTF("award_window", arg0.window)
	arg0.buttonAwardGet = arg0:findTF("award_bg/btn_get", arg0.awardWindow)
	arg0.awardWindowBg = arg0:findTF("bg", arg0.awardWindow)
	arg0.awardItem = arg0:findTF("award_bg/mask/item", arg0.awardWindow)
	arg0.awardItems = arg0:findTF("award_bg/mask/content", arg0.awardWindow)
	arg0.awardActivity = getProxy(ActivityProxy):getActivityById(var0.AWARD_ACT_ID)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskGroup = arg0.awardActivity:getConfig("config_data")
	arg0.taskList = UIItemList.New(arg0.awardItems, arg0.awardItem)
	arg0.taskMap = {}

	for iter0 = 1, #arg0.taskGroup do
		table.insert(arg0.taskMap, iter0)
	end
end

function var0.InitDice(arg0)
	arg0.diceWindow = arg0:findTF("dice_window", arg0.window)
	arg0.buttonDiceContinue = arg0:findTF("btn_continue", arg0.diceWindow)
	arg0.dice = arg0:findTF("dice", arg0.diceWindow)
	arg0.dices = {
		arg0:findTF("dice1", arg0.dice),
		arg0:findTF("dice2", arg0.dice)
	}
	arg0.result = arg0:findTF("result", arg0.diceWindow)
	arg0.success = arg0:findTF("success", arg0.result)
	arg0.criticalSuccess = arg0:findTF("critical_success", arg0.result)
	arg0.failure = arg0:findTF("failure", arg0.result)
	arg0.criticalFailure = arg0:findTF("critical_failure", arg0.result)
end

function var0.InitCharacter(arg0)
	arg0.characterWindow = arg0:findTF("character_window", arg0.window)
	arg0.characterWindowBg = arg0:findTF("bg", arg0.characterWindow)
	arg0.characterCard = arg0:findTF("character_card", arg0.characterWindowBg)
	arg0.characterName = arg0:findTF("title_base/name", arg0.characterCard)
	arg0.profession = arg0:findTF("title_base/profession", arg0.characterCard)
	arg0.nameInput = arg0:findTF("InputField", arg0.characterName)
	arg0.attrGroup = arg0:findTF("title_attr/attrGroup", arg0.characterCard)
	arg0.skillGroup = arg0:findTF("title_skill/skillGroup", arg0.characterCard)
	arg0.characterTip = arg0:findTF("tip", arg0.characterCard)

	setText(arg0.characterTip, i18n("roll_unlock"))

	arg0.buttonRandom = arg0:findTF("random", arg0.characterCard)
	arg0.randomLock = arg0:findTF("lock", arg0.buttonRandom)
	arg0.randomText = arg0:findTF("Image", arg0.buttonRandom)

	setText(arg0:findTF("title_base", arg0.characterCard), i18n("roll_card_info"))
	setText(arg0:findTF("title_attr", arg0.characterCard), i18n("roll_card_attr"))
	setText(arg0:findTF("title_skill", arg0.characterCard), i18n("roll_card_skill"))

	local var0 = arg0.activity:getConfig("config_client")[2]

	arg0.story2Attr = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(arg0.story2Attr, iter1[1], iter1[2])
	end

	arg0.attrLock = {}
end

function var0.InitVX(arg0)
	for iter0, iter1 in ipairs({
		"success",
		"Csuccess",
		"failure",
		"Cfailure"
	}) do
		local var0 = arg0.result:GetChild(iter0 - 1)
		local var1 = findTF(var0, iter1)
		local var2 = findTF(var0, "VX/glow")

		setLocalScale(var2, {
			x = var1.rect.width,
			y = var1.rect.height
		})
	end
end

function var0.didEnter(arg0)
	for iter0 = 1, var0.ROOM_NUM do
		local var0 = arg0:GetRoomTF(iter0)
		local var1 = findTF(var0, "name")

		setText(var1, i18n("roll_room_unexplored"))

		local var2 = findTF(var0, "explorable")

		setImageRaycastTarget(findTF(var0, "fill"), true)
		onButton(arg0, var0, function()
			for iter0, iter1 in ipairs(arg0.map2Story[iter0]) do
				if table.contains(arg0.explorableStories, iter1) then
					arg0:PlayStory(iter1)

					break
				end
			end
		end, SFX_PANEL)
	end

	if table.contains(arg0.explorableStories, arg0.storyGroup[15]) or table.contains(arg0.exploredStories, arg0.storyGroup[15]) then
		local var3

		for iter1 = #arg0.exploredStories, 1, -1 do
			if not arg0:IsBadEnd(arg0.exploredStories[iter1]) then
				var3 = arg0.exploredStories[iter1]

				break
			end
		end

		local var4 = var3 and arg0.story2Map[var3] or 0
		local var5 = var4 > 10 and var4 < 17

		setActive(arg0.floors[1], not var5)
		setActive(arg0.floors[2], var5)
		setActive(arg0.button1F, not var5)
		setActive(arg0.button2F, var5)
	else
		setActive(arg0.button1F, false)
		setActive(arg0.button2F, false)
	end

	arg0.taskList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateTask(arg1, arg2)
		end
	end)
	arg0.nameInput:GetComponent(typeof(InputField)).onValueChanged:AddListener(function()
		if not nameValidityCheck(getInputText(arg0.nameInput), 0, 40, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"ship_renameShip_error_2011",
			"playerinfo_mask_word"
		}) then
			setInputText(arg0.nameInput, getProxy(PlayerProxy):getData().name)
		end
	end)
	arg0:InitButton()
	arg0:UpdateFlush()

	local var6 = arg0.activity:getConfig("config_data")[1]

	if var6 and not arg0:IsPlayed(var6) then
		arg0:emit(CastleMainMediator.CASTLE_ACT_OP, {
			cmd = 3,
			id = var0.ACT_ID,
			arg1 = var6
		})
	else
		arg0:CheckGuide()
	end
end

function var0.InitButton(arg0)
	onButton(arg0, arg0.button1F, function()
		setActive(arg0.button1F, false)
		setActive(arg0.button2F, true)
		setActive(arg0.floors[2], true)
		setActive(arg0.floors[1], false)
	end, var0.WALK_SE)
	onButton(arg0, arg0.button2F, function()
		setActive(arg0.button2F, false)
		setActive(arg0.button1F, true)
		setActive(arg0.floors[1], true)
		setActive(arg0.floors[2], false)
	end, var0.WALK_SE)
	onButton(arg0, arg0.buttonBack, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.buttonHelp, function()
		local var0 = i18n("roll_gametip")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.buttonAward, function()
		setActive(arg0.awardWindow, true)
		arg0:CheckAwardGet()
		arg0:ExplorableEffect(false)
	end, SFX_PANEL)
	onButton(arg0, arg0.buttonAwardGet, function()
		local var0 = underscore(arg0.taskGroup):chain():map(function(arg0)
			return arg0.taskProxy:getTaskVO(arg0)
		end):filter(function(arg0)
			return arg0:getTaskStatus() == 1
		end):value()

		if #var0 > 0 then
			arg0:emit(CastleMainMediator.ON_TASK_SUBMIT, var0)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.awardWindowBg, function()
		setActive(arg0.awardWindow, false)
		arg0:ExplorableEffect(true)
	end, SFX_CANCEL)
	onButton(arg0, arg0.buttonCharacter, function()
		arg0:UpdateCard()
		setActive(arg0.characterWindow, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0.characterCard)
	end, SFX_PANEL)
	onButton(arg0, arg0.characterWindowBg, function()
		setActive(arg0.characterWindow, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.characterCard, arg0.characterWindowBg)
		arg0:UpdateFlush()
		arg0:CheckGuide()
	end, SFX_CANCEL)
	onButton(arg0, arg0.buttonRandom, function()
		if arg0:IsFinish() then
			if #getInputText(arg0.nameInput) == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("roll_noname"))
			else
				arg0:RollCharacterCard()
			end
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.buttonDice, function()
		if arg0.diceCount < 1 then
			if table.contains(arg0.explorableStories, arg0.storyGroup[23]) or table.contains(arg0.explorableStories, arg0.storyGroup[24]) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("roll_ending_tip1"))
			elseif table.contains(arg0.exploredStories, arg0.storyGroup[23]) and table.contains(arg0.exploredStories, arg0.storyGroup[24]) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("roll_ending_tip2"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("roll_notimes"))
			end

			return
		end

		if arg0:IndexofStory(arg0.explorablePos) > arg0:IndexofStory(arg0.currentPos) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("roll_tip2"))

			return
		end

		arg0:emit(CastleMainMediator.CASTLE_ACT_OP, {
			cmd = 1,
			id = var0.ACT_ID
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.buttonDiceContinue, function()
		setActive(arg0.diceWindow, false)
		arg0:UpdateFlush()
		arg0:CheckGuide()
		arg0:ExplorableEffect(true)
	end, SFX_PANEL)
end

function var0.UpdateFlush(arg0)
	arg0.activity = getProxy(ActivityProxy):getActivityById(var0.ACT_ID)
	arg0.awardActivity = getProxy(ActivityProxy):getActivityById(var0.AWARD_ACT_ID)
	arg0.taskGroup = arg0.awardActivity:getConfig("config_data")

	arg0:UpdateDice()
	arg0:UpdateMap()
	arg0:UpdateAward()
	arg0:UpdateCharacter()

	if arg0:IndexofStory(arg0.explorablePos) == 15 and arg0:IndexofStory(arg0.explorablePos) > arg0:IndexofStory(arg0.currentPos) then
		setActive(arg0.button1F, true)
	end

	setActive(arg0.buttonDice, not arg0:IsFinish())
end

function var0.UpdateDice(arg0)
	arg0.diceCount = arg0.activity.data2

	if table.contains(arg0.explorableStories, arg0.explorablePos) and arg0:IsBadEnd(arg0.explorablePos) then
		arg0.diceCount = arg0.diceCount - 1
	end

	setText(arg0.diceRes, i18n("roll_times_left", arg0.diceCount))

	if arg0.explorablePos == arg0.currentPos and arg0.diceCount > 0 then
		arg0.buttonDice:GetComponent(typeof(Animation)):Play("anim_castle_dice_tiploop")
	else
		arg0.buttonDice:GetComponent(typeof(Animation)):Stop()
	end
end

function var0.UpdateMap(arg0)
	for iter0 = 1, var0.ROOM_NUM do
		arg0:ChangeRoomColor(iter0, var0.TRANSPARENT_COLOR)
		arg0:ChangeRoomMark(iter0, nil)
	end

	for iter1, iter2 in ipairs(arg0.exploredStories) do
		local var0 = arg0.story2Map[iter2]
		local var1 = arg0:GetRoomTF(var0)

		setText(findTF(var1, "name"), i18n("roll_room" .. var0))
	end

	setActive(findTF(arg0.main, "finish_mask"), false)

	if arg0:IsFinish() then
		setActive(findTF(arg0.main, "finish_mask"), true)

		return
	end

	for iter3, iter4 in ipairs(arg0.exploredStories) do
		local var2 = arg0.story2Map[iter4]

		if arg0:IsBadEnd(iter4) then
			if var2 ~= 17 then
				if var2 ~= 4 then
					arg0:ChangeRoomColor(var2, var0.BAD_FILL_COLOR)
				end

				arg0:ChangeRoomMark(var2, var0.MARK_BAD)
			end
		else
			arg0:ChangeRoomColor(var2, var0.NORMAL_FILL_COLOR)
		end
	end

	for iter5, iter6 in ipairs(arg0.explorableStories) do
		local var3 = arg0.story2Map[iter6]

		arg0:ChangeRoomMark(var3, var0.MARK_EXPLORABLE)
		arg0:ChangeRoomMark(var3, var0.MARK_UNEXPLORED, true)
	end

	if #arg0.exploredStories > 0 then
		local var4

		for iter7, iter8 in ipairs(arg0.storyGroup) do
			if not arg0:IsBadEnd(iter8) and table.contains(arg0.exploredStories, iter8) then
				var4 = iter8
			end
		end

		arg0:ChangeRoomMark(arg0.story2Map[var4], var0.MARK_CURRENT, true)
	end

	setActive(arg0.button1F:Find("Image"), table.contains(arg0.explorableStories, arg0.storyGroup[24]))
	setActive(arg0.button2F:Find("Image"), table.contains(arg0.explorableStories, arg0.storyGroup[23]))
end

function var0.UpdateAward(arg0)
	arg0:CheckAwardGet()
	table.sort(arg0.taskMap, function(arg0, arg1)
		local var0 = arg0.taskProxy:getTaskVO(arg0.taskGroup[arg0]):getTaskStatus() == 2 and 1 or 0
		local var1 = arg0.taskProxy:getTaskVO(arg0.taskGroup[arg1]):getTaskStatus() == 2 and 1 or 0

		if var0 == var1 then
			return arg0 < arg1
		end

		return var0 < var1
	end)
	arg0.taskList:align(#arg0.taskGroup)

	local var0 = arg0.storyMgr:StoryId2StoryName(arg0.activity:getConfig("config_client")[1][3])

	if not arg0:IsPlayed(var0) and getProxy(TaskProxy):isReceiveTasks(arg0.taskGroup) then
		playStory(var0)
	end
end

function var0.UpdateCharacter(arg0)
	setActive(arg0.randomLock, not arg0:IsFinish())
	setActive(arg0.randomText, arg0:IsFinish())

	arg0.nameInput:GetComponent(typeof(InputField)).interactable = arg0:IsFinish()

	setActive(arg0:findTF("edit", arg0.characterName), arg0:IsFinish())
end

function var0.UpdateTask(arg0, arg1, arg2)
	local var0 = arg0.taskMap[arg1 + 1]
	local var1 = arg0:findTF("IconTpl", arg2)
	local var2 = arg0.taskGroup[var0]
	local var3 = arg0.taskProxy:getTaskVO(var2)

	assert(var3, "without this task by id: " .. var2)
	setText(arg0:findTF("title", arg2), i18n("roll_reward_word" .. var0))

	local var4 = var3:getConfig("award_display")[1]
	local var5 = {
		type = var4[1],
		id = var4[2],
		count = var4[3]
	}

	updateDrop(var1, var5)
	onButton(arg0, var1, function()
		arg0:emit(BaseUI.ON_DROP, var5)
	end, SFX_PANEL)

	local var6 = var3:getProgress()
	local var7 = var3:getConfig("target_num")

	setText(arg0:findTF("progress", arg2), i18n("roll_reward_tip", var6, var7))
	setText(arg0:findTF("mask/Text", arg2), i18n("roll_reward_got"))
	setActive(arg0:findTF("mask", arg2), var3:isReceive())
end

function var0.UpdateAttrLock(arg0)
	arg0.attrLock = {}

	for iter0, iter1 in ipairs(arg0.exploredStories) do
		if arg0.story2Attr[iter1] ~= nil then
			for iter2, iter3 in ipairs(arg0.story2Attr[iter1]) do
				table.insert(arg0.attrLock, iter3)
			end
		end
	end
end

function var0.UpdateCard(arg0)
	arg0:UpdateAttrLock()
	setText(arg0.characterName, var0.GetRollData(1, var1) .. ":")
	setInputText(arg0.nameInput, getProxy(PlayerProxy):getData().name)
	setText(arg0.profession, var0.GetRollData(2, var1) .. ":")
	setText(findTF(arg0.profession, "Text"), var0.GetRollData(2, var2))

	for iter0 = 1, arg0.attrGroup.childCount do
		local var0 = arg0.attrGroup:GetChild(iter0 - 1)

		for iter1 = 1, var0.childCount do
			local var1 = var0:GetChild(iter1 - 1)
			local var2 = (iter1 - 1) * arg0.attrGroup.childCount + iter0 + 2

			setText(findTF(var1, "name"), var0.GetRollData(var2, var1))
			setText(findTF(var1, "Text"), table.contains(arg0.attrLock, var2) and var0.GetRollData(var2, var2) or "---")
			setActive(findTF(var1, "Text/Image"), not table.contains(arg0.attrLock, var2))
		end
	end

	for iter2 = 1, arg0.skillGroup.childCount do
		local var3 = arg0.skillGroup:GetChild(iter2 - 1)

		for iter3 = 1, var3.childCount do
			local var4 = var3:GetChild(iter3 - 1)
			local var5 = (iter3 - 1) * arg0.attrGroup.childCount + iter2 + 10

			setText(findTF(var4, "group/skill_name"), table.contains(arg0.attrLock, var5) and var0.GetRollData(var5, var1) or "")
			setText(findTF(var4, "group/Text"), table.contains(arg0.attrLock, var5) and var0.GetColorValue(var5, var0.GetRollData(var5, var2)) or "")
			setActive(findTF(var4, "Image"), not table.contains(arg0.attrLock, var5))
		end
	end
end

function var0.RollCharacterCard(arg0)
	for iter0 = 1, arg0.attrGroup.childCount do
		local var0 = arg0.attrGroup:GetChild(iter0 - 1)

		for iter1 = 1, var0.childCount do
			local var1 = var0:GetChild(iter1 - 1)
			local var2 = (iter1 - 1) * arg0.attrGroup.childCount + iter0 + 2
			local var3 = var0.GetRollData(var2, var3)

			setText(findTF(var1, "Text"), math.random(var3[1], var3[2]))
		end
	end

	local var4 = var0.GetRandomValue(i18n("roll_attr_list"), 8)
	local var5 = 1

	for iter2 = 1, arg0.skillGroup.childCount do
		local var6 = arg0.skillGroup:GetChild(iter2 - 1)

		for iter3 = 1, var6.childCount do
			local var7 = var6:GetChild(iter3 - 1)
			local var8 = (iter3 - 1) * arg0.attrGroup.childCount + iter2 + 10

			setText(findTF(var7, "group/skill_name"), var4[var5])

			var5 = var5 + 1

			setText(findTF(var7, "group/Text"), var0.GetColorValue(var8, var0.GetRandomValue(var0.GetRollData(var8, var3), 1)[1]))
		end
	end
end

function var0.IsFinish(arg0)
	return #arg0.exploredStories == 24
end

function var0.GetRandomValue(arg0, arg1)
	local var0 = {}

	for iter0 = 1, #arg0 do
		table.insert(var0, iter0)
	end

	shuffle(var0)

	local var1 = {}

	for iter1 = 1, arg1 do
		table.insert(var1, arg0[var0[iter1]])
	end

	return var1
end

function var0.GetColorValue(arg0, arg1)
	local var0 = var0.GetRollData(arg0, var3)
	local var1 = table.indexof(var0, arg1)

	return setColorStr(arg1, var0.SKILL_COLOR[var1])
end

function var0.CheckAwardGet(arg0)
	local var0 = false

	for iter0, iter1 in ipairs(arg0.taskGroup) do
		if arg0.taskProxy:getTaskVO(iter1):getTaskStatus() == 1 then
			var0 = true
		end
	end

	setActive(arg0.buttonAwardGet, var0)
	setActive(findTF(arg0.buttonAward, "red"), var0)
end

function var0.PlayStory(arg0, arg1)
	if arg0:IsPlayed(arg1) then
		return
	end

	arg0.waitPlayStory = arg1

	arg0:emit(CastleMainMediator.CASTLE_ACT_OP, {
		cmd = 2,
		id = var0.ACT_ID,
		arg1 = arg1
	})
end

function var0.StoryActEnd(arg0, arg1)
	if not arg0.waitPlayStory then
		return
	end

	local var0, var1 = arg0.storyMgr:StoryId2StoryName(arg0.waitPlayStory)

	local function var2()
		if arg0.story2Attr[arg0.waitPlayStory] == nil then
			return false
		end

		local var0 = 0

		for iter0, iter1 in ipairs(arg0.story2Attr[arg0.waitPlayStory]) do
			if not table.contains(arg0.attrLock, iter1) then
				var0 = var0 + 1
			end
		end

		return var0 > 0
	end

	playStory(var0, function()
		if var2() then
			arg0:UpdateCard()
			setActive(arg0.characterWindow, true)
			pg.UIMgr.GetInstance():BlurPanel(arg0.characterCard)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0.CARD_SE)

			for iter0, iter1 in ipairs(arg0.story2Attr[arg0.waitPlayStory]) do
				if iter1 < 11 then
					local var0 = iter1 - 3
					local var1 = math.floor(var0 / arg0.attrGroup.childCount)
					local var2 = var0 % arg0.attrGroup.childCount
					local var3 = arg0.attrGroup:GetChild(var2):GetChild(var1)

					setText(findTF(var3, "Text"), var0.GetRollData(iter1, var2))
					findTF(var3, "Text/Image"):GetComponent(typeof(Animation)):Play("anim_castle_skill")
				else
					local var4 = iter1 - 11
					local var5 = math.floor(var4 / arg0.skillGroup.childCount)
					local var6 = var4 % arg0.skillGroup.childCount
					local var7 = arg0.skillGroup:GetChild(var6):GetChild(var5)

					setText(findTF(var7, "group/skill_name"), var0.GetRollData(iter1, var1))
					setText(findTF(var7, "group/Text"), var0.GetColorValue(iter1, var0.GetRollData(iter1, var2)))
					findTF(var7, "Image"):GetComponent(typeof(Animation)):Play("anim_castle_skill")
				end
			end

			arg0:ExploreStory(arg0.waitPlayStory)
			arg0:UnlockStory(arg1)
			arg0:UpdateAttrLock()
		else
			arg0:ExploreStory(arg0.waitPlayStory)
			arg0:UnlockStory(arg1)
			arg0:UpdateAttrLock()
			arg0:UpdateFlush()
			arg0:CheckGuide()
		end
	end)
end

function var0.FirstStory(arg0)
	local var0 = arg0.activity:getConfig("config_data")[1]
	local var1, var2 = arg0.storyMgr:StoryId2StoryName(var0)

	playStory(var1, function()
		local var0 = {
			8,
			59496,
			1
		}
		local var1 = {
			type = var0[1],
			id = var0[2],
			count = var0[3]
		}

		arg0:UpdateFlush()
		arg0:emit(BaseUI.ON_AWARD, {
			items = {
				var1
			},
			title = AwardInfoLayer.TITLE.ITEM,
			removeFunc = function()
				arg0:CheckGuide()
			end
		})
	end)
end

function var0.RollDice(arg0, arg1, arg2)
	for iter0, iter1 in ipairs({
		arg0.success,
		arg0.criticalSuccess,
		arg0.failure,
		arg0.criticalFailure
	}) do
		setActive(iter1, false)
	end

	setActive(arg0.diceWindow, true)
	setActive(arg0.buttonDiceContinue, false)
	arg0:ExplorableEffect(false)
	setImageAlpha(arg0.buttonDiceContinue, 0)

	arg0.diceNumber = arg1

	if arg1 == 100 then
		arg1 = 0
	end

	local var0 = math.floor(arg1 / 10)
	local var1 = arg1 % 10

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0.ROLL_SE)
	arg0:SetAnim(arg0.dices[1], var0, nil)
	arg0:SetAnim(arg0.dices[2], var1, function()
		LeanTween.delayedCall(go(arg0._tf), 0.12, System.Action(function()
			if arg0.diceNumber <= 5 then
				setActive(arg0.criticalSuccess, true)
			elseif arg0.diceNumber <= 50 then
				setActive(arg0.success, true)
			elseif arg0.diceNumber <= 94 then
				setActive(arg0.failure, true)
			else
				setActive(arg0.criticalFailure, true)
			end

			setActive(arg0.buttonDiceContinue, true)
			LeanTween.delayedCall(go(arg0._tf), 0.495, System.Action(function()
				LeanTween.alpha(arg0.buttonDiceContinue, 1, 0.26)
			end))
		end))
	end)

	arg0.explorablePos = arg2

	for iter2, iter3 in ipairs(arg0.storyGroup) do
		arg0:UnlockStory(iter3)

		if iter3 == arg2 then
			break
		end
	end
end

function var0.SetAnim(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetComponent(typeof(SpineAnimUI))

	var0:SetActionCallBack(nil)
	var0:SetAction("roll" .. arg2, 0)
	var0:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			var0:SetActionCallBack(nil)
			var0:SetAction("normal" .. arg2, 0)

			if arg3 then
				arg3()
			end
		end
	end)
end

function var0.UnlockStory(arg0, arg1)
	if table.contains(arg0.explorableStories, arg1) or table.contains(arg0.exploredStories, arg1) then
		return
	end

	table.insert(arg0.explorableStories, arg1)

	if arg0:IndexofStory(arg1) > arg0:IndexofStory(arg0.explorablePos) then
		arg0.explorablePos = arg1
	end
end

function var0.ExploreStory(arg0, arg1)
	if table.contains(arg0.exploredStories, arg1) then
		return
	end

	if not table.contains(arg0.explorableStories, arg1) then
		return
	end

	table.removebyvalue(arg0.explorableStories, arg1)
	table.insert(arg0.exploredStories, arg1)

	if arg0:IndexofStory(arg1) > arg0:IndexofStory(arg0.currentPos) then
		arg0.currentPos = arg1
	end
end

function var0.IndexofStory(arg0, arg1)
	local var0 = table.indexof(arg0.storyGroup, arg1)

	if var0 == false then
		return -1
	end

	return var0
end

function var0.IsPlayed(arg0, arg1)
	local var0, var1 = arg0.storyMgr:StoryId2StoryName(arg1)

	return arg0.storyMgr:IsPlayed(var0, var1)
end

function var0.IsBadEnd(arg0, arg1)
	return (table.indexof(arg0.storyGroup, arg1) + 1) % 3 == 0
end

function var0.ExplorableEffect(arg0, arg1)
	for iter0 = 1, var0.ROOM_NUM do
		local var0 = arg0:GetRoomTF(iter0)

		setActive(findTF(var0, "explorable/glow"), arg1)
		setActive(findTF(var0, "explorable/glow1"), arg1)
	end
end

function var0.ChangeRoomColor(arg0, arg1, arg2)
	local var0 = arg0:GetRoomTF(arg1)
	local var1 = findTF(var0, "fill")

	if arg2 then
		setImageColor(var1, arg2)
	end
end

function var0.ChangeRoomMark(arg0, arg1, arg2, arg3)
	cover = cover or false

	local var0 = arg0:GetRoomTF(arg1)
	local var1 = findTF(var0, "current")
	local var2 = findTF(var0, "unexplored")
	local var3 = findTF(var0, "bad")
	local var4 = findTF(var0, "explorable")

	if not arg3 then
		for iter0, iter1 in ipairs({
			var1,
			var2,
			var3,
			var4
		}) do
			setActive(iter1, false)
		end
	end

	if arg2 then
		if arg2 == var0.MARK_CURRENT then
			setActive(var1, true)
		elseif arg2 == var0.MARK_UNEXPLORED then
			setActive(var2, true)
		elseif arg2 == var0.MARK_BAD then
			setActive(var3, true)
		elseif arg2 == var0.MARK_EXPLORABLE then
			setActive(var4, true)
		end
	end
end

function var0.GetRoomTF(arg0, arg1)
	if arg1 == var0.ROOM_NUM then
		return arg0.rooms[1]:GetChild(arg0.rooms[1].childCount - 1)
	elseif arg1 < arg0.rooms[1].childCount then
		return arg0.rooms[1]:GetChild(arg1 - 1)
	end

	arg1 = arg1 - arg0.rooms[1].childCount

	return arg0.rooms[2]:GetChild(arg1)
end

function var0.CheckGuide(arg0)
	for iter0, iter1 in pairs({
		{
			"guide",
			"Castle000",
			function(arg0)
				return #arg0.exploredStories == 0
			end
		},
		{
			"guide",
			"Castle001",
			function(arg0)
				return #arg0.exploredStories == 1 and arg0:IndexofStory(arg0.explorablePos) <= arg0:IndexofStory(arg0.currentPos)
			end
		},
		{
			"story",
			arg0.storyMgr:StoryId2StoryName(arg0.activity:getConfig("config_client")[1][1]),
			function(arg0)
				return #arg0.exploredStories == 1 and arg0:IndexofStory(arg0.explorablePos) > arg0:IndexofStory(arg0.currentPos)
			end
		},
		{
			"story",
			arg0.storyMgr:StoryId2StoryName(arg0.activity:getConfig("config_client")[1][2]),
			function(arg0)
				return #arg0.exploredStories == 2 and arg0:IndexofStory(arg0.explorablePos) <= arg0:IndexofStory(arg0.currentPos)
			end
		},
		{
			"guide",
			"Castle002",
			function(arg0)
				return arg0:IndexofStory(arg0.explorablePos) == 15 and arg0:IndexofStory(arg0.explorablePos) > arg0:IndexofStory(arg0.currentPos)
			end
		},
		{
			"story",
			arg0.storyMgr:StoryId2StoryName(arg0.activity:getConfig("config_client")[1][3]),
			function(arg0)
				return getProxy(TaskProxy):isReceiveTasks(arg0.taskGroup)
			end
		}
	}) do
		local var0, var1, var2 = unpack(iter1)

		if not arg0:IsPlayed(var1) and var2(arg0) then
			if var0 == "guide" then
				pg.NewGuideMgr.GetInstance():Play(var1, nil, function()
					arg0:emit(CastleMainMediator.UPDATE_GUIDE, var1)
				end)
			elseif var0 == "story" then
				playStory(var1)
			else
				assert(false)
			end

			break
		end
	end
end

function var0.PlaySE(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg0)
end

function var0.GetRollData(arg0, arg1)
	return pg.roll_attr[arg0][arg1]
end

function var0.willExit(arg0)
	if isActive(arg0.characterWindow) then
		setActive(arg0.characterWindow, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.characterCard, arg0.characterWindowBg)
	end

	LeanTween.cancel(go(arg0._tf))
end

function var0.onBackPressed(arg0)
	if isActive(arg0.diceWindow) then
		return
	end

	arg0:emit(var0.ON_BACK_PRESSED)
end

return var0
