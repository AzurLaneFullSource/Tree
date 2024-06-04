local var0 = class("SculptureGratitudePage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SculptureGratitudeUI"
end

function var0.OnLoaded(arg0)
	arg0.backBtn = arg0:findTF("back")
	arg0.roleImg = arg0:findTF("char/Image")
	arg0.container = arg0:findTF("frame/gift")
	arg0.awards = arg0:findTF("frame/awards")
	arg0.giftBg = arg0:findTF("frame/Image")
	arg0.wordTxtScr = arg0:findTF("frame/scrollrect")
	arg0.wordTxt = arg0:findTF("frame/scrollrect/content/Text"):GetComponent(typeof(Text))
	arg0.typer = arg0:findTF("frame/scrollrect/content/Text"):GetComponent(typeof(Typewriter))
	arg0.uilist = UIItemList.New(arg0:findTF("frame/awards"), arg0:findTF("frame/awards/tpl"))
	arg0.arrLeft = arg0:findTF("frame/arr")
	arg0.arrRight = arg0:findTF("frame/arr (1)")
end

function var0.OnInit(arg0)
	return
end

function var0.Show(arg0, arg1, arg2, arg3)
	arg0:Clear()
	setText(arg0:findTF("tip"), i18n("sculpture_gratitude_tip"))
	var0.super.Show(arg0)
	setActive(arg0.giftBg, true)
	setAnchoredPosition(arg0.arrLeft, {
		x = 338
	})
	setAnchoredPosition(arg0.arrRight, {
		x = 675
	})

	if arg3 then
		arg3()
	end

	arg0.id = arg1
	arg0.activity = arg2

	arg0:SetScrollTxt(arg2:getDataConfig(arg0.id, "words"))
	seriesAsync({
		function(arg0)
			arg0:LoadChar(arg0)
		end,
		function(arg0)
			arg0:LoadSculpture(arg0)
		end
	}, function()
		arg0:RegisterEvent()
	end)
	pg.BgmMgr.GetInstance():Push(arg0.__cname, "story-richang-8")
end

function var0.Flush(arg0, arg1)
	arg0.activity = arg1

	local var0 = arg0.activity:GetSculptureState(arg0.id)

	if var0 == SculptureActivity.STATE_FINSIH then
		arg0:Clear()

		local var1, var2, var3 = arg0:State2CharNameAndActionName(var0)

		arg0:UpdateRole(var1, var2, var3)
		setActive(arg0.container, false)
		setActive(arg0.awards, true)
		arg0:InitAwards()
		arg0:SetScrollTxt(arg1:getDataConfig(arg0.id, "thankwords"))
		setText(arg0:findTF("tip"), "")
		setActive(arg0.giftBg, false)
		setAnchoredPosition(arg0.arrLeft, {
			x = 260
		})
		setAnchoredPosition(arg0.arrRight, {
			x = 745
		})
	end
end

function var0.SetScrollTxt(arg0, arg1)
	arg0.typer:setSpeed(99999)

	arg0.wordTxt.text = HXSet.hxLan(arg1)

	arg0.typer:setSpeed(0.06)

	function arg0.typer.endFunc()
		arg0:RemoveTimer()
	end

	arg0.typer:Play()
	arg0:RemoveTimer()

	arg0.timer = Timer.New(function()
		scrollToBottom(arg0.wordTxtScr)
	end, 0.1, -1)

	arg0.timer:Start()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.InitAwards(arg0)
	local var0 = arg0.activity:getDataConfig(arg0.id, "reward_display")

	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2, var1)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
		end
	end)
	arg0.uilist:align(#var0)
end

function var0.LoadChar(arg0, arg1)
	local var0 = arg0.activity:GetSculptureState(arg0.id)
	local var1, var2, var3 = arg0:State2CharNameAndActionName(var0)

	arg0:UpdateRole(var1, var2, var3, arg1)
end

function var0.State2CharNameAndActionName(arg0, arg1)
	local var0 = arg0.activity:GetResorceName(arg0.id)

	if arg1 == SculptureActivity.STATE_FINSIH then
		return var0, "gift_get_", "take_wait_"
	else
		return var0, "gift_wait_"
	end
end

function var0.LoadSculpture(arg0, arg1)
	local var0 = arg0.activity:GetResorceName(arg0.id)

	ResourceMgr.Inst:getAssetAsync("ui/" .. var0 .. "_puzzle_whole", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		local var0 = Object.Instantiate(arg0, arg0.container)

		var0.transform.localScale = arg0.activity:GetScale(arg0.id)

		arg0:InitSculpture(var0.transform)

		arg0.puzzle = var0

		arg1()
	end), true, true)
end

function var0.InitSculpture(arg0, arg1)
	local var0 = GetOrAddComponent(arg1, typeof(EventTriggerListener))
	local var1

	var0:AddBeginDragFunc(function()
		arg1:SetAsLastSibling()

		var1 = arg1.localPosition
	end)
	var0:AddDragFunc(function(arg0, arg1)
		local var0 = Screen2Local(arg1.parent, arg1.position)

		arg1.localPosition = var0
	end)
	var0:AddDragEndFunc(function(arg0, arg1)
		local var0 = arg0.roleImg.gameObject.transform
		local var1 = getBounds(var0)
		local var2 = getBounds(arg1)

		if var1:Intersects(var2) then
			arg1.localPosition = TrPosition2LocalPos(var0.parent, arg1.parent, var0.localPosition)

			arg0:emit(SculptureMediator.ON_FINSIH_SCULPTURE, arg0.id)
		else
			arg1.localPosition = var1
		end
	end)
end

function var0.UpdateRole(arg0, arg1, arg2, arg3, arg4)
	if arg0.charName == arg1 then
		return
	end

	arg0:ClearChar()
	PoolMgr.GetInstance():GetSpineChar("takegift_" .. arg1, true, function(arg0)
		arg0.transform:SetParent(arg0.roleImg.gameObject.transform.parent)

		arg0.transform.localScale = Vector3(1, 1, 0)
		arg0.transform.localPosition = Vector3(0, 0, 0)

		local var0 = arg0:GetComponent(typeof(SpineAnimUI))

		var0:SetAction(arg2 .. arg1, 0)

		if arg3 then
			var0:SetActionCallBack(function(arg0)
				if arg0 == "finish" then
					var0:SetActionCallBack(nil)
					var0:SetAction(arg3 .. arg1, 0)
				end
			end)
		end

		arg0.spineAnimUI = var0
		arg0.charGo = arg0

		if arg4 then
			arg4()
		end
	end)

	arg0.charName = arg1
end

function var0.ClearChar(arg0)
	if arg0.charName and arg0.charGo then
		if arg0.spineAnimUI then
			arg0.spineAnimUI:SetActionCallBack(nil)

			arg0.spineAnimUI = nil
		end

		PoolMgr.GetInstance():ReturnSpineChar(arg0.charName, arg0.charGo)

		arg0.charName = nil
		arg0.charGo = nil
	end
end

function var0.RegisterEvent(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Clear(arg0)
	if arg0.puzzle then
		local var0 = arg0.puzzle:GetComponent(typeof(EventTriggerListener))

		ClearEventTrigger(var0)
		Object.Destroy(arg0.puzzle.gameObject)

		arg0.puzzle = nil
	end

	arg0:ClearChar()
	setActive(arg0.container, true)
	setActive(arg0.awards, false)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.BgmMgr.GetInstance():Pop(arg0.__cname)
	arg0:RemoveTimer()
end

function var0.OnDestroy(arg0)
	arg0:Clear()
end

return var0
