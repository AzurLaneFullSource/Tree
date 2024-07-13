local var0_0 = class("ChocolateWorkshopSkinPage", import(".TemplatePage.SkinTemplatePage"))

var0_0.FADE_TIME = 0.5
var0_0.SHOW_TIME = 2
var0_0.FADE_OUT_TIME = 0.5

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.finishContainer = arg0_1:findTF("FinishContainer", arg0_1.bg)
	arg0_1.bubbleTF = arg0_1:findTF("Bubble", arg0_1.bg)
	arg0_1.bubbleText = arg0_1:findTF("Text", arg0_1.bubbleTF)
	arg0_1.bubbleCG = GetComponent(arg0_1.bubbleTF, "CanvasGroup")
	arg0_1.sdContainer = arg0_1:findTF("SDcontainer", arg0_1.bg)
	arg0_1.sdBtn = arg0_1:findTF("SDBtn", arg0_1.bg)

	onButton(arg0_1, arg0_1.sdBtn, function()
		local var0_2 = {
			{
				{
					2022,
					2,
					14
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2022,
					2,
					23
				},
				{
					23,
					59,
					59
				}
			}
		}

		if type(var0_2) == "table" and pg.TimeMgr.GetInstance():inTime(var0_2) then
			setActive(arg0_1.boxTF, true)
		end
	end, SFX_PANEL)

	arg0_1.boxTF = arg0_1:findTF("Box")
	arg0_1.boxBG = arg0_1:findTF("BG", arg0_1.boxTF)
	arg0_1.boxText = arg0_1:findTF("Content/Text", arg0_1.boxTF)

	setText(arg0_1.boxText, i18n("valentinesday__shop_tip"))

	arg0_1.confirmBtn = arg0_1:findTF("Content/Confirm", arg0_1.boxTF)
	arg0_1.cancelBtn = arg0_1:findTF("Content/Cancel", arg0_1.boxTF)

	onButton(arg0_1, arg0_1.boxBG, function()
		setActive(arg0_1.boxTF, false)
	end, SFX_CANCEL)
	onButton(arg0_1, arg0_1.cancelBtn, function()
		setActive(arg0_1.boxTF, false)
	end, SFX_CANCEL)
	onButton(arg0_1, arg0_1.confirmBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
		setActive(arg0_1.boxTF, false)
	end, SFX_PANEL)

	arg0_1.sdNameList = {
		"anshan_3",
		"shiyu_4"
	}
	arg0_1.bubbleTextTable = {
		anshan_3 = {
			"valentinesday__txt1_tip",
			"valentinesday__txt2_tip",
			"valentinesday__txt3_tip"
		},
		shiyu_4 = {
			"valentinesday__txt4_tip",
			"valentinesday__txt5_tip",
			"valentinesday__txt6_tip"
		}
	}
	arg0_1.aniContainerTF = arg0_1:findTF("AniContainer", arg0_1.bg)

	local var0_1 = GetComponent(arg0_1._tf, "ItemList").prefabItem

	arg0_1.tplList = {}

	for iter0_1 = 0, var0_1.Length - 1 do
		table.insert(arg0_1.tplList, var0_1[iter0_1])
	end

	arg0_1.sdName = arg0_1.sdNameList[math.random(#arg0_1.sdNameList)]
	arg0_1.spine = nil
	arg0_1.spineLRQ = GetSpineRequestPackage.New(arg0_1.sdName, function(arg0_6)
		SetParent(arg0_6, arg0_1.sdContainer)

		arg0_1.spine = arg0_6
		arg0_1.spine.transform.localScale = Vector3.one

		local var0_6 = arg0_1.spine:GetComponent("SpineAnimUI")

		if var0_6 then
			var0_6:SetAction("stand2", 0)
		end

		arg0_1.spineLRQ = nil
	end):Start()
end

function var0_0.OnFirstFlush(arg0_7)
	arg0_7.uilist:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg1_8 + 1
			local var1_8 = arg0_7:findTF("item", arg2_8)
			local var2_8 = arg0_7.taskGroup[arg0_7.nday][var0_8]
			local var3_8 = arg0_7.taskProxy:getTaskById(var2_8) or arg0_7.taskProxy:getFinishTaskById(var2_8)

			assert(var3_8, "without this task by id: " .. var2_8)

			local var4_8 = var3_8:getConfig("award_display")[1]
			local var5_8 = {
				type = var4_8[1],
				id = var4_8[2],
				count = var4_8[3]
			}

			updateDrop(var1_8, var5_8)
			onButton(arg0_7, var1_8, function()
				arg0_7:emit(BaseUI.ON_DROP, var5_8)
			end, SFX_PANEL)

			local var6_8 = var3_8:getProgress()
			local var7_8 = var3_8:getConfig("target_num")

			setText(arg0_7:findTF("description", arg2_8), var3_8:getConfig("desc"))
			setText(arg0_7:findTF("progressText", arg2_8), setColorStr(var6_8, "#BBCF2EFF") .. "/" .. var7_8)
			setSlider(arg0_7:findTF("progress", arg2_8), 0, var7_8, var6_8)

			local var8_8 = arg0_7:findTF("go_btn", arg2_8)
			local var9_8 = arg0_7:findTF("get_btn", arg2_8)
			local var10_8 = arg0_7:findTF("got_btn", arg2_8)
			local var11_8 = var3_8:getTaskStatus()

			setActive(var8_8, var11_8 == 0)
			setActive(var9_8, var11_8 == 1)
			setActive(var10_8, var11_8 == 2)
			onButton(arg0_7, var8_8, function()
				arg0_7:emit(ActivityMediator.ON_TASK_GO, var3_8)
			end, SFX_PANEL)
			onButton(arg0_7, var9_8, function()
				arg0_7:emit(ActivityMediator.ON_TASK_SUBMIT, var3_8)
			end, SFX_PANEL)
		end
	end)

	arg0_7.showBubbleTag = false
end

function var0_0.OnUpdateFlush(arg0_12)
	var0_0.super.OnUpdateFlush(arg0_12)
	setActive(arg0_12.boxTF, false)

	for iter0_12 = 1, arg0_12.finishContainer.childCount do
		local var0_12 = arg0_12.finishContainer:GetChild(iter0_12 - 1)

		setActive(var0_12, iter0_12 <= arg0_12.nday)
	end

	local var1_12 = arg0_12.taskGroup[arg0_12.nday][1]
	local var2_12 = arg0_12.taskProxy:getTaskVO(var1_12):getTaskStatus()

	if not arg0_12.showBubbleTag then
		if var2_12 == 0 then
			arg0_12:showBubble(i18n(arg0_12.bubbleTextTable[arg0_12.sdName][1]))

			arg0_12.showBubbleTag = true
		elseif var2_12 == 1 then
			arg0_12:showBubble(i18n(arg0_12.bubbleTextTable[arg0_12.sdName][2]))

			arg0_12.showBubbleTag = true
		end
	end

	eachChild(arg0_12.aniContainerTF, function(arg0_13)
		Destroy(arg0_13)
	end)

	if var2_12 == 0 then
		SetParent(Instantiate(arg0_12.tplList[1]), arg0_12.aniContainerTF, false)
	else
		SetParent(Instantiate(arg0_12.tplList[2]), arg0_12.aniContainerTF, false)
	end
end

function var0_0.OnDestroy(arg0_14)
	var0_0.super.OnDestroy(arg0_14)

	if arg0_14.spineLRQ then
		arg0_14.spineLRQ:Stop()

		arg0_14.spineLRQ = nil
	end

	if arg0_14.spine then
		arg0_14.spine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar(arg0_14.sdName, arg0_14.spine)

		arg0_14.spine = nil
	end
end

function var0_0.showBubble(arg0_15, arg1_15)
	local var0_15

	if not arg1_15 then
		var0_15 = i18n(arg0_15.bubbleTextList[math.random(#arg0_15.bubbleTextList)])
	else
		var0_15 = arg1_15
	end

	setText(arg0_15.bubbleText, var0_15)

	local function var1_15(arg0_16)
		arg0_15.bubbleCG.alpha = arg0_16

		setLocalScale(arg0_15.bubbleTF, Vector3.one * arg0_16)
	end

	local function var2_15()
		LeanTween.value(go(arg0_15.bubbleTF), 1, 0, var0_0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var1_15)):setOnComplete(System.Action(function()
			setActive(arg0_15.bubbleTF, false)
		end))
	end

	LeanTween.cancel(go(arg0_15.bubbleTF))
	setActive(arg0_15.bubbleTF, true)
	LeanTween.value(go(arg0_15.bubbleTF), 0, 1, var0_0.FADE_TIME):setOnUpdate(System.Action_float(var1_15)):setOnComplete(System.Action(function()
		LeanTween.delayedCall(go(arg0_15.bubbleTF), var0_0.SHOW_TIME, System.Action(var2_15))
	end))
end

return var0_0
