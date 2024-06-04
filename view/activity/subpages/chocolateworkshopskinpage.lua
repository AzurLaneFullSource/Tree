local var0 = class("ChocolateWorkshopSkinPage", import(".TemplatePage.SkinTemplatePage"))

var0.FADE_TIME = 0.5
var0.SHOW_TIME = 2
var0.FADE_OUT_TIME = 0.5

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.finishContainer = arg0:findTF("FinishContainer", arg0.bg)
	arg0.bubbleTF = arg0:findTF("Bubble", arg0.bg)
	arg0.bubbleText = arg0:findTF("Text", arg0.bubbleTF)
	arg0.bubbleCG = GetComponent(arg0.bubbleTF, "CanvasGroup")
	arg0.sdContainer = arg0:findTF("SDcontainer", arg0.bg)
	arg0.sdBtn = arg0:findTF("SDBtn", arg0.bg)

	onButton(arg0, arg0.sdBtn, function()
		local var0 = {
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

		if type(var0) == "table" and pg.TimeMgr.GetInstance():inTime(var0) then
			setActive(arg0.boxTF, true)
		end
	end, SFX_PANEL)

	arg0.boxTF = arg0:findTF("Box")
	arg0.boxBG = arg0:findTF("BG", arg0.boxTF)
	arg0.boxText = arg0:findTF("Content/Text", arg0.boxTF)

	setText(arg0.boxText, i18n("valentinesday__shop_tip"))

	arg0.confirmBtn = arg0:findTF("Content/Confirm", arg0.boxTF)
	arg0.cancelBtn = arg0:findTF("Content/Cancel", arg0.boxTF)

	onButton(arg0, arg0.boxBG, function()
		setActive(arg0.boxTF, false)
	end, SFX_CANCEL)
	onButton(arg0, arg0.cancelBtn, function()
		setActive(arg0.boxTF, false)
	end, SFX_CANCEL)
	onButton(arg0, arg0.confirmBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
		setActive(arg0.boxTF, false)
	end, SFX_PANEL)

	arg0.sdNameList = {
		"anshan_3",
		"shiyu_4"
	}
	arg0.bubbleTextTable = {
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
	arg0.aniContainerTF = arg0:findTF("AniContainer", arg0.bg)

	local var0 = GetComponent(arg0._tf, "ItemList").prefabItem

	arg0.tplList = {}

	for iter0 = 0, var0.Length - 1 do
		table.insert(arg0.tplList, var0[iter0])
	end

	arg0.sdName = arg0.sdNameList[math.random(#arg0.sdNameList)]
	arg0.spine = nil
	arg0.spineLRQ = GetSpineRequestPackage.New(arg0.sdName, function(arg0)
		SetParent(arg0, arg0.sdContainer)

		arg0.spine = arg0
		arg0.spine.transform.localScale = Vector3.one

		local var0 = arg0.spine:GetComponent("SpineAnimUI")

		if var0 then
			var0:SetAction("stand2", 0)
		end

		arg0.spineLRQ = nil
	end):Start()
end

function var0.OnFirstFlush(arg0)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0:findTF("item", arg2)
			local var2 = arg0.taskGroup[arg0.nday][var0]
			local var3 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)

			assert(var3, "without this task by id: " .. var2)

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

			setText(arg0:findTF("description", arg2), var3:getConfig("desc"))
			setText(arg0:findTF("progressText", arg2), setColorStr(var6, "#BBCF2EFF") .. "/" .. var7)
			setSlider(arg0:findTF("progress", arg2), 0, var7, var6)

			local var8 = arg0:findTF("go_btn", arg2)
			local var9 = arg0:findTF("get_btn", arg2)
			local var10 = arg0:findTF("got_btn", arg2)
			local var11 = var3:getTaskStatus()

			setActive(var8, var11 == 0)
			setActive(var9, var11 == 1)
			setActive(var10, var11 == 2)
			onButton(arg0, var8, function()
				arg0:emit(ActivityMediator.ON_TASK_GO, var3)
			end, SFX_PANEL)
			onButton(arg0, var9, function()
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var3)
			end, SFX_PANEL)
		end
	end)

	arg0.showBubbleTag = false
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setActive(arg0.boxTF, false)

	for iter0 = 1, arg0.finishContainer.childCount do
		local var0 = arg0.finishContainer:GetChild(iter0 - 1)

		setActive(var0, iter0 <= arg0.nday)
	end

	local var1 = arg0.taskGroup[arg0.nday][1]
	local var2 = arg0.taskProxy:getTaskVO(var1):getTaskStatus()

	if not arg0.showBubbleTag then
		if var2 == 0 then
			arg0:showBubble(i18n(arg0.bubbleTextTable[arg0.sdName][1]))

			arg0.showBubbleTag = true
		elseif var2 == 1 then
			arg0:showBubble(i18n(arg0.bubbleTextTable[arg0.sdName][2]))

			arg0.showBubbleTag = true
		end
	end

	eachChild(arg0.aniContainerTF, function(arg0)
		Destroy(arg0)
	end)

	if var2 == 0 then
		SetParent(Instantiate(arg0.tplList[1]), arg0.aniContainerTF, false)
	else
		SetParent(Instantiate(arg0.tplList[2]), arg0.aniContainerTF, false)
	end
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	if arg0.spineLRQ then
		arg0.spineLRQ:Stop()

		arg0.spineLRQ = nil
	end

	if arg0.spine then
		arg0.spine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar(arg0.sdName, arg0.spine)

		arg0.spine = nil
	end
end

function var0.showBubble(arg0, arg1)
	local var0

	if not arg1 then
		var0 = i18n(arg0.bubbleTextList[math.random(#arg0.bubbleTextList)])
	else
		var0 = arg1
	end

	setText(arg0.bubbleText, var0)

	local function var1(arg0)
		arg0.bubbleCG.alpha = arg0

		setLocalScale(arg0.bubbleTF, Vector3.one * arg0)
	end

	local function var2()
		LeanTween.value(go(arg0.bubbleTF), 1, 0, var0.FADE_OUT_TIME):setOnUpdate(System.Action_float(var1)):setOnComplete(System.Action(function()
			setActive(arg0.bubbleTF, false)
		end))
	end

	LeanTween.cancel(go(arg0.bubbleTF))
	setActive(arg0.bubbleTF, true)
	LeanTween.value(go(arg0.bubbleTF), 0, 1, var0.FADE_TIME):setOnUpdate(System.Action_float(var1)):setOnComplete(System.Action(function()
		LeanTween.delayedCall(go(arg0.bubbleTF), var0.SHOW_TIME, System.Action(var2))
	end))
end

return var0
