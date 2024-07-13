local var0_0 = class("CastleMainScene", import("..base.BaseUI"))

var0_0.optionsPath = {
	"main/top/btn_home"
}

local var1_0 = "name"
local var2_0 = "default_value"
local var3_0 = "random_value"

var0_0.ACT_ID = ActivityConst.CASTLE_ACT_ID
var0_0.AWARD_ACT_ID = ActivityConst.CASTLE_AWARD_ID
var0_0.SKILL_COLOR = {
	"#546190",
	"#835490",
	"#A57D55",
	"#C15348"
}
var0_0.BAD_FILL_COLOR = Color(0.658823529411765, 0.501960784313725, 0.482352941176471, 0.5)
var0_0.NORMAL_FILL_COLOR = Color(1, 1, 1, 0.5)
var0_0.TRANSPARENT_COLOR = Color(1, 1, 1, 0)
var0_0.MARK_CURRENT = "1"
var0_0.MARK_UNEXPLORED = "2"
var0_0.MARK_BAD = "3"
var0_0.MARK_EXPLORABLE = "4"
var0_0.MAP_POS = {
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
var0_0.ROOM_NUM = 17
var0_0.WALK_SE = "event:/ui/castle_walk"
var0_0.ROLL_SE = "event:/ui/caslte_roll"
var0_0.CARD_SE = "event:/ui/huihua1"

function var0_0.getUIName(arg0_1)
	return "CastleMainUI"
end

function var0_0.init(arg0_2)
	arg0_2:InitData()
	arg0_2:InitTF()
	arg0_2:InitAward()
	arg0_2:InitCharacter()
	arg0_2:InitDice()
	arg0_2:InitVX()
end

function var0_0.InitTF(arg0_3)
	arg0_3.main = arg0_3:findTF("main")
	arg0_3.map = arg0_3:findTF("map", arg0_3.main)
	arg0_3.floors = {
		arg0_3:findTF("floor1", arg0_3.map),
		arg0_3:findTF("floor2", arg0_3.map)
	}
	arg0_3.rooms = {
		arg0_3:findTF("rooms", arg0_3.floors[1]),
		arg0_3:findTF("rooms", arg0_3.floors[2])
	}
	arg0_3.top = arg0_3:findTF("top", arg0_3.main)
	arg0_3.buttonBack = arg0_3:findTF("btn_back", arg0_3.top)
	arg0_3.buttonHelp = arg0_3:findTF("btn_help", arg0_3.top)
	arg0_3.buttonAward = arg0_3:findTF("btn_award", arg0_3.top)
	arg0_3.buttonCharacter = arg0_3:findTF("btn_character", arg0_3.top)
	arg0_3.buttonDice = arg0_3:findTF("btn_dice", arg0_3.top)
	arg0_3.diceRes = arg0_3:findTF("dice_res", arg0_3.buttonDice)
	arg0_3.button1F = arg0_3:findTF("btn_1F", arg0_3.top)
	arg0_3.button2F = arg0_3:findTF("btn_2F", arg0_3.top)
	arg0_3.window = arg0_3:findTF("window")
end

function var0_0.InitData(arg0_4)
	arg0_4.storyMgr = pg.NewStoryMgr.GetInstance()
	arg0_4.activity = getProxy(ActivityProxy):getActivityById(var0_0.ACT_ID)
	arg0_4.story2Map = {}
	arg0_4.map2Story = {}
	arg0_4.storyGroup = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.activity:getConfig("config_data")[3]) do
		table.insert(arg0_4.storyGroup, iter1_4[1][1])
		table.insert(arg0_4.storyGroup, iter1_4[2][2])
		table.insert(arg0_4.storyGroup, iter1_4[2][1])
	end

	for iter2_4 = 1, var0_0.ROOM_NUM do
		table.insert(arg0_4.map2Story, {})
	end

	for iter3_4 = 1, #arg0_4.storyGroup do
		table.insert(arg0_4.story2Map, arg0_4.storyGroup[iter3_4], var0_0.MAP_POS[iter3_4])
		table.insert(arg0_4.map2Story[var0_0.MAP_POS[iter3_4]], arg0_4.storyGroup[iter3_4])
	end

	arg0_4.explorableStories = {}
	arg0_4.exploredStories = {}

	if arg0_4.activity.data1 ~= nil and arg0_4.activity.data1 ~= 0 then
		for iter4_4 = 1, #arg0_4.storyGroup do
			table.insert(arg0_4:IsPlayed(arg0_4.storyGroup[iter4_4]) and arg0_4.exploredStories or arg0_4.explorableStories, arg0_4.storyGroup[iter4_4])

			if arg0_4.storyGroup[iter4_4] == arg0_4.activity.data1 then
				break
			end
		end
	end

	arg0_4.explorablePos = arg0_4.activity.data1
	arg0_4.currentPos = #arg0_4.exploredStories == 0 and 0 or arg0_4.exploredStories[#arg0_4.exploredStories]
end

function var0_0.InitAward(arg0_5)
	arg0_5.awardWindow = arg0_5:findTF("award_window", arg0_5.window)
	arg0_5.buttonAwardGet = arg0_5:findTF("award_bg/btn_get", arg0_5.awardWindow)
	arg0_5.awardWindowBg = arg0_5:findTF("bg", arg0_5.awardWindow)
	arg0_5.awardItem = arg0_5:findTF("award_bg/mask/item", arg0_5.awardWindow)
	arg0_5.awardItems = arg0_5:findTF("award_bg/mask/content", arg0_5.awardWindow)
	arg0_5.awardActivity = getProxy(ActivityProxy):getActivityById(var0_0.AWARD_ACT_ID)
	arg0_5.taskProxy = getProxy(TaskProxy)
	arg0_5.taskGroup = arg0_5.awardActivity:getConfig("config_data")
	arg0_5.taskList = UIItemList.New(arg0_5.awardItems, arg0_5.awardItem)
	arg0_5.taskMap = {}

	for iter0_5 = 1, #arg0_5.taskGroup do
		table.insert(arg0_5.taskMap, iter0_5)
	end
end

function var0_0.InitDice(arg0_6)
	arg0_6.diceWindow = arg0_6:findTF("dice_window", arg0_6.window)
	arg0_6.buttonDiceContinue = arg0_6:findTF("btn_continue", arg0_6.diceWindow)
	arg0_6.dice = arg0_6:findTF("dice", arg0_6.diceWindow)
	arg0_6.dices = {
		arg0_6:findTF("dice1", arg0_6.dice),
		arg0_6:findTF("dice2", arg0_6.dice)
	}
	arg0_6.result = arg0_6:findTF("result", arg0_6.diceWindow)
	arg0_6.success = arg0_6:findTF("success", arg0_6.result)
	arg0_6.criticalSuccess = arg0_6:findTF("critical_success", arg0_6.result)
	arg0_6.failure = arg0_6:findTF("failure", arg0_6.result)
	arg0_6.criticalFailure = arg0_6:findTF("critical_failure", arg0_6.result)
end

function var0_0.InitCharacter(arg0_7)
	arg0_7.characterWindow = arg0_7:findTF("character_window", arg0_7.window)
	arg0_7.characterWindowBg = arg0_7:findTF("bg", arg0_7.characterWindow)
	arg0_7.characterCard = arg0_7:findTF("character_card", arg0_7.characterWindowBg)
	arg0_7.characterName = arg0_7:findTF("title_base/name", arg0_7.characterCard)
	arg0_7.profession = arg0_7:findTF("title_base/profession", arg0_7.characterCard)
	arg0_7.nameInput = arg0_7:findTF("InputField", arg0_7.characterName)
	arg0_7.attrGroup = arg0_7:findTF("title_attr/attrGroup", arg0_7.characterCard)
	arg0_7.skillGroup = arg0_7:findTF("title_skill/skillGroup", arg0_7.characterCard)
	arg0_7.characterTip = arg0_7:findTF("tip", arg0_7.characterCard)

	setText(arg0_7.characterTip, i18n("roll_unlock"))

	arg0_7.buttonRandom = arg0_7:findTF("random", arg0_7.characterCard)
	arg0_7.randomLock = arg0_7:findTF("lock", arg0_7.buttonRandom)
	arg0_7.randomText = arg0_7:findTF("Image", arg0_7.buttonRandom)

	setText(arg0_7:findTF("title_base", arg0_7.characterCard), i18n("roll_card_info"))
	setText(arg0_7:findTF("title_attr", arg0_7.characterCard), i18n("roll_card_attr"))
	setText(arg0_7:findTF("title_skill", arg0_7.characterCard), i18n("roll_card_skill"))

	local var0_7 = arg0_7.activity:getConfig("config_client")[2]

	arg0_7.story2Attr = {}

	for iter0_7, iter1_7 in ipairs(var0_7) do
		table.insert(arg0_7.story2Attr, iter1_7[1], iter1_7[2])
	end

	arg0_7.attrLock = {}
end

function var0_0.InitVX(arg0_8)
	for iter0_8, iter1_8 in ipairs({
		"success",
		"Csuccess",
		"failure",
		"Cfailure"
	}) do
		local var0_8 = arg0_8.result:GetChild(iter0_8 - 1)
		local var1_8 = findTF(var0_8, iter1_8)
		local var2_8 = findTF(var0_8, "VX/glow")

		setLocalScale(var2_8, {
			x = var1_8.rect.width,
			y = var1_8.rect.height
		})
	end
end

function var0_0.didEnter(arg0_9)
	for iter0_9 = 1, var0_0.ROOM_NUM do
		local var0_9 = arg0_9:GetRoomTF(iter0_9)
		local var1_9 = findTF(var0_9, "name")

		setText(var1_9, i18n("roll_room_unexplored"))

		local var2_9 = findTF(var0_9, "explorable")

		setImageRaycastTarget(findTF(var0_9, "fill"), true)
		onButton(arg0_9, var0_9, function()
			for iter0_10, iter1_10 in ipairs(arg0_9.map2Story[iter0_9]) do
				if table.contains(arg0_9.explorableStories, iter1_10) then
					arg0_9:PlayStory(iter1_10)

					break
				end
			end
		end, SFX_PANEL)
	end

	if table.contains(arg0_9.explorableStories, arg0_9.storyGroup[15]) or table.contains(arg0_9.exploredStories, arg0_9.storyGroup[15]) then
		local var3_9

		for iter1_9 = #arg0_9.exploredStories, 1, -1 do
			if not arg0_9:IsBadEnd(arg0_9.exploredStories[iter1_9]) then
				var3_9 = arg0_9.exploredStories[iter1_9]

				break
			end
		end

		local var4_9 = var3_9 and arg0_9.story2Map[var3_9] or 0
		local var5_9 = var4_9 > 10 and var4_9 < 17

		setActive(arg0_9.floors[1], not var5_9)
		setActive(arg0_9.floors[2], var5_9)
		setActive(arg0_9.button1F, not var5_9)
		setActive(arg0_9.button2F, var5_9)
	else
		setActive(arg0_9.button1F, false)
		setActive(arg0_9.button2F, false)
	end

	arg0_9.taskList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_9:UpdateTask(arg1_11, arg2_11)
		end
	end)
	arg0_9.nameInput:GetComponent(typeof(InputField)).onValueChanged:AddListener(function()
		if not nameValidityCheck(getInputText(arg0_9.nameInput), 0, 40, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"ship_renameShip_error_2011",
			"playerinfo_mask_word"
		}) then
			setInputText(arg0_9.nameInput, getProxy(PlayerProxy):getData().name)
		end
	end)
	arg0_9:InitButton()
	arg0_9:UpdateFlush()

	local var6_9 = arg0_9.activity:getConfig("config_data")[1]

	if var6_9 and not arg0_9:IsPlayed(var6_9) then
		arg0_9:emit(CastleMainMediator.CASTLE_ACT_OP, {
			cmd = 3,
			id = var0_0.ACT_ID,
			arg1 = var6_9
		})
	else
		arg0_9:CheckGuide()
	end
end

function var0_0.InitButton(arg0_13)
	onButton(arg0_13, arg0_13.button1F, function()
		setActive(arg0_13.button1F, false)
		setActive(arg0_13.button2F, true)
		setActive(arg0_13.floors[2], true)
		setActive(arg0_13.floors[1], false)
	end, var0_0.WALK_SE)
	onButton(arg0_13, arg0_13.button2F, function()
		setActive(arg0_13.button2F, false)
		setActive(arg0_13.button1F, true)
		setActive(arg0_13.floors[1], true)
		setActive(arg0_13.floors[2], false)
	end, var0_0.WALK_SE)
	onButton(arg0_13, arg0_13.buttonBack, function()
		arg0_13:closeView()
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.buttonHelp, function()
		local var0_17 = i18n("roll_gametip")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = var0_17
		})
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.buttonAward, function()
		setActive(arg0_13.awardWindow, true)
		arg0_13:CheckAwardGet()
		arg0_13:ExplorableEffect(false)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.buttonAwardGet, function()
		local var0_19 = underscore(arg0_13.taskGroup):chain():map(function(arg0_20)
			return arg0_13.taskProxy:getTaskVO(arg0_20)
		end):filter(function(arg0_21)
			return arg0_21:getTaskStatus() == 1
		end):value()

		if #var0_19 > 0 then
			arg0_13:emit(CastleMainMediator.ON_TASK_SUBMIT, var0_19)
		end
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.awardWindowBg, function()
		setActive(arg0_13.awardWindow, false)
		arg0_13:ExplorableEffect(true)
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.buttonCharacter, function()
		arg0_13:UpdateCard()
		setActive(arg0_13.characterWindow, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_13.characterCard)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.characterWindowBg, function()
		setActive(arg0_13.characterWindow, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_13.characterCard, arg0_13.characterWindowBg)
		arg0_13:UpdateFlush()
		arg0_13:CheckGuide()
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.buttonRandom, function()
		if arg0_13:IsFinish() then
			if #getInputText(arg0_13.nameInput) == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("roll_noname"))
			else
				arg0_13:RollCharacterCard()
			end
		end
	end, SFX_CANCEL)
	onButton(arg0_13, arg0_13.buttonDice, function()
		if arg0_13.diceCount < 1 then
			if table.contains(arg0_13.explorableStories, arg0_13.storyGroup[23]) or table.contains(arg0_13.explorableStories, arg0_13.storyGroup[24]) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("roll_ending_tip1"))
			elseif table.contains(arg0_13.exploredStories, arg0_13.storyGroup[23]) and table.contains(arg0_13.exploredStories, arg0_13.storyGroup[24]) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("roll_ending_tip2"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("roll_notimes"))
			end

			return
		end

		if arg0_13:IndexofStory(arg0_13.explorablePos) > arg0_13:IndexofStory(arg0_13.currentPos) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("roll_tip2"))

			return
		end

		arg0_13:emit(CastleMainMediator.CASTLE_ACT_OP, {
			cmd = 1,
			id = var0_0.ACT_ID
		})
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.buttonDiceContinue, function()
		setActive(arg0_13.diceWindow, false)
		arg0_13:UpdateFlush()
		arg0_13:CheckGuide()
		arg0_13:ExplorableEffect(true)
	end, SFX_PANEL)
end

function var0_0.UpdateFlush(arg0_28)
	arg0_28.activity = getProxy(ActivityProxy):getActivityById(var0_0.ACT_ID)
	arg0_28.awardActivity = getProxy(ActivityProxy):getActivityById(var0_0.AWARD_ACT_ID)
	arg0_28.taskGroup = arg0_28.awardActivity:getConfig("config_data")

	arg0_28:UpdateDice()
	arg0_28:UpdateMap()
	arg0_28:UpdateAward()
	arg0_28:UpdateCharacter()

	if arg0_28:IndexofStory(arg0_28.explorablePos) == 15 and arg0_28:IndexofStory(arg0_28.explorablePos) > arg0_28:IndexofStory(arg0_28.currentPos) then
		setActive(arg0_28.button1F, true)
	end

	setActive(arg0_28.buttonDice, not arg0_28:IsFinish())
end

function var0_0.UpdateDice(arg0_29)
	arg0_29.diceCount = arg0_29.activity.data2

	if table.contains(arg0_29.explorableStories, arg0_29.explorablePos) and arg0_29:IsBadEnd(arg0_29.explorablePos) then
		arg0_29.diceCount = arg0_29.diceCount - 1
	end

	setText(arg0_29.diceRes, i18n("roll_times_left", arg0_29.diceCount))

	if arg0_29.explorablePos == arg0_29.currentPos and arg0_29.diceCount > 0 then
		arg0_29.buttonDice:GetComponent(typeof(Animation)):Play("anim_castle_dice_tiploop")
	else
		arg0_29.buttonDice:GetComponent(typeof(Animation)):Stop()
	end
end

function var0_0.UpdateMap(arg0_30)
	for iter0_30 = 1, var0_0.ROOM_NUM do
		arg0_30:ChangeRoomColor(iter0_30, var0_0.TRANSPARENT_COLOR)
		arg0_30:ChangeRoomMark(iter0_30, nil)
	end

	for iter1_30, iter2_30 in ipairs(arg0_30.exploredStories) do
		local var0_30 = arg0_30.story2Map[iter2_30]
		local var1_30 = arg0_30:GetRoomTF(var0_30)

		setText(findTF(var1_30, "name"), i18n("roll_room" .. var0_30))
	end

	setActive(findTF(arg0_30.main, "finish_mask"), false)

	if arg0_30:IsFinish() then
		setActive(findTF(arg0_30.main, "finish_mask"), true)

		return
	end

	for iter3_30, iter4_30 in ipairs(arg0_30.exploredStories) do
		local var2_30 = arg0_30.story2Map[iter4_30]

		if arg0_30:IsBadEnd(iter4_30) then
			if var2_30 ~= 17 then
				if var2_30 ~= 4 then
					arg0_30:ChangeRoomColor(var2_30, var0_0.BAD_FILL_COLOR)
				end

				arg0_30:ChangeRoomMark(var2_30, var0_0.MARK_BAD)
			end
		else
			arg0_30:ChangeRoomColor(var2_30, var0_0.NORMAL_FILL_COLOR)
		end
	end

	for iter5_30, iter6_30 in ipairs(arg0_30.explorableStories) do
		local var3_30 = arg0_30.story2Map[iter6_30]

		arg0_30:ChangeRoomMark(var3_30, var0_0.MARK_EXPLORABLE)
		arg0_30:ChangeRoomMark(var3_30, var0_0.MARK_UNEXPLORED, true)
	end

	if #arg0_30.exploredStories > 0 then
		local var4_30

		for iter7_30, iter8_30 in ipairs(arg0_30.storyGroup) do
			if not arg0_30:IsBadEnd(iter8_30) and table.contains(arg0_30.exploredStories, iter8_30) then
				var4_30 = iter8_30
			end
		end

		arg0_30:ChangeRoomMark(arg0_30.story2Map[var4_30], var0_0.MARK_CURRENT, true)
	end

	setActive(arg0_30.button1F:Find("Image"), table.contains(arg0_30.explorableStories, arg0_30.storyGroup[24]))
	setActive(arg0_30.button2F:Find("Image"), table.contains(arg0_30.explorableStories, arg0_30.storyGroup[23]))
end

function var0_0.UpdateAward(arg0_31)
	arg0_31:CheckAwardGet()
	table.sort(arg0_31.taskMap, function(arg0_32, arg1_32)
		local var0_32 = arg0_31.taskProxy:getTaskVO(arg0_31.taskGroup[arg0_32]):getTaskStatus() == 2 and 1 or 0
		local var1_32 = arg0_31.taskProxy:getTaskVO(arg0_31.taskGroup[arg1_32]):getTaskStatus() == 2 and 1 or 0

		if var0_32 == var1_32 then
			return arg0_32 < arg1_32
		end

		return var0_32 < var1_32
	end)
	arg0_31.taskList:align(#arg0_31.taskGroup)

	local var0_31 = arg0_31.storyMgr:StoryId2StoryName(arg0_31.activity:getConfig("config_client")[1][3])

	if not arg0_31:IsPlayed(var0_31) and getProxy(TaskProxy):isReceiveTasks(arg0_31.taskGroup) then
		playStory(var0_31)
	end
end

function var0_0.UpdateCharacter(arg0_33)
	setActive(arg0_33.randomLock, not arg0_33:IsFinish())
	setActive(arg0_33.randomText, arg0_33:IsFinish())

	arg0_33.nameInput:GetComponent(typeof(InputField)).interactable = arg0_33:IsFinish()

	setActive(arg0_33:findTF("edit", arg0_33.characterName), arg0_33:IsFinish())
end

function var0_0.UpdateTask(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.taskMap[arg1_34 + 1]
	local var1_34 = arg0_34:findTF("IconTpl", arg2_34)
	local var2_34 = arg0_34.taskGroup[var0_34]
	local var3_34 = arg0_34.taskProxy:getTaskVO(var2_34)

	assert(var3_34, "without this task by id: " .. var2_34)
	setText(arg0_34:findTF("title", arg2_34), i18n("roll_reward_word" .. var0_34))

	local var4_34 = var3_34:getConfig("award_display")[1]
	local var5_34 = {
		type = var4_34[1],
		id = var4_34[2],
		count = var4_34[3]
	}

	updateDrop(var1_34, var5_34)
	onButton(arg0_34, var1_34, function()
		arg0_34:emit(BaseUI.ON_DROP, var5_34)
	end, SFX_PANEL)

	local var6_34 = var3_34:getProgress()
	local var7_34 = var3_34:getConfig("target_num")

	setText(arg0_34:findTF("progress", arg2_34), i18n("roll_reward_tip", var6_34, var7_34))
	setText(arg0_34:findTF("mask/Text", arg2_34), i18n("roll_reward_got"))
	setActive(arg0_34:findTF("mask", arg2_34), var3_34:isReceive())
end

function var0_0.UpdateAttrLock(arg0_36)
	arg0_36.attrLock = {}

	for iter0_36, iter1_36 in ipairs(arg0_36.exploredStories) do
		if arg0_36.story2Attr[iter1_36] ~= nil then
			for iter2_36, iter3_36 in ipairs(arg0_36.story2Attr[iter1_36]) do
				table.insert(arg0_36.attrLock, iter3_36)
			end
		end
	end
end

function var0_0.UpdateCard(arg0_37)
	arg0_37:UpdateAttrLock()
	setText(arg0_37.characterName, var0_0.GetRollData(1, var1_0) .. ":")
	setInputText(arg0_37.nameInput, getProxy(PlayerProxy):getData().name)
	setText(arg0_37.profession, var0_0.GetRollData(2, var1_0) .. ":")
	setText(findTF(arg0_37.profession, "Text"), var0_0.GetRollData(2, var2_0))

	for iter0_37 = 1, arg0_37.attrGroup.childCount do
		local var0_37 = arg0_37.attrGroup:GetChild(iter0_37 - 1)

		for iter1_37 = 1, var0_37.childCount do
			local var1_37 = var0_37:GetChild(iter1_37 - 1)
			local var2_37 = (iter1_37 - 1) * arg0_37.attrGroup.childCount + iter0_37 + 2

			setText(findTF(var1_37, "name"), var0_0.GetRollData(var2_37, var1_0))
			setText(findTF(var1_37, "Text"), table.contains(arg0_37.attrLock, var2_37) and var0_0.GetRollData(var2_37, var2_0) or "---")
			setActive(findTF(var1_37, "Text/Image"), not table.contains(arg0_37.attrLock, var2_37))
		end
	end

	for iter2_37 = 1, arg0_37.skillGroup.childCount do
		local var3_37 = arg0_37.skillGroup:GetChild(iter2_37 - 1)

		for iter3_37 = 1, var3_37.childCount do
			local var4_37 = var3_37:GetChild(iter3_37 - 1)
			local var5_37 = (iter3_37 - 1) * arg0_37.attrGroup.childCount + iter2_37 + 10

			setText(findTF(var4_37, "group/skill_name"), table.contains(arg0_37.attrLock, var5_37) and var0_0.GetRollData(var5_37, var1_0) or "")
			setText(findTF(var4_37, "group/Text"), table.contains(arg0_37.attrLock, var5_37) and var0_0.GetColorValue(var5_37, var0_0.GetRollData(var5_37, var2_0)) or "")
			setActive(findTF(var4_37, "Image"), not table.contains(arg0_37.attrLock, var5_37))
		end
	end
end

function var0_0.RollCharacterCard(arg0_38)
	for iter0_38 = 1, arg0_38.attrGroup.childCount do
		local var0_38 = arg0_38.attrGroup:GetChild(iter0_38 - 1)

		for iter1_38 = 1, var0_38.childCount do
			local var1_38 = var0_38:GetChild(iter1_38 - 1)
			local var2_38 = (iter1_38 - 1) * arg0_38.attrGroup.childCount + iter0_38 + 2
			local var3_38 = var0_0.GetRollData(var2_38, var3_0)

			setText(findTF(var1_38, "Text"), math.random(var3_38[1], var3_38[2]))
		end
	end

	local var4_38 = var0_0.GetRandomValue(i18n("roll_attr_list"), 8)
	local var5_38 = 1

	for iter2_38 = 1, arg0_38.skillGroup.childCount do
		local var6_38 = arg0_38.skillGroup:GetChild(iter2_38 - 1)

		for iter3_38 = 1, var6_38.childCount do
			local var7_38 = var6_38:GetChild(iter3_38 - 1)
			local var8_38 = (iter3_38 - 1) * arg0_38.attrGroup.childCount + iter2_38 + 10

			setText(findTF(var7_38, "group/skill_name"), var4_38[var5_38])

			var5_38 = var5_38 + 1

			setText(findTF(var7_38, "group/Text"), var0_0.GetColorValue(var8_38, var0_0.GetRandomValue(var0_0.GetRollData(var8_38, var3_0), 1)[1]))
		end
	end
end

function var0_0.IsFinish(arg0_39)
	return #arg0_39.exploredStories == 24
end

function var0_0.GetRandomValue(arg0_40, arg1_40)
	local var0_40 = {}

	for iter0_40 = 1, #arg0_40 do
		table.insert(var0_40, iter0_40)
	end

	shuffle(var0_40)

	local var1_40 = {}

	for iter1_40 = 1, arg1_40 do
		table.insert(var1_40, arg0_40[var0_40[iter1_40]])
	end

	return var1_40
end

function var0_0.GetColorValue(arg0_41, arg1_41)
	local var0_41 = var0_0.GetRollData(arg0_41, var3_0)
	local var1_41 = table.indexof(var0_41, arg1_41)

	return setColorStr(arg1_41, var0_0.SKILL_COLOR[var1_41])
end

function var0_0.CheckAwardGet(arg0_42)
	local var0_42 = false

	for iter0_42, iter1_42 in ipairs(arg0_42.taskGroup) do
		if arg0_42.taskProxy:getTaskVO(iter1_42):getTaskStatus() == 1 then
			var0_42 = true
		end
	end

	setActive(arg0_42.buttonAwardGet, var0_42)
	setActive(findTF(arg0_42.buttonAward, "red"), var0_42)
end

function var0_0.PlayStory(arg0_43, arg1_43)
	if arg0_43:IsPlayed(arg1_43) then
		return
	end

	arg0_43.waitPlayStory = arg1_43

	arg0_43:emit(CastleMainMediator.CASTLE_ACT_OP, {
		cmd = 2,
		id = var0_0.ACT_ID,
		arg1 = arg1_43
	})
end

function var0_0.StoryActEnd(arg0_44, arg1_44)
	if not arg0_44.waitPlayStory then
		return
	end

	local var0_44, var1_44 = arg0_44.storyMgr:StoryId2StoryName(arg0_44.waitPlayStory)

	local function var2_44()
		if arg0_44.story2Attr[arg0_44.waitPlayStory] == nil then
			return false
		end

		local var0_45 = 0

		for iter0_45, iter1_45 in ipairs(arg0_44.story2Attr[arg0_44.waitPlayStory]) do
			if not table.contains(arg0_44.attrLock, iter1_45) then
				var0_45 = var0_45 + 1
			end
		end

		return var0_45 > 0
	end

	playStory(var0_44, function()
		if var2_44() then
			arg0_44:UpdateCard()
			setActive(arg0_44.characterWindow, true)
			pg.UIMgr.GetInstance():BlurPanel(arg0_44.characterCard)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_0.CARD_SE)

			for iter0_46, iter1_46 in ipairs(arg0_44.story2Attr[arg0_44.waitPlayStory]) do
				if iter1_46 < 11 then
					local var0_46 = iter1_46 - 3
					local var1_46 = math.floor(var0_46 / arg0_44.attrGroup.childCount)
					local var2_46 = var0_46 % arg0_44.attrGroup.childCount
					local var3_46 = arg0_44.attrGroup:GetChild(var2_46):GetChild(var1_46)

					setText(findTF(var3_46, "Text"), var0_0.GetRollData(iter1_46, var2_0))
					findTF(var3_46, "Text/Image"):GetComponent(typeof(Animation)):Play("anim_castle_skill")
				else
					local var4_46 = iter1_46 - 11
					local var5_46 = math.floor(var4_46 / arg0_44.skillGroup.childCount)
					local var6_46 = var4_46 % arg0_44.skillGroup.childCount
					local var7_46 = arg0_44.skillGroup:GetChild(var6_46):GetChild(var5_46)

					setText(findTF(var7_46, "group/skill_name"), var0_0.GetRollData(iter1_46, var1_0))
					setText(findTF(var7_46, "group/Text"), var0_0.GetColorValue(iter1_46, var0_0.GetRollData(iter1_46, var2_0)))
					findTF(var7_46, "Image"):GetComponent(typeof(Animation)):Play("anim_castle_skill")
				end
			end

			arg0_44:ExploreStory(arg0_44.waitPlayStory)
			arg0_44:UnlockStory(arg1_44)
			arg0_44:UpdateAttrLock()
		else
			arg0_44:ExploreStory(arg0_44.waitPlayStory)
			arg0_44:UnlockStory(arg1_44)
			arg0_44:UpdateAttrLock()
			arg0_44:UpdateFlush()
			arg0_44:CheckGuide()
		end
	end)
end

function var0_0.FirstStory(arg0_47)
	local var0_47 = arg0_47.activity:getConfig("config_data")[1]
	local var1_47, var2_47 = arg0_47.storyMgr:StoryId2StoryName(var0_47)

	playStory(var1_47, function()
		local var0_48 = {
			8,
			59496,
			1
		}
		local var1_48 = {
			type = var0_48[1],
			id = var0_48[2],
			count = var0_48[3]
		}

		arg0_47:UpdateFlush()
		arg0_47:emit(BaseUI.ON_AWARD, {
			items = {
				var1_48
			},
			title = AwardInfoLayer.TITLE.ITEM,
			removeFunc = function()
				arg0_47:CheckGuide()
			end
		})
	end)
end

function var0_0.RollDice(arg0_50, arg1_50, arg2_50)
	for iter0_50, iter1_50 in ipairs({
		arg0_50.success,
		arg0_50.criticalSuccess,
		arg0_50.failure,
		arg0_50.criticalFailure
	}) do
		setActive(iter1_50, false)
	end

	setActive(arg0_50.diceWindow, true)
	setActive(arg0_50.buttonDiceContinue, false)
	arg0_50:ExplorableEffect(false)
	setImageAlpha(arg0_50.buttonDiceContinue, 0)

	arg0_50.diceNumber = arg1_50

	if arg1_50 == 100 then
		arg1_50 = 0
	end

	local var0_50 = math.floor(arg1_50 / 10)
	local var1_50 = arg1_50 % 10

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_0.ROLL_SE)
	arg0_50:SetAnim(arg0_50.dices[1], var0_50, nil)
	arg0_50:SetAnim(arg0_50.dices[2], var1_50, function()
		LeanTween.delayedCall(go(arg0_50._tf), 0.12, System.Action(function()
			if arg0_50.diceNumber <= 5 then
				setActive(arg0_50.criticalSuccess, true)
			elseif arg0_50.diceNumber <= 50 then
				setActive(arg0_50.success, true)
			elseif arg0_50.diceNumber <= 94 then
				setActive(arg0_50.failure, true)
			else
				setActive(arg0_50.criticalFailure, true)
			end

			setActive(arg0_50.buttonDiceContinue, true)
			LeanTween.delayedCall(go(arg0_50._tf), 0.495, System.Action(function()
				LeanTween.alpha(arg0_50.buttonDiceContinue, 1, 0.26)
			end))
		end))
	end)

	arg0_50.explorablePos = arg2_50

	for iter2_50, iter3_50 in ipairs(arg0_50.storyGroup) do
		arg0_50:UnlockStory(iter3_50)

		if iter3_50 == arg2_50 then
			break
		end
	end
end

function var0_0.SetAnim(arg0_54, arg1_54, arg2_54, arg3_54)
	local var0_54 = arg1_54:GetComponent(typeof(SpineAnimUI))

	var0_54:SetActionCallBack(nil)
	var0_54:SetAction("roll" .. arg2_54, 0)
	var0_54:SetActionCallBack(function(arg0_55)
		if arg0_55 == "finish" then
			var0_54:SetActionCallBack(nil)
			var0_54:SetAction("normal" .. arg2_54, 0)

			if arg3_54 then
				arg3_54()
			end
		end
	end)
end

function var0_0.UnlockStory(arg0_56, arg1_56)
	if table.contains(arg0_56.explorableStories, arg1_56) or table.contains(arg0_56.exploredStories, arg1_56) then
		return
	end

	table.insert(arg0_56.explorableStories, arg1_56)

	if arg0_56:IndexofStory(arg1_56) > arg0_56:IndexofStory(arg0_56.explorablePos) then
		arg0_56.explorablePos = arg1_56
	end
end

function var0_0.ExploreStory(arg0_57, arg1_57)
	if table.contains(arg0_57.exploredStories, arg1_57) then
		return
	end

	if not table.contains(arg0_57.explorableStories, arg1_57) then
		return
	end

	table.removebyvalue(arg0_57.explorableStories, arg1_57)
	table.insert(arg0_57.exploredStories, arg1_57)

	if arg0_57:IndexofStory(arg1_57) > arg0_57:IndexofStory(arg0_57.currentPos) then
		arg0_57.currentPos = arg1_57
	end
end

function var0_0.IndexofStory(arg0_58, arg1_58)
	local var0_58 = table.indexof(arg0_58.storyGroup, arg1_58)

	if var0_58 == false then
		return -1
	end

	return var0_58
end

function var0_0.IsPlayed(arg0_59, arg1_59)
	local var0_59, var1_59 = arg0_59.storyMgr:StoryId2StoryName(arg1_59)

	return arg0_59.storyMgr:IsPlayed(var0_59, var1_59)
end

function var0_0.IsBadEnd(arg0_60, arg1_60)
	return (table.indexof(arg0_60.storyGroup, arg1_60) + 1) % 3 == 0
end

function var0_0.ExplorableEffect(arg0_61, arg1_61)
	for iter0_61 = 1, var0_0.ROOM_NUM do
		local var0_61 = arg0_61:GetRoomTF(iter0_61)

		setActive(findTF(var0_61, "explorable/glow"), arg1_61)
		setActive(findTF(var0_61, "explorable/glow1"), arg1_61)
	end
end

function var0_0.ChangeRoomColor(arg0_62, arg1_62, arg2_62)
	local var0_62 = arg0_62:GetRoomTF(arg1_62)
	local var1_62 = findTF(var0_62, "fill")

	if arg2_62 then
		setImageColor(var1_62, arg2_62)
	end
end

function var0_0.ChangeRoomMark(arg0_63, arg1_63, arg2_63, arg3_63)
	cover = cover or false

	local var0_63 = arg0_63:GetRoomTF(arg1_63)
	local var1_63 = findTF(var0_63, "current")
	local var2_63 = findTF(var0_63, "unexplored")
	local var3_63 = findTF(var0_63, "bad")
	local var4_63 = findTF(var0_63, "explorable")

	if not arg3_63 then
		for iter0_63, iter1_63 in ipairs({
			var1_63,
			var2_63,
			var3_63,
			var4_63
		}) do
			setActive(iter1_63, false)
		end
	end

	if arg2_63 then
		if arg2_63 == var0_0.MARK_CURRENT then
			setActive(var1_63, true)
		elseif arg2_63 == var0_0.MARK_UNEXPLORED then
			setActive(var2_63, true)
		elseif arg2_63 == var0_0.MARK_BAD then
			setActive(var3_63, true)
		elseif arg2_63 == var0_0.MARK_EXPLORABLE then
			setActive(var4_63, true)
		end
	end
end

function var0_0.GetRoomTF(arg0_64, arg1_64)
	if arg1_64 == var0_0.ROOM_NUM then
		return arg0_64.rooms[1]:GetChild(arg0_64.rooms[1].childCount - 1)
	elseif arg1_64 < arg0_64.rooms[1].childCount then
		return arg0_64.rooms[1]:GetChild(arg1_64 - 1)
	end

	arg1_64 = arg1_64 - arg0_64.rooms[1].childCount

	return arg0_64.rooms[2]:GetChild(arg1_64)
end

function var0_0.CheckGuide(arg0_65)
	for iter0_65, iter1_65 in pairs({
		{
			"guide",
			"Castle000",
			function(arg0_66)
				return #arg0_66.exploredStories == 0
			end
		},
		{
			"guide",
			"Castle001",
			function(arg0_67)
				return #arg0_67.exploredStories == 1 and arg0_67:IndexofStory(arg0_67.explorablePos) <= arg0_67:IndexofStory(arg0_67.currentPos)
			end
		},
		{
			"story",
			arg0_65.storyMgr:StoryId2StoryName(arg0_65.activity:getConfig("config_client")[1][1]),
			function(arg0_68)
				return #arg0_68.exploredStories == 1 and arg0_68:IndexofStory(arg0_68.explorablePos) > arg0_68:IndexofStory(arg0_68.currentPos)
			end
		},
		{
			"story",
			arg0_65.storyMgr:StoryId2StoryName(arg0_65.activity:getConfig("config_client")[1][2]),
			function(arg0_69)
				return #arg0_69.exploredStories == 2 and arg0_69:IndexofStory(arg0_69.explorablePos) <= arg0_69:IndexofStory(arg0_69.currentPos)
			end
		},
		{
			"guide",
			"Castle002",
			function(arg0_70)
				return arg0_70:IndexofStory(arg0_70.explorablePos) == 15 and arg0_70:IndexofStory(arg0_70.explorablePos) > arg0_70:IndexofStory(arg0_70.currentPos)
			end
		},
		{
			"story",
			arg0_65.storyMgr:StoryId2StoryName(arg0_65.activity:getConfig("config_client")[1][3]),
			function(arg0_71)
				return getProxy(TaskProxy):isReceiveTasks(arg0_71.taskGroup)
			end
		}
	}) do
		local var0_65, var1_65, var2_65 = unpack(iter1_65)

		if not arg0_65:IsPlayed(var1_65) and var2_65(arg0_65) then
			if var0_65 == "guide" then
				pg.NewGuideMgr.GetInstance():Play(var1_65, nil, function()
					arg0_65:emit(CastleMainMediator.UPDATE_GUIDE, var1_65)
				end)
			elseif var0_65 == "story" then
				playStory(var1_65)
			else
				assert(false)
			end

			break
		end
	end
end

function var0_0.PlaySE(arg0_73)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg0_73)
end

function var0_0.GetRollData(arg0_74, arg1_74)
	return pg.roll_attr[arg0_74][arg1_74]
end

function var0_0.willExit(arg0_75)
	if isActive(arg0_75.characterWindow) then
		setActive(arg0_75.characterWindow, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_75.characterCard, arg0_75.characterWindowBg)
	end

	LeanTween.cancel(go(arg0_75._tf))
end

function var0_0.onBackPressed(arg0_76)
	if isActive(arg0_76.diceWindow) then
		return
	end

	arg0_76:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
