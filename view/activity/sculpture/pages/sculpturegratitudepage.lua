local var0_0 = class("SculptureGratitudePage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SculptureGratitudeUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("back")
	arg0_2.roleImg = arg0_2:findTF("char/Image")
	arg0_2.container = arg0_2:findTF("frame/gift")
	arg0_2.awards = arg0_2:findTF("frame/awards")
	arg0_2.giftBg = arg0_2:findTF("frame/Image")
	arg0_2.wordTxtScr = arg0_2:findTF("frame/scrollrect")
	arg0_2.wordTxt = arg0_2:findTF("frame/scrollrect/content/Text"):GetComponent(typeof(Text))
	arg0_2.typer = arg0_2:findTF("frame/scrollrect/content/Text"):GetComponent(typeof(Typewriter))
	arg0_2.uilist = UIItemList.New(arg0_2:findTF("frame/awards"), arg0_2:findTF("frame/awards/tpl"))
	arg0_2.arrLeft = arg0_2:findTF("frame/arr")
	arg0_2.arrRight = arg0_2:findTF("frame/arr (1)")
end

function var0_0.OnInit(arg0_3)
	return
end

function var0_0.Show(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4:Clear()
	setText(arg0_4:findTF("tip"), i18n("sculpture_gratitude_tip"))
	var0_0.super.Show(arg0_4)
	setActive(arg0_4.giftBg, true)
	setAnchoredPosition(arg0_4.arrLeft, {
		x = 338
	})
	setAnchoredPosition(arg0_4.arrRight, {
		x = 675
	})

	if arg3_4 then
		arg3_4()
	end

	arg0_4.id = arg1_4
	arg0_4.activity = arg2_4

	arg0_4:SetScrollTxt(arg2_4:getDataConfig(arg0_4.id, "words"))
	seriesAsync({
		function(arg0_5)
			arg0_4:LoadChar(arg0_5)
		end,
		function(arg0_6)
			arg0_4:LoadSculpture(arg0_6)
		end
	}, function()
		arg0_4:RegisterEvent()
	end)
	pg.BgmMgr.GetInstance():Push(arg0_4.__cname, "story-richang-8")
end

function var0_0.Flush(arg0_8, arg1_8)
	arg0_8.activity = arg1_8

	local var0_8 = arg0_8.activity:GetSculptureState(arg0_8.id)

	if var0_8 == SculptureActivity.STATE_FINSIH then
		arg0_8:Clear()

		local var1_8, var2_8, var3_8 = arg0_8:State2CharNameAndActionName(var0_8)

		arg0_8:UpdateRole(var1_8, var2_8, var3_8)
		setActive(arg0_8.container, false)
		setActive(arg0_8.awards, true)
		arg0_8:InitAwards()
		arg0_8:SetScrollTxt(arg1_8:getDataConfig(arg0_8.id, "thankwords"))
		setText(arg0_8:findTF("tip"), "")
		setActive(arg0_8.giftBg, false)
		setAnchoredPosition(arg0_8.arrLeft, {
			x = 260
		})
		setAnchoredPosition(arg0_8.arrRight, {
			x = 745
		})
	end
end

function var0_0.SetScrollTxt(arg0_9, arg1_9)
	arg0_9.typer:setSpeed(99999)

	arg0_9.wordTxt.text = HXSet.hxLan(arg1_9)

	arg0_9.typer:setSpeed(0.06)

	function arg0_9.typer.endFunc()
		arg0_9:RemoveTimer()
	end

	arg0_9.typer:Play()
	arg0_9:RemoveTimer()

	arg0_9.timer = Timer.New(function()
		scrollToBottom(arg0_9.wordTxtScr)
	end, 0.1, -1)

	arg0_9.timer:Start()
end

function var0_0.RemoveTimer(arg0_12)
	if arg0_12.timer then
		arg0_12.timer:Stop()

		arg0_12.timer = nil
	end
end

function var0_0.InitAwards(arg0_13)
	local var0_13 = arg0_13.activity:getDataConfig(arg0_13.id, "reward_display")

	arg0_13.uilist:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var0_13[arg1_14 + 1]
			local var1_14 = {
				type = var0_14[1],
				id = var0_14[2],
				count = var0_14[3]
			}

			updateDrop(arg2_14, var1_14)
			onButton(arg0_13, arg2_14, function()
				arg0_13:emit(BaseUI.ON_DROP, var1_14)
			end, SFX_PANEL)
		end
	end)
	arg0_13.uilist:align(#var0_13)
end

function var0_0.LoadChar(arg0_16, arg1_16)
	local var0_16 = arg0_16.activity:GetSculptureState(arg0_16.id)
	local var1_16, var2_16, var3_16 = arg0_16:State2CharNameAndActionName(var0_16)

	arg0_16:UpdateRole(var1_16, var2_16, var3_16, arg1_16)
end

function var0_0.State2CharNameAndActionName(arg0_17, arg1_17)
	local var0_17 = arg0_17.activity:GetResorceName(arg0_17.id)

	if arg1_17 == SculptureActivity.STATE_FINSIH then
		return var0_17, "gift_get_", "take_wait_"
	else
		return var0_17, "gift_wait_"
	end
end

function var0_0.LoadSculpture(arg0_18, arg1_18)
	local var0_18 = arg0_18.activity:GetResorceName(arg0_18.id)

	ResourceMgr.Inst:getAssetAsync("ui/" .. var0_18 .. "_puzzle_whole", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_19)
		local var0_19 = Object.Instantiate(arg0_19, arg0_18.container)

		var0_19.transform.localScale = arg0_18.activity:GetScale(arg0_18.id)

		arg0_18:InitSculpture(var0_19.transform)

		arg0_18.puzzle = var0_19

		arg1_18()
	end), true, true)
end

function var0_0.InitSculpture(arg0_20, arg1_20)
	local var0_20 = GetOrAddComponent(arg1_20, typeof(EventTriggerListener))
	local var1_20

	var0_20:AddBeginDragFunc(function()
		arg1_20:SetAsLastSibling()

		var1_20 = arg1_20.localPosition
	end)
	var0_20:AddDragFunc(function(arg0_22, arg1_22)
		local var0_22 = Screen2Local(arg1_20.parent, arg1_22.position)

		arg1_20.localPosition = var0_22
	end)
	var0_20:AddDragEndFunc(function(arg0_23, arg1_23)
		local var0_23 = arg0_20.roleImg.gameObject.transform
		local var1_23 = getBounds(var0_23)
		local var2_23 = getBounds(arg1_20)

		if var1_23:Intersects(var2_23) then
			arg1_20.localPosition = TrPosition2LocalPos(var0_23.parent, arg1_20.parent, var0_23.localPosition)

			arg0_20:emit(SculptureMediator.ON_FINSIH_SCULPTURE, arg0_20.id)
		else
			arg1_20.localPosition = var1_20
		end
	end)
end

function var0_0.UpdateRole(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24)
	if arg0_24.charName == arg1_24 then
		return
	end

	arg0_24:ClearChar()
	PoolMgr.GetInstance():GetSpineChar("takegift_" .. arg1_24, true, function(arg0_25)
		arg0_25.transform:SetParent(arg0_24.roleImg.gameObject.transform.parent)

		arg0_25.transform.localScale = Vector3(1, 1, 0)
		arg0_25.transform.localPosition = Vector3(0, 0, 0)

		local var0_25 = arg0_25:GetComponent(typeof(SpineAnimUI))

		var0_25:SetAction(arg2_24 .. arg1_24, 0)

		if arg3_24 then
			var0_25:SetActionCallBack(function(arg0_26)
				if arg0_26 == "finish" then
					var0_25:SetActionCallBack(nil)
					var0_25:SetAction(arg3_24 .. arg1_24, 0)
				end
			end)
		end

		arg0_24.spineAnimUI = var0_25
		arg0_24.charGo = arg0_25

		if arg4_24 then
			arg4_24()
		end
	end)

	arg0_24.charName = arg1_24
end

function var0_0.ClearChar(arg0_27)
	if arg0_27.charName and arg0_27.charGo then
		if arg0_27.spineAnimUI then
			arg0_27.spineAnimUI:SetActionCallBack(nil)

			arg0_27.spineAnimUI = nil
		end

		PoolMgr.GetInstance():ReturnSpineChar(arg0_27.charName, arg0_27.charGo)

		arg0_27.charName = nil
		arg0_27.charGo = nil
	end
end

function var0_0.RegisterEvent(arg0_28)
	onButton(arg0_28, arg0_28.backBtn, function()
		arg0_28:Hide()
	end, SFX_PANEL)
end

function var0_0.Clear(arg0_30)
	if arg0_30.puzzle then
		local var0_30 = arg0_30.puzzle:GetComponent(typeof(EventTriggerListener))

		ClearEventTrigger(var0_30)
		Object.Destroy(arg0_30.puzzle.gameObject)

		arg0_30.puzzle = nil
	end

	arg0_30:ClearChar()
	setActive(arg0_30.container, true)
	setActive(arg0_30.awards, false)
end

function var0_0.Hide(arg0_31)
	var0_0.super.Hide(arg0_31)
	pg.BgmMgr.GetInstance():Pop(arg0_31.__cname)
	arg0_31:RemoveTimer()
end

function var0_0.OnDestroy(arg0_32)
	arg0_32:Clear()
end

return var0_0
