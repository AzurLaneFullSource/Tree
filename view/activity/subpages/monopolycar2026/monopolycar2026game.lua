local var0_0 = class("MonopolyCar2026Game", import("..MonopolyCar2024.MonopolyCar2024Game"))
local var1_0 = 1
local var2_0 = 2

local function var3_0(arg0_1)
	local var0_1 = arg0_1 and arg0_1.story

	return var0_1 ~= nil and var0_1 ~= "" and var0_1 ~= "0"
end

local function var4_0(arg0_2)
	local var0_2 = pg.activity_monopolycar2026_story_event
	local var1_2 = var0_2.all[arg0_2]

	return var1_2 and var0_2[var1_2]
end

local function var5_0(arg0_3)
	for iter0_3 = arg0_3 - 1, 1, -1 do
		local var0_3 = var4_0(iter0_3)

		if var3_0(var0_3) then
			return var0_3
		end
	end
end

local function var6_0()
	for iter0_4 = #pg.activity_monopolycar2026_story_event.all, 1, -1 do
		local var0_4 = var4_0(iter0_4)

		if var3_0(var0_4) then
			return var0_4
		end
	end
end

local function var7_0(arg0_5)
	local var0_5 = arg0_5 and arg0_5.main_story

	return var0_5 ~= nil and var0_5 ~= "" and var0_5 ~= "0"
end

function var0_0.NewPickPage(arg0_6, arg1_6, arg2_6)
	return MonopolyCar2026PickPage.New(arg1_6, arg2_6)
end

function var0_0.NewBubblePage(arg0_7, arg1_7, arg2_7)
	return MonopolyCar2026BubblePage.New(arg1_7:Find("bubble"), arg2_7)
end

function var0_0.InitUI(arg0_8)
	var0_0.super.InitUI(arg0_8)

	arg0_8.labelLeftCount2 = findTF(arg0_8.btnStart, "labelLeftCount/Text_1")
	arg0_8.mainModeBtn = findTF(arg0_8._tf.parent, "mode/toggles/main")
	arg0_8.storyModeBtn = findTF(arg0_8._tf.parent, "mode/toggles/story")
	arg0_8.storyModeBtnTip = arg0_8.storyModeBtn:Find("tip")
	arg0_8.btnAutolock = findTF(arg0_8.topTr, "btnAuto/lock")

	setText(arg0_8.mainModeBtn:Find("Text"), i18n("mono_car_2026_toggle_main"))
	setText(arg0_8.mainModeBtn:Find("sel/Text"), i18n("mono_car_2026_toggle_main"))
	setText(arg0_8.storyModeBtn:Find("Text"), i18n("mono_car_2026_toggle_story"))
	setText(arg0_8.storyModeBtn:Find("sel/Text"), i18n("mono_car_2026_toggle_story"))

	arg0_8.storyCnt = findTF(arg0_8._tf.parent, "story/award/Text")
	arg0_8.storyTpl = findTF(arg0_8._tf.parent, "story/mapContainer/tpl")
	arg0_8.storyContainer = findTF(arg0_8._tf.parent, "story/mapContainer")
	arg0_8.storyAward = findTF(arg0_8._tf.parent, "story/award/award")
	arg0_8.storyAwardGot = findTF(arg0_8.storyAward, "icon_mask")
	arg0_8.mileageTxt = findTF(arg0_8._tf, "mileage/Text")
	arg0_8.hideList = {
		arg0_8.btnStart,
		arg0_8.btnBack,
		arg0_8.btnAuto,
		arg0_8.register
	}
end

function var0_0.UpdateAutoBtn(arg0_9)
	var0_0.super.UpdateAutoBtn(arg0_9)

	local var0_9 = arg0_9.useCount >= 10

	setActive(arg0_9.btnAutolock, not var0_9)
end

function var0_0.OnEnterDone(arg0_10, arg1_10)
	if not pg.NewStoryMgr.GetInstance():IsPlayed("BINHAIJISU1") then
		pg.NewStoryMgr.GetInstance():Play("BINHAIJISU1", arg1_10, true)
	else
		arg1_10()
	end
end

function var0_0.InitDone(arg0_11, arg1_11)
	if not pg.NewStoryMgr.GetInstance():IsPlayed("BINHAIJISU2") then
		pg.NewStoryMgr.GetInstance():Play("BINHAIJISU2", arg1_11, true)
	else
		arg1_11()
	end
end

function var0_0.CheckMainStorys(arg0_12, arg1_12)
	arg1_12 = arg1_12 or function()
		return
	end

	local var0_12 = pg.activity_monopolycar2026_story_event
	local var1_12 = pg.NewStoryMgr.GetInstance()
	local var2_12 = {}
	local var3_12 = arg0_12.turnCnt or 1

	for iter0_12, iter1_12 in ipairs(var0_12.all) do
		local var4_12 = var0_12[iter1_12]

		if var4_12 and iter1_12 <= var3_12 - 1 and var7_0(var4_12) and not var1_12:IsPlayed(var4_12.main_story) then
			table.insert(var2_12, var4_12.main_story)
		end
	end

	if #var2_12 <= 0 then
		arg0_12:PlayStepHideAnim(arg1_12)

		return
	end

	local var5_12 = {}

	for iter2_12, iter3_12 in ipairs(var2_12) do
		table.insert(var5_12, function(arg0_14)
			if arg0_12.autoFlag then
				var1_12:ForceAutoPlay(iter3_12, arg0_14, true, true)
			else
				var1_12:Play(iter3_12, arg0_14, true)
			end
		end)
	end

	seriesAsync(var5_12, function()
		arg0_12:PlayStepHideAnim(arg1_12)
	end)
end

function var0_0.PlayStepHideAnim(arg0_16, arg1_16)
	local var0_16 = findTF(arg0_16.rollStep, "animroot"):GetComponent(typeof(Animation))

	var0_16:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_16:SetRollStepAct(false)

		if arg1_16 then
			arg1_16()
		end
	end)
	var0_16:Play("anim_monopolycar_mainui_step_hide")
end

function var0_0.PlayRollAnimation(arg0_18, arg1_18, arg2_18)
	setText(findTF(arg0_18.rollStep, "animroot/Image/Text"), "00")

	local var0_18 = arg0_18.btnStart:GetComponent(typeof(Animation))
	local var1_18 = var0_18:GetComponent(typeof(DftAniEvent))
	local var2_18 = findTF(arg0_18.rollStep, "animroot"):GetComponent(typeof(Animation))
	local var3_18 = var2_18:GetComponent(typeof(DftAniEvent))

	var3_18:SetTriggerEvent(function()
		setText(findTF(arg0_18.rollStep, "animroot/Image/Text"), "0" .. arg1_18)
	end)
	seriesAsync({
		function(arg0_20)
			var1_18:SetEndEvent(function()
				arg0_20()
			end)
			var0_18:Play("anim_monopolycar_mainui_btn_hide")
		end,
		function(arg0_22)
			arg0_18:SetRollStepAct(true)
			arg0_22()
		end,
		function(arg0_23)
			var3_18:SetEndEvent(function()
				arg0_23()
			end)
			var2_18:Play("anim_monopolycar_mainui_step_0" .. arg1_18)
		end
	}, function()
		var0_18:Play("anim_monopolycar_mainui_btn_show")
		arg2_18()
	end)
end

function var0_0.InitMap(arg0_26)
	arg0_26.mapCells = {}

	for iter0_26, iter1_26 in ipairs(pg.activity_monopolycar2026_map_event.all) do
		local var0_26 = pg.activity_monopolycar2026_map_event[iter1_26]
		local var1_26 = var0_26.event_id
		local var2_26 = cloneTplTo(arg0_26.tplMapCell, arg0_26.mapContainer, tostring(var1_26))
		local var3_26 = Vector3(var0_26.pos.x, var0_26.pos.y, 0)

		var2_26.localPosition = var3_26

		setActive(var2_26, false)

		local var4_26 = pg.activity_event_monopoly_map[var1_26].icon
		local var5_26 = {
			col = col,
			row = row,
			mapId = var1_26,
			tf = var2_26,
			icon = var4_26,
			position = var3_26,
			flip = var0_26.flip or 0
		}

		table.insert(arg0_26.mapCells, var5_26)
	end

	table.sort(arg0_26.mapCells, function(arg0_27, arg1_27)
		return arg0_27.mapId < arg1_27.mapId
	end)
	arg0_26:InitStoryMap()
end

function var0_0.SetRollStepAct(arg0_28, arg1_28)
	if not arg1_28 then
		setText(findTF(arg0_28.rollStep, "animroot/Image/Text"), "00")
	end

	setActive(arg0_28.rollStep, true)
end

function var0_0.InitStoryMap(arg0_29)
	arg0_29.storyCells = {}

	for iter0_29, iter1_29 in ipairs(pg.activity_monopolycar2026_story_event.all) do
		local var0_29 = pg.activity_monopolycar2026_story_event[iter1_29]
		local var1_29 = cloneTplTo(arg0_29.storyTpl, arg0_29.storyContainer, tostring(iter1_29))

		var1_29.localPosition = Vector3(var0_29.pos.x, var0_29.pos.y, 0)

		local var2_29 = var3_0(var0_29)

		if var2_29 then
			onButton(arg0_29, var1_29, function()
				pg.NewStoryMgr.GetInstance():Play(var0_29.story, nil, true)
			end, SFX_PANEL)
		end

		local var3_29 = findTF(var1_29, "Image")
		local var4_29 = pg.ship_skin_template[var0_29.icon]

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var4_29.prefab, "", var3_29)
		setActive(var1_29, var2_29)
		table.insert(arg0_29.storyCells, var1_29)
	end

	arg0_29:UpdateStoriesUnlock()
	arg0_29:UpdateStoryAward()
end

function var0_0.UpdateStoryAward(arg0_31)
	local var0_31 = var6_0()
	local var1_31 = var0_31 and pg.NewStoryMgr.GetInstance():StoryName2StoryId(var0_31.story)
	local var2_31 = var1_31 and pg.story_template[var1_31]
	local var3_31 = var2_31 and var2_31.drop_client and var2_31.drop_client[1]

	if var3_31 then
		local var4_31 = {
			type = var3_31[1],
			id = var3_31[2],
			count = var3_31[3]
		}

		updateDrop(arg0_31.storyAward, var4_31)
	end
end

function var0_0.UpdateStoriesUnlock(arg0_32)
	local var0_32 = pg.NewStoryMgr.GetInstance()
	local var1_32 = 0

	for iter0_32, iter1_32 in ipairs(arg0_32.storyCells) do
		local var2_32 = var4_0(iter0_32)
		local var3_32 = false

		if var3_0(var2_32) then
			var1_32 = var1_32 + 1
			var3_32 = var1_32 <= arg0_32.turnCnt
		end

		if var3_32 and var1_32 > 1 then
			local var4_32 = var5_0(iter0_32)

			var3_32 = not var4_32 or var0_32:IsPlayed(var4_32.story)
		end

		setActive(iter1_32, var3_32)
	end
end

function var0_0.InitCar(arg0_33, arg1_33)
	arg0_33.model = findTF(arg0_33.car, "car")
	arg0_33.model.transform.localScale = Vector3.one
	arg0_33.model.transform.localPosition = Vector3.zero

	arg0_33.model.transform:SetParent(arg0_33.car, false)

	arg0_33.modelIconTf = findTF(arg0_33.model, "icon")
	arg0_33.modelArrTf = findTF(arg0_33.model, "arr")

	if arg0_33.modelIconTf then
		arg0_33.modelIconBasePos = arg0_33.modelIconTf.localPosition
	end

	if arg0_33.modelArrTf then
		arg0_33.modelArrBaseScale = arg0_33.modelArrTf.localScale
	end

	if arg0_33.pos then
		arg0_33:UpdateCarPos(arg0_33.pos, false)
	end

	arg1_33()
end

function var0_0.UpdateStory(arg0_34)
	arg0_34:UpdateStoriesUnlock()
	arg0_34:UpdateStoryUI()
end

function var0_0.UpdateUI(arg0_35)
	var0_0.super.UpdateUI(arg0_35)
	setText(arg0_35.labelLeftCount2, i18n("monopoly2026_left_cnt", arg0_35.leftCount))
	setText(arg0_35.mileageTxt, arg0_35.pos .. "/" .. #arg0_35.mapCells .. "KM")
	setText(arg0_35.labelLeftCount, arg0_35.leftCount)
	setText(arg0_35.registerTxt, arg0_35.turnCnt)
	arg0_35:UpdateStoriesUnlock()
	arg0_35:UpdateStoryUI()
end

function var0_0.UpdateStoryUI(arg0_36)
	local var0_36 = 0
	local var1_36 = 0
	local var2_36 = false
	local var3_36 = pg.NewStoryMgr.GetInstance()
	local var4_36 = 0

	for iter0_36, iter1_36 in ipairs(pg.activity_monopolycar2026_story_event.all) do
		local var5_36 = pg.activity_monopolycar2026_story_event[iter1_36]
		local var6_36 = var3_0(var5_36)

		if var6_36 then
			var4_36 = var4_36 + 1
			var0_36 = var0_36 + 1
		end

		local var7_36 = false

		if var6_36 then
			local var8_36 = var3_36:IsPlayed(var5_36.story)

			if var8_36 then
				var1_36 = var1_36 + 1
			end

			local var9_36 = var4_36 <= arg0_36.turnCnt

			if var9_36 and var4_36 > 1 then
				local var10_36 = var5_0(iter0_36)

				var9_36 = not var10_36 or var3_36:IsPlayed(var10_36.story)
			end

			var7_36 = var9_36 and not var8_36
			var2_36 = var2_36 or var7_36
		else
			setActive(arg0_36.storyCells[iter0_36], false)
		end

		setActive(arg0_36.storyCells[iter0_36]:Find("tip"), var7_36)
	end

	setText(arg0_36.storyCnt, i18n("monopoly2026_story_award", var1_36, var0_36))

	local var11_36 = var0_36 > 0 and var1_36 == var0_36

	setActive(arg0_36.storyAwardGot, var11_36)
	setActive(arg0_36.storyModeBtnTip, var2_36)
end

function var0_0.UpdateCarPos(arg0_37, arg1_37, arg2_37)
	if arg0_37.model then
		assert(arg0_37.mapCells[arg1_37], arg1_37)
		arg0_37:ApplyModelFlip(arg0_37.mapCells[arg1_37].flip or 0)

		local var0_37 = arg0_37.mapCells[arg1_37].position
		local var1_37 = arg1_37 + 1 > #arg0_37.mapCells and 1 or arg1_37 + 1
		local var2_37 = arg0_37.mapCells[var1_37]

		arg0_37.car.localPosition = var0_37

		arg0_37.car:SetAsLastSibling()
	end
end

function var0_0.ReadyMoveCar(arg0_38, arg1_38, arg2_38)
	if not arg1_38 or #arg1_38 <= 0 then
		if arg2_38 then
			arg2_38()
		end

		return
	end

	local var0_38 = {}

	for iter0_38 = 1, #arg1_38 do
		table.insert(var0_38, function(arg0_39)
			arg0_38:UpdateCarPos(arg1_38[iter0_38], true)
			Timer.New(arg0_39, 1, 1):Start()
		end)
	end

	seriesAsync(var0_38, arg2_38)
end

function var0_0.ApplyModelFlip(arg0_40, arg1_40)
	if not arg0_40.model then
		return
	end

	if arg0_40.modelIconTf and arg0_40.modelIconBasePos then
		local var0_40 = 0

		if arg1_40 == 1 then
			local var1_40 = arg0_40.modelIconTf:GetComponent(typeof(RectTransform))
			local var2_40 = arg0_40.modelArrTf and arg0_40.modelArrTf:GetComponent(typeof(RectTransform))

			var0_40 = (var1_40 and var1_40.rect.height or 0) + (var2_40 and var2_40.rect.height or 0)
		end

		local var3_40 = arg0_40.modelIconBasePos

		arg0_40.modelIconTf.localPosition = Vector3(var3_40.x, var3_40.y - var0_40, var3_40.z)
	end

	if arg0_40.modelArrTf and arg0_40.modelArrBaseScale then
		local var4_40 = arg0_40.modelArrBaseScale
		local var5_40 = arg1_40 == 1 and -1 or var4_40.y

		arg0_40.modelArrTf.localScale = Vector3(var4_40.x, var5_40, var4_40.z)
	end
end

function var0_0.GetCarMoveType(arg0_41, arg1_41, arg2_41, arg3_41)
	local var0_41
	local var1_41
	local var2_41 = arg3_41 and stateWalkB or stateStandB
	local var3_41 = Vector3(1, 1, 1)

	return var2_41, var3_41
end

function var0_0.InitCheerLeaders(arg0_42, arg1_42)
	arg0_42.cheerLeaders = {}

	arg1_42()
end

function var0_0.RegisterUI(arg0_43)
	var0_0.super.RegisterUI(arg0_43)
	onToggle(arg0_43, arg0_43.mainModeBtn, function(arg0_44)
		if arg0_44 then
			arg0_43:SwitchMode(var1_0)
		end
	end, SFX_PANEL)
	onToggle(arg0_43, arg0_43.storyModeBtn, function(arg0_45)
		if arg0_45 then
			arg0_43:SwitchMode(var2_0)
		end
	end, SFX_PANEL)
	onButton(arg0_43, arg0_43.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_monopoly_car2026.tip
		})
	end, SFX_PANEL)
	onButton(arg0_43, arg0_43.register, function()
		return
	end, SFX_PANEL)
end

function var0_0.SwitchMode(arg0_48, arg1_48)
	arg0_48.mode = arg1_48
end

return var0_0
