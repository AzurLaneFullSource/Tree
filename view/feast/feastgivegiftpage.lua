local var0 = class("FeastGiveGiftPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "FeastGiveGiftPage"
end

function var0.OnLoaded(arg0)
	arg0.mask = arg0:findTF("mask")
	arg0.back = arg0:findTF("back")
	arg0.charContainer = arg0:findTF("char")
	arg0.charRect = arg0:findTF("char/rect")
	arg0.nameTxt = arg0:findTF("dialogue/name/Text"):GetComponent(typeof(Text))
	arg0.dialogueTxt = arg0:findTF("dialogue/Text"):GetComponent(typeof(Text))
	arg0.typer = arg0:findTF("dialogue/Text"):GetComponent(typeof(Typewriter))
	arg0.giftTr = arg0:findTF("dialogue/item/icon")
	arg0.effectTr = arg0:findTF("char/effect")
	arg0.giftTrPos = arg0.giftTr.localPosition
	arg0.tipTr = arg0:findTF("dialogue/tip"):GetComponent(typeof(Text))
end

function var0.BindEvents(arg0)
	arg0.eventId = arg0:bind(FeastScene.ON_GOT_GIFT, function(arg0, arg1)
		arg0:OnGotGift(arg1)
	end)
end

function var0.ClearBindEvents(arg0)
	if arg0.eventId then
		arg0:disconnect(arg0.eventId)

		arg0.eventId = nil
	end
end

function var0.OnGotGift(arg0, arg1)
	if arg0.feastShip then
		arg0:BlockEvents()
		setActive(arg0.effectTr, true)
		seriesAsync({
			function(arg0)
				arg0:UpdateGiftState(arg0.feastShip, arg0)
			end,
			function(arg0)
				onButton(arg0, arg0.mask, function()
					arg0:UnBlockEvents()
					arg0()
				end, SFX_PANEL)
			end,
			function(arg0)
				arg0:emit(BaseUI.ON_ACHIEVE, arg1, arg0)
			end,
			function(arg0)
				local var0 = arg0.feastShip:GetGiftStory()

				pg.NewStoryMgr.GetInstance():Play(var0, arg0)
			end
		}, function()
			setActive(arg0.effectTr, false)
			arg0:emit(FeastScene.ON_BACK_FEAST)
		end)
	end
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	arg0:UnBlockEvents()
	setActive(arg0.effectTr, false)

	arg0.feastShip = arg1

	arg0:SetTipContent()
	seriesAsync({
		function(arg0)
			arg0:LoadChar(arg1, arg0)
		end,
		function(arg0)
			arg0.giftTr.localPosition = arg0.giftTrPos

			arg0:LoadItem(arg1, arg0)
		end
	}, function()
		arg0:BindEvents()
		arg0:UpdateShipName(arg1)
		arg0:UpdateGiftState(arg1)
		arg0:RegisterEvent()
	end)
end

function var0.SetTipContent(arg0)
	arg0.tipTr.text = i18n("feast_drag_gift_tip")
end

function var0.CanInterAction(arg0)
	return not isActive(arg0.mask)
end

function var0.BlockEvents(arg0)
	setActive(arg0.mask, true)
end

function var0.UnBlockEvents(arg0)
	setActive(arg0.mask, false)
	removeOnButton(arg0.mask)
end

function var0.RegisterEvent(arg0)
	onButton(arg0, arg0.back, function()
		arg0:Hide()
	end, SFX_PANEL)
end

local function var1(arg0, arg1)
	local var0 = pg.UIMgr.GetInstance().overlayCameraComp
	local var1 = arg0:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1, arg1, var0))
end

function var0.LoadChar(arg0, arg1, arg2)
	local var0 = arg1:GetPrefab()

	PoolMgr.GetInstance():GetPrefab("feastChar/" .. var0, var0, true, function(arg0)
		if arg0.exited then
			PoolMgr.GetInstance():ReturnPrefab("feastChar/" .. var0, var0, arg0)

			return
		end

		arg0.transform:SetParent(arg0.charContainer)

		arg0.transform.localScale = Vector3(1, 1, 0)
		arg0.transform.localPosition = Vector3(0, 0, 0)

		local var0 = arg0:GetComponent(typeof(SpineAnimUI))

		arg0.loadedChar = {
			spineAnimUI = var0,
			name = var0
		}

		if arg2 then
			arg2()
		end
	end)
end

function var0.LoadItem(arg0, arg1, arg2)
	local var0 = arg1:GetPrefab()

	LoadSpriteAsync("FeastCharGift/" .. var0, function(arg0)
		local var0 = arg0.giftTr:GetComponent(typeof(Image))

		var0.sprite = arg0

		var0:SetNativeSize()
		arg2()
	end)
end

function var0.UpdateShipName(arg0, arg1)
	arg0.nameTxt.text = arg1:GetShipName()
end

function var0.UpdateGiftState(arg0, arg1, arg2)
	arg0:ClearGiftEvent()
	parallelAsync({
		function(arg0)
			arg0:UpdateContent(arg1:GetDialogueForGift(), 4, arg0)
		end,
		function(arg0)
			local var0 = arg0.loadedChar.spineAnimUI

			if not arg1:GotGift() then
				setActive(arg0.giftTr, true)
				arg0:AddGiftEvent()
				var0:SetAction("activity_wait", 0)
			else
				setActive(arg0.giftTr, false)
				var0:SetActionCallBack(function(arg0)
					if arg0 == "finish" then
						var0:SetActionCallBack(nil)
						var0:SetAction("activity_wait", 0)
						arg0()
					end
				end)
				var0:SetAction("activity_getgift", 0)
			end
		end
	}, function()
		if arg2 then
			arg2()
		end
	end)
end

function var0.UpdateContent(arg0, arg1, arg2, arg3)
	local var0 = arg2 / System.String.New(arg1).Length

	arg0.typer:setSpeed(99999)

	arg0.dialogueTxt.text = arg1

	arg0.typer:setSpeed(var0)

	function arg0.typer.endFunc()
		if arg3 then
			arg3()
		end
	end

	arg0.typer:Play()
end

function var0.AddGiftEvent(arg0)
	local var0 = arg0.giftTr
	local var1 = GetOrAddComponent(var0, typeof(EventTriggerListener))
	local var2

	var1:AddBeginDragFunc(function()
		var0:SetAsLastSibling()

		var2 = var0.localPosition
	end)
	var1:AddDragFunc(function(arg0, arg1)
		local var0 = var1(var0.parent, arg1.position)

		var0.localPosition = var0
	end)
	var1:AddDragEndFunc(function(arg0, arg1)
		local var0 = arg0.charRect
		local var1 = getBounds(var0)
		local var2 = getBounds(var0)

		if var1:Intersects(var2) then
			arg0:Send()
		else
			var0.localPosition = arg0.giftTrPos
		end
	end)
end

function var0.ClearGiftEvent(arg0)
	local var0 = arg0.giftTr
	local var1 = GetOrAddComponent(var0, typeof(EventTriggerListener))

	var1:AddBeginDragFunc(nil)
	var1:AddDragFunc(nil)
	var1:AddDragEndFunc(nil)
	var1:RemoveBeginDragFunc()
	var1:RemoveDragFunc()
	var1:RemoveDragEndFunc()
end

function var0.Send(arg0)
	local var0 = arg0.feastShip

	arg0:emit(FeastMediator.GIVE_GIFT, var0.tid)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	arg0:ClearBindEvents()

	if arg0.loadedChar then
		arg0.loadedChar.spineAnimUI:SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnPrefab("feastChar/" .. arg0.loadedChar.name, arg0.loadedChar.name, arg0.loadedChar.spineAnimUI.gameObject)

		arg0.loadedChar = nil
	end

	arg0:ClearGiftEvent()
end

function var0.OnDestroy(arg0)
	return
end

return var0
