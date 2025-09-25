local var0_0 = class("ShopPaintingView")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._painting = arg1_1
	arg0_1._paintingInitPos = arg0_1._painting.anchoredPosition
	arg0_1._paintingOffsetMin = Vector2(arg0_1._painting.offsetMin.x, arg0_1._painting.offsetMin.y)
	arg0_1._paintingOffsetMax = Vector2(arg0_1._painting.offsetMax.x, arg0_1._painting.offsetMax.y)
	arg0_1.touch = arg0_1._painting:Find("paint_touch")
	arg0_1.chat = arg2_1
	arg0_1.chatText = arg0_1.chat:Find("Text")
	arg0_1.name = nil
	arg0_1.chatting = false
	arg0_1.chatTrOffset = Vector3(118, -276, 0)

	pg.DelegateInfo.New(arg0_1)
end

function var0_0.InitChatPosition(arg0_2)
	return
end

function var0_0.Init(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3)
	if not arg0_3.isInitChatPosition then
		arg0_3.isInitChatPosition = true

		arg0_3:InitChatPosition()
	end

	arg0_3:UnLoad()

	arg0_3.name = arg1_3

	if arg2_3 and arg0_3.secretaryTf then
		arg0_3._painting.anchoredPosition = arg0_3.secretaryTf.anchoredPosition
		arg0_3._painting.offsetMin = arg0_3.secretaryTf.offsetMin
		arg0_3._painting.offsetMax = arg0_3.secretaryTf.offsetMax
	else
		arg0_3._painting.anchoredPosition = arg0_3._paintingInitPos
		arg0_3._painting.offsetMin = arg0_3._paintingOffsetMin
		arg0_3._painting.offsetMax = arg0_3._paintingOffsetMax
	end

	arg0_3:Load(arg3_3, arg4_3)

	if arg5_3 then
		onButton(arg0_3, arg0_3.touch, function()
			arg5_3()
		end, SFX_PANEL)
	end
end

function var0_0.Load(arg0_5, arg1_5, arg2_5)
	local var0_5

	if arg0_5.name == "mingshi_live2d" then
		var0_5 = ShopMingShiPainting.New(arg0_5._painting)
	else
		var0_5 = ShopMeshPainting.New(arg0_5._painting)
	end

	arg0_5.iShopPainting = var0_5

	var0_5:Load(arg0_5.name, arg1_5, arg2_5)
end

function var0_0.setSecretaryPos(arg0_6, arg1_6)
	if arg1_6 then
		arg0_6.secretaryTf = arg1_6
	end
end

function var0_0.Chat(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	local var0_7 = 1

	if type(arg1_7) == "table" then
		var0_7 = math.random(1, #arg1_7)
		arg1_7 = arg1_7[var0_7]
	end

	if type(arg2_7) == "table" then
		arg2_7 = arg2_7[var0_7]
	end

	if type(arg3_7) == "table" then
		arg3_7 = arg3_7[var0_7]
	end

	local function var1_7()
		if arg1_7 then
			arg0_7:ShowShipWord(arg1_7)
		end

		if arg3_7 and arg0_7.iShopPainting then
			arg0_7.iShopPainting:Action(arg3_7)
		end
	end

	if not arg0_7.chatting or arg4_7 then
		arg0_7:StopChat()

		if arg2_7 then
			arg0_7:PlayCV(arg2_7, function(arg0_9)
				if arg0_9 then
					arg0_7._cueInfo = arg0_9.cueInfo
				end

				var1_7()
			end)
		else
			var1_7()
		end
	end
end

function var0_0.ShowShipWord(arg0_10, arg1_10)
	arg0_10.chatting = true

	if LeanTween.isTweening(go(arg0_10.chat)) then
		LeanTween.cancel(go(arg0_10.chat))
	end

	local var0_10 = 0.3
	local var1_10 = 3

	if arg0_10._cueInfo then
		local var2_10 = long2int(arg0_10._cueInfo.length) / 1000

		if var1_10 < var2_10 then
			var1_10 = var2_10
		end
	end

	setActive(arg0_10.chat, true)
	setText(arg0_10.chatText, arg1_10)
	LeanTween.scale(arg0_10.chat.gameObject, Vector3.New(1, 1, 1), var0_10):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		if IsNil(arg0_10.chat) then
			return
		end

		LeanTween.scale(arg0_10.chat.gameObject, Vector3.New(0, 0, 1), var0_10):setFrom(Vector3.New(1, 1, 1)):setEase(LeanTweenType.easeInBack):setDelay(var1_10):setOnComplete(System.Action(function()
			if IsNil(arg0_10.chat) then
				return
			end

			arg0_10:StopChat()
		end))
	end))
end

function var0_0.StopChat(arg0_13)
	arg0_13.chatting = nil

	if LeanTween.isTweening(go(arg0_13.chat)) then
		LeanTween.cancel(go(arg0_13.chat))
	end

	setActive(arg0_13.chat, false)
	arg0_13:StopCV()
end

local function var1_0(arg0_14, arg1_14)
	local var0_14
	local var1_14

	if string.find(arg1_14, "/") then
		local var2_14 = string.split(arg1_14, "/")

		var0_14 = var2_14[1]
		var1_14 = var2_14[2]
	elseif arg0_14.name == "mingshi_live2d" then
		var0_14 = "cv-chargeShop"
		var1_14 = arg1_14
	elseif string.find(arg1_14, "ryza_shop") then
		var0_14 = "cv-1090002"
		var1_14 = arg1_14
	elseif string.find(arg1_14, "atelier_yumia_shop") then
		var0_14 = "cv-1130002"
		var1_14 = arg1_14
	else
		var0_14 = "cv-shop"
		var1_14 = arg1_14
	end

	return var0_14, var1_14
end

function var0_0.PlayCV(arg0_15, arg1_15, arg2_15)
	local var0_15, var1_15 = var1_0(arg0_15, arg1_15)

	arg0_15:StopCV()
	pg.CriMgr.GetInstance():PlayCV_V3(var0_15, var1_15, arg2_15)

	arg0_15._currentVoice = var0_15
end

function var0_0.StopCV(arg0_16)
	if arg0_16._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_16._currentVoice)
	end

	arg0_16._currentVoice = nil
	arg0_16._cueInfo = nil
end

function var0_0.UnLoad(arg0_17)
	if arg0_17.iShopPainting and arg0_17.name then
		arg0_17.iShopPainting:UnLoad(arg0_17.name)

		arg0_17.name = nil
		arg0_17.iShopPainting = nil
	end
end

function var0_0.Show(arg0_18, arg1_18)
	if arg1_18 then
		setActive(arg0_18._painting, true)
	else
		setActive(arg0_18._painting, false)

		arg0_18.name = nil

		arg0_18:StopCV()
	end
end

function var0_0.Dispose(arg0_19)
	pg.DelegateInfo.Dispose(arg0_19)
	arg0_19:UnLoad()
	arg0_19:StopCV()
end

return var0_0
