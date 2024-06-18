local var0_0 = class("FeastGiveGiftPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "FeastGiveGiftPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.mask = arg0_2:findTF("mask")
	arg0_2.back = arg0_2:findTF("back")
	arg0_2.charContainer = arg0_2:findTF("char")
	arg0_2.charRect = arg0_2:findTF("char/rect")
	arg0_2.nameTxt = arg0_2:findTF("dialogue/name/Text"):GetComponent(typeof(Text))
	arg0_2.dialogueTxt = arg0_2:findTF("dialogue/Text"):GetComponent(typeof(Text))
	arg0_2.typer = arg0_2:findTF("dialogue/Text"):GetComponent(typeof(Typewriter))
	arg0_2.giftTr = arg0_2:findTF("dialogue/item/icon")
	arg0_2.effectTr = arg0_2:findTF("char/effect")
	arg0_2.giftTrPos = arg0_2.giftTr.localPosition
	arg0_2.tipTr = arg0_2:findTF("dialogue/tip"):GetComponent(typeof(Text))
end

function var0_0.BindEvents(arg0_3)
	arg0_3.eventId = arg0_3:bind(FeastScene.ON_GOT_GIFT, function(arg0_4, arg1_4)
		arg0_3:OnGotGift(arg1_4)
	end)
end

function var0_0.ClearBindEvents(arg0_5)
	if arg0_5.eventId then
		arg0_5:disconnect(arg0_5.eventId)

		arg0_5.eventId = nil
	end
end

function var0_0.OnGotGift(arg0_6, arg1_6)
	if arg0_6.feastShip then
		arg0_6:BlockEvents()
		setActive(arg0_6.effectTr, true)
		seriesAsync({
			function(arg0_7)
				arg0_6:UpdateGiftState(arg0_6.feastShip, arg0_7)
			end,
			function(arg0_8)
				onButton(arg0_6, arg0_6.mask, function()
					arg0_6:UnBlockEvents()
					arg0_8()
				end, SFX_PANEL)
			end,
			function(arg0_10)
				arg0_6:emit(BaseUI.ON_ACHIEVE, arg1_6, arg0_10)
			end,
			function(arg0_11)
				local var0_11 = arg0_6.feastShip:GetGiftStory()

				pg.NewStoryMgr.GetInstance():Play(var0_11, arg0_11)
			end
		}, function()
			setActive(arg0_6.effectTr, false)
			arg0_6:emit(FeastScene.ON_BACK_FEAST)
		end)
	end
end

function var0_0.Show(arg0_13, arg1_13)
	var0_0.super.Show(arg0_13)
	arg0_13:UnBlockEvents()
	setActive(arg0_13.effectTr, false)

	arg0_13.feastShip = arg1_13

	arg0_13:SetTipContent()
	seriesAsync({
		function(arg0_14)
			arg0_13:LoadChar(arg1_13, arg0_14)
		end,
		function(arg0_15)
			arg0_13.giftTr.localPosition = arg0_13.giftTrPos

			arg0_13:LoadItem(arg1_13, arg0_15)
		end
	}, function()
		arg0_13:BindEvents()
		arg0_13:UpdateShipName(arg1_13)
		arg0_13:UpdateGiftState(arg1_13)
		arg0_13:RegisterEvent()
	end)
end

function var0_0.SetTipContent(arg0_17)
	arg0_17.tipTr.text = i18n("feast_drag_gift_tip")
end

function var0_0.CanInterAction(arg0_18)
	return not isActive(arg0_18.mask)
end

function var0_0.BlockEvents(arg0_19)
	setActive(arg0_19.mask, true)
end

function var0_0.UnBlockEvents(arg0_20)
	setActive(arg0_20.mask, false)
	removeOnButton(arg0_20.mask)
end

function var0_0.RegisterEvent(arg0_21)
	onButton(arg0_21, arg0_21.back, function()
		arg0_21:Hide()
	end, SFX_PANEL)
end

local function var1_0(arg0_23, arg1_23)
	local var0_23 = pg.UIMgr.GetInstance().overlayCameraComp
	local var1_23 = arg0_23:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1_23, arg1_23, var0_23))
end

function var0_0.LoadChar(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg1_24:GetPrefab()

	PoolMgr.GetInstance():GetPrefab("feastChar/" .. var0_24, var0_24, true, function(arg0_25)
		if arg0_24.exited then
			PoolMgr.GetInstance():ReturnPrefab("feastChar/" .. var0_24, var0_24, arg0_25)

			return
		end

		arg0_25.transform:SetParent(arg0_24.charContainer)

		arg0_25.transform.localScale = Vector3(1, 1, 0)
		arg0_25.transform.localPosition = Vector3(0, 0, 0)

		local var0_25 = arg0_25:GetComponent(typeof(SpineAnimUI))

		arg0_24.loadedChar = {
			spineAnimUI = var0_25,
			name = var0_24
		}

		if arg2_24 then
			arg2_24()
		end
	end)
end

function var0_0.LoadItem(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg1_26:GetPrefab()

	LoadSpriteAsync("FeastCharGift/" .. var0_26, function(arg0_27)
		local var0_27 = arg0_26.giftTr:GetComponent(typeof(Image))

		var0_27.sprite = arg0_27

		var0_27:SetNativeSize()
		arg2_26()
	end)
end

function var0_0.UpdateShipName(arg0_28, arg1_28)
	arg0_28.nameTxt.text = arg1_28:GetShipName()
end

function var0_0.UpdateGiftState(arg0_29, arg1_29, arg2_29)
	arg0_29:ClearGiftEvent()
	parallelAsync({
		function(arg0_30)
			arg0_29:UpdateContent(arg1_29:GetDialogueForGift(), 4, arg0_30)
		end,
		function(arg0_31)
			local var0_31 = arg0_29.loadedChar.spineAnimUI

			if not arg1_29:GotGift() then
				setActive(arg0_29.giftTr, true)
				arg0_29:AddGiftEvent()
				var0_31:SetAction("activity_wait", 0)
			else
				setActive(arg0_29.giftTr, false)
				var0_31:SetActionCallBack(function(arg0_32)
					if arg0_32 == "finish" then
						var0_31:SetActionCallBack(nil)
						var0_31:SetAction("activity_wait", 0)
						arg0_31()
					end
				end)
				var0_31:SetAction("activity_getgift", 0)
			end
		end
	}, function()
		if arg2_29 then
			arg2_29()
		end
	end)
end

function var0_0.UpdateContent(arg0_34, arg1_34, arg2_34, arg3_34)
	local var0_34 = arg2_34 / System.String.New(arg1_34).Length

	arg0_34.typer:setSpeed(99999)

	arg0_34.dialogueTxt.text = arg1_34

	arg0_34.typer:setSpeed(var0_34)

	function arg0_34.typer.endFunc()
		if arg3_34 then
			arg3_34()
		end
	end

	arg0_34.typer:Play()
end

function var0_0.AddGiftEvent(arg0_36)
	local var0_36 = arg0_36.giftTr
	local var1_36 = GetOrAddComponent(var0_36, typeof(EventTriggerListener))
	local var2_36

	var1_36:AddBeginDragFunc(function()
		var0_36:SetAsLastSibling()

		var2_36 = var0_36.localPosition
	end)
	var1_36:AddDragFunc(function(arg0_38, arg1_38)
		local var0_38 = var1_0(var0_36.parent, arg1_38.position)

		var0_36.localPosition = var0_38
	end)
	var1_36:AddDragEndFunc(function(arg0_39, arg1_39)
		local var0_39 = arg0_36.charRect
		local var1_39 = getBounds(var0_39)
		local var2_39 = getBounds(var0_36)

		if var1_39:Intersects(var2_39) then
			arg0_36:Send()
		else
			var0_36.localPosition = arg0_36.giftTrPos
		end
	end)
end

function var0_0.ClearGiftEvent(arg0_40)
	local var0_40 = arg0_40.giftTr
	local var1_40 = GetOrAddComponent(var0_40, typeof(EventTriggerListener))

	var1_40:AddBeginDragFunc(nil)
	var1_40:AddDragFunc(nil)
	var1_40:AddDragEndFunc(nil)
	var1_40:RemoveBeginDragFunc()
	var1_40:RemoveDragFunc()
	var1_40:RemoveDragEndFunc()
end

function var0_0.Send(arg0_41)
	local var0_41 = arg0_41.feastShip

	arg0_41:emit(FeastMediator.GIVE_GIFT, var0_41.tid)
end

function var0_0.Hide(arg0_42)
	var0_0.super.Hide(arg0_42)
	arg0_42:ClearBindEvents()

	if arg0_42.loadedChar then
		arg0_42.loadedChar.spineAnimUI:SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnPrefab("feastChar/" .. arg0_42.loadedChar.name, arg0_42.loadedChar.name, arg0_42.loadedChar.spineAnimUI.gameObject)

		arg0_42.loadedChar = nil
	end

	arg0_42:ClearGiftEvent()
end

function var0_0.OnDestroy(arg0_43)
	return
end

return var0_0
