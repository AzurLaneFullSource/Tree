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
end

function var0_0.InitChatPosition(arg0_2)
	local var0_2 = arg0_2._painting.localPosition + arg0_2.chatTrOffset
	local var1_2 = arg0_2._painting.parent:TransformPoint(var0_2)
	local var2_2 = arg0_2.chat.parent:InverseTransformPoint(var1_2)

	arg0_2.chat.localPosition = Vector3(var2_2.x, var2_2.y, 0)
end

function var0_0.Init(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
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
end

function var0_0.Load(arg0_4, arg1_4, arg2_4)
	local var0_4

	if arg0_4.name == "mingshi_live2d" then
		var0_4 = ShopMingShiPainting.New(arg0_4._painting)
	else
		var0_4 = ShopMeshPainting.New(arg0_4._painting)
	end

	arg0_4.iShopPainting = var0_4

	var0_4:Load(arg0_4.name, arg1_4, arg2_4)
end

function var0_0.setSecretaryPos(arg0_5, arg1_5)
	if arg1_5 then
		arg0_5.secretaryTf = arg1_5
	end
end

function var0_0.Chat(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	local var0_6 = 1

	if type(arg1_6) == "table" then
		var0_6 = math.random(1, #arg1_6)
		arg1_6 = arg1_6[var0_6]
	end

	if type(arg2_6) == "table" then
		arg2_6 = arg2_6[var0_6]
	end

	if type(arg3_6) == "table" then
		arg3_6 = arg3_6[var0_6]
	end

	local function var1_6()
		if arg1_6 then
			arg0_6:ShowShipWord(arg1_6)
		end

		if arg3_6 and arg0_6.iShopPainting then
			arg0_6.iShopPainting:Action(arg3_6)
		end
	end

	if not arg0_6.chatting or arg4_6 then
		arg0_6:StopChat()

		if arg2_6 then
			arg0_6:PlayCV(arg2_6, function(arg0_8)
				if arg0_8 then
					arg0_6._cueInfo = arg0_8.cueInfo
				end

				var1_6()
			end)
		else
			var1_6()
		end
	end
end

function var0_0.ShowShipWord(arg0_9, arg1_9)
	arg0_9.chatting = true

	if LeanTween.isTweening(go(arg0_9.chat)) then
		LeanTween.cancel(go(arg0_9.chat))
	end

	local var0_9 = 0.3
	local var1_9 = 3

	if arg0_9._cueInfo then
		local var2_9 = long2int(arg0_9._cueInfo.length) / 1000

		if var1_9 < var2_9 then
			var1_9 = var2_9
		end
	end

	setActive(arg0_9.chat, true)
	setText(arg0_9.chatText, arg1_9)
	LeanTween.scale(arg0_9.chat.gameObject, Vector3.New(1, 1, 1), var0_9):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		if IsNil(arg0_9.chat) then
			return
		end

		LeanTween.scale(arg0_9.chat.gameObject, Vector3.New(0, 0, 1), var0_9):setFrom(Vector3.New(1, 1, 1)):setEase(LeanTweenType.easeInBack):setDelay(var1_9):setOnComplete(System.Action(function()
			if IsNil(arg0_9.chat) then
				return
			end

			arg0_9:StopChat()
		end))
	end))
end

function var0_0.StopChat(arg0_12)
	arg0_12.chatting = nil

	if LeanTween.isTweening(go(arg0_12.chat)) then
		LeanTween.cancel(go(arg0_12.chat))
	end

	setActive(arg0_12.chat, false)
	arg0_12:StopCV()
end

local function var1_0(arg0_13, arg1_13)
	local var0_13
	local var1_13

	if string.find(arg1_13, "/") then
		local var2_13 = string.split(arg1_13, "/")

		var0_13 = var2_13[1]
		var1_13 = var2_13[2]
	elseif arg0_13.name == "mingshi_live2d" then
		var0_13 = "cv-chargeShop"
		var1_13 = arg1_13
	elseif string.find(arg1_13, "ryza_shop") then
		var0_13 = "cv-1090002"
		var1_13 = arg1_13
	else
		var0_13 = "cv-shop"
		var1_13 = arg1_13
	end

	return var0_13, var1_13
end

function var0_0.PlayCV(arg0_14, arg1_14, arg2_14)
	local var0_14, var1_14 = var1_0(arg0_14, arg1_14)

	arg0_14:StopCV()
	pg.CriMgr.GetInstance():PlayCV_V3(var0_14, var1_14, arg2_14)

	arg0_14._currentVoice = var0_14
end

function var0_0.StopCV(arg0_15)
	if arg0_15._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_15._currentVoice)
	end

	arg0_15._currentVoice = nil
	arg0_15._cueInfo = nil
end

function var0_0.UnLoad(arg0_16)
	if arg0_16.iShopPainting and arg0_16.name then
		arg0_16.iShopPainting:UnLoad(arg0_16.name)

		arg0_16.name = nil
		arg0_16.iShopPainting = nil
	end
end

function var0_0.Dispose(arg0_17)
	arg0_17:UnLoad()
	arg0_17:StopCV()
end

return var0_0
