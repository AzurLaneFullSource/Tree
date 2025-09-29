local var0_0 = class("AnniversaryEightLoginJpPage", import("view.activity.CorePage.templatePage.CoreLoginSignTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.item = arg0_1:findTF("item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items/items", arg0_1.bg)
	arg0_1.itemList = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.signBtn = arg0_1:findTF("signBtn", arg0_1.bg)
	arg0_1.signRedTip = arg0_1:findTF("signBtn/tip", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.enterFlag = true

	setActive(arg0_2.item, false)

	arg0_2.playedAnimationList = {}

	for iter0_2 = 1, arg0_2.activity.data1 do
		table.insert(arg0_2.playedAnimationList, iter0_2 - 1)
	end

	arg0_2.itemList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg0_2:findTF("item", arg2_3)
			local var1_3 = arg0_2.config.front_drops[arg1_3 + 1]
			local var2_3 = {
				type = var1_3[1],
				id = var1_3[2],
				count = var1_3[3]
			}

			updateDrop(var0_3, var2_3)
			onButton(arg0_2, arg2_3, function()
				arg0_2:emit(BaseUI.ON_DROP, var2_3)
			end, SFX_PANEL)

			local var3_3 = arg0_2:findTF("got", arg2_3)

			setActive(var3_3, arg1_3 < arg0_2.nday)
			setActive(arg0_2:findTF("getEffect", arg2_3), arg0_2.activity.data1 == arg1_3 and arg0_2.activity:readyToAchieve())

			if table.contains(arg0_2.playedAnimationList, arg1_3) and arg1_3 == arg0_2.nday - 1 then
				GetComponent(arg2_3, typeof(Animation)):Play("anim_AnniversaryEightLoginJPPage_tpl_get")
			end
		end
	end)
	onButton(arg0_2, arg0_2.signBtn, function()
		if arg0_2.activity:readyToAchieve() == false then
			return
		end

		arg0_2:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_2.activity.id
		})
	end, SFX_CONFIRM)
end

function var0_0.ShowOrHide(arg0_6, arg1_6)
	var0_0.super.ShowOrHide(arg0_6, arg1_6)

	if arg1_6 == true then
		setActive(arg0_6.items, false)

		arg0_6.showTimer = Timer.New(function()
			arg0_6.enterFlag = false

			setActive(arg0_6.items, true)
			arg0_6:StopTimer()
		end, 0.396, 1)

		arg0_6.showTimer:Start()
	else
		arg0_6.enterFlag = true
	end
end

function var0_0.StopTimer(arg0_8)
	if arg0_8.showTimer then
		arg0_8.showTimer:Stop()

		arg0_8.showTimer = nil
	end
end

function var0_0.OnUpdateFlush(arg0_9)
	arg0_9.nday = arg0_9.activity.data1

	for iter0_9 = 1, arg0_9.activity.data1 do
		table.insert(arg0_9.playedAnimationList, iter0_9 - 1)
	end

	arg0_9.itemList:align(arg0_9.Day, arg0_9.enterFlag and 0.1 or 0)
	setText(arg0_9.bg:Find("items/Root/image_05/Text"), arg0_9.nday .. "/" .. arg0_9.Day)

	local var0_9 = arg0_9.activity:readyToAchieve()

	setActive(arg0_9.signRedTip, var0_9)
	setGray(arg0_9.signBtn, not var0_9)
end

function var0_0.OnDestroy(arg0_10)
	arg0_10:StopTimer()
	arg0_10.itemList:Dispose()
	var0_0.super.OnDestroy(arg0_10)
end

return var0_0
